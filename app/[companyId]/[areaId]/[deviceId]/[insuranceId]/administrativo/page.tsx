import { Card, Table, TableHead, TableRow, TableHeaderCell, TableBody, TableCell, Badge } from '@tremor/react';
import { FileText, DollarSign, TrendingUp, AlertTriangle, Users } from 'lucide-react';
import { notFound } from 'next/navigation';
import { BreadcrumbNav } from '@/components/navigation/breadcrumb-nav';
import { PeriodDisplay } from '@/components/navigation/period-display';
import { StatusDonutChart } from '@/components/charts/status-donut-chart';
import { getCompanyById } from '@/actions/companies';
import { getBusinessAreaById } from '@/actions/business-areas';
import { getDeviceById } from '@/actions/devices';
import { getHealthInsuranceById } from '@/actions/health-insurances';
// Mock data - Prototipo rápido (Nivel Insurance sin modalidad)
import mockData from '@/data/mock-administrativo.json';

const STATUS_MAP: Record<string, { label: string; color: 'green' | 'yellow' | 'red' | 'blue' | 'gray' | 'orange' }> = {
  DRAFT: { label: 'Borrador', color: 'gray' },
  ISSUED: { label: 'Emitida', color: 'blue' },
  PRESENTED: { label: 'Presentada', color: 'yellow' },
  PAID: { label: 'Pagada', color: 'green' },
  REJECTED: { label: 'Rechazada', color: 'red' },
  PARTIALLY_PAID: { label: 'Pago Parcial', color: 'orange' },
};

