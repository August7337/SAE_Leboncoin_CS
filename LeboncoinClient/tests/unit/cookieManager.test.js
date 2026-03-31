import { describe, it, expect, vi, beforeEach } from 'vitest'

// ── localStorage mock ────────────────────────────────────────────────────────
const localStorageMock = (() => {
  let store = {}
  return {
    getItem: vi.fn((key) => store[key] ?? null),
    setItem: vi.fn((key, value) => { store[key] = String(value) }),
    removeItem: vi.fn((key) => { delete store[key] }),
    clear: vi.fn(() => { store = {} }),
    _store: () => store,
  }
})()
Object.defineProperty(window, 'localStorage', { value: localStorageMock })

// ── Helpers ──────────────────────────────────────────────────────────────────
const STORAGE_KEY = 'leboncoin_cookie_consent'

async function freshModule() {
  vi.resetModules()
  return import('@/cookieManager.js')
}

// ── Tests ────────────────────────────────────────────────────────────────────
describe('cookieManager.js', () => {
  beforeEach(() => {
    vi.clearAllMocks()
    localStorageMock.clear()
  })

  // ── État initial ────────────────────────────────────────────────────────
  describe('État initial', () => {
    it("initialise hasAnswered à false quand aucun consentement n'est stocké", async () => {
      const { cookieState } = await freshModule()
      expect(cookieState.hasAnswered).toBe(false)
    })

    it('initialise les préférences à false par défaut', async () => {
      const { cookieState } = await freshModule()
      expect(cookieState.preferences.maps).toBe(false)
      expect(cookieState.preferences.chatbot).toBe(false)
    })

    it('restaure les préférences depuis localStorage si elles existent', async () => {
      localStorageMock.getItem.mockReturnValueOnce(JSON.stringify({ maps: true, chatbot: false }))
      const { cookieState } = await freshModule()
      expect(cookieState.hasAnswered).toBe(true)
      expect(cookieState.preferences.maps).toBe(true)
      expect(cookieState.preferences.chatbot).toBe(false)
    })

    it('initialise showSettings à false', async () => {
      const { cookieState } = await freshModule()
      expect(cookieState.showSettings).toBe(false)
    })
  })

  // ── saveCookiePreferences ──────────────────────────────────────────────
  describe('saveCookiePreferences', () => {
    it('met à jour les préférences dans le state', async () => {
      const { cookieState, saveCookiePreferences } = await freshModule()
      saveCookiePreferences({ maps: true, chatbot: true })
      expect(cookieState.preferences.maps).toBe(true)
      expect(cookieState.preferences.chatbot).toBe(true)
    })

    it('passe hasAnswered à true', async () => {
      const { cookieState, saveCookiePreferences } = await freshModule()
      saveCookiePreferences({ maps: false, chatbot: false })
      expect(cookieState.hasAnswered).toBe(true)
    })

    it('ferme le panneau de paramètres', async () => {
      const { cookieState, openCookieSettings, saveCookiePreferences } = await freshModule()
      openCookieSettings()
      expect(cookieState.showSettings).toBe(true)
      saveCookiePreferences({ maps: false, chatbot: false })
      expect(cookieState.showSettings).toBe(false)
    })

    it('persiste les préférences dans localStorage', async () => {
      const { saveCookiePreferences } = await freshModule()
      saveCookiePreferences({ maps: true, chatbot: false })
      expect(localStorageMock.setItem).toHaveBeenCalledWith(
        STORAGE_KEY,
        JSON.stringify({ maps: true, chatbot: false }),
      )
    })

    it('ne mute pas les préférences passées en argument', async () => {
      const { cookieState, saveCookiePreferences } = await freshModule()
      const prefs = { maps: false, chatbot: false }
      saveCookiePreferences(prefs)
      cookieState.preferences.maps = true
      expect(prefs.maps).toBe(false)
    })
  })

  // ── acceptAll ──────────────────────────────────────────────────────────
  describe('acceptAll', () => {
    it('active maps et chatbot', async () => {
      const { cookieState, acceptAll } = await freshModule()
      acceptAll()
      expect(cookieState.preferences.maps).toBe(true)
      expect(cookieState.preferences.chatbot).toBe(true)
    })

    it('passe hasAnswered à true', async () => {
      const { cookieState, acceptAll } = await freshModule()
      acceptAll()
      expect(cookieState.hasAnswered).toBe(true)
    })

    it('sauvegarde dans localStorage', async () => {
      const { acceptAll } = await freshModule()
      acceptAll()
      expect(localStorageMock.setItem).toHaveBeenCalledWith(
        STORAGE_KEY,
        JSON.stringify({ maps: true, chatbot: true }),
      )
    })
  })

  // ── rejectAll ──────────────────────────────────────────────────────────
  describe('rejectAll', () => {
    it('désactive maps et chatbot', async () => {
      const { cookieState, rejectAll } = await freshModule()
      rejectAll()
      expect(cookieState.preferences.maps).toBe(false)
      expect(cookieState.preferences.chatbot).toBe(false)
    })

    it('passe hasAnswered à true', async () => {
      const { cookieState, rejectAll } = await freshModule()
      rejectAll()
      expect(cookieState.hasAnswered).toBe(true)
    })

    it('sauvegarde dans localStorage', async () => {
      const { rejectAll } = await freshModule()
      rejectAll()
      expect(localStorageMock.setItem).toHaveBeenCalledWith(
        STORAGE_KEY,
        JSON.stringify({ maps: false, chatbot: false }),
      )
    })

    it('écrase une valeur acceptAll précédente', async () => {
      const { cookieState, acceptAll, rejectAll } = await freshModule()
      acceptAll()
      rejectAll()
      expect(cookieState.preferences.maps).toBe(false)
      expect(cookieState.preferences.chatbot).toBe(false)
    })
  })

  // ── openCookieSettings / closeCookieSettings ──────────────────────────
  describe('openCookieSettings / closeCookieSettings', () => {
    it('openCookieSettings passe showSettings à true', async () => {
      const { cookieState, openCookieSettings } = await freshModule()
      openCookieSettings()
      expect(cookieState.showSettings).toBe(true)
    })

    it('closeCookieSettings passe showSettings à false', async () => {
      const { cookieState, openCookieSettings, closeCookieSettings } = await freshModule()
      openCookieSettings()
      closeCookieSettings()
      expect(cookieState.showSettings).toBe(false)
    })

    it("closeCookieSettings ne provoque pas d'erreur si déjà fermé", async () => {
      const { closeCookieSettings } = await freshModule()
      expect(() => closeCookieSettings()).not.toThrow()
    })
  })
})
