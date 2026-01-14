'use server';

import prisma from '@/lib/prisma';

/**
 * Calcula métricas agregadas por compañía
 */
export async function getCompanyMetrics(companyId: string, periodStart?: Date, periodEnd?: Date) {
  try {
    const whereDate = periodStart && periodEnd 
      ? { gte: periodStart, lte: periodEnd }
      : undefined;

    // Total facturado en el periodo
    const facturado = await prisma.invoice.aggregate({
      where: {
        companyId,
        ...(whereDate && { invoiceDate: whereDate }),
      },
      _sum: { totalAmount: true },
      _count: true,
    });

    // Capacidad total y ocupación
    const devices = await prisma.device.findMany({
      where: {
        businessArea: { companyId },
        active: true,
      },
      select: {
        capacity: true,
        _count: {
          select: {
            admissions: {
              where: { status: 'ACTIVE' },
            },
          },
        },
      },
    });

    const totalCapacity = devices.reduce((sum: number, d: typeof devices[0]) => sum + (d.capacity || 0), 0);
    const totalOccupied = devices.reduce((sum: number, d: typeof devices[0]) => sum + d._count.admissions, 0);
    const occupancyRate = totalCapacity > 0 ? (totalOccupied / totalCapacity) * 100 : 0;

    // Honorarios pendientes
    const honorariosPendientes = await prisma.professionalFee.aggregate({
      where: {
        service: {
          admission: {
            device: {
              businessArea: { companyId },
            },
          },
        },
        status: 'PENDING',
      },
      _sum: { amount: true },
      _count: true,
    });

    // Días promedio de cobro (facturas pagadas)
    const invoicesPagadas = await prisma.invoice.findMany({
      where: {
        companyId,
        status: 'PAID',
        paymentDate: { not: null },
      },
      select: {
        invoiceDate: true,
        paymentDate: true,
      },
    });

    const diasPromedio = invoicesPagadas.length > 0
      ? invoicesPagadas.reduce((sum: number, inv: typeof invoicesPagadas[0]) => {
          const dias = Math.ceil(
            (new Date(inv.paymentDate!).getTime() - new Date(inv.invoiceDate).getTime()) /
            (1000 * 60 * 60 * 24)
          );
          return sum + dias;
        }, 0) / invoicesPagadas.length
      : 0;

    return {
      success: true,
      data: {
        totalFacturado: Number(facturado._sum.totalAmount || 0),
        cantidadFacturas: facturado._count,
        ocupacion: {
          rate: Math.round(occupancyRate * 10) / 10,
          occupied: totalOccupied,
          capacity: totalCapacity,
        },
        honorariosPendientes: {
          total: Number(honorariosPendientes._sum.amount || 0),
          cantidad: honorariosPendientes._count,
        },
        diasPromedioCobro: Math.round(diasPromedio),
      },
    };
  } catch (error) {
    console.error('Error fetching company metrics:', error);
    return { success: false, error: 'Error al calcular métricas de la empresa' };
  }
}

/**
 * Calcula métricas por área de negocio
 */
export async function getBusinessAreaMetrics(areaId: string, periodStart?: Date, periodEnd?: Date) {
  try {
    const whereDate = periodStart && periodEnd 
      ? { gte: periodStart, lte: periodEnd }
      : undefined;

    // Facturado del área
    const facturado = await prisma.invoice.aggregate({
      where: {
        device: { businessAreaId: areaId },
        ...(whereDate && { invoiceDate: whereDate }),
      },
      _sum: { totalAmount: true },
    });

    // Ocupación del área
    const devices = await prisma.device.findMany({
      where: {
        businessAreaId: areaId,
        active: true,
      },
      select: {
        capacity: true,
        _count: {
          select: {
            admissions: {
              where: { status: 'ACTIVE' },
            },
          },
        },
      },
    });

    const totalCapacity = devices.reduce((sum: number, d: typeof devices[0]) => sum + (d.capacity || 0), 0);
    const totalOccupied = devices.reduce((sum: number, d: typeof devices[0]) => sum + d._count.admissions, 0);
    const occupancyRate = totalCapacity > 0 ? (totalOccupied / totalCapacity) * 100 : 0;

    // Honorarios pendientes del área
    const honorarios = await prisma.professionalFee.aggregate({
      where: {
        service: {
          admission: {
            device: { businessAreaId: areaId },
          },
        },
        status: 'PENDING',
      },
      _sum: { amount: true },
    });

    return {
      success: true,
      data: {
        facturado: Number(facturado._sum.totalAmount || 0),
        ocupacion: {
          rate: Math.round(occupancyRate * 10) / 10,
          occupied: totalOccupied,
          capacity: totalCapacity,
        },
        honorariosPendientes: Number(honorarios._sum.amount || 0),
      },
    };
  } catch (error) {
    console.error('Error fetching area metrics:', error);
    return { success: false, error: 'Error al calcular métricas del área' };
  }
}

/**
 * Obtiene facturación por obra social (para gráficos)
 */
