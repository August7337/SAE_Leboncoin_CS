<script setup>
import { ref, onMounted, computed } from 'vue'
import axios from 'axios'
import AnnonceList from '@/components/AnnonceList.vue'

const allAnnonces = ref([])
const loading = ref(true)
const searchQuery = ref('')

async function fetchAnnonces() {
  try {
    const response = await axios.get('https://localhost:7057/api/Annonces')
    allAnnonces.value = response.data
  } catch (error) {
    console.error("Erreur recherche", error)
  } finally {
    loading.value = false
  }
}

const filteredAnnonces = computed(() => {
  if (!searchQuery.value) return allAnnonces.value
  const q = searchQuery.value.toLowerCase()
  return allAnnonces.value.filter(a => 
    a.titreannonce.toLowerCase().includes(q) || 
    a.idadresseNavigation?.ville?.nomville?.toLowerCase().includes(q)
  )
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
            type="text" 
            placeholder="Rechercher une ville, un titre..."
            class="w-full bg-gray-100 border-none rounded-2xl py-4 pl-12 pr-4 focus:ring-2 focus:ring-[#ea580c] transition-all outline-none"
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
        </div>

        <AnnonceList v-if="filteredAnnonces.length > 0" :annonces="filteredAnnonces" />

        <div v-else class="bg-white rounded-3xl p-16 text-center border border-gray-100 mt-10">
          <p class="text-gray-400 text-lg">Aucun résultat pour cette recherche.</p>
          <button @click="searchQuery = ''" class="mt-4 text-[#ea580c] font-bold">Effacer les filtres</button>
        </div>
      </div>
    </div>
  </div>
</template>