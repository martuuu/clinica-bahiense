import { Card } from '@tremor/react';
import { 
  Building, 
  Home as HomeIcon, 
  Sun, 
  Stethoscope, 
  Users, 
  ArrowRight 
} from 'lucide-react';
import Link from 'next/link';
import { notFound } from 'next/navigation';
import { BreadcrumbNav } from '@/components/navigation/breadcrumb-nav';
import { PeriodDisplay } from '@/components/navigation/period-display';
import { getBusinessAreaById } from '@/actions/business-areas';
import { getDevicesByArea } from '@/actions/devices';
import { getCompanyById } from '@/actions/companies';

// Mapeo de tipos de dispositivo a iconos y colores
const DEVICE_CONFIG = {
  INTERNACION: {
    icon: Building,
    color: 'bg-red-500',
    iconColor: 'text-red-600',
  },
  VIVIENDA_ASISTIDA: {
    icon: HomeIcon,
    color: 'bg-purple-500',
    iconColor: 'text-purple-600',
  },
  HOSPITAL_DIA: {
    icon: Sun,
    color: 'bg-yellow-500',
    iconColor: 'text-yellow-600',
  },
  CONSULTORIOS_EXTERNOS: {
    icon: Stethoscope,
    color: 'bg-blue-500',
    iconColor: 'text-blue-600',
  },
  CCSI: {
    icon: Users,
    color: 'bg-green-500',
    iconColor: 'text-green-600',
  },
} as const;

export default async function BusinessAreaPage({ 
  params 
}: { 
  params: Promise<{ companyId: string; areaId: string }> 
}) {
  const { companyId, areaId } = await params;
  
  const [companyResult, areaResult, devicesResult] = await Promise.all([
    getCompanyById(companyId),
    getBusinessAreaById(areaId),
    getDevicesByArea(areaId),
  ]);
  
  if (!companyResult.success || !companyResult.data) {
    notFound();
  }
  
  if (!areaResult.success || !areaResult.data) {
    notFound();
  }
  
  if (!devicesResult.success) {
    notFound();
  }
  
  const company = companyResult.data;
  const area = areaResult.data;
  const devices = devicesResult.data || [];

  const breadcrumbs = [
    { label: company.name, href: `/${companyId}` },
    { label: area.name, href: `/${companyId}/${areaId}` },
  ];

  return (
    <main className="min-h-screen bg-gray-50 p-8">
      <div className="mx-auto max-w-7xl">
        <div className="flex items-center justify-between mb-6">
          <BreadcrumbNav breadcrumbs={breadcrumbs} />
          <PeriodDisplay />
        </div>

        <div className="mb-8">
          <h1 className="text-3xl font-bold text-gray-900">{area.name}</h1>
          <p className="mt-2 text-gray-600">Seleccione un dispositivo para ver el detalle</p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {/* eslint-disable @typescript-eslint/no-explicit-any */}
          {devices.map((device: any) => {
            const config = DEVICE_CONFIG[device.type as keyof typeof DEVICE_CONFIG] || DEVICE_CONFIG.INTERNACION;
            const Icon = config.icon;
            const capacity = device.capacity || 0;
            const occupied = device.occupied || 0;
            const occupancyRate = capacity > 0 
              ? Math.round((occupied / capacity) * 100) 
              : 0;

            return (
              <Link 
                key={device.id} 
                href={`/${companyId}/${areaId}/${device.id}`}
              >
                <Card className="p-6 hover:shadow-lg transition-shadow cursor-pointer group">
                  <div className="flex items-start justify-between mb-4">
                    <div className={`p-3 rounded-lg ${config.color} bg-opacity-10`}>
                      <Icon className={`h-6 w-6 ${config.iconColor}`} />
                    </div>
                    <ArrowRight className="h-5 w-5 text-gray-400 group-hover:text-blue-600 transition-colors" />
                  </div>

                  <h3 className="text-lg font-semibold text-gray-900 group-hover:text-blue-600 transition-colors mb-2">
                    {device.name}
                  </h3>

                  <div className="space-y-2">
                    <div className="flex justify-between text-sm">
                      <span className="text-gray-600">Ocupación:</span>
                      <span className="font-medium text-gray-900">
                        {occupied} / {capacity}
                      </span>
                    </div>
                    <div className="w-full bg-gray-200 rounded-full h-2">
                      <div 
                        className={`h-2 rounded-full ${config.color}`}
                        style={{ width: `${occupancyRate}%` }}
                      />
                    </div>
                    <div className="text-xs text-gray-500 text-right">
                      {occupancyRate}% ocupado
                    </div>
                  </div>
                </Card>
              </Link>
            );
          })}
        </div>

        {/* Summary Section */}
        {/* eslint-disable @typescript-eslint/no-explicit-any */}
        <div className="mt-8">
          <Card className="p-6">
            <h3 className="text-lg font-semibold text-gray-900 mb-4">
              Resumen de Capacidad
            </h3>
            <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
              <div>
                <div className="text-sm text-gray-600">Total Capacidad</div>
                <div className="text-2xl font-bold text-gray-900 mt-1">
                  {devices.reduce((sum: number, d: any) => sum + (d.capacity || 0), 0)}
                </div>
              </div>
              <div>
                <div className="text-sm text-gray-600">Total Ocupados</div>
                <div className="text-2xl font-bold text-gray-900 mt-1">
                  {devices.reduce((sum: number, d: any) => sum + (d.occupied || 0), 0)}
                </div>
              </div>
              <div>
                <div className="text-sm text-gray-600">Disponibles</div>
                <div className="text-2xl font-bold text-green-600 mt-1">
                  {devices.reduce((sum: number, d: any) => sum + ((d.capacity || 0) - (d.occupied || 0)), 0)}
                </div>
              </div>
              <div>
                <div className="text-sm text-gray-600">% Ocupación Total</div>
                <div className="text-2xl font-bold text-gray-900 mt-1">
                  {(() => {
                    const totalCapacity = devices.reduce((sum: number, d: any) => sum + (d.capacity || 0), 0);
                    const totalOccupied = devices.reduce((sum: number, d: any) => sum + (d.occupied || 0), 0);
                    return totalCapacity > 0 ? Math.round((totalOccupied / totalCapacity) * 100) : 0;
                  })()}%
                </div>
              </div>
            </div>
          </Card>
        </div>
      </div>
    </main>
  );
}
