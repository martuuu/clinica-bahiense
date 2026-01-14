import { Card } from '@tremor/react';
import { 
  Landmark,
  Building2,
  CreditCard,
  Users2,
  TrendingUp,
  ArrowRight 
} from 'lucide-react';
import Link from 'next/link';
import { notFound } from 'next/navigation';
import { BreadcrumbNav } from '@/components/navigation/breadcrumb-nav';
import { PeriodDisplay } from '@/components/navigation/period-display';
import { getCompanyById } from '@/actions/companies';
import { getBusinessAreaById } from '@/actions/business-areas';
import { getDeviceById } from '@/actions/devices';
import { getInsurancesByDevice } from '@/actions/health-insurances';

// Mapeo de tipos de obra social a iconos y colores
const INSURANCE_CONFIG = {
  PAMI: {
    icon: Landmark,
    color: 'bg-purple-500',
    iconColor: 'text-purple-600',
  },
  OSDE: {
    icon: Building2,
    color: 'bg-blue-500',
    iconColor: 'text-blue-600',
  },
  SWISS_MEDICAL: {
    icon: CreditCard,
    color: 'bg-red-500',
    iconColor: 'text-red-600',
  },
  OSMEDICA: {
    icon: Users2,
    color: 'bg-green-500',
    iconColor: 'text-green-600',
  },
  PARTICULAR: {
    icon: TrendingUp,
    color: 'bg-gray-500',
    iconColor: 'text-gray-600',
  },
} as const;

export default async function DevicePage({ 
  params 
}: { 
  params: Promise<{ companyId: string; areaId: string; deviceId: string }> 
}) {
  const { companyId, areaId, deviceId } = await params;
  
  const [companyResult, areaResult, deviceResult, insurancesResult] = await Promise.all([
    getCompanyById(companyId),
    getBusinessAreaById(areaId),
    getDeviceById(deviceId),
    getInsurancesByDevice(deviceId),
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
  
  if (!insurancesResult.success) {
    notFound();
  }
  
  const company = companyResult.data;
  const area = areaResult.data;
  const device = deviceResult.data;
  const insurances = insurancesResult.data || [];

  const breadcrumbs = [
    { label: company.name, href: `/${companyId}` },
    { label: area.name, href: `/${companyId}/${areaId}` },
    { label: device.name, href: `/${companyId}/${areaId}/${deviceId}` },
  ];

  return (
    <main className="min-h-screen bg-gray-50 p-8">
      <div className="mx-auto max-w-7xl">
        <div className="flex items-center justify-between mb-6">
          <BreadcrumbNav breadcrumbs={breadcrumbs} />
          <PeriodDisplay />
        </div>

        <div className="mb-8">
          <h1 className="text-3xl font-bold text-gray-900">{device.name}</h1>
          <p className="mt-2 text-gray-600">Seleccione una obra social para ver el detalle</p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {/* eslint-disable @typescript-eslint/no-explicit-any */}
          {insurances.map((insurance: any) => {
            const config = INSURANCE_CONFIG[insurance.type as keyof typeof INSURANCE_CONFIG] || INSURANCE_CONFIG.PARTICULAR;
            const Icon = config.icon;

            return (
              <Link 
                key={insurance.id} 
                href={`/${companyId}/${areaId}/${deviceId}/${insurance.id}`}
              >
                <Card className="p-6 hover:shadow-lg transition-shadow cursor-pointer group">
                  <div className="flex items-start justify-between mb-4">
                    <div className={`p-3 rounded-lg ${config.color} bg-opacity-10`}>
                      <Icon className={`h-6 w-6 ${config.iconColor}`} />
                    </div>
                    <ArrowRight className="h-5 w-5 text-gray-400 group-hover:text-blue-600 transition-colors" />
                  </div>

                  <h3 className="text-lg font-semibold text-gray-900 group-hover:text-blue-600 transition-colors mb-1">
                    {insurance.name}
                  </h3>
                  <p className="text-sm text-gray-500 mb-4">{insurance.type}</p>

                  <div className="space-y-2 border-t pt-4">
                    <div className="flex justify-between text-sm">
                      <span className="text-gray-600">Convenios activos:</span>
                      <span className="font-medium text-gray-900">
                        {insurance.agreements?.length || 0}
                      </span>
                    </div>
                    <div className="flex justify-between text-sm">
                      <span className="text-gray-600">Días plazo pago:</span>
                      <span className="font-medium text-gray-900">
                        {insurance.paymentTermDays} días
                      </span>
                    </div>
                  </div>
                </Card>
              </Link>
            );
          })}
        </div>

        {/* Summary Statistics */}
        <div className="mt-8 grid grid-cols-1 md:grid-cols-3 gap-6">
          <Card className="p-6">
            <div className="text-sm text-gray-600">Obras Sociales Activas</div>
            <div className="text-2xl font-bold text-gray-900 mt-2">
              {insurances.length}
            </div>
          </Card>
          
          <Card className="p-6">
            <div className="text-sm text-gray-600">Total Convenios</div>
            <div className="text-2xl font-bold text-gray-900 mt-2">
              {insurances.reduce((sum: number, i: any) => sum + (i.agreements?.length || 0), 0)}
            </div>
          </Card>
          
          <Card className="p-6">
            <div className="text-sm text-gray-600">Días Prom. Cobro</div>
            <div className="text-2xl font-bold text-gray-900 mt-2">
              {insurances.length > 0 
                ? Math.round(insurances.reduce((sum: number, i: any) => sum + i.paymentTermDays, 0) / insurances.length)
                : 0
              } días
            </div>
          </Card>
        </div>
      </div>
    </main>
  );
}
