import { describe, it, expect, vi, beforeEach } from 'vitest'
import { mount } from '@vue/test-utils'

// ── cookieManager mock ────────────────────────────────────────────────────────
vi.mock('@/cookieManager.js', () => {
  const mockCookieState = { hasAnswered: false, showSettings: false, preferences: { maps: false, chatbot: false } }
  const mockAcceptAll = vi.fn()
  const mockRejectAll = vi.fn()
  const mockOpenCookieSettings = vi.fn()
  const mockCloseCookieSettings = vi.fn()
  const mockSaveCookiePreferences = vi.fn()

  return {
    cookieState: mockCookieState,
    acceptAll: mockAcceptAll,
    rejectAll: mockRejectAll,
    openCookieSettings: mockOpenCookieSettings,
    closeCookieSettings: mockCloseCookieSettings,
    saveCookiePreferences: mockSaveCookiePreferences,
    __mockCookieState: mockCookieState,
    __mockAcceptAll: mockAcceptAll,
    __mockRejectAll: mockRejectAll,
    __mockOpenCookieSettings: mockOpenCookieSettings,
    __mockCloseCookieSettings: mockCloseCookieSettings,
    __mockSaveCookiePreferences: mockSaveCookiePreferences,
  }
})

vi.mock('vue-router', () => ({
  useRouter: () => ({ push: vi.fn() }),
  RouterLink: { template: '<a><slot /></a>' },
}))

import CookieBanner from '@/components/CookieBanner.vue'
import CookieSettings from '@/components/CookieSettings.vue'
import {
  __mockCookieState,
  __mockAcceptAll,
  __mockRejectAll,
  __mockOpenCookieSettings,
  __mockCloseCookieSettings,
  __mockSaveCookiePreferences,
} from '@/cookieManager.js'

// ── Tests CookieBanner ────────────────────────────────────────────────────────
describe('CookieBanner.vue', () => {
  beforeEach(() => {
    vi.clearAllMocks()
    mockCookieState.hasAnswered = false
    mockCookieState.showSettings = false
  })

  it("affiche la bannière quand hasAnswered est false", () => {
    const wrapper = mount(CookieBanner, {
      global: { stubs: ['router-link'] },
    })
    expect(wrapper.find('[class*="fixed"]').exists()).toBe(true)
  })

  it("n'affiche pas la bannière quand hasAnswered est true", () => {
    mockCookieState.hasAnswered = true
    const wrapper = mount(CookieBanner, {
      global: { stubs: ['router-link'] },
    })
    // v-if=!hasAnswered → inner div absent
    expect(wrapper.html()).not.toContain('Votre vie privée')
  })

  it('appelle rejectAll au clic sur "Tout refuser"', async () => {
    const wrapper = mount(CookieBanner, {
      global: { stubs: ['router-link'] },
    })
    await wrapper.find('button:first-of-type').trigger('click')
    expect(mockRejectAll).toHaveBeenCalledOnce()
  })

  it('appelle openCookieSettings au clic sur "Paramétrer"', async () => {
    const wrapper = mount(CookieBanner, {
      global: { stubs: ['router-link'] },
    })
    const buttons = wrapper.findAll('button')
    const settingsBtn = buttons.find((b) => b.text() === 'Paramétrer')
    await settingsBtn.trigger('click')
    expect(mockOpenCookieSettings).toHaveBeenCalledOnce()
  })

  it('appelle acceptAll au clic sur "Tout accepter"', async () => {
    const wrapper = mount(CookieBanner, {
      global: { stubs: ['router-link'] },
    })
    const buttons = wrapper.findAll('button')
    const acceptBtn = buttons.find((b) => b.text() === 'Tout accepter')
    await acceptBtn.trigger('click')
    expect(mockAcceptAll).toHaveBeenCalledOnce()
  })

  it('affiche le texte principal de consentement', () => {
    const wrapper = mount(CookieBanner, {
      global: { stubs: ['router-link'] },
    })
    expect(wrapper.text()).toContain('Votre vie privée')
  })
})

