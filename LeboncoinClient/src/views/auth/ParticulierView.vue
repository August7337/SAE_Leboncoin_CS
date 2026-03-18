<template>
  <div v-if="loginSuccess" class="fixed inset-0 flex items-center justify-center bg-white/95 z-50">
      <div class="text-center">
        <div class="w-20 h-20 bg-orange-100 rounded-full flex items-center justify-center mx-auto mb-4 animate-pulse">
          <svg xmlns="http://www.w3.org/2000/svg" class="h-10 w-10 text-[#ea580c]" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M5 13l4 4L19 7" />
          </svg>
        </div>
        <h2 class="text-2xl font-bold text-gray-900">Bienvenue, {{ authState.user?.pseudonyme }} !</h2>
        <p class="text-gray-500 mt-2">Votre compte particulier est prêt.</p>
      </div>
    </div>
    <div class="register-container relative"><button type="button" class="back-arrow-btn" @click="goBack" title="Retour à l'étape 1">
      <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18" />
      </svg>
    </button>
      <h1>Finalisez votre profil</h1>
      <h2 style="margin-bottom: 4%;">Etape 2/2 (Particulier)</h2>

      <form @submit.prevent="submitFinal">
        <div class="field">
          <label>Civilité</label>
          <select v-model="particulierForm.civilite">
            <option value="M.">Monsieur</option>
            <option value="Mme">Madame</option>
            <option value="Autre">Autre</option>
          </select>
        </div>
  
        <div class="field">
  <label>Nom</label>
  <input v-model="particulierForm.nom" type="text" :class="{ 'error': errors.nom }" />
  <span v-if="errors.nom" class="error-text">{{ errors.nom }}</span>
</div>

<div class="field">
  <label>Prénom</label>
  <input v-model="particulierForm.prenom" type="text" :class="{ 'error': errors.prenom }" />
  <span v-if="errors.prenom" class="error-text">{{ errors.prenom }}</span>
</div>

<div class="field">
  <label>Date de naissance</label>
  <input v-model="particulierForm.dateNaissance" type="date" :class="{ 'error': errors.dateNaissance }" />
  <span v-if="errors.dateNaissance" class="error-text">{{ errors.dateNaissance }}</span>
</div>
  
        <button type="submit">Créer mon compte particulier</button>
      </form>
  
      <div v-if="dataFromStep1" class="debug-info">
        <p>Bienvenue {{ dataFromStep1.pseudonyme }} !</p>
      </div>
    </div>
  </template>
  
  <script setup>
import { onMounted, reactive, ref } from 'vue'
import { useRouter } from 'vue-router'
import axios from 'axios'
import { authState } from '@/auth' 

const router = useRouter()
const dataFromStep1 = ref(null)
const loginSuccess = ref(false) 

const particulierForm = reactive({
  nom: "",
  prenom: "",
  civilite: "M.",
  dateNaissance: ""
})

const errors = reactive({
  nom: "",
  prenom: "",
  dateNaissance: ""
})

// --- FIX 1: Recovery of Step 1 data ---
onMounted(() => {
  const savedDraft = sessionStorage.getItem('registration_draft');
  if (savedDraft) {
    dataFromStep1.value = JSON.parse(savedDraft);
    // Pre-fill Step 2 if user came back from a phone error
    const data = dataFromStep1.value;
    if (data.nomutilisateur) particulierForm.nom = data.nomutilisateur;
    if (data.prenomutilisateur) particulierForm.prenom = data.prenomutilisateur;
    if (data.civilite) particulierForm.civilite = data.civilite;
    if (data.dateNaissance) particulierForm.dateNaissance = data.dateNaissance;
  } else if (window.history.state?.payload) {
    dataFromStep1.value = window.history.state.payload;
  }
});

const goBack = () => {
  const fullData = { ...dataFromStep1.value, ...particulierForm };
  sessionStorage.setItem('registration_draft', JSON.stringify(fullData));
  router.push({ name: 'register' });
};


const validateParticulier = () => {

  Object.keys(errors).forEach(key => errors[key] = "")
  let isValid = true

  
  if (!particulierForm.nom.trim()) {
    errors.nom = "Le nom est obligatoire."
    isValid = false
  }
  if (!particulierForm.prenom.trim()) {
    errors.prenom = "Le prénom est obligatoire."
    isValid = false
  }

 
  if (!particulierForm.dateNaissance) {
    errors.dateNaissance = "La date de naissance est requise."
    isValid = false
  } else {
    const birthDate = new Date(particulierForm.dateNaissance)
    const today = new Date()
    
   
    let age = today.getFullYear() - birthDate.getFullYear()
    const m = today.getMonth() - birthDate.getMonth()
    
    
    if (m < 0 || (m === 0 && today.getDate() < birthDate.getDate())) {
      age--
    }

    if (age < 18) {
      errors.dateNaissance = "Vous devez avoir au moins 18 ans pour vous inscrire."
      isValid = false
    }
  }
  
  return isValid
}

const submitFinal = async () => {
  if (!validateParticulier()) return

  const userStep1 = dataFromStep1.value || {};
  const payload = { 
    pseudonyme: userStep1.pseudonyme, 
    email: userStep1.email, 
    password: userStep1.password, 
    telephoneutilisateur: userStep1.telephoneutilisateur || userStep1.telephoneUtilisateur || "", 
    rue: userStep1.rue || userStep1.adresseUtilisateur?.rue || userStep1.rue || "", 
    ville: userStep1.ville || userStep1.adresseUtilisateur?.ville || userStep1.ville || "", 
    codePostal: userStep1.codePostal || userStep1.adresseUtilisateur?.codePostal || userStep1.codePostal || "", 
    nomutilisateur: particulierForm.nom, 
    prenomutilisateur: particulierForm.prenom, 
    civilite: particulierForm.civilite, 
    dateNaissance: particulierForm.dateNaissance 
  };

  try {
    const res = await axios.post("https://localhost:7057/api/Utilisateurs/register-particulier", payload);
    
    if (res.data.user || res.status === 200) {
      sessionStorage.removeItem('registration_draft');
authState.user = res.data.user;
authState.isAuthenticated = true;
if (res.data.token) {
  localStorage.setItem('user_token', res.data.token);
}
loginSuccess.value = true;
setTimeout(() => {
  router.push({ name: 'home' });
}, 1500);
    }
  } catch (error) {
    if (error.response && error.response.status === 409) {
      const { target, message } = error.response.data;
      
      
      const step1Fields = ['email', 'telephoneutilisateur', 'telephoneUtilisateur', 'pseudonyme'];
      const isStep1Error = step1Fields.includes(target.toLowerCase()) || step1Fields.includes(target);

      if (isStep1Error) {
        sessionStorage.setItem('registration_draft', JSON.stringify(payload));
        router.push({ 
          name: 'register', 
          state: { externalErrors: { [target]: message } } 
        });
      } else {
        errors[target] = message;
      }
    } else {
      alert("Erreur critique : " + (error.response?.data?.message || "Serveur injoignable"));
    }
  }
};
</script>
  
  <style src="../../assets/register.css" scoped>

  </style>