-- ============================================
-- CLINICCORE DATABASE SCHEMA - DEFINITIVO
-- Sistema de Gestión Clínica - Supabase PostgreSQL
-- ============================================
-- IMPORTANTE: Ejecutar este archivo en Supabase SQL Editor
-- NO usar prisma db push/pull (no funciona con Connection Pooler)
-- ============================================
-- NOTA: Este script hace DROP de todo antes de crear
-- Si ya tienes datos, se perderán. Ejecuta seed-data.sql después.
-- ============================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================
-- DROP EXISTING (limpia todo antes de crear)
-- ============================================

DROP TABLE IF EXISTS "AuditLog" CASCADE;
DROP TABLE IF EXISTS "Session" CASCADE;
DROP TABLE IF EXISTS "User" CASCADE;
DROP TABLE IF EXISTS "ProfessionalFee" CASCADE;
DROP TABLE IF EXISTS "InvoiceLine" CASCADE;
DROP TABLE IF EXISTS "Invoice" CASCADE;
DROP TABLE IF EXISTS "Service" CASCADE;
DROP TABLE IF EXISTS "Professional" CASCADE;
DROP TABLE IF EXISTS "Evolution" CASCADE;
DROP TABLE IF EXISTS "Authorization" CASCADE;
DROP TABLE IF EXISTS "Admission" CASCADE;
DROP TABLE IF EXISTS "Patient" CASCADE;
DROP TABLE IF EXISTS "InternmentModality" CASCADE;
DROP TABLE IF EXISTS "Agreement" CASCADE;
DROP TABLE IF EXISTS "HealthInsurance" CASCADE;
DROP TABLE IF EXISTS "Device" CASCADE;
DROP TABLE IF EXISTS "BusinessArea" CASCADE;
DROP TABLE IF EXISTS "Company" CASCADE;

DROP TYPE IF EXISTS "UserRole" CASCADE;
DROP TYPE IF EXISTS "FeeStatus" CASCADE;
DROP TYPE IF EXISTS "InvoiceStatus" CASCADE;
DROP TYPE IF EXISTS "ServiceType" CASCADE;
DROP TYPE IF EXISTS "AuthorizationStatus" CASCADE;
DROP TYPE IF EXISTS "AdmissionStatus" CASCADE;
DROP TYPE IF EXISTS "Gender" CASCADE;
DROP TYPE IF EXISTS "InsuranceType" CASCADE;
DROP TYPE IF EXISTS "DeviceType" CASCADE;

-- ============================================
-- ENUMS
-- ============================================

CREATE TYPE "DeviceType" AS ENUM (
  'INTERNACION',
  'VIVIENDA_ASISTIDA',
  'HOSPITAL_DIA',
  'CONSULTORIOS_EXTERNOS',
  'CCSI'
);

CREATE TYPE "InsuranceType" AS ENUM (
  'PAMI',
  'OSDE',
  'SWISS_MEDICAL',
  'OSMEDICA',
  'PARTICULAR',
  'PRESUPUESTO',
  'OTHER'
);

CREATE TYPE "Gender" AS ENUM (
  'MALE',
  'FEMALE',
  'OTHER'
);

CREATE TYPE "AdmissionStatus" AS ENUM (
  'ACTIVE',
  'DISCHARGED',
  'TRANSFERRED',
  'CANCELLED'
);

CREATE TYPE "AuthorizationStatus" AS ENUM (
  'ACTIVE',
  'EXPIRED',
  'EXTENDED',
  'CANCELLED'
);

CREATE TYPE "ServiceType" AS ENUM (
  'CONSULTA',
  'EVOLUCION',
  'GUARDIA',
  'INTERCONSULTA',
  'TERAPIA_INDIVIDUAL',
  'TERAPIA_GRUPAL',
  'TALLER',
  'OTRO'
);

CREATE TYPE "InvoiceStatus" AS ENUM (
  'DRAFT',
  'ISSUED',
  'PRESENTED',
  'PAID',
  'REJECTED',
  'PARTIALLY_PAID',
  'CANCELLED'
);

CREATE TYPE "FeeStatus" AS ENUM (
  'PENDING',
  'PAID',
  'CANCELLED'
);

