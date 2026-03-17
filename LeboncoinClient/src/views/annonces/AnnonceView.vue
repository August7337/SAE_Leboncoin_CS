<script setup>
import { ref, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import axios from 'axios'

const route = useRoute()
const annonce = ref(null)
const loading = ref(true)

async function fetchAnnonce() {
  try {
    const response = await axios.get(`https://localhost:7057/api/Annonces/${route.params.id}`)
    annonce.value = response.data
  } catch (error) {
    console.error("Erreur chargement annonce", error)
  } finally {
    loading.value = false
  }
}

onMounted(fetchAnnonce)
</script>

<template>
  <div class="min-h-screen bg-white">
    <div v-if="loading" class="flex justify-center items-center h-[60vh]">
      <div class="w-12 h-12 border-4 border-orange-100 border-t-[#ea580c] rounded-full animate-spin"></div>
    </div>

    <div v-else-if="annonce" class="max-w-6xl mx-auto px-4 py-8">
      <div class="grid grid-cols-1 lg:grid-cols-3 gap-12">
        
        <div class="lg:col-span-2 space-y-6">
          <img :src="annonce.lienphoto || 'https://via.placeholder.com/800x500'" class="w-full h-[450px] object-cover rounded-3xl shadow-sm" />
          
          <div class="border-b border-gray-100 pb-6">
            <h1 class="text-3xl font-black text-gray-900">{{ annonce.titreannonce }}</h1>
            <p class="text-gray-500 mt-2">{{ annonce.idadresseNavigation?.ville?.nomville || "Ville inconnue" }}</p>
          </div>

          <div>
            <h2 class="text-xl font-bold mb-4 text-gray-900">Description</h2>
            <p class="text-gray-600 leading-relaxed">{{ annonce.descriptionannonce }}</p>
          </div>
        </div>

        <div class="lg:col-span-1">
          <div class="sticky top-24 bg-white border border-gray-100 rounded-3xl p-8 shadow-xl">
            <div class="flex items-baseline gap-1 mb-8">
              <span class="text-3xl font-black">{{ annonce.prixnuitee }}€</span>
              <span class="text-gray-500">/ nuit</span>
            </div>

            <button class="w-full bg-[#ea580c] text-white font-black py-4 rounded-2xl hover:bg-[#c2410c] transition-all mb-4">
              Réserver maintenant
            </button>
            
            <p class="text-xs text-center text-gray-400">Paiement sécurisé via leboncoin</p>
          </div>
        </div>

      </div>
    </div>
  </div>
</template>