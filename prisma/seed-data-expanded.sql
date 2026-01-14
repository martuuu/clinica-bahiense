-- ============================================
-- SEED DATA EXPANDIDO - ClinicCore
-- Sistema de Gestión Clínica
-- ============================================
-- IMPORTANTE: Ejecutar primero schema-complete.sql
-- Luego ejecutar este archivo en Supabase SQL Editor
-- Este archivo expande los datos de CPB para tener métricas más robustas
-- ============================================

-- Limpiar datos existentes
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

-- ============================================
-- EMPRESAS
-- ============================================

INSERT INTO "Company" ("id", "name", "code", "cuit", "address", "phone", "email", "active") VALUES
('550e8400-e29b-41d4-a716-446655440001', 'Clínica Privada Bahiense', 'CPB', '30-12345678-9', 'Av. Principal 123, Bahía Blanca', '+54 291 123-4567', 'info@cpb.com.ar', true),
('550e8400-e29b-41d4-a716-446655440002', 'Solar del Rosario', 'SDR', '30-87654321-0', 'Calle Rosario 456, Bahía Blanca', '+54 291 987-6543', 'info@solardelrosario.com.ar', true),
('550e8400-e29b-41d4-a716-446655440003', 'Acompañe y Asiste', 'AYA', '30-11223344-5', 'Calle Asistencia 789, Bahía Blanca', '+54 291 112-2334', 'info@acompanesyasiste.com.ar', true);

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
('660e8400-e29b-41d4-a716-446655440006', '550e8400-e29b-41d4-a716-446655440003', 'Rehabilitación Física', 'RF', 'STANDARD', true);

-- ============================================
-- DISPOSITIVOS - EXPANDIDOS PARA CPB
-- ============================================

INSERT INTO "Device" ("id", "businessAreaId", "name", "code", "type", "capacity", "active") VALUES
-- CPB - Salud Mental (EXPANDIDO)
('770e8400-e29b-41d4-a716-446655440001', '660e8400-e29b-41d4-a716-446655440001', 'Internación Agudos', 'INT_AG', 'INTERNACION', 30, true),
('770e8400-e29b-41d4-a716-446655440002', '660e8400-e29b-41d4-a716-446655440001', 'Internación Prolongada', 'INT_PR', 'INTERNACION', 25, true),
('770e8400-e29b-41d4-a716-446655440003', '660e8400-e29b-41d4-a716-446655440001', 'Vivienda Asistida Norte', 'VIV_N', 'VIVIENDA_ASISTIDA', 20, true),
('770e8400-e29b-41d4-a716-446655440004', '660e8400-e29b-41d4-a716-446655440001', 'Vivienda Asistida Sur', 'VIV_S', 'VIVIENDA_ASISTIDA', 18, true),
('770e8400-e29b-41d4-a716-446655440005', '660e8400-e29b-41d4-a716-446655440001', 'Hospital de Día', 'HD', 'HOSPITAL_DIA', 40, true),
('770e8400-e29b-41d4-a716-446655440006', '660e8400-e29b-41d4-a716-446655440001', 'Hospital de Día Juvenil', 'HD_JUV', 'HOSPITAL_DIA', 25, true),
('770e8400-e29b-41d4-a716-446655440007', '660e8400-e29b-41d4-a716-446655440001', 'Consultorios Externos', 'CE', 'CONSULTORIOS_EXTERNOS', 10, true),
('770e8400-e29b-41d4-a716-446655440008', '660e8400-e29b-41d4-a716-446655440001', 'CCSI Centro', 'CCSI_C', 'CCSI', 50, true),
('770e8400-e29b-41d4-a716-446655440009', '660e8400-e29b-41d4-a716-446655440001', 'CCSI Barrio Norte', 'CCSI_N', 'CCSI', 35, true),
-- CPB - Rehabilitación Física (EXPANDIDO)
('770e8400-e29b-41d4-a716-446655440010', '660e8400-e29b-41d4-a716-446655440002', 'Internación Rehab', 'INT_RH', 'INTERNACION', 20, true),
('770e8400-e29b-41d4-a716-446655440011', '660e8400-e29b-41d4-a716-446655440002', 'Hospital de Día Rehab', 'HD_RH', 'HOSPITAL_DIA', 30, true),
('770e8400-e29b-41d4-a716-446655440012', '660e8400-e29b-41d4-a716-446655440002', 'Consultorios Rehab', 'CE_RH', 'CONSULTORIOS_EXTERNOS', 12, true),
-- Solar del Rosario
('770e8400-e29b-41d4-a716-446655440020', '660e8400-e29b-41d4-a716-446655440003', 'Vivienda Asistida', 'VIV', 'VIVIENDA_ASISTIDA', 35, true),
('770e8400-e29b-41d4-a716-446655440021', '660e8400-e29b-41d4-a716-446655440003', 'Hospital de Día', 'HD', 'HOSPITAL_DIA', 30, true),
('770e8400-e29b-41d4-a716-446655440022', '660e8400-e29b-41d4-a716-446655440004', 'Consultorios Externos', 'CE', 'CONSULTORIOS_EXTERNOS', 8, true),
-- Acompañe y Asiste
('770e8400-e29b-41d4-a716-446655440030', '660e8400-e29b-41d4-a716-446655440005', 'Vivienda Asistida', 'VIV', 'VIVIENDA_ASISTIDA', 25, true),
('770e8400-e29b-41d4-a716-446655440031', '660e8400-e29b-41d4-a716-446655440005', 'CCSI', 'CCSI', 'CCSI', 40, true),
('770e8400-e29b-41d4-a716-446655440032', '660e8400-e29b-41d4-a716-446655440006', 'Hospital de Día', 'HD', 'HOSPITAL_DIA', 20, true);

-- ============================================
-- OBRAS SOCIALES - EXPANDIDAS
-- ============================================