export default async function AdministrativoPage({ 
  params 
}: { 
  params: Promise<{ 
    companyId: string; 
    areaId: string; 
    deviceId: string; 
    insuranceId: string;
  }> 
}) {
  const { companyId, areaId, deviceId, insuranceId } = await params;
  
  const [companyResult, areaResult, deviceResult, insuranceResult] = await Promise.all([
    getCompanyById(companyId),
    getBusinessAreaById(areaId),
    getDeviceById(deviceId),
    getHealthInsuranceById(insuranceId),
  ]);
  
  if (!companyResult.success || !companyResult.data) {
    notFound();
  }
  
  if (!areaResult.success || !areaResult.data) {
    notFound();
  }
  
  if (!deviceResult.success || !deviceResult.data) {
    notFound();
  }
  
  if (!insuranceResult.success || !insuranceResult.data) {
    notFound();
  }
  
  const company = companyResult.data;
  const area = areaResult.data;
  const device = deviceResult.data;
  const insurance = insuranceResult.data;
  
  // 🎨 MOCK DATA - Prototipo rápido
  const invoices = mockData.invoices;
  const stats = mockData.stats;
  const statusDistribution = mockData.statusDistribution;
  const professionalFees = mockData.professionalFees;
  const honorariosStats = mockData.honorariosStats;

  const breadcrumbs = [
    { label: company.name, href: `/${companyId}` },
    { label: area.name, href: `/${companyId}/${areaId}` },
    { label: device.name, href: `/${companyId}/${areaId}/${deviceId}` },
    { label: insurance.name, href: `/${companyId}/${areaId}/${deviceId}/${insuranceId}` },
    { label: 'Administrativo', href: `/${companyId}/${areaId}/${deviceId}/${insuranceId}/administrativo` },
  ];

  return (
    <main className="min-h-screen bg-gray-50 p-8">
      <div className="mx-auto max-w-7xl">
        <div className="flex items-center justify-between mb-6">
          <BreadcrumbNav breadcrumbs={breadcrumbs} />
          <PeriodDisplay />
        </div>

        <div className="mb-8">
          <h1 className="text-3xl font-bold text-gray-900">Vista Administrativa</h1>
          <p className="mt-2 text-gray-600">Facturación y honorarios - {insurance.name}</p>
        </div>

        {/* Stats Cards */}
        <div className="grid grid-cols-1 md:grid-cols-4 gap-6 mb-8">
          <Card className="p-6">
            <div className="flex items-center justify-between">
              <div>
                <div className="text-sm text-gray-600">Total Facturado</div>
                <div className="text-2xl font-bold text-gray-900 mt-2">
                  ${stats.totalFacturado.toLocaleString('es-AR')}
                </div>
              </div>
              <FileText className="h-8 w-8 text-blue-600" />
            </div>
          </Card>

          <Card className="p-6">
            <div className="flex items-center justify-between">
              <div>
                <div className="text-sm text-gray-600">Total Cobrado</div>
                <div className="text-2xl font-bold text-green-600 mt-2">
                  ${stats.totalCobrado.toLocaleString('es-AR')}
                </div>
              </div>
              <DollarSign className="h-8 w-8 text-green-600" />
            </div>
          </Card>

          <Card className="p-6">
            <div className="flex items-center justify-between">
              <div>
                <div className="text-sm text-gray-600">Pendiente de Cobro</div>
                <div className="text-2xl font-bold text-orange-600 mt-2">
                  ${stats.totalPendiente.toLocaleString('es-AR')}
                </div>
              </div>
              <AlertTriangle className="h-8 w-8 text-orange-600" />
            </div>
          </Card>

          <Card className="p-6">
            <div className="flex items-center justify-between">
              <div>
                <div className="text-sm text-gray-600">% Cobrado</div>
                <div className="text-2xl font-bold text-gray-900 mt-2">
                  {stats.porcentajeCobrado.toFixed(1)}%
                </div>
              </div>
              <TrendingUp className="h-8 w-8 text-purple-600" />
            </div>
          </Card>
        </div>

        {/* Gráfico de Distribución de Estados */}
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-8">
          <StatusDonutChart
            data={statusDistribution.map(item => ({
              name: item.label,
              total: item.total
            }))}
            title="Distribución por Estado"
          />

          <Card className="p-6">
            <h3 className="text-lg font-semibold text-gray-900 mb-4">Resumen de Honorarios</h3>
            <div className="space-y-4">
              <div className="flex justify-between items-center p-4 bg-orange-50 rounded-lg">
                <div>
                  <div className="text-sm text-gray-600">Honorarios Pendientes</div>
                  <div className="text-2xl font-bold text-orange-600">
                    ${honorariosStats.totalPendiente.toLocaleString('es-AR')}
                  </div>
                </div>
                <Users className="h-8 w-8 text-orange-600" />
              </div>
              <div className="flex justify-between items-center p-4 bg-green-50 rounded-lg">
                <div>
                  <div className="text-sm text-gray-600">Honorarios Pagados</div>
                  <div className="text-2xl font-bold text-green-600">
                    ${honorariosStats.totalPagado.toLocaleString('es-AR')}
                  </div>
                </div>
                <DollarSign className="h-8 w-8 text-green-600" />
              </div>
              <div className="text-sm text-gray-600 mt-4">
                <div>• {honorariosStats.profesionalesConPendiente} profesionales con honorarios pendientes</div>
                <div>• {honorariosStats.serviciosPendientes} servicios sin liquidar</div>
              </div>
            </div>
          </Card>
        </div>

        {/* Invoices Table */}
        <Card className="p-6 mb-6">
          <div className="flex items-center justify-between mb-4">
            <h3 className="text-lg font-semibold text-gray-900">Facturas ({invoices.length})</h3>
            <button className="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors text-sm">
              Generar Factura
            </button>
          </div>
          
          <Table>
            <TableHead>
              <TableRow>
                <TableHeaderCell>Número</TableHeaderCell>
                <TableHeaderCell>Fecha</TableHeaderCell>
                <TableHeaderCell>Paciente</TableHeaderCell>
                <TableHeaderCell>Descripción</TableHeaderCell>
                <TableHeaderCell>Monto</TableHeaderCell>
                <TableHeaderCell>Estado</TableHeaderCell>
                <TableHeaderCell>Pago</TableHeaderCell>
              </TableRow>
            </TableHead>
            <TableBody>
              {invoices.map((invoice) => {
                const status = STATUS_MAP[invoice.status] || STATUS_MAP.DRAFT;
                
                return (
                  <TableRow key={invoice.id}>
                    <TableCell className="font-medium">
                      <div>
                        <div>{invoice.invoiceNumber}</div>
                        <div className="text-xs text-gray-500">
                          {new Date(invoice.invoiceDate).toLocaleDateString('es-AR')}
                        </div>
                      </div>
                    </TableCell>
                    <TableCell>
                      <div className="text-sm">
                        {new Date(invoice.periodStart).toLocaleDateString('es-AR')} - 
                        {new Date(invoice.periodEnd).toLocaleDateString('es-AR')}
                      </div>
                    </TableCell>
                    <TableCell>
                      <div>
                        <div className="font-medium">{invoice.patient}</div>
                        <div className="text-xs text-gray-500">DNI: {invoice.dni}</div>
                      </div>
                    </TableCell>
                    <TableCell>
                      <div className="text-sm">
                        <div>{invoice.description}</div>
                        <div className="text-xs text-gray-500 mt-1">
                          {invoice.days} días × {invoice.urModules} UR (${invoice.urValue})
                        </div>
                      </div>
                    </TableCell>
                    <TableCell className="font-medium">
                      ${invoice.totalAmount.toLocaleString('es-AR')}
                    </TableCell>
                    <TableCell>
                      <Badge color={status.color}>{status.label}</Badge>
                    </TableCell>
                    <TableCell>
                      {invoice.paymentDate ? (
                        <div className="text-sm">
                          <div className="text-green-600 font-medium">
                            {new Date(invoice.paymentDate).toLocaleDateString('es-AR')}
                          </div>
                          {invoice.daysToPayment && (
                            <div className="text-xs text-gray-500">
                              {invoice.daysToPayment} días
                            </div>
                          )}
                        </div>
                      ) : (
                        <span className="text-sm text-gray-500">Pendiente</span>
                      )}
                    </TableCell>
                  </TableRow>
                );
              })}
            </TableBody>
          </Table>

          {invoices.length === 0 && (
            <div className="text-center py-12">
              <FileText className="h-12 w-12 text-gray-400 mx-auto mb-4" />
              <p className="text-gray-600">No hay facturas generadas para este período</p>
            </div>
          )}
        </Card>

        {/* Honorarios Profesionales */}
        <Card className="p-6 mb-6">
          <h3 className="text-lg font-semibold text-gray-900 mb-4">Honorarios Profesionales</h3>
          <Table>
            <TableHead>
              <TableRow>
                <TableHeaderCell>Profesional</TableHeaderCell>
                <TableHeaderCell>Especialidad</TableHeaderCell>
                <TableHeaderCell>Servicios</TableHeaderCell>
                <TableHeaderCell>Monto</TableHeaderCell>
                <TableHeaderCell>Estado</TableHeaderCell>
                <TableHeaderCell>Fecha Pago</TableHeaderCell>
              </TableRow>
            </TableHead>
            <TableBody>
              {professionalFees.map((fee) => (
                <TableRow key={fee.id}>
                  <TableCell className="font-medium">{fee.professional}</TableCell>
                  <TableCell>{fee.specialty}</TableCell>
                  <TableCell>{fee.servicesCount}</TableCell>
                  <TableCell className="font-medium">
                    ${fee.totalAmount.toLocaleString('es-AR')}
                  </TableCell>
                  <TableCell>
                    <Badge color={fee.status === 'PAID' ? 'green' : 'orange'}>
                      {fee.status === 'PAID' ? 'Pagado' : 'Pendiente'}
                    </Badge>
                  </TableCell>
                  <TableCell>
                    {fee.paymentDate 
                      ? new Date(fee.paymentDate).toLocaleDateString('es-AR')
                      : '-'
                    }
                  </TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
        </Card>

        {/* Additional Info */}
        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
          <Card className="p-6">
            <h3 className="text-lg font-semibold text-gray-900 mb-4">Dispositivo</h3>
            <div className="space-y-2">
              <div className="flex justify-between">
                <span className="text-gray-600">Nombre:</span>
                <span className="font-medium">{device.name}</span>
              </div>
              <div className="flex justify-between">
                <span className="text-gray-600">Código:</span>
                <span className="font-medium">{device.code}</span>
              </div>
            </div>
          </Card>

          <Card className="p-6">
            <h3 className="text-lg font-semibold text-gray-900 mb-4">Obra Social</h3>
            <div className="space-y-2">
              <div className="flex justify-between">
                <span className="text-gray-600">Nombre:</span>
                <span className="font-medium">{insurance.name}</span>
              </div>
              <div className="flex justify-between">
                <span className="text-gray-600">Plazo de pago:</span>
                <span className="font-medium">{insurance.paymentTermDays} días</span>
              </div>
            </div>
          </Card>
        </div>
      </div>
    </main>
  );
}
