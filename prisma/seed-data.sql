-- ============================================
-- SEED DATA COMPLETO - ClinicCore
-- Sistema de Gestión Clínica
-- ============================================
-- IMPORTANTE: Ejecutar primero schema-complete.sql
-- Luego ejecutar este archivo en Supabase SQL Editor
-- ============================================

-- Limpiar datos existentes (opcional - descomentar si necesitas limpiar)
/*
TRUNCATE TABLE 
  "AuditLog",
  "Session",
  "User",
  "ProfessionalFee",
  "InvoiceLine",
  "Invoice",
  "Service",
  "Professional",
  "Evolution",
  "Authorization",
  "Admission",
  "Patient",
  "InternmentModality",
  "Agreement",
  "Device",
  "BusinessArea",
  "HealthInsurance",
  "Company"
CASCADE;
*/

-- ============================================
-- EMPRESAS
-- ============================================

INSERT INTO "Company" ("id", "name", "code", "cuit", "address", "phone", "email", "active") VALUES
('550e8400-e29b-41d4-a716-446655440001', 'Clínica Privada Bahiense', 'CPB', '30-12345678-9', 'Av. Principal 123, Bahía Blanca', '+54 291 123-4567', 'info@cpb.com.ar', true),
('550e8400-e29b-41d4-a716-446655440002', 'Solar del Rosario', 'SDR', '30-87654321-0', 'Calle Rosario 456, Bahía Blanca', '+54 291 987-6543', 'info@solardelrosario.com.ar', true),
('550e8400-e29b-41d4-a716-446655440003', 'Acompañe y Asiste', 'AYA', '30-11223344-5', 'Calle Asistencia 789, Bahía Blanca', '+54 291 112-2334', 'info@acompanesyasiste.com.ar', true)
ON CONFLICT ("code") DO NOTHING;

-- ============================================
-- ÁREAS DE NEGOCIO
-- ============================================

INSERT INTO "BusinessArea" ("id", "companyId", "name", "code", "billingSystem", "active") VALUES
-- CPB - Clínica Privada Bahiense
('660e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440001', 'Salud Mental', 'SM', 'UR_PAMI', true),
('660e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440001', 'Rehabilitación Física', 'RF', 'STANDARD', true),
-- Solar del Rosario
('660e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440002', 'Salud Mental', 'SM', 'UR_PAMI', true),
('660e8400-e29b-41d4-a716-446655440004', '550e8400-e29b-41d4-a716-446655440002', 'Rehabilitación Física', 'RF', 'STANDARD', true),
-- Acompañe y Asiste
('660e8400-e29b-41d4-a716-446655440005', '550e8400-e29b-41d4-a716-446655440003', 'Salud Mental', 'SM', 'UR_PAMI', true),
('660e8400-e29b-41d4-a716-446655440006', '550e8400-e29b-41d4-a716-446655440003', 'Rehabilitación Física', 'RF', 'STANDARD', true)
ON CONFLICT ("companyId", "code") DO NOTHING;

-- ============================================
-- DISPOSITIVOS
-- ============================================

