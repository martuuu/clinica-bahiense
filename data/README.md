# 🎨 Mock Data - Prototipo Rápido

## Estrategia

Para acelerar el desarrollo del MVP, hemos desconectado **temporalmente** las vistas operativa y administrativa de las queries complejas a la base de datos. En su lugar, utilizamos archivos JSON con data pre-armada que permite visualizar completamente las interfaces.

## Archivos

### `mock-operativo.json`
**Propósito:** Simular la vista operativa de gestión de pacientes

**Contenido:**
- ✅ 12 pacientes activos con datos completos
- ✅ Admisiones con diagnósticos CIE-10
- ✅ Autorizaciones con estados y alertas
- ✅ 3 niveles de alertas (crítico, urgente, warning)
- ✅ Evoluciones recientes
- ✅ Stats calculadas (promedio estadía, autorizaciones por vencer, etc.)

**Usado en:**
- `/app/[companyId]/[areaId]/[deviceId]/[insuranceId]/[modalityId]/operativo/page.tsx`

### `mock-administrativo.json`
**Propósito:** Simular la vista administrativa de facturación

**Contenido:**
- ✅ 10 facturas con diferentes estados (PAID, PRESENTED, ISSUED, REJECTED, PARTIALLY_PAID)
- ✅ Distribución por estado para DonutChart
- ✅ 5 profesionales con honorarios (pendientes y pagados)
- ✅ Stats financieras completas
- ✅ Facturación histórica (agosto 2025 - enero 2026)
- ✅ Cálculos de UR y días de cobro

**Usado en:**
- `/app/[companyId]/[areaId]/[deviceId]/[insuranceId]/[modalityId]/administrativo/page.tsx`

## Ventajas de esta Estrategia

### ✅ Velocidad
- **Antes:** 2-3 horas creando queries complejas + seed data masivo
- **Ahora:** 30 minutos con JSON + imports directos

### ✅ Flexibilidad
- Cambiar datos es instantáneo (editar JSON)
- No requiere migraciones ni SQL
- Perfecto para demos y prototipos

### ✅ Claridad
- Los datos están visibles y documentados
- Fácil de entender la estructura esperada
- No depende de estado de base de datos

### ✅ Mantenibilidad
- Desacoplado de la lógica de persistencia
- Se puede cambiar sin afectar otras partes
- Fácil de compartir con el equipo

## Próximos Pasos (Cuando Reconectemos)

Cuando estemos listos para conectar con la base de datos real:

1. **Eliminar import del JSON:**
   ```typescript
   // ❌ Remover
   import mockData from '@/data/mock-operativo.json';
   ```

2. **Restaurar server actions:**
   ```typescript
   // ✅ Agregar
   import { getPatientsByModality } from '@/actions/patients';
   
   // ✅ Descomentar en Promise.all
   const patientsResult = await getPatientsByModality(modalityId);
   ```

3. **Mapear datos reales a la estructura esperada:**
   ```typescript
   const patients = patientsResult.data.map(patient => ({
     id: patient.id,
     firstName: patient.firstName,
     lastName: patient.lastName,
     // ... resto del mapeo
   }));
   ```

## Estructura de Datos

### Vista Operativa

#### Paciente
```typescript
{
  id: string
  dni: string
  firstName: string
  lastName: string
  birthDate: string (ISO date)
  gender: "MALE" | "FEMALE" | "OTHER"
  healthInsurance: string
  affiliateNumber: string
  admission: {
    admissionDate: string (ISO date)
    diagnosis: string
    icd10Code: string
    daysAdmitted: number
    device: string
  }
  authorization: {
    authNumber: string
    authorizedDays: number
    validFrom: string (ISO date)
    validTo: string (ISO date)
    daysRemaining: number
    status: "ACTIVE" | "EXPIRED" | "EXTENDED"
    alert?: string (opcional, para alertas críticas)
  }
  lastEvolution: string (ISO date)
  observations: string
}
```

#### Stats
```typescript
{
  totalPacientesActivos: number
  autorizacionesPorVencer: number
  promedioEstadia: number
  ultimasEvoluciones: number
}
```

### Vista Administrativa

#### Factura
```typescript
{
  id: string
  invoiceNumber: string
  invoiceDate: string (ISO date)
  periodStart: string (ISO date)
  periodEnd: string (ISO date)
  status: "DRAFT" | "ISSUED" | "PRESENTED" | "PAID" | "REJECTED" | "PARTIALLY_PAID"
  healthInsurance: string
  totalAmount: number
  patient: string
  dni: string
  description: string
  urModules: number
  urValue: number
  days: number
  paymentDate?: string (ISO date)
  daysToPayment?: number
  observations: string
}
```

#### Stats Administrativas
```typescript
{
  totalFacturado: number
  totalCobrado: number
  totalPendiente: number
  porcentajeCobrado: number (0-100)
  diasPromedioCobro: number
  facturasPagadas: number
  facturasEmitidas: number
  facturasPresentadas: number
  facturasRechazadas: number
  facturasParciales: number
}
```

## Mantenimiento

### Actualizar Mock Data
1. Editar el archivo JSON correspondiente
2. Mantener la estructura de tipos
3. Validar que las fechas sean coherentes
4. Los cambios se reflejan automáticamente al recargar

### Agregar Nuevos Casos
Para agregar nuevos escenarios de prueba:
1. Duplicar un objeto existente en el array
2. Cambiar IDs y datos relevantes
3. Mantener coherencia en las relaciones (ej: paciente con su admisión)

---

**Nota:** Esta es una solución temporal para acelerar el desarrollo. El objetivo final es conectar con la base de datos Prisma/Supabase usando server actions, pero esta estrategia nos permite avanzar rápidamente en la UI/UX sin bloquearnos en la complejidad del backend.