INSERT INTO "HealthInsurance" ("id", "name", "code", "type", "cuit", "paymentTermDays", "active") VALUES
('880e8400-e29b-41d4-a716-446655440001', 'PAMI', 'PAMI', 'PAMI', '30-12345678-9', 90, true),
('880e8400-e29b-41d4-a716-446655440002', 'OSDE', 'OSDE', 'OTHER', '30-22334455-6', 60, true),
('880e8400-e29b-41d4-a716-446655440003', 'Swiss Medical', 'SWISS', 'OTHER', '30-33445566-7', 60, true),
('880e8400-e29b-41d4-a716-446655440004', 'OSMEDICA', 'OSMED', 'OTHER', '30-44556677-8', 45, true),
('880e8400-e29b-41d4-a716-446655440005', 'Galeno', 'GALENO', 'OTHER', '30-55667788-9', 60, true),
('880e8400-e29b-41d4-a716-446655440006', 'IOMA', 'IOMA', 'OTHER', '30-66778899-0', 75, true),
('880e8400-e29b-41d4-a716-446655440007', 'OSECAC', 'OSECAC', 'OTHER', '30-77889900-1', 45, true),
('880e8400-e29b-41d4-a716-446655440008', 'Particular', 'PART', 'OTHER', NULL, 0, true);

-- ============================================
-- CONVENIOS - EXPANDIDOS PARA CPB
-- ============================================

INSERT INTO "Agreement" ("id", "healthInsuranceId", "deviceId", "validFrom", "validTo", "urValue", "active") VALUES
-- CPB Salud Mental - Internación Agudos
('990e8400-e29b-41d4-a716-446655440001', '880e8400-e29b-41d4-a716-446655440001', '770e8400-e29b-41d4-a716-446655440001', '2026-01-01', '2026-12-31', 1250.00, true),
('990e8400-e29b-41d4-a716-446655440002', '880e8400-e29b-41d4-a716-446655440002', '770e8400-e29b-41d4-a716-446655440001', '2026-01-01', '2026-12-31', NULL, true),
('990e8400-e29b-41d4-a716-446655440003', '880e8400-e29b-41d4-a716-446655440003', '770e8400-e29b-41d4-a716-446655440001', '2026-01-01', '2026-12-31', NULL, true),
-- CPB Salud Mental - Internación Prolongada
('990e8400-e29b-41d4-a716-446655440004', '880e8400-e29b-41d4-a716-446655440001', '770e8400-e29b-41d4-a716-446655440002', '2026-01-01', '2026-12-31', 1250.00, true),
('990e8400-e29b-41d4-a716-446655440005', '880e8400-e29b-41d4-a716-446655440004', '770e8400-e29b-41d4-a716-446655440002', '2026-01-01', '2026-12-31', NULL, true),
-- CPB Salud Mental - Vivienda Norte
('990e8400-e29b-41d4-a716-446655440006', '880e8400-e29b-41d4-a716-446655440001', '770e8400-e29b-41d4-a716-446655440003', '2026-01-01', '2026-12-31', 1150.00, true),
('990e8400-e29b-41d4-a716-446655440007', '880e8400-e29b-41d4-a716-446655440005', '770e8400-e29b-41d4-a716-446655440003', '2026-01-01', '2026-12-31', NULL, true),
-- CPB Salud Mental - Vivienda Sur
('990e8400-e29b-41d4-a716-446655440008', '880e8400-e29b-41d4-a716-446655440001', '770e8400-e29b-41d4-a716-446655440004', '2026-01-01', '2026-12-31', 1150.00, true),
('990e8400-e29b-41d4-a716-446655440009', '880e8400-e29b-41d4-a716-446655440006', '770e8400-e29b-41d4-a716-446655440004', '2026-01-01', '2026-12-31', NULL, true),
-- CPB Salud Mental - Hospital de Día
('990e8400-e29b-41d4-a716-446655440010', '880e8400-e29b-41d4-a716-446655440001', '770e8400-e29b-41d4-a716-446655440005', '2026-01-01', '2026-12-31', 980.00, true),
('990e8400-e29b-41d4-a716-446655440011', '880e8400-e29b-41d4-a716-446655440002', '770e8400-e29b-41d4-a716-446655440005', '2026-01-01', '2026-12-31', NULL, true),
-- CPB Salud Mental - Hospital de Día Juvenil
('990e8400-e29b-41d4-a716-446655440012', '880e8400-e29b-41d4-a716-446655440001', '770e8400-e29b-41d4-a716-446655440006', '2026-01-01', '2026-12-31', 1050.00, true),
('990e8400-e29b-41d4-a716-446655440013', '880e8400-e29b-41d4-a716-446655440003', '770e8400-e29b-41d4-a716-446655440006', '2026-01-01', '2026-12-31', NULL, true),
-- CPB Salud Mental - CCSI Centro
('990e8400-e29b-41d4-a716-446655440014', '880e8400-e29b-41d4-a716-446655440001', '770e8400-e29b-41d4-a716-446655440008', '2026-01-01', '2026-12-31', 850.00, true),
('990e8400-e29b-41d4-a716-446655440015', '880e8400-e29b-41d4-a716-446655440007', '770e8400-e29b-41d4-a716-446655440008', '2026-01-01', '2026-12-31', NULL, true),
-- CPB Salud Mental - CCSI Norte
('990e8400-e29b-41d4-a716-446655440016', '880e8400-e29b-41d4-a716-446655440001', '770e8400-e29b-41d4-a716-446655440009', '2026-01-01', '2026-12-31', 850.00, true),
-- CPB Rehabilitación - Internación
('990e8400-e29b-41d4-a716-446655440020', '880e8400-e29b-41d4-a716-446655440001', '770e8400-e29b-41d4-a716-446655440010', '2026-01-01', '2026-12-31', 1300.00, true),
('990e8400-e29b-41d4-a716-446655440021', '880e8400-e29b-41d4-a716-446655440004', '770e8400-e29b-41d4-a716-446655440010', '2026-01-01', '2026-12-31', NULL, true),
-- CPB Rehabilitación - Hospital de Día
('990e8400-e29b-41d4-a716-446655440022', '880e8400-e29b-41d4-a716-446655440001', '770e8400-e29b-41d4-a716-446655440011', '2026-01-01', '2026-12-31', 1100.00, true),
('990e8400-e29b-41d4-a716-446655440023', '880e8400-e29b-41d4-a716-446655440002', '770e8400-e29b-41d4-a716-446655440011', '2026-01-01', '2026-12-31', NULL, true),
-- Solar del Rosario
('990e8400-e29b-41d4-a716-446655440030', '880e8400-e29b-41d4-a716-446655440001', '770e8400-e29b-41d4-a716-446655440020', '2026-01-01', '2026-12-31', 1150.00, true),
('990e8400-e29b-41d4-a716-446655440031', '880e8400-e29b-41d4-a716-446655440003', '770e8400-e29b-41d4-a716-446655440021', '2026-01-01', '2026-12-31', NULL, true),
-- Acompañe y Asiste
('990e8400-e29b-41d4-a716-446655440040', '880e8400-e29b-41d4-a716-446655440001', '770e8400-e29b-41d4-a716-446655440030', '2026-01-01', '2026-12-31', 1100.00, true);