INSERT INTO "Device" ("id", "businessAreaId", "name", "code", "type", "capacity", "active") VALUES
-- CPB - Salud Mental
('770e8400-e29b-41d4-a716-446655440001', '660e8400-e29b-41d4-a716-446655440001', 'Internación', 'INT', 'INTERNACION', 30, true),
('770e8400-e29b-41d4-a716-446655440002', '660e8400-e29b-41d4-a716-446655440001', 'Vivienda Asistida', 'VIV', 'VIVIENDA_ASISTIDA', 20, true),
('770e8400-e29b-41d4-a716-446655440003', '660e8400-e29b-41d4-a716-446655440001', 'Hospital de Día', 'HD', 'HOSPITAL_DIA', 40, true),
('770e8400-e29b-41d4-a716-446655440004', '660e8400-e29b-41d4-a716-446655440001', 'Consultorios Externos', 'CE', 'CONSULTORIOS_EXTERNOS', 10, true),
('770e8400-e29b-41d4-a716-446655440005', '660e8400-e29b-41d4-a716-446655440001', 'CCSI', 'CCSI', 'CCSI', 50, true),
-- CPB - Rehabilitación Física
('770e8400-e29b-41d4-a716-446655440006', '660e8400-e29b-41d4-a716-446655440002', 'Internación', 'INT', 'INTERNACION', 15, true),
('770e8400-e29b-41d4-a716-446655440007', '660e8400-e29b-41d4-a716-446655440002', 'Hospital de Día', 'HD', 'HOSPITAL_DIA', 25, true),
-- Solar del Rosario - Salud Mental
('770e8400-e29b-41d4-a716-446655440008', '660e8400-e29b-41d4-a716-446655440003', 'Vivienda Asistida', 'VIV', 'VIVIENDA_ASISTIDA', 35, true),
('770e8400-e29b-41d4-a716-446655440009', '660e8400-e29b-41d4-a716-446655440003', 'Hospital de Día', 'HD', 'HOSPITAL_DIA', 30, true),
-- Solar del Rosario - Rehabilitación
('770e8400-e29b-41d4-a716-446655440010', '660e8400-e29b-41d4-a716-446655440004', 'Consultorios Externos', 'CE', 'CONSULTORIOS_EXTERNOS', 8, true),
-- Acompañe y Asiste - Salud Mental
('770e8400-e29b-41d4-a716-446655440011', '660e8400-e29b-41d4-a716-446655440005', 'Vivienda Asistida', 'VIV', 'VIVIENDA_ASISTIDA', 25, true),
('770e8400-e29b-41d4-a716-446655440012', '660e8400-e29b-41d4-a716-446655440005', 'CCSI', 'CCSI', 'CCSI', 40, true),
-- Acompañe y Asiste - Rehabilitación
('770e8400-e29b-41d4-a716-446655440013', '660e8400-e29b-41d4-a716-446655440006', 'Hospital de Día', 'HD', 'HOSPITAL_DIA', 20, true)
ON CONFLICT ("businessAreaId", "code") DO NOTHING;

-- ============================================
-- OBRAS SOCIALES
-- ============================================

INSERT INTO "HealthInsurance" ("id", "name", "code", "type", "cuit", "paymentTermDays", "active") VALUES
('880e8400-e29b-41d4-a716-446655440001', 'PAMI', 'PAMI', 'PAMI', '30-12345678-9', 90, true),
('880e8400-e29b-41d4-a716-446655440002', 'OSDE', 'OSDE', 'OSDE', '30-22334455-6', 60, true),
('880e8400-e29b-41d4-a716-446655440003', 'Swiss Medical', 'SWISS', 'SWISS_MEDICAL', '30-33445566-7', 60, true),
('880e8400-e29b-41d4-a716-446655440004', 'OSMEDICA', 'OSMED', 'OSMEDICA', '30-44556677-8', 45, true),
('880e8400-e29b-41d4-a716-446655440005', 'Particular', 'PART', 'PARTICULAR', NULL, 0, true)
ON CONFLICT ("code") DO NOTHING;

-- ============================================
-- CONVENIOS
-- ============================================

INSERT INTO "Agreement" ("id", "healthInsuranceId", "deviceId", "validFrom", "validTo", "urValue", "active") VALUES
-- CPB - Salud Mental - Internación (PAMI)
('990e8400-e29b-41d4-a716-446655440001', '880e8400-e29b-41d4-a716-446655440001', '770e8400-e29b-41d4-a716-446655440001', '2026-01-01', '2026-12-31', 1250.00, true),
-- CPB - Salud Mental - Vivienda (PAMI)
('990e8400-e29b-41d4-a716-446655440002', '880e8400-e29b-41d4-a716-446655440001', '770e8400-e29b-41d4-a716-446655440002', '2026-01-01', '2026-12-31', 1100.00, true),
-- CPB - Salud Mental - Internación (OSDE)
('990e8400-e29b-41d4-a716-446655440003', '880e8400-e29b-41d4-a716-446655440002', '770e8400-e29b-41d4-a716-446655440001', '2026-01-01', '2026-12-31', NULL, true),
-- CPB - Salud Mental - Hospital de Día (PAMI)
('990e8400-e29b-41d4-a716-446655440004', '880e8400-e29b-41d4-a716-446655440001', '770e8400-e29b-41d4-a716-446655440003', '2026-01-01', '2026-12-31', 950.00, true),
-- CPB - Rehabilitación - Internación (OSMEDICA)
('990e8400-e29b-41d4-a716-446655440005', '880e8400-e29b-41d4-a716-446655440004', '770e8400-e29b-41d4-a716-446655440006', '2026-01-01', '2026-12-31', NULL, true),
-- Solar del Rosario - Vivienda (PAMI)
('990e8400-e29b-41d4-a716-446655440006', '880e8400-e29b-41d4-a716-446655440001', '770e8400-e29b-41d4-a716-446655440008', '2026-01-01', '2026-12-31', 1150.00, true),
-- Solar del Rosario - Hospital Día (Swiss)
('990e8400-e29b-41d4-a716-446655440007', '880e8400-e29b-41d4-a716-446655440003', '770e8400-e29b-41d4-a716-446655440009', '2026-01-01', '2026-12-31', NULL, true),
-- Acompañe y Asiste - Vivienda (PAMI)
('990e8400-e29b-41d4-a716-446655440008', '880e8400-e29b-41d4-a716-446655440001', '770e8400-e29b-41d4-a716-446655440011', '2026-01-01', '2026-12-31', 1100.00, true)
ON CONFLICT DO NOTHING;

