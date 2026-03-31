<script setup>
import { useRouter } from 'vue-router';
import { ref, onMounted, computed, watch, nextTick } from 'vue'
import { useRoute } from 'vue-router'
import { authState } from '@/auth.js';
import axios from 'axios'
import { buildAssetUrl } from '../../services/api'
import PhotoCarousel from '../../components/PhotoCarousel.vue'
import DateRangePicker from '../../components/DateRangePicker.vue'

const router = useRouter();

const reserverMaintenant = (annonceId, dateDebut, dateFin) => {
  if (!authState.user) {
    router.push('/login');
    return;
  }

  router.push({
    name: 'ReservationCreate',
    params: { id: annonceId },
    query: { start: dateDebut, end: dateFin }
  });
};

const route = useRoute()
const annonce = ref(null)
const similaires = ref([])
const loading = ref(true)
const shareMenuOpen = ref(false)
const dateArrivee = ref('')
const dateDepart = ref('')
const dateWarning = ref('* Veuillez sélectionner vos dates pour continuer')
const canReserve = ref(false)
const nombreNuits = ref(0)
const totalPrix = ref(null)
const selectedDates = ref({ start: '', end: '' })

const googleApiKey = import.meta.env.VITE_GOOGLE_MAPS_API_KEY

// --- Computed ---

const fullAddress = computed(() => {
  const addr = annonce.value?.idadresseNavigation
  if (!addr) return null
  const num = addr.numerorue || ''
  const rue = addr.nomrue || ''
  const ville = addr.idvilleNavigation?.nomville || ''
  const cp = addr.idvilleNavigation?.codepostal || ''
  const adresseTexte = `${num} ${rue}, ${cp} ${ville}, France`.trim()
  return encodeURIComponent(adresseTexte)
})

const currentUrl = computed(() => window.location.href)

const reservedDates = computed(() => {
  if (!annonce.value?.reservations) return []
  const dates = []
  for (const r of annonce.value.reservations) {
    const start = r.iddatedebutreservationNavigation?.date1
    const end = r.iddatefinreservationNavigation?.date1
    if (!start || !end) continue
    const current = new Date(start)
    const endDate = new Date(end)
    while (current <= endDate) {
      dates.push(current.toISOString().split('T')[0])
      current.setDate(current.getDate() + 1)
    }
  }
  return dates
})

const commoditesGroupees = computed(() => {
  if (!annonce.value?.idcommodites?.length) return {}
  return annonce.value.idcommodites.reduce((groups, c) => {
    const cat = c.idcategorieNavigation?.nomcategorie || c.nomcategorie || 'Autres'
    if (!groups[cat]) groups[cat] = []
    groups[cat].push(c)
    return groups
  }, {})
})

// --- Calendrier ---

function onDatesChanged({ start, end }) {
  selectedDates.value = { start, end }
  dateArrivee.value = start
  dateDepart.value = end
  if (start && end) {
    const s = new Date(start)
    const e = new Date(end)
    const nights = Math.max(0, Math.round((e - s) / (1000 * 60 * 60 * 24)))
    nombreNuits.value = nights
    totalPrix.value = nights > 0 && annonce.value?.prixnuitee
      ? Math.round(nights * annonce.value.prixnuitee)
      : null
    canReserve.value = true
    dateWarning.value = ''
  } else {
    nombreNuits.value = 0
    totalPrix.value = null
    canReserve.value = false
    if (!start && !end) dateWarning.value = ''
  }
}

// --- Autres fonctions ---

function share(network) {
  const url = encodeURIComponent(currentUrl.value)
  const title = encodeURIComponent(annonce.value?.titreannonce || '')
  const urls = {
    facebook: `https://www.facebook.com/sharer/sharer.php?u=${url}`,
    twitter: `https://twitter.com/intent/tweet?text=${title}&url=${url}`,
    whatsapp: `https://wa.me/?text=${title}%20${url}`,
  }
  if (urls[network]) window.open(urls[network], '_blank')
  shareMenuOpen.value = false
}

function copyLink() {
  navigator.clipboard.writeText(currentUrl.value).then(() => alert('Lien copié !'))
  shareMenuOpen.value = false
}

function formatDate(dateStr) {
  if (!dateStr) return 'Date inconnue'
  return new Intl.DateTimeFormat('fr-FR', { month: 'long', year: 'numeric' }).format(new Date(dateStr))
}

async function fetchAnnonce() {
  loading.value = true
  try {
    const [annonceRes, similairesRes] = await Promise.all([
      axios.get(`https://localhost:7057/api/Annonces/${route.params.id}`),
      axios
        .get(`https://localhost:7057/api/Annonces/${route.params.id}/similaires`)
        .catch(() => ({ data: [] })),
    ])

    const data = annonceRes.data
    if (data.photos && Array.isArray(data.photos)) {
      data.photos = data.photos.map((p) => ({
        ...p,
        lienphoto: buildAssetUrl(p.lienphoto),
      }))
    }
    annonce.value = data
    similaires.value = similairesRes.data || []

  } catch (error) {
    console.error('Erreur chargement annonce', error)
  } finally {
    loading.value = false
  }
}

onMounted(fetchAnnonce)
</script>

