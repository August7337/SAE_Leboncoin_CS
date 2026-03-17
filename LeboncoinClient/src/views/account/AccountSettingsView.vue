<script setup>
import { reactive, ref } from 'vue'
import { authState } from '@/auth.js'
import axios from 'axios'


const form = reactive({
  pseudonyme: authState.user?.pseudonyme || '',
  email: authState.user?.email || ''
})

const isSaving = ref(false)
const message = ref({ text: '', type: '' })

const updateAccount = async () => {
  const userId = authState.user?.idutilisateur;
  if (!userId) return;

  isSaving.value = true;
  message.value = { text: '', type: '' };

  try {
    // Create a CLEAN payload (This is essentially a manual DTO)
    const payload = {
      idutilisateur: userId,
      pseudonyme: form.pseudonyme,
      email: form.email,
      // Passwords and Phones usually shouldn't be "defaulted" like this, 
      // but for now, we keep them to satisfy your backend requirements
      motDePasse: authState.user.motDePasse, 
      telephoneutilisateur: authState.user.telephoneutilisateur || "0600000000"
    };

    const response = await axios.put(`https://localhost:7057/api/Utilisateurs/${userId}`, payload);

    // IMPORTANT: Merge the new data with existing data so you don't lose 
    // fields the backend might have left out (like profilePhoto)
    const updatedUser = { ...authState.user, ...response.data };
    authState.setUser(updatedUser);
    
    message.value = { text: 'Modifications enregistrées !', type: 'success' };
  } catch (error) {
    console.error("Error:", error);
    message.value = { text: 'Erreur lors de la sauvegarde.', type: 'error' };
  } finally {
    isSaving.value = false;
  }
};
</script>

<template>
  <div class="min-h-screen bg-[#f5f5f5] py-10">
    <div class="max-w-2xl mx-auto px-4">
      <h1 class="text-2xl font-black text-gray-900 mb-8">Paramètres du compte</h1>

      <div class="bg-white rounded-3xl p-8 shadow-sm border border-gray-100 space-y-6">
        
        <div v-if="message.text" 
             :class="message.type === 'success' ? 'bg-green-50 text-green-700' : 'bg-red-50 text-red-700'"
             class="p-4 rounded-xl text-sm font-bold text-center transition-all">
          {{ message.text }}
        </div>

        <div>
          <label class="block text-sm font-bold mb-2">Nom complet (Pseudonyme)</label>
          <input
            v-model="form.pseudonyme"
            type="text"
            class="w-full px-4 py-3 rounded-xl border border-gray-200 outline-none focus:border-[#ea580c] transition-colors"
          />
        </div>

        <div>
          <label class="block text-sm font-bold mb-2">Adresse email</label>
          <input
            v-model="form.email"
            type="email"
            class="w-full px-4 py-3 rounded-xl border border-gray-200 outline-none focus:border-[#ea580c] transition-colors"
          />
        </div>

        <button
          @click="updateAccount"
          :disabled="isSaving"
          class="w-full bg-[#ea580c] text-white font-bold py-4 rounded-2xl transition-all hover:bg-[#c2410c] disabled:opacity-50 disabled:cursor-not-allowed shadow-lg shadow-orange-100"
        >
          {{ isSaving ? 'Chargement...' : 'Enregistrer les modifications' }}
        </button>
      </div>
    </div>
  </div>
</template>