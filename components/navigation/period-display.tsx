'use client';

import { Calendar as CalendarIcon } from 'lucide-react';
import { useNavigationStore } from '@/store/navigation-store';
import { format } from 'date-fns';
import { es } from 'date-fns/locale';

export function PeriodDisplay() {
  const { period } = useNavigationStore();

  if (!period.start || !period.end) return null;

  return (
    <div className="flex items-center gap-2 text-sm text-gray-600 bg-white px-4 py-2 rounded-lg border border-gray-200">
      <CalendarIcon className="h-4 w-4 text-gray-500" />
      <span>
        {format(period.start, 'dd MMM yyyy', { locale: es })} - {format(period.end, 'dd MMM yyyy', { locale: es })}
      </span>
    </div>
  );
}
