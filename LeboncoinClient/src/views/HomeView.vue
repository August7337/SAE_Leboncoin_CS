<template>
  <div class="min-h-screen bg-[#f5f5f5]">
    <div class="max-w-6xl mx-auto px-4 md:px-12 xl:px-6 py-8">
      <!-- Titre de bienvenue style Laravel -->
      <div class="w-full flex justify-center mt-4 mb-10">
        <div
          class="bg-[#f0f4f7] w-fit mx-auto rounded-[32px] px-10 md:px-16 py-8 text-center shadow-sm"
        >
          <h2 class="text-[#5e6a7e] font-bold text-[20px] md:text-[24px] leading-snug">
            Ne passez pas à côté de LA bonne affaire !
          </h2>
        </div>
      </div>

      <!-- Barre de recherche et Filtres style Laravel -->
      <div class="bg-white p-6 rounded-3xl shadow-sm border border-gray-100 mb-10">
        <div class="flex items-center gap-3 overflow-x-auto hide-scrollbar pb-2">
          <!-- Input Recherche Localisation -->
          <div class="relative flex-grow min-w-[280px]">
            <div
              class="flex items-center gap-3 px-5 py-3 bg-white border border-gray-200 rounded-[15px] shadow-sm hover:bg-gray-50 text-sm font-medium transition-colors w-full group focus-within:border-[#ea580c]"
            >
              <svg
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 24 24"
                stroke-width="2"
                stroke="currentColor"
                class="w-5 h-5 text-slate-800 flex-shrink-0"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  d="M15 10.5a3 3 0 11-6 0 3 3 0 016 0z"
                />
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  d="M19.5 10.5c0 7.142-7.5 11.25-7.5 11.25S4.5 17.642 4.5 10.5a7.5 7.5 0 1115 0z"
                />
              </svg>

              <input
                v-model="searchQuery"
                @input="onSearchInput"
                type="text"
                class="border-0 outline-0 focus:outline-none focus:ring-0 bg-transparent w-full text-slate-900 placeholder-slate-400"
                placeholder="Ville, département ou région..."
                autocomplete="off"
              />

              <button 
                v-if="searchQuery || hasActiveFilters" 
                @click="saveCurrentSearch"
                class="text-xs font-bold flex items-center gap-1 transition-colors bg-white px-2 py-1 rounded-lg border ml-2 flex-shrink-0"
                :class="isSaved ? 'text-[#ea580c] border-[#ea580c] cursor-default' : 'text-gray-600 border-gray-200 hover:text-[#ea580c] hover:border-[#ea580c] hover:bg-gray-50'"
              >
                <svg v-if="isSaved" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" class="w-4 h-4">
                  <path fill-rule="evenodd" d="M10.788 3.21c.448-1.077 1.976-1.077 2.424 0l2.082 5.007 5.404.433c1.164.093 1.636 1.545.749 2.305l-4.117 3.527 1.257 5.273c.271 1.136-.964 2.033-1.96 1.425L12 18.354 7.373 21.18c-.996.608-2.231-.29-1.96-1.425l1.257-5.273-4.117-3.527c-.887-.76-.415-2.212.749-2.305l5.404-.433 2.082-5.006z" clip-rule="evenodd" />
                </svg>
                <svg v-else xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" class="w-4 h-4">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M11.48 3.499a.562.562 0 011.04 0l2.125 5.111a.563.563 0 00.475.345l5.518.442c.499.04.701.663.321.988l-4.204 3.602a.563.563 0 00-.182.557l1.285 5.385a.562.562 0 01-.84.61l-4.725-2.885a.563.563 0 00-.586 0L6.982 20.54a.562.562 0 01-.84-.61l1.285-5.386a.562.562 0 00-.182-.557l-4.204-3.602a.563.563 0 01.321-.988l5.518-.442a.563.563 0 00.475-.345L11.48 3.5z" />
                </svg>
                <span class="hidden sm:inline">{{ isSaved ? 'Sauvegardée' : 'Sauvegarder' }}</span>
              </button>

              <svg
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 24 24"
                stroke-width="2.5"
                stroke="currentColor"
                class="w-4 h-4 text-slate-400 flex-shrink-0"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  d="M19.5 8.25l-7.5 7.5-7.5-7.5"
                />
              </svg>
            </div>
          </div>

          <!-- Boutons Filtres -->
          <button @click="openSidebar" class="filter-btn">
            <span>Dates</span>
            <svg
              class="w-4 h-4 text-slate-400"
              fill="none"
              viewBox="0 0 24 24"
              stroke="currentColor"
              stroke-width="2.5"
            >
              <path d="M8.25 4.5l7.5 7.5-7.5 7.5" />
            </svg>
          </button>

          <button @click="openSidebar" class="filter-btn">
            <span>Prix</span>
            <svg
              class="w-4 h-4 text-slate-400"
              fill="none"
              viewBox="0 0 24 24"
              stroke="currentColor"
              stroke-width="2.5"
            >
              <path d="M8.25 4.5l7.5 7.5-7.5 7.5" />
            </svg>
          </button>

          <button @click="openSidebar" class="filter-btn">
            <span>Chambres</span>
            <svg
              class="w-4 h-4 text-slate-400"
              fill="none"
              viewBox="0 0 24 24"
              stroke="currentColor"
              stroke-width="2.5"
            >
              <path d="M8.25 4.5l7.5 7.5-7.5 7.5" />
            </svg>
          </button>

          <button @click="openSidebar" class="filter-btn bg-slate-50 border-slate-200">
            <svg
              xmlns="http://www.w3.org/2000/svg"
              fill="none"
              viewBox="0 0 24 24"
              stroke-width="2"
              stroke="currentColor"
              class="w-5 h-5 text-slate-600"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                d="M10.5 6h9.75M10.5 6a1.5 1.5 0 11-3 0m3 0a1.5 1.5 0 10-3 0M3.75 6H7.5m3 12h9.75m-9.75 0a1.5 1.5 0 01-3 0m3 0a1.5 1.5 0 00-3 0m-3.75 0H7.5m9-6h3.75m-3.75 0a1.5 1.5 0 01-3 0m3 0a1.5 1.5 0 00-3 0m-9.75 0h9.75"
              />
            </svg>
            <span>Filtres</span>
          </button>
        </div>
      </div>

      <!-- Liste des annonces -->
      <div class="mb-6">
        <h1 class="text-2xl font-black text-gray-900 tracking-tight">
          {{ searchQuery ? `Résultats pour "${searchQuery}"` : 'Locations de vacances' }}
        </h1>
        <p class="text-gray-500 text-sm mt-1 font-medium" v-if="!isLoading && !errorMessage">
          {{ annonces.length }} logements disponibles
        </p>
      </div>

      <div v-if="isLoading" class="text-center py-12 text-gray-500 italic">
        Recherche en cours...
      </div>

      <div v-else-if="errorMessage" class="text-center py-12 text-red-600 font-medium">
        {{ errorMessage }}
      </div>

      <div v-else-if="annonces.length > 0">
        <AnnonceList :annonces="annonces" :favorite-ids="favoriteIds" @update-favorites="favoriteIds = $event" />
      </div>

      <div v-else class="bg-white rounded-3xl p-12 text-center shadow-sm border border-gray-100">
        <h2 class="text-xl font-bold text-gray-900">Aucun résultat trouvé</h2>
        <p class="text-gray-500 mt-2">Essayez de modifier votre recherche ou vos filtres.</p>
      </div>
    </div>

    <!-- Sidebar de Filtres -->
    <FilterSidebar
      :isOpen="isSidebarOpen"
      :initialFilters="filters"
      @close="isSidebarOpen = false"
      @apply="applyFilters"
    />
  </div>