CREATE TYPE "UserRole" AS ENUM (
  'SUPER_ADMIN',
  'COMPANY_ADMIN',
  'MANAGER',
  'PROFESSIONAL',
  'BILLING',
  'VIEWER'
);

-- ============================================
-- CONFIGURACIÓN Y MAESTROS
-- ============================================

-- Companies (Empresas del grupo)
CREATE TABLE "Company" (
  "id" UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  "name" TEXT NOT NULL,
  "code" TEXT UNIQUE NOT NULL,
  "cuit" TEXT UNIQUE NOT NULL,
  "address" TEXT,
  "phone" TEXT,
  "email" TEXT,
  "active" BOOLEAN NOT NULL DEFAULT true,
  "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX "Company_code_idx" ON "Company"("code");
CREATE INDEX "Company_active_idx" ON "Company"("active");

-- Business Areas (Áreas de negocio: Salud Mental, Rehabilitación)
CREATE TABLE "BusinessArea" (
  "id" UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  "companyId" UUID NOT NULL REFERENCES "Company"("id") ON DELETE CASCADE,
  "name" TEXT NOT NULL,
  "code" TEXT NOT NULL,
  "billingSystem" TEXT,
  "active" BOOLEAN NOT NULL DEFAULT true,
  "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE("companyId", "code")
);

CREATE INDEX "BusinessArea_companyId_idx" ON "BusinessArea"("companyId");

-- Devices (Dispositivos: Internación, Vivienda, Hospital de Día, etc.)
CREATE TABLE "Device" (
  "id" UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  "businessAreaId" UUID NOT NULL REFERENCES "BusinessArea"("id") ON DELETE CASCADE,
  "name" TEXT NOT NULL,
  "code" TEXT NOT NULL,
  "type" "DeviceType" NOT NULL,
  "capacity" INTEGER,
  "active" BOOLEAN NOT NULL DEFAULT true,
  "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE("businessAreaId", "code")
);

CREATE INDEX "Device_businessAreaId_idx" ON "Device"("businessAreaId");
CREATE INDEX "Device_type_idx" ON "Device"("type");

-- Health Insurance (Obras Sociales y Prepagas)
CREATE TABLE "HealthInsurance" (
  "id" UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  "name" TEXT NOT NULL,
  "code" TEXT UNIQUE NOT NULL,
  "type" "InsuranceType" NOT NULL,
  "cuit" TEXT,
  "paymentTermDays" INTEGER NOT NULL DEFAULT 30,
  "active" BOOLEAN NOT NULL DEFAULT true,
  "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX "HealthInsurance_type_idx" ON "HealthInsurance"("type");
CREATE INDEX "HealthInsurance_active_idx" ON "HealthInsurance"("active");

-- Agreements (Convenios con obras sociales)
CREATE TABLE "Agreement" (
  "id" UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  "healthInsuranceId" UUID NOT NULL REFERENCES "HealthInsurance"("id"),
  "deviceId" UUID NOT NULL REFERENCES "Device"("id"),
  "validFrom" TIMESTAMP(3) NOT NULL,
  "validTo" TIMESTAMP(3),
  "urValue" DECIMAL(10,2),
  "billingRules" JSONB,
  "active" BOOLEAN NOT NULL DEFAULT true,
  "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX "Agreement_healthInsuranceId_idx" ON "Agreement"("healthInsuranceId");
CREATE INDEX "Agreement_deviceId_idx" ON "Agreement"("deviceId");
CREATE INDEX "Agreement_validFrom_validTo_idx" ON "Agreement"("validFrom", "validTo");

-- Internment Modalities (Modalidades de internación)
CREATE TABLE "InternmentModality" (
  "id" UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  "agreementId" UUID NOT NULL REFERENCES "Agreement"("id") ON DELETE CASCADE,
  "name" TEXT NOT NULL,
  "code" TEXT NOT NULL,
  "modules" JSONB,
  "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE("agreementId", "code")
);

CREATE INDEX "InternmentModality_agreementId_idx" ON "InternmentModality"("agreementId");

-- ============================================
-- PACIENTES Y ADMISIONES
-- ============================================

-- Patients (Pacientes)
CREATE TABLE "Patient" (
  "id" UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  "dni" TEXT UNIQUE NOT NULL,
  "firstName" TEXT NOT NULL,
  "lastName" TEXT NOT NULL,
  "birthDate" TIMESTAMP(3) NOT NULL,
  "gender" "Gender" NOT NULL,
  "phone" TEXT,
  "email" TEXT,
  "address" TEXT,
  "healthInsuranceId" UUID NOT NULL REFERENCES "HealthInsurance"("id"),
  "affiliateNumber" TEXT,
  "emergencyContact" JSONB,
  "medicalHistory" JSONB,
  "active" BOOLEAN NOT NULL DEFAULT true,
  "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX "Patient_dni_idx" ON "Patient"("dni");
CREATE INDEX "Patient_healthInsuranceId_idx" ON "Patient"("healthInsuranceId");
CREATE INDEX "Patient_lastName_firstName_idx" ON "Patient"("lastName", "firstName");

-- Admissions (Ingresos/Admisiones)
CREATE TABLE "Admission" (
  "id" UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  "patientId" UUID NOT NULL REFERENCES "Patient"("id"),
  "deviceId" UUID NOT NULL REFERENCES "Device"("id"),
  "modalityId" UUID REFERENCES "InternmentModality"("id"),
  "admissionDate" TIMESTAMP(3) NOT NULL,
  "dischargeDate" TIMESTAMP(3),
  "status" "AdmissionStatus" NOT NULL DEFAULT 'ACTIVE',
  "diagnosis" TEXT NOT NULL,
  "icd10Code" TEXT,
  "dsmCode" TEXT,
  "observations" TEXT,
  "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX "Admission_patientId_idx" ON "Admission"("patientId");
CREATE INDEX "Admission_deviceId_idx" ON "Admission"("deviceId");
CREATE INDEX "Admission_status_idx" ON "Admission"("status");
CREATE INDEX "Admission_admissionDate_idx" ON "Admission"("admissionDate");

-- Authorizations (Autorizaciones de obras sociales)
CREATE TABLE "Authorization" (
  "id" UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  "admissionId" UUID NOT NULL REFERENCES "Admission"("id") ON DELETE CASCADE,
  "authNumber" TEXT UNIQUE NOT NULL,
  "authorizedDays" INTEGER NOT NULL,
  "validFrom" TIMESTAMP(3) NOT NULL,
  "validTo" TIMESTAMP(3) NOT NULL,
  "status" "AuthorizationStatus" NOT NULL DEFAULT 'ACTIVE',
  "requestedExtension" BOOLEAN NOT NULL DEFAULT false,
  "extensionObservations" TEXT,
  "observations" TEXT,
  "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX "Authorization_admissionId_idx" ON "Authorization"("admissionId");
CREATE INDEX "Authorization_status_idx" ON "Authorization"("status");
CREATE INDEX "Authorization_validTo_idx" ON "Authorization"("validTo");

-- Evolutions (Evoluciones clínicas)
CREATE TABLE "Evolution" (
  "id" UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  "admissionId" UUID NOT NULL REFERENCES "Admission"("id") ON DELETE CASCADE,
  "professionalId" UUID NOT NULL,
  "evolutionDate" TIMESTAMP(3) NOT NULL,
  "content" TEXT NOT NULL,
  "signature" TEXT,
  "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX "Evolution_admissionId_idx" ON "Evolution"("admissionId");
CREATE INDEX "Evolution_evolutionDate_idx" ON "Evolution"("evolutionDate");

-- ============================================
-- PROFESIONALES Y SERVICIOS
-- ============================================

-- Professionals (Profesionales)
CREATE TABLE "Professional" (
  "id" UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  "firstName" TEXT NOT NULL,
  "lastName" TEXT NOT NULL,
  "dni" TEXT UNIQUE NOT NULL,
  "matricula" TEXT UNIQUE NOT NULL,
  "specialty" TEXT NOT NULL,
  "cuit" TEXT,
  "email" TEXT,
  "phone" TEXT,
  "active" BOOLEAN NOT NULL DEFAULT true,
  "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX "Professional_dni_idx" ON "Professional"("dni");
CREATE INDEX "Professional_matricula_idx" ON "Professional"("matricula");
CREATE INDEX "Professional_lastName_firstName_idx" ON "Professional"("lastName", "firstName");

-- Services (Prestaciones/Servicios facturables)
CREATE TABLE "Service" (
  "id" UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  "admissionId" UUID NOT NULL REFERENCES "Admission"("id") ON DELETE CASCADE,
  "professionalId" UUID NOT NULL REFERENCES "Professional"("id"),
  "serviceDate" TIMESTAMP(3) NOT NULL,
  "serviceType" "ServiceType" NOT NULL,
  "duration" INTEGER,
  "amount" DECIMAL(10,2) NOT NULL,
  "billed" BOOLEAN NOT NULL DEFAULT false,
  "observations" TEXT,
  "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX "Service_admissionId_idx" ON "Service"("admissionId");
CREATE INDEX "Service_professionalId_idx" ON "Service"("professionalId");
CREATE INDEX "Service_serviceDate_idx" ON "Service"("serviceDate");
CREATE INDEX "Service_billed_idx" ON "Service"("billed");

-- ============================================
-- FACTURACIÓN
-- ============================================

-- Invoices (Facturas)
CREATE TABLE "Invoice" (
  "id" UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  "companyId" UUID NOT NULL REFERENCES "Company"("id"),
  "healthInsuranceId" UUID NOT NULL REFERENCES "HealthInsurance"("id"),
  "deviceId" UUID NOT NULL REFERENCES "Device"("id"),
  "invoiceNumber" TEXT UNIQUE NOT NULL,
  "invoiceDate" TIMESTAMP(3) NOT NULL,
  "periodStart" TIMESTAMP(3) NOT NULL,
  "periodEnd" TIMESTAMP(3) NOT NULL,
  "totalAmount" DECIMAL(12,2) NOT NULL,
  "status" "InvoiceStatus" NOT NULL DEFAULT 'DRAFT',
  "paymentDate" TIMESTAMP(3),
  "observations" TEXT,
  "tangoExported" BOOLEAN NOT NULL DEFAULT false,
  "tangoExportDate" TIMESTAMP(3),
  "afipCae" TEXT,
  "afipCaeExpiry" TIMESTAMP(3),
  "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX "Invoice_companyId_idx" ON "Invoice"("companyId");
CREATE INDEX "Invoice_healthInsuranceId_idx" ON "Invoice"("healthInsuranceId");
CREATE INDEX "Invoice_status_idx" ON "Invoice"("status");
CREATE INDEX "Invoice_invoiceDate_idx" ON "Invoice"("invoiceDate");
CREATE INDEX "Invoice_periodStart_periodEnd_idx" ON "Invoice"("periodStart", "periodEnd");

-- Invoice Lines (Líneas de factura)
CREATE TABLE "InvoiceLine" (
  "id" UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  "invoiceId" UUID NOT NULL REFERENCES "Invoice"("id") ON DELETE CASCADE,
  "patientId" UUID NOT NULL REFERENCES "Patient"("id"),
  "admissionId" UUID REFERENCES "Admission"("id"),
  "serviceId" UUID REFERENCES "Service"("id"),
  "description" TEXT NOT NULL,
  "quantity" DECIMAL(10,2) NOT NULL,
  "unitPrice" DECIMAL(10,2) NOT NULL,
  "totalAmount" DECIMAL(12,2) NOT NULL,
  "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX "InvoiceLine_invoiceId_idx" ON "InvoiceLine"("invoiceId");
CREATE INDEX "InvoiceLine_patientId_idx" ON "InvoiceLine"("patientId");
CREATE INDEX "InvoiceLine_admissionId_idx" ON "InvoiceLine"("admissionId");

-- Professional Fees (Honorarios profesionales)
CREATE TABLE "ProfessionalFee" (
  "id" UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  "professionalId" UUID NOT NULL REFERENCES "Professional"("id"),
  "invoiceLineId" UUID REFERENCES "InvoiceLine"("id"),
  "serviceId" UUID REFERENCES "Service"("id"),
  "amount" DECIMAL(10,2) NOT NULL,
  "percentage" DECIMAL(5,2),
  "status" "FeeStatus" NOT NULL DEFAULT 'PENDING',
  "paymentDate" TIMESTAMP(3),
  "observations" TEXT,
  "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX "ProfessionalFee_professionalId_idx" ON "ProfessionalFee"("professionalId");
CREATE INDEX "ProfessionalFee_status_idx" ON "ProfessionalFee"("status");
CREATE INDEX "ProfessionalFee_paymentDate_idx" ON "ProfessionalFee"("paymentDate");

-- ============================================
-- USUARIOS Y SEGURIDAD
-- ============================================

-- Users (Usuarios del sistema)
CREATE TABLE "User" (
  "id" UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  "email" TEXT UNIQUE NOT NULL,
  "password" TEXT NOT NULL,
  "firstName" TEXT NOT NULL,
  "lastName" TEXT NOT NULL,
  "role" "UserRole" NOT NULL,
  "companyId" UUID REFERENCES "Company"("id"),
  "active" BOOLEAN NOT NULL DEFAULT true,
  "lastLogin" TIMESTAMP(3),
  "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX "User_email_idx" ON "User"("email");
CREATE INDEX "User_role_idx" ON "User"("role");
CREATE INDEX "User_companyId_idx" ON "User"("companyId");

-- Sessions (Sesiones de usuario)
CREATE TABLE "Session" (
  "id" UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  "userId" UUID NOT NULL REFERENCES "User"("id") ON DELETE CASCADE,
  "token" TEXT UNIQUE NOT NULL,
  "expiresAt" TIMESTAMP(3) NOT NULL,
  "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX "Session_userId_idx" ON "Session"("userId");
CREATE INDEX "Session_token_idx" ON "Session"("token");
CREATE INDEX "Session_expiresAt_idx" ON "Session"("expiresAt");

-- ============================================
-- AUDITORÍA
-- ============================================

-- Audit Log (Registro de auditoría)
CREATE TABLE "AuditLog" (
  "id" UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  "userId" UUID REFERENCES "User"("id"),
  "action" TEXT NOT NULL,
  "entity" TEXT NOT NULL,
  "entityId" TEXT,
  "oldData" JSONB,
  "newData" JSONB,
  "ipAddress" TEXT,
  "userAgent" TEXT,
  "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX "AuditLog_userId_idx" ON "AuditLog"("userId");
CREATE INDEX "AuditLog_action_idx" ON "AuditLog"("action");
CREATE INDEX "AuditLog_entity_idx" ON "AuditLog"("entity");
CREATE INDEX "AuditLog_createdAt_idx" ON "AuditLog"("createdAt");

-- ============================================
-- TRIGGERS PARA UPDATED_AT
-- ============================================

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW."updatedAt" = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Apply trigger to all tables with updatedAt
CREATE TRIGGER update_company_updated_at BEFORE UPDATE ON "Company" FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_business_area_updated_at BEFORE UPDATE ON "BusinessArea" FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_device_updated_at BEFORE UPDATE ON "Device" FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_health_insurance_updated_at BEFORE UPDATE ON "HealthInsurance" FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_agreement_updated_at BEFORE UPDATE ON "Agreement" FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_internment_modality_updated_at BEFORE UPDATE ON "InternmentModality" FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_patient_updated_at BEFORE UPDATE ON "Patient" FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_admission_updated_at BEFORE UPDATE ON "Admission" FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_authorization_updated_at BEFORE UPDATE ON "Authorization" FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_evolution_updated_at BEFORE UPDATE ON "Evolution" FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_professional_updated_at BEFORE UPDATE ON "Professional" FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_service_updated_at BEFORE UPDATE ON "Service" FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_invoice_updated_at BEFORE UPDATE ON "Invoice" FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_invoice_line_updated_at BEFORE UPDATE ON "InvoiceLine" FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_professional_fee_updated_at BEFORE UPDATE ON "ProfessionalFee" FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_user_updated_at BEFORE UPDATE ON "User" FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ============================================
-- ESQUEMA COMPLETADO
-- ============================================
-- Siguiente paso: Ejecutar seed-data.sql para cargar datos de prueba