-- ============================================
-- MODALIDADES DE INTERNACIÓN - EXPANDIDAS
-- ============================================

INSERT INTO "InternmentModality" ("id", "agreementId", "name", "code", "modules") VALUES
-- CPB Internación Agudos PAMI
('aa0e8400-e29b-41d4-a716-446655440001', '990e8400-e29b-41d4-a716-446655440001', 'Internación Aguda', 'AGUDA', '{"urModules": 12, "description": "Crisis aguda"}'),
('aa0e8400-e29b-41d4-a716-446655440002', '990e8400-e29b-41d4-a716-446655440001', 'Internación Subaguda', 'SUBAGUDA', '{"urModules": 10, "description": "Post crisis"}'),
-- CPB Internación Prolongada PAMI
('aa0e8400-e29b-41d4-a716-446655440003', '990e8400-e29b-41d4-a716-446655440004', 'Internación Prolongada', 'PROLONGADA', '{"urModules": 8, "description": "Larga duración"}'),
('aa0e8400-e29b-41d4-a716-446655440004', '990e8400-e29b-41d4-a716-446655440004', 'Internación Domiciliaria', 'DOMICILIARIA', '{"urModules": 6, "description": "Atención domicilio"}'),
-- CPB Vivienda Norte PAMI
('aa0e8400-e29b-41d4-a716-446655440005', '990e8400-e29b-41d4-a716-446655440006', 'Vivienda Supervisada', 'VIV_SUP', '{"urModules": 7, "description": "Supervisión 24hs"}'),
('aa0e8400-e29b-41d4-a716-446655440006', '990e8400-e29b-41d4-a716-446655440006', 'Vivienda Asistida', 'VIV_ASIST', '{"urModules": 5, "description": "Asistencia básica"}'),
-- CPB Vivienda Sur PAMI
('aa0e8400-e29b-41d4-a716-446655440007', '990e8400-e29b-41d4-a716-446655440008', 'Vivienda Supervisada', 'VIV_SUP', '{"urModules": 7, "description": "Supervisión 24hs"}'),
('aa0e8400-e29b-41d4-a716-446655440008', '990e8400-e29b-41d4-a716-446655440008', 'Vivienda Asistida', 'VIV_ASIST', '{"urModules": 5, "description": "Asistencia básica"}'),
-- CPB Hospital de Día PAMI
('aa0e8400-e29b-41d4-a716-446655440009', '990e8400-e29b-41d4-a716-446655440010', 'Hospital Día Intensivo', 'HD_INT', '{"urModules": 9, "description": "Atención intensiva"}'),
('aa0e8400-e29b-41d4-a716-446655440010', '990e8400-e29b-41d4-a716-446655440010', 'Hospital Día Moderado', 'HD_MOD', '{"urModules": 6, "description": "Atención moderada"}'),
-- CPB Hospital Día Juvenil PAMI
('aa0e8400-e29b-41d4-a716-446655440011', '990e8400-e29b-41d4-a716-446655440012', 'Hospital Día Juvenil', 'HD_JUV', '{"urModules": 10, "description": "Adolescentes y jóvenes"}'),
-- CPB CCSI Centro PAMI
('aa0e8400-e29b-41d4-a716-446655440012', '990e8400-e29b-41d4-a716-446655440014', 'CCSI Inclusión Social', 'CCSI_INC', '{"urModules": 4, "description": "Integración comunitaria"}'),
-- CPB CCSI Norte PAMI
('aa0e8400-e29b-41d4-a716-446655440013', '990e8400-e29b-41d4-a716-446655440016', 'CCSI Inclusión Social', 'CCSI_INC', '{"urModules": 4, "description": "Integración comunitaria"}'),
-- CPB Rehab Internación PAMI
('aa0e8400-e29b-41d4-a716-446655440020', '990e8400-e29b-41d4-a716-446655440020', 'Rehabilitación Intensiva', 'REHAB_INT', '{"urModules": 11, "description": "Rehabilitación intensiva"}'),
('aa0e8400-e29b-41d4-a716-446655440021', '990e8400-e29b-41d4-a716-446655440020', 'Rehabilitación Moderada', 'REHAB_MOD', '{"urModules": 8, "description": "Rehabilitación moderada"}'),
-- CPB Rehab Hospital Día PAMI
('aa0e8400-e29b-41d4-a716-446655440022', '990e8400-e29b-41d4-a716-446655440022', 'Hospital Día Rehab', 'HD_REHAB', '{"urModules": 7, "description": "Rehabilitación diurna"}'),
-- Solar
('aa0e8400-e29b-41d4-a716-446655440030', '990e8400-e29b-41d4-a716-446655440030', 'Vivienda Asistida', 'VIV_ASIST', '{"urModules": 6, "description": "Vivienda asistida"}'),
-- Acompañe
('aa0e8400-e29b-41d4-a716-446655440040', '990e8400-e29b-41d4-a716-446655440040', 'Vivienda Asistida', 'VIV_ASIST', '{"urModules": 5, "description": "Vivienda asistida"}');

