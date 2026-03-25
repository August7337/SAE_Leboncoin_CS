<template>
  <div class="register-container">
    <div v-if="loginSuccess" class="fixed inset-0 flex items-center justify-center bg-white/95 z-50 transition-opacity">
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

    <h1 style="font-weight: bold; font-size: large">Créer un compte</h1>
    <h2 style="margin-bottom: 4%;">Etape 1/2</h2>

    <form @submit.prevent="register">
      <div class="field">
        <label>Pseudonyme</label>
        <input v-model="form.pseudonyme" type="text" :class="{ 'error': errors.pseudonyme }" />
        <span v-if="errors.pseudonyme" class="error-text">{{ errors.pseudonyme }}</span>
      </div>

      <div class="field">
        <label>Email</label>
        <input v-model="form.email" type="text" :class="{ 'error': errors.email }" placeholder="exemple@mail.com" />
        <span v-if="errors.email" class="error-text">{{ errors.email }}</span>
      </div>

      <div class="field">
        <label>Téléphone</label>
        <input v-model="form.telephoneUtilisateur" type="text" :class="{ 'error': errors.telephoneUtilisateur }" placeholder="0612345678"/>
        <span v-if="errors.telephoneUtilisateur" class="error-text">{{ errors.telephoneUtilisateur }}</span>
      </div>

      <div class="field relative">
        <label>Rue et numéro</label>
        <input 
          v-model="form.adresseUtilisateur.rue" 
          @input="fetchAutocomplete"
          @blur="closeSuggestions"
          type="text" 
          placeholder="Commencez à taper votre adresse..." 
          class="w-full"
          :class="{ 'error': errors.adresseUtilisateur }"
        />

        <ul v-if="showSuggestions && suggestions.length" class="absolute z-50 w-full bg-white border border-gray-200 rounded-xl mt-1 shadow-xl max-h-60 overflow-auto">
      <li 
        v-for="(s, index) in suggestions" 
        :key="index"
        @click="selectSuggestion(s)"
        class="px-4 py-3 hover:bg-orange-50 cursor-pointer border-b last:border-b-0 text-sm"
      >
        <span class="font-bold">{{ s.properties.formatted }}</span>
      </li>
    </ul>
      </div>

      <div class="grid grid-cols-2 gap-4 mb-4">
        <div class="field">
          <label>Code Postal</label>
          <input v-model="form.adresseUtilisateur.codePostal" type="text" placeholder="75001" />
        </div>
        <div class="field">
          <label>Ville</label>
          <input v-model="form.adresseUtilisateur.ville" type="text" placeholder="Paris" />
        </div>
      </div>

      <div class="field">
        <label>Mot de passe</label>
        <div class="password-wrapper">
          <input v-model="form.password" :type="showPassword ? 'text' : 'password'" :class="{ 'error': errors.password }" />
          <button type="button" class="toggle-btn" @click="showPassword = !showPassword">
            {{ showPassword ? 'Masquer' : 'Afficher' }}
          </button>
        </div>
        <span v-if="errors.password" class="error-text">{{ errors.password }}</span>
      </div>

      <div class="field">
        <label>Confirmer le mot de passe</label>
        <div class="password-wrapper">
          <input v-model="form.passwordConfirm" :type="showPasswordConfirm ? 'text' : 'password'" :class="{ 'error': errors.passwordConfirm }" />
          <button type="button" class="toggle-btn" @click="showPasswordConfirm = !showPasswordConfirm">
            {{ showPasswordConfirm ? 'Masquer' : 'Afficher' }}
          </button>
        </div>
        <span v-if="errors.passwordConfirm" class="error-text">{{ errors.passwordConfirm }}</span>
      </div>

      <div class="field">
        <label>Type de compte</label>
        <div class="account-selector">
          <button type="button" :class="{ 'active': typeUtilisateur === 'particulier' }" @click="typeUtilisateur = 'particulier'">
            Particulier
          </button>
          <button type="button" :class="{ 'active': typeUtilisateur === 'professionnel' }" @click="typeUtilisateur = 'professionnel'">
            Professionnel
          </button>
        </div>
      </div>

      <button type="submit" class="submit-btn">Continuer</button>
    </form>

    <p class="success" v-if="successMessage">{{ successMessage }}</p>
    <p class="error" v-if="apiError">{{ apiError }}</p>
  </div>
</template>

<script setup>
import { reactive, ref, onMounted } from "vue"
import { useRouter, useRoute } from "vue-router"
import { authState } from '@/auth.js'
import axios from 'axios'
const router = useRouter()
const route = useRoute()


const loginSuccess = ref(false)
const successMessage = ref("")
const apiError = ref("")
const showPassword = ref(false)
const showPasswordConfirm = ref(false)
const typeUtilisateur = ref('particulier')
const suggestions = ref([]);
const showSuggestions = ref(false);

