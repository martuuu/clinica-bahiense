import { Card, Table, TableHead, TableRow, TableHeaderCell, TableBody, TableCell, Badge } from '@tremor/react';
import { 
  Users,
  AlertCircle,
  Plus,
  FileText,
  Clock
} from 'lucide-react';
import { notFound } from 'next/navigation';
import { BreadcrumbNav } from '@/components/navigation/breadcrumb-nav';
import { PeriodDisplay } from '@/components/navigation/period-display';
import { getCompanyById } from '@/actions/companies';
import { getBusinessAreaById } from '@/actions/business-areas';
import { getDeviceById } from '@/actions/devices';
import { getHealthInsuranceById } from '@/actions/health-insurances';
// Mock data - Prototipo rápido (Nivel Insurance sin modalidad)
import mockData from '@/data/mock-operativo.json';

export default async function OperativoPage({ 
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
  const patients = mockData.patients;
  const stats = mockData.stats;
  const alertas = mockData.alertas;
  const recentEvolutions = mockData.recentEvolutions;

  const breadcrumbs = [
    { label: company.name, href: `/${companyId}` },
    { label: area.name, href: `/${companyId}/${areaId}` },
    { label: device.name, href: `/${companyId}/${areaId}/${deviceId}` },
    { label: insurance.name, href: `/${companyId}/${areaId}/${deviceId}/${insuranceId}` },
    { label: 'Operativo', href: `/${companyId}/${areaId}/${deviceId}/${insuranceId}/operativo` },
  ];

  return (
    <main className="min-h-screen bg-gray-50 p-8">
      <div className="mx-auto max-w-7xl">
        <div className="flex items-center justify-between mb-6">
          <BreadcrumbNav breadcrumbs={breadcrumbs} />
          <PeriodDisplay />
        </div>

        <div className="mb-8 flex items-center justify-between">
          <div>
            <h1 className="text-3xl font-bold text-gray-900">Vista Operativa</h1>
            <p className="mt-2 text-gray-600">Gestión de pacientes - {insurance.name}</p>
          </div>
          <button className="flex items-center gap-2 px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors">
            <Plus className="h-5 w-5" />
            Nueva Admisión
          </button>
        </div>

        {/* Stats Cards */}
        <div className="grid grid-cols-1 md:grid-cols-4 gap-6 mb-8">
          <Card className="p-6">
            <div className="flex items-center justify-between">
              <div>
                <div className="text-sm text-gray-600">Pacientes Activos</div>
                <div className="text-2xl font-bold text-gray-900 mt-2">
                  {stats.totalPacientesActivos}
                </div>
              </div>
              <Users className="h-8 w-8 text-blue-600" />
            </div>
          </Card>

          <Card className="p-6">
            <div className="flex items-center justify-between">
              <div>
                <div className="text-sm text-gray-600">Autorizaciones por Vencer</div>
                <div className="text-2xl font-bold text-orange-600 mt-2">
                  {stats.autorizacionesPorVencer}
                </div>
              </div>
              <AlertCircle className="h-8 w-8 text-orange-600" />
            </div>
          </Card>

          <Card className="p-6">
            <div className="flex items-center justify-between">
              <div>
                <div className="text-sm text-gray-600">Promedio Estadía</div>
                <div className="text-2xl font-bold text-gray-900 mt-2">
                  {stats.promedioEstadia} días
                </div>
              </div>
              <Clock className="h-8 w-8 text-blue-600" />
            </div>
          </Card>

          <Card className="p-6">
            <div className="flex items-center justify-between">
              <div>
                <div className="text-sm text-gray-600">Evoluciones Recientes</div>
                <div className="text-2xl font-bold text-gray-900 mt-2">
                  {stats.ultimasEvoluciones}
                </div>
              </div>
              <FileText className="h-8 w-8 text-blue-600" />
            </div>
          </Card>
        </div>

        {/* Alertas de Autorizaciones */}
        {alertas.length > 0 && (
          <Card className="p-6 mb-8 border-l-4 border-orange-500">
            <div className="flex items-start gap-3">
              <AlertCircle className="h-6 w-6 text-orange-600 mt-1" />
              <div className="flex-1">
                <h3 className="text-lg font-semibold text-gray-900 mb-3">Alertas de Autorizaciones</h3>
                <div className="space-y-2">
                  {alertas.map((alerta, idx) => {
                    const priorityColors = {
                      critical: 'bg-red-100 text-red-800 border-red-300',
                      urgent: 'bg-orange-100 text-orange-800 border-orange-300',
                      warning: 'bg-yellow-100 text-yellow-800 border-yellow-300',
                    };
                    return (
                      <div 
                        key={idx}
                        className={`p-3 rounded-lg border ${priorityColors[alerta.priority as keyof typeof priorityColors]}`}
                      >
                        <div className="font-semibold">{alerta.patient}</div>
                        <div className="text-sm mt-1">{alerta.message}</div>
                        <div className="text-xs mt-1 opacity-75">{alerta.authNumber}</div>
                      </div>
                    );
                  })}
                </div>
              </div>
            </div>
          </Card>
        )}

        {/* Patients Table */}
        <Card className="p-6">
          <h3 className="text-lg font-semibold text-gray-900 mb-4">Pacientes Internados</h3>
          <Table>
            <TableHead>
              <TableRow>
                <TableHeaderCell>Paciente</TableHeaderCell>
                <TableHeaderCell>DNI</TableHeaderCell>
                <TableHeaderCell>Fecha Ingreso</TableHeaderCell>
                <TableHeaderCell>Diagnóstico</TableHeaderCell>
                <TableHeaderCell>Días</TableHeaderCell>
                <TableHeaderCell>Autorización</TableHeaderCell>
                <TableHeaderCell>Estado</TableHeaderCell>
              </TableRow>
            </TableHead>
            <TableBody>
              {patients.map((patient) => {
                return (
                  <TableRow key={patient.id}>
                    <TableCell className="font-medium">
                      {patient.firstName} {patient.lastName}
                    </TableCell>
                    <TableCell>{patient.dni}</TableCell>
                    <TableCell>
                      {new Date(patient.admission.admissionDate).toLocaleDateString('es-AR')}
                    </TableCell>
                    <TableCell>
                      <div>
                        <div className="font-medium">{patient.admission.diagnosis}</div>
                        <div className="text-xs text-gray-500">{patient.admission.icd10Code}</div>
                      </div>
                    </TableCell>
                    <TableCell>
                      {patient.admission.daysAdmitted} días
                    </TableCell>
                    <TableCell>
                      <div className="flex flex-col">
                        <span className="text-sm font-medium">
                          {patient.authorization.authNumber}
                        </span>
                        <span className="text-xs text-gray-500">
                          Vence: {new Date(patient.authorization.validTo).toLocaleDateString('es-AR')}
                        </span>
                        <span className={`text-xs mt-1 font-semibold ${
                          patient.authorization.daysRemaining <= 5 
                            ? 'text-red-600' 
                            : patient.authorization.daysRemaining <= 15 
                            ? 'text-orange-600' 
                            : 'text-green-600'
                        }`}>
                          {patient.authorization.daysRemaining} días restantes
                        </span>
                      </div>
                    </TableCell>
                    <TableCell>
                      <Badge color={patient.authorization.status === 'ACTIVE' ? 'green' : 'gray'}>
                        {patient.authorization.status}
                      </Badge>
                    </TableCell>
                  </TableRow>
                );
              })}
            </TableBody>
          </Table>

          {patients.length === 0 && (
            <div className="text-center py-12">
              <Users className="h-12 w-12 text-gray-400 mx-auto mb-4" />
              <p className="text-gray-600">No hay pacientes activos en este momento</p>
            </div>
          )}
        </Card>

        {/* Evoluciones Recientes */}
        <Card className="p-6 mt-6">
          <h3 className="text-lg font-semibold text-gray-900 mb-4">Últimas Evoluciones</h3>
          <div className="space-y-3">
            {recentEvolutions.map((evo, idx) => (
              <div key={idx} className="border-l-4 border-blue-500 pl-4 py-2">
                <div className="flex justify-between items-start">
                  <div className="flex-1">
                    <div className="font-medium text-gray-900">{evo.patient}</div>
                    <div className="text-sm text-gray-600 mt-1">{evo.summary}</div>
                  </div>
                  <div className="text-right text-sm text-gray-500">
                    <div>{new Date(evo.date).toLocaleDateString('es-AR')}</div>
                    <div className="text-xs">{evo.professional}</div>
                  </div>
                </div>
              </div>
            ))}
          </div>
        </Card>
      </div>
    </main>
  );
}
