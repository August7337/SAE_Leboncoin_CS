import { describe, it, expect, vi, beforeEach } from 'vitest'
import { mount } from '@vue/test-utils'

// ── Mocks ─────────────────────────────────────────────────────────────────────
vi.mock('@/services/annoncesService', () => {
  const mockAddFavorite = vi.fn()
  const mockRemoveFavorite = vi.fn()

  return {
    default: {
      addFavorite: mockAddFavorite,
      removeFavorite: mockRemoveFavorite,
    },
    __mockAddFavorite: mockAddFavorite,
    __mockRemoveFavorite: mockRemoveFavorite,
  }
})

vi.mock('@/auth.js', () => {
  const mockAuthState = { user: null }
  return {
    authState: mockAuthState,
    __mockAuthState: mockAuthState,
  }
})

vi.mock('vue-router', () => ({
  RouterLink: { template: '<a><slot /></a>' },
  useRouter: () => ({ push: vi.fn() }),
}))

// Stub PhotoCarousel — not under test
vi.mock('@/components/PhotoCarousel.vue', () => ({
  default: { template: '<div class="photo-carousel"></div>' },
}))

// Silence window.alert
vi.stubGlobal('alert', vi.fn())

import AnnonceList from '@/components/AnnonceList.vue'
import { __mockAddFavorite, __mockRemoveFavorite } from '@/services/annoncesService'
import { __mockAuthState } from '@/auth.js'

// ── Fixtures ─────────────────────────────────────────────────────────────────
const ANNONCE_1 = {
  idannonce: 1,
  titreannonce: 'Bel appartement Paris',
  prixnuitee: 75.5,
  capacite: 4,
  nombreetoilesleboncoin: 3,
  typehebergement: { nomtypehebergement: 'Appartement' },
  adresse: { ville: { nomville: 'Paris', codepostal: '75001' } },
  photos: [],
  dateDepot: '2025-06-01',
}

const ANNONCE_2 = {
  idannonce: 2,
  titreannonce: 'Maison de vacances',
  prixnuitee: 120,
  capacite: 6,
  nombreetoilesleboncoin: 4,
  typehebergement: { nomtypehebergement: 'Maison' },
  adresse: { ville: { nomville: 'Lyon', codepostal: '69001' } },
  photos: [],
  dateDepot: '2025-06-15',
}

function mountList(props = {}) {
  return mount(AnnonceList, {
    props: {
      annonces: [ANNONCE_1, ANNONCE_2],
      favoriteIds: [],
      isAuth: false,
      ...props,
    },
    global: { 
      stubs: {
        'router-link': { template: '<a><slot /></a>' },
        'PhotoCarousel': { template: '<div class="photo-carousel-stub"><slot /></div>' }
      }
    },
  })
}

