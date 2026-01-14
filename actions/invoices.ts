'use server';

import prisma from '@/lib/prisma';

export async function getInvoicesByModality(
  modalityId: string,
  filters?: { status?: string; startDate?: Date; endDate?: Date }
) {
  try {
    const whereClause: {
      invoiceLines: { some: { invoice: object } };
      status?: string;
      invoiceDate?: { gte?: Date; lte?: Date };
    } = {
      invoiceLines: {
        some: {
          invoice: {
            // Filtrar por servicios de esta modalidad (necesitamos vincular service -> admission -> modality)
          }
        }
      },
    };

    if (filters?.status) {
      whereClause.status = filters.status;
    }
    
    if (filters?.startDate || filters?.endDate) {
      whereClause.invoiceDate = {};
      if (filters.startDate) {
        whereClause.invoiceDate.gte = filters.startDate;
      }
      if (filters.endDate) {
        whereClause.invoiceDate.lte = filters.endDate;
      }
    }

    const invoices = await prisma.invoice.findMany({
      where: whereClause as any, // eslint-disable-line @typescript-eslint/no-explicit-any
      include: {
        healthInsurance: true,
        device: true,
        lines: {
          include: {
            service: true,
          },
        },
      },
      orderBy: { invoiceDate: 'desc' },
    });

    return { success: true, data: invoices };
  } catch (error) {
    console.error('Error fetching invoices:', error);
    return { success: false, error: 'Error al obtener facturas' };
  }
}

export async function getInvoiceById(invoiceId: string) {
  try {
    const invoice = await prisma.invoice.findUnique({
      where: { id: invoiceId },
      include: {
        company: true,
        healthInsurance: true,
        device: true,
        lines: {
          include: {
            service: {
              include: {
                admission: {
                  include: {
                    patient: true,
                    modality: true,
                  },
                },
                professional: true,
              },
            },
          },
        },
      },
    });

    if (!invoice) {
      return { success: false, error: 'Factura no encontrada' };
    }

    return { success: true, data: invoice };
  } catch (error) {
    console.error('Error fetching invoice:', error);
    return { success: false, error: 'Error al obtener factura' };
  }
}

export async function getInvoiceStats(companyId: string, deviceId?: string) {
  try {
    const whereClause = {
      companyId,
      ...(deviceId && { deviceId }),
    };

    const [total, paid, pending] = await Promise.all([
      prisma.invoice.aggregate({
        where: whereClause,
        _sum: { totalAmount: true },
      }),
      prisma.invoice.aggregate({
        where: { ...whereClause, status: 'PAID' },
        _sum: { totalAmount: true },
      }),
      prisma.invoice.aggregate({
        where: { ...whereClause, status: { in: ['ISSUED', 'PRESENTED'] } },
        _sum: { totalAmount: true },
      }),
    ]);

    return {
      success: true,
      data: {
        totalBilled: total._sum.totalAmount || 0,
        totalPaid: paid._sum.totalAmount || 0,
        totalPending: pending._sum.totalAmount || 0,
        percentCollected: total._sum.totalAmount
          ? Math.round((Number(paid._sum.totalAmount || 0) / Number(total._sum.totalAmount)) * 100)
          : 0,
      },
    };
  } catch (error) {
    console.error('Error fetching invoice stats:', error);
    return { success: false, error: 'Error al obtener estadísticas' };
  }
}