-- ============================================
-- MODALIDADES DE INTERNACIÓN
-- ============================================

INSERT INTO "InternmentModality" ("id", "agreementId", "name", "code", "modules") VALUES
-- CPB Internación PAMI
('aa0e8400-e29b-41d4-a716-446655440001', '990e8400-e29b-41d4-a716-446655440001', 'Internación Aguda', 'AGUDA', '{"urModules": 10, "description": "Internación de corta duración"}'),
('aa0e8400-e29b-41d4-a716-446655440002', '990e8400-e29b-41d4-a716-446655440001', 'Internación Prolongada', 'PROLONGADA', '{"urModules": 8, "description": "Internación de larga duración"}'),
('aa0e8400-e29b-41d4-a716-446655440003', '990e8400-e29b-41d4-a716-446655440001', 'Internación Domiciliaria', 'DOMICILIARIA', '{"urModules": 6, "description": "Atención en domicilio"}'),
-- CPB Vivienda PAMI
('aa0e8400-e29b-41d4-a716-446655440004', '990e8400-e29b-41d4-a716-446655440002', 'Vivienda Supervisada', 'VIV_SUP', '{"urModules": 7, "description": "Supervisión permanente"}'),
('aa0e8400-e29b-41d4-a716-446655440005', '990e8400-e29b-41d4-a716-446655440002', 'Vivienda Asistida', 'VIV_ASIST', '{"urModules": 5, "description": "Asistencia básica"}'),
-- CPB Hospital de Día PAMI
('aa0e8400-e29b-41d4-a716-446655440006', '990e8400-e29b-41d4-a716-446655440004', 'Hospital de Día Intensivo', 'HD_INT', '{"urModules": 9, "description": "Atención intensiva diurna"}'),
-- Solar Vivienda PAMI
('aa0e8400-e29b-41d4-a716-446655440007', '990e8400-e29b-41d4-a716-446655440006', 'Vivienda Asistida', 'VIV_ASIST', '{"urModules": 6, "description": "Asistencia en vivienda"}'),
-- Acompañe Vivienda PAMI
('aa0e8400-e29b-41d4-a716-446655440008', '990e8400-e29b-41d4-a716-446655440008', 'Vivienda Asistida', 'VIV_ASIST', '{"urModules": 5, "description": "Vivienda con asistencia"}')
ON CONFLICT ("agreementId", "code") DO NOTHING;

-- ============================================
-- PACIENTES
-- ============================================

