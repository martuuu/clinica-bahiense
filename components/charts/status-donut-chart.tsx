'use client';

import { DonutChart, Card } from '@tremor/react';

interface StatusData {
  name: string;
  total: number;
}

interface StatusDonutChartProps {
  data: StatusData[];
  title: string;
}

export function StatusDonutChart({ data, title }: StatusDonutChartProps) {
  const valueFormatter = (number: number) => {
    return new Intl.NumberFormat('es-AR', {
      style: 'currency',
      currency: 'ARS',
      minimumFractionDigits: 0,
      maximumFractionDigits: 0,
    }).format(number);
  };

  return (
    <Card className="p-6">
      <h3 className="text-lg font-semibold text-gray-900 mb-4">{title}</h3>
      <DonutChart
        data={data}
        category="total"
        index="name"
        valueFormatter={valueFormatter}
        colors={['emerald', 'blue', 'amber', 'rose', 'slate']}
        className="h-60"
      />
    </Card>
  );
}
