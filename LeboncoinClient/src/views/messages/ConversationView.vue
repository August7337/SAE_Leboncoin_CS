<script setup>
import { ref, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import { authState } from '@/auth.js'
import axios from 'axios'

const route = useRoute()
const messages = ref([])
const newMessage = ref('')
const interlocuteur = ref({ pseudonyme: 'Chargement...' })

async function fetchChat() {
  try {
    // On récupère l'historique avec l'ID de l'interlocuteur présent dans l'URL
    const response = await axios.get(`https://localhost:7057/api/Messages/chat/${authState.user.idutilisateur}/${route.params.id}`)
    messages.value = response.data.messages
    interlocuteur.value = response.data.interlocuteur
  } catch (error) {
    console.error("Erreur chat", error)
  }
}

async function sendMessage() {
  if (!newMessage.value.trim()) return
  
  const text = newMessage.value
  newMessage.value = '' // Vider l'input tout de suite pour la fluidité

  try {
    await axios.post(`https://localhost:7057/api/Messages`, {
      expediteurId: authState.user.idutilisateur,
      destinataireId: route.params.id,
      contenu: text
    })
    fetchChat() // Recharger pour voir le message envoyé
  } catch (error) {
    alert("Message non envoyé")
  }
}

onMounted(fetchChat)
</script>

<template>
  <div class="h-screen bg-white flex flex-col max-w-4xl mx-auto border-x border-gray-100 shadow-2xl">
    <div class="p-4 border-b border-gray-100 flex items-center gap-4 bg-white/80 backdrop-blur-md sticky top-0">
      <router-link to="/messages" class="p-2 hover:bg-gray-100 rounded-full transition-colors">
        <svg class="w-6 h-6 text-gray-600" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path d="M15 19l-7-7 7-7" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"/></svg>
      </router-link>
      <div class="w-10 h-10 bg-orange-100 rounded-full flex items-center justify-center font-bold text-[#ea580c]">
        {{ interlocuteur.pseudonyme.charAt(0) }}
      </div>
      <div>
        <h2 class="font-black text-gray-900 leading-none">{{ interlocuteur.pseudonyme }}</h2>
        <span class="text-[10px] text-green-500 font-bold uppercase tracking-wider">En ligne</span>
      </div>
    </div>

    <div class="flex-1 overflow-y-auto p-6 space-y-6 bg-[#fcfcfc]">
      <div v-for="msg in messages" :key="msg.id" 
           :class="msg.expediteurId === authState.user.idutilisateur ? 'flex justify-end' : 'flex justify-start'">
        <div :class="msg.expediteurId === authState.user.idutilisateur 
              ? 'bg-[#ea580c] text-white rounded-3xl rounded-tr-none shadow-orange-100 shadow-lg' 
              : 'bg-white text-gray-800 rounded-3xl rounded-tl-none border border-gray-100 shadow-sm'"
             class="max-w-[75%] px-5 py-4 text-sm font-bold leading-relaxed">
          {{ msg.contenu }}
        </div>
      </div>
    </div>

    <div class="p-6 border-t border-gray-100 bg-white">
      <form @submit.prevent="sendMessage" class="flex gap-3">
        <input 
          v-model="newMessage"
          type="text" 
          placeholder="Votre message..."
          class="flex-1 bg-gray-100 border-none rounded-2xl px-6 py-4 focus:ring-2 focus:ring-[#ea580c] outline-none transition-all font-medium"
        />
        <button type="submit" class="bg-[#ea580c] text-white p-4 rounded-2xl hover:bg-[#c2410c] transition-all shadow-lg shadow-orange-200">
          <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path d="M5 13l4 4L19 7" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/></svg>
        </button>
      </form>
    </div>
  </div>
</template>