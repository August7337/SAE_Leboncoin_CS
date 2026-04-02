import { describe, it, expect, vi, beforeEach } from 'vitest'
import { mount } from '@vue/test-utils'
import Register from '@/views/auth/RegisterView.vue'

// 1. Stable mock for router.push
const mockPush = vi.fn()

vi.mock('vue-router', () => ({
  useRouter: () => ({ push: mockPush }),
  useRoute: () => ({ query: {} }),
}))

// 2. Axios mock — interceptors must exist so src/api/axios.js doesn't crash on import
vi.mock('axios', () => {
  const interceptorHandler = { use: vi.fn(), eject: vi.fn() }
  const instance = {
    get: vi.fn(() => Promise.resolve({ data: { features: [] } })),
    post: vi.fn(() => Promise.resolve({ data: {} })),
    interceptors: {
      request: interceptorHandler,
      response: interceptorHandler,
    },
  }
  return {
    default: {
      ...instance,
      create: vi.fn(() => instance),
    },
  }
})

// 3. Mock src/api/axios.js directly so its module-level interceptor setup never runs
vi.mock('@/api/axios.js', () => ({
  default: {
    get: vi.fn(() => Promise.resolve({ data: { features: [] } })),
    post: vi.fn(() => Promise.resolve({ data: {} })),
  },
}))

// 4. Mock src/auth.js to provide a stable authState without side effects
vi.mock('@/auth.js', () => ({
  authState: { token: null, user: null },
}))

// 3. sessionStorage mock
const sessionStorageMock = (() => {
  let store = {}
  return {
    getItem: vi.fn((key) => store[key] ?? null),
    setItem: vi.fn((key, value) => { store[key] = value }),
    removeItem: vi.fn((key) => { delete store[key] }),
    clear: vi.fn(() => { store = {} }),
  }
})()
Object.defineProperty(window, 'sessionStorage', { value: sessionStorageMock })

// ─── Helpers ────────────────────────────────────────────────────────────────

function createWrapper() {
  return mount(Register, {
    global: { stubs: ['router-link', 'router-view'] },
  })
}

function fillValidForm(vm) {
  Object.assign(vm.form, {
    pseudonyme: 'JohnDoe',
    email: 'john@example.com',
    telephoneUtilisateur: '0612345678',
    password: 'password123',
    passwordConfirm: 'password123',
  })
  vm.form.adresseUtilisateur.rue = '10 rue de Paris'
  vm.form.adresseUtilisateur.ville = 'Paris'
  vm.form.adresseUtilisateur.codePostal = '75001'
  vm.addressSelected = true
}

// ─── Tests ──────────────────────────────────────────────────────────────────

