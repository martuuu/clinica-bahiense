'use server';

import prisma from '@/lib/prisma';

export async function getPatientsByModality(
  modalityId: string, 
  filters?: { search?: string; status?: string }
) {
  try {
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    const whereClause: any = {
      admissions: {
        some: {
          modalityId: modalityId,
          status: filters?.status === 'ACTIVE' ? 'ACTIVE' : undefined,
        }
      }
    };

    // Agregar búsqueda si existe
    if (filters?.search) {
      whereClause.OR = [
        { firstName: { contains: filters.search, mode: 'insensitive' } },
        { lastName: { contains: filters.search, mode: 'insensitive' } },
        { documentNumber: { contains: filters.search } },
      ];
    }

    const patients = await prisma.patient.findMany({
      where: whereClause,
      include: {
        healthInsurance: true,
        admissions: {
          where: {
            modalityId: modalityId,
            status: filters?.status === 'ACTIVE' ? 'ACTIVE' : undefined,
          },
          include: {
            device: true,
            modality: true,
            authorizations: {
              where: { status: 'ACTIVE' },
              orderBy: { validTo: 'asc' },
              take: 1,
            },
          },
          orderBy: { admissionDate: 'desc' },
          take: 1,
        },
      },
      orderBy: { lastName: 'asc' },
    });

    return { success: true, data: patients };
  } catch (error) {
    console.error('Error fetching patients:', error);
    return { success: false, error: 'Error al obtener pacientes' };
  }
}

export async function getPatientById(patientId: string) {
  try {
    const patient = await prisma.patient.findUnique({
      where: { id: patientId },
      include: {
        healthInsurance: true,
        admissions: {
          include: {
            device: true,
            modality: true,
            authorizations: {
              orderBy: { validTo: 'desc' },
            },
            evolutions: {
              orderBy: { evolutionDate: 'desc' },
              take: 5,
            },
          },
          orderBy: { admissionDate: 'desc' },
        },
      },
    });

    if (!patient) {
      return { success: false, error: 'Paciente no encontrado' };
    }

    return { success: true, data: patient };
  } catch (error) {
    console.error('Error fetching patient:', error);
    return { success: false, error: 'Error al obtener paciente' };
  }
}

export async function createPatient(data: {
  firstName: string;
  lastName: string;
  dni: string;
  birthDate: Date;
  gender: 'MALE' | 'FEMALE' | 'OTHER';
  healthInsuranceId: string;
  affiliateNumber?: string;
  phone?: string;
  email?: string;
  address?: string;
}) {
  try {
    const patient = await prisma.patient.create({
      data,
    });

    return { success: true, data: patient };
  } catch (error) {
    console.error('Error creating patient:', error);
    return { success: false, error: 'Error al crear paciente' };
  }
}

export async function createAdmission(data: {
  patientId: string;
  deviceId: string;
  modalityId?: string;
  admissionDate: Date;
  diagnosis: string;
  icd10Code?: string;
  dsmCode?: string;
}) {
  try {
    const admission = await prisma.admission.create({
      data: {
        ...data,
        status: 'ACTIVE',
      },
      include: {
        patient: true,
        device: true,
        modality: true,
      },
    });

    return { success: true, data: admission };
  } catch (error) {
    console.error('Error creating admission:', error);
    return { success: false, error: 'Error al crear admisión' };
  }
}