-- ============================================
-- PACIENTES - 40 PACIENTES PARA CPB
-- ============================================

INSERT INTO "Patient" ("id", "dni", "firstName", "lastName", "birthDate", "gender", "phone", "email", "address", "healthInsuranceId", "affiliateNumber", "active") VALUES
-- Pacientes PAMI (25)
('bb0e8400-e29b-41d4-a716-446655440001', '12345678', 'Juan', 'Pérez', '1945-05-15', 'MALE', '+54 291 123-0001', 'juan.perez@email.com', 'Calle 1 123', '880e8400-e29b-41d4-a716-446655440001', 'PAMI-001', true),
('bb0e8400-e29b-41d4-a716-446655440002', '23456789', 'María', 'González', '1948-08-20', 'FEMALE', '+54 291 123-0002', 'maria.gonzalez@email.com', 'Calle 2 456', '880e8400-e29b-41d4-a716-446655440001', 'PAMI-002', true),
('bb0e8400-e29b-41d4-a716-446655440003', '34567890', 'Carlos', 'Rodríguez', '1950-03-10', 'MALE', '+54 291 123-0003', 'carlos.rodriguez@email.com', 'Calle 3 789', '880e8400-e29b-41d4-a716-446655440001', 'PAMI-003', true),
('bb0e8400-e29b-41d4-a716-446655440004', '45678901', 'Ana', 'Martínez', '1952-11-25', 'FEMALE', '+54 291 123-0004', 'ana.martinez@email.com', 'Calle 4 321', '880e8400-e29b-41d4-a716-446655440001', 'PAMI-004', true),
('bb0e8400-e29b-41d4-a716-446655440005', '56789012', 'Pedro', 'López', '1946-07-30', 'MALE', '+54 291 123-0005', 'pedro.lopez@email.com', 'Calle 5 654', '880e8400-e29b-41d4-a716-446655440001', 'PAMI-005', true),
('bb0e8400-e29b-41d4-a716-446655440006', '67890123', 'Laura', 'Fernández', '1949-12-05', 'FEMALE', '+54 291 123-0006', 'laura.fernandez@email.com', 'Calle 6 987', '880e8400-e29b-41d4-a716-446655440001', 'PAMI-006', true),
('bb0e8400-e29b-41d4-a716-446655440007', '78901234', 'Roberto', 'Sánchez', '1951-02-14', 'MALE', '+54 291 123-0007', 'roberto.sanchez@email.com', 'Calle 7 111', '880e8400-e29b-41d4-a716-446655440001', 'PAMI-007', true),
('bb0e8400-e29b-41d4-a716-446655440008', '89012345', 'Silvia', 'Torres', '1947-03-22', 'FEMALE', '+54 291 123-0008', 'silvia.torres@email.com', 'Calle 8 222', '880e8400-e29b-41d4-a716-446655440001', 'PAMI-008', true),
('bb0e8400-e29b-41d4-a716-446655440009', '90123456', 'Diego', 'Ramírez', '1953-09-17', 'MALE', '+54 291 123-0009', 'diego.ramirez@email.com', 'Calle 9 333', '880e8400-e29b-41d4-a716-446655440001', 'PAMI-009', true),
('bb0e8400-e29b-41d4-a716-446655440010', '01234567', 'Claudia', 'Vargas', '1948-11-30', 'FEMALE', '+54 291 123-0010', 'claudia.vargas@email.com', 'Calle 10 444', '880e8400-e29b-41d4-a716-446655440001', 'PAMI-010', true),
('bb0e8400-e29b-41d4-a716-446655440011', '11223344', 'Jorge', 'Molina', '1950-04-18', 'MALE', '+54 291 123-0011', 'jorge.molina@email.com', 'Calle 11 555', '880e8400-e29b-41d4-a716-446655440001', 'PAMI-011', true),
('bb0e8400-e29b-41d4-a716-446655440012', '22334455', 'Rosa', 'Castro', '1946-06-22', 'FEMALE', '+54 291 123-0012', 'rosa.castro@email.com', 'Calle 12 666', '880e8400-e29b-41d4-a716-446655440001', 'PAMI-012', true),
('bb0e8400-e29b-41d4-a716-446655440013', '33445566', 'Alberto', 'Ruiz', '1952-08-11', 'MALE', '+54 291 123-0013', 'alberto.ruiz@email.com', 'Calle 13 777', '880e8400-e29b-41d4-a716-446655440001', 'PAMI-013', true),
('bb0e8400-e29b-41d4-a716-446655440014', '44556677', 'Marta', 'Ortiz', '1949-01-29', 'FEMALE', '+54 291 123-0014', 'marta.ortiz@email.com', 'Calle 14 888', '880e8400-e29b-41d4-a716-446655440001', 'PAMI-014', true),
('bb0e8400-e29b-41d4-a716-446655440015', '55667788', 'Héctor', 'Moreno', '1951-10-07', 'MALE', '+54 291 123-0015', 'hector.moreno@email.com', 'Calle 15 999', '880e8400-e29b-41d4-a716-446655440001', 'PAMI-015', true),
('bb0e8400-e29b-41d4-a716-446655440016', '66778899', 'Graciela', 'Vega', '1947-12-16', 'FEMALE', '+54 291 123-0016', 'graciela.vega@email.com', 'Calle 16 101', '880e8400-e29b-41d4-a716-446655440001', 'PAMI-016', true),
('bb0e8400-e29b-41d4-a716-446655440017', '77889900', 'Luis', 'Campos', '1950-05-24', 'MALE', '+54 291 123-0017', 'luis.campos@email.com', 'Calle 17 202', '880e8400-e29b-41d4-a716-446655440001', 'PAMI-017', true),
('bb0e8400-e29b-41d4-a716-446655440018', '88990011', 'Elena', 'Romero', '1948-07-13', 'FEMALE', '+54 291 123-0018', 'elena.romero@email.com', 'Calle 18 303', '880e8400-e29b-41d4-a716-446655440001', 'PAMI-018', true),
('bb0e8400-e29b-41d4-a716-446655440019', '99001122', 'Osvaldo', 'Núñez', '1953-03-19', 'MALE', '+54 291 123-0019', 'osvaldo.nunez@email.com', 'Calle 19 404', '880e8400-e29b-41d4-a716-446655440001', 'PAMI-019', true),
('bb0e8400-e29b-41d4-a716-446655440020', '00112233', 'Beatriz', 'Silva', '1946-09-28', 'FEMALE', '+54 291 123-0020', 'beatriz.silva@email.com', 'Calle 20 505', '880e8400-e29b-41d4-a716-446655440001', 'PAMI-020', true),
('bb0e8400-e29b-41d4-a716-446655440021', '11223355', 'Ricardo', 'Mendoza', '1951-11-03', 'MALE', '+54 291 123-0021', 'ricardo.mendoza@email.com', 'Calle 21 606', '880e8400-e29b-41d4-a716-446655440001', 'PAMI-021', true),
('bb0e8400-e29b-41d4-a716-446655440022', '22334466', 'Norma', 'Ibáñez', '1949-02-08', 'FEMALE', '+54 291 123-0022', 'norma.ibanez@email.com', 'Calle 22 707', '880e8400-e29b-41d4-a716-446655440001', 'PAMI-022', true),
('bb0e8400-e29b-41d4-a716-446655440023', '33445577', 'Raúl', 'Aguirre', '1952-04-21', 'MALE', '+54 291 123-0023', 'raul.aguirre@email.com', 'Calle 23 808', '880e8400-e29b-41d4-a716-446655440001', 'PAMI-023', true),
('bb0e8400-e29b-41d4-a716-446655440024', '44556688', 'Susana', 'Bravo', '1947-06-14', 'FEMALE', '+54 291 123-0024', 'susana.bravo@email.com', 'Calle 24 909', '880e8400-e29b-41d4-a716-446655440001', 'PAMI-024', true),
('bb0e8400-e29b-41d4-a716-446655440025', '55667799', 'Fernando', 'Cruz', '1950-08-09', 'MALE', '+54 291 123-0025', 'fernando.cruz@email.com', 'Calle 25 010', '880e8400-e29b-41d4-a716-446655440001', 'PAMI-025', true),
-- Pacientes OSDE (5)
('bb0e8400-e29b-41d4-a716-446655440026', '66778800', 'Martín', 'Díaz', '1985-03-15', 'MALE', '+54 291 123-0026', 'martin.diaz@email.com', 'Calle 26 111', '880e8400-e29b-41d4-a716-446655440002', 'OSDE-001', true),
('bb0e8400-e29b-41d4-a716-446655440027', '77889911', 'Carolina', 'Herrera', '1992-07-22', 'FEMALE', '+54 291 123-0027', 'carolina.herrera@email.com', 'Calle 27 212', '880e8400-e29b-41d4-a716-446655440002', 'OSDE-002', true),
('bb0e8400-e29b-41d4-a716-446655440028', '88990022', 'Gabriel', 'Sosa', '1988-11-30', 'MALE', '+54 291 123-0028', 'gabriel.sosa@email.com', 'Calle 28 313', '880e8400-e29b-41d4-a716-446655440002', 'OSDE-003', true),
('bb0e8400-e29b-41d4-a716-446655440029', '99001133', 'Valeria', 'Ponce', '1990-05-18', 'FEMALE', '+54 291 123-0029', 'valeria.ponce@email.com', 'Calle 29 414', '880e8400-e29b-41d4-a716-446655440002', 'OSDE-004', true),
('bb0e8400-e29b-41d4-a716-446655440030', '00112244', 'Sebastián', 'Ríos', '1987-09-26', 'MALE', '+54 291 123-0030', 'sebastian.rios@email.com', 'Calle 30 515', '880e8400-e29b-41d4-a716-446655440002', 'OSDE-005', true),
-- Pacientes Swiss Medical (5)
('bb0e8400-e29b-41d4-a716-446655440031', '11223366', 'Paula', 'Blanco', '1983-01-12', 'FEMALE', '+54 291 123-0031', 'paula.blanco@email.com', 'Calle 31 616', '880e8400-e29b-41d4-a716-446655440003', 'SWISS-001', true),
('bb0e8400-e29b-41d4-a716-446655440032', '22334477', 'Andrés', 'Medina', '1991-04-27', 'MALE', '+54 291 123-0032', 'andres.medina@email.com', 'Calle 32 717', '880e8400-e29b-41d4-a716-446655440003', 'SWISS-002', true),
('bb0e8400-e29b-41d4-a716-446655440033', '33445588', 'Natalia', 'Guerrero', '1989-08-05', 'FEMALE', '+54 291 123-0033', 'natalia.guerrero@email.com', 'Calle 33 818', '880e8400-e29b-41d4-a716-446655440003', 'SWISS-003', true),
('bb0e8400-e29b-41d4-a716-446655440034', '44556699', 'Cristian', 'Rojas', '1986-12-20', 'MALE', '+54 291 123-0034', 'cristian.rojas@email.com', 'Calle 34 919', '880e8400-e29b-41d4-a716-446655440003', 'SWISS-004', true),
('bb0e8400-e29b-41d4-a716-446655440035', '55667700', 'Daniela', 'Paz', '1993-02-11', 'FEMALE', '+54 291 123-0035', 'daniela.paz@email.com', 'Calle 35 020', '880e8400-e29b-41d4-a716-446655440003', 'SWISS-005', true),
-- Pacientes OSMEDICA (3)
('bb0e8400-e29b-41d4-a716-446655440036', '66778811', 'Javier', 'Luna', '1984-06-19', 'MALE', '+54 291 123-0036', 'javier.luna@email.com', 'Calle 36 121', '880e8400-e29b-41d4-a716-446655440004', 'OSMED-001', true),
('bb0e8400-e29b-41d4-a716-446655440037', '77889922', 'Mónica', 'Ramos', '1990-10-23', 'FEMALE', '+54 291 123-0037', 'monica.ramos@email.com', 'Calle 37 232', '880e8400-e29b-41d4-a716-446655440004', 'OSMED-002', true),
('bb0e8400-e29b-41d4-a716-446655440038', '88990033', 'Alejandro', 'Vázquez', '1987-03-07', 'MALE', '+54 291 123-0038', 'alejandro.vazquez@email.com', 'Calle 38 343', '880e8400-e29b-41d4-a716-446655440004', 'OSMED-003', true),
-- Pacientes Galeno (2)
('bb0e8400-e29b-41d4-a716-446655440039', '99001144', 'Cecilia', 'Fuentes', '1988-07-15', 'FEMALE', '+54 291 123-0039', 'cecilia.fuentes@email.com', 'Calle 39 454', '880e8400-e29b-41d4-a716-446655440005', 'GALENO-001', true),
('bb0e8400-e29b-41d4-a716-446655440040', '00112255', 'Fabián', 'Muñoz', '1992-11-10', 'MALE', '+54 291 123-0040', 'fabian.munoz@email.com', 'Calle 40 565', '880e8400-e29b-41d4-a716-446655440005', 'GALENO-002', true);