<template>
  <div class="min-h-screen bg-white" @click.self="shareMenuOpen = false">
    <!-- Chargement -->
    <div v-if="loading" class="flex justify-center items-center h-[60vh]">
      <div
        class="w-12 h-12 border-4 border-orange-100 border-t-[#ea580c] rounded-full animate-spin"
      ></div>
    </div>

    <!-- Contenu -->
    <div v-else-if="annonce" class="max-w-6xl mx-auto px-4 md:px-12 xl:px-6 py-8">
      <!-- Breadcrumb -->
      <nav class="flex mb-6 text-sm text-gray-500 items-center gap-2">
        <router-link to="/" class="hover:text-[#ea580c] transition-colors">Accueil</router-link>
        <span class="text-gray-300">/</span>
        <span class="font-medium text-gray-900 truncate">{{ annonce.titreannonce }}</span>
      </nav>

      <!-- Carousel photos -->
      <div class="mb-8">
        <PhotoCarousel :photos="annonce.photos" height="h-[450px]" />
      </div>

      <div class="grid grid-cols-1 lg:grid-cols-3 gap-12">
        <!-- ===== Colonne principale ===== -->
        <div class="lg:col-span-2 space-y-8">
          <!-- Titre + badge SMS + partage -->
          <div class="pb-8 border-b border-gray-100">
            <div class="flex items-start justify-between gap-4 mb-3">
              <div class="flex items-center gap-3 flex-wrap">
                <h1 class="text-3xl font-black text-gray-900">{{ annonce.titreannonce }}</h1>
                <span
                  v-if="annonce.smsverifie"
                  class="inline-flex items-center px-2.5 py-1 rounded-full text-xs font-semibold bg-green-100 text-green-800"
                >
                  <svg class="w-3.5 h-3.5 mr-1" fill="currentColor" viewBox="0 0 20 20">
                    <path
                      fill-rule="evenodd"
                      d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z"
                      clip-rule="evenodd"
                    />
                  </svg>
                  Vérifié SMS
                </span>
              </div>

              <!-- Bouton partage -->
              <div class="relative flex-shrink-0">
                <button
                  @click.stop="shareMenuOpen = !shareMenuOpen"
                  class="bg-gray-100 p-3 rounded-full hover:bg-gray-200 transition flex items-center justify-center w-11 h-11 text-gray-500 hover:text-slate-800"
                >
                  <svg
                    xmlns="http://www.w3.org/2000/svg"
                    fill="none"
                    viewBox="0 0 24 24"
                    stroke-width="1.5"
                    stroke="currentColor"
                    class="w-5 h-5"
                  >
                    <path
                      stroke-linecap="round"
                      stroke-linejoin="round"
                      d="M7.217 10.907a2.25 2.25 0 100 2.186m0-2.186c.18.324.283.696.283 1.093s-.103.77-.283 1.093m0-2.186l9.566-5.314m-9.566 7.5l9.566 5.314m0 0a2.25 2.25 0 103.935 2.186 2.25 2.25 0 00-3.935-2.186zm0-12.814a2.25 2.25 0 103.933-2.185 2.25 2.25 0 00-3.933 2.185z"
                    />
                  </svg>
                </button>
                <div
                  v-if="shareMenuOpen"
                  @click.stop
                  class="absolute right-0 mt-2 w-48 bg-white rounded-xl shadow-lg border border-gray-100 z-50 overflow-hidden"
                >
                  <div class="py-1">
                    <button
                      @click="share('facebook')"
                      class="w-full text-left px-4 py-3 text-sm text-gray-700 hover:bg-gray-50 flex items-center gap-3"
                    >
                      <svg class="w-5 h-5 text-blue-600" fill="currentColor" viewBox="0 0 24 24">
                        <path
                          d="M24 12.073c0-6.627-5.373-12-12-12s-12 5.373-12 12c0 5.99 4.388 10.954 10.125 11.854v-8.385H7.078v-3.47h3.047V9.43c0-3.007 1.791-4.669 4.533-4.669 1.312 0 2.686.235 2.686.235v2.953H15.83c-1.491 0-1.956.925-1.956 1.874v2.25h3.328l-.532 3.47h-2.796v8.385C19.612 23.027 24 18.062 24 12.073z"
                        />
                      </svg>
                      Facebook
                    </button>
                    <button
                      @click="share('twitter')"
                      class="w-full text-left px-4 py-3 text-sm text-gray-700 hover:bg-gray-50 flex items-center gap-3"
                    >
                      <svg class="w-5 h-5 text-black" fill="currentColor" viewBox="0 0 24 24">
                        <path
                          d="M18.244 2.25h3.308l-7.227 8.26 8.502 11.24H16.17l-5.214-6.817L4.99 21.75H1.68l7.73-8.835L1.254 2.25H8.08l4.713 6.231zm-1.161 17.52h1.833L7.084 4.126H5.117z"
                        />
                      </svg>
                      X (Twitter)
                    </button>
                    <button
                      @click="share('whatsapp')"
                      class="w-full text-left px-4 py-3 text-sm text-gray-700 hover:bg-gray-50 flex items-center gap-3"
                    >
                      <svg class="w-5 h-5 text-green-500" fill="currentColor" viewBox="0 0 24 24">
                        <path
                          d="M.057 24l1.687-6.163c-1.041-1.804-1.588-3.849-1.587-5.946.003-6.556 5.338-11.891 11.893-11.891 3.181.001 6.167 1.24 8.413 3.488 2.245 2.248 3.481 5.236 3.48 8.414-.003 6.557-5.338 11.892-11.893 11.892-1.99-.001-3.951-.5-5.688-1.448l-6.305 1.654zm6.597-3.807c1.676.995 3.276 1.591 5.392 1.592 5.448 0 9.886-4.434 9.889-9.885.002-5.462-4.415-9.89-9.881-9.892-5.452 0-9.887 4.434-9.889 9.884-.001 2.225.651 3.891 1.746 5.634l-.999 3.648 3.742-.981zm11.387-5.464c-.074-.124-.272-.198-.57-.347-.297-.149-1.758-.868-2.031-.967-.272-.099-.47-.149-.669.149-.198.297-.768.967-.941 1.165-.173.198-.347.223-.644.074-.297-.149-1.255-.462-2.39-1.475-.883-.788-1.48-1.761-1.653-2.059-.173-.297-.018-.458.13-.606.134-.133.297-.347.446-.521.151-.172.2-.296.3-.495.099-.198.05-.372-.025-.521-.075-.148-.669-1.611-.916-2.206-.242-.579-.487-.501-.669-.51l-.57-.01c-.198 0-.52.074-.792.372-.272.297-1.04 1.016-1.04 2.479 0 1.463 1.065 2.876 1.213 3.074.149.198 2.095 3.2 5.076 4.487.709.306 1.263.489 1.694.626.712.226 1.36.194 1.872.118.571-.085 1.758-.719 2.006-1.413.248-.695.248-1.29.173-1.414z"
                        />
                      </svg>
                      WhatsApp
                    </button>
                    <hr class="border-gray-100 my-1" />
                    <button
                      @click="copyLink()"
                      class="w-full text-left px-4 py-3 text-sm text-gray-700 hover:bg-gray-50 flex items-center gap-3"
                    >
                      <svg
                        xmlns="http://www.w3.org/2000/svg"
                        fill="none"
                        viewBox="0 0 24 24"
                        stroke-width="1.5"
                        stroke="currentColor"
                        class="w-5 h-5 text-gray-400"
                      >
                        <path
                          stroke-linecap="round"
                          stroke-linejoin="round"
                          d="M15.75 17.25v3.375c0 .621-.504 1.125-1.125 1.125h-9.75a1.125 1.125 0 01-1.125-1.125V7.875c0-.621.504-1.125 1.125-1.125H6.75a9.06 9.06 0 011.5.124m7.5 10.376h3.375c.621 0 1.125-.504 1.125-1.125V11.25c0-4.46-3.243-8.161-7.5-8.876a9.06 9.06 0 00-1.5-.124H9.375c-.621 0-1.125.504-1.125 1.125v3.5m7.5 10.375H9.375a1.125 1.125 0 01-1.125-1.125v-9.25m12 6.625v-1.875a3.375 3.375 0 00-3.375-3.375h-1.5"
                        />
                      </svg>
                      Copier le lien
                    </button>
                  </div>
                </div>
              </div>
            </div>

            <!-- Infos rapides -->
            <div class="text-sm text-gray-600 flex flex-wrap items-center gap-2">
              <span>{{ annonce.capacite ?? '?' }} pers.</span>
              <span class="font-bold">·</span>
              <span>{{ annonce.nbchambres ?? '?' }} chambres</span>
              <span class="font-bold">·</span>
              <span>{{
                annonce.idadresseNavigation?.idvilleNavigation?.nomville || 'Ville inconnue'
              }}</span>
              <span class="font-bold">·</span>
              <div class="inline-flex items-center gap-1">
                <svg class="w-4 h-4 text-[#b84a14] fill-current" viewBox="0 0 24 24">
                  <path
                    d="M11.0437 2.29647C10.7942 2.46286 10.5447 2.71245 10.3784 3.04524L8.29938 7.6211L3.55925 8.28668C3.22661 8.28668 2.97713 8.45307 2.64449 8.61947C2.39501 8.86906 2.14553 9.11865 2.06237 9.45144C1.97921 9.86742 1.97921 10.2002 2.06237 10.533C2.14553 10.8658 2.31185 11.1986 2.56133 11.4482L6.05405 14.9425L5.22245 19.9343C5.13929 20.2671 5.22245 20.5999 5.30561 20.9327C5.38877 21.2655 5.63825 21.5151 5.88773 21.6814C6.13721 21.8478 6.46985 22.0142 6.8025 22.0142C7.13514 22.0142 7.46778 21.931 7.71726 21.8478L12.0416 19.5183L16.3659 21.8478C16.6154 22.0142 16.948 22.0974 17.2807 22.0142C17.6133 22.0142 17.9459 21.8478 18.1954 21.6814C18.4449 21.5151 18.6944 21.1823 18.7775 20.9327C18.8607 20.5999 18.9439 20.2671 18.8607 19.9343L18.0291 14.9425L21.4387 11.365C21.6882 11.1154 21.8545 10.8658 21.9376 10.533C22.0208 10.2002 22.0208 9.86742 21.9376 9.53464C21.8545 9.20185 21.6882 8.95225 21.4387 8.70266C21.1892 8.45307 20.8566 8.36987 20.6071 8.28668L15.8669 7.5379L13.7048 3.04524C13.5385 2.71245 13.3721 2.46286 13.0395 2.29647Z"
                  />
                </svg>
                <span class="font-semibold">{{ annonce.nombreetoilesleboncoin ?? 0 }}</span>
              </div>
            </div>
          </div>

          <!-- Description -->
          <div>
            <h2 class="text-2xl font-bold mb-4 text-gray-900">À propos de ce logement</h2>
            <p class="text-gray-600 leading-relaxed text-lg whitespace-pre-line">
              {{ annonce.descriptionannonce }}
            </p>
          </div>

          <hr class="border-gray-200" />

          <!-- Critères -->
          <section>
            <h2 class="text-xl font-black mb-6 text-slate-800">Critères</h2>
            <div class="grid grid-cols-2 md:grid-cols-3 gap-6">
              <div class="flex items-start gap-3">
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  fill="none"
                  viewBox="0 0 24 24"
                  stroke-width="1.5"
                  stroke="currentColor"
                  class="w-6 h-6 text-neutral-800 shrink-0"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    d="M13.5 21v-7.5a.75.75 0 01.75-.75h3a.75.75 0 01.75.75V21m-4.5 0H2.36m11.14 0H18m0 0h3.64m-1.39 0V9.349m-16.5 11.65V9.35m0 0a3.001 3.001 0 003.75-.615A2.993 2.993 0 009.75 9.75c.896 0 1.7-.393 2.25-1.016a2.993 2.993 0 002.25 1.016c.896 0 1.7-.393 2.25-1.016a3.001 3.001 0 003.75.614m-16.5 0a3.004 3.004 0 01-.621-4.72L4.318 3.44A1.5 1.5 0 015.378 3h13.243a1.5 1.5 0 011.06.44l1.19 1.189a3 3 0 01-.621 4.72m-13.5 8.65h3.75a.75.75 0 00.75-.75V13.5a.75.75 0 00-.75-.75H6.75a.75.75 0 00-.75.75v3.75c0 .415.336.75.75.75z"
                  />
                </svg>
                <div class="flex flex-col">
                  <span class="text-xs text-gray-500 mb-0.5">Classement</span>
                  <span class="font-bold text-sm text-neutral-900">{{
                    annonce.nombreetoilesleboncoin
                      ? annonce.nombreetoilesleboncoin + ' étoiles'
                      : 'Non classé'
                  }}</span>
                </div>
              </div>
              <div class="flex items-start gap-3">
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  fill="none"
                  viewBox="0 0 24 24"
                  stroke-width="1.5"
                  stroke="currentColor"
                  class="w-6 h-6 text-neutral-800 shrink-0"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    d="M18 18.72a9.094 9.094 0 003.741-.479 3 3 0 00-4.682-2.72m.94 3.198l.001.031c0 .225-.012.447-.037.666A11.944 11.944 0 0112 21c-2.17 0-4.207-.576-5.963-1.584A6.062 6.062 0 016 18.719m12 0a5.971 5.971 0 00-.941-3.197m0 0A5.995 5.995 0 0012 12.75a5.995 5.995 0 00-5.058 2.772m0 0a3 3 0 00-4.681 2.72 8.986 8.986 0 003.74.477m.94-3.197a5.971 5.971 0 00-.94 3.197M15 6.75a3 3 0 11-6 0 3 3 0 016 0zm6 3a2.25 2.25 0 11-4.5 0 2.25 2.25 0 014.5 0zm-13.5 0a2.25 2.25 0 11-4.5 0 2.25 2.25 0 014.5 0z"
                  />
                </svg>
                <div class="flex flex-col">
                  <span class="text-xs text-gray-500 mb-0.5">Capacité</span>
                  <span class="font-bold text-sm text-neutral-900"
                    >{{ annonce.capacite ?? '?' }} personnes</span
                  >
                </div>
              </div>
              <div class="flex items-start gap-3">
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  fill="none"
                  viewBox="0 0 24 24"
                  stroke-width="1.5"
                  stroke="currentColor"
                  class="w-6 h-6 text-neutral-800 shrink-0"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    d="M20.25 7.5l-.625 10.632a2.25 2.25 0 01-2.247 2.118H6.622a2.25 2.25 0 01-2.247-2.118L3.75 7.5M10 11.25h4M3.375 7.5h17.25c.621 0 1.125-.504 1.125-1.125v-1.5c0-.621-.504-1.125-1.125-1.125H3.375c-.621 0-1.125.504-1.125 1.125v1.5c0 .621.504 1.125 1.125 1.125z"
                  />
                </svg>
                <div class="flex flex-col">
                  <span class="text-xs text-gray-500 mb-0.5">Chambres</span>
                  <span class="font-bold text-sm text-neutral-900"
                    >{{ annonce.nbchambres ?? 0 }} chambres</span
                  >
                </div>
              </div>
              <div class="flex items-start gap-3">
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  fill="none"
                  viewBox="0 0 24 24"
                  stroke-width="1.5"
                  stroke="currentColor"
                  class="w-6 h-6 text-neutral-800 shrink-0"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    d="M12 6v6h4.5m4.5 0a9 9 0 11-18 0 9 9 0 0118 0z"
                  />
                </svg>
                <div class="flex flex-col">
                  <span class="text-xs text-gray-500 mb-0.5">Séjour minimum</span>
                  <span class="font-bold text-sm text-neutral-900"
                    >{{ annonce.minimumnuitee ?? 1 }} nuit{{
                      annonce.minimumnuitee !== 1 ? 's' : ''
                    }}</span
                  >
                </div>
              </div>
              <div class="flex items-start gap-3">
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  fill="none"
                  viewBox="0 0 24 24"
                  stroke-width="1.5"
                  stroke="currentColor"
                  class="w-6 h-6 text-neutral-800 shrink-0"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    d="M15 19.128a9.38 9.38 0 002.625.372 9.337 9.337 0 004.121-.952 4.125 4.125 0 00-7.533-2.493M15 19.128v-.003c0-1.113-.285-2.16-.786-3.07M15 19.128v.106A12.318 12.318 0 018.624 21c-2.331 0-4.512-.645-6.374-1.766l-.001-.109a6.375 6.375 0 0111.964-3.07M12 6.375a3.375 3.375 0 11-6.75 0 3.375 3.375 0 016.75 0zm8.25 2.25a2.625 2.625 0 11-5.25 0 2.625 2.625 0 015.25 0z"
                  />
                </svg>
                <div class="flex flex-col">
                  <span class="text-xs text-gray-500 mb-0.5">Bébés max</span>
                  <span class="font-bold text-sm text-neutral-900">{{
                    annonce.nombrebebesmax ?? 0
                  }}</span>
                </div>
              </div>
              <div class="flex items-start gap-3">
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  fill="none"
                  viewBox="0 0 24 24"
                  stroke-width="1.5"
                  stroke="currentColor"
                  class="w-6 h-6 text-neutral-800 shrink-0"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    d="M13.5 21v-7.5a.75.75 0 01.75-.75h3a.75.75 0 01.75.75V21m-4.5 0H2.36m11.14 0H18m0 0h3.64m-1.39 0V9.349m-16.5 11.65V9.35m0 0a3.001 3.001 0 003.75-.615A2.993 2.993 0 009.75 9.75c.896 0 1.7-.393 2.25-1.016a2.993 2.993 0 002.25 1.016c.896 0 1.7-.393 2.25-1.016a3.001 3.001 0 003.75.614m-16.5 0a3.004 3.004 0 01-.621-4.72L4.318 3.44A1.5 1.5 0 015.378 3h13.243a1.5 1.5 0 011.06.44l1.19 1.189a3 3 0 01-.621 4.72m-13.5 8.65h3.75a.75.75 0 00.75-.75V13.5a.75.75 0 00-.75-.75H6.75a.75.75 0 00-.75.75v3.75c0 .415.336.75.75.75z"
                  />
                </svg>
                <div class="flex flex-col">
                  <span class="text-xs text-gray-500 mb-0.5">Type</span>
                  <span class="font-bold text-sm text-neutral-900">{{
                    annonce.idtypehebergementNavigation?.nomtypehebergement || 'Non spécifié'
                  }}</span>
                </div>
              </div>
            </div>
          </section>

          <hr class="border-gray-200" />

          <!-- Conditions -->
          <section>
            <h2 class="text-xl font-black mb-6 text-slate-800">Conditions</h2>
            <div class="grid grid-cols-2 md:grid-cols-3 gap-6">
              <div class="flex items-start gap-3">
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  fill="none"
                  viewBox="0 0 24 24"
                  stroke-width="1.5"
                  stroke="currentColor"
                  class="w-6 h-6 text-neutral-800 shrink-0"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    d="M12 6v6h4.5m4.5 0a9 9 0 11-18 0 9 9 0 0118 0z"
                  />
                </svg>
                <div class="flex flex-col">
                  <span class="text-xs text-gray-500 mb-0.5">Arrivée</span>
                  <span class="font-bold text-sm text-neutral-900">{{
                    annonce.idheurearriveeNavigation?.heure ?? 'Non spécifiée'
                  }}</span>
                </div>
              </div>
              <div class="flex items-start gap-3">
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  fill="none"
                  viewBox="0 0 24 24"
                  stroke-width="1.5"
                  stroke="currentColor"
                  class="w-6 h-6 text-neutral-800 shrink-0"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    d="M12 6v6h4.5m4.5 0a9 9 0 11-18 0 9 9 0 0118 0z"
                  />
                </svg>
                <div class="flex flex-col">
                  <span class="text-xs text-gray-500 mb-0.5">Départ</span>
                  <span class="font-bold text-sm text-neutral-900">{{
                    annonce.idheuredepartNavigation?.heure ?? 'Non spécifié'
                  }}</span>
                </div>
              </div>
              <div class="flex items-start gap-3">
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  fill="none"
                  viewBox="0 0 24 24"
                  stroke-width="1.5"
                  stroke="currentColor"
                  class="w-6 h-6 text-neutral-800 shrink-0"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    d="M15.182 15.182a4.5 4.5 0 01-6.364 0M21 12a9 9 0 11-18 0 9 9 0 0118 0zM9.75 9.75c0 .414-.168.75-.375.75S9 10.164 9 9.75 9.168 9 9.375 9s.375.336.375.75zm-.375 0h.008v.015h-.008V9.75zm5.625 0c0 .414-.168.75-.375.75s-.375-.336-.375-.75.168-.75.375-.75.375.336.375.75zm-.375 0h.008v.015h-.008V9.75z"
                  />
                </svg>
                <div class="flex flex-col">
                  <span class="text-xs text-gray-500 mb-0.5">Animaux</span>
                  <span class="font-bold text-sm text-neutral-900">{{
                    annonce.possibiliteanimaux ? 'Autorisé' : 'Non autorisé'
                  }}</span>
                </div>
              </div>
              <div class="flex items-start gap-3">
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  fill="none"
                  viewBox="0 0 24 24"
                  stroke-width="1.5"
                  stroke="currentColor"
                  class="w-6 h-6 text-neutral-800 shrink-0"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    d="M18.364 18.364A9 9 0 005.636 5.636m12.728 12.728A9 9 0 015.636 5.636m12.728 12.728L5.636 5.636"
                  />
                </svg>
                <div class="flex flex-col">
                  <span class="text-xs text-gray-500 mb-0.5">Fumeur</span>
                  <span class="font-bold text-sm text-neutral-900">{{
                    annonce.possibilitefumeur ? 'Autorisé' : 'Non-fumeur'
                  }}</span>
                </div>
              </div>
            </div>
          </section>

          <hr class="border-gray-200" />

          <!-- Commodités -->
          <section v-if="Object.keys(commoditesGroupees).length > 0">
            <h2 class="text-xl font-bold mb-6 text-slate-800">Équipements et services</h2>
            <div v-for="(commodites, categorie, index) in commoditesGroupees" :key="categorie">
              <hr v-if="index > 0" class="border-t border-gray-100 my-6" />
              <h3 class="font-bold text-base text-slate-800 mb-4">{{ categorie }}</h3>
              <ul class="grid grid-cols-1 md:grid-cols-2 gap-y-2">
                <li
                  v-for="c in commodites"
                  :key="c.idcommodite"
                  class="text-slate-600 font-medium flex items-center gap-2"
                >
                  <span>•</span> {{ c.nomcommodite }}
                </li>
              </ul>
            </div>
          </section>

          <hr class="border-gray-200" />

          <div v-if="annonce.idutilisateurNavigation" class="bg-slate-50 border border-slate-100 rounded-3xl p-8 transition-all hover:shadow-md">
            <div class="flex flex-col md:flex-row gap-8 items-start md:items-center">
              <router-link :to="`/vendeur/${annonce.idutilisateur}`" class="relative flex-shrink-0 group">
                <img
                  :src="
                    annonce.idutilisateurNavigation.profilePhotoPath ||
                    'https://ui-avatars.com/api/?name=' +
                      encodeURIComponent(annonce.idutilisateurNavigation.pseudonyme || 'U')
                  "
                  :alt="annonce.idutilisateurNavigation.pseudonyme"
                  class="w-24 h-24 rounded-full object-cover border-4 border-white shadow-sm group-hover:border-orange-200 transition-all"
                />
                <div 
                  v-if="annonce.idutilisateurNavigation.identityVerified"
                  class="absolute -bottom-1 -right-1 bg-blue-500 text-white p-1.5 rounded-full border-2 border-white shadow-sm"
                  title="Identité vérifiée"
                >
                  <svg class="w-4 h-4" fill="currentColor" viewBox="0 0 20 20">
                    <path fill-rule="evenodd" d="M2.166 4.9L9.03 9.069a2.25 2.25 0 002.49 0l6.861-4.17a2.25 2.25 0 00.32-3.619l-7.5-5.25a2.25 2.25 0 00-2.43 0l-7.5 5.25a2.25 2.25 0 00.395 3.62zM1.8 11.458l6.83 4.148a2.25 2.25 0 002.49 0l6.83-4.148a.75.75 0 01.765 1.284l-6.83 4.148a3.75 3.75 0 01-4.15 0L.785 12.742a.75.75 0 11.765-1.284z" clip-rule="evenodd" />
                    <path d="M10 11a1 1 0 100-2 1 1 0 000 2z" />
                    <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" />
                  </svg>
                </div>
              </router-link>

              <div class="flex-1 space-y-4 w-full">
                <div class="flex flex-col md:flex-row md:items-center justify-between gap-4">
                  <div>
                    <router-link :to="`/vendeur/${annonce.idutilisateur}`">
                      <h3 class="text-2xl font-black text-slate-900 mb-1 hover:text-orange-500 transition-colors">
                        {{ annonce.idutilisateurNavigation.pseudonyme }}
                      </h3>
                    </router-link>
                    <p class="text-slate-500 font-medium flex items-center gap-2">
                      Membre depuis {{ formatDate(annonce.idutilisateurNavigation.dateInscription) }}
                    </p>
                  </div>
                  
                  <div class="flex gap-2">
                    <span 
                      v-if="annonce.idutilisateurNavigation.phoneVerified"
                      class="inline-flex items-center gap-1 px-3 py-1 rounded-full text-xs font-bold bg-green-50 text-green-700 border border-green-100"
                    >
                      <svg class="w-3.5 h-3.5" fill="currentColor" viewBox="0 0 20 20">
                        <path d="M2.003 5.884L10 9.882l7.997-3.998A2 2 0 0016 4H4a2 2 0 00-1.997 1.884z" />
                        <path d="M18 8.118l-8 4-8-4V14a2 2 0 002 2h12a2 2 0 002-2V8.118z" />
                      </svg>
                      Téléphone vérifié
                    </span>
                  </div>
                </div>

                <div class="grid grid-cols-1 sm:grid-cols-2 gap-4 pt-4 border-t border-slate-200">
                  <div class="flex items-center gap-3">
                    <div class="p-2.5 bg-white rounded-xl shadow-sm border border-slate-100">
                      <svg class="w-5 h-5 text-orange-500 fill-current" viewBox="0 0 24 24">
                        <path d="M11.0437 2.29647C10.7942 2.46286 10.5447 2.71245 10.3784 3.04524L8.29938 7.6211L3.55925 8.28668C3.22661 8.28668 2.97713 8.45307 2.64449 8.61947C2.39501 8.86906 2.14553 9.11865 2.06237 9.45144C1.97921 9.86742 1.97921 10.2002 2.06237 10.533C2.14553 10.8658 2.31185 11.1986 2.56133 11.4482L6.05405 14.9425L5.22245 19.9343C5.13929 20.2671 5.22245 20.5999 5.30561 20.9327C5.38877 21.2655 5.63825 21.5151 5.88773 21.6814C6.13721 21.8478 6.46985 22.0142 6.8025 22.0142C7.13514 22.0142 7.46778 21.931 7.71726 21.8478L12.0416 19.5183L16.3659 21.8478C16.6154 22.0142 16.948 22.0974 17.2807 22.0142C17.6133 22.0142 17.9459 21.8478 18.1954 21.6814C18.4449 21.5151 18.6944 21.1823 18.7775 20.9327C18.8607 20.5999 18.9439 20.2671 18.8607 19.9343L18.0291 14.9425L21.4387 11.365C21.6882 11.1154 21.8545 10.8658 21.9376 10.533C22.0208 10.2002 22.0208 9.86742 21.9376 9.53464C21.8545 9.20185 21.6882 8.95225 21.4387 8.70266C21.1892 8.45307 20.8566 8.36987 20.6071 8.28668L15.8669 7.5379L13.7048 3.04524C13.5385 2.71245 13.3721 2.46286 13.0395 2.29647C12.79 2.13007 12.5405 2.04688 12.2911 2.04688H11.9584C11.5426 2.13007 11.2931 2.21327 11.0437 2.29647Z"></path>
                      </svg>
                    </div>
                    <div class="flex flex-col">
                      <span class="font-bold text-slate-900">
                        {{ annonce.idutilisateurNavigation.noteMoyenne ? Number(annonce.idutilisateurNavigation.noteMoyenne).toFixed(1) : '∅' }}
                      </span>
                      <span class="text-xs text-slate-500">{{ annonce.idutilisateurNavigation.nombreAvis || 0 }} avis</span>
                    </div>
                  </div>

                  <div class="flex items-center gap-3">
                    <div class="p-2.5 bg-white rounded-xl shadow-sm border border-slate-100 text-slate-700">
                      <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10" />
                      </svg>
                    </div>
                    <div class="flex flex-col">
                      <span class="font-bold text-slate-900">{{ annonce.idutilisateurNavigation.nombreAnnonces || 0 }}</span>
                      <span class="text-xs text-slate-500">annonces en ligne</span>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <hr class="border-gray-200" />

          <!-- Carte -->
          <div class="pt-8 border-t border-gray-100">
            <h2 class="text-2xl font-bold mb-6">Localisation</h2>
            <div class="w-full h-[400px] rounded-3xl overflow-hidden bg-gray-100 border">
              <iframe
                v-if="fullAddress && googleApiKey"
                width="100%"
                height="100%"
                frameborder="0"
                style="border: 0"
                :src="`https://www.google.com/maps/embed/v1/place?key=${googleApiKey}&q=${fullAddress}`"
                allowfullscreen
              ></iframe>

              <div v-else class="flex items-center justify-center h-full text-gray-400">
                Chargement de la carte...
              </div>
            </div>
          </div>
        </div>

        <!-- ===== Sidebar ===== -->
        <div class="lg:col-span-1">
          <div
            class="sticky top-24 bg-white border border-gray-200 rounded-2xl shadow-xl p-6 space-y-4"
          >
            <!-- Prix -->
            <div>
              <div class="flex items-baseline gap-1">
                <span class="text-3xl font-black text-gray-900">{{ annonce.prixnuitee }}€</span>
                <span class="text-gray-500 font-medium">/ nuit</span>
              </div>
              <p class="text-sm font-medium text-orange-600 mt-1">
                Minimum : {{ annonce.minimumnuitee ?? 1 }} nuit{{
                  annonce.minimumnuitee !== 1 ? 's' : ''
                }}
              </p>
            </div>

            <!-- Sélecteur de dates -->
            <div>
              <p class="text-sm font-bold text-slate-800 mb-2">
                Sélectionnez vos dates de séjour :
              </p>
              <DateRangePicker
                v-model="selectedDates"
                :disabled-dates="reservedDates"
                :min-nights="annonce?.minimumnuitee ?? 1"
                :show-months="2"
                :show-minimum-banner="true"
                @update:model-value="onDatesChanged"
                @warning="dateWarning = $event"
              />
            </div>

            <!-- Résumé du séjour -->
            <div
              v-if="canReserve && totalPrix"
              class="bg-gradient-to-r from-orange-50 to-orange-100/50 border border-orange-200 rounded-xl p-4"
            >
              <p class="text-xs font-semibold text-orange-700 uppercase tracking-wider mb-1">
                Résumé de votre séjour
              </p>
              <div class="flex items-baseline gap-2">
                <p class="text-2xl font-bold text-slate-900">{{ totalPrix }} €</p>
                <p class="text-sm text-slate-700 font-medium">
                  {{ nombreNuits }} nuit{{ nombreNuits > 1 ? 's' : '' }}
                </p>
              </div>
            </div>

            <!-- Avertissement dates -->
            <p
              v-if="dateWarning"
              class="text-xs font-medium text-center"
              :class="canReserve ? 'text-green-600' : 'text-red-500'"
            >
              {{ dateWarning }}
            </p>

            <!-- Bouton réserver -->
            <button
              @click="reserverMaintenant(annonce.idannonce, dateArrivee, dateDepart)"
              :disabled="!canReserve"
              :class="
                canReserve
                  ? 'bg-[#ea580c] hover:bg-[#c2410c] hover:scale-[1.02] active:scale-[0.98] cursor-pointer shadow-sm'
                  : 'bg-gray-300 cursor-not-allowed pointer-events-none'
              "
              class="w-full text-white font-black py-4 rounded-2xl transition-all text-lg"
            >
              Réserver maintenant
            </button>

            <p class="text-sm text-center text-gray-400 font-medium">
              Aucun montant ne sera débité pour le moment
            </p>
          </div>
        </div>
      </div>

      <!-- ===== Annonces similaires ===== -->
      <div v-if="similaires.length > 0" class="mt-16">
        <hr class="mb-12 opacity-50" />
        <div class="flex justify-between items-center mb-6 px-1">
          <h2 class="text-2xl font-black text-slate-800">Ces annonces peuvent vous intéresser</h2>
        </div>
        <div class="flex overflow-x-auto space-x-6 pb-6 px-1 snap-x scrollbar-hide">
          <router-link
            v-for="s in similaires"
            :key="s.idannonce"
            :to="`/annonce/${s.idannonce}`"
            class="snap-start flex-shrink-0 w-72 block bg-white border border-gray-100 rounded-2xl hover:shadow-lg transition-shadow duration-300"
          >
            <div class="relative">
              <img
                :src="s.photos?.[0]?.lienphoto || 'https://via.placeholder.com/300'"
                :alt="s.titreannonce"
                class="w-full h-52 object-cover rounded-t-2xl"
                loading="lazy"
              />
            </div>
            <div class="p-4 flex flex-col gap-1">
              <p class="font-bold text-lg truncate text-slate-800">{{ s.titreannonce }}</p>
              <p class="text-slate-600 text-sm">
                à partir de <span class="font-black text-slate-900">{{ s.prixnuitee }} €</span> /
                nuit
              </p>
              <p class="text-gray-500 text-sm mt-1">{{ s.nomville }} {{ s.codepostal }}</p>
            </div>
          </router-link>
        </div>
      </div>
    </div>

    <!-- Annonce introuvable -->
    <div v-else class="flex flex-col items-center justify-center min-h-[60vh] px-4">
      <div class="bg-orange-50 p-6 rounded-full mb-6">
        <svg class="w-12 h-12 text-[#ea580c]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            stroke-width="2"
            d="M9.172 9.172a4 4 0 015.656 0M9 10h.01M15 10h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"
          />
        </svg>
      </div>
      <h2 class="text-2xl font-bold text-gray-900 mb-2">Annonce introuvable</h2>
      <router-link
        to="/"
        class="bg-gray-900 text-white font-bold py-3 px-8 rounded-xl hover:bg-gray-800 transition-all"
      >
        Retour à l'accueil
      </router-link>
    </div>
  </div>
