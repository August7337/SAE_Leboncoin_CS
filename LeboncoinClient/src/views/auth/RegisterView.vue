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


    <h1>Créer un compte</h1>

    <form @submit.prevent="register">
      <div class="field">
        <label>Pseudonyme</label>
        <input v-model="form.pseudonyme" type="text" />
        <span v-if="errors.pseudonyme">{{ errors.pseudonyme }}</span>
      </div>

<div class="field">
  <label>Email</label>
  <input 
    v-model="form.email" 
    type="text" 
    :class="{ 'error': errors.email }"
    placeholder="exemple@mail.com"
  />
  <span v-if="errors.email" class="error-text">{{ errors.email }}</span>
</div>

      <div class="field">
        <label>Téléphone</label>
        <input v-model="form.telephoneUtilisateur" type="text" placeholder="0612345678"/>
        <span v-if="errors.telephoneUtilisateur">{{ errors.telephoneUtilisateur }}</span>
      </div>

      <div class="field">
        <label>Adresse</label>
        <input v-model="form.adresseUtilisateur.rue" type="text" placeholder="Rue"/>
        <input v-model="form.adresseUtilisateur.ville" type="text" placeholder="Ville"/>
        <input v-model="form.adresseUtilisateur.codePostal" type="text" placeholder="Code postal"/>
        <span v-if="errors.adresseUtilisateur">{{ errors.adresseUtilisateur }}</span>
      </div>

<div class="field">
  <label>Mot de passe</label>
  <div class="password-wrapper">
    <input 
      v-model="form.password" 
      :type="showPassword ? 'text' : 'password'" 
      :class="{ 'error': errors.password }"
    />
    <button type="button" class="toggle-btn" @click="showPassword = !showPassword">
      {{ showPassword ? 'Masquer' : 'Afficher' }}
    </button>
  </div>
  <span v-if="errors.password">{{ errors.password }}</span>
</div>

<div class="field">
  <label>Confirmer le mot de passe</label>
  <div class="password-wrapper">
    <input 
      v-model="form.passwordConfirm" 
      :type="showPasswordConfirm ? 'text' : 'password'" 
      :class="{ 'error': errors.passwordConfirm }"
    />
    <button type="button" class="toggle-btn" @click="showPasswordConfirm = !showPasswordConfirm">
      {{ showPasswordConfirm ? 'Masquer' : 'Afficher' }}
    </button>
  </div>
  <span v-if="errors.passwordConfirm">{{ errors.passwordConfirm }}</span>
</div>

      <button type="submit">S'inscrire</button>
    </form>

    <p class="success" v-if="successMessage">{{ successMessage }}</p>
    <p class="error" v-if="apiError">{{ apiError }}</p>
  </div>
</template>

<script setup>
import { reactive, ref, onMounted } from "vue"
import { useRoute,useRouter } from "vue-router"
import axios from "axios"
import { authState } from '@/auth.js'


const showPassword = ref(false)
const showPasswordConfirm = ref(false)
const loginSuccess = ref(false)
const route = useRoute()
const router = useRouter()
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

const successMessage = ref("")
const apiError = ref("")

onMounted(() => {
  if (route.query.email) {
    form.email = route.query.email
  }
})

const validate = () => {
  Object.keys(errors).forEach(key => errors[key] = "")
  let valid = true

  if (!form.pseudonyme) { errors.pseudonyme = "Le pseudonyme est requis"; valid = false; }
  const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  if (!form.email) { 
    errors.email = "Email requis"; 
    valid = false; 
  } else if (!emailPattern.test(form.email)) {
    errors.email = "Format email invalide (ex: nom@domaine.com)";
    valid = false;
  }
  
const rawPhone = form.telephoneUtilisateur.replace(/[\s.-]/g, ""); 
  const phonePattern = /^0[1-9]\d{8}$/;
  
  if (!form.telephoneUtilisateur) {
    errors.telephoneUtilisateur = "Téléphone requis";
    valid = false;
  } else if (!phonePattern.test(rawPhone)) {
    errors.telephoneUtilisateur = "Format invalide (ex: 0612345678)";
    valid = false;
  }

  if (!form.adresseUtilisateur.rue || !form.adresseUtilisateur.ville || !form.adresseUtilisateur.codePostal) {
    errors.adresseUtilisateur = "Adresse complète requise"
    valid = false
  }
  if (!form.adresseUtilisateur.codePostal || !/^\d{5}$/.test(form.adresseUtilisateur.codePostal)) {
  errors.adresseUtilisateur = "Le code postal doit contenir exactement 5 chiffres"
  valid = false
}

  const pwdRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{12,}$/
  if (!form.password || !pwdRegex.test(form.password)) {
    errors.password = "Le mot de passe doit contenir au moins 12 caractères, une majuscule, une minuscule, un chiffre et un caractère spécial."
    valid = false
  }

  if (form.password !== form.passwordConfirm) {
    errors.passwordConfirm = "Les mots de passe ne correspondent pas"
    valid = false
  }

  return valid
}


