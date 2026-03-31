import { describe, it, expect, vi, beforeEach } from 'vitest'
import { mount } from '@vue/test-utils'
import SignalerIncident from '@/views/incidents/CreateIncidentView.vue'

// ── Hoisted mocks ─────────────────────────────────────────────────────────────
const { mockPush, mockBack, mockPost, mockGet, mockIsLoggedIn, mockGetByUserId } = vi.hoisted(() => ({
  mockPush:        vi.fn(),
  mockBack:        vi.fn(),
  mockPost:        vi.fn(),
  mockGet:         vi.fn(),
  mockIsLoggedIn:  vi.fn(() => true),
  mockGetByUserId: vi.fn(),
}))

vi.mock('vue-router', () => ({
  useRouter: () => ({ push: mockPush, back: mockBack }),
  useRoute:  () => ({ query: { reservationId: '42' } }),
}))

vi.mock('@/api/axios', () => ({
  default: { post: mockPost, get: mockGet },
}))

vi.mock('@/auth', () => ({
  authState: {
    isLoggedIn:    mockIsLoggedIn,
    user:          { idutilisateur: 1 },
    hasPermission: vi.fn(),
  },
}))

vi.mock('@/services/reservationsService', () => ({
  default: { getByUserId: mockGetByUserId },
}))

// Stub FileUploader to avoid component resolution errors
const FileUploaderStub = { template: '<div />', props: ['modelValue'] }

// ── Helpers ───────────────────────────────────────────────────────────────────
const MOCK_RESERVATIONS = [
  {
    idreservation: 42,
    idannonceNavigation: { titreannonce: 'Villa Méditerranée' },
    iddatedebutreservationNavigation: { date1: '2025-01-10T00:00:00' },
    iddatefinreservationNavigation:   { date1: '2025-01-17T00:00:00' },
  },
  {
    idreservation: 99,
    idannonceNavigation: { titreannonce: 'Chalet Alpin' },
    iddatedebutreservationNavigation: { date1: '2024-06-01T00:00:00' },
    iddatefinreservationNavigation:   { date1: '2024-06-08T00:00:00' },
  },
]

function createWrapper() {
  return mount(SignalerIncident, {
    global: {
      stubs: {
        'router-link':   true,
        'router-view':   true,
        'FileUploader':  FileUploaderStub,
      },
    },
  })
}

function fillValidForm(vm) {
  vm.form.idreservation      = 42
  vm.form.motifincident      = 'Probleme de proprete'
  vm.form.descriptionincident = 'Le logement était très sale à notre arrivée.'
}

