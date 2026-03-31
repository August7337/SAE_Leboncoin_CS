import { describe, it, expect, vi, beforeEach } from 'vitest'

// ── localStorage mock ────────────────────────────────────────────────────────
const localStorageMock = (() => {
  let store = {}
  return {
    getItem: vi.fn((key) => store[key] ?? null),
    setItem: vi.fn((key, value) => { store[key] = String(value) }),
    removeItem: vi.fn((key) => { delete store[key] }),
    clear: vi.fn(() => { store = {} }),
  }
})()
Object.defineProperty(window, 'localStorage', { value: localStorageMock })

// ── axios mock (évite les imports circulaires) ───────────────────────────────
vi.mock('axios', () => {
  const interceptorHandler = { use: vi.fn(), eject: vi.fn() }
  const instance = {
    get: vi.fn(),
    post: vi.fn(),
    interceptors: { request: interceptorHandler, response: interceptorHandler },
  }
  return { default: { ...instance, create: vi.fn(() => instance) } }
})

vi.mock('@/api/axios.js', () => ({
  default: {
    get: vi.fn(),
    post: vi.fn(),
  },
}))

async function freshAuthState() {
  vi.resetModules()
  const mod = await import('@/auth.js')
  return mod.authState
}

const SAMPLE_USER = {
  idutilisateur: 42,
  pseudonyme: 'Alice',
  permissions: ['app.view.home', 'app.view.my_annonces'],
  roles: ['Locataire'],
}