INSERT INTO "Patient" ("id", "dni", "firstName", "lastName", "birthDate", "gender", "phone", "email", "address", "healthInsuranceId", "affiliateNumber", "active") VALUES
('bb0e8400-e29b-41d4-a716-446655440001', '12345678', 'Juan', 'Pérez', '1980-05-15', 'MALE', '+54 291 123-4567', 'juan.perez@email.com', 'Calle 1, Bahía Blanca', '880e8400-e29b-41d4-a716-446655440001', 'PAMI-12345678', true),
('bb0e8400-e29b-41d4-a716-446655440002', '87654321', 'María', 'González', '1975-08-20', 'FEMALE', '+54 291 987-6543', 'maria.gonzalez@email.com', 'Calle 2, Bahía Blanca', '880e8400-e29b-41d4-a716-446655440001', 'PAMI-87654321', true),
('bb0e8400-e29b-41d4-a716-446655440003', '11223344', 'Carlos', 'Rodríguez', '1985-03-10', 'MALE', '+54 291 112-2334', 'carlos.rodriguez@email.com', 'Calle 3, Bahía Blanca', '880e8400-e29b-41d4-a716-446655440002', 'OSDE-11223344', true),
('bb0e8400-e29b-41d4-a716-446655440004', '55667788', 'Ana', 'Martínez', '1990-11-25', 'FEMALE', '+54 291 556-6778', 'ana.martinez@email.com', 'Calle 4, Bahía Blanca', '880e8400-e29b-41d4-a716-446655440003', 'SWISS-55667788', true),
('bb0e8400-e29b-41d4-a716-446655440005', '99887766', 'Pedro', 'López', '1978-07-30', 'MALE', '+54 291 998-8776', 'pedro.lopez@email.com', 'Calle 5, Bahía Blanca', '880e8400-e29b-41d4-a716-446655440004', 'OSMED-99887766', true),
('bb0e8400-e29b-41d4-a716-446655440006', '22334455', 'Laura', 'Fernández', '1982-12-05', 'FEMALE', '+54 291 223-3445', 'laura.fernandez@email.com', 'Calle 6, Bahía Blanca', '880e8400-e29b-41d4-a716-446655440001', 'PAMI-22334455', true),
('bb0e8400-e29b-41d4-a716-446655440007', '66778899', 'Roberto', 'Sánchez', '1995-02-14', 'MALE', '+54 291 667-7889', 'roberto.sanchez@email.com', 'Calle 7, Bahía Blanca', '880e8400-e29b-41d4-a716-446655440005', NULL, true),
('bb0e8400-e29b-41d4-a716-446655440008', '33445566', 'Silvia', 'Torres', '1970-03-22', 'FEMALE', '+54 291 334-4556', 'silvia.torres@email.com', 'Calle 8, Bahía Blanca', '880e8400-e29b-41d4-a716-446655440001', 'PAMI-33445566', true),
('bb0e8400-e29b-41d4-a716-446655440009', '77889900', 'Diego', 'Ramírez', '1988-09-17', 'MALE', '+54 291 778-8990', 'diego.ramirez@email.com', 'Calle 9, Bahía Blanca', '880e8400-e29b-41d4-a716-446655440002', 'OSDE-77889900', true),
('bb0e8400-e29b-41d4-a716-446655440010', '44556677', 'Claudia', 'Vargas', '1983-11-30', 'FEMALE', '+54 291 445-5667', 'claudia.vargas@email.com', 'Calle 10, Bahía Blanca', '880e8400-e29b-41d4-a716-446655440003', 'SWISS-44556677', true)
ON CONFLICT ("dni") DO NOTHING;

-- ============================================
-- ADMISIONES
-- ============================================

