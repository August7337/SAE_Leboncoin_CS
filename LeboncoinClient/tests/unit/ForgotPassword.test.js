import { describe, it, expect, vi, beforeEach } from 'vitest'
import { mount } from '@vue/test-utils'
import ForgotPassword from '@/views/auth/ForgotPasswordView.vue'

// ── Hoisted mocks ─────────────────────────────────────────────────────────────
const { mockPush, mockPost } = vi.hoisted(() => ({
  mockPush: vi.fn(),
  mockPost: vi.fn(),
}))

vi.mock('vue-router', () => ({
  useRouter: () => ({ push: mockPush }),
  useRoute:  () => ({ query: {} }),
}))

vi.mock('@/api/axios', () => ({
  default: { post: mockPost },
}))

// ── Helpers ───────────────────────────────────────────────────────────────────
function createWrapper() {
  return mount(ForgotPassword, {
    global: { stubs: ['router-link', 'router-view'] },
  })
}

// ── Tests ─────────────────────────────────────────────────────────────────────
describe('ForgotPasswordView.vue', () => {
  let wrapper

  beforeEach(() => {
    vi.clearAllMocks()
    wrapper = createWrapper()
  })

  // ── Rendu initial ──────────────────────────────────────────────────────────
  describe('Rendu initial', () => {
    it('affiche le titre "Mot de passe oublié"', () => {
      expect(wrapper.text()).toContain('Mot de passe oublié')
    })

    it('affiche le champ email', () => {
      expect(wrapper.find('input[type="email"]').exists()).toBe(true)
    })

    it("n'affiche pas l'overlay de succès au départ", () => {
      expect(wrapper.vm.isSent).toBe(false)
    })

    it('affiche le bouton de soumission', () => {
      expect(wrapper.find('button[type="submit"]').exists()).toBe(true)
    })
  })

  // ── Validation ─────────────────────────────────────────────────────────────
  describe('Validation', () => {
    it('affiche une erreur si le champ email est vide', async () => {
      await wrapper.vm.handleForgot()
      expect(wrapper.vm.errors.email).toBeTruthy()
      expect(mockPost).not.toHaveBeenCalled()
    })

    it('efface les erreurs à chaque nouvel appel', async () => {
      wrapper.vm.errors.email = 'ancienne erreur'
      wrapper.vm.form.email = 'test@test.com'
      mockPost.mockResolvedValueOnce({})
      await wrapper.vm.handleForgot()
      expect(wrapper.vm.errors.email).toBe('')
    })
  })

  // ── Soumission réussie ─────────────────────────────────────────────────────
  describe('Soumission réussie', () => {
    it('appelle POST /Utilisateurs/forgot-password avec le bon email', async () => {
      mockPost.mockResolvedValueOnce({})
      wrapper.vm.form.email = 'user@example.com'
      await wrapper.vm.handleForgot()
      expect(mockPost).toHaveBeenCalledWith('/Utilisateurs/forgot-password', {
        email: 'user@example.com',
      })
    })

    it('passe isSent à true après succès', async () => {
      mockPost.mockResolvedValueOnce({})
      wrapper.vm.form.email = 'user@example.com'
      await wrapper.vm.handleForgot()
      expect(wrapper.vm.isSent).toBe(true)
    })

    it("redirige vers 'login' après le délai", async () => {
      vi.useFakeTimers()
      mockPost.mockResolvedValueOnce({})
      wrapper.vm.form.email = 'user@example.com'
      await wrapper.vm.handleForgot()
      vi.runAllTimers()
      expect(mockPush).toHaveBeenCalledWith({ name: 'login' })
      vi.useRealTimers()
    })

    it('remet isSending à false après succès', async () => {
      mockPost.mockResolvedValueOnce({})
      wrapper.vm.form.email = 'user@example.com'
      await wrapper.vm.handleForgot()
      expect(wrapper.vm.isSending).toBe(false)
    })
  })

  // ── Erreur API ─────────────────────────────────────────────────────────────
  describe('Erreur API', () => {
    it('affiche le message string renvoyé par le serveur', async () => {
      mockPost.mockRejectedValueOnce({ response: { data: 'Email introuvable.' } })
      wrapper.vm.form.email = 'unknown@example.com'
      await wrapper.vm.handleForgot()
      expect(wrapper.vm.apiError).toBe('Email introuvable.')
    })

    it("affiche le message générique si pas de réponse serveur", async () => {
      mockPost.mockRejectedValueOnce(new Error('Network Error'))
      wrapper.vm.form.email = 'user@example.com'
      await wrapper.vm.handleForgot()
      expect(wrapper.vm.apiError).toBe('Une erreur est survenue.')
    })

    it('remet isSending à false après une erreur', async () => {
      mockPost.mockRejectedValueOnce({ response: { data: 'Erreur' } })
      wrapper.vm.form.email = 'user@example.com'
      await wrapper.vm.handleForgot()
      expect(wrapper.vm.isSending).toBe(false)
    })
  })
})
