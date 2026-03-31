<script setup>
import { ref, onMounted } from 'vue'
import axios from 'axios'
import { authState } from '@/auth.js'
import EmptyState from '@/components/EmptyState.vue'

const conversations = ref([])
const loading = ref(true)

async function fetchConversations() {
  if (!authState.user) return

  try {
    // On récupère les discussions de l'utilisateur connecté
    const response = await axios.get(
      `https://localhost:7057/api/Messages/conversations/${authState.user.idutilisateur}`,
    )
    conversations.value = response.data
  } catch (error) {
    console.error('Erreur chargement messages', error)
  } finally {
    loading.value = false
  }
}

onMounted(fetchConversations)
</script>

<template>
  <div class="min-h-screen bg-[#f5f5f5] py-10">
    <div class="max-w-4xl mx-auto px-4">
      <h1 class="text-3xl font-black text-gray-900 mb-8">Mes messages</h1>

      <div v-if="loading" class="text-center py-20">
        <div
          class="w-10 h-10 border-4 border-orange-100 border-t-[#ea580c] rounded-full animate-spin mx-auto"
        ></div>
      </div>

      <div v-else-if="conversations.length > 0" class="space-y-3">
        <router-link
          v-for="conv in conversations"
          :key="conv.id"
          :to="'/conversation/' + conv.interlocuteurId"
          class="bg-white p-5 rounded-3xl shadow-sm border border-gray-100 flex items-center gap-4 hover:border-[#ea580c] transition-all group"
        >
          <div
            class="w-14 h-14 bg-orange-50 rounded-full flex items-center justify-center text-[#ea580c] font-bold text-lg"
          >
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

      <EmptyState
        v-else
        title="Aucun message pour le moment"
        description="Dès que vous contacterez un vendeur, vos échanges s'afficheront ici."
        link-label="Parcourir les annonces"
      >
        <template #icon>
          <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-10 h-10 text-[#ea580c]">
            <path stroke-linecap="round" stroke-linejoin="round" d="M8.625 9.75a.375.375 0 11-.75 0 .375.375 0 01.75 0zm0 0H8.25m4.125 0a.375.375 0 11-.75 0 .375.375 0 01.75 0zm0 0H12m4.125 0a.375.375 0 11-.75 0 .375.375 0 01.75 0zm0 0h-.375m-13.5 3.01c0 1.6 1.123 2.994 2.707 3.227 1.087.16 2.185.283 3.293.369V21l4.184-4.183a1.14 1.14 0 01.778-.332 48.294 48.294 0 005.83-.498c1.585-.233 2.708-1.626 2.708-3.228V6.741c0-1.602-1.123-2.995-2.707-3.228A48.394 48.394 0 0012 3c-2.392 0-4.744.175-7.043.513C3.373 3.746 2.25 5.14 2.25 6.741v6.018z" />
          </svg>
        </template>
      </EmptyState>
    </div>
  </div>
</template>

