<script setup>
import { reactive, ref } from 'vue'
import { authState } from '@/auth.js'
import axios from 'axios'


const localUser = reactive({
  pseudonyme: authState.user?.pseudonyme || '',
  email: authState.user?.email || '',
  profilePhoto: authState.user?.profilePhoto || ''
})

const isSaving = ref(false)
const showSuccess = ref(false)

const saveProfile = async () => {
  isSaving.value = true
  
  try {

    const response = await axios.put(`https://localhost:7057/api/Utilisateurs/${authState.user.utilisateurId}`, {
      utilisateurId: authState.user.utilisateurId,
      pseudonyme: localUser.pseudonyme,
      email: localUser.email,
      profilePhoto: localUser.profilePhoto
     
    })

    
    authState.setUser(response.data)

    
    showSuccess.value = true
    setTimeout(() => { showSuccess.value = false }, 3000)

  } catch (error) {
    console.error('Erreur lors de la mise à jour :', error)
    alert("Une erreur est survenue lors de l'enregistrement.")
  } finally {
    isSaving.value = false
  }
}
</script>

<template>
  <div class="min-h-screen bg-[#f5f5f5] py-10">
    <div class="max-w-2xl mx-auto px-4">
      
      <div class="flex justify-between items-center mb-8">
        <h1 class="text-2xl font-black text-gray-900">Modifier mon profil</h1>
        <router-link to="/profil" class="text-sm text-gray-500 hover:text-black">Annuler</router-link>
      </div>

      <div class="bg-white rounded-3xl p-8 shadow-sm border border-gray-100 space-y-8 relative overflow-hidden">
        
        <div v-if="showSuccess" class="absolute top-0 left-0 right-0 bg-green-500 text-white text-center py-2 text-sm font-bold animate-fade-in-down">
          Profil mis à jour avec succès !
        </div>

        <div class="flex flex-col items-center gap-4 pt-4">
          <img 
            :src="localUser.profilePhoto || `https://ui-avatars.com/api/?name=${localUser.pseudonyme}&background=ea580c&color=fff`" 
            class="w-32 h-32 rounded-full border-4 border-orange-50 object-cover" 
          />
          <button class="text-[#ea580c] font-bold text-sm hover:underline">Changer la photo</button>
        </div>

        <div class="space-y-4">
          <div>
            <label class="block text-sm font-bold mb-2 text-gray-700">Pseudonyme</label>
            <input
              v-model="localUser.pseudonyme"
              type="text"
              placeholder="Votre pseudo"
              class="w-full px-4 py-3 rounded-xl border border-gray-200 outline-none focus:border-[#ea580c] transition-all"
            />
          </div>

          <div>
            <label class="block text-sm font-bold mb-2 text-gray-700">Adresse email</label>
            <input
              v-model="localUser.email"
              type="email"
              placeholder="email@example.com"
              class="w-full px-4 py-3 rounded-xl border border-gray-200 outline-none focus:border-[#ea580c] transition-all"
            />
          </div>
        </div>

        <button
          @click="saveProfile"
          :disabled="isSaving"
          class="w-full bg-[#ea580c] text-white font-black py-4 rounded-2xl shadow-lg shadow-orange-100 hover:bg-[#c2410c] transition-all disabled:opacity-50"
        >
          {{ isSaving ? 'Enregistrement...' : 'Enregistrer les modifications' }}
        </button>
      </div>
    </div>
  </div>
</template>