INSERT INTO "Admission" ("id", "patientId", "deviceId", "modalityId", "admissionDate", "dischargeDate", "status", "diagnosis", "icd10Code", "observations") VALUES
-- CPB Internación
('cc0e8400-e29b-41d4-a716-446655440001', 'bb0e8400-e29b-41d4-a716-446655440001', '770e8400-e29b-41d4-a716-446655440001', 'aa0e8400-e29b-41d4-a716-446655440001', '2026-01-01', NULL, 'ACTIVE', 'Trastorno depresivo mayor', 'F32.9', 'Paciente estable, responde bien al tratamiento'),
('cc0e8400-e29b-41d4-a716-446655440002', 'bb0e8400-e29b-41d4-a716-446655440002', '770e8400-e29b-41d4-a716-446655440001', 'aa0e8400-e29b-41d4-a716-446655440002', '2025-12-15', NULL, 'ACTIVE', 'Trastorno de ansiedad generalizada', 'F41.1', 'Evolución favorable'),
-- CPB Vivienda
('cc0e8400-e29b-41d4-a716-446655440003', 'bb0e8400-e29b-41d4-a716-446655440003', '770e8400-e29b-41d4-a716-446655440002', 'aa0e8400-e29b-41d4-a716-446655440004', '2026-01-05', NULL, 'ACTIVE', 'Trastorno bipolar', 'F31.9', 'Requiere seguimiento cercano'),
-- CPB Hospital de Día
('cc0e8400-e29b-41d4-a716-446655440004', 'bb0e8400-e29b-41d4-a716-446655440004', '770e8400-e29b-41d4-a716-446655440003', 'aa0e8400-e29b-41d4-a716-446655440006', '2026-01-03', NULL, 'ACTIVE', 'Trastorno de pánico', 'F41.0', 'Participando en terapia grupal'),
-- CPB Internación (más pacientes)
('cc0e8400-e29b-41d4-a716-446655440005', 'bb0e8400-e29b-41d4-a716-446655440005', '770e8400-e29b-41d4-a716-446655440001', 'aa0e8400-e29b-41d4-a716-446655440001', '2025-12-20', NULL, 'ACTIVE', 'Trastorno adaptativo', 'F43.2', 'Buena adherencia al tratamiento'),
('cc0e8400-e29b-41d4-a716-446655440006', 'bb0e8400-e29b-41d4-a716-446655440006', '770e8400-e29b-41d4-a716-446655440001', 'aa0e8400-e29b-41d4-a716-446655440002', '2025-11-01', '2025-12-31', 'DISCHARGED', 'Trastorno depresivo mayor', 'F32.9', 'Alta por mejoría clínica'),
-- CPB Consultorios (sin modalidad)
('cc0e8400-e29b-41d4-a716-446655440007', 'bb0e8400-e29b-41d4-a716-446655440007', '770e8400-e29b-41d4-a716-446655440004', NULL, '2026-01-08', NULL, 'ACTIVE', 'Trastorno de estrés postraumático', 'F43.1', 'En evaluación inicial'),
-- CPB Rehabilitación
('cc0e8400-e29b-41d4-a716-446655440008', 'bb0e8400-e29b-41d4-a716-446655440008', '770e8400-e29b-41d4-a716-446655440006', NULL, '2026-01-02', NULL, 'ACTIVE', 'Rehabilitación post ACV', 'I69.3', 'Evolución favorable'),
-- Solar Vivienda
('cc0e8400-e29b-41d4-a716-446655440009', 'bb0e8400-e29b-41d4-a716-446655440009', '770e8400-e29b-41d4-a716-446655440008', 'aa0e8400-e29b-41d4-a716-446655440007', '2025-12-28', NULL, 'ACTIVE', 'Esquizofrenia', 'F20.0', 'Estable con medicación'),
-- Solar Hospital Día (sin modalidad - Swiss)
('cc0e8400-e29b-41d4-a716-446655440010', 'bb0e8400-e29b-41d4-a716-446655440010', '770e8400-e29b-41d4-a716-446655440009', NULL, '2026-01-06', NULL, 'ACTIVE', 'Trastorno de personalidad', 'F60.3', 'En tratamiento ambulatorio'),
-- Acompañe Vivienda
('cc0e8400-e29b-41d4-a716-446655440011', 'bb0e8400-e29b-41d4-a716-446655440001', '770e8400-e29b-41d4-a716-446655440011', 'aa0e8400-e29b-41d4-a716-446655440008', '2025-12-10', NULL, 'ACTIVE', 'Trastorno depresivo recurrente', 'F33.1', 'Necesita apoyo constante')
ON CONFLICT DO NOTHING;

-- ============================================
-- AUTORIZACIONES
-- ============================================

