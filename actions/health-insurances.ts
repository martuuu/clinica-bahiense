'use server';

import prisma from '@/lib/prisma';

export async function getHealthInsurances() {
  try {
    const insurances = await prisma.healthInsurance.findMany({
      where: { active: true },
      orderBy: { name: 'asc' },
      select: {
        id: true,
        name: true,
        code: true,
        type: true,
        paymentTermDays: true,
        active: true,
      },
    });
    
    return { success: true, data: insurances };
  } catch (error) {
    console.error('Error fetching health insurances:', error);
    return { success: false, error: 'Error al obtener obras sociales' };
  }
}

export async function getInsurancesByDevice(deviceId: string) {
  try {
    const insurances = await prisma.healthInsurance.findMany({
      where: {
        active: true,
        agreements: {
          some: {
            deviceId,
            active: true,
          },
        },
      },
      include: {
        agreements: {
          where: {
            deviceId,
            active: true,
          },
          include: {
            modalities: {
              orderBy: { name: 'asc' },
            },
          },
        },
      },
      orderBy: { name: 'asc' },
    });
    
    return { success: true, data: insurances };
  } catch (error) {
    console.error('Error fetching insurances by device:', error);
    return { success: false, error: 'Error al obtener obras sociales' };
  }
}

export async function getHealthInsuranceById(id: string) {
  try {
    const insurance = await prisma.healthInsurance.findUnique({
      where: { id },
      include: {
        agreements: {
          where: { active: true },
          include: {
            device: {
              include: {
                businessArea: {
                  include: {
                    company: true,
                  },
                },
              },
            },
          },
        },
      },
    });
    
    if (!insurance) {
      return { success: false, error: 'Obra social no encontrada' };
    }
    
    return { success: true, data: insurance };
  } catch (error) {
    console.error('Error fetching health insurance:', error);
    return { success: false, error: 'Error al obtener obra social' };
  }
}

export async function getModalitiesByInsuranceAndDevice(insuranceId: string, deviceId: string) {
  try {
    // Buscar convenio activo
    const agreement = await prisma.agreement.findFirst({
      where: {
        healthInsuranceId: insuranceId,
        deviceId: deviceId,
        active: true,
        OR: [
          { validTo: null },
          { validTo: { gte: new Date() } }
        ]
      },
      include: {
        modalities: {
          orderBy: { name: 'asc' },
          include: {
            _count: {
              select: {
                admissions: {
                  where: { status: 'ACTIVE' }
                }
              }
            }
          }
        },
        healthInsurance: true,
      },
    });
    
    if (!agreement) {
      return { success: false, error: 'No se encontró convenio activo' };
    }
    
    return { success: true, data: agreement };
  } catch (error) {
    console.error('Error fetching modalities:', error);
    return { success: false, error: 'Error al obtener modalidades' };
  }
}
