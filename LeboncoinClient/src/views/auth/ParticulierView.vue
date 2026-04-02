<template>
  <div class="register-container relative">
    <div v-if="registrationSuccess" class="fixed inset-0 flex items-center justify-center bg-white/95 z-50 transition-opacity">
      <div class="text-center">
        <div class="w-20 h-20 bg-orange-100 rounded-full flex items-center justify-center mx-auto mb-4 animate-pulse">
          <svg xmlns="http://www.w3.org/2000/svg" class="h-10 w-10 text-[#ea580c]" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M5 13l4 4L19 7" />
          </svg>
        </div>
        <h2 class="text-2xl font-bold text-gray-900">Bienvenue, {{ authState.user?.pseudonyme }} !</h2>
        <p class="text-gray-500 mt-2">Votre compte a été créé avec succès.</p>
      </div>
    </div>

    <button type="button" class="back-arrow-btn" @click="goBack">
      <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18" />
      </svg>
    </button>

    <h1 style="font-weight: bold; font-size: large">Finalisez votre profil</h1>
    <h2 style="margin-bottom: 4%;">Etape 2/2 (Particulier)</h2>

    <form @submit.prevent="submitFinal">
      <div class="field">
        <label>Civilité</label>
        <div class="account-selector flex gap-2">
          <button 
            type="button" 
            :class="{ 'active': form.civilite === 'M.' }" 
            @click="form.civilite = 'M.'"
            class="flex-1 py-3 border rounded-xl"
          >Monsieur</button>
          <button 
            type="button" 
            :class="{ 'active': form.civilite === 'Mme' }" 
            @click="form.civilite = 'Mme'"
            class="flex-1 py-3 border rounded-xl"
          >Madame</button>
        </div>
        <span v-if="errors.civilite" class="error-text text-red-500 text-xs">{{ errors.civilite }}</span>
      </div>

      <div class="field">
        <label for="prenom">Prénom</label>
        <input id="prenom" v-model="form.prenomutilisateur" type="text" :class="{ 'error': errors.prenomutilisateur }" />
        <span v-if="errors.prenomutilisateur" class="error-text text-red-500 text-xs">{{ errors.prenomutilisateur }}</span>
      </div>

      <div class="field">
        <label for="nom">Nom</label>
        <input id="nom" v-model="form.nomutilisateur" type="text" :class="{ 'error': errors.nomutilisateur }" />
        <span v-if="errors.nomutilisateur" class="error-text text-red-500 text-xs">{{ errors.nomutilisateur }}</span>
      </div>

      <div class="field">
        <label for="dob">Date de naissance</label>
        <input id="dob" v-model="form.dateNaissance" type="date" :class="{ 'error': errors.dateNaissance }" />
        <span v-if="errors.dateNaissance" class="error-text text-red-500 text-xs">{{ errors.dateNaissance }}</span>
      </div>

      <button type="submit" :disabled="isSubmitting" class="submit-btn bg-[#ea580c] text-white w-full py-4 rounded-xl font-bold mt-4">
        {{ isSubmitting ? 'Création en cours...' : 'Créer mon compte' }}
      </button>
    </form>

    <p class="error text-red-500 text-center mt-4" v-if="apiError">{{ apiError }}</p>
  </div>
</template>

<script setup>
import { reactive, ref, onMounted } from "vue"
import { useRouter } from "vue-router"
import { authState } from '@/auth.js'
import api from '@/api/axios'

const router = useRouter()
const registrationSuccess = ref(false)
const isSubmitting = ref(false)
const apiError = ref("")
const dataFromStep1 = ref(null)

const form = reactive({
  nomutilisateur: "",
  prenomutilisateur: "",
  civilite: "M.",
  dateNaissance: ""
})

const errors = reactive({
  nomutilisateur: "",
  prenomutilisateur: "",
  civilite: "",
  dateNaissance: ""
})

onMounted(() => {
  const savedDraft = sessionStorage.getItem('registration_draft')
  const draft = savedDraft ? JSON.parse(savedDraft) : (window.history.state?.payload || null)
  
  if (draft) {
    dataFromStep1.value = draft
    // Pre-fill Step 2 fields if they exist in the draft
    if (draft.nomutilisateur) form.nomutilisateur = draft.nomutilisateur
    if (draft.prenomutilisateur) form.prenomutilisateur = draft.prenomutilisateur
    if (draft.civilite) form.civilite = draft.civilite
    if (draft.dateNaissance) form.dateNaissance = draft.dateNaissance
  } else {
    // No data from step 1, go back
    router.push({ name: 'register' })
  }
})

const goBack = () => {
  router.push({ name: 'register' })
}

const validate = () => {
  Object.keys(errors).forEach(key => errors[key] = "")
  let valid = true

  if (!form.nomutilisateur.trim()) { errors.nomutilisateur = "Requis."; valid = false; }
  if (!form.prenomutilisateur.trim()) { errors.prenomutilisateur = "Requis."; valid = false; }
  
  if (!form.dateNaissance) { 
    errors.dateNaissance = "Requis."; 
    valid = false; 
  } else {
    // Check if at least 18 years old
    const birthDate = new Date(form.dateNaissance)
    const today = new Date()
    let age = today.getFullYear() - birthDate.getFullYear()
    const m = today.getMonth() - birthDate.getMonth()
    if (m < 0 || (m === 0 && today.getDate() < birthDate.getDate())) {
      age--
    }
    
    if (age < 18) {
      errors.dateNaissance = "Vous devez avoir au moins 18 ans.";
      valid = false;
    }
  }

  return valid
}

const submitFinal = async () => {
  if (!validate()) return
  isSubmitting.value = true
  apiError.value = ""

  try {
    const fullPayload = {
      ...dataFromStep1.value,
      ...form
    }

    // Adapt payload to match backend DTO (RegisterParticulierDTO)
    // Removed passwordConfirm and typeUtilisateur which are usually not in the base DTO
    const { passwordConfirm, typeUtilisateur, ...apiPayload } = fullPayload

    const response = await api.post('/Utilisateurs/register-particulier', apiPayload)
    
    // Cleanup draft
    sessionStorage.removeItem('registration_draft')

    // If API returns token + user, log in immediately
    if (response.data && response.data.Token) {
      authState.login(response.data)
    }

    registrationSuccess.value = true
    setTimeout(() => {
      router.push({ name: 'home' })
    }, 1500)

  } catch (error) {
    if (error.response && error.response.status === 409) {
      const { target, message } = error.response.data
      const isStep1Error = ['email', 'telephoneutilisateur', 'pseudonyme'].includes(target)
      
      if (isStep1Error) {
        router.push({ 
          name: 'register', 
          state: { externalErrors: { [target]: message } } 
        })
      } else {
        // Step 2 error: show inline
        errors[target] = message
      }
    } else {
      apiError.value = error.response?.data?.message || "Une erreur est survenue lors de l'inscription."
    }
  } finally {
    isSubmitting.value = false
  }
}
</script>

<style src="../../assets/register.css" scoped></style>
<style scoped>
.account-selector button {
  background: white;
  transition: all 0.2s;
}
.account-selector button.active {
  background: #fff7ed;
  border-color: #ea580c;
  color: #ea580c;
  font-weight: bold;
}
.back-arrow-btn {
  position: absolute;
  top: 1.5rem;
  left: 1rem;
  padding: 0.5rem;
  border-radius: 9999px;
  color: #64748b;
  transition: all 0.2s;
}
.back-arrow-btn:hover {
  background-color: #f1f5f9;
  color: #0f172a;
}
</style>