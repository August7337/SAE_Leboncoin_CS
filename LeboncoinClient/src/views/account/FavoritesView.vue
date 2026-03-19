<script setup>
import { ref, onMounted } from 'vue'
import axios from 'axios'
import { authState } from '@/auth.js'
import AnnonceList from '@/components/AnnonceList.vue'

const favorites = ref([])
const loading = ref(true)

async function fetchFavorites() {
  if (!authState.user) return
  try {
    // Note: l'URL dépend de ta table de jointure (ex: UtilisateurFavoris)
    const response = await axios.get(`https://localhost:7057/api/Annonces/favorites/${authState.user.idutilisateur}`)
    favorites.value = response.data
  } catch (error) {
    console.error("Erreur favoris", error)
  } finally {
    loading.value = false
  }
}

onMounted(fetchFavorites)
</script>

<template>
  <div class="min-h-screen bg-[#f5f5f5] py-10">
    <div class="max-w-6xl mx-auto px-4">
      <h1 class="text-3xl font-black text-gray-900 mb-8">Mes favoris</h1>

      <div v-if="loading" class="text-center py-20 text-gray-400">Chargement...</div>

      <div v-else-if="favorites.length > 0">
        <AnnonceList :annonces="favorites" />
      </div>

      <div v-else class="bg-white rounded-3xl p-16 text-center border border-gray-100 shadow-sm">
        <div class="w-20 h-20 bg-pink-50 text-pink-500 rounded-full flex items-center justify-center mx-auto mb-4 text-2xl">❤️</div>
        <h2 class="text-xl font-bold text-gray-900">Aucun favori pour le moment</h2>
        <p class="text-gray-500 mt-2 max-w-sm mx-auto">Parcourez les annonces et cliquez sur le cœur pour les retrouver ici.</p>
        <router-link to="/search" class="inline-block mt-6 font-bold text-[#ea580c]">Explorer les annonces</router-link>
      </div>
    </div>
  </div>
</template>