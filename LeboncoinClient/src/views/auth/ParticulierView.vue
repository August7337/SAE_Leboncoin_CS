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
        <label for="pseudonyme">Pseudonyme</label>
        <input 
          id="pseudonyme"
          v-model="form.pseudonyme" 
          type="text" 
          :class="{ 'error': errors.pseudonyme, 'valid': !errors.pseudonyme && form.pseudonyme.trim() }" 
        />
        <span v-if="errors.pseudonyme" class="error-text">{{ errors.pseudonyme }}</span>
      </div>

      <div class="field">
        <label for="email">Email</label>
        <input 
          id="email"
          v-model="form.email" 
          type="text" 
          :class="{ 'error': errors.email, 'valid': !errors.email && /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(form.email) }" 
          placeholder="exemple@mail.com" 
        />
        <span v-if="errors.email" class="error-text">{{ errors.email }}</span>
      </div>

      <div class="field">
        <label for="telephone">Téléphone</label>
        <input 
          id="telephone"
          v-model="form.telephoneUtilisateur" 
          type="text" 
          inputmode="numeric" 
          maxlength="14" 
          @input="formatTelephone" 
          @blur="checkPhoneAvailability" 
          :class="{ 'error': errors.telephoneUtilisateur || phoneCheckError, 'valid': phoneAvailable }" 
          placeholder="06 12 34 56 78"
        />
        <span v-if="errors.telephoneUtilisateur" class="error-text">{{ errors.telephoneUtilisateur }}</span>
        <span v-else-if="phoneCheckError" class="error-text">{{ phoneCheckError }}</span>
      </div>

      <div class="field">
        <label for="adresse">Numéro et rue</label>
        <div class="relative" style="width:100%">
          <input 
            id="adresse"
            v-model="form.adresseUtilisateur.rue" 
            @input="fetchAutocomplete"
            @blur="closeSuggestions"
            type="text" 
            placeholder="Écrivez votre adresse et sélectionnez une suggestion"
            :readonly="addressSelected"
            :class="{ 
              'error': errors.adresseUtilisateur, 
              'valid': addressSelected && !errors.adresseUtilisateur, 
              'bg-gray-50 cursor-default': addressSelected, 
              'address-input-with-clear': addressSelected 
            }"
          />
          <button
            v-if="addressSelected"
            type="button"
            @click="clearAddress"
            class="clear-address-btn"
            title="Modifier l'adresse"
          >&times;</button>

          <ul v-if="showSuggestions && suggestions.length" class="absolute z-50 w-full bg-white border border-gray-200 rounded-xl mt-1 shadow-xl max-h-60 overflow-auto">
            <li 
              v-for="(s, index) in suggestions" 
              :key="index"
              @mousedown="selectSuggestion(s)"
              class="px-4 py-3 hover:bg-orange-50 cursor-pointer border-b last:border-b-0 text-sm"
            >
              <span class="font-bold">{{ s.properties.formatted }}</span>
            </li>
          </ul>
        </div>
        <span v-if="errors.adresseUtilisateur" class="error-text">{{ errors.adresseUtilisateur }}</span>
      </div>

      <div class="grid grid-cols-2 gap-4 mb-4">
        <div class="field">
          <label for="codePostal">Code Postal</label>
          <input 
            id="codePostal"
            v-model="form.adresseUtilisateur.codePostal" 
            type="text" 
            placeholder="75001" 
            :readonly="addressSelected" 
            :class="{ 'bg-gray-50 cursor-default': addressSelected, 'valid': addressSelected }" 
          />
        </div>
        <div class="field">
          <label for="ville">Ville</label>
          <input 
            id="ville"
            v-model="form.adresseUtilisateur.ville" 
            type="text" 
            placeholder="Paris" 
            :readonly="addressSelected" 
            :class="{ 'bg-gray-50 cursor-default': addressSelected, 'valid': addressSelected }" 
          />
        </div>
      </div>

      <div class="field">
        <label for="password">Mot de passe</label>
        <div class="password-wrapper">
          <input 
            id="password"
            v-model="form.password" 
            :type="showPassword ? 'text' : 'password'" 
            :class="{ 'error': errors.password, 'valid': !errors.password && form.password.length >= 6 }" 
          />
          <button type="button" class="toggle-btn" @click="showPassword = !showPassword">
            {{ showPassword ? 'Masquer' : 'Afficher' }}
          </button>
        </div>
        <span v-if="errors.password" class="error-text">{{ errors.password }}</span>
      </div>

      <div class="field">
        <label for="passwordConfirm">Confirmer le mot de passe</label>
        <div class="password-wrapper">
          <input 
            id="passwordConfirm"
            v-model="form.passwordConfirm" 
            :type="showPasswordConfirm ? 'text' : 'password'" 
            :class="{ 'error': errors.passwordConfirm, 'valid': !errors.passwordConfirm && form.passwordConfirm.length >= 6 && form.passwordConfirm === form.password }" 
          />
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
import api from '@/api/axios'
import axios from 'axios'

