<script setup>
import { ref, onMounted } from 'vue'
import axios from 'axios'
import { authState } from '@/auth.js'

const conversations = ref([])
const loading = ref(true)

async function fetchConversations() {
  if (!authState.user) return
  
  try {
    // On récupère les discussions de l'utilisateur connecté
    const response = await axios.get(`https://localhost:7057/api/Messages/conversations/${authState.user.idutilisateur}`)
    conversations.value = response.data
  } catch (error) {
    console.error("Erreur chargement messages", error)
  } finally {
    loading.value = false
  }
}

onMounted(fetchConversations)
</script>

<template>
  <div class="min-h-screen bg-[#f5f5f5] py-10">
    <div class="max-w-4xl mx-auto px-4">
      <h1 class="text-2xl font-black text-gray-900 mb-8">Mes messages</h1>

      <div v-if="loading" class="text-center py-20">
        <div class="w-10 h-10 border-4 border-orange-100 border-t-[#ea580c] rounded-full animate-spin mx-auto"></div>
      </div>

      <div v-else-if="conversations.length > 0" class="space-y-3">
        <router-link 
          v-for="conv in conversations" 
          :key="conv.id"
          :to="'/conversation/' + conv.interlocuteurId"
          class="bg-white p-5 rounded-3xl shadow-sm border border-gray-100 flex items-center gap-4 hover:border-[#ea580c] transition-all group"
        >
          <div class="w-14 h-14 bg-orange-50 rounded-full flex items-center justify-center text-[#ea580c] font-bold text-lg">
            {{ conv.interlocuteurNom.charAt(0) }}
          </div>

          <div class="flex-1 min-w-0">
            <div class="flex justify-between items-center mb-1">
              <h3 class="font-bold text-gray-900 truncate">{{ conv.interlocuteurNom }}</h3>
              <span class="text-xs text-gray-400">{{ conv.dateDernierMessage }}</span>
            </div>
            <p class="text-sm text-gray-500 truncate group-hover:text-gray-700">
              {{ conv.dernierMessage }}
            </p>
          </div>

          <div v-if="conv.nonLu" class="w-3 h-3 bg-[#ea580c] rounded-full"></div>
        </router-link>
      </div>

      <div v-else class="bg-white rounded-3xl shadow-sm border border-gray-100 py-20 text-center">
        <div class="bg-gray-50 w-24 h-24 rounded-full flex items-center justify-center mx-auto mb-6">
          <svg class="w-12 h-12 text-gray-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path d="M8 10h.01M12 10h.01M16 10h.01M9 16H5a2 2 0 01-2-2V6a2 2 0 012-2h14a2 2 0 012 2v8a2 2 0 01-2 2h-5l-5 5v-5z" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" />
          </svg>
        </div>
        <h2 class="text-xl font-bold text-gray-900">Aucun message pour le moment</h2>
        <p class="text-gray-500 mt-2 mb-8">Dès que vous contacterez un vendeur, vos échanges s'afficheront ici.</p>
        <router-link to="/search" class="bg-[#ea580c] text-white px-8 py-4 rounded-2xl font-black shadow-lg shadow-orange-100 hover:bg-[#c2410c] transition-all">
          Parcourir les annonces
        </router-link>
      </div>
    </div>
  </div>
</template>

<style scoped>
.animate-spin {
  animation: spin 1s linear infinite;
}
@keyframes spin {
  from { transform: rotate(0deg); }
  to { transform: rotate(360deg); }
}
</style>