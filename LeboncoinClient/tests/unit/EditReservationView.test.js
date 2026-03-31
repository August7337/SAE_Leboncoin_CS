import { describe, it, expect, vi, beforeEach } from 'vitest'
import { shallowMount } from '@vue/test-utils'
import EditReservationView from '@/views/account/EditReservationView.vue'

const mockPush = vi.fn()
const mockRoute = { params: { id: '1' }, query: { start: '2026-01-01', end: '2026-01-02' } }

vi.mock('vue-router', () => ({
  useRoute: () => mockRoute,
  useRouter: () => ({ push: mockPush }),
}))

vi.mock('axios', () => {
  const interceptor = { use: vi.fn(), eject: vi.fn() }
  const makeGet = (url) => {
    if (typeof url === 'string') {
      const lowerUrl = url.toLowerCase()
      if (lowerUrl.includes('/features')) return Promise.resolve({ data: [] })
      if (lowerUrl.includes('/annonces/') && lowerUrl.endsWith('/similaires')) return Promise.resolve({ data: [] })
      if (lowerUrl.includes('/annonces/')) {
        return Promise.resolve({ data: {
          idannonce: 1,
          titreannonce: 'Annonce test',
          prixnuitee: 100,
          capacite: 2,
          nombrebebesmax: 0,
          possibiliteanimaux: false,
          description: 'Description test',
          photos: [],
          adresse: { rue: 'Rue test', ville: 'Test', codePostal: '75001' },
          categorie: { idcategorie: 1, nomcategorie: 'Test' },
          idutilisateur: 1,
        } })
      }
      if (lowerUrl.includes('/incidents/') && lowerUrl.includes('/timeline')) {
        return Promise.resolve({ data: [{ statut: { libelle: 'Créé' }, datechangement: '2026-03-31', modificateur: { pseudonyme: 'Agent', email: 'agent@test.com' } }] })
      }
      if (lowerUrl.includes('/incidents/') && !lowerUrl.includes('mes-incidents') && !lowerUrl.includes('similaires') && !lowerUrl.includes('/timeline')) {
        return Promise.resolve({ data: { idincident: 1, statut: { code: 'SIGNALE', libelle: 'Signalé' }, dateSignalement: '2026-03-31', motifincident: 'Test', photos: [], idutilisateur: 1 } })
      }
      if (lowerUrl.includes('/utilisateurs/') && !lowerUrl.includes('/email/')) {
        return Promise.resolve({ data: { idutilisateur: 1, typeUtilisateur: 'particulier', prenomutilisateur: 'John', nomutilisateur: 'Doe', solde: 0, pseudonyme: 'JohnDoe', email: 'john@example.com' } })
      }
      if (lowerUrl.includes('/reservations/') || lowerUrl.includes('/messages/') || lowerUrl.includes('/recherches/')) {
        return Promise.resolve({ data: [] })
      }
      return Promise.resolve({ data: [] })
    }
    return Promise.resolve({ data: [] })
  }
  return {
    default: {
      get: vi.fn(makeGet),
      post: vi.fn(() => Promise.resolve({ data: {} })),
      put: vi.fn(() => Promise.resolve({ data: {} })),
      delete: vi.fn(() => Promise.resolve({ data: {} })),
      interceptors: { request: interceptor, response: interceptor },
      create: vi.fn(() => ({
        get: vi.fn(makeGet),
        post: vi.fn(() => Promise.resolve({ data: {} })),
        put: vi.fn(() => Promise.resolve({ data: {} })),
        delete: vi.fn(() => Promise.resolve({ data: {} })),
        interceptors: { request: interceptor, response: interceptor },
      })),
    },
  }
})