// ── Tests ─────────────────────────────────────────────────────────────────────
describe('AnnonceList.vue', () => {
  beforeEach(() => {
    vi.clearAllMocks()
    __mockAuthState.user = null
  })

  // ── Rendu ────────────────────────────────────────────────────────────────
  describe('Rendu', () => {
    it('affiche un message quand la liste est vide', () => {
      const wrapper = mountList({ annonces: [] })
      expect(wrapper.text()).toContain('Aucune annonce disponible')
    })

    it("n'affiche pas le message vide si des annonces existent", () => {
      const wrapper = mountList()
      expect(wrapper.text()).not.toContain('Aucune annonce disponible')
    })

    it('affiche le titre de chaque annonce', async () => {
      const wrapper = mountList()
      await wrapper.vm.$nextTick()
      expect(wrapper.html()).toContain('Bel appartement Paris')
      expect(wrapper.html()).toContain('Maison de vacances')
    })

    it('affiche le prix correctement formaté', async () => {
      const wrapper = mountList()
      await wrapper.vm.$nextTick()
      expect(wrapper.html()).toContain('75.5')
    })
  })

  // ── formatPrice ──────────────────────────────────────────────────────────
  describe('formatPrice()', () => {
    it('retourne "0" si le prix est falsy', () => {
      const wrapper = mountList()
      expect(wrapper.vm.formatPrice(null)).toBe('0')
      expect(wrapper.vm.formatPrice(0)).toBe('0')
      expect(wrapper.vm.formatPrice('')).toBe('0')
    })

    it('supprime les zéros finaux inutiles', () => {
      const wrapper = mountList()
      expect(wrapper.vm.formatPrice('120.00')).toBe('120')
      expect(wrapper.vm.formatPrice('75.50')).toBe('75.5')
    })

    it('retourne la valeur flottante en chaîne', () => {
      const wrapper = mountList()
      expect(wrapper.vm.formatPrice(99.9)).toBe('99.9')
    })
  })

  // ── isFavorite ───────────────────────────────────────────────────────────
  describe('isFavorite()', () => {
    it('retourne false si id absent de favoriteIds', () => {
      const wrapper = mountList({ favoriteIds: [2, 3] })
      expect(wrapper.vm.isFavorite(1)).toBe(false)
    })

    it('retourne true si id présent dans favoriteIds', () => {
      const wrapper = mountList({ favoriteIds: [1, 2] })
      expect(wrapper.vm.isFavorite(1)).toBe(true)
    })

    it('suit les mises à jour du prop favoriteIds', async () => {
      const wrapper = mountList({ favoriteIds: [] })
      expect(wrapper.vm.isFavorite(1)).toBe(false)
      await wrapper.setProps({ favoriteIds: [1] })
      expect(wrapper.vm.isFavorite(1)).toBe(true)
    })
  })

  // ── toggleFavorite ───────────────────────────────────────────────────────
  describe('toggleFavorite()', () => {
    it("affiche une alerte et ne fait pas d'appel API si non connecté", async () => {
      const wrapper = mountList()
      await wrapper.vm.toggleFavorite(1)
      expect(alert).toHaveBeenCalledWith(expect.stringContaining('connecté'))
      expect(__mockAddFavorite).not.toHaveBeenCalled()
      expect(__mockRemoveFavorite).not.toHaveBeenCalled()
    })

    it('appelle addFavorite si id non favori et utilisateur connecté', async () => {
      __mockAuthState.user = { idutilisateur: 7 }
      __mockAddFavorite.mockResolvedValue({})
      const wrapper = mountList({ favoriteIds: [] })
      await wrapper.vm.toggleFavorite(1)
      expect(__mockAddFavorite).toHaveBeenCalledWith(1, 7)
    })

    it('appelle removeFavorite si id déjà favori et utilisateur connecté', async () => {
      __mockAuthState.user = { idutilisateur: 7 }
      __mockRemoveFavorite.mockResolvedValue({})
      const wrapper = mountList({ favoriteIds: [1] })
      await wrapper.vm.toggleFavorite(1)
      expect(__mockRemoveFavorite).toHaveBeenCalledWith(1, 7)
    })

    it('mise à jour optimiste : ajoute id localement avant la réponse API', async () => {
      __mockAuthState.user = { idutilisateur: 7 }
      let resolveAdd
      __mockAddFavorite.mockReturnValue(new Promise((r) => { resolveAdd = r }))
      const wrapper = mountList({ favoriteIds: [] })
      const promise = wrapper.vm.toggleFavorite(1)
      // Before API resolves, local state should already be updated
      expect(wrapper.vm.localFavoriteIds).toContain(1)
      resolveAdd({})
      await promise
    })

    it('mise à jour optimiste : retire id localement avant la réponse API', async () => {
      __mockAuthState.user = { idutilisateur: 7 }
      let resolveRemove
      __mockRemoveFavorite.mockReturnValue(new Promise((r) => { resolveRemove = r }))
      const wrapper = mountList({ favoriteIds: [1] })
      const promise = wrapper.vm.toggleFavorite(1)
      expect(wrapper.vm.localFavoriteIds).not.toContain(1)
      resolveRemove({})
      await promise
    })

    it("émet 'update-favorites' avec la nouvelle liste", async () => {
      __mockAuthState.user = { idutilisateur: 7 }
      __mockAddFavorite.mockResolvedValue({})
      const wrapper = mountList({ favoriteIds: [] })
      await wrapper.vm.toggleFavorite(1)
      expect(wrapper.emitted('update-favorites')).toBeTruthy()
      expect(wrapper.emitted('update-favorites')[0][0]).toContain(1)
    })

    it("gère silencieusement une erreur API sans planter", async () => {
      __mockAuthState.user = { idutilisateur: 7 }
      __mockAddFavorite.mockRejectedValue(new Error('Network error'))
      const wrapper = mountList({ favoriteIds: [] })
      await expect(wrapper.vm.toggleFavorite(1)).resolves.not.toThrow()
    })
  })

  // ── Sync prop → localFavoriteIds ─────────────────────────────────────────
  describe('Synchronisation du prop favoriteIds', () => {
    it('met à jour localFavoriteIds quand le prop change', async () => {
      const wrapper = mountList({ favoriteIds: [] })
      await wrapper.setProps({ favoriteIds: [1, 2] })
      expect(wrapper.vm.localFavoriteIds).toEqual([1, 2])
    })

    it('ne mute pas le prop directement (copie)', async () => {
      const ids = [1]
      const wrapper = mountList({ favoriteIds: ids })
      wrapper.vm.localFavoriteIds.push(99)
      expect(ids).toHaveLength(1)
    })
  })
})
