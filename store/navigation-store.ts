import { create } from 'zustand'
import { persist } from 'zustand/middleware'

export interface Breadcrumb {
  label: string
  href: string
}

export interface NavigationState {
  companyId: string | null
  period: {
    start: Date
    end: Date
  }
  breadcrumbs: Breadcrumb[]
  setCompanyId: (companyId: string) => void
  setPeriod: (start: Date, end: Date) => void
  setBreadcrumbs: (breadcrumbs: Breadcrumb[]) => void
  resetNavigation: () => void
}

const getDefaultPeriod = () => {
  const now = new Date()
  const start = new Date(now.getFullYear(), now.getMonth(), 1)
  const end = new Date(now.getFullYear(), now.getMonth() + 1, 0)
  return { start, end }
}

export const useNavigationStore = create<NavigationState>()(
  persist(
    (set) => ({
      companyId: null,
      period: getDefaultPeriod(),
      breadcrumbs: [],
      setCompanyId: (companyId) => set({ companyId }),
      setPeriod: (start, end) => set({ period: { start, end } }),
      setBreadcrumbs: (breadcrumbs) => set({ breadcrumbs }),
      resetNavigation: () =>
        set({
          companyId: null,
          period: getDefaultPeriod(),
          breadcrumbs: [],
        }),
    }),
    {
      name: 'navigation-storage',
    }
  )
)