INSERT INTO "Authorization" ("id", "admissionId", "authNumber", "authorizedDays", "validFrom", "validTo", "status", "observations") VALUES
('dd0e8400-e29b-41d4-a716-446655440001', 'cc0e8400-e29b-41d4-a716-446655440001', 'AUTH-2026-001', 45, '2026-01-01', '2026-02-15', 'ACTIVE', 'Autorización inicial'),
('dd0e8400-e29b-41d4-a716-446655440002', 'cc0e8400-e29b-41d4-a716-446655440002', 'AUTH-2025-125', 60, '2025-12-15', '2026-01-20', 'ACTIVE', 'Próximo a vencer - solicitar extensión'),
('dd0e8400-e29b-41d4-a716-446655440003', 'cc0e8400-e29b-41d4-a716-446655440003', 'AUTH-2026-002', 30, '2026-01-05', '2026-02-04', 'ACTIVE', 'Autorización inicial vivienda'),
('dd0e8400-e29b-41d4-a716-446655440004', 'cc0e8400-e29b-41d4-a716-446655440005', 'AUTH-2025-124', 45, '2025-12-20', '2026-02-03', 'ACTIVE', 'Renovación aprobada'),
('dd0e8400-e29b-41d4-a716-446655440005', 'cc0e8400-e29b-41d4-a716-446655440006', 'AUTH-2025-100', 60, '2025-11-01', '2025-12-31', 'EXPIRED', 'Paciente dado de alta'),
('dd0e8400-e29b-41d4-a716-446655440006', 'cc0e8400-e29b-41d4-a716-446655440004', 'AUTH-2026-003', 30, '2026-01-03', '2026-02-02', 'ACTIVE', 'Hospital de día - PAMI'),
('dd0e8400-e29b-41d4-a716-446655440007', 'cc0e8400-e29b-41d4-a716-446655440009', 'AUTH-2025-128', 90, '2025-12-28', '2026-03-28', 'ACTIVE', 'Vivienda Solar - prolongada'),
('dd0e8400-e29b-41d4-a716-446655440008', 'cc0e8400-e29b-41d4-a716-446655440011', 'AUTH-2025-120', 60, '2025-12-10', '2026-02-08', 'ACTIVE', 'Acompañe vivienda')
ON CONFLICT ("authNumber") DO NOTHING;

-- ============================================
-- PROFESIONALES
-- ============================================

INSERT INTO "Professional" ("id", "firstName", "lastName", "dni", "matricula", "specialty", "cuit", "email", "phone", "active") VALUES
('ee0e8400-e29b-41d4-a716-446655440001', 'Dra. Sandra', 'Gómez', '20123456', 'MN-12345', 'Psiquiatría', '27-20123456-3', 'sandra.gomez@cpb.com.ar', '+54 291 123-0001', true),
('ee0e8400-e29b-41d4-a716-446655440002', 'Lic. Miguel', 'Torres', '30987654', 'MP-67890', 'Psicología Clínica', '20-30987654-8', 'miguel.torres@cpb.com.ar', '+54 291 123-0002', true),
('ee0e8400-e29b-41d4-a716-446655440003', 'Dr. Roberto', 'Díaz', '25556677', 'MN-54321', 'Psiquiatría', '20-25556677-4', 'roberto.diaz@cpb.com.ar', '+54 291 123-0003', true),
('ee0e8400-e29b-41d4-a716-446655440004', 'Lic. Carolina', 'Ruiz', '28445566', 'MP-98765', 'Terapia Ocupacional', '27-28445566-2', 'carolina.ruiz@cpb.com.ar', '+54 291 123-0004', true)
ON CONFLICT ("dni") DO NOTHING;

-- ============================================
-- SERVICIOS
-- ============================================

INSERT INTO "Service" ("id", "admissionId", "professionalId", "serviceDate", "serviceType", "duration", "amount", "billed", "observations") VALUES
('ff0e8400-e29b-41d4-a716-446655440001', 'cc0e8400-e29b-41d4-a716-446655440001', 'ee0e8400-e29b-41d4-a716-446655440001', '2026-01-02', 'CONSULTA', 60, 5000.00, false, 'Evaluación inicial'),
('ff0e8400-e29b-41d4-a716-446655440002', 'cc0e8400-e29b-41d4-a716-446655440001', 'ee0e8400-e29b-41d4-a716-446655440002', '2026-01-03', 'TERAPIA_INDIVIDUAL', 45, 3500.00, false, 'Primera sesión de terapia'),
('ff0e8400-e29b-41d4-a716-446655440003', 'cc0e8400-e29b-41d4-a716-446655440002', 'ee0e8400-e29b-41d4-a716-446655440001', '2025-12-16', 'EVOLUCION', 30, 2500.00, false, 'Control de evolución'),
('ff0e8400-e29b-41d4-a716-446655440004', 'cc0e8400-e29b-41d4-a716-446655440004', 'ee0e8400-e29b-41d4-a716-446655440004', '2026-01-04', 'TERAPIA_GRUPAL', 90, 2000.00, false, 'Taller grupal de manejo de ansiedad')
ON CONFLICT DO NOTHING;

