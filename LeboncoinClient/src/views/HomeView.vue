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
import { onMounted, ref } from 'vue'
import AnnonceList from '../components/AnnonceList.vue'
import FilterSidebar from '../components/FilterSidebar.vue'
import { buildAssetUrl } from '../services/api'
import annoncesService from '../services/annoncesService'
import { authState } from '@/auth.js'

const annonces = ref([])
const favoriteIds = ref([])
const isLoading = ref(false)
const errorMessage = ref('')
const searchQuery = ref('')
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
  if (searchTimeout) clearTimeout(searchTimeout)
  searchTimeout = setTimeout(() => {
    performSearch()
  }, 400)
}

const openSidebar = () => {
  isSidebarOpen.value = true
}

const applyFilters = (newFilters) => {
  filters.value = newFilters
  performSearch()
}

onMounted(async () => {
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
