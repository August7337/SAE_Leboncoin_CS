import { describe, it, expect, vi, beforeEach } from 'vitest'
import { mount } from '@vue/test-utils'
import Particulier from '@/views/auth/ParticulierView.vue'

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

vi.mock('@/auth.js', () => ({
  authState: { token: null, user: null, login: mockLogin },
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
  pseudonyme:          'JohnDoe',
  email:               'john@example.com',
  password:            'password123',
  telephoneutilisateur: '0612345678',
  rue:                 '10 rue de Paris',
  ville:               'Paris',
  codePostal:          '75001',
}

function createWrapper(draft = null) {
  if (draft) {
    sessionStorageMock.getItem.mockReturnValueOnce(JSON.stringify(draft))
  }
  return mount(Particulier, {
    global: { stubs: ['router-link', 'router-view'] },
  })
}

function fillValidForm(vm) {
  vm.particulierForm.nom          = 'Dupont'
  vm.particulierForm.prenom       = 'Jean'
  vm.particulierForm.dateNaissance = '1990-06-15'
}

// ── Tests ─────────────────────────────────────────────────────────────────────
describe('RegisterParticulierView.vue', () => {
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

    it('affiche "Etape 2/2 (Particulier)"', () => {
      expect(wrapper.text()).toContain('Etape 2/2 (Particulier)')
    })

    it('affiche les champs nom, prénom et date de naissance', () => {
      const inputs = wrapper.findAll('input')
      expect(inputs.length).toBeGreaterThanOrEqual(3)
    })

    it('affiche le select civilité avec "M." par défaut', () => {
      expect(wrapper.vm.particulierForm.civilite).toBe('M.')
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
      expect(w.vm.dataFromStep1).toMatchObject({ pseudonyme: 'JohnDoe' })
    })

    it('pré-remplit nom/prénom/civilité/dateNaissance si présents dans le brouillon', async () => {
      const draft = {
        ...VALID_DRAFT,
        nomutilisateur:    'Martin',
        prenomutilisateur: 'Sophie',
        civilite:          'Mme',
        dateNaissance:     '1995-03-20',
      }
      const w = createWrapper(draft)
      await w.vm.$nextTick()
      expect(w.vm.particulierForm.nom).toBe('Martin')
      expect(w.vm.particulierForm.prenom).toBe('Sophie')
      expect(w.vm.particulierForm.civilite).toBe('Mme')
      expect(w.vm.particulierForm.dateNaissance).toBe('1995-03-20')
    })

    it('utilise window.history.state.payload si pas de brouillon en session', async () => {
      window.history.replaceState({ payload: VALID_DRAFT }, '')
      const w = createWrapper()        // no draft mock → getItem returns null
      await w.vm.$nextTick()
      expect(w.vm.dataFromStep1).toMatchObject({ pseudonyme: 'JohnDoe' })
      window.history.replaceState({}, '')
    })
  })

  // ── Validation ─────────────────────────────────────────────────────────────
  describe('Validation du formulaire', () => {
    it('retourne false si le nom est vide', () => {
      fillValidForm(wrapper.vm)
      wrapper.vm.particulierForm.nom = ''
      expect(wrapper.vm.validateParticulier()).toBe(false)
      expect(wrapper.vm.errors.nom).toBeTruthy()
    })

    it('retourne false si le prénom est vide', () => {
      fillValidForm(wrapper.vm)
      wrapper.vm.particulierForm.prenom = ''
      expect(wrapper.vm.validateParticulier()).toBe(false)
      expect(wrapper.vm.errors.prenom).toBeTruthy()
    })

    it('retourne false si la date de naissance est absente', () => {
      fillValidForm(wrapper.vm)
      wrapper.vm.particulierForm.dateNaissance = ''
      expect(wrapper.vm.validateParticulier()).toBe(false)
      expect(wrapper.vm.errors.dateNaissance).toBeTruthy()
    })

    it('retourne false si le candidat a moins de 18 ans', () => {
      fillValidForm(wrapper.vm)
      const today = new Date()
      const minor = new Date(today.getFullYear() - 16, today.getMonth(), today.getDate())
      wrapper.vm.particulierForm.dateNaissance = minor.toISOString().split('T')[0]
      expect(wrapper.vm.validateParticulier()).toBe(false)
      expect(wrapper.vm.errors.dateNaissance).toContain('18 ans')
    })

    it('retourne true pour un formulaire valide (majeur)', () => {
      fillValidForm(wrapper.vm)
      expect(wrapper.vm.validateParticulier()).toBe(true)
    })

    it('efface les erreurs précédentes avant chaque validation', () => {
      wrapper.vm.errors.nom = 'ancienne erreur'
      fillValidForm(wrapper.vm)
      wrapper.vm.validateParticulier()
      expect(wrapper.vm.errors.nom).toBe('')
    })

    it("accepte un utilisateur qui vient exactement d'avoir 18 ans aujourd\'hui", () => {
      fillValidForm(wrapper.vm)
      const today = new Date()
      const exact18 = new Date(today.getFullYear() - 18, today.getMonth(), today.getDate())
      wrapper.vm.particulierForm.dateNaissance = exact18.toISOString().split('T')[0]
      expect(wrapper.vm.validateParticulier()).toBe(true)
    })
  })

  // ── Bouton retour ──────────────────────────────────────────────────────────
  describe('Bouton retour', () => {
    it("sauvegarde le brouillon dans sessionStorage et redirige vers 'register'", async () => {
      wrapper.vm.dataFromStep1 = { ...VALID_DRAFT }
      fillValidForm(wrapper.vm)
      await wrapper.find('.back-arrow-btn').trigger('click')
      expect(sessionStorageMock.setItem).toHaveBeenCalledWith(
        'registration_draft',
        expect.any(String)
      )
      expect(mockPush).toHaveBeenCalledWith({ name: 'register' })
    })

    it('fusionne les données étape 1 et étape 2 dans le brouillon sauvegardé', async () => {
      wrapper.vm.dataFromStep1 = { ...VALID_DRAFT }
      fillValidForm(wrapper.vm)
      await wrapper.find('.back-arrow-btn').trigger('click')
      const saved = JSON.parse(sessionStorageMock.setItem.mock.calls[0][1])
      expect(saved.pseudonyme).toBe('JohnDoe')
      expect(saved.nom).toBe('Dupont')
    })
  })

  // ── Soumission réussie ─────────────────────────────────────────────────────
  describe('Soumission réussie', () => {
    beforeEach(() => {
      wrapper.vm.dataFromStep1 = { ...VALID_DRAFT }
      fillValidForm(wrapper.vm)
    })

    it('appelle POST /Utilisateurs/register-particulier', async () => {
      mockPost.mockResolvedValueOnce({ data: { user: { pseudonyme: 'JohnDoe' } } })
      await wrapper.vm.submitFinal()
      expect(mockPost).toHaveBeenCalledWith(
        '/Utilisateurs/register-particulier',
        expect.objectContaining({ pseudonyme: 'JohnDoe', nomutilisateur: 'Dupont' })
      )
    })

    it('appelle authState.login avec la réponse', async () => {
      const responseData = { user: { pseudonyme: 'JohnDoe' } }
      mockPost.mockResolvedValueOnce({ data: responseData })
      await wrapper.vm.submitFinal()
      expect(mockLogin).toHaveBeenCalledWith(responseData)
    })

    it('passe loginSuccess à true après la soumission', async () => {
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
      wrapper.vm.particulierForm.nom = ''
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

    it('affiche une erreur inline si le conflit concerne un champ de l\'étape 2', async () => {
      mockPost.mockRejectedValueOnce({
        response: { status: 409, data: { target: 'nom', message: 'Nom invalide.' } },
      })
      await wrapper.vm.submitFinal()
      expect(mockPush).not.toHaveBeenCalled()
      expect(wrapper.vm.errors.nom).toBe('Nom invalide.')
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

  // ── Payload envoyé ─────────────────────────────────────────────────────────
  describe('Construction du payload', () => {
    it('inclut les données des deux étapes dans le payload', async () => {
      wrapper.vm.dataFromStep1 = { ...VALID_DRAFT }
      fillValidForm(wrapper.vm)
      mockPost.mockResolvedValueOnce({ data: { user: {} } })
      await wrapper.vm.submitFinal()
      const sentPayload = mockPost.mock.calls[0][1]
      expect(sentPayload).toMatchObject({
        pseudonyme:          'JohnDoe',
        email:               'john@example.com',
        nomutilisateur:      'Dupont',
        prenomutilisateur:   'Jean',
        dateNaissance:       '1990-06-15',
        civilite:            'M.',
      })
    })

    it('résout telephoneutilisateur depuis adresseUtilisateur si nécessaire', async () => {
      wrapper.vm.dataFromStep1 = {
        ...VALID_DRAFT,
        telephoneutilisateur: undefined,
        telephoneUtilisateur: '0699887766',
      }
      fillValidForm(wrapper.vm)
      mockPost.mockResolvedValueOnce({ data: { user: {} } })
      await wrapper.vm.submitFinal()
      expect(mockPost.mock.calls[0][1].telephoneutilisateur).toBe('0699887766')
    })
  })
})