vi.mock('@/api/axios', () => {
  const makeGet = (url) => {
    if (typeof url === 'string') {
      const lowerUrl = url.toLowerCase()
      if (lowerUrl.includes('/features')) return Promise.resolve({ data: [] })
      if (lowerUrl.includes('/annonces/') && lowerUrl.endsWith('/similaires')) return Promise.resolve({ data: [] })
      if (lowerUrl.includes('/annonces/')) {
        return Promise.resolve({ data: {
          idannonce: 1,
          titreannonce: 'Annonce test',
          prixnuitee: 100,
          capacite: 2,
          nombrebebesmax: 0,
          possibiliteanimaux: false,
          description: 'Description test',
          photos: [],
          adresse: { rue: 'Rue test', ville: 'Test', codePostal: '75001' },
          categorie: { idcategorie: 1, nomcategorie: 'Test' },
          idutilisateur: 1,
        } })
      }
      if (lowerUrl.includes('/incidents/') && lowerUrl.includes('/timeline')) {
        return Promise.resolve({ data: [{ statut: { libelle: 'Créé' }, datechangement: '2026-03-31', modificateur: { pseudonyme: 'Agent', email: 'agent@test.com' } }] })
      }
      if (lowerUrl.includes('/incidents/') && !lowerUrl.includes('mes-incidents') && !lowerUrl.includes('similaires') && !lowerUrl.includes('/timeline')) {
        return Promise.resolve({ data: { idincident: 1, statut: { code: 'SIGNALE', libelle: 'Signalé' }, dateSignalement: '2026-03-31', motifincident: 'Test', photos: [], idutilisateur: 1 } })
      }
      if (lowerUrl.includes('/utilisateurs/') && !lowerUrl.includes('/email/')) {
        return Promise.resolve({ data: { idutilisateur: 1, typeUtilisateur: 'particulier', prenomutilisateur: 'John', nomutilisateur: 'Doe', solde: 0, pseudonyme: 'JohnDoe', email: 'john@example.com' } })
      }
      if (lowerUrl.includes('/reservations/') || lowerUrl.includes('/messages/') || lowerUrl.includes('/recherches/')) {
        return Promise.resolve({ data: [] })
      }
      return Promise.resolve({ data: [] })
    }
    return Promise.resolve({ data: [] })
  }
  return {
    default: {
      get: vi.fn(makeGet),
      post: vi.fn(() => Promise.resolve({ data: {} })),
      put: vi.fn(() => Promise.resolve({ data: {} })),
      delete: vi.fn(() => Promise.resolve({ data: {} })),
    },
  }
})

vi.mock('@/api/axios.js', () => {
  const makeGet = (url) => {
    if (typeof url === 'string') {
      const lowerUrl = url.toLowerCase()
      if (lowerUrl.includes('/features')) return Promise.resolve({ data: [] })
      if (lowerUrl.includes('/annonces/') && lowerUrl.endsWith('/similaires')) return Promise.resolve({ data: [] })
      if (lowerUrl.includes('/annonces/')) {
        return Promise.resolve({ data: {
          idannonce: 1,
          titreannonce: 'Annonce test',
          prixnuitee: 100,
          capacite: 2,
          nombrebebesmax: 0,
          possibiliteanimaux: false,
          description: 'Description test',
          photos: [],
          adresse: { rue: 'Rue test', ville: 'Test', codePostal: '75001' },
          categorie: { idcategorie: 1, nomcategorie: 'Test' },
          idutilisateur: 1,
        } })
      }
      if (lowerUrl.includes('/incidents/') && lowerUrl.includes('/timeline')) {
        return Promise.resolve({ data: [{ statut: { libelle: 'Créé' }, datechangement: '2026-03-31', modificateur: { pseudonyme: 'Agent', email: 'agent@test.com' } }] })
      }
      if (lowerUrl.includes('/incidents/') && !lowerUrl.includes('mes-incidents') && !lowerUrl.includes('similaires') && !lowerUrl.includes('/timeline')) {
        return Promise.resolve({ data: { idincident: 1, statut: { code: 'SIGNALE', libelle: 'Signalé' }, dateSignalement: '2026-03-31', motifincident: 'Test', photos: [], idutilisateur: 1 } })
      }
      if (lowerUrl.includes('/utilisateurs/') && !lowerUrl.includes('/email/')) {
        return Promise.resolve({ data: { idutilisateur: 1, typeUtilisateur: 'particulier', prenomutilisateur: 'John', nomutilisateur: 'Doe', solde: 0, pseudonyme: 'JohnDoe', email: 'john@example.com' } })
      }
      if (lowerUrl.includes('/reservations/') || lowerUrl.includes('/messages/') || lowerUrl.includes('/recherches/')) {
        return Promise.resolve({ data: [] })
      }
      return Promise.resolve({ data: [] })
    }
    return Promise.resolve({ data: [] })
  }
  return {
    default: {
      get: vi.fn(makeGet),
      post: vi.fn(() => Promise.resolve({ data: {} })),
      put: vi.fn(() => Promise.resolve({ data: {} })),
      delete: vi.fn(() => Promise.resolve({ data: {} })),
    },
  }
})

