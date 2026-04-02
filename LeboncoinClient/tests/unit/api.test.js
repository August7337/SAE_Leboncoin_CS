import { describe, it, expect, vi, beforeEach, afterEach } from 'vitest'


// ── Helpers ──────────────────────────────────────────────────────────────────
async function freshModule(envUrl = '') {
  vi.resetModules()
  vi.stubEnv('VITE_API_BASE_URL', envUrl)
  return import('@/services/api.js')
}

// ── Tests ────────────────────────────────────────────────────────────────────
describe('api.js', () => {
  afterEach(() => {
    vi.unstubAllEnvs()
  })

  // ── API_BASE_URL ────────────────────────────────────────────────────────
  describe('API_BASE_URL', () => {
    it('utilise la valeur de VITE_API_BASE_URL quand elle est définie', async () => {
      const { API_BASE_URL } = await freshModule('https://api.example.com')
      expect(API_BASE_URL).toBe('https://api.example.com')
    })

    it('retombe sur l\'URL par défaut si VITE_API_BASE_URL est vide', async () => {
      const { API_BASE_URL } = await freshModule('')
      expect(API_BASE_URL).toBe('https://leboncoinapi-b0b2bmazh9ebdqef.spaincentral-01.azurewebsites.net/api')
    })

    it('supprime le slash final de VITE_API_BASE_URL', async () => {
      const { API_BASE_URL } = await freshModule('https://api.example.com/')
      expect(API_BASE_URL).toBe('https://api.example.com')
    })

    it('supprime les slashes finaux multiples', async () => {
      const { API_BASE_URL } = await freshModule('https://api.example.com///')
      expect(API_BASE_URL).toBe('https://api.example.com')
    })

    it('ignore les espaces autour de la valeur de VITE_API_BASE_URL', async () => {
      const { API_BASE_URL } = await freshModule('  https://api.example.com  ')
      expect(API_BASE_URL).toBe('https://api.example.com')
    })
  })

  // ── buildApiUrl ─────────────────────────────────────────────────────────
  describe('buildApiUrl()', () => {
    it('concatène base URL et path avec slash', async () => {
      const { buildApiUrl } = await freshModule('https://api.example.com')
      expect(buildApiUrl('/users')).toBe('https://api.example.com/users')
    })

    it('ajoute un slash si le path ne commence pas par /', async () => {
      const { buildApiUrl } = await freshModule('https://api.example.com')
      expect(buildApiUrl('users')).toBe('https://api.example.com/users')
    })

    it("retourne juste la base URL avec '/' si path est vide", async () => {
      const { buildApiUrl } = await freshModule('https://api.example.com')
      expect(buildApiUrl('')).toBe('https://api.example.com/')
    })

    it('préserve les query strings dans le path', async () => {
      const { buildApiUrl } = await freshModule('https://api.example.com')
      expect(buildApiUrl('/search?q=test')).toBe('https://api.example.com/search?q=test')
    })
  })

  // ── buildAssetUrl ───────────────────────────────────────────────────────
  describe('buildAssetUrl()', () => {
    it("retourne '' si assetPath est vide", async () => {
      const { buildAssetUrl } = await freshModule('https://api.example.com')
      expect(buildAssetUrl('')).toBe('')
    })

    it('retourne une URL absolue http:// telle quelle', async () => {
      const { buildAssetUrl } = await freshModule('https://api.example.com')
      expect(buildAssetUrl('http://cdn.com/img.jpg')).toBe('http://cdn.com/img.jpg')
    })

    it('retourne une URL absolue https:// telle quelle', async () => {
      const { buildAssetUrl } = await freshModule('https://api.example.com')
      expect(buildAssetUrl('https://cdn.com/img.jpg')).toBe('https://cdn.com/img.jpg')
    })

    it('construit une URL depuis un chemin relatif', async () => {
      const { buildAssetUrl } = await freshModule('https://api.example.com')
      expect(buildAssetUrl('uploads/photo.jpg')).toBe('https://api.example.com/uploads/photo.jpg')
    })

    it('supprime le slash initial du chemin relatif pour éviter le double slash', async () => {
      const { buildAssetUrl } = await freshModule('https://api.example.com')
      expect(buildAssetUrl('/uploads/photo.jpg')).toBe('https://api.example.com/uploads/photo.jpg')
    })

    it('supprime les slashes initiaux multiples', async () => {
      const { buildAssetUrl } = await freshModule('https://api.example.com')
      expect(buildAssetUrl('///uploads/photo.jpg')).toBe('https://api.example.com/uploads/photo.jpg')
    })
  })

  // ── apiFetch / apiJson ──────────────────────────────────────────────────
  describe('apiFetch()', () => {
    beforeEach(() => {
      vi.stubGlobal('fetch', vi.fn())
    })

    it('appelle fetch avec la bonne URL et cache: no-cache', async () => {
      const { apiFetch } = await freshModule('https://api.example.com')
      vi.mocked(fetch).mockResolvedValue({ ok: true, status: 200 })
      await apiFetch('/test')
      expect(fetch).toHaveBeenCalledWith(
        'https://api.example.com/test',
        expect.objectContaining({ cache: 'no-cache' }),
      )
    })

    it('lève une erreur si response.ok est false', async () => {
      const { apiFetch } = await freshModule('https://api.example.com')
      vi.mocked(fetch).mockResolvedValue({ ok: false, status: 404 })
      await expect(apiFetch('/missing')).rejects.toThrow('Erreur HTTP 404')
    })
  })

  describe('apiJson()', () => {
    beforeEach(() => {
      vi.stubGlobal('fetch', vi.fn())
    })

    it('retourne null pour une réponse 204 No Content', async () => {
      const { apiJson } = await freshModule('https://api.example.com')
      vi.mocked(fetch).mockResolvedValue({ ok: true, status: 204 })
      const result = await apiJson('/empty')
      expect(result).toBeNull()
    })

    it('parse et retourne le JSON pour une réponse 200', async () => {
      const { apiJson } = await freshModule('https://api.example.com')
      vi.mocked(fetch).mockResolvedValue({
        ok: true,
        status: 200,
        json: () => Promise.resolve({ id: 1 }),
      })
      const result = await apiJson('/data')
      expect(result).toEqual({ id: 1 })
    })
  })

  // ── getJson / postJson / putJson / deleteRequest ────────────────────────
  describe('Méthodes HTTP raccourcies', () => {
    beforeEach(() => {
      vi.stubGlobal('fetch', vi.fn())
    })

    it('getJson utilise la méthode GET', async () => {
      const { getJson } = await freshModule('https://api.example.com')
      vi.mocked(fetch).mockResolvedValue({
        ok: true, status: 200, json: () => Promise.resolve({}),
      })
      await getJson('/items')
      expect(fetch).toHaveBeenCalledWith(
        expect.any(String),
        expect.objectContaining({ method: 'GET' }),
      )
    })

    it('postJson utilise la méthode POST et sérialise le body', async () => {
      const { postJson } = await freshModule('https://api.example.com')
      vi.mocked(fetch).mockResolvedValue({
        ok: true, status: 200, json: () => Promise.resolve({}),
      })
      await postJson('/items', { name: 'Test' })
      expect(fetch).toHaveBeenCalledWith(
        expect.any(String),
        expect.objectContaining({
          method: 'POST',
          body: JSON.stringify({ name: 'Test' }),
          headers: expect.objectContaining({ 'Content-Type': 'application/json' }),
        }),
      )
    })

    it('putJson utilise la méthode PUT et sérialise le body', async () => {
      const { putJson } = await freshModule('https://api.example.com')
      vi.mocked(fetch).mockResolvedValue({
        ok: true, status: 200, json: () => Promise.resolve({}),
      })
      await putJson('/items/1', { name: 'Updated' })
      expect(fetch).toHaveBeenCalledWith(
        expect.any(String),
        expect.objectContaining({ method: 'PUT' }),
      )
    })

    it('deleteRequest utilise la méthode DELETE', async () => {
      const { deleteRequest } = await freshModule('https://api.example.com')
      vi.mocked(fetch).mockResolvedValue({ ok: true, status: 204 })
      await deleteRequest('/items/1')
      expect(fetch).toHaveBeenCalledWith(
        expect.any(String),
        expect.objectContaining({ method: 'DELETE' }),
      )
    })
  })
})
