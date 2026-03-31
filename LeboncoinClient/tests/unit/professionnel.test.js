import { describe, it, expect, vi, beforeEach } from 'vitest'
import { mount } from '@vue/test-utils'
import Professionnel from '@/views/auth/ProfessionnelView.vue'

// ── Hoisted mocks ─────────────────────────────────────────────────────────────
const { mockPush, mockPost, mockLogin } = vi.hoisted(() => ({
  mockPush:  vi.fn(),
  mockPost:  vi.fn(),
  mockLogin: vi.fn(),
}))

vi.mock('vue-router', () => ({
  useRouter: () => ({ push: mockPush }),
}))

vi.mock('@/api/axios', () => ({
  default: { post: mockPost },
}))

vi.mock('@/auth', () => ({
  authState: { token: null, user: null, login: mockLogin },
}))

// ── sessionStorage mock ───────────────────────────────────────────────────────
const sessionStorageMock = (() => {
  let store = {}
  return {
    getItem:    vi.fn((key) => store[key] ?? null),
    setItem:    vi.fn((key, val) => { store[key] = val }),
    removeItem: vi.fn((key) => { delete store[key] }),
    clear:      vi.fn(() => { store = {} }),
  }
})()
Object.defineProperty(window, 'sessionStorage', { value: sessionStorageMock })

// ── Helpers ───────────────────────────────────────────────────────────────────
const VALID_DRAFT = {
  pseudonyme:           'ProUser',
  email:                'pro@example.com',
  password:             'password123',
  telephoneutilisateur: '0612345678',
  rue:                  '5 avenue des Affaires',
  ville:                'Lyon',
  codePostal:           '69001',
}

function createWrapper(draft = null) {
  if (draft) {
    sessionStorageMock.getItem.mockReturnValueOnce(JSON.stringify(draft))
  }
  return mount(Professionnel, {
    global: { stubs: ['router-link', 'router-view'] },
  })
}

function fillValidForm(vm) {
  vm.proForm.nomsociete      = 'Acme SARL'
  vm.proForm.numsiret        = '12345678901234'
  vm.proForm.secteuractivite = 'Informatique'
}

