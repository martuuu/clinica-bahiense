# Base de Datos - ClinicCore

## ⚠️ IMPORTANTE

**NO USAR `prisma db push` o `prisma db pull`**

Estos comandos NO funcionan con Supabase Connection Pooler. **SIEMPRE usa SQL Editor de Supabase.**

---

## 📋 Archivos SQL Definitivos

### 1. `schema-complete.sql` - Esquema Completo
**Contiene:** Toda la estructura de la base de datos
- Extensiones (UUID)
- Enums (tipos de datos)
- Tablas completas con relaciones
- Índices optimizados
- Triggers para `updatedAt`

### 2. `seed-data.sql` - Datos de Prueba
**Contiene:** Datos iniciales para desarrollo y testing
- 3 Empresas
- 2 Áreas de Negocio
- 5 Dispositivos
- 5 Obras Sociales
- Convenios, modalidades, pacientes, admisiones, etc.

---

## 🚀 Proceso de Instalación

### Paso 1: Ejecutar Esquema

1. Ve a **Supabase Dashboard** → https://supabase.com/dashboard
2. Selecciona tu proyecto
3. Ve a **SQL Editor**
4. Copia el contenido de `schema-complete.sql`
5. Pégalo en el editor
6. Presiona **RUN** (o Ctrl/Cmd + Enter)
7. Espera a que termine ✅

### Paso 2: Cargar Datos de Prueba

1. En el mismo **SQL Editor**
2. Copia el contenido de `seed-data.sql`
3. Pégalo en el editor
4. Presiona **RUN** (o Ctrl/Cmd + Enter)
5. Espera a que termine ✅

### Paso 3: Verificar

1. Ve a **Table Editor** en Supabase
2. Verifica que existan las tablas:
   - Company (3 registros)
   - BusinessArea (2 registros)
   - Device (5 registros)
   - Patient (7 registros)
   - etc.

---

## 🗑️ Limpiar y Recrear

Si necesitas limpiar TODO y empezar de cero:

1. **Descomentar** la sección DROP en `schema-complete.sql`
2. Ejecutar `schema-complete.sql` completo
3. Ejecutar `seed-data.sql`

O puedes descomentar la sección TRUNCATE en `seed-data.sql` para solo limpiar datos.

---

## 📊 Datos que se Cargan

### Empresas (3)
- Clínica Privada Bahiense (CPB)
- Solar del Rosario (SDR)
- Acompañe y Asiste (AYA)

### Áreas de Negocio (2)
- Salud Mental
- Rehabilitación Física

### Dispositivos (5)
- Internación (30 camas)
- Vivienda Asistida (20 camas)
- Hospital de Día (40 cupos)
- Consultorios Externos (10 consultorios)
- CCSI (50 cupos)

### Obras Sociales (5)
- PAMI (90 días plazo de pago)
- OSDE (60 días)
- Swiss Medical (60 días)
- OSMEDICA (45 días)
- Particular (inmediato)

### Pacientes (7)
Con diferentes obras sociales y admisiones activas

### Facturas (4)
- Total: $1,055,000
- Estados: ISSUED, PRESENTED, PAID
- Con líneas de factura calculadas en UR para PAMI

---

## 🔧 Después de Cargar los Datos

### Regenerar Cliente de Prisma

Aunque no usamos push/pull, SÍ necesitamos regenerar el cliente:

```bash
cd clinica-bahiense
npx prisma generate
```

Esto crea el cliente de TypeScript basado en `schema.prisma`.

---

## 🐛 Solución de Problemas

### Error: "column does not exist"
✅ **Solución:** Ejecuta primero `schema-complete.sql` completo

### Error: "type does not exist"
✅ **Solución:** Verifica que los ENUMs se crearon correctamente

### Error: "violates foreign key constraint"
✅ **Solución:** Los datos en `seed-data.sql` están ordenados correctamente. Verifica que ejecutaste `schema-complete.sql` primero.

### Error: "duplicate key value"
✅ **Solución:** Ya existen datos. Limpia con TRUNCATE o DROP antes de reinsertar.

---

## � Notas Importantes

1. **Supabase Connection Pooler** usa modo transaccional que no soporta comandos DDL de Prisma
2. **Prisma 7** cambió la configuración de datasource, por eso usamos SQL directo
3. Los **UUIDs son fijos** en seed para facilitar referencias
4. **Passwords de usuarios** son placeholders, en producción usar bcrypt real
5. **Todos los nombres de columnas** usan comillas dobles para PostgreSQL case-sensitivity

---

## 📚 Archivos Obsoletos

Los siguientes archivos NO se deben usar:
- ❌ `supabase-schema.sql` (viejo, incompleto)
- ❌ `supabase-seed.sql` (viejo, incompleto)
- ❌ `seed.ts` (no funciona con Prisma 7)

Usa solo:
- ✅ `schema-complete.sql`
- ✅ `seed-data.sql`

---

## ✅ Checklist de Verificación

Después de ejecutar ambos archivos SQL:

- [ ] Extensión UUID habilitada
- [ ] Todos los ENUMs creados (9 tipos)
- [ ] Todas las tablas creadas (19 tablas)
- [ ] Índices creados
- [ ] Triggers de updatedAt funcionando
- [ ] 3 Empresas insertadas
- [ ] 7 Pacientes insertados
- [ ] 4 Facturas insertadas
- [ ] Cliente Prisma regenerado (`npx prisma generate`)
- [ ] Aplicación Next.js funcionando sin errores

---

## 🆘 Soporte

Si tienes problemas:
1. Verifica que estás en el **SQL Editor** de Supabase
2. Verifica que la base de datos está **vacía** o **limpia**
3. Ejecuta `schema-complete.sql` **primero**
4. Luego ejecuta `seed-data.sql`
5. Finalmente `npx prisma generate`