vi.mock('@/auth.js', () => ({
  authState: {
    token: null,
    user: {
      idutilisateur: 1,
      typeUtilisateur: 'particulier',
      prenomutilisateur: 'John',
      nomutilisateur: 'Doe',
      pseudonyme: 'JohnDoe',
      email: 'john@example.com',
      solde: 0,
    },
    hasPermission: vi.fn(() => false),
    isLoggedIn: vi.fn(() => true),
    refreshUser: vi.fn(),
    clearUser: vi.fn(),
    login: vi.fn(),
    logout: vi.fn(),
  },
}))

vi.mock('@/auth', () => ({
  authState: {
    token: null,
    user: {
      idutilisateur: 1,
      typeUtilisateur: 'particulier',
      prenomutilisateur: 'John',
      nomutilisateur: 'Doe',
      pseudonyme: 'JohnDoe',
      email: 'john@example.com',
      solde: 0,
    },
    hasPermission: vi.fn(() => false),
    isLoggedIn: vi.fn(() => true),
    refreshUser: vi.fn(),
    clearUser: vi.fn(),
    login: vi.fn(),
    logout: vi.fn(),
  },
}))

vi.mock('@/notification.js', () => ({
  showSuccess: vi.fn(),
  showError: vi.fn(),
}))

const sessionStorageMock = {
  getItem: vi.fn(() => null),
  setItem: vi.fn(),
  removeItem: vi.fn(),
  clear: vi.fn(),
}

Object.defineProperty(window, 'sessionStorage', {
  value: sessionStorageMock,
  configurable: true,
})

vi.stubGlobal('fetch', vi.fn((input) => {
  const url = typeof input === 'string' ? input.toLowerCase() : input?.url?.toLowerCase()
  if (url?.includes('/api/reservations/1')) {
    return Promise.resolve({
      ok: true,
      json: () => Promise.resolve({
        idreservation: 1,
        idannonce: 1,
        idannonceNavigation: {
          prixnuitee: 100,
          capacite: 4,
          photos: [{ lienphoto: 'photo.jpg' }],
          titreannonce: 'Test annonce',
          idadresseNavigation: { idvilleNavigation: { nomville: 'Paris' } },
        },
        iddatedebutreservationNavigation: { date1: '2026-04-01T00:00:00Z' },
        iddatefinreservationNavigation: { date1: '2026-04-05T00:00:00Z' },
        inclures: [
          { idtypevoyageur: 1, nombrevoyageur: 2 },
          { idtypevoyageur: 2, nombrevoyageur: 1 },
        ],
        nomclient: 'Doe',
        prenomclient: 'John',
        telephoneclient: '0123456789',
        transactions: [],
      }),
    })
  }
  return Promise.resolve({ ok: true, json: () => Promise.resolve({}) })
}))

function createWrapper() {
  return shallowMount(EditReservationView, {
    global: {
      stubs: ['router-link', 'router-view'],
    },
  })
}

describe('EditReservationView.vue', () => {
  let wrapper

  beforeEach(() => {
    vi.clearAllMocks()
    wrapper = createWrapper()
  })

  it('renders without crashing', () => {
    expect(wrapper.exists()).toBe(true)
  })
})
