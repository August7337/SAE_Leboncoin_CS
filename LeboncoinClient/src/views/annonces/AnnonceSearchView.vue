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
    const results = await annoncesService.searchByLocation(searchQuery.value)
    
    filteredAnnonces.value = results.map(mapAnnonceFromApi)
  } catch (error) {
    console.error('Erreur de recherche:', error)
    errorMessage.value = "Une erreur est survenue lors de la récupération des annonces."
  } finally {
    isLoading.value = false
  }
}

const onSearchInput = () => {
  if (searchTimeout) clearTimeout(searchTimeout)
  searchTimeout = setTimeout(() => {
    performSearch()
  }, 300) 
}

onMounted(() => {
  performSearch()
})
</script>

<template>
  <div class="min-h-screen bg-slate-50 py-12">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
      
      <div class="mb-12">
        <h1 class="text-4xl font-black text-slate-900 mb-8 text-center">
          Trouvez votre prochain <span class="text-[#ea580c]">chez-vous</span>
        </h1>
        
        <div class="max-w-2xl mx-auto relative group">
          <input
            v-model="searchQuery"
            @input="onSearchInput"
            type="text"
            placeholder="Où voulez-vous aller ? (Ville, Code postal...)"
            class="w-full pl-14 pr-32 py-5 bg-white border-2 border-slate-200 rounded-3xl shadow-sm focus:border-[#ea580c] focus:ring-0 text-lg transition-all"
          />
          <div class="absolute left-5 top-1/2 -translate-y-1/2 text-slate-400 group-focus-within:text-[#ea580c] transition-colors">
            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
            </svg>
          </div>
          <button @click="performSearch" class="absolute right-3 top-3 bottom-3 bg-[#ea580c] text-white px-6 rounded-2xl font-bold hover:bg-[#c2410c] transition-colors shadow-lg shadow-orange-200">Rechercher</button>
        </div>
      </div>

      <div v-if="isLoading" class="flex justify-center py-20">
        <div class="w-12 h-12 border-4 border-orange-100 border-t-[#ea580c] rounded-full animate-spin"></div>
      </div>
      
      <div v-else-if="errorMessage" class="max-w-md mx-auto bg-red-50 border border-red-100 text-red-700 px-6 py-4 rounded-2xl text-center font-medium">
        {{ errorMessage }}
      </div>

      <div v-else-if="filteredAnnonces.length > 0">
        <AnnonceList :annonces="filteredAnnonces" />
      </div>

      <div v-else class="bg-white rounded-3xl p-16 text-center shadow-sm border border-slate-100 mt-10">
        <div class="bg-orange-50 w-24 h-24 rounded-full flex items-center justify-center mx-auto mb-6">
          <svg class="w-12 h-12 text-[#ea580c]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9.172 9.172a4 4 0 015.656 0M9 10h.01M15 10h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
          </svg>
        </div>
        <h3 class="text-2xl font-bold text-slate-900 mb-2">Aucun résultat trouvé</h3>
        <p class="text-slate-500 max-w-sm mx-auto">
          Nous n'avons trouvé aucun logement pour "{{ searchQuery }}". 
          Essayez de modifier votre recherche.
        </p>
        <button @click="searchQuery = ''; performSearch()" class="mt-8 text-[#ea580c] font-bold hover:underline">
          Effacer la recherche
        </button>
      </div>

    </div>
  </div>
</template>