const register = async () => {
  if (!validate()) return

  try { 
    const cleanPhone = form.telephoneUtilisateur.replace(/[\s.-]/g, "");
    const cp = form.adresseUtilisateur.codePostal;
    const depCodeRaw = cp.substring(0, 2);
    const depKey = depCodeRaw.startsWith('0') ? depCodeRaw.substring(1) : depCodeRaw;

    const payload = {
      pseudonyme: form.pseudonyme,
      email: form.email,
      telephoneutilisateur: cleanPhone,
      password: form.password,
      rue: form.adresseUtilisateur.rue,
      ville: form.adresseUtilisateur.ville,
      codePostal: form.adresseUtilisateur.codePostal
    }

    const response = await axios.post("https://localhost:7057/api/Utilisateurs/register", payload);
    authState.setUser(response.data);
    loginSuccess.value = true;
    successMessage.value = "Inscription réussie !";
    apiError.value = "";
    loginSuccess.value = true;
      
      setTimeout(() => {
        router.push({ name: 'home' });
      }, 800);

  } catch (error) {
   
    if (error.response && error.response.status === 400) {
        const msg = error.response.data;
        if (typeof msg === 'string' && msg.includes("email")) {
            errors.email = msg;
        } else if (typeof msg === 'string' && msg.includes("téléphone")) {
            errors.telephoneUtilisateur = msg;
        } else {
            apiError.value = msg;
        }
    } else {
        apiError.value = "Une erreur serveur est survenue.";
        console.error(error);
    }
    
  }
}




</script>


<style scoped>
/* Fix text alignment: ensuring labels and errors are left-aligned */
.field {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  text-align: left;
  margin-bottom: 15px;
}

.field label {
  font-weight: bold;
  margin-bottom: 5px;
}

/* Password positioning */
.password-wrapper {
  position: relative;
  width: 100%;
}

.password-wrapper input {
  padding-right: 80px; /* Make room for the button */
  width: 100%;
  box-sizing: border-box;
}

.toggle-btn {
  position: absolute;
  right: 10px;
  top: 50%;
  transform: translateY(-50%);
  background: none;
  border: none;
  color: #ea580c; /* leboncoin orange */
  font-size: 12px;
  font-weight: bold;
  cursor: pointer;
  width: auto; /* Overrides your global button width */
  padding: 5px;
}

.toggle-btn:hover {
  background: none;
  text-decoration: underline;
}

/* Remove any remaining centering */
.error, span {
  text-align: left;
  width: 100%;
}
@keyframes pulse {
  0%, 100% { opacity: 1; }
  50% { opacity: .5; }
}

.animate-pulse {
  animation: pulse 2s cubic-bezier(0.4, 0, 0.6, 1) infinite;
}


.fixed {
  position: fixed;
}
.inset-0 {
  top: 0; right: 0; bottom: 0; left: 0;
}
.z-50 {
  z-index: 50;
}
.bg-white\/95 {
  background-color: rgba(255, 255, 255, 0.95);
}

.register-container {
  width: 400px;
  margin: auto;
  margin-top: 80px;
  padding: 30px;
  border-radius: 10px;
  background: #f5f5f5;
  box-shadow: 0 5px 15px rgba(0,0,0,0.1);
}
h1 { text-align: center; }
.field { margin-bottom: 15px; }
input {
  width: 100%;
  padding: 10px;
  margin-top: 5px;
  border: 1px solid #ccc;
  border-radius: 12px;
}
input::placeholder {
  font-weight: bold;
  opacity: 0.5;
  color: rgb(146, 117, 117);
}

input:focus {
  outline: none;
  border: 1px solid #ff6e14;
}
input.error {
  border: 1px solid red;
}
button {
  width: 100%;
  padding: 12px;
  background: #ff6e14;
  color: white;
  border: none;
  border-radius: 5px;
  cursor: pointer;
}
button:hover { background: #e65c00; }
span { color: red; font-size: 12px; }
.success { color: green; text-align: center; margin-top: 10px; }
.error { color: red; text-align: left; margin-top: 10px; }
</style>