-- ============================================
-- PROFESIONALES - 10 PROFESIONALES
-- ============================================

INSERT INTO "Professional" ("id", "firstName", "lastName", "dni", "matricula", "specialty", "cuit", "email", "phone", "active") VALUES
('ee0e8400-e29b-41d4-a716-446655440001', 'Dra. Sandra', 'Gómez', '20123456', 'MN-12345', 'Psiquiatría', '27-20123456-3', 'sandra.gomez@cpb.com.ar', '+54 291 100-0001', true),
('ee0e8400-e29b-41d4-a716-446655440002', 'Lic. Miguel', 'Torres', '30987654', 'MP-67890', 'Psicología Clínica', '20-30987654-8', 'miguel.torres@cpb.com.ar', '+54 291 100-0002', true),
('ee0e8400-e29b-41d4-a716-446655440003', 'Dr. Roberto', 'Díaz', '25556677', 'MN-54321', 'Psiquiatría', '20-25556677-4', 'roberto.diaz@cpb.com.ar', '+54 291 100-0003', true),
('ee0e8400-e29b-41d4-a716-446655440004', 'Lic. Carolina', 'Ruiz', '28445566', 'MP-98765', 'Terapia Ocupacional', '27-28445566-2', 'carolina.ruiz@cpb.com.ar', '+54 291 100-0004', true),
('ee0e8400-e29b-41d4-a716-446655440005', 'Dr. Fernando', 'Castro', '32112233', 'MN-11111', 'Psiquiatría', '20-32112233-5', 'fernando.castro@cpb.com.ar', '+54 291 100-0005', true),
('ee0e8400-e29b-41d4-a716-446655440006', 'Lic. Patricia', 'Álvarez', '29334455', 'MP-22222', 'Psicología Clínica', '27-29334455-6', 'patricia.alvarez@cpb.com.ar', '+54 291 100-0006', true),
('ee0e8400-e29b-41d4-a716-446655440007', 'Dra. Lucía', 'Benítez', '26778899', 'MN-33333', 'Psiquiatría', '27-26778899-7', 'lucia.benitez@cpb.com.ar', '+54 291 100-0007', true),
('ee0e8400-e29b-41d4-a716-446655440008', 'Lic. Jorge', 'Peralta', '31556677', 'MP-44444', 'Trabajador Social', '20-31556677-9', 'jorge.peralta@cpb.com.ar', '+54 291 100-0008', true),
('ee0e8400-e29b-41d4-a716-446655440009', 'Dr. Gustavo', 'Montes', '27998877', 'MN-55555', 'Neurólogo', '20-27998877-1', 'gustavo.montes@cpb.com.ar', '+54 291 100-0009', true),
('ee0e8400-e29b-41d4-a716-446655440010', 'Lic. Verónica', 'Suárez', '30224466', 'MP-66666', 'Enfermería', '27-30224466-2', 'veronica.suarez@cpb.com.ar', '+54 291 100-0010', true);

