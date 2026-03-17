<script setup>
import { reactive, ref } from 'vue'
import axios from 'axios'
import { useRouter } from 'vue-router'
import { authState } from '@/auth.js'

const router = useRouter()
const isPublishing = ref(false)
const showSuccess = ref(false)
const apiError = ref('')

const form = reactive({
  titreannonce: '',
  descriptionannonce: '',
  prixnuitee: 0,
  nombrepersonnesmax: 1,
  lienphoto: '', // Pour simplifier, on commence par un lien URL direct
  idadresse: 1 // Id de test, à lier plus tard à une sélection de ville
})

async function publishAnnonce() {
  apiError.value = ''
  
  if (!authState.user) {
    apiError.value = "Vous devez être connecté pour publier."
    return
  }

  isPublishing.value = true
  try {
    const payload = {
      ...form,
      idutilisateur: authState.user.idutilisateur // Lien avec l'auteur
    }

    await axios.post(`https://localhost:7057/api/Annonces`, payload)
    
    showSuccess.value = true
    setTimeout(() => {
      router.push({ name: 'home' })
    }, 2500)
  } catch (error) {
    apiError.value = "Erreur lors de la publication. Vérifiez les champs."
  } finally {
    isPublishing.value = false
  }
}
</script>

<template>
  <div class="min-h-screen bg-[#f5f5f5] py-10">
    <div v-if="showSuccess" class="fixed inset-0 flex items-center justify-center bg-white/95 z-50">
      <div class="text-center">
        <div class="w-20 h-20 bg-orange-100 rounded-full flex items-center justify-center mx-auto mb-4 animate-pulse">
          <svg xmlns="http://www.w3.org/2000/svg" class="h-10 w-10 text-[#ea580c]" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M5 13l4 4L19 7" />
          </svg>
        </div>
        <h2 class="text-2xl font-bold text-gray-900">Annonce publiée !</h2>
        <p class="text-gray-500 mt-2">Elle est désormais visible par tous.</p>
      </div>
    </div>

    <div class="max-w-3xl mx-auto px-4">
      <h1 class="text-2xl font-black text-gray-900 mb-8">Déposer une annonce</h1>

      <form @submit.prevent="publishAnnonce" class="space-y-6">
        <div v-if="apiError" class="bg-red-50 text-red-600 p-4 rounded-2xl text-sm font-bold text-center border border-red-100">
          {{ apiError }}
        </div>

        <div class="bg-white rounded-3xl p-6 shadow-sm border border-gray-100 space-y-4">
          <div>
            <label class="block text-sm font-bold mb-2">Titre de l'annonce</label>
            <input v-model="form.titreannonce" type="text" placeholder="Ex: Bel appartement avec vue..." class="w-full px-4 py-3 rounded-xl border border-gray-200 focus:border-[#ea580c] outline-none transition-all" />
          </div>
          <div>
            <label class="block text-sm font-bold mb-2">Lien de la photo (URL)</label>
            <input v-model="form.lienphoto" type="text" placeholder="https://..." class="w-full px-4 py-3 rounded-xl border border-gray-200 focus:border-[#ea580c] outline-none transition-all" />
          </div>
        </div>

        <div class="bg-white rounded-3xl p-6 shadow-sm border border-gray-100 grid grid-cols-2 gap-4">
          <div>
            <label class="block text-sm font-bold mb-2">Prix par nuit (€)</label>
            <input v-model="form.prixnuitee" type="number" class="w-full px-4 py-3 rounded-xl border border-gray-200 focus:border-[#ea580c] outline-none transition-all" />
          </div>
          <div>
            <label class="block text-sm font-bold mb-2">Voyageurs max</label>
            <input v-model="form.nombrepersonnesmax" type="number" class="w-full px-4 py-3 rounded-xl border border-gray-200 focus:border-[#ea580c] outline-none transition-all" />
          </div>
        </div>

        <div class="bg-white rounded-3xl p-6 shadow-sm border border-gray-100">
          <label class="block text-sm font-bold mb-4">Description</label>
          <textarea v-model="form.descriptionannonce" rows="5" class="w-full px-4 py-3 rounded-xl border border-gray-200 focus:border-[#ea580c] outline-none resize-none transition-all" placeholder="Décrivez votre bien..."></textarea>
        </div>

        <button type="submit" :disabled="isPublishing" class="w-full bg-[#ea580c] text-white font-black py-5 rounded-2xl shadow-lg shadow-orange-100 hover:bg-[#c2410c] transition-all disabled:opacity-50">
          {{ isPublishing ? 'Publication en cours...' : 'Publier mon annonce' }}
        </button>
      </form>
    </div>
  </div>
</template>

<style scoped>
@keyframes pulse { 0%, 100% { opacity: 1; } 50% { opacity: .5; } }
.animate-pulse { animation: pulse 2s infinite; }
</style>