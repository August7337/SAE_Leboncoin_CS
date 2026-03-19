<script setup>
import { ref, onMounted } from 'vue'
import axios from 'axios'
import { authState } from '@/auth.js'

const myAnnonces = ref([])
const loading = ref(true)

async function fetchMyAnnonces() {
  if (!authState.user) return
  
  try {
    // Supposons un endpoint qui filtre par utilisateur
    const response = await axios.get(`https://localhost:7057/api/Annonces/user/${authState.user.idutilisateur}`)
    myAnnonces.value = response.data
  } catch (error) {
    console.error("Erreur mes annonces", error)
  } finally {
    loading.value = false
  }
}

onMounted(fetchMyAnnonces)
</script>

<template>
  <div class="min-h-screen bg-[#f5f5f5] py-10">
    <div class="max-w-4xl mx-auto px-4">
      <div class="flex justify-between items-center mb-10">
        <h1 class="text-2xl font-black text-gray-900">Mes annonces</h1>
        <router-link to="/create-annonce" class="bg-[#ea580c] text-white px-6 py-3 rounded-2xl font-bold shadow-md shadow-orange-100 hover:bg-[#c2410c] transition-all">
          Déposer une annonce
        </router-link>
      </div>

      <div v-if="loading" class="text-center py-10">Chargement...</div>

      <div v-else-if="myAnnonces.length > 0" class="space-y-4">
        <div v-for="annonce in myAnnonces" :key="annonce.idannonce" class="bg-white p-4 rounded-3xl shadow-sm border border-gray-50 flex items-center gap-6">
          <img :src="annonce.lienphoto" class="w-32 h-24 object-cover rounded-2xl" />
          <div class="flex-1">
            <h3 class="font-bold text-gray-900">{{ annonce.titreannonce }}</h3>
            <p class="text-[#ea580c] font-black">{{ annonce.prixnuitee }}€ / nuit</p>
          </div>
          <div class="flex gap-2">
            <router-link :to="'/edit-annonce/' + annonce.idannonce" class="p-3 bg-gray-50 text-gray-700 rounded-xl hover:bg-gray-100 transition-all font-bold text-sm">Modifier</router-link>
          </div>
        </div>
      </div>

      <div v-else class="text-center py-20 bg-white rounded-3xl border border-gray-100">
        <p class="text-gray-500">Vous n'avez pas encore d'annonces.</p>
      </div>
    </div>
  </div>
</template>