</template>

<script setup>
import { onMounted, ref, computed } from 'vue'
import { useRoute } from 'vue-router'
import AnnonceList from '../components/AnnonceList.vue'
import FilterSidebar from '../components/FilterSidebar.vue'
import { buildAssetUrl } from '../services/api'
import annoncesService from '../services/annoncesService'
import recherchesService from '../services/recherchesService'
import { authState } from '@/auth.js'

const route = useRoute()
const annonces = ref([])
const favoriteIds = ref([])
const isLoading = ref(false)
const errorMessage = ref('')
const searchQuery = ref('')
const isSaved = ref(false)
const isSidebarOpen = ref(false)
const filters = ref({
  dateArrivee: '',
  dateDepart: '',
  minPrice: null,
  maxPrice: null,
  nbChambres: 0,
  typeHebergementIds: [],
  commoditeIds: [],
})

const hasActiveFilters = computed(() => {
  return filters.value.dateArrivee !== '' ||
         filters.value.dateDepart !== '' ||
         filters.value.minPrice !== null ||
         filters.value.maxPrice !== null ||
         filters.value.nbChambres > 0 ||
         filters.value.typeHebergementIds.length > 0 ||
         filters.value.commoditeIds.length > 0
})

let searchTimeout = null

const mapAnnonceFromApi = (annonceApi) => {
  return {
    idannonce: annonceApi.idannonce || annonceApi.annonceId,
    titreannonce: annonceApi.titreannonce || annonceApi.titreAnnonce || 'Sans titre',
    prixnuitee: annonceApi.prixnuitee || 0,
    capacite: annonceApi.capacite,
    typehebergement: {
      nomtypehebergement:
        annonceApi.typeHebergement ||
        annonceApi.idtypehebergementNavigation?.nomtypehebergement ||
        'Logement',
    },
    adresse: {
      ville: {
        nomville:
          annonceApi.nomville ||
          annonceApi.idadresseNavigation?.idvilleNavigation?.nomville ||
          null,
        codepostal:
          annonceApi.codepostal ||
          annonceApi.idadresseNavigation?.idvilleNavigation?.codepostal ||
          null,
      },
      adresseComplete: annonceApi.adresse || null,
    },
    photos:
      Array.isArray(annonceApi.photos) && annonceApi.photos.length > 0
        ? annonceApi.photos.map((p) => ({ lienphoto: p.lienphoto }))
        : [],
    dateDepot: annonceApi.dateDepot
      ? new Date(annonceApi.dateDepot).toLocaleDateString('fr-FR')
      : null,
    nombreetoilesleboncoin: annonceApi.nombreetoilesleboncoin,
  }
}

