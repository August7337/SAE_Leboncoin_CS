<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import recherchesService from '@/services/recherchesService'
import annoncesService from '@/services/annoncesService'
import EmptyState from '@/components/EmptyState.vue'

const router = useRouter()
const savedSearches = ref([])
const typeHebergements = ref([])

onMounted(async () => {
  savedSearches.value = recherchesService.getSavedSearches()
  try {
    typeHebergements.value = await annoncesService.getTypeHebergements()
  } catch (e) {
    console.error('Erreur chargement types', e)
  }
})

const deleteSearch = (id) => {
  recherchesService.deleteSearch(id)
  savedSearches.value = recherchesService.getSavedSearches()
}

const replaySearch = (search) => {
  // Navigate to home page with query and filter params
  const queryObj = { q: search.query }
  if (search.filters) {
    queryObj.f = JSON.stringify(search.filters)
  }
  router.push({ name: 'home', query: queryObj })
}

const formatDate = (isoString) => {
  const date = new Date(isoString)
  return new Intl.DateTimeFormat('fr-FR', {
    dateStyle: 'long',
    timeStyle: 'short'
  }).format(date)
}

const getFilterSummary = (filters) => {
  if (!filters) return ''
  const parts = []

  if (filters.typeHebergementIds && filters.typeHebergementIds.length > 0 && typeHebergements.value.length > 0) {
    const names = filters.typeHebergementIds
      .map(id => typeHebergements.value.find(t => t.idtypehebergement === id)?.nomtypehebergement)
      .filter(Boolean)
    if (names.length > 0) {
      parts.push(names.join(', '))
    }
  }

  if (filters.nbChambres > 0) parts.push(`${filters.nbChambres} ch. min`)
  if (filters.minPrice && filters.maxPrice) parts.push(`${filters.minPrice}-${filters.maxPrice}€`)
  else if (filters.minPrice) parts.push(`dès ${filters.minPrice}€`)
  else if (filters.maxPrice) parts.push(`max ${filters.maxPrice}€`)
  if (filters.dateArrivee && filters.dateDepart) {
    parts.push(`${new Date(filters.dateArrivee).toLocaleDateString('fr-FR')} au ${new Date(filters.dateDepart).toLocaleDateString('fr-FR')}`)
  } else if (filters.dateArrivee) {
    parts.push(`dès le ${new Date(filters.dateArrivee).toLocaleDateString('fr-FR')}`)
  }
  return parts.length > 0 ? parts.join(' • ') : 'Aucun filtre'
}
</script>

<template>
  <div class="min-h-screen bg-[#f5f5f5] py-10">
    <div class="max-w-4xl mx-auto px-4">
      <div class="flex items-center gap-4 mb-8">
        <h1 class="text-3xl font-black text-gray-900">Mes recherches sauvegardées</h1>
        <div class="bg-orange-100 text-[#ea580c] px-3 py-1 rounded-full text-sm font-bold">
          {{ savedSearches.length }}
        </div>
      </div>

      <EmptyState
        v-if="savedSearches.length === 0"
        title="Aucune recherche sauvegardée"
        description="Vous n'avez pas encore sauvegardé de recherche."
        link-label="Faire une recherche"
      >
        <template #icon>
          <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-10 h-10 text-[#ea580c]">
            <path stroke-linecap="round" stroke-linejoin="round" d="M21 21l-5.197-5.197m0 0A7.5 7.5 0 105.196 5.196a7.5 7.5 0 0010.607 10.607z" />
          </svg>
        </template>
      </EmptyState>

      <div v-else class="space-y-4">
        <div v-for="search in savedSearches" :key="search.id" class="bg-white rounded-2xl p-6 shadow-sm border border-gray-100 flex items-center justify-between hover:shadow-md transition-shadow group">
          <div>
            <h3 class="text-lg font-bold text-gray-900 capitalize">{{ search.query || 'Tous les lieux' }}</h3>
            <p class="text-sm text-gray-600 mt-1 font-medium" v-if="search.filters && getFilterSummary(search.filters) !== 'Aucun filtre'">
              {{ getFilterSummary(search.filters) }}
            </p>
            <p class="text-xs text-gray-400 mt-1">Sauvegardée le {{ formatDate(search.date) }}</p>
          </div>
          
          <div class="flex items-center gap-3">
            <button @click="replaySearch(search)" class="bg-gray-100 hover:bg-orange-50 text-gray-700 hover:text-[#ea580c] px-4 py-2 rounded-xl font-bold transition-colors">
              Relancer
            </button>
            <button @click="deleteSearch(search.id)" class="p-2 text-gray-400 hover:text-red-500 hover:bg-red-50 rounded-xl transition-colors" title="Supprimer">
              <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" class="w-5 h-5">
                <path stroke-linecap="round" stroke-linejoin="round" d="M14.74 9l-.346 9m-4.788 0L9.26 9m9.968-3.21c.342.052.682.107 1.022.166m-1.022-.165L18.16 19.673a2.25 2.25 0 01-2.244 2.077H8.084a2.25 2.25 0 01-2.244-2.077L4.772 5.79m14.456 0a48.108 48.108 0 00-3.478-.397m-12 .562c.34-.059.68-.114 1.022-.165m0 0a48.11 48.11 0 013.478-.397m7.5 0v-.916c0-1.18-.91-2.164-2.09-2.201a51.964 51.964 0 00-3.32 0c-1.18.037-2.09 1.022-2.09 2.201v.916m7.5 0a48.667 48.667 0 00-7.5 0" />
              </svg>
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