// ── Tests CookieSettings ──────────────────────────────────────────────────────
describe('CookieSettings.vue', () => {
  function mountSettings(showSettings = true, preferences = { maps: false, chatbot: false }) {
    mockCookieState.showSettings = showSettings
    mockCookieState.preferences = { ...preferences }
    return mount(CookieSettings, {
      global: { stubs: ['router-link'] },
    })
  }

  beforeEach(() => {
    vi.clearAllMocks()
  })

  // ── Rendu ──────────────────────────────────────────────────────────────
  describe('Rendu', () => {
    it('affiche la modale quand showSettings est true', () => {
      const wrapper = mountSettings(true)
      expect(wrapper.text()).toContain('Préférences de cookies')
    })

    it("n'affiche pas la modale quand showSettings est false", () => {
      const wrapper = mountSettings(false)
      expect(wrapper.html()).not.toContain('Préférences de cookies')
    })

    it('les détails sont masqués par défaut', () => {
      const wrapper = mountSettings()
      expect(wrapper.vm.showDetails).toBe(false)
    })

    it('affiche les détails après clic sur le bouton toggle', async () => {
      const wrapper = mountSettings()
      const toggleBtn = wrapper.find('button')
      await toggleBtn.trigger('click')
      expect(wrapper.vm.showDetails).toBe(true)
    })
  })

  // ── toggleAll computed ─────────────────────────────────────────────────
  describe('toggleAll (computed)', () => {
    it('retourne false si maps et chatbot sont false', () => {
      const wrapper = mountSettings(true, { maps: false, chatbot: false })
      expect(wrapper.vm.toggleAll).toBe(false)
    })

    it('retourne false si seulement maps est true', () => {
      const wrapper = mountSettings(true, { maps: true, chatbot: false })
      expect(wrapper.vm.toggleAll).toBe(false)
    })

    it('retourne true si maps ET chatbot sont true', () => {
      const wrapper = mountSettings(true, { maps: true, chatbot: true })
      expect(wrapper.vm.toggleAll).toBe(true)
    })

    it('passe maps et chatbot à true quand toggleAll est mis à true', () => {
      const wrapper = mountSettings(true, { maps: false, chatbot: false })
      wrapper.vm.toggleAll = true
      expect(wrapper.vm.localPreferences.maps).toBe(true)
      expect(wrapper.vm.localPreferences.chatbot).toBe(true)
    })

    it('passe maps et chatbot à false quand toggleAll est mis à false', () => {
      const wrapper = mountSettings(true, { maps: true, chatbot: true })
      wrapper.vm.toggleAll = false
      expect(wrapper.vm.localPreferences.maps).toBe(false)
      expect(wrapper.vm.localPreferences.chatbot).toBe(false)
    })
  })

  // ── localPreferences sync ──────────────────────────────────────────────
  describe('Synchronisation de localPreferences', () => {
    it('initialise localPreferences depuis cookieState.preferences', () => {
      const wrapper = mountSettings(true, { maps: true, chatbot: false })
      expect(wrapper.vm.localPreferences.maps).toBe(true)
      expect(wrapper.vm.localPreferences.chatbot).toBe(false)
    })

    it('ne mute pas cookieState.preferences directement', () => {
      const wrapper = mountSettings(true, { maps: false, chatbot: false })
      wrapper.vm.localPreferences.maps = true
      expect(mockCookieState.preferences.maps).toBe(false)
    })
  })

  // ── savePreferences ────────────────────────────────────────────────────
  describe('savePreferences()', () => {
    it('appelle saveCookiePreferences avec les préférences locales', async () => {
      const wrapper = mountSettings(true, { maps: true, chatbot: false })
      wrapper.vm.savePreferences()
      expect(mockSaveCookiePreferences).toHaveBeenCalledWith({ maps: true, chatbot: false })
    })
  })

  // ── rejectAll ──────────────────────────────────────────────────────────
  describe('Bouton "Tout refuser"', () => {
    it('appelle rejectAll', async () => {
      const wrapper = mountSettings()
      const buttons = wrapper.findAll('button')
      const refuserBtn = buttons.find((b) => b.text() === 'Tout refuser')
      await refuserBtn.trigger('click')
      expect(mockRejectAll).toHaveBeenCalledOnce()
    })
  })

  // ── closeCookieSettings ────────────────────────────────────────────────
  describe('Fermeture de la modale', () => {
    it('appelle closeCookieSettings au clic sur le bouton ✕', async () => {
      const wrapper = mountSettings()
      // The close (×) button is in the header of the modal
      const closeBtn = wrapper.find('button')
      await closeBtn.trigger('click')
      expect(mockCloseCookieSettings).toHaveBeenCalled()
    })

    it('appelle closeCookieSettings au clic sur l\'overlay', async () => {
      const wrapper = mountSettings()
      const overlay = wrapper.find('.absolute.inset-0')
      await overlay.trigger('click')
      expect(mockCloseCookieSettings).toHaveBeenCalled()
    })
  })
})