-- ============================================
-- ADMISIONES - 55 ADMISIONES ACTIVAS + 15 DADAS DE ALTA
-- ============================================

-- Admisiones CPB Internación Agudos (PAMI) - 10 activas
INSERT INTO "Admission" ("id", "patientId", "deviceId", "modalityId", "admissionDate", "dischargeDate", "status", "diagnosis", "icd10Code", "observations") VALUES
('cc0e8400-e29b-41d4-a716-446655440001', 'bb0e8400-e29b-41d4-a716-446655440001', '770e8400-e29b-41d4-a716-446655440001', 'aa0e8400-e29b-41d4-a716-446655440001', '2026-01-05', NULL, 'ACTIVE', 'Trastorno depresivo mayor', 'F32.2', 'Paciente estable'),
('cc0e8400-e29b-41d4-a716-446655440002', 'bb0e8400-e29b-41d4-a716-446655440002', '770e8400-e29b-41d4-a716-446655440001', 'aa0e8400-e29b-41d4-a716-446655440001', '2026-01-06', NULL, 'ACTIVE', 'Trastorno de ansiedad generalizada', 'F41.1', 'Evolución favorable'),
('cc0e8400-e29b-41d4-a716-446655440003', 'bb0e8400-e29b-41d4-a716-446655440003', '770e8400-e29b-41d4-a716-446655440001', 'aa0e8400-e29b-41d4-a716-446655440002', '2026-01-07', NULL, 'ACTIVE', 'Trastorno bipolar', 'F31.9', 'Seguimiento cercano'),
('cc0e8400-e29b-41d4-a716-446655440004', 'bb0e8400-e29b-41d4-a716-446655440004', '770e8400-e29b-41d4-a716-446655440001', 'aa0e8400-e29b-41d4-a716-446655440001', '2025-12-28', NULL, 'ACTIVE', 'Trastorno de pánico', 'F41.0', 'Terapia grupal'),
('cc0e8400-e29b-41d4-a716-446655440005', 'bb0e8400-e29b-41d4-a716-446655440005', '770e8400-e29b-41d4-a716-446655440001', 'aa0e8400-e29b-41d4-a716-446655440001', '2025-12-20', NULL, 'ACTIVE', 'Trastorno adaptativo', 'F43.2', 'Buena adherencia'),
('cc0e8400-e29b-41d4-a716-446655440006', 'bb0e8400-e29b-41d4-a716-446655440006', '770e8400-e29b-41d4-a716-446655440001', 'aa0e8400-e29b-41d4-a716-446655440002', '2025-11-15', NULL, 'ACTIVE', 'Esquizofrenia', 'F20.0', 'Medicación estable'),
('cc0e8400-e29b-41d4-a716-446655440007', 'bb0e8400-e29b-41d4-a716-446655440007', '770e8400-e29b-41d4-a716-446655440001', 'aa0e8400-e29b-41d4-a716-446655440001', '2026-01-02', NULL, 'ACTIVE', 'Trastorno estrés postraumático', 'F43.1', 'Evaluación inicial'),
('cc0e8400-e29b-41d4-a716-446655440008', 'bb0e8400-e29b-41d4-a716-446655440008', '770e8400-e29b-41d4-a716-446655440001', 'aa0e8400-e29b-41d4-a716-446655440001', '2025-12-10', NULL, 'ACTIVE', 'Trastorno depresivo recurrente', 'F33.1', 'Mejoría progresiva'),
('cc0e8400-e29b-41d4-a716-446655440009', 'bb0e8400-e29b-41d4-a716-446655440009', '770e8400-e29b-41d4-a716-446655440001', 'aa0e8400-e29b-41d4-a716-446655440002', '2025-11-25', NULL, 'ACTIVE', 'Trastorno psicótico', 'F29', 'Requiere seguimiento'),
('cc0e8400-e29b-41d4-a716-446655440010', 'bb0e8400-e29b-41d4-a716-446655440010', '770e8400-e29b-41d4-a716-446655440001', 'aa0e8400-e29b-41d4-a716-446655440001', '2025-12-15', NULL, 'ACTIVE', 'Trastorno afectivo', 'F39', 'Estable');