const router = useRouter()
const route = useRoute()

// UI State
const loginSuccess = ref(false)
const successMessage = ref("")
const apiError = ref("")
const showPassword = ref(false)
const showPasswordConfirm = ref(false)
const typeUtilisateur = ref('particulier')

// Address Logic State
const suggestions = ref([]);
const showSuggestions = ref(false);
const addressSelected = ref(false);

// Phone Logic State
const phoneCheckError = ref('');
const phoneAvailable = ref(false);

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

// --- Logic Methods ---

const checkPhoneAvailability = async () => {
  phoneCheckError.value = '';
  phoneAvailable.value = false;
  const digits = form.telephoneUtilisateur.replace(/\D/g, '');
  if (digits.length !== 10) return;
  try {
    const res = await api.get('/Utilisateurs/check-phone', { params: { phone: digits } });
    if (!res.data.available) {
      phoneCheckError.value = 'Numéro de téléphone déjà affilié à un compte.';
    } else {
      phoneAvailable.value = true;
    }
  } catch { /* silently ignore */ }
};

const closeSuggestions = () => {
  setTimeout(() => {
    showSuggestions.value = false;
  }, 200);
};

const formatTelephone = (event) => {
  phoneCheckError.value = '';
  phoneAvailable.value = false;
  const input = event.target;
  const cursorPos = input.selectionStart;
  const digits = input.value.replace(/\D/g, '').substring(0, 10);

  let formatted = '';
  for (let i = 0; i < digits.length; i++) {
    if (i > 0 && i % 2 === 0) formatted += ' ';
    formatted += digits[i];
  }

  form.telephoneUtilisateur = formatted;
  adjustCursor(input, cursorPos, input.value, formatted);
};

const adjustCursor = (input, oldCursor, oldValue, newValue) => {
  const digitsBeforeCursor = oldValue.substring(0, oldCursor).replace(/\D/g, '').length;
  let newCursor = 0;
  let count = 0;
  for (let i = 0; i < newValue.length; i++) {
    if (newValue[i] !== ' ') count++;
    if (count === digitsBeforeCursor) { newCursor = i + 1; break; }
    newCursor = i + 1;
  }
  requestAnimationFrame(() => {
    input.setSelectionRange(newCursor, newCursor);
  });
};

const fetchAutocomplete = async () => {
  if (addressSelected.value) return;
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
  addressSelected.value = true;
};

const clearAddress = () => {
  form.adresseUtilisateur.rue = '';
  form.adresseUtilisateur.ville = '';
  form.adresseUtilisateur.codePostal = '';
  addressSelected.value = false;
  suggestions.value = [];
  showSuggestions.value = false;
};

onMounted(() => {
  const hasExternalErrors = window.history.state && window.history.state.externalErrors;
  const savedDraft = sessionStorage.getItem('registration_draft');
  const draft = savedDraft ? JSON.parse(savedDraft) : null;

  const shouldRestore = hasExternalErrors || (draft && draft.typeUtilisateur);

  if (shouldRestore && draft) {
    form.pseudonyme = draft.pseudonyme || "";
    form.email = draft.email || "";
    form.telephoneUtilisateur = draft.telephoneutilisateur || draft.telephoneUtilisateur || "";
    form.password = draft.password || "";
    form.passwordConfirm = draft.passwordConfirm || draft.password || "";

    form.adresseUtilisateur.rue = draft.rue || draft.adresseUtilisateur?.rue || "";
    form.adresseUtilisateur.ville = draft.ville || draft.adresseUtilisateur?.ville || "";
    form.adresseUtilisateur.codePostal = draft.codePostal || draft.adresseUtilisateur?.codePostal || "";
    if (draft.rue || draft.adresseUtilisateur?.rue) addressSelected.value = true;

    if (draft.typeUtilisateur) typeUtilisateur.value = draft.typeUtilisateur;
  }

  if (hasExternalErrors) {
    const incoming = hasExternalErrors;
    if (incoming.email) errors.email = incoming.email;
    if (incoming.pseudonyme) errors.pseudonyme = incoming.pseudonyme;
    if (incoming.telephoneutilisateur || incoming.telephoneUtilisateur) {
      errors.telephoneUtilisateur = incoming.telephoneutilisateur || incoming.telephoneUtilisateur;
    }
  }

  if (!shouldRestore) {
    sessionStorage.removeItem('registration_draft');
  }

  if (route.query.email) {
    form.email = route.query.email;
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

  if (!addressSelected.value) {
    errors.adresseUtilisateur = "Veuillez sélectionner une adresse dans les suggestions.";
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