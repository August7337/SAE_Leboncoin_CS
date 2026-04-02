import { describe, it, expect, vi, beforeEach } from 'vitest'

// ── Mock axios instance ───────────────────────────────────────────────────────
vi.mock('@/api/axios.js', () => {
  const mockApi = {
    get: vi.fn(),
    post: vi.fn(),
    delete: vi.fn(),
  }

  return {
    default: mockApi,
    __mockApi: mockApi,
  }
})

// Avoid auth.js side effects
vi.mock('@/auth.js', () => ({
  authState: { token: null, user: null },
}))

import annoncesService from '@/services/annoncesService'
import { __mockApi } from '@/api/axios.js'

// ── Tests ────────────────────────────────────────────────────────────────────
describe('annoncesService', () => {
  beforeEach(() => {
    vi.clearAllMocks()
  })

  // ── getAll ──────────────────────────────────────────────────────────────
  describe('getAll()', () => {
    it('appelle GET /Annonces et retourne les données', async () => {
      const data = [{ idannonce: 1 }, { idannonce: 2 }]
      __mockApi.get.mockResolvedValue({ data })
      const result = await annoncesService.getAll()
      expect(__mockApi.get).toHaveBeenCalledWith('/Annonces')
      expect(result).toEqual(data)
    })
  })

  // ── getById ─────────────────────────────────────────────────────────────
  describe('getById()', () => {
    it('appelle GET /Annonces/:id et retourne les données', async () => {
      __mockApi.get.mockResolvedValue({ data: { idannonce: 5 } })
      const result = await annoncesService.getById(5)
      expect(__mockApi.get).toHaveBeenCalledWith('/Annonces/5')
      expect(result).toMatchObject({ idannonce: 5 })
    })
  })

  // ── searchByLocation ────────────────────────────────────────────────────
  describe('searchByLocation()', () => {
    it("construit l'URL de base avec query encodée", async () => {
      __mockApi.get.mockResolvedValue({ data: [] })
      await annoncesService.searchByLocation('Paris 75')
      expect(__mockApi.get).toHaveBeenCalledWith(
        expect.stringContaining('q=Paris%2075'),
      )
    })

    it('encode une query nulle comme chaîne vide', async () => {
      __mockApi.get.mockResolvedValue({ data: [] })
      await annoncesService.searchByLocation(null)
      expect(__mockApi.get).toHaveBeenCalledWith(expect.stringContaining('q='))
    })

    it('ajoute minPrice si présent', async () => {
      __mockApi.get.mockResolvedValue({ data: [] })
      await annoncesService.searchByLocation('Lyon', { minPrice: 50 })
      expect(__mockApi.get).toHaveBeenCalledWith(expect.stringContaining('minPrice=50'))
    })

    it('ajoute maxPrice si présent', async () => {
      __mockApi.get.mockResolvedValue({ data: [] })
      await annoncesService.searchByLocation('Lyon', { maxPrice: 200 })
      expect(__mockApi.get).toHaveBeenCalledWith(expect.stringContaining('maxPrice=200'))
    })

    it('ajoute nbChambres si présent', async () => {
      __mockApi.get.mockResolvedValue({ data: [] })
      await annoncesService.searchByLocation('Lyon', { nbChambres: 3 })
      expect(__mockApi.get).toHaveBeenCalledWith(expect.stringContaining('nbChambres=3'))
    })

    it("n'ajoute pas nbChambres si absent du filtre", async () => {
      __mockApi.get.mockResolvedValue({ data: [] })
      await annoncesService.searchByLocation('Lyon', {})
      expect(__mockApi.get).toHaveBeenCalledWith(
        expect.not.stringContaining('nbChambres'),
      )
    })

    it('joint les typeHebergementIds par virgule', async () => {
      __mockApi.get.mockResolvedValue({ data: [] })
      await annoncesService.searchByLocation('Lyon', { typeHebergementIds: [1, 2, 3] })
      expect(__mockApi.get).toHaveBeenCalledWith(
        expect.stringContaining('typeHebergementIds=1,2,3'),
      )
    })

    it("n'ajoute pas typeHebergementIds si tableau vide", async () => {
      __mockApi.get.mockResolvedValue({ data: [] })
      await annoncesService.searchByLocation('Lyon', { typeHebergementIds: [] })
      expect(__mockApi.get).toHaveBeenCalledWith(
        expect.not.stringContaining('typeHebergementIds'),
      )
    })

    it('joint les commoditeIds par virgule', async () => {
      __mockApi.get.mockResolvedValue({ data: [] })
      await annoncesService.searchByLocation('Lyon', { commoditeIds: [10, 20] })
      expect(__mockApi.get).toHaveBeenCalledWith(
        expect.stringContaining('commoditeIds=10,20'),
      )
    })

    it('ajoute dateArrivee et dateDepart si présents', async () => {
      __mockApi.get.mockResolvedValue({ data: [] })
      await annoncesService.searchByLocation('Lyon', {
        dateArrivee: '2025-07-01',
        dateDepart: '2025-07-07',
      })
      const url = __mockApi.get.mock.calls[0][0]
      expect(url).toContain('dateArrivee=2025-07-01')
      expect(url).toContain('dateDepart=2025-07-07')
    })

    it('cumule plusieurs filtres dans la même URL', async () => {
      __mockApi.get.mockResolvedValue({ data: [] })
      await annoncesService.searchByLocation('Lyon', {
        minPrice: 50,
        maxPrice: 150,
        nbChambres: 2,
        typeHebergementIds: [1],
        commoditeIds: [5],
      })
      const url = __mockApi.get.mock.calls[0][0]
      expect(url).toContain('minPrice=50')
      expect(url).toContain('maxPrice=150')
      expect(url).toContain('nbChambres=2')
      expect(url).toContain('typeHebergementIds=1')
      expect(url).toContain('commoditeIds=5')
    })
  })

  // ── getTypeHebergements ─────────────────────────────────────────────────
  describe('getTypeHebergements()', () => {
    it('appelle GET /TypeHebergements', async () => {
      __mockApi.get.mockResolvedValue({ data: [] })
      await annoncesService.getTypeHebergements()
      expect(__mockApi.get).toHaveBeenCalledWith('/TypeHebergements')
    })
  })

  // ── getCommoditesByCategories ───────────────────────────────────────────
  describe('getCommoditesByCategories()', () => {
    it('appelle GET /Commodites/by-categories', async () => {
      __mockApi.get.mockResolvedValue({ data: [] })
      await annoncesService.getCommoditesByCategories()
      expect(__mockApi.get).toHaveBeenCalledWith('/Commodites/by-categories')
    })
  })

  // ── Favoris ─────────────────────────────────────────────────────────────
  describe('Favoris', () => {
    it('getFavorites appelle GET /Annonces/favorites/:userId', async () => {
      __mockApi.get.mockResolvedValue({ data: [] })
      await annoncesService.getFavorites(7)
      expect(__mockApi.get).toHaveBeenCalledWith('/Annonces/favorites/7')
    })

    it('getFavoriteIds appelle GET /Annonces/favorites/ids/:userId', async () => {
      __mockApi.get.mockResolvedValue({ data: [] })
      await annoncesService.getFavoriteIds(7)
      expect(__mockApi.get).toHaveBeenCalledWith('/Annonces/favorites/ids/7')
    })

    it('addFavorite appelle POST /Annonces/:annonceId/favorite/:userId', async () => {
      __mockApi.post.mockResolvedValue({ data: {} })
      await annoncesService.addFavorite(3, 7)
      expect(__mockApi.post).toHaveBeenCalledWith('/Annonces/3/favorite/7', {})
    })

    it('removeFavorite appelle DELETE /Annonces/:annonceId/favorite/:userId', async () => {
      __mockApi.delete.mockResolvedValue({ data: {} })
      await annoncesService.removeFavorite(3, 7)
      expect(__mockApi.delete).toHaveBeenCalledWith('/Annonces/3/favorite/7')
    })

    it('addFavorite retourne la donnée de réponse', async () => {
      __mockApi.post.mockResolvedValue({ data: { success: true } })
      const result = await annoncesService.addFavorite(3, 7)
      expect(result).toEqual({ success: true })
    })
  })
})
