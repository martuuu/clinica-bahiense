import { Card } from '@tremor/react';
import { 
  Clock,
  Home as HomeIcon,
  Bed,
  ArrowRight 
} from 'lucide-react';
import Link from 'next/link';
import { notFound } from 'next/navigation';
import { BreadcrumbNav } from '@/components/navigation/breadcrumb-nav';
import { PeriodDisplay } from '@/components/navigation/period-display';
import { getCompanyById } from '@/actions/companies';
import { getBusinessAreaById } from '@/actions/business-areas';
import { getDeviceById } from '@/actions/devices';
import { getHealthInsuranceById, getModalitiesByInsuranceAndDevice } from '@/actions/health-insurances';

// Mapeo de códigos de modalidad a iconos y colores
const MODALITY_ICONS: Record<string, any> = {
  'AGUDA': { icon: Clock, color: 'bg-red-500', iconColor: 'text-red-600' },
  'PROLONGADA': { icon: Bed, color: 'bg-blue-500', iconColor: 'text-blue-600' },
  'DOMICILIARIA': { icon: HomeIcon, color: 'bg-green-500', iconColor: 'text-green-600' },
};

export default async function InsurancePage({ 
  params 
}: { 
  params: Promise<{ companyId: string; areaId: string; deviceId: string; insuranceId: string }> 
}) {
  const { companyId, areaId, deviceId, insuranceId } = await params;
  
  const [companyResult, areaResult, deviceResult, insuranceResult, agreementResult] = await Promise.all([
    getCompanyById(companyId),
    getBusinessAreaById(areaId),
    getDeviceById(deviceId),
    getHealthInsuranceById(insuranceId),
    getModalitiesByInsuranceAndDevice(insuranceId, deviceId),
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
  const agreement = agreementResult.success ? agreementResult.data : null;
  
  const modalities = agreement?.modalities || [];
  const isPAMI = insurance.type === 'PAMI';
  const urValue = agreement?.urValue ? Number(agreement.urValue) : 1250;

  const breadcrumbs = [
    { label: company.name, href: `/${companyId}` },
    { label: area.name, href: `/${companyId}/${areaId}` },
    { label: device.name, href: `/${companyId}/${areaId}/${deviceId}` },
    { label: insurance.name, href: `/${companyId}/${areaId}/${deviceId}/${insuranceId}` },
  ];

  return (
    <main className="min-h-screen bg-gray-50 p-8">
      <div className="mx-auto max-w-7xl">
        <div className="flex items-center justify-between mb-6">
          <BreadcrumbNav breadcrumbs={breadcrumbs} />
          <PeriodDisplay />
        </div>

        <div className="mb-8">
          <h1 className="text-3xl font-bold text-gray-900">{insurance.name}</h1>
          <p className="mt-2 text-gray-600">
            {isPAMI && modalities.length > 0 ? 'Seleccione una modalidad de internación' : 'Información de la obra social'}
          </p>
        </div>

        {isPAMI && modalities.length > 0 ? (
          <>
            {/* Valor UR Card */}
            <Card className="p-6 mb-6 bg-linear-to-r from-purple-50 to-blue-50">
              <div className="flex items-center justify-between">
                <div>
                  <h3 className="text-sm font-medium text-gray-600">Valor Unidad Retributiva (UR)</h3>
                  <p className="text-3xl font-bold text-gray-900 mt-2">${urValue.toLocaleString('es-AR', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</p>
                  <p className="text-sm text-gray-500 mt-1">
                    Vigente desde: {agreement?.validFrom ? new Date(agreement.validFrom).toLocaleDateString('es-AR') : 'N/A'}
                  </p>
                </div>
                <div className="text-right">
                  <div className="text-sm text-gray-600">Sistema de Facturación</div>
                  <div className="text-lg font-semibold text-purple-600 mt-1">Módulos UR</div>
                </div>
              </div>
            </Card>

            {/* Modalities Grid */}
            <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
              {/* eslint-disable @typescript-eslint/no-explicit-any */}
              {modalities.map((modality: any) => {
                const modalityCode = modality.code?.toUpperCase() || 'AGUDA';
                const config = MODALITY_ICONS[modalityCode] || MODALITY_ICONS['AGUDA'];
                const Icon = config.icon;
                
                // Parsear módulos UR del JSON
                const modules = modality.modules as any;
                const urModules = modules?.urModules || 10;
                const dailyValue = urModules * urValue;
                const activePatients = modality._count?.admissions || 0;

                return (
                  <Link 
                    key={modality.id} 
                    href={`/${companyId}/${areaId}/${deviceId}/${insuranceId}/${modality.id}`}
                  >
                    <Card className="p-6 hover:shadow-lg transition-shadow cursor-pointer group h-full">
                      <div className="flex items-start justify-between mb-4">
                        <div className={`p-3 rounded-lg ${config.color} bg-opacity-10`}>
                          <Icon className={`h-6 w-6 ${config.iconColor}`} />
                        </div>
                        <ArrowRight className="h-5 w-5 text-gray-400 group-hover:text-blue-600 transition-colors" />
                      </div>

                      <h3 className="text-lg font-semibold text-gray-900 group-hover:text-blue-600 transition-colors mb-2">
                        {modality.name}
                      </h3>
                      <p className="text-sm text-gray-600 mb-4">{modules?.description || 'Sin descripción'}</p>

                      <div className="space-y-2 border-t pt-4">
                        <div className="flex justify-between text-sm">
                          <span className="text-gray-600">Módulos UR:</span>
                          <span className="font-medium text-gray-900">{urModules} UR/día</span>
                        </div>
                        <div className="flex justify-between text-sm">
                          <span className="text-gray-600">Valor diario:</span>
                          <span className="font-medium text-gray-900">
                            ${dailyValue.toLocaleString('es-AR')}
                          </span>
                        </div>
                      </div>

                      <div className="mt-4 pt-4 border-t">
                        <div className="flex justify-between items-center">
                          <span className="text-sm text-gray-600">Pacientes activos:</span>
                          <span className="text-lg font-bold text-gray-900">
                            {activePatients}
                          </span>
                        </div>
                      </div>
                    </Card>
                  </Link>
                );
              })}
            </div>

            {/* Summary */}
            <div className="mt-8 grid grid-cols-1 md:grid-cols-3 gap-6">
              <Card className="p-6">
                <div className="text-sm text-gray-600">Total Pacientes Activos</div>
                <div className="text-2xl font-bold text-gray-900 mt-2">
                  {modalities.reduce((sum: number, m: any) => sum + (m._count?.admissions || 0), 0)}
                </div>
              </Card>
              
              <Card className="p-6">
                <div className="text-sm text-gray-600">Modalidades Disponibles</div>
                <div className="text-2xl font-bold text-gray-900 mt-2">
                  {modalities.length}
                </div>
              </Card>
              
              <Card className="p-6">
                <div className="text-sm text-gray-600">Valor UR Vigente</div>
                <div className="text-2xl font-bold text-purple-600 mt-2">
                  ${urValue.toLocaleString('es-AR')}
                </div>
              </Card>
            </div>
          </>
        ) : (
          <Card className="p-8 text-center">
            <h3 className="text-xl font-semibold text-gray-900 mb-4">Vista simplificada</h3>
            <p className="text-gray-600 mb-6">
              {!isPAMI 
                ? 'Esta obra social no utiliza el sistema de modalidades PAMI. Accede directamente a las vistas operativas.'
                : 'No se encontraron modalidades activas para este convenio.'
              }
            </p>
            <div className="flex gap-4 justify-center">
              <Link href={`/${companyId}/${areaId}/${deviceId}/${insuranceId}/operativo`}>
                <button className="px-6 py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors">
                  Vista Operativa
                </button>
              </Link>
              <Link href={`/${companyId}/${areaId}/${deviceId}/${insuranceId}/administrativo`}>
                <button className="px-6 py-3 bg-green-600 text-white rounded-lg hover:bg-green-700 transition-colors">
                  Vista Administrativa
                </button>
              </Link>
            </div>
          </Card>
        )}
      </div>
    </main>
  );
}
