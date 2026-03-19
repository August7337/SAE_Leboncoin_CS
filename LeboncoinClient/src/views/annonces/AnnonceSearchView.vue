<script setup>
import { ref, onMounted } from 'vue'
import AnnonceList from '../../components/AnnonceList.vue'
import annoncesService from '../../services/annoncesService'
import { buildAssetUrl } from '../../services/api'

const searchQuery = ref('')
const filteredAnnonces = ref([])
const isLoading = ref(false)
const errorMessage = ref('')
let searchTimeout = null

const mapAnnonceFromApi = (annonceApi) => {
  return {
    idannonce: annonceApi.idannonce,
    titreannonce: annonceApi.titreannonce || 'Sans titre',
    prixnuitee: annonceApi.prixnuitee || 0,
    capacite: annonceApi.capacite,
    typehebergement: {
      nomtypehebergement: annonceApi.typeHebergement || 'Logement',
    },
    adresse: annonceApi.nomville ? {
      ville: {
        nomville: annonceApi.nomville,
        codepostal: annonceApi.codepostal,
      },
      adresseComplete: annonceApi.adresse
    } : null,
    photos: Array.isArray(annonceApi.photos)
      ? annonceApi.photos.map(p => ({
          ...p,
          lienphoto: buildAssetUrl(p.lienphoto)
        }))
      : [],
    dateDepot: annonceApi.dateDepot ? new Date(annonceApi.dateDepot).toLocaleDateString('fr-FR') : null,
    nombreetoilesleboncoin: annonceApi.nombreetoilesleboncoin
  }
}

const performSearch = async () => {
  isLoading.value = true
  errorMessage.value = ''

  try {
    const data = await annoncesService.searchByLocation(searchQuery.value)
    filteredAnnonces.value = Array.isArray(data) ? data.map(mapAnnonceFromApi) : []
  } catch (error) {
    console.error(error)
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

const clearSearch = () => {
  searchQuery.value = ''
  performSearch()
}

onMounted(() => {
  performSearch()
})

onMounted(fetchAnnonces)
</script>

<template>
  <div class="min-h-screen bg-[#f5f5f5]">
    <div class="bg-white border-b border-gray-100 py-6 sticky top-0 z-10 shadow-sm">
      <div class="max-w-6xl mx-auto px-4">
        <div class="relative group">
          <input 
            v-model="searchQuery"
            @input="onSearchInput"
            type="text"
            placeholder="Où cherchez-vous ? (ex: Nice, Paris...)"
            class="w-full pl-14 pr-4 py-4 bg-gray-100 rounded-2xl border-2 border-transparent focus:border-[#ea580c] focus:bg-white focus:ring-0 outline-none transition-all text-lg"
          />
          <svg class="w-6 h-6 absolute left-4 top-4 text-gray-400 group-focus-within:text-[#ea580c]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
          </svg>
        </div>
      </div>
    </div>

    <div class="max-w-6xl mx-auto px-4 py-8">
      <div v-if="loading" class="flex justify-center py-20">
        <div class="w-10 h-10 border-4 border-orange-100 border-t-[#ea580c] rounded-full animate-spin"></div>
      </div>

      <div v-else>
        <div class="flex items-center justify-between mb-8">
          <h1 class="text-xl font-black text-gray-900">
            {{ filteredAnnonces.length }} logement{{ filteredAnnonces.length > 1 ? 's' : '' }} trouvé{{ filteredAnnonces.length > 1 ? 's' : '' }}
          </h1>
          <p class="text-gray-500 font-medium" v-if="!isLoading && !errorMessage">
            {{ filteredAnnonces.length }} logements disponibles
          </p>
        </div>

        <AnnonceList v-if="filteredAnnonces.length > 0" :annonces="filteredAnnonces" />

        <div v-else class="bg-white rounded-3xl p-16 text-center border border-gray-100 mt-10">
          <p class="text-gray-400 text-lg">Aucun résultat pour cette recherche.</p>
          <button @click="searchQuery = ''" class="mt-4 text-[#ea580c] font-bold">Effacer les filtres</button>
        </div>
      </div>

      <div v-if="isLoading" class="text-center py-12 text-gray-500 italic">
        Recherche en cours...
      </div>
      
      <div v-else-if="errorMessage" class="text-center py-12 text-red-600 font-medium">
        {{ errorMessage }}
      </div>

      <div v-else-if="filteredAnnonces.length > 0">
        <AnnonceList :annonces="filteredAnnonces" />
      </div>

      <div
        v-else
        class="bg-white rounded-3xl p-12 text-center shadow-sm border border-gray-100 mt-10"
      >
        <div
          class="bg-orange-50 w-20 h-20 rounded-full flex items-center justify-center mx-auto mb-4"
        >
          <svg
            class="w-10 h-10 text-[#ea580c]"
            fill="none"
            stroke="currentColor"
            viewBox="0 0 24 24"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M9.172 9.172a4 4 0 015.656 0M9 10h.01M15 10h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"
            ></path>
          </svg>
        </div>
        <h2 class="text-xl font-bold text-gray-900">Aucun résultat trouvé</h2>
        <p class="text-gray-500 mt-2">
          Essayez de modifier votre recherche ou de supprimer les filtres.
        </p>
        <button @click="clearSearch" class="mt-6 text-[#ea580c] font-black hover:underline">
          Voir toutes les annonces
        </button>
      </div>
    </div>
  </div>
</template>