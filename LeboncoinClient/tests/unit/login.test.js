import { describe, it, expect, vi, beforeEach } from 'vitest'
import { mount } from '@vue/test-utils'
import Login from '@/views/auth/LoginView.vue'

// ── Hoisted mocks (must be declared before vi.mock factories run) ─────────────
const { mockPush, mockGet, mockPost, mockLogin, mockHasPermission } = vi.hoisted(() => ({
  mockPush:          vi.fn(),
  mockGet:           vi.fn(),
  mockPost:          vi.fn(),
  mockLogin:         vi.fn(),
  mockHasPermission: vi.fn(),
}))

// ── Router mock ──────────────────────────────────────────────────────────────
vi.mock('vue-router', () => ({
  useRouter: () => ({ push: mockPush }),
}))

// ── API mock ─────────────────────────────────────────────────────────────────
vi.mock('@/api/axios', () => ({
  default: { get: mockGet, post: mockPost },
}))

// ── Auth mock ─────────────────────────────────────────────────────────────────
vi.mock('@/auth.js', () => ({
  authState: {
    token: null,
    user: null,
    login: mockLogin,
    hasPermission: mockHasPermission,
  },
}))

// ── Helpers ───────────────────────────────────────────────────────────────────
function createWrapper() {
  return mount(Login, {
    global: { stubs: ['router-link', 'router-view'] },
  })
}

