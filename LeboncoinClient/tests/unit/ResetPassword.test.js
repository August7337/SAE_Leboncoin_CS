import { describe, it, expect, vi, beforeEach } from 'vitest'
import { mount } from '@vue/test-utils'
import ResetPassword from '@/views/auth/ResetPasswordView.vue'
const { mockPush, mockPost } = vi.hoisted(() => ({
  mockPush: vi.fn(),
  mockPost: vi.fn(),
}))

vi.mock('vue-router', () => ({
  useRouter: () => ({ push: mockPush }),
  useRoute:  () => ({ query: { token: 'valid-token-abc' } }),
}))

vi.mock('@/api/axios', () => ({
  default: { post: mockPost },
}))
function createWrapper() {
  return mount(ResetPassword, {
    global: { stubs: ['router-link', 'router-view'] },
  })
}

function fillValidForm(vm) {
  vm.form.password        = 'newpassword123'
  vm.form.confirmPassword = 'newpassword123'
}

describe('ResetPasswordView.vue', () => {
  let wrapper

  beforeEach(() => {
    vi.clearAllMocks()
    wrapper = createWrapper()
  })
  describe('Rendu initial', () => {
    it('affiche le titre "Nouveau mot de passe"', () => {
      expect(wrapper.text()).toContain('Nouveau mot de passe')
    })

    it('affiche les deux champs mot de passe', () => {
      const inputs = wrapper.findAll('input[type="password"]')
      expect(inputs.length).toBe(2)
    })

    it("n'affiche pas l'overlay de succès au départ", () => {
      expect(wrapper.vm.showSuccess).toBe(false)
    })
  })
  describe('Validation', () => {
    it('affiche une erreur si le mot de passe fait moins de 8 caractères', async () => {
      wrapper.vm.form.password        = 'short'
      wrapper.vm.form.confirmPassword = 'short'
      await wrapper.vm.handleReset()
      expect(wrapper.vm.apiError).toContain('8 caractères')
      expect(mockPost).not.toHaveBeenCalled()
    })

    it('affiche une erreur si les mots de passe ne correspondent pas', async () => {
      wrapper.vm.form.password        = 'password123'
      wrapper.vm.form.confirmPassword = 'different123'
      await wrapper.vm.handleReset()
      expect(wrapper.vm.apiError).toContain('correspondent pas')
      expect(mockPost).not.toHaveBeenCalled()
    })

    it('efface apiError avant chaque soumission', async () => {
      wrapper.vm.apiError = 'ancienne erreur'
      fillValidForm(wrapper.vm)
      mockPost.mockResolvedValueOnce({})
      await wrapper.vm.handleReset()
      expect(wrapper.vm.apiError).toBe('')
    })
  })

  describe('Soumission réussie', () => {
    it('appelle POST /Utilisateurs/reset-password avec le token et le nouveau mot de passe', async () => {
      fillValidForm(wrapper.vm)
      mockPost.mockResolvedValueOnce({})
      await wrapper.vm.handleReset()
      expect(mockPost).toHaveBeenCalledWith('/Utilisateurs/reset-password', {
        token:       'valid-token-abc',
        newPassword: 'newpassword123',
      })
    })

    it('passe showSuccess à true après succès', async () => {
      fillValidForm(wrapper.vm)
      mockPost.mockResolvedValueOnce({})
      await wrapper.vm.handleReset()
      expect(wrapper.vm.showSuccess).toBe(true)
    })

    it("redirige vers 'login' après le délai", async () => {
      vi.useFakeTimers()
      fillValidForm(wrapper.vm)
      mockPost.mockResolvedValueOnce({})
      await wrapper.vm.handleReset()
      vi.runAllTimers()
      expect(mockPush).toHaveBeenCalledWith({ name: 'login' })
      vi.useRealTimers()
    })

    it('remet isSaving à false après succès', async () => {
      fillValidForm(wrapper.vm)
      mockPost.mockResolvedValueOnce({})
      await wrapper.vm.handleReset()
      expect(wrapper.vm.isSaving).toBe(false)
    })
  })


  describe('Erreur API', () => {
    it("affiche 'Lien invalide ou expiré.' en cas d'erreur serveur", async () => {
      fillValidForm(wrapper.vm)
      mockPost.mockRejectedValueOnce({ response: { status: 400 } })
      await wrapper.vm.handleReset()
      expect(wrapper.vm.apiError).toBe('Lien invalide ou expiré.')
    })

    it('remet isSaving à false après une erreur', async () => {
      fillValidForm(wrapper.vm)
      mockPost.mockRejectedValueOnce({ response: { status: 400 } })
      await wrapper.vm.handleReset()
      expect(wrapper.vm.isSaving).toBe(false)
    })
  })
})