export async function getInvoicesByInsurance(areaId: string, periodStart?: Date, periodEnd?: Date) {
  try {
    const whereDate = periodStart && periodEnd 
      ? { gte: periodStart, lte: periodEnd }
      : undefined;

    const invoices = await prisma.invoice.groupBy({
      by: ['healthInsuranceId'],
      where: {
        device: { businessAreaId: areaId },
        ...(whereDate && { invoiceDate: whereDate }),
      },
      _sum: {
        totalAmount: true,
      },
      _count: true,
    });

    // Obtener nombres de obras sociales
    const insuranceIds = invoices.map((inv: typeof invoices[0]) => inv.healthInsuranceId).filter((id: string | null): id is string => id !== null);
    const insurances = await prisma.healthInsurance.findMany({
      where: { id: { in: insuranceIds } },
      select: { id: true, name: true },
    });

    const insuranceMap = new Map(insurances.map((ins: typeof insurances[0]) => [ins.id, ins.name]));

    const chartData = invoices.map((inv: typeof invoices[0]) => ({
      name: inv.healthInsuranceId ? insuranceMap.get(inv.healthInsuranceId) || 'Desconocida' : 'Sin Obra Social',
      value: Number(inv._sum.totalAmount || 0),
      count: inv._count,
    }));

    return { success: true, data: chartData };
  } catch (error) {
    console.error('Error fetching invoices by insurance:', error);
    return { success: false, error: 'Error al obtener facturación por obra social' };
  }
}

/**
 * Obtiene facturación mensual (últimos 6 meses)
 */
export async function getMonthlyRevenue(companyId: string, months: number = 6) {
  try {
    const today = new Date();
    const startDate = new Date(today.getFullYear(), today.getMonth() - months, 1);

    const invoices = await prisma.invoice.findMany({
      where: {
        companyId,
        invoiceDate: { gte: startDate },
      },
      select: {
        invoiceDate: true,
        totalAmount: true,
        device: {
          select: {
            businessArea: {
              select: {
                name: true,
              },
            },
          },
        },
      },
      orderBy: {
        invoiceDate: 'asc',
      },
    });

    // Agrupar por mes y área
    const monthlyData = new Map<string, Record<string, number>>();

    invoices.forEach((inv: typeof invoices[0]) => {
      const month = new Date(inv.invoiceDate).toLocaleDateString('es-AR', { 
        year: 'numeric', 
        month: 'short' 
      });
      const areaName = inv.device.businessArea.name;
      const amount = Number(inv.totalAmount);

      if (!monthlyData.has(month)) {
        monthlyData.set(month, {});
      }

      const monthData = monthlyData.get(month)!;
      monthData[areaName] = (monthData[areaName] || 0) + amount;
    });

    // Convertir a array para Tremor
    const chartData = Array.from(monthlyData.entries()).map(([month, areas]) => ({
      month,
      ...areas,
    }));

    // Obtener nombres únicos de áreas para categories
    const areaNames = Array.from(
      new Set(invoices.map((inv: typeof invoices[0]) => inv.device.businessArea.name))
    );

    return { 
      success: true, 
      data: {
        chartData,
        categories: areaNames,
      },
    };
  } catch (error) {
    console.error('Error fetching monthly revenue:', error);
    return { success: false, error: 'Error al obtener ingresos mensuales' };
  }
}

/**
 * Obtiene estadísticas de pacientes por modalidad
 */
export async function getModalityStats(modalityId: string) {
  try {
    // Total pacientes activos
    const totalActivos = await prisma.admission.count({
      where: {
        modalityId,
        status: 'ACTIVE',
      },
    });

    // Promedio días de estadía
    const admissions = await prisma.admission.findMany({
      where: {
        modalityId,
        status: 'ACTIVE',
      },
      select: {
        admissionDate: true,
      },
    });

    const avgDays = admissions.length > 0
      ? admissions.reduce((sum: number, adm: typeof admissions[0]) => {
          const days = Math.ceil(
            (new Date().getTime() - new Date(adm.admissionDate).getTime()) /
            (1000 * 60 * 60 * 24)
          );
          return sum + days;
        }, 0) / admissions.length
      : 0;

    // Autorizaciones por vencer (próximos 15 días)
    const today = new Date();
    const futureDate = new Date();
    futureDate.setDate(today.getDate() + 15);

    const authsExpiring = await prisma.authorization.count({
      where: {
        admission: {
          modalityId,
          status: 'ACTIVE',
        },
        status: 'ACTIVE',
        validTo: {
          gte: today,
          lte: futureDate,
        },
      },
    });

    return {
      success: true,
      data: {
        totalActivos,
        promedioEstadia: Math.round(avgDays),
        autorizacionesPorVencer: authsExpiring,
      },
    };
  } catch (error) {
    console.error('Error fetching modality stats:', error);
    return { success: false, error: 'Error al obtener estadísticas de modalidad' };
  }
}

/**
 * Obtiene distribución de estados de facturas (para gráficos)
 */
export async function getInvoiceStatusDistribution(modalityId: string) {
  try {
    // Obtener todas las admisiones de esta modalidad
    const admissions = await prisma.admission.findMany({
      where: { modalityId },
      select: { id: true },
    });

    const admissionIds = admissions.map((a: typeof admissions[0]) => a.id);

    // Agrupar facturas por estado
    const invoicesByStatus = await prisma.invoice.groupBy({
      by: ['status'],
      where: {
        lines: {
          some: {
            admissionId: { in: admissionIds },
          },
        },
      },
      _sum: {
        totalAmount: true,
      },
      _count: true,
    });

    const statusLabels: Record<string, string> = {
      DRAFT: 'Borrador',
      ISSUED: 'Emitida',
      PRESENTED: 'Presentada',
      PAID: 'Pagada',
      REJECTED: 'Rechazada',
      PARTIALLY_PAID: 'Pago Parcial',
    };

    const chartData = invoicesByStatus.map((item: typeof invoicesByStatus[0]) => ({
      name: statusLabels[item.status] || item.status,
      value: Number(item._sum.totalAmount || 0),
      count: item._count,
    }));

    return { success: true, data: chartData };
  } catch (error) {
    console.error('Error fetching invoice status distribution:', error);
    return { success: false, error: 'Error al obtener distribución de facturas' };
  }
}