// ── Tests ─────────────────────────────────────────────────────────────────────
describe('LoginView.vue', () => {
  let wrapper

  beforeEach(() => {
    vi.clearAllMocks()
    wrapper = createWrapper()
  })

  // ── Rendu initial ────────────────────────────────────────────────────────
  describe('Rendu initial', () => {
    it('affiche le titre de connexion', () => {
      expect(wrapper.text()).toContain('Connectez-vous')
    })

    it('affiche le champ email', () => {
      expect(wrapper.find('input[type="email"]').exists()).toBe(true)
    })

    it("n'affiche pas le champ mot de passe tant que l'email n'est pas confirmé", () => {
      expect(wrapper.find('input[type="password"]').exists()).toBe(false)
    })

    it("n'affiche pas le bouton modifier l'email au départ", () => {
      expect(wrapper.find('.modifier-btn').exists()).toBe(false)
    })

    it("n'affiche pas l'overlay de succès au départ", () => {
      expect(wrapper.vm.loginSuccess).toBe(false)
    })
  })

  // ── Validation email ─────────────────────────────────────────────────────
  describe('Validation email', () => {
    it('affiche une erreur si le champ email est vide', async () => {
      await wrapper.vm.login()
      expect(wrapper.vm.errors.email).toBeTruthy()
      expect(mockGet).not.toHaveBeenCalled()
    })

    it('affiche une erreur pour un email invalide', async () => {
      wrapper.vm.form.email = 'pas-un-email'
      await wrapper.vm.login()
      expect(wrapper.vm.errors.email).toBeTruthy()
      expect(mockGet).not.toHaveBeenCalled()
    })

    it("n'affiche pas d'erreur pour un email valide", async () => {
      mockGet.mockResolvedValueOnce({ data: {} })
      wrapper.vm.form.email = 'user@example.com'
      await wrapper.vm.login()
      expect(wrapper.vm.errors.email).toBeFalsy()
    })

    it('efface les erreurs email à chaque nouvel appel', async () => {
      wrapper.vm.errors.email = 'ancienne erreur'
      wrapper.vm.form.email = 'user@example.com'
      mockGet.mockResolvedValueOnce({ data: {} })
      await wrapper.vm.login()
      expect(wrapper.vm.errors.email).toBe('')
    })
  })

  // ── Vérification email (étape 1) ─────────────────────────────────────────
  describe("Vérification de l'existence de l'email", () => {
    it("appelle GET /Utilisateurs/check-email avec l'email saisi", async () => {
      mockGet.mockResolvedValueOnce({ data: { exists: true } })
      wrapper.vm.form.email = 'user@example.com'
      await wrapper.vm.login()
      expect(mockGet).toHaveBeenCalledWith('/Utilisateurs/check-email', { params: { email: 'user@example.com' } })
    })

    it('passe emailExists à true si le GET réussit avec exists: true', async () => {
      mockGet.mockResolvedValueOnce({ data: { exists: true } })
      wrapper.vm.form.email = 'user@example.com'
      await wrapper.vm.login()
      expect(wrapper.vm.emailExists).toBe(true)
    })

    it('redirige vers register avec le query email si exists: false', async () => {
      mockGet.mockResolvedValueOnce({ data: { exists: false } })
      wrapper.vm.form.email = 'nouveau@example.com'
      await wrapper.vm.login()
      expect(mockPush).toHaveBeenCalledWith({
        name: 'register',
        query: { email: 'nouveau@example.com' },
      })
    })

    it('affiche une erreur serveur pour une erreur autre que 404', async () => {
      mockGet.mockRejectedValueOnce({ response: { status: 500 } })
      wrapper.vm.form.email = 'user@example.com'
      await wrapper.vm.login()
      expect(wrapper.vm.apiError).toBeTruthy()
      expect(mockPush).not.toHaveBeenCalled()
    })
  })

  // ── Affichage conditionnel après confirmation email ──────────────────────
  describe('Après confirmation email (emailExists = true)', () => {
    beforeEach(async () => {
      wrapper.vm.emailExists = true
      await wrapper.vm.$nextTick()
    })

    it('affiche le champ mot de passe', () => {
      expect(wrapper.find('.password-wrapper').exists()).toBe(true)
    })

    it("affiche le bouton modifier l'email", () => {
      expect(wrapper.find('.modifier-btn').exists()).toBe(true)
    })

    it("remet emailExists à false au clic sur modifier l'email", async () => {
      await wrapper.find('.modifier-btn').trigger('click')
      expect(wrapper.vm.emailExists).toBe(false)
    })

    it('désactive le champ email', () => {
      const emailInput = wrapper.find('input[type="email"]')
      expect(emailInput.attributes('disabled')).toBeDefined()
    })
  })

  // ── Toggle visibilité mot de passe ───────────────────────────────────────
  describe('Toggle visibilité mot de passe', () => {
    beforeEach(async () => {
      wrapper.vm.emailExists = true
      await wrapper.vm.$nextTick()
    })

    it('showPasswordConfirm est false par défaut', () => {
      expect(wrapper.vm.showPasswordConfirm).toBe(false)
    })

    it('bascule showPasswordConfirm au clic sur le bouton toggle', async () => {
      await wrapper.find('.toggle-btn').trigger('click')
      expect(wrapper.vm.showPasswordConfirm).toBe(true)
    })

    it('affiche "Masquer" quand le mot de passe est visible', async () => {
      wrapper.vm.showPasswordConfirm = true
      await wrapper.vm.$nextTick()
      expect(wrapper.find('.toggle-btn').text()).toBe('Masquer')
    })

    it('affiche "Afficher" quand le mot de passe est masqué', () => {
      expect(wrapper.find('.toggle-btn').text()).toBe('Afficher')
    })
  })

  // ── Connexion avec mot de passe (étape 2) ────────────────────────────────
  describe('Connexion avec mot de passe', () => {
    beforeEach(() => {
      wrapper.vm.emailExists = true
      wrapper.vm.form.email = 'user@example.com'
      wrapper.vm.form.password = 'password123'
    })

    it('appelle POST /Utilisateurs/login avec email et password', async () => {
      mockPost.mockResolvedValueOnce({ data: { token: 'abc' } })
      mockHasPermission.mockReturnValue(true)
      await wrapper.vm.login()
      expect(mockPost).toHaveBeenCalledWith('/Utilisateurs/login', {
        email: 'user@example.com',
        password: 'password123',
      })
    })

    it('appelle authState.login avec la réponse du serveur', async () => {
      const responseData = { token: 'abc', pseudonyme: 'JohnDoe' }
      mockPost.mockResolvedValueOnce({ data: responseData })
      mockHasPermission.mockReturnValue(true)
      await wrapper.vm.login()
      expect(mockLogin).toHaveBeenCalledWith(responseData)
    })

    it("redirige vers 'home' si l'utilisateur a la permission app.view.home", async () => {
      vi.useFakeTimers()
      mockPost.mockResolvedValueOnce({ data: {} })
      mockHasPermission.mockImplementation((p) => p === 'app.view.home')
      await wrapper.vm.login()
      vi.runAllTimers()
      expect(mockPush).toHaveBeenCalledWith({ name: 'home' })
      vi.useRealTimers()
    })

    it("redirige vers 'service-dashboard' sans la permission home", async () => {
      vi.useFakeTimers()
      mockPost.mockResolvedValueOnce({ data: {} })
      mockHasPermission.mockReturnValue(false)
      await wrapper.vm.login()
      vi.runAllTimers()
      expect(mockPush).toHaveBeenCalledWith({ name: 'service-dashboard' })
      vi.useRealTimers()
    })

    it('affiche le message string du serveur en cas de mauvais mot de passe', async () => {
      mockPost.mockRejectedValueOnce({
        response: { data: 'Mot de passe incorrect.' },
      })
      await wrapper.vm.login()
      expect(wrapper.vm.apiError).toBe('Mot de passe incorrect.')
    })

    it("affiche 'Erreur de connexion.' si la réponse est un objet", async () => {
      mockPost.mockRejectedValueOnce({
        response: { data: { code: 401 } },
      })
      await wrapper.vm.login()
      expect(wrapper.vm.apiError).toBe('Erreur de connexion.')
    })

    it("affiche 'Le serveur est injoignable.' si pas de réponse réseau", async () => {
      mockPost.mockRejectedValueOnce(new Error('Network Error'))
      await wrapper.vm.login()
      expect(wrapper.vm.apiError).toBe('Le serveur est injoignable.')
    })
  })
})