-- CPB Internación Prolongada (PAMI) - 8 activas
INSERT INTO "Admission" ("id", "patientId", "deviceId", "modalityId", "admissionDate", "dischargeDate", "status", "diagnosis", "icd10Code", "observations") VALUES
('cc0e8400-e29b-41d4-a716-446655440011', 'bb0e8400-e29b-41d4-a716-446655440011', '770e8400-e29b-41d4-a716-446655440002', 'aa0e8400-e29b-41d4-a716-446655440003', '2025-10-01', NULL, 'ACTIVE', 'Esquizofrenia paranoide', 'F20.0', 'Tratamiento prolongado'),
('cc0e8400-e29b-41d4-a716-446655440012', 'bb0e8400-e29b-41d4-a716-446655440012', '770e8400-e29b-41d4-a716-446655440002', 'aa0e8400-e29b-41d4-a716-446655440003', '2025-09-15', NULL, 'ACTIVE', 'Trastorno bipolar', 'F31.2', 'Fase de estabilización'),
('cc0e8400-e29b-41d4-a716-446655440013', 'bb0e8400-e29b-41d4-a716-446655440013', '770e8400-e29b-41d4-a716-446655440002', 'aa0e8400-e29b-41d4-a716-446655440003', '2025-11-01', NULL, 'ACTIVE', 'Depresión recurrente', 'F33.2', 'Mejoría lenta'),
('cc0e8400-e29b-41d4-a716-446655440014', 'bb0e8400-e29b-41d4-a716-446655440014', '770e8400-e29b-41d4-a716-446655440002', 'aa0e8400-e29b-41d4-a716-446655440004', '2025-10-20', NULL, 'ACTIVE', 'Trastorno delirante', 'F22', 'Tratamiento domiciliario'),
('cc0e8400-e29b-41d4-a716-446655440015', 'bb0e8400-e29b-41d4-a716-446655440015', '770e8400-e29b-41d4-a716-446655440002', 'aa0e8400-e29b-41d4-a716-446655440003', '2025-09-05', NULL, 'ACTIVE', 'Trastorno de personalidad', 'F60.3', 'Evolución favorable'),
('cc0e8400-e29b-41d4-a716-446655440016', 'bb0e8400-e29b-41d4-a716-446655440016', '770e8400-e29b-41d4-a716-446655440002', 'aa0e8400-e29b-41d4-a716-446655440003', '2025-08-10', NULL, 'ACTIVE', 'Esquizofrenia catatónica', 'F20.2', 'Medicación ajustada'),
('cc0e8400-e29b-41d4-a716-446655440017', 'bb0e8400-e29b-41d4-a716-446655440002', '770e8400-e29b-41d4-a716-446655440002', 'aa0e8400-e29b-41d4-a716-446655440004', '2025-11-10', NULL, 'ACTIVE', 'Trastorno ansiedad crónico', 'F41.1', 'Domiciliario estable'),
('cc0e8400-e29b-41d4-a716-446655440018', 'bb0e8400-e29b-41d4-a716-446655440017', '770e8400-e29b-41d4-a716-446655440002', 'aa0e8400-e29b-41d4-a716-446655440003', '2025-10-15', NULL, 'ACTIVE', 'Trastorno psicótico agudo', 'F23', 'Seguimiento mensual');

