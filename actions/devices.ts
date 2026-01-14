'use server';

import prisma from '@/lib/prisma';

type DeviceWithCount = {
  id: string;
  name: string;
  code: string;
  type: string;
  capacity: number | null;
  active: boolean;
  _count: {
    admissions: number;
  };
};

export async function getDevicesByArea(areaId: string) {
  try {
    const devices = await prisma.device.findMany({
      where: { 
        businessAreaId: areaId, 
        active: true 
      },
      orderBy: { name: 'asc' },
      select: {
        id: true,
        name: true,
        code: true,
        type: true,
        capacity: true,
        active: true,
        _count: {
          select: {
            admissions: {
              where: { status: 'ACTIVE' }
            }
          }
        }
      },
    });
    
    // Calcular ocupación
    const devicesWithOccupancy = devices.map((device: DeviceWithCount) => ({
      ...device,
      occupied: device._count.admissions,
      occupancyRate: device.capacity 
        ? Math.round((device._count.admissions / device.capacity) * 100)
        : 0,
    }));
    
    return { success: true, data: devicesWithOccupancy };
  } catch (error) {
    console.error('Error fetching devices:', error);
    return { success: false, error: 'Error al obtener dispositivos' };
  }
}

export async function getDeviceById(deviceId: string) {
  try {
    const device = await prisma.device.findUnique({
      where: { id: deviceId },
      include: {
        businessArea: {
          include: {
            company: true,
          },
        },
        _count: {
          select: {
            admissions: {
              where: { status: 'ACTIVE' }
            }
          }
        }
      },
    });
    
    if (!device) {
      return { success: false, error: 'Dispositivo no encontrado' };
    }
    
    return { success: true, data: device };
  } catch (error) {
    console.error('Error fetching device:', error);
    return { success: false, error: 'Error al obtener dispositivo' };
  }
}