// ── Tests ────────────────────────────────────────────────────────────────────
describe('authState (auth.js)', () => {
  beforeEach(() => {
    vi.resetAllMocks()
    localStorageMock.clear()
  })

  // ── État initial ────────────────────────────────────────────────────────
  describe('État initial', () => {
    it('user est null quand localStorage est vide', async () => {
      const authState = await freshAuthState()
      expect(authState.user).toBeNull()
    })

    it('token est null quand localStorage est vide', async () => {
      const authState = await freshAuthState()
      expect(authState.token).toBeNull()
    })

    it('restaure user depuis localStorage', async () => {
      localStorageMock.getItem.mockImplementation((key) =>
        key === 'user' ? JSON.stringify(SAMPLE_USER) : null,
      )
      const authState = await freshAuthState()
      expect(authState.user).toMatchObject({ pseudonyme: 'Alice' })
    })

    it('restaure token depuis localStorage', async () => {
      localStorageMock.getItem.mockImplementation((key) =>
        key === 'token' ? 'jwt-abc' : null,
      )
      const authState = await freshAuthState()
      expect(authState.token).toBe('jwt-abc')
    })
  })

  // ── login ───────────────────────────────────────────────────────────────
  describe('login()', () => {
    it("enregistre l'utilisateur dans le state et localStorage", async () => {
      const authState = await freshAuthState()
      authState.login({ user: SAMPLE_USER, token: 'tok123' })
      expect(authState.user).toMatchObject({ pseudonyme: 'Alice' })
      expect(localStorageMock.setItem).toHaveBeenCalledWith('user', JSON.stringify(SAMPLE_USER))
    })

    it('enregistre le token dans le state et localStorage', async () => {
      const authState = await freshAuthState()
      authState.login({ user: SAMPLE_USER, token: 'tok123' })
      expect(authState.token).toBe('tok123')
      expect(localStorageMock.setItem).toHaveBeenCalledWith('token', 'tok123')
    })

    it('accepte un payload plat (idutilisateur au premier niveau)', async () => {
      const authState = await freshAuthState()
      authState.login({ ...SAMPLE_USER, token: 'flat-tok' })
      expect(authState.user).toMatchObject({ idutilisateur: 42 })
    })

    it('accepte data.Token (majuscule) comme token', async () => {
      const authState = await freshAuthState()
      authState.login({ user: SAMPLE_USER, Token: 'upper-tok' })
      expect(authState.token).toBe('upper-tok')
    })
  })

  // ── setUser ─────────────────────────────────────────────────────────────
  describe('setUser()', () => {
    it('met à jour user dans le state', async () => {
      const authState = await freshAuthState()
      authState.setUser(SAMPLE_USER)
      expect(authState.user).toMatchObject({ pseudonyme: 'Alice' })
    })

    it('persiste user dans localStorage', async () => {
      const authState = await freshAuthState()
      authState.setUser(SAMPLE_USER)
      expect(localStorageMock.setItem).toHaveBeenCalledWith('user', JSON.stringify(SAMPLE_USER))
    })
  })

  // ── isLoggedIn ──────────────────────────────────────────────────────────
  describe('isLoggedIn()', () => {
    it('retourne false si user et token sont null', async () => {
      const authState = await freshAuthState()
      expect(authState.isLoggedIn()).toBe(false)
    })

    it('retourne false si user est présent mais token absent', async () => {
      const authState = await freshAuthState()
      authState.user = SAMPLE_USER
      expect(authState.isLoggedIn()).toBe(false)
    })

    it('retourne false si token est présent mais user absent', async () => {
      const authState = await freshAuthState()
      authState.token = 'tok'
      expect(authState.isLoggedIn()).toBe(false)
    })

    it('retourne true si user ET token sont présents', async () => {
      const authState = await freshAuthState()
      authState.login({ user: SAMPLE_USER, token: 'tok' })
      expect(authState.isLoggedIn()).toBe(true)
    })
  })

  // ── hasPermission ───────────────────────────────────────────────────────
  describe('hasPermission()', () => {
    it('retourne false si user est null', async () => {
      const authState = await freshAuthState()
      expect(authState.hasPermission('app.view.home')).toBe(false)
    })

    it("retourne false si l'utilisateur n'a pas de tableau permissions", async () => {
      const authState = await freshAuthState()
      authState.user = { idutilisateur: 1 }
      expect(authState.hasPermission('app.view.home')).toBe(false)
    })

    it('retourne false pour une permission absente', async () => {
      const authState = await freshAuthState()
      authState.login({ user: SAMPLE_USER, token: 'tok' })
      expect(authState.hasPermission('app.view.admin')).toBe(false)
    })

    it('retourne true pour une permission présente', async () => {
      const authState = await freshAuthState()
      authState.login({ user: SAMPLE_USER, token: 'tok' })
      expect(authState.hasPermission('app.view.home')).toBe(true)
    })
  })

  // ── clearUser ───────────────────────────────────────────────────────────
  describe('clearUser()', () => {
    it('efface user et token du state', async () => {
      const authState = await freshAuthState()
      authState.login({ user: SAMPLE_USER, token: 'tok' })
      authState.clearUser()
      expect(authState.user).toBeNull()
      expect(authState.token).toBeNull()
    })

    it('supprime user et token de localStorage', async () => {
      const authState = await freshAuthState()
      authState.login({ user: SAMPLE_USER, token: 'tok' })
      authState.clearUser()
      expect(localStorageMock.removeItem).toHaveBeenCalledWith('user')
      expect(localStorageMock.removeItem).toHaveBeenCalledWith('token')
    })

    it('isLoggedIn retourne false après clearUser', async () => {
      const authState = await freshAuthState()
      authState.login({ user: SAMPLE_USER, token: 'tok' })
      authState.clearUser()
      expect(authState.isLoggedIn()).toBe(false)
    })
  })

  // ── refreshUser ─────────────────────────────────────────────────────────
  describe('refreshUser()', () => {
    it("ne fait rien si l'utilisateur n'est pas connecté", async () => {
      const authState = await freshAuthState()
      const api = (await import('@/api/axios.js')).default
      await authState.refreshUser()
      expect(api.get).not.toHaveBeenCalled()
    })

    it('met à jour solde, roles et permissions depuis les endpoints API', async () => {
      const authState = await freshAuthState()
      authState.login({ user: SAMPLE_USER, token: 'tok' })

      const api = (await import('@/api/axios.js')).default
      api.get.mockImplementation((url) => {
        if (url.includes('auth-profile'))
          return Promise.resolve({ data: { roles: ['Proprietaire'], permissions: ['app.view.home', 'app.view.my_annonces'] } })
        return Promise.resolve({ data: { solde: 99.5 } })
      })

      await authState.refreshUser()
      expect(authState.user.solde).toBe(99.5)
      expect(authState.user.roles).toContain('Proprietaire')
    })

    it('appelle clearUser si le serveur répond 401', async () => {
      const authState = await freshAuthState()
      authState.login({ user: SAMPLE_USER, token: 'tok' })

      const api = (await import('@/api/axios.js')).default
      api.get.mockRejectedValue({ response: { status: 401, data: 'Unauthorized' } })

      await authState.refreshUser()
      expect(authState.user).toBeNull()
      expect(authState.token).toBeNull()
    })

    it("ne déconnecte pas l'utilisateur pour une erreur non-401", async () => {
      const authState = await freshAuthState()
      authState.login({ user: SAMPLE_USER, token: 'tok' })

      const api = (await import('@/api/axios.js')).default
      api.get.mockRejectedValue({ response: { status: 500, data: 'Server Error' } })

      await authState.refreshUser()
      expect(authState.user).not.toBeNull()
    })
  })
})
