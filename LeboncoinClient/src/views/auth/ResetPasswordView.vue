<script setup>
import { reactive, ref } from 'vue'
import axios from 'axios'
import { useRouter, useRoute } from 'vue-router'

const router = useRouter()
const route = useRoute()
const isSaving = ref(false)
const showSuccess = ref(false)
const apiError = ref('')

const form = reactive({
  password: '',
  confirmPassword: ''
})

async function handleReset() {
  apiError.value = ''
  if (form.password.length < 8) {
    apiError.value = "Le mot de passe doit contenir au moins 8 caractères."
    return
  }
  if (form.password !== form.confirmPassword) {
    apiError.value = "Les mots de passe ne correspondent pas."
    return
  }

  isSaving.value = true
  try {
    await axios.post(`https://localhost:7057/api/Utilisateurs/reset-password`, {
      token: route.query.token,
      newPassword: form.password
    })
    showSuccess.value = true
    setTimeout(() => { router.push({ name: 'login' }) }, 3000)
  } catch (error) {
    apiError.value = "Lien invalide ou expiré."
  } finally {
    isSaving.value = false
  }
}
</script>

<template>
  <div class="min-h-screen bg-[#f5f5f5] flex items-center justify-center px-4">
    <div v-if="showSuccess" class="fixed inset-0 flex items-center justify-center bg-white/95 z-50">
      <div class="text-center">
        <div class="w-20 h-20 bg-orange-100 rounded-full flex items-center justify-center mx-auto mb-4 animate-pulse">
           <svg xmlns="http://www.w3.org/2000/svg" class="h-10 w-10 text-[#ea580c]" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M5 13l4 4L19 7" />
          </svg>
        </div>
        <h2 class="text-2xl font-bold text-gray-900">Mot de passe modifié !</h2>
        <p class="text-gray-500 mt-2">Vous pouvez maintenant vous connecter.</p>
      </div>
    </div>

    <div class="max-w-md w-full bg-white p-8 rounded-3xl shadow-xl border border-gray-100">
      <h1 class="text-2xl font-black text-gray-900 text-center mb-8">Nouveau mot de passe</h1>
      <form @submit.prevent="handleReset" class="space-y-4">
        <div v-if="apiError" class="bg-red-50 text-red-600 p-3 rounded-xl text-sm font-bold text-center">
          {{ apiError }}
        </div>
        <div>
          <label class="block text-sm font-bold mb-2 text-gray-700">Nouveau mot de passe</label>
          <input v-model="form.password" type="password" class="w-full px-4 py-3 rounded-xl border border-gray-200 outline-none focus:border-[#ea580c]" />
        </div>
        <div>
          <label class="block text-sm font-bold mb-2 text-gray-700">Confirmer le mot de passe</label>
          <input v-model="form.confirmPassword" type="password" class="w-full px-4 py-3 rounded-xl border border-gray-200 outline-none focus:border-[#ea580c]" />
        </div>
        <button type="submit" :disabled="isSaving" class="w-full bg-[#ea580c] text-white font-black py-4 rounded-2xl shadow-lg hover:bg-[#c2410c] transition-all">
          {{ isSaving ? 'Mise à jour...' : 'Réinitialiser mon mot de passe' }}
        </button>
      </form>
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