const performSearch = async () => {
  isLoading.value = true
  errorMessage.value = ''

  try {
    let data
    data = await annoncesService.searchByLocation(searchQuery.value || '', filters.value)
    annonces.value = Array.isArray(data) ? data.map(mapAnnonceFromApi) : []
  } catch (error) {
    errorMessage.value = 'Impossible de charger les annonces.'
  } finally {
    isLoading.value = false
  }
}

const onSearchInput = () => {
  isSaved.value = recherchesService.isSearchSaved(searchQuery.value, filters.value)
  if (searchTimeout) clearTimeout(searchTimeout)
  searchTimeout = setTimeout(() => {
    performSearch()
  }, 400)
}

const saveCurrentSearch = () => {
  if ((!searchQuery.value && !hasActiveFilters.value) || isSaved.value) return
  recherchesService.saveSearch(searchQuery.value, filters.value)
  isSaved.value = true
}

const openSidebar = () => {
  isSidebarOpen.value = true
}

const applyFilters = (newFilters) => {
  filters.value = newFilters
  isSaved.value = recherchesService.isSearchSaved(searchQuery.value, filters.value)
  performSearch()
}

onMounted(async () => {
  if (route.query.q !== undefined) {
    searchQuery.value = route.query.q
  }
  if (route.query.f) {
    try {
      filters.value = { ...filters.value, ...JSON.parse(route.query.f) }
    } catch (e) {
      console.error('Failed to parse filters', e)
    }
  }
  isSaved.value = recherchesService.isSearchSaved(searchQuery.value, filters.value)

  if (authState.user) {
    try {
      favoriteIds.value = await annoncesService.getFavoriteIds(authState.user.idutilisateur)
    } catch (e) {
      console.error("Erreur récup favoris", e)
    }
  }
  performSearch()
})
</script>

<style scoped>
.filter-btn {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 0.75rem 1.25rem;
  background-color: white;
  border: 1px solid #e2e8f0;
  border-radius: 15px;
  box-shadow: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
  transition: background-color 0.2s;
  font-size: 0.875rem;
  font-weight: 500;
  white-space: nowrap;
}

.filter-btn:hover {
  background-color: #f8fafc;
}

.hide-scrollbar::-webkit-scrollbar {
  display: none;
}
.hide-scrollbar {
  -ms-overflow-style: none;
  scrollbar-width: none;
}
</style>
