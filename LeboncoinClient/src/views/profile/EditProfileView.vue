<script setup>
import { reactive, ref, onMounted } from 'vue'
import { authState } from '@/auth.js'
import api from '@/api/axios'

const isSaving = ref(false)
const message = ref({ text: '', type: '' })

// 1. Detect user type (assuming your authState has a 'role' or 'type' property)
const userType = ref(authState.user?.typeUtilisateur || 'particulier')

const form = reactive({
  pseudonyme: authState.user?.pseudonyme || '',
  email: authState.user?.email || '',
  telephone: authState.user?.telephoneutilisateur || '',
  // Professional specific fields
  nomEntreprise: authState.user?.nomEntreprise || '',
  siret: authState.user?.siret || '',
  siteWeb: authState.user?.siteWeb || '',
})

const updateAccount = async () => {
  const userId = authState.user?.idutilisateur
  if (!userId) return

  isSaving.value = true
  message.value = { text: '', type: '' }

  try {
    // 2. Build the payload dynamically
    const payload = {
      idutilisateur: userId,
      pseudonyme: form.pseudonyme,
      email: form.email,
      telephoneutilisateur: form.telephone,
      motDePasse: authState.user.motDePasse, // Caution: backend usually expects a separate "change password" flow
    }

    // Add professional fields if applicable
    if (userType.value === 'professionnel') {
      payload.nomEntreprise = form.nomEntreprise
      payload.siret = form.siret
      payload.siteWeb = form.siteWeb
    }

    // 3. Choose the endpoint based on user type if your API is separated
    const endpoint =
      userType.value === 'professionnel'
        ? `/Professionnels/${userId}`
        : `/Utilisateurs/${userId}`

    const response = await api.put(endpoint, payload)

    const updatedUser = { ...authState.user, ...response.data }
    authState.setUser(updatedUser)

    message.value = { text: 'Modifications enregistrées !', type: 'success' }
  } catch (error) {
    console.error('Error:', error)
    message.value = { text: 'Erreur lors de la sauvegarde.', type: 'error' }
  } finally {
    isSaving.value = false
  }
}
</script>

<template>
  <div class="min-h-screen bg-[#f5f5f5] py-10">
    <div class="max-w-2xl mx-auto px-4">
      <div class="flex items-center justify-between mb-8">
        <h1 class="text-2xl font-black text-gray-900">Paramètres du compte</h1>
        <span
          class="px-3 py-1 rounded-full text-xs font-bold uppercase tracking-wider bg-orange-100 text-[#ea580c]"
        >
          {{ userType }}
        </span>
      </div>

      <div class="bg-white rounded-3xl p-8 shadow-sm border border-gray-100 space-y-6">
        <div
          v-if="message.text"
          :class="
            message.type === 'success' ? 'bg-green-50 text-green-700' : 'bg-red-50 text-red-700'
          "
          class="p-4 rounded-xl text-sm font-bold text-center transition-all"
        >
          {{ message.text }}
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
          <div>
            <label class="block text-sm font-bold mb-2">Pseudonyme</label>
            <input v-model="form.pseudonyme" type="text" class="input-style" />
          </div>
          <div>
            <label class="block text-sm font-bold mb-2">Téléphone</label>
            <input v-model="form.telephone" type="text" class="input-style" />
          </div>
        </div>

        <div>
          <label class="block text-sm font-bold mb-2">Adresse email</label>
          <input v-model="form.email" type="email" class="input-style" />
        </div>

        <div v-if="userType === 'professionnel'" class="pt-6 border-t border-gray-100 space-y-6">
          <h3 class="font-bold text-gray-400 uppercase text-xs">Informations Professionnelles</h3>

          <div>
            <label class="block text-sm font-bold mb-2">Nom de l'entreprise</label>
            <input v-model="form.nomEntreprise" type="text" class="input-style" />
          </div>

          <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div>
              <label class="block text-sm font-bold mb-2">SIRET</label>
              <input v-model="form.siret" type="text" class="input-style" />
            </div>
          </div>
        </div>

        <button
          @click="updateAccount"
          :disabled="isSaving"
          class="w-full bg-[#ea580c] text-white font-bold py-4 rounded-2xl transition-all hover:bg-[#c2410c] disabled:opacity-50 shadow-lg shadow-orange-100"
        >
          {{ isSaving ? 'Chargement...' : 'Enregistrer les modifications' }}
        </button>
      </div>
    </div>
  </div>
</template>
