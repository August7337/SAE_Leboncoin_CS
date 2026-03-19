<script setup>
import { reactive, ref } from 'vue'
import { authState } from '@/auth.js'
import axios from 'axios'

const isSaving = ref(false)
const showSuccess = ref(false)
const apiError = ref('')

const form = reactive({
  currentPassword: '',
  newPassword: '',
  confirmPassword: ''
})

async function updatePassword() {
  apiError.value = ''
  
  if (form.newPassword !== form.confirmPassword) {
    apiError.value = "Les nouveaux mots de passe ne correspondent pas."
    return
  }

  isSaving.value = true
  try {
    await axios.post(`https://localhost:7057/api/Utilisateurs/change-password`, {
      idutilisateur: authState.user.idutilisateur,
      oldPassword: form.currentPassword,
      newPassword: form.newPassword
    })
    
    showSuccess.value = true
    form.currentPassword = ''
    form.newPassword = ''
    form.confirmPassword = ''
    setTimeout(() => { showSuccess.value = false }, 3000)
  } catch (error) {
    apiError.value = error.response?.data || "Erreur lors de la modification."
  } finally {
    isSaving.value = false
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
        <h2 class="text-2xl font-bold text-gray-900">Mot de passe mis à jour !</h2>
      </div>
    </div>

    <div class="max-w-2xl mx-auto px-4">
      <h1 class="text-2xl font-black text-gray-900 mb-8">Sécurité du compte</h1>

      <div class="bg-white rounded-3xl p-8 shadow-sm border border-gray-100">
        <div v-if="apiError" class="mb-6 bg-red-50 text-red-600 p-4 rounded-xl text-sm font-bold border border-red-100">
          {{ apiError }}
        </div>

        <div class="space-y-6">
          <div>
            <label class="block text-sm font-bold mb-2">Mot de passe actuel</label>
            <input v-model="form.currentPassword" type="password" class="w-full px-4 py-3 rounded-xl border border-gray-200 outline-none focus:border-[#ea580c] transition-all" />
          </div>
          
          <div class="border-t border-gray-50 pt-6">
            <label class="block text-sm font-bold mb-2">Nouveau mot de passe</label>
            <input v-model="form.newPassword" type="password" class="w-full px-4 py-3 rounded-xl border border-gray-200 outline-none focus:border-[#ea580c] transition-all" />
          </div>

          <div>
            <label class="block text-sm font-bold mb-2">Confirmer le nouveau mot de passe</label>
            <input v-model="form.confirmPassword" type="password" class="w-full px-4 py-3 rounded-xl border border-gray-200 outline-none focus:border-[#ea580c] transition-all" />
          </div>

          <button 
            @click="updatePassword"
            :disabled="isSaving"
            class="w-full bg-gray-900 text-white font-black py-4 rounded-2xl hover:bg-black transition-all disabled:opacity-50"
          >
            {{ isSaving ? 'Mise à jour...' : 'Modifier le mot de passe' }}
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
@keyframes pulse { 0%, 100% { opacity: 1; } 50% { opacity: .5; } }
.animate-pulse { animation: pulse 2s infinite; }
</style>