</template>

<style scoped>
.whitespace-pre-line {
  white-space: pre-line;
}
.scrollbar-hide::-webkit-scrollbar {
  display: none;
}
.scrollbar-hide {
  -ms-overflow-style: none;
  scrollbar-width: none;
}
</style>

<style>
/* ===== Flatpickr — style calendrier ===== */
.flatpickr-calendar {
  background: white;
  border: 1px solid #dddddd;
  border-radius: 12px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.15);
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', sans-serif;
  width: auto !important;
  overflow: hidden;
  z-index: 9999 !important;
}

.flatpickr-months {
  padding: 24px 16px 16px;
  display: flex;
  gap: 60px;
  background: white;
  position: relative;
}

.flatpickr-months .flatpickr-month {
  flex: 1;
  width: 100%;
  position: relative;
}

.flatpickr-month {
  font-weight: 600;
  font-size: 16px;
  color: #222;
  text-align: center;
  padding-bottom: 20px;
}

.flatpickr-prev-month,
.flatpickr-next-month {
  color: #ea580c;
  fill: #ea580c;
  cursor: pointer;
  transition: all 0.2s ease;
  top: 18px !important;
  height: 32px;
  width: 32px;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 0;
}

.flatpickr-prev-month:hover,
.flatpickr-next-month:hover {
  opacity: 0.7;
}