// ── Tests ─────────────────────────────────────────────────────────────────────
describe('RegisterProfessionnelView.vue', () => {
  let wrapper

  beforeEach(() => {
    vi.clearAllMocks()
    sessionStorageMock.clear()
    wrapper = createWrapper()
  })

  // ── Rendu initial ──────────────────────────────────────────────────────────
  describe('Rendu initial', () => {
    it('affiche le titre "Finalisez votre profil"', () => {
      expect(wrapper.text()).toContain('Finalisez votre profil')
    })

    it('affiche "Etape 2/2 (Professionnel)"', () => {
      expect(wrapper.text()).toContain('Etape 2/2 (Professionnel)')
    })

    it('affiche les champs nom de société et SIRET', () => {
      const inputs = wrapper.findAll('input')
      expect(inputs.length).toBeGreaterThanOrEqual(2)
    })

    it('affiche le select secteur avec "Automobile" par défaut', () => {
      expect(wrapper.vm.proForm.secteuractivite).toBe('Automobile')
    })

    it("n'affiche pas l'overlay de succès au départ", () => {
      expect(wrapper.vm.loginSuccess).toBe(false)
    })

    it('affiche le bouton retour', () => {
      expect(wrapper.find('.back-arrow-btn').exists()).toBe(true)
    })
  })

  // ── onMounted : restauration du brouillon ─────────────────────────────────
  describe('Restauration depuis sessionStorage (onMounted)', () => {
    it('charge dataFromStep1 depuis le brouillon', async () => {
      const w = createWrapper(VALID_DRAFT)
      await w.vm.$nextTick()
      expect(w.vm.dataFromStep1).toMatchObject({ pseudonyme: 'ProUser' })
    })

    it('pré-remplit nomsociete, numsiret et secteuractivite si présents', async () => {
      const draft = {
        ...VALID_DRAFT,
        nomsociete:      'Acme SARL',
        numsiret:        '12345678901234',
        secteuractivite: 'Immobilier',
      }
      const w = createWrapper(draft)
      await w.vm.$nextTick()
      expect(w.vm.proForm.nomsociete).toBe('Acme SARL')
      expect(w.vm.proForm.numsiret).toBe('12345678901234')
      expect(w.vm.proForm.secteuractivite).toBe('Immobilier')
    })

    it('utilise window.history.state.payload si pas de brouillon en session', async () => {
      window.history.replaceState({ payload: VALID_DRAFT }, '')
      const w = createWrapper()
      await w.vm.$nextTick()
      expect(w.vm.dataFromStep1).toMatchObject({ pseudonyme: 'ProUser' })
      window.history.replaceState({}, '')
    })
  })

  // ── Validation ─────────────────────────────────────────────────────────────
  describe('Validation du formulaire', () => {
    it('retourne false si le nom de société est vide', () => {
      fillValidForm(wrapper.vm)
      wrapper.vm.proForm.nomsociete = ''
      expect(wrapper.vm.validatePro()).toBe(false)
      expect(wrapper.vm.errors.nomsociete).toBeTruthy()
    })

    it('retourne false si le nom de société ne contient que des espaces', () => {
      fillValidForm(wrapper.vm)
      wrapper.vm.proForm.nomsociete = '   '
      expect(wrapper.vm.validatePro()).toBe(false)
      expect(wrapper.vm.errors.nomsociete).toBeTruthy()
    })

    it('retourne false si le SIRET fait moins de 14 chiffres', () => {
      fillValidForm(wrapper.vm)
      wrapper.vm.proForm.numsiret = '1234567'
      expect(wrapper.vm.validatePro()).toBe(false)
      expect(wrapper.vm.errors.numsiret).toBeTruthy()
    })

    it('retourne false si le SIRET contient des lettres', () => {
      fillValidForm(wrapper.vm)
      wrapper.vm.proForm.numsiret = '1234567890123A'
      expect(wrapper.vm.validatePro()).toBe(false)
      expect(wrapper.vm.errors.numsiret).toBeTruthy()
    })

    it('retourne false si le SIRET fait plus de 14 chiffres', () => {
      fillValidForm(wrapper.vm)
      wrapper.vm.proForm.numsiret = '123456789012345'
      expect(wrapper.vm.validatePro()).toBe(false)
      expect(wrapper.vm.errors.numsiret).toBeTruthy()
    })

    it('retourne true pour un formulaire valide', () => {
      fillValidForm(wrapper.vm)
      expect(wrapper.vm.validatePro()).toBe(true)
    })

    it('efface les erreurs précédentes avant chaque validation', () => {
      wrapper.vm.errors.nomsociete = 'ancienne erreur'
      fillValidForm(wrapper.vm)
      wrapper.vm.validatePro()
      expect(wrapper.vm.errors.nomsociete).toBe('')
    })
  })

  // ── Bouton retour ──────────────────────────────────────────────────────────
  describe('Bouton retour', () => {
    it("sauvegarde le brouillon et redirige vers 'register'", async () => {
      wrapper.vm.dataFromStep1 = { ...VALID_DRAFT }
      fillValidForm(wrapper.vm)
      await wrapper.find('.back-arrow-btn').trigger('click')
      expect(sessionStorageMock.setItem).toHaveBeenCalledWith(
        'registration_draft',
        expect.any(String)
      )
      expect(mockPush).toHaveBeenCalledWith({ name: 'register' })
    })

    it('inclut typeUtilisateur: "professionnel" dans le brouillon sauvegardé', async () => {
      wrapper.vm.dataFromStep1 = { ...VALID_DRAFT }
      fillValidForm(wrapper.vm)
      await wrapper.find('.back-arrow-btn').trigger('click')
      const saved = JSON.parse(sessionStorageMock.setItem.mock.calls[0][1])
      expect(saved.typeUtilisateur).toBe('professionnel')
    })

    it('fusionne les données étape 1 et étape 2 dans le brouillon', async () => {
      wrapper.vm.dataFromStep1 = { ...VALID_DRAFT }
      fillValidForm(wrapper.vm)
      await wrapper.find('.back-arrow-btn').trigger('click')
      const saved = JSON.parse(sessionStorageMock.setItem.mock.calls[0][1])
      expect(saved.pseudonyme).toBe('ProUser')
      expect(saved.nomsociete).toBe('Acme SARL')
    })
  })

  // ── Soumission réussie ─────────────────────────────────────────────────────
  describe('Soumission réussie', () => {
    beforeEach(() => {
      wrapper.vm.dataFromStep1 = { ...VALID_DRAFT }
      fillValidForm(wrapper.vm)
    })

    it('appelle POST /Utilisateurs/register-professionnel', async () => {
      mockPost.mockResolvedValueOnce({ data: { user: { pseudonyme: 'ProUser' } } })
      await wrapper.vm.submitFinal()
      expect(mockPost).toHaveBeenCalledWith(
        '/Utilisateurs/register-professionnel',
        expect.objectContaining({ pseudonyme: 'ProUser', nomsociete: 'Acme SARL' })
      )
    })

    it('envoie numsiret converti en nombre dans le payload', async () => {
      mockPost.mockResolvedValueOnce({ data: { user: {} } })
      await wrapper.vm.submitFinal()
      const sentPayload = mockPost.mock.calls[0][1]
      expect(typeof sentPayload.numsiret).toBe('number')
      expect(sentPayload.numsiret).toBe(12345678901234)
    })

    it('exclut passwordConfirm et typeUtilisateur du payload API', async () => {
      wrapper.vm.dataFromStep1 = { ...VALID_DRAFT, passwordConfirm: 'password123', typeUtilisateur: 'professionnel' }
      mockPost.mockResolvedValueOnce({ data: { user: {} } })
      await wrapper.vm.submitFinal()
      const sentPayload = mockPost.mock.calls[0][1]
      expect(sentPayload).not.toHaveProperty('passwordConfirm')
      expect(sentPayload).not.toHaveProperty('typeUtilisateur')
    })

    it('appelle authState.login si response.data.user existe', async () => {
      const responseData = { user: { pseudonyme: 'ProUser' } }
      mockPost.mockResolvedValueOnce({ data: responseData })
      await wrapper.vm.submitFinal()
      expect(mockLogin).toHaveBeenCalledWith(responseData)
    })

    it("ne appelle pas authState.login si response.data.user est absent", async () => {
      mockPost.mockResolvedValueOnce({ data: {} })
      await wrapper.vm.submitFinal()
      expect(mockLogin).not.toHaveBeenCalled()
    })

    it('passe loginSuccess à true', async () => {
      mockPost.mockResolvedValueOnce({ data: { user: {} } })
      await wrapper.vm.submitFinal()
      expect(wrapper.vm.loginSuccess).toBe(true)
    })

    it('supprime le brouillon de sessionStorage après succès', async () => {
      mockPost.mockResolvedValueOnce({ data: { user: {} } })
      await wrapper.vm.submitFinal()
      expect(sessionStorageMock.removeItem).toHaveBeenCalledWith('registration_draft')
    })

    it("redirige vers 'home' après le délai", async () => {
      vi.useFakeTimers()
      mockPost.mockResolvedValueOnce({ data: { user: {} } })
      await wrapper.vm.submitFinal()
      vi.runAllTimers()
      expect(mockPush).toHaveBeenCalledWith({ name: 'home' })
      vi.useRealTimers()
    })

    it("n'appelle pas POST si la validation échoue", async () => {
      wrapper.vm.proForm.nomsociete = ''
      await wrapper.vm.submitFinal()
      expect(mockPost).not.toHaveBeenCalled()
    })
  })

  // ── Gestion des erreurs 409 ────────────────────────────────────────────────
  describe('Erreur 409 (conflit)', () => {
    beforeEach(() => {
      wrapper.vm.dataFromStep1 = { ...VALID_DRAFT }
      fillValidForm(wrapper.vm)
    })

    it("redirige vers 'register' avec externalErrors si le conflit concerne l'email", async () => {
      mockPost.mockRejectedValueOnce({
        response: { status: 409, data: { target: 'email', message: 'Email déjà utilisé.' } },
      })
      await wrapper.vm.submitFinal()
      expect(mockPush).toHaveBeenCalledWith(
        expect.objectContaining({ name: 'register' })
      )
    })

    it("redirige vers 'register' si le conflit concerne le pseudonyme", async () => {
      mockPost.mockRejectedValueOnce({
        response: { status: 409, data: { target: 'pseudonyme', message: 'Pseudonyme pris.' } },
      })
      await wrapper.vm.submitFinal()
      expect(mockPush).toHaveBeenCalledWith(
        expect.objectContaining({ name: 'register' })
      )
    })

    it("redirige vers 'register' si le conflit concerne le téléphone", async () => {
      mockPost.mockRejectedValueOnce({
        response: { status: 409, data: { target: 'telephoneUtilisateur', message: 'Téléphone déjà utilisé.' } },
      })
      await wrapper.vm.submitFinal()
      expect(mockPush).toHaveBeenCalledWith(
        expect.objectContaining({ name: 'register' })
      )
    })

    it('affiche une erreur inline si le conflit concerne un champ étape 2', async () => {
      mockPost.mockRejectedValueOnce({
        response: { status: 409, data: { target: 'nomsociete', message: 'Société déjà enregistrée.' } },
      })
      await wrapper.vm.submitFinal()
      expect(mockPush).not.toHaveBeenCalled()
      expect(wrapper.vm.errors.nomsociete).toBe('Société déjà enregistrée.')
    })

    it('sauvegarde le brouillon avant de rediriger vers étape 1', async () => {
      mockPost.mockRejectedValueOnce({
        response: { status: 409, data: { target: 'email', message: 'Email déjà utilisé.' } },
      })
      await wrapper.vm.submitFinal()
      expect(sessionStorageMock.setItem).toHaveBeenCalledWith(
        'registration_draft',
        expect.any(String)
      )
    })
  })
})