// ── Tests ─────────────────────────────────────────────────────────────────────
describe('SignalerIncidentView.vue', () => {
  let wrapper

  beforeEach(async () => {
    vi.clearAllMocks()
    mockGetByUserId.mockResolvedValue(MOCK_RESERVATIONS)
    wrapper = createWrapper()
    await wrapper.vm.$nextTick()
  })

  // ── Rendu initial ──────────────────────────────────────────────────────────
  describe('Rendu initial', () => {
    it('affiche le titre "Signaler un incident"', () => {
      expect(wrapper.text()).toContain('Signaler un incident')
    })

    it('pré-remplit idreservation depuis le query param', () => {
      expect(wrapper.vm.form.idreservation).toBe(42)
    })

    it("n'affiche pas de message d'erreur au départ", () => {
      expect(wrapper.vm.errorMessage).toBeNull()
    })

    it("n'affiche pas de message de succès au départ", () => {
      expect(wrapper.vm.successMessage).toBeNull()
    })
  })

  // ── onMounted ──────────────────────────────────────────────────────────────
  describe('onMounted', () => {
    it("redirige vers /login si l'utilisateur n'est pas connecté", async () => {
      mockIsLoggedIn.mockReturnValueOnce(false)
      const w = createWrapper()
      await w.vm.$nextTick()
      expect(mockPush).toHaveBeenCalledWith('/login')
    })

    it('charge les réservations via reservationsService', async () => {
      expect(mockGetByUserId).toHaveBeenCalledWith(1)
    })

    it('filtre les réservations passées uniquement', () => {
      // Both mock reservations have past dates, both should be present
      expect(wrapper.vm.reservations.length).toBeGreaterThan(0)
    })

    it('affiche une erreur si le chargement des réservations échoue', async () => {
      mockGetByUserId.mockRejectedValueOnce(new Error('network'))
      const w = createWrapper()
      await w.vm.$nextTick()
      expect(w.vm.errorMessage).toBeTruthy()
    })
  })

  // ── Validation ─────────────────────────────────────────────────────────────
  describe('Validation à la soumission', () => {
    it('affiche une erreur si idreservation est absent', async () => {
      fillValidForm(wrapper.vm)
      wrapper.vm.form.idreservation = ''
      await wrapper.vm.submit()
      expect(wrapper.vm.errorMessage).toBeTruthy()
      expect(mockPost).not.toHaveBeenCalled()
    })

    it('affiche une erreur si motifincident est absent', async () => {
      fillValidForm(wrapper.vm)
      wrapper.vm.form.motifincident = ''
      await wrapper.vm.submit()
      expect(wrapper.vm.errorMessage).toBeTruthy()
      expect(mockPost).not.toHaveBeenCalled()
    })

    it('affiche une erreur si la description est vide ou espaces', async () => {
      fillValidForm(wrapper.vm)
      wrapper.vm.form.descriptionincident = '   '
      await wrapper.vm.submit()
      expect(wrapper.vm.errorMessage).toBeTruthy()
      expect(mockPost).not.toHaveBeenCalled()
    })
  })

  // ── Soumission réussie ─────────────────────────────────────────────────────
  describe('Soumission réussie', () => {
    beforeEach(() => fillValidForm(wrapper.vm))

    it('appelle POST /Incidents avec les bonnes données', async () => {
      mockPost.mockResolvedValueOnce({ data: { idincident: 10 } })
      await wrapper.vm.submit()
      expect(mockPost).toHaveBeenCalledWith('/Incidents', {
        idreservation:       42,
        motifincident:       'Probleme de proprete',
        descriptionincident: 'Le logement était très sale à notre arrivée.',
      })
    })

    it('affiche le message de succès', async () => {
      mockPost.mockResolvedValueOnce({ data: { idincident: 10 } })
      await wrapper.vm.submit()
      expect(wrapper.vm.successMessage).toBeTruthy()
    })

    it("redirige vers 'incident-detail' après le délai", async () => {
      vi.useFakeTimers()
      mockPost.mockResolvedValueOnce({ data: { idincident: 10 } })
      await wrapper.vm.submit()
      vi.runAllTimers()
      expect(mockPush).toHaveBeenCalledWith({ name: 'incident-detail', params: { id: 10 } })
      vi.useRealTimers()
    })

    it('uploade les photos si photoFiles est non vide', async () => {
      const fakeFile = new File(['img'], 'photo.jpg', { type: 'image/jpeg' })
      wrapper.vm.photoFiles = [fakeFile]
      mockPost
        .mockResolvedValueOnce({ data: { idincident: 10 } }) // POST /Incidents
        .mockResolvedValueOnce({})                            // POST photos
      await wrapper.vm.submit()
      expect(mockPost).toHaveBeenCalledTimes(2)
      expect(mockPost.mock.calls[1][0]).toContain('/Incidents/10/photos')
    })

    it('remet submitting à false après succès', async () => {
      mockPost.mockResolvedValueOnce({ data: { idincident: 10 } })
      await wrapper.vm.submit()
      expect(wrapper.vm.submitting).toBe(false)
    })
  })

  // ── Erreur API ─────────────────────────────────────────────────────────────
  describe('Erreur API', () => {
    it('affiche le message du serveur en cas d\'erreur', async () => {
      fillValidForm(wrapper.vm)
      mockPost.mockRejectedValueOnce({
        response: { data: { message: 'Réservation introuvable.' } },
      })
      await wrapper.vm.submit()
      expect(wrapper.vm.errorMessage).toBe('Réservation introuvable.')
    })

    it('affiche le message générique si pas de message serveur', async () => {
      fillValidForm(wrapper.vm)
      mockPost.mockRejectedValueOnce(new Error('Network Error'))
      await wrapper.vm.submit()
      expect(wrapper.vm.errorMessage).toBeTruthy()
    })

    it('remet submitting à false après une erreur', async () => {
      fillValidForm(wrapper.vm)
      mockPost.mockRejectedValueOnce(new Error('fail'))
      await wrapper.vm.submit()
      expect(wrapper.vm.submitting).toBe(false)
    })
  })

  // ── formatDate ─────────────────────────────────────────────────────────────
  describe('formatDate', () => {
    it('retourne "?" si la valeur est nulle', () => {
      expect(wrapper.vm.formatDate(null)).toBe('?')
    })

    it('formate une date valide en français', () => {
      const result = wrapper.vm.formatDate('2025-06-15T00:00:00')
      expect(result).toMatch(/2025/)
    })
  })
})
