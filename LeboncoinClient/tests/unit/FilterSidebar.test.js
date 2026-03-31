import { describe, it, expect, vi, beforeEach } from 'vitest'
import { mount } from '@vue/test-utils'

// ── annoncesService mock ──────────────────────────────────────────────────────
vi.mock('@/services/annoncesService', () => {
  const mockGetTypeHebergements = vi.fn()
  const mockGetCommoditesByCategories = vi.fn()

  return {
    default: {
      getTypeHebergements: mockGetTypeHebergements,
      getCommoditesByCategories: mockGetCommoditesByCategories,
    },
    __mockGetTypeHebergements: mockGetTypeHebergements,
    __mockGetCommoditesByCategories: mockGetCommoditesByCategories,
  }
})

import FilterSidebar from '@/components/FilterSidebar.vue'
import { __mockGetTypeHebergements, __mockGetCommoditesByCategories } from '@/services/annoncesService'

const DEFAULT_FILTERS = {
  dateArrivee: '',
  dateDepart: '',
  minPrice: null,
  maxPrice: null,
  nbChambres: 0,
  typeHebergementIds: [],
  commoditeIds: [],
}

const SAMPLE_TYPES = [
  { idtypehebergement: 1, nomtypehebergement: 'Appartement' },
  { idtypehebergement: 2, nomtypehebergement: 'Maison' },
]

const SAMPLE_CATEGORIES = [
  { id: 1, nom: 'Services', items: [{ id: 10, nom: 'Parking' }, { id: 11, nom: 'Piscine' }] },
  { id: 2, nom: 'Équipements', items: [{ id: 20, nom: 'Wifi' }] },
]

function mountSidebar(props = {}) {
  return mount(FilterSidebar, {
    props: {
      isOpen: true,
      initialFilters: { ...DEFAULT_FILTERS },
      ...props,
    },
  })
}

