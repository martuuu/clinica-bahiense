'use server';

import prisma from '@/lib/prisma';

export async function getCompanies() {
  try {
    const companies = await prisma.company.findMany({
      where: { active: true },
      orderBy: { name: 'asc' },
      select: {
        id: true,
        name: true,
        code: true,
        active: true,
      },
    });
    
    return { success: true, data: companies };
  } catch (error) {
    console.error('Error fetching companies:', error);
    return { success: false, error: 'Error al obtener empresas' };
  }
}

export async function getCompanyById(id: string) {
  try {
    const company = await prisma.company.findUnique({
      where: { id },
      include: {
        businessAreas: {
          where: { active: true },
          orderBy: { name: 'asc' },
        },
      },
    });
    
    if (!company) {
      return { success: false, error: 'Empresa no encontrada' };
    }
    
    return { success: true, data: company };
  } catch (error) {
    console.error('Error fetching company:', error);
    return { success: false, error: 'Error al obtener empresa' };
  }
}