-- ============================================
-- FACTURAS
-- ============================================

INSERT INTO "Invoice" ("id", "companyId", "healthInsuranceId", "deviceId", "invoiceNumber", "invoiceDate", "periodStart", "periodEnd", "totalAmount", "status") VALUES
-- CPB - Salud Mental
('100e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440001', '880e8400-e29b-41d4-a716-446655440001', '770e8400-e29b-41d4-a716-446655440001', 'FAC-CPB-2025-12-001', '2025-12-31', '2025-12-01', '2025-12-31', 375000.00, 'ISSUED'),
('100e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440001', '880e8400-e29b-41d4-a716-446655440001', '770e8400-e29b-41d4-a716-446655440001', 'FAC-CPB-2025-11-001', '2025-11-30', '2025-11-01', '2025-11-30', 480000.00, 'PRESENTED'),
('100e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440001', '880e8400-e29b-41d4-a716-446655440002', '770e8400-e29b-41d4-a716-446655440001', 'FAC-CPB-2025-12-002', '2025-12-31', '2025-12-01', '2025-12-31', 120000.00, 'PAID'),
('100e8400-e29b-41d4-a716-446655440004', '550e8400-e29b-41d4-a716-446655440001', '880e8400-e29b-41d4-a716-446655440003', '770e8400-e29b-41d4-a716-446655440002', 'FAC-CPB-2025-12-003', '2025-12-31', '2025-12-01', '2025-12-31', 80000.00, 'ISSUED'),
-- CPB - Rehabilitación
('100e8400-e29b-41d4-a716-446655440005', '550e8400-e29b-41d4-a716-446655440001', '880e8400-e29b-41d4-a716-446655440004', '770e8400-e29b-41d4-a716-446655440006', 'FAC-CPB-2025-12-004', '2025-12-31', '2025-12-01', '2025-12-31', 95000.00, 'PRESENTED'),
-- Solar del Rosario
('100e8400-e29b-41d4-a716-446655440006', '550e8400-e29b-41d4-a716-446655440002', '880e8400-e29b-41d4-a716-446655440001', '770e8400-e29b-41d4-a716-446655440008', 'FAC-SDR-2025-12-001', '2025-12-31', '2025-12-01', '2025-12-31', 207000.00, 'ISSUED'),
('100e8400-e29b-41d4-a716-446655440007', '550e8400-e29b-41d4-a716-446655440002', '880e8400-e29b-41d4-a716-446655440003', '770e8400-e29b-41d4-a716-446655440009', 'FAC-SDR-2025-11-001', '2025-11-30', '2025-11-01', '2025-11-30', 150000.00, 'PAID'),
-- Acompañe y Asiste
('100e8400-e29b-41d4-a716-446655440008', '550e8400-e29b-41d4-a716-446655440003', '880e8400-e29b-41d4-a716-446655440001', '770e8400-e29b-41d4-a716-446655440011', 'FAC-AYA-2025-12-001', '2025-12-31', '2025-12-01', '2025-12-31', 165000.00, 'PRESENTED')
ON CONFLICT ("invoiceNumber") DO NOTHING;

-- ============================================
-- LÍNEAS DE FACTURA
-- ============================================

INSERT INTO "InvoiceLine" ("id", "invoiceId", "patientId", "admissionId", "description", "quantity", "unitPrice", "totalAmount") VALUES
('110e8400-e29b-41d4-a716-446655440001', '100e8400-e29b-41d4-a716-446655440001', 'bb0e8400-e29b-41d4-a716-446655440001', 'cc0e8400-e29b-41d4-a716-446655440001', 'Internación Aguda - 30 días x 10 UR', 300, 1250.00, 375000.00),
('110e8400-e29b-41d4-a716-446655440002', '100e8400-e29b-41d4-a716-446655440002', 'bb0e8400-e29b-41d4-a716-446655440002', 'cc0e8400-e29b-41d4-a716-446655440002', 'Internación Prolongada - 30 días x 8 UR', 240, 1250.00, 300000.00),
('110e8400-e29b-41d4-a716-446655440003', '100e8400-e29b-41d4-a716-446655440002', 'bb0e8400-e29b-41d4-a716-446655440006', 'cc0e8400-e29b-41d4-a716-446655440006', 'Internación Prolongada - 30 días x 6 UR', 180, 1000.00, 180000.00),
('110e8400-e29b-41d4-a716-446655440004', '100e8400-e29b-41d4-a716-446655440003', 'bb0e8400-e29b-41d4-a716-446655440003', 'cc0e8400-e29b-41d4-a716-446655440003', 'Internación - 20 días', 20, 6000.00, 120000.00),
('110e8400-e29b-41d4-a716-446655440005', '100e8400-e29b-41d4-a716-446655440004', 'bb0e8400-e29b-41d4-a716-446655440004', 'cc0e8400-e29b-41d4-a716-446655440004', 'Vivienda Asistida - 25 días', 25, 3200.00, 80000.00)
ON CONFLICT DO NOTHING;

