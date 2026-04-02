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

function createWrapper(draft = VALID_DRAFT) {
  if (draft) {
    sessionStorageMock.getItem.mockReturnValue(JSON.stringify(draft))
  } else {
    sessionStorageMock.getItem.mockReturnValue(null)
  }
  return mount(Particulier, {
    global: { stubs: ['router-link', 'router-view'] },
  })
}

function fillValidForm(vm) {
  vm.form.nomutilisateur    = 'Dupont'
  vm.form.prenomutilisateur = 'Jean'
  vm.form.dateNaissance     = '1990-06-15'
}

// ── Tests ─────────────────────────────────────────────────────────────────────
describe('RegisterParticulierView.vue', () => {
  let wrapper

  beforeEach(() => {
    vi.clearAllMocks()
    sessionStorageMock.clear()
    // By default, provide a valid draft to avoid redirection in onMounted
    wrapper = createWrapper(VALID_DRAFT)
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
      // nom, prenom, dateNaissance = 3 inputs
      expect(inputs.length).toBeGreaterThanOrEqual(3)
    })

    it('affiche le sélecteur civilité avec "M." par défaut', () => {
      expect(wrapper.vm.form.civilite).toBe('M.')
    })

    it("n'affiche pas l'overlay de succès au départ", () => {
      expect(wrapper.vm.registrationSuccess).toBe(false)
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
      expect(w.vm.form.nomutilisateur).toBe('Martin')
      expect(w.vm.form.prenomutilisateur).toBe('Sophie')
      expect(w.vm.form.civilite).toBe('Mme')
      expect(w.vm.form.dateNaissance).toBe('1995-03-20')
    })

    it('redirige vers register si pas de brouillon', async () => {
      mockPush.mockClear()
      // Create wrapper without draft
      const w = createWrapper(null)
      await w.vm.$nextTick()
      expect(mockPush).toHaveBeenCalledWith({ name: 'register' })
    })
  })

  // ── Validation ─────────────────────────────────────────────────────────────
  describe('Validation du formulaire', () => {
    it('retourne false si le nom est vide', () => {
      fillValidForm(wrapper.vm)
      wrapper.vm.form.nomutilisateur = ''
      expect(wrapper.vm.validate()).toBe(false)
      expect(wrapper.vm.errors.nomutilisateur).toBeTruthy()
    })

    it('retourne false si le prénom est vide', () => {
      fillValidForm(wrapper.vm)
      wrapper.vm.form.prenomutilisateur = ''
      expect(wrapper.vm.validate()).toBe(false)
      expect(wrapper.vm.errors.prenomutilisateur).toBeTruthy()
    })

    it('retourne false si la date de naissance est absente', () => {
      fillValidForm(wrapper.vm)
      wrapper.vm.form.dateNaissance = ''
      expect(wrapper.vm.validate()).toBe(false)
      expect(wrapper.vm.errors.dateNaissance).toBeTruthy()
    })

    it('retourne false si le candidat a moins de 18 ans', () => {
      fillValidForm(wrapper.vm)
      const today = new Date()
      const minor = new Date(today.getFullYear() - 16, today.getMonth(), today.getDate())
      wrapper.vm.form.dateNaissance = minor.toISOString().split('T')[0]
      expect(wrapper.vm.validate()).toBe(false)
      expect(wrapper.vm.errors.dateNaissance).toContain('18 ans')
    })

    it('retourne true for un formulaire valide (majeur)', () => {
      fillValidForm(wrapper.vm)
      expect(wrapper.vm.validate()).toBe(true)
    })

    it('efface les erreurs précédentes avant chaque validation', () => {
      wrapper.vm.errors.nomutilisateur = 'ancienne erreur'
      fillValidForm(wrapper.vm)
      wrapper.vm.validate()
      expect(wrapper.vm.errors.nomutilisateur).toBe('')
    })
  })

  // ── Bouton retour ──────────────────────────────────────────────────────────
  describe('Bouton retour', () => {
    it("redirige vers 'register'", async () => {
      await wrapper.find('.back-arrow-btn').trigger('click')
      expect(mockPush).toHaveBeenCalledWith({ name: 'register' })
    })
  })

  // ── Soumission réussie ─────────────────────────────────────────────────────
  describe('Soumission réussie', () => {
    beforeEach(() => {
      mockPush.mockClear() // Clear the redirect from onMounted if any
      fillValidForm(wrapper.vm)
    })

    it('appelle POST /Utilisateurs/register-particulier', async () => {
      mockPost.mockResolvedValueOnce({ data: { Token: 'fake-token', user: { pseudonyme: 'JohnDoe' } } })
      await wrapper.vm.submitFinal()
      expect(mockPost).toHaveBeenCalledWith(
        '/Utilisateurs/register-particulier',
        expect.objectContaining({ pseudonyme: 'JohnDoe', nomutilisateur: 'Dupont' })
      )
    })

    it('appelle authState.login avec la réponse', async () => {
      const responseData = { Token: 'fake-token', user: { pseudonyme: 'JohnDoe' } }
      mockPost.mockResolvedValueOnce({ data: responseData })
      await wrapper.vm.submitFinal()
      expect(mockLogin).toHaveBeenCalledWith(responseData)
    })

    it('passe registrationSuccess à true après la soumission', async () => {
      mockPost.mockResolvedValueOnce({ data: { Token: 'tk', user: {} } })
      await wrapper.vm.submitFinal()
      expect(wrapper.vm.registrationSuccess).toBe(true)
    })

    it('supprime le brouillon de sessionStorage après succès', async () => {
      mockPost.mockResolvedValueOnce({ data: { Token: 'tk', user: {} } })
      await wrapper.vm.submitFinal()
      expect(sessionStorageMock.removeItem).toHaveBeenCalledWith('registration_draft')
    })

    it("redirige vers 'home' après le délai", async () => {
      vi.useFakeTimers()
      mockPost.mockResolvedValueOnce({ data: { Token: 'tk', user: {} } })
      await wrapper.vm.submitFinal()
      vi.runAllTimers()
      expect(mockPush).toHaveBeenCalledWith({ name: 'home' })
      vi.useRealTimers()
    })

    it("n'appelle pas POST si la validation échoue", async () => {
      wrapper.vm.form.nomutilisateur = ''
      await wrapper.vm.submitFinal()
      expect(mockPost).not.toHaveBeenCalled()
    })
  })

  // ── Gestion des erreurs 409 ────────────────────────────────────────────────
  describe('Erreur 409 (conflit)', () => {
    beforeEach(() => {
      mockPush.mockClear()
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
        response: { status: 409, data: { target: 'nomutilisateur', message: 'Nom invalide.' } },
      })
      await wrapper.vm.submitFinal()
      // mockPush might have been called 0 times here because we provided draft in beforeEach
      expect(mockPush).not.toHaveBeenCalled()
      expect(wrapper.vm.errors.nomutilisateur).toBe('Nom invalide.')
    })
  })

  // ── Payload envoyé ─────────────────────────────────────────────────────────
  describe('Construction du payload', () => {
    it('inclut les données des deux étapes dans le payload', async () => {
      fillValidForm(wrapper.vm)
      mockPost.mockResolvedValueOnce({ data: { Token: 'tk', user: {} } })
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
  })
})