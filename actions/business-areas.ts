'use server';

import prisma from '@/lib/prisma';

export async function getBusinessAreasByCompany(companyId: string) {
  try {
    const areas = await prisma.businessArea.findMany({
      where: { 
        companyId, 
        active: true 
      },
      orderBy: { name: 'asc' },
      select: {
        id: true,
        name: true,
        code: true,
        billingSystem: true,
        active: true,
      },
    });
    
    return { success: true, data: areas };
  } catch (error) {
    console.error('Error fetching business areas:', error);
    return { success: false, error: 'Error al obtener áreas de negocio' };
  }
}

export async function getBusinessAreaById(areaId: string) {
  try {
    const area = await prisma.businessArea.findUnique({
      where: { id: areaId },
      include: {
        company: {
          select: {
            id: true,
            name: true,
            code: true,
          },
        },
        devices: {
          where: { active: true },
          orderBy: { name: 'asc' },
        },
      },
    });
    
    if (!area) {
      return { success: false, error: 'Área de negocio no encontrada' };
    }
    
    return { success: true, data: area };
  } catch (error) {
    console.error('Error fetching business area:', error);
    return { success: false, error: 'Error al obtener área de negocio' };
  }
}
