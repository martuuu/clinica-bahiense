import { Card } from '@tremor/react';
import { BrainCircuit, HeartPulse, ArrowRight } from 'lucide-react';
import Link from 'next/link';
import { notFound } from 'next/navigation';
import { BreadcrumbNav } from '@/components/navigation/breadcrumb-nav';
import { PeriodDisplay } from '@/components/navigation/period-display';
import { getCompanyById } from '@/actions/companies';
import { getBusinessAreasByCompany } from '@/actions/business-areas';

// Icon mapping for business areas
// eslint-disable-next-line @typescript-eslint/no-explicit-any
const AREA_ICONS: Record<string, any> = {
  'SM': BrainCircuit,  // Salud Mental
  'RF': HeartPulse,     // Rehabilitación Física
};

const AREA_COLORS: Record<string, { bg: string; text: string }> = {
  'SM': { bg: 'bg-blue-500', text: 'text-blue-600' },
  'RF': { bg: 'bg-green-500', text: 'text-green-600' },
};

export default async function CompanyPage({ params }: { params: Promise<{ companyId: string }> }) {
  const { companyId } = await params;
  
  const [companyResult, areasResult] = await Promise.all([
    getCompanyById(companyId),
    getBusinessAreasByCompany(companyId),
  ]);
  
  if (!companyResult.success || !companyResult.data) {
    notFound();
  }
  
  const company = companyResult.data;
  const businessAreas = areasResult.success ? areasResult.data : [];

  const breadcrumbs = [
    { label: company.name, href: `/${companyId}` },
  ];

  return (
    <main className="min-h-screen bg-gray-50 p-8">
      <div className="mx-auto max-w-7xl">
        <div className="flex items-center justify-between mb-6">
          <BreadcrumbNav breadcrumbs={breadcrumbs} />
          <PeriodDisplay />
        </div>

        <div className="mb-8">
          <h1 className="text-3xl font-bold text-gray-900">{company.name}</h1>
          <p className="mt-2 text-gray-600">Seleccione un área de negocio para continuar</p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
          {/* eslint-disable-next-line @typescript-eslint/no-explicit-any */}
          {businessAreas.map((area: any) => {
            const Icon = AREA_ICONS[area.code] || BrainCircuit;
            const colors = AREA_COLORS[area.code] || { bg: 'bg-blue-500', text: 'text-blue-600' };
            return (
              <Link key={area.id} href={`/${companyId}/${area.id}`}>
                <Card className="p-6 hover:shadow-lg transition-shadow cursor-pointer group">
                  <div className="flex items-start justify-between">
                    <div className="flex items-start gap-4">
                      <div className={`p-3 rounded-lg ${colors.bg} bg-opacity-10`}>
                        <Icon className={`h-8 w-8 ${colors.text}`} />
                      </div>
                      <div>
                        <h3 className="text-xl font-semibold text-gray-900 group-hover:text-blue-600 transition-colors">
                          {area.name}
                        </h3>
                        <p className="mt-2 text-gray-600">
                          {area.code === 'SM' ? 'Gestión de dispositivos de salud mental' : 'Gestión de dispositivos de rehabilitación'}
                        </p>
                      </div>
                    </div>
                    <ArrowRight className="h-5 w-5 text-gray-400 group-hover:text-blue-600 transition-colors" />
                  </div>
                </Card>
              </Link>
            );
          })}
        </div>

        {/* Summary Cards */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mt-8">
          <Card className="p-6">
            <div className="text-sm text-gray-600">Total Facturado</div>
            <div className="text-2xl font-bold text-gray-900 mt-2">$0</div>
            <div className="text-xs text-green-600 mt-1">+0% vs periodo anterior</div>
          </Card>
          
          <Card className="p-6">
            <div className="text-sm text-gray-600">Ocupación Promedio</div>
            <div className="text-2xl font-bold text-gray-900 mt-2">0%</div>
            <div className="text-xs text-gray-500 mt-1">0 / 0 cupos</div>
          </Card>
          
          <Card className="p-6">
            <div className="text-sm text-gray-600">Honorarios Pendientes</div>
            <div className="text-2xl font-bold text-gray-900 mt-2">$0</div>
            <div className="text-xs text-gray-500 mt-1">0 profesionales</div>
          </Card>
        </div>
      </div>
    </main>
  );
}