.flatpickr-prev-month {
  left: 8px !important;
  right: auto !important;
}

.flatpickr-next-month {
  right: 8px !important;
  left: auto !important;
}

.flatpickr-weekdays {
  background: white;
  padding: 12px 0;
  font-weight: 500;
  font-size: 12px;
  color: #999;
  text-transform: lowercase;
  letter-spacing: 0.5px;
  border-bottom: 1px solid #f0f0f0;
}

.flatpickr-weekday {
  width: 42px;
  height: 32px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: 400;
}

.flatpickr-days {
  padding: 12px 8px;
  width: 100%;
  background: white;
}

.flatpickr-day {
  width: 42px;
  height: 42px;
  max-width: none;
  font-size: 13px;
  color: #222;
  border-radius: 4px;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.15s ease;
  line-height: 1;
  position: relative;
  margin: 2px;
  font-weight: 400;
}

.flatpickr-day.today {
  background-color: white;
  color: #222;
  font-weight: 600;
  border: 1px solid #e0e0e0;
}

.flatpickr-day.today:hover {
  background-color: #fafafa;
}

.flatpickr-day.selected,
.flatpickr-day.startRange,
.flatpickr-day.endRange {
  background-color: #222 !important;
  color: white !important;
  font-weight: 600;
  border-radius: 4px;
}