// ── Tests ────────────────────────────────────────────────────────────────────
describe('FilterSidebar.vue', () => {
  beforeEach(() => {
    vi.clearAllMocks()
    __mockGetTypeHebergements.mockResolvedValue(SAMPLE_TYPES)
    __mockGetCommoditesByCategories.mockResolvedValue(SAMPLE_CATEGORIES)
  })

  // ── Rendu ───────────────────────────────────────────────────────────────
  describe('Rendu', () => {
    it("affiche la sidebar quand isOpen est true", () => {
      const wrapper = mountSidebar({ isOpen: true })
      expect(wrapper.text()).toContain('Tous les filtres')
    })

    it("n'affiche pas la sidebar quand isOpen est false", () => {
      const wrapper = mountSidebar({ isOpen: false })
      expect(wrapper.html()).not.toContain('Tous les filtres')
    })

    it('affiche le bouton "Rechercher"', () => {
      const wrapper = mountSidebar()
      expect(wrapper.text()).toContain('Rechercher')
    })

    it('affiche le bouton "Tout Effacer"', () => {
      const wrapper = mountSidebar()
      expect(wrapper.text()).toContain('Tout Effacer')
    })
  })

  // ── Chargement des données ──────────────────────────────────────────────
  describe('Chargement des données (loadData)', () => {
    it('appelle getTypeHebergements et getCommoditesByCategories', async () => {
      mountSidebar()
      await vi.dynamicImportSettled?.()
      expect(__mockGetTypeHebergements).toHaveBeenCalled()
      expect(__mockGetCommoditesByCategories).toHaveBeenCalled()
    })

    it('peuple typesHebergement depuis la réponse API', async () => {
      const wrapper = mountSidebar()
      // flush promises
      await new Promise((r) => setTimeout(r, 0))
      expect(wrapper.vm.typesHebergement).toEqual(SAMPLE_TYPES)
    })

    it('peuple commoditeCategories depuis la réponse API', async () => {
      const wrapper = mountSidebar()
      await new Promise((r) => setTimeout(r, 0))
      expect(wrapper.vm.commoditeCategories).toEqual(SAMPLE_CATEGORIES)
    })

    it('gère les erreurs API silencieusement', async () => {
      __mockGetTypeHebergements.mockRejectedValue(new Error('Network error'))
      const wrapper = mountSidebar()
      await new Promise((r) => setTimeout(r, 0))
      // Should not throw, types stays empty
      expect(wrapper.vm.typesHebergement).toEqual([])
    })
  })

  // ── Watcher isOpen ──────────────────────────────────────────────────────
  describe('Watcher sur isOpen', () => {
    it('recopie initialFilters dans localFilters quand isOpen passe à true', async () => {
      const wrapper = mountSidebar({ isOpen: false })
      const filtersWithDates = { ...DEFAULT_FILTERS, dateArrivee: '2025-08-01', dateDepart: '2025-08-07' }
      await wrapper.setProps({ isOpen: true, initialFilters: filtersWithDates })
      expect(wrapper.vm.localFilters.dateArrivee).toBe('2025-08-01')
    })

    it('réalise une copie profonde des tableaux de initialFilters', async () => {
      const wrapper = mountSidebar({ isOpen: false })
      const filtersWithTypes = { ...DEFAULT_FILTERS, typeHebergementIds: [1, 2] }
      await wrapper.setProps({ isOpen: true, initialFilters: filtersWithTypes })
      // Mutating localFilters should not affect initialFilters
      wrapper.vm.localFilters.typeHebergementIds.push(3)
      expect(filtersWithTypes.typeHebergementIds).toHaveLength(2)
    })
  })

  // ── resetFilters ────────────────────────────────────────────────────────
  describe('resetFilters()', () => {
    it('remet tous les filtres à leurs valeurs par défaut', async () => {
      const wrapper = mountSidebar()
      // Dirty state
      wrapper.vm.localFilters.minPrice = 100
      wrapper.vm.localFilters.maxPrice = 300
      wrapper.vm.localFilters.nbChambres = 3
      wrapper.vm.localFilters.typeHebergementIds = [1, 2]
      wrapper.vm.localFilters.commoditeIds = [10]
      wrapper.vm.localFilters.dateArrivee = '2025-08-01'
      wrapper.vm.localFilters.dateDepart = '2025-08-07'

      wrapper.vm.resetFilters()

      expect(wrapper.vm.localFilters).toEqual({
        dateArrivee: '',
        dateDepart: '',
        minPrice: null,
        maxPrice: null,
        nbChambres: 0,
        typeHebergementIds: [],
        commoditeIds: [],
      })
    })

    it('est déclenché par le bouton "Tout Effacer"', async () => {
      const wrapper = mountSidebar()
      wrapper.vm.localFilters.minPrice = 100
      const resetSpy = vi.spyOn(wrapper.vm, 'resetFilters')
      const btn = wrapper.findAll('button').find((b) => b.text() === 'Tout Effacer')
      await btn.trigger('click')
      expect(resetSpy).toHaveBeenCalled()
    })
  })

  // ── applyFilters ────────────────────────────────────────────────────────
  describe('applyFilters()', () => {
    it('émet l\'événement "apply" avec une copie des filtres locaux', async () => {
      const wrapper = mountSidebar()
      wrapper.vm.localFilters.nbChambres = 2
      wrapper.vm.applyFilters()
      expect(wrapper.emitted('apply')).toBeTruthy()
      expect(wrapper.emitted('apply')[0][0]).toMatchObject({ nbChambres: 2 })
    })

    it('émet l\'événement "close" après apply', async () => {
      const wrapper = mountSidebar()
      wrapper.vm.applyFilters()
      expect(wrapper.emitted('close')).toBeTruthy()
    })

    it("l'objet émis est une copie (pas une référence au state)", async () => {
      const wrapper = mountSidebar()
      wrapper.vm.applyFilters()
      const emitted = wrapper.emitted('apply')[0][0]
      emitted.nbChambres = 99
      expect(wrapper.vm.localFilters.nbChambres).toBe(0)
    })

    it('est déclenché par le bouton "Rechercher"', async () => {
      const wrapper = mountSidebar()
      const applySpy = vi.spyOn(wrapper.vm, 'applyFilters')
      const btn = wrapper.findAll('button').find((b) => b.text() === 'Rechercher')
      await btn.trigger('click')
      expect(applySpy).toHaveBeenCalled()
    })
  })

  // ── Boutons Chambres ────────────────────────────────────────────────────
  describe('Sélection du nombre de chambres', () => {
    it('sélectionne nbChambres = 0 au clic sur "Tout"', async () => {
      const wrapper = mountSidebar()
      wrapper.vm.localFilters.nbChambres = 3
      const toutBtn = wrapper.findAll('button').find((b) => b.text() === 'Tout')
      await toutBtn.trigger('click')
      expect(wrapper.vm.localFilters.nbChambres).toBe(0)
    })

    it('sélectionne nbChambres = 2 au clic sur le bouton 2', async () => {
      const wrapper = mountSidebar()
      const btn2 = wrapper.findAll('button').find((b) => b.text() === '2')
      await btn2.trigger('click')
      expect(wrapper.vm.localFilters.nbChambres).toBe(2)
    })
  })

  // ── toggleCommodite ─────────────────────────────────────────────────────
  describe('toggleCommodite()', () => {
    it('ajoute un id absent', () => {
      const wrapper = mountSidebar()
      wrapper.vm.localFilters.commoditeIds = []
      wrapper.vm.toggleCommodite(10)
      expect(wrapper.vm.localFilters.commoditeIds).toContain(10)
    })

    it('supprime un id déjà présent', () => {
      const wrapper = mountSidebar()
      wrapper.vm.localFilters.commoditeIds = [10, 20]
      wrapper.vm.toggleCommodite(10)
      expect(wrapper.vm.localFilters.commoditeIds).not.toContain(10)
      expect(wrapper.vm.localFilters.commoditeIds).toContain(20)
    })
  })

  // ── Fermeture via overlay ───────────────────────────────────────────────
  describe('Fermeture', () => {
    it("émet 'close' au clic sur l'overlay", async () => {
      const wrapper = mountSidebar()
      const overlay = wrapper.find('.absolute.inset-0.bg-black\\/50')
      await overlay.trigger('click')
      expect(wrapper.emitted('close')).toBeTruthy()
    })

    it("émet 'close' au clic sur le bouton ✕", async () => {
      const wrapper = mountSidebar()
      const closeBtn = wrapper.find('button')
      await closeBtn.trigger('click')
      expect(wrapper.emitted('close')).toBeTruthy()
    })
  })
})