-- ============================================
-- HONORARIOS PROFESIONALES
-- ============================================

INSERT INTO "ProfessionalFee" ("id", "professionalId", "serviceId", "amount", "percentage", "status") VALUES
('120e8400-e29b-41d4-a716-446655440001', 'ee0e8400-e29b-41d4-a716-446655440001', 'ff0e8400-e29b-41d4-a716-446655440001', 5000.00, 100.00, 'PENDING'),
('120e8400-e29b-41d4-a716-446655440002', 'ee0e8400-e29b-41d4-a716-446655440002', 'ff0e8400-e29b-41d4-a716-446655440002', 3500.00, 100.00, 'PENDING'),
('120e8400-e29b-41d4-a716-446655440003', 'ee0e8400-e29b-41d4-a716-446655440001', 'ff0e8400-e29b-41d4-a716-446655440003', 2500.00, 100.00, 'PENDING'),
('120e8400-e29b-41d4-a716-446655440004', 'ee0e8400-e29b-41d4-a716-446655440004', 'ff0e8400-e29b-41d4-a716-446655440004', 2000.00, 100.00, 'PAID')
ON CONFLICT DO NOTHING;

-- ============================================
-- USUARIOS
-- ============================================

-- Password: admin123 (en producción usar bcrypt)
INSERT INTO "User" ("id", "email", "password", "firstName", "lastName", "role", "companyId", "active") VALUES
('130e8400-e29b-41d4-a716-446655440001', 'admin@cpb.com.ar', '$2a$10$XQKvvvvvvvvvvvvvvvvvvuN3GGsK8dXMn7K7PZ.VHLa6WO9r2', 'Admin', 'Sistema', 'SUPER_ADMIN', NULL, true),
('130e8400-e29b-41d4-a716-446655440002', 'facturacion@cpb.com.ar', '$2a$10$XQKvvvvvvvvvvvvvvvvvvuN3GGsK8dXMn7K7PZ.VHLa6WO9r2', 'María', 'Facturación', 'BILLING', '550e8400-e29b-41d4-a716-446655440001', true),
('130e8400-e29b-41d4-a716-446655440003', 'direccion@cpb.com.ar', '$2a$10$XQKvvvvvvvvvvvvvvvvvvuN3GGsK8dXMn7K7PZ.VHLa6WO9r2', 'Carlos', 'Director', 'COMPANY_ADMIN', '550e8400-e29b-41d4-a716-446655440001', true)
ON CONFLICT ("email") DO NOTHING;

-- ============================================
-- DATOS CARGADOS EXITOSAMENTE
-- ============================================
-- Resumen de datos insertados:
-- - 3 Empresas (CPB, Solar del Rosario, Acompañe y Asiste)
-- - 6 Áreas de Negocio (2 por empresa: Salud Mental + Rehabilitación)
-- - 14 Dispositivos distribuidos en todas las áreas
-- - 5 Obras Sociales (PAMI, OSDE, Swiss Medical, OSMEDICA, Particular)
-- - 8 Convenios activos con diferentes dispositivos
-- - 8 Modalidades de Internación (principalmente PAMI)
-- - 10 Pacientes con diferentes obras sociales
-- - 11 Admisiones (10 activas, 1 dada de alta)
-- - 8 Autorizaciones (7 activas, 1 vencida)
-- - 4 Profesionales
-- - 4 Servicios
-- - 8 Facturas distribuidas en las 3 empresas
-- - 5 Líneas de factura con cálculos de UR
-- - 4 Honorarios profesionales
-- - 3 Usuarios del sistema
-- ============================================