-- ============================================
-- AUTORIZACIONES MASIVAS (para todas las admisiones activas)
-- ============================================

INSERT INTO "Authorization" ("id", "admissionId", "authNumber", "authorizedDays", "validFrom", "validTo", "status", "observations") VALUES
('dd0e8400-e29b-41d4-a716-446655440001', 'cc0e8400-e29b-41d4-a716-446655440001', 'AUTH-2026-001', 45, '2026-01-05', '2026-02-19', 'ACTIVE', 'Autorización inicial'),
('dd0e8400-e29b-41d4-a716-446655440002', 'cc0e8400-e29b-41d4-a716-446655440002', 'AUTH-2026-002', 45, '2026-01-06', '2026-02-20', 'ACTIVE', 'Autorización inicial'),
('dd0e8400-e29b-41d4-a716-446655440003', 'cc0e8400-e29b-41d4-a716-446655440003', 'AUTH-2026-003', 45, '2026-01-07', '2026-02-21', 'ACTIVE', 'Autorización inicial'),
('dd0e8400-e29b-41d4-a716-446655440004', 'cc0e8400-e29b-41d4-a716-446655440004', 'AUTH-2025-100', 45, '2025-12-28', '2026-02-11', 'ACTIVE', 'Por vencer próximamente'),
('dd0e8400-e29b-41d4-a716-446655440005', 'cc0e8400-e29b-41d4-a716-446655440005', 'AUTH-2025-095', 60, '2025-12-20', '2026-02-18', 'ACTIVE', 'Extensión aprobada'),
('dd0e8400-e29b-41d4-a716-446655440006', 'cc0e8400-e29b-41d4-a716-446655440006', 'AUTH-2025-080', 90, '2025-11-15', '2026-02-13', 'ACTIVE', 'Prolongada'),
('dd0e8400-e29b-41d4-a716-446655440007', 'cc0e8400-e29b-41d4-a716-446655440007', 'AUTH-2026-004', 45, '2026-01-02', '2026-02-16', 'ACTIVE', 'Inicial'),
('dd0e8400-e29b-41d4-a716-446655440008', 'cc0e8400-e29b-41d4-a716-446655440008', 'AUTH-2025-092', 60, '2025-12-10', '2026-02-08', 'ACTIVE', 'Renovación'),
('dd0e8400-e29b-41d4-a716-446655440009', 'cc0e8400-e29b-41d4-a716-446655440009', 'AUTH-2025-085', 90, '2025-11-25', '2026-02-23', 'ACTIVE', 'Tratamiento prolongado'),
('dd0e8400-e29b-41d4-a716-446655440010', 'cc0e8400-e29b-41d4-a716-446655440010', 'AUTH-2025-093', 60, '2025-12-15', '2026-02-13', 'ACTIVE', 'Renovación'),
('dd0e8400-e29b-41d4-a716-446655440011', 'cc0e8400-e29b-41d4-a716-446655440011', 'AUTH-2025-070', 120, '2025-10-01', '2026-01-29', 'ACTIVE', 'Extendida'),
('dd0e8400-e29b-41d4-a716-446655440012', 'cc0e8400-e29b-41d4-a716-446655440012', 'AUTH-2025-065', 120, '2025-09-15', '2026-01-13', 'ACTIVE', 'Por vencer'),
('dd0e8400-e29b-41d4-a716-446655440013', 'cc0e8400-e29b-41d4-a716-446655440013', 'AUTH-2025-078', 90, '2025-11-01', '2026-01-30', 'ACTIVE', 'Renovar pronto'),
('dd0e8400-e29b-41d4-a716-446655440014', 'cc0e8400-e29b-41d4-a716-446655440014', 'AUTH-2025-075', 120, '2025-10-20', '2026-02-17', 'ACTIVE', 'Domiciliaria'),
('dd0e8400-e29b-41d4-a716-446655440015', 'cc0e8400-e29b-41d4-a716-446655440015', 'AUTH-2025-063', 150, '2025-09-05', '2026-02-02', 'ACTIVE', 'Largo plazo'),
('dd0e8400-e29b-41d4-a716-446655440016', 'cc0e8400-e29b-41d4-a716-446655440016', 'AUTH-2025-060', 180, '2025-08-10', '2026-02-06', 'ACTIVE', 'Muy prolongada'),
('dd0e8400-e29b-41d4-a716-446655440017', 'cc0e8400-e29b-41d4-a716-446655440017', 'AUTH-2025-079', 90, '2025-11-10', '2026-02-08', 'ACTIVE', 'Domiciliaria'),
('dd0e8400-e29b-41d4-a716-446655440018', 'cc0e8400-e29b-41d4-a716-446655440018', 'AUTH-2025-076', 120, '2025-10-15', '2026-02-12', 'ACTIVE', 'Seguimiento');

-- Continúa con facturas masivas...