.flatpickr-day.inRange {
  background-color: #f0f0f0 !important;
  color: #222 !important;
  border-radius: 0;
  box-shadow: none !important;
}

.flatpickr-day.startRange {
  border-radius: 4px;
}

.flatpickr-day.endRange {
  border-radius: 4px;
}

.flatpickr-day.disabled,
.flatpickr-day.flatpickr-disabled {
  background-color: white !important;
  color: #ccc !important;
  cursor: not-allowed !important;
  opacity: 1 !important;
  text-decoration: line-through;
  text-decoration-color: #ccc;
  text-decoration-thickness: 1px;
}

.flatpickr-day.prevMonthDay,
.flatpickr-day.nextMonthDay {
  color: #e0e0e0;
  background-color: transparent;
}

.flatpickr-day:hover:not(.disabled):not(.prevMonthDay):not(.nextMonthDay):not(.flatpickr-disabled) {
  background-color: #f0f0f0;
  cursor: pointer;
}

.flatpickr-day.selected:hover {
  background-color: #222 !important;
}

.flatpickr-time {
  display: none !important;
}

.flatpickr-innerContainer {
  display: flex;
  gap: 20px;
  padding: 0;
}

.flatpickr-monthContainer {
  flex: 1;
}

.flatpickr-monthDropdown-months {
  background: white;
  border: 1px solid #d1d5db;
  border-radius: 4px;
  padding: 4px;
  font-size: 13px;
  color: #1f2937;
}

.flatpickr-monthDropdown-months:hover {
  border-color: #ea580c;
}

.fp-minimum-header {
  padding: 14px 16px;
  background: #ea580c;
  text-align: center;
  font-size: 13px;
  font-weight: 600;
  color: white;
  border-radius: 12px 12px 0 0;
  letter-spacing: 0.3px;
}
</style>