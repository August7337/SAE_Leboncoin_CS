<script setup>
import { reactive, ref } from 'vue'
import axios from 'axios'
import { useRouter } from 'vue-router'

const router = useRouter()
const isSending = ref(false)
const isSent = ref(false)
const apiError = ref('')

const form = reactive({
  email: ''
})

const errors = reactive({
  email: ''
})

async function handleForgot() {
  errors.email = ''
  apiError.value = ''

  if (!form.email) {
    errors.email = 'Email requis'
    return
  }

  isSending.value = true
  try {
    await axios.post(`https://localhost:7057/api/Utilisateurs/forgot-password`, { 
      email: form.email 
    })
    
    isSent.value = true
    setTimeout(() => {
      router.push({ name: 'login' })
    }, 3000)
  } catch (error) {
    apiError.value = error.response?.data || "Une erreur est survenue."
  } finally {
    isSending.value = false
  }
}
</script>

<template>
  <div class="min-h-screen bg-[#f5f5f5] flex items-center justify-center px-4">
    <div v-if="isSent" class="fixed inset-0 flex items-center justify-center bg-white/95 z-50 transition-opacity">
      <div class="text-center">
        <div class="w-20 h-20 bg-orange-100 rounded-full flex items-center justify-center mx-auto mb-4 animate-pulse">
           <svg xmlns="http://www.w3.org/2000/svg" class="h-10 w-10 text-[#ea580c]" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M5 13l4 4L19 7" />
          </svg>
        </div>
        <h2 class="text-2xl font-bold text-gray-900">Email envoyé !</h2>
        <p class="text-gray-500 mt-2">Consultez votre boîte mail pour réinitialiser votre mot de passe.</p>
      </div>
    </div>

    <div class="max-w-md w-full bg-white p-8 rounded-3xl shadow-xl border border-gray-100">
      <h1 class="text-2xl font-black text-gray-900 text-center mb-2">Mot de passe oublié</h1>
      <p class="text-center text-gray-500 mb-8">Entrez votre email pour recevoir un lien.</p>

      <form @submit.prevent="handleForgot" class="space-y-6">
        <div v-if="apiError" class="bg-red-50 text-red-600 p-3 rounded-xl text-sm font-bold text-center">
          {{ apiError }}
        </div>

        <div class="field">
          <label class="block text-sm font-bold mb-2 text-gray-700">Votre adresse email</label>
          <input 
            v-model="form.email"
            type="email" 
            placeholder="exemple@mail.com"
            class="w-full px-4 py-3 rounded-xl border border-gray-200 outline-none focus:border-[#ea580c] transition-all"
          />
          <span v-if="errors.email" class="text-red-500 text-xs font-bold mt-1">{{ errors.email }}</span>
        </div>

        <button 
          type="submit" 
          :disabled="isSending"
          class="w-full bg-[#ea580c] text-white font-black py-4 rounded-2xl shadow-lg shadow-orange-200 hover:bg-[#c2410c] transition-all disabled:opacity-50"
        >
          {{ isSending ? 'Envoi...' : 'Envoyer le lien' }}
        </button>
      </form>

      <div class="mt-6 text-center">
        <router-link to="/login" class="text-[#ea580c] font-bold hover:underline text-sm">Retour à la connexion</router-link>
      </div>
    </div>
  </div>
</template>

<style scoped>
@keyframes pulse {
  0%, 100% { opacity: 1; }
  50% { opacity: .5; }
}
.animate-pulse {
  animation: pulse 2s cubic-bezier(0.4, 0, 0.6, 1) infinite;
}
</style>