const closeSuggestions = () => {
  
  setTimeout(() => {
    showSuggestions.value = false;
  }, 200);
};
const fetchAutocomplete = async () => {
  if (form.adresseUtilisateur.rue.length < 3) {
    suggestions.value = [];
    return;
  }

  try {
    const apiKey = 'd1f65bc8100b4c868d082eb1f125364e';
    const response = await axios.get(`https://api.geoapify.com/v1/geocode/autocomplete`, {
      params: {
        text: form.adresseUtilisateur.rue,
        apiKey: apiKey,
        lang: 'fr',
        filter: 'countrycode:fr' 
      }
    });
    suggestions.value = response.data.features;
    showSuggestions.value = true;
  } catch (error) {
    console.error("Error fetching autocomplete:", error);
  }
};

const selectSuggestion = (suggestion) => {
  const props = suggestion.properties;
  form.adresseUtilisateur.rue = props.housenumber ? `${props.housenumber} ${props.street}` : props.street || props.name;
  form.adresseUtilisateur.ville = props.city || props.town || '';
  form.adresseUtilisateur.codePostal = props.postcode || '';
  
  showSuggestions.value = false;
  suggestions.value = [];
};


const form = reactive({
  pseudonyme: "",
  email: "",
  telephoneUtilisateur: "",
  adresseUtilisateur: { rue: "", ville: "", codePostal: "" },
  password: "",
  passwordConfirm: ""
})

const errors = reactive({
  pseudonyme: "",
  email: "",
  telephoneUtilisateur: "",
  adresseUtilisateur: "",
  password: "",
  passwordConfirm: ""
})

onMounted(() => {

  const savedDraft = sessionStorage.getItem('registration_draft');
  if (savedDraft) {
    const data = JSON.parse(savedDraft);
    form.pseudonyme = data.pseudonyme || "";
    form.email = data.email || "";
    form.telephoneUtilisateur = data.telephoneutilisateur || data.telephoneUtilisateur || "";
    form.password = data.password || "";
    form.passwordConfirm = data.passwordConfirm || data.password || "";
    

    form.adresseUtilisateur.rue = data.rue || data.adresseUtilisateur?.rue || "";
    form.adresseUtilisateur.ville = data.ville || data.adresseUtilisateur?.ville || "";
    form.adresseUtilisateur.codePostal = data.codePostal || data.adresseUtilisateur?.codePostal || "";
    
    if (data.typeUtilisateur) typeUtilisateur.value = data.typeUtilisateur;
  }


  if (route.query.email) {
    form.email = route.query.email;
  }

  
  if (window.history.state && window.history.state.externalErrors) {
    const incoming = window.history.state.externalErrors;
    if (incoming.email) errors.email = incoming.email;
    if (incoming.pseudonyme) errors.pseudonyme = incoming.pseudonyme;
    if (incoming.telephoneutilisateur || incoming.telephoneUtilisateur) {
      errors.telephoneUtilisateur = incoming.telephoneutilisateur || incoming.telephoneUtilisateur;
    }
  }
});

const validate = () => {

  Object.keys(errors).forEach(key => errors[key] = "")
  let valid = true

  if (!form.pseudonyme.trim()) { 
    errors.pseudonyme = "Le pseudonyme est requis."; 
    valid = false; 
  }

  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
  if (!emailRegex.test(form.email)) { 
    errors.email = "Email invalide."; 
    valid = false; 
  }

  const cleanPhone = form.telephoneUtilisateur.replace(/[\s.-]/g, "");
  if (!/^\d{10}$/.test(cleanPhone)) { 
    errors.telephoneUtilisateur = "10 chiffres requis."; 
    valid = false; 
  }

  if (form.password.length < 6) { 
    errors.password = "Minimum 6 caractères."; 
    valid = false; 
  }

  if (form.password !== form.passwordConfirm) { 
    errors.passwordConfirm = "Mots de passe différents."; 
    valid = false; 
  }

  return valid
}

const register = () => {
  if (!validate()) return

  const cleanPhone = form.telephoneUtilisateur.replace(/[\s.-]/g, "");
  

  const payload = {
    pseudonyme: form.pseudonyme,
    email: form.email,
    telephoneutilisateur: cleanPhone,
    password: form.password,
    passwordConfirm: form.passwordConfirm,
    rue: form.adresseUtilisateur.rue,
    ville: form.adresseUtilisateur.ville,
    codePostal: form.adresseUtilisateur.codePostal,
    typeUtilisateur: typeUtilisateur.value 
  }

  
  const existingDraft = JSON.parse(sessionStorage.getItem('registration_draft') || '{}');
  const mergedDraft = { ...existingDraft, ...payload };
  sessionStorage.setItem('registration_draft', JSON.stringify(mergedDraft));
  

  router.push({ name: typeUtilisateur.value, state: { payload: mergedDraft } });
}
</script>

<style src="../../assets/register.css" scoped></style>