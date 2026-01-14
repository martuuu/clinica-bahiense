'use client';

import { Building2, Calendar, ArrowRight } from "lucide-react";
import { Card } from "@tremor/react";
import { useNavigationStore } from "@/store/navigation-store";
import { useState } from "react";
import { format } from "date-fns";
import { useRouter } from "next/navigation";
import { useQuery } from "@tanstack/react-query";
import { getCompanies } from "@/actions/companies";

export default function HomePage() {
  const router = useRouter();
  const { companyId, period, setCompanyId, setPeriod } = useNavigationStore();
  
  // Fetch companies from database
  const { data: companies, isLoading, error } = useQuery({
    queryKey: ['companies'],
    queryFn: async () => {
      const result = await getCompanies();
      if (!result.success) throw new Error(result.error);
      return result.data;
    },
  });
  
  const [startDate, setStartDate] = useState(
    period.start ? format(period.start, 'yyyy-MM-dd') : ''
  );
  const [endDate, setEndDate] = useState(
    period.end ? format(period.end, 'yyyy-MM-dd') : ''
  );

  const handleCompanyChange = (e: React.ChangeEvent<HTMLSelectElement>) => {
    setCompanyId(e.target.value);
  };

  const handleStartDateChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setStartDate(e.target.value);
    if (e.target.value && endDate) {
      setPeriod(new Date(e.target.value), new Date(endDate));
    }
  };

  const handleEndDateChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setEndDate(e.target.value);
    if (startDate && e.target.value) {
      setPeriod(new Date(startDate), new Date(e.target.value));
    }
  };

  const handleContinue = () => {
    if (companyId) {
      router.push(`/${companyId}`);
    }
  };

  const isFormComplete = companyId && startDate && endDate;

  return (
    <main className="min-h-screen bg-gray-50 p-8">
      <div className="mx-auto max-w-7xl space-y-6">
        {/* Header */}
        <div className="mb-8">
          <h1 className="text-3xl font-bold text-gray-900">ClinicCore</h1>
          <p className="mt-2 text-gray-600">Sistema de Gestión Clínica</p>
        </div>

        {/* Company Selector Card */}
        <Card className="p-6">
          <div className="flex items-center gap-3 mb-4">
            <Building2 className="h-6 w-6 text-blue-600" />
            <h3 className="text-lg font-semibold text-gray-900">Seleccionar Empresa</h3>
          </div>
          
          {isLoading ? (
            <div className="w-full px-4 py-3 text-center text-gray-500">
              Cargando empresas...
            </div>
          ) : error ? (
            <div className="w-full px-4 py-3 text-center text-red-600">
              Error al cargar empresas
            </div>
          ) : (
            <select 
              className="w-full rounded-md border border-gray-300 bg-white px-4 py-2 text-gray-900 focus:border-blue-500 focus:outline-none focus:ring-2 focus:ring-blue-500"
              value={companyId || ''}
              onChange={handleCompanyChange}
            >
              <option value="" disabled>Seleccione una empresa...</option>
              {/* eslint-disable-next-line @typescript-eslint/no-explicit-any */}
              {companies?.map((company: any) => (
                <option key={company.id} value={company.id}>
                  {company.name} ({company.code})
                </option>
              ))}
            </select>
          )}
        </Card>

        {/* Period Selector Card */}
        <Card className="p-6">
          <div className="flex items-center gap-3 mb-4">
            <Calendar className="h-6 w-6 text-green-600" />
            <h3 className="text-lg font-semibold text-gray-900">Periodo</h3>
          </div>
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">
                Fecha Inicio
              </label>
              <input 
                type="date" 
                value={startDate}
                onChange={handleStartDateChange}
                className="w-full rounded-md border border-gray-300 bg-white px-4 py-2 text-gray-900 focus:border-green-500 focus:outline-none focus:ring-2 focus:ring-green-500"
              />
            </div>
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">
                Fecha Fin
              </label>
              <input 
                type="date" 
                value={endDate}
                onChange={handleEndDateChange}
                className="w-full rounded-md border border-gray-300 bg-white px-4 py-2 text-gray-900 focus:border-green-500 focus:outline-none focus:ring-2 focus:ring-green-500"
              />
            </div>
          </div>
        </Card>

        {/* Welcome Instructions */}
        <Card className="p-6">
          <h2 className="text-xl font-semibold text-gray-900 mb-4">
            Bienvenido a ClinicCore
          </h2>
          <p className="text-gray-600 mb-4">
            Para comenzar a trabajar con el sistema, siga estos pasos:
          </p>
          <ol className="list-decimal list-inside space-y-2 text-gray-700">
            <li>Seleccione la empresa con la que desea trabajar</li>
            <li>Configure el periodo de tiempo a consultar</li>
            <li>Navegue por las diferentes áreas de negocio</li>
            <li>Profundice en los dispositivos y datos específicos</li>
          </ol>
          
          <div className="mt-6 rounded-lg bg-blue-50 border border-blue-200 p-4">
            <p className="text-sm text-blue-800">
              <strong>💡 Consejo:</strong> Su selección de empresa y periodo se mantendrá 
              mientras navega por el sistema, permitiéndole acceder rápidamente a la 
              información que necesita.
            </p>
          </div>

          {/* Continue Button */}
          <button
            onClick={handleContinue}
            disabled={!isFormComplete}
            className={`mt-6 w-full flex items-center justify-center gap-2 px-6 py-3 rounded-lg font-semibold transition-colors ${
              isFormComplete
                ? 'bg-blue-600 text-white hover:bg-blue-700'
                : 'bg-gray-300 text-gray-500 cursor-not-allowed'
            }`}
          >
            Continuar
            <ArrowRight className="h-5 w-5" />
          </button>
        </Card>
      </div>
    </main>
  );
}