describe('Register.vue', () => {
  let wrapper

  beforeEach(() => {
    vi.clearAllMocks()
    sessionStorageMock.clear()
    wrapper = createWrapper()
  })

  // ── Rendu ────────────────────────────────────────────────────────────────

  describe('Rendu initial', () => {
    it('affiche le titre "Créer un compte"', () => {
      expect(wrapper.text()).toContain('Créer un compte')
    })

    it('affiche "Etape 1/2"', () => {
      expect(wrapper.text()).toContain('Etape 1/2')
    })

    it('affiche tous les champs du formulaire', () => {
      const inputs = wrapper.findAll('input')
      // pseudonyme, email, téléphone, rue, code postal, ville, mdp, confirmation
      expect(inputs.length).toBeGreaterThanOrEqual(6)
    })

    it('affiche les boutons "Particulier" et "Professionnel"', () => {
      expect(wrapper.text()).toContain('Particulier')
      expect(wrapper.text()).toContain('Professionnel')
    })

    it('sélectionne "particulier" par défaut', () => {
      expect(wrapper.vm.typeUtilisateur).toBe('particulier')
    })

    it("n'affiche pas l'overlay de succès au départ", () => {
      expect(wrapper.vm.loginSuccess).toBe(false)
    })
  })

  // ── Validation ───────────────────────────────────────────────────────────

  describe('Validation du formulaire', () => {
    it('retourne false et affiche une erreur si le pseudonyme est vide', async () => {
      fillValidForm(wrapper.vm)
      wrapper.vm.form.pseudonyme = ''
      const result = wrapper.vm.validate()
      expect(result).toBe(false)
      expect(wrapper.vm.errors.pseudonyme).toBeTruthy()
    })

    it('retourne false pour un email invalide', async () => {
      fillValidForm(wrapper.vm)
      wrapper.vm.form.email = 'pas-un-email'
      const result = wrapper.vm.validate()
      expect(result).toBe(false)
      expect(wrapper.vm.errors.email).toBeTruthy()
    })

    it('retourne false pour un numéro de téléphone trop court', async () => {
      fillValidForm(wrapper.vm)
      wrapper.vm.form.telephoneUtilisateur = '0606'
      const result = wrapper.vm.validate()
      expect(result).toBe(false)
      expect(wrapper.vm.errors.telephoneUtilisateur).toBeTruthy()
    })

    it('accepte un téléphone avec espaces ou tirets (ex: 06 12 34 56 78)', async () => {
      fillValidForm(wrapper.vm)
      wrapper.vm.form.telephoneUtilisateur = '06 12 34 56 78'
      const result = wrapper.vm.validate()
      expect(result).toBe(true)
    })

    it('retourne false si le mot de passe fait moins de 6 caractères', async () => {
      fillValidForm(wrapper.vm)
      wrapper.vm.form.password = '123'
      wrapper.vm.form.passwordConfirm = '123'
      const result = wrapper.vm.validate()
      expect(result).toBe(false)
      expect(wrapper.vm.errors.password).toBeTruthy()
    })

    it('retourne false si les mots de passe ne correspondent pas', async () => {
      fillValidForm(wrapper.vm)
      wrapper.vm.form.passwordConfirm = 'different'
      const result = wrapper.vm.validate()
      expect(result).toBe(false)
      expect(wrapper.vm.errors.passwordConfirm).toBeTruthy()
    })

    it('retourne true quand toutes les données sont valides', async () => {
      fillValidForm(wrapper.vm)
      expect(wrapper.vm.validate()).toBe(true)
    })

    it('efface les erreurs précédentes avant chaque validation', async () => {
      fillValidForm(wrapper.vm)
      wrapper.vm.form.email = 'invalide'
      wrapper.vm.validate()
      expect(wrapper.vm.errors.email).toBeTruthy()

      // Corrige le champ et revalide
      wrapper.vm.form.email = 'valide@test.com'
      wrapper.vm.validate()
      expect(wrapper.vm.errors.email).toBeFalsy()
    })
  })

  // ── Soumission ───────────────────────────────────────────────────────────

  describe('Soumission du formulaire', () => {
    it('appelle router.push quand les données sont valides', async () => {
      fillValidForm(wrapper.vm)
      await wrapper.vm.register()
      await wrapper.vm.$nextTick()
      expect(mockPush).toHaveBeenCalled()
    })

    it("n'appelle pas router.push si le formulaire est invalide", async () => {
      // Formulaire vide → invalide
      await wrapper.vm.register()
      expect(mockPush).not.toHaveBeenCalled()
    })

    it('redirige vers la route "particulier" si typeUtilisateur = particulier', async () => {
      fillValidForm(wrapper.vm)
      wrapper.vm.typeUtilisateur = 'particulier'
      await wrapper.vm.register()
      expect(mockPush).toHaveBeenCalledWith(
        expect.objectContaining({ name: 'particulier' })
      )
    })

    it('redirige vers la route "professionnel" si typeUtilisateur = professionnel', async () => {
      fillValidForm(wrapper.vm)
      wrapper.vm.typeUtilisateur = 'professionnel'
      await wrapper.vm.register()
      expect(mockPush).toHaveBeenCalledWith(
        expect.objectContaining({ name: 'professionnel' })
      )
    })

    it('enregistre le brouillon dans sessionStorage avant la redirection', async () => {
      fillValidForm(wrapper.vm)
      await wrapper.vm.register()
      expect(sessionStorageMock.setItem).toHaveBeenCalledWith(
        'registration_draft',
        expect.any(String)
      )
    })

    it('inclut le payload correct dans le state de la route', async () => {
      fillValidForm(wrapper.vm)
      await wrapper.vm.register()
      const call = mockPush.mock.calls[0][0]
      expect(call.state.payload).toMatchObject({
        pseudonyme: 'JohnDoe',
        email: 'john@example.com',
        telephoneutilisateur: '0612345678',
      })
    })

    it('nettoie le numéro de téléphone (supprime espaces/tirets) dans le payload', async () => {
      fillValidForm(wrapper.vm)
      wrapper.vm.form.telephoneUtilisateur = '06-12.34 56 78'
      await wrapper.vm.register()
      const call = mockPush.mock.calls[0][0]
      expect(call.state.payload.telephoneutilisateur).toBe('0612345678')
    })
  })

  // ── Type de compte ───────────────────────────────────────────────────────

  describe('Sélection du type de compte', () => {
    it('change typeUtilisateur en "professionnel" au clic', async () => {
      const buttons = wrapper.findAll('.account-selector button')
      const proBtn = buttons.find(b => b.text() === 'Professionnel')
      await proBtn.trigger('click')
      expect(wrapper.vm.typeUtilisateur).toBe('professionnel')
    })

    it('revient à "particulier" au clic sur le bouton correspondant', async () => {
      wrapper.vm.typeUtilisateur = 'professionnel'
      const buttons = wrapper.findAll('.account-selector button')
      const partBtn = buttons.find(b => b.text() === 'Particulier')
      await partBtn.trigger('click')
      expect(wrapper.vm.typeUtilisateur).toBe('particulier')
    })
  })

  // ── Affichage du mot de passe ─────────────────────────────────────────────

  describe('Toggle visibilité mot de passe', () => {
    it('affiche "Afficher" par défaut pour le mot de passe', () => {
      expect(wrapper.vm.showPassword).toBe(false)
    })

    it('bascule showPassword au clic sur le bouton toggle', async () => {
      const toggleBtns = wrapper.findAll('.toggle-btn')
      await toggleBtns[0].trigger('click')
      expect(wrapper.vm.showPassword).toBe(true)
    })

    it('bascule showPasswordConfirm au clic sur son bouton toggle', async () => {
      const toggleBtns = wrapper.findAll('.toggle-btn')
      await toggleBtns[1].trigger('click')
      expect(wrapper.vm.showPasswordConfirm).toBe(true)
    })
  })

  // ── onMounted : restauration du brouillon ────────────────────────────────

  describe('Restauration depuis sessionStorage (onMounted)', () => {
    it('pré-remplit le formulaire depuis un brouillon existant', async () => {
      const draft = {
        pseudonyme: 'Alice',
        email: 'alice@test.com',
        telephoneutilisateur: '0601020304',
        password: 'secret123',
        passwordConfirm: 'secret123',
        rue: '5 avenue des Fleurs',
        ville: 'Lyon',
        codePostal: '69001',
        typeUtilisateur: 'professionnel',
      }
      sessionStorageMock.getItem.mockReturnValueOnce(JSON.stringify(draft))

      const w = createWrapper()
      await w.vm.$nextTick()

      expect(w.vm.form.pseudonyme).toBe('Alice')
      expect(w.vm.form.email).toBe('alice@test.com')
      expect(w.vm.typeUtilisateur).toBe('professionnel')
    })
  })

  // ── Autocomplete adresse ─────────────────────────────────────────────────

  describe("Autocomplétion d'adresse", () => {
    it("n'appelle pas l'API si la saisie est inférieure à 3 caractères", async () => {
      const axios = (await import('axios')).default
      wrapper.vm.form.adresseUtilisateur.rue = 'Pa'
      await wrapper.vm.fetchAutocomplete()
      expect(axios.get).not.toHaveBeenCalled()
    })

    it("appelle l'API Geoapify quand la saisie atteint 3 caractères", async () => {
      const axios = (await import('axios')).default
      wrapper.vm.form.adresseUtilisateur.rue = 'Par'
      await wrapper.vm.fetchAutocomplete()
      expect(axios.get).toHaveBeenCalledWith(
        expect.stringContaining('geoapify'),
        expect.any(Object)
      )
    })

    it("remplit les champs adresse lors de la sélection d'une suggestion", async () => {
      const suggestion = {
        properties: {
          housenumber: '12',
          street: 'rue de Rivoli',
          city: 'Paris',
          postcode: '75001',
          formatted: '12 rue de Rivoli, Paris',
        },
      }
      wrapper.vm.selectSuggestion(suggestion)

      expect(wrapper.vm.form.adresseUtilisateur.rue).toBe('12 rue de Rivoli')
      expect(wrapper.vm.form.adresseUtilisateur.ville).toBe('Paris')
      expect(wrapper.vm.form.adresseUtilisateur.codePostal).toBe('75001')
      expect(wrapper.vm.showSuggestions).toBe(false)
    })

    it('ferme les suggestions après un blur (avec délai)', async () => {
      vi.useFakeTimers()
      wrapper.vm.showSuggestions = true
      wrapper.vm.closeSuggestions()
      expect(wrapper.vm.showSuggestions).toBe(true) // pas encore fermé
      vi.runAllTimers()
      expect(wrapper.vm.showSuggestions).toBe(false)
      vi.useRealTimers()
    })
  })
})