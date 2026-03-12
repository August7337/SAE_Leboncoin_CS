<template>
  <div class="register-container">
    <h1>Créer un compte</h1>

    <form @submit.prevent="register">
      <div class="field">
        <label>Pseudonyme</label>
        <input v-model="form.pseudonyme" type="text" />
        <span v-if="errors.pseudonyme">{{ errors.pseudonyme }}</span>
      </div>

      <div class="field">
        <label>Email</label>
        <input v-model="form.email" type="email" />
        <span v-if="errors.email">{{ errors.email }}</span>
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
        <input v-model="form.password" type="password" />
        <span v-if="errors.password">{{ errors.password }}</span>
      </div>

      <div class="field">
        <label>Confirmer le mot de passe</label>
        <input v-model="form.passwordConfirm" type="password" />
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
import { useRoute } from "vue-router"
import axios from "axios"

const route = useRoute()

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
  if (!form.email) { errors.email = "Email requis"; valid = false; }
  
  if (!form.telephoneUtilisateur || !/^0\d{9}$/.test(form.telephoneUtilisateur)) {
    errors.telephoneUtilisateur = "Le numéro de téléphone doit contenir 10 chiffres et commencer par 0"
    valid = false
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
    const cp = form.adresseUtilisateur.codePostal;
    // Remove leading zero for department lookup if needed (01 -> 1)
    const depCodeRaw = cp.substring(0, 2);
    const depKey = depCodeRaw.startsWith('0') ? depCodeRaw.substring(1) : depCodeRaw;

    const payload = {
      Pseudonyme: form.pseudonyme,
      Email: form.email,
      TelephoneUtilisateur: form.telephoneUtilisateur,
      Password: form.password,
      Solde: 0,
      PhoneVerified: false,
      IdentityVerified: false,
      
      AdresseUtilisateur: {
        NomRue: form.adresseUtilisateur.rue,
        // We set IDs to 0 to tell the backend "This is new, please generate an ID"
        AdresseId: 0, 
        VilleAdresse: {
          VilleId: 0,
          NomVille: form.adresseUtilisateur.ville,
          CodePostal: cp,
          DepartementAssocie: {
            DepartementId: 0,
            NumeroDepartement: depCodeRaw,
            // Access the dictionary safely
            NomDepartement: departements[depKey] || "Inconnu",
            RegionAssociee: {
              RegionId: 0,
              NomRegion: getRegionFromPostalCode(cp) || "Inconnue"
            }
          }
        }
      },
      
      DateInscription: {
        DateId: 0,
        DateValeur: new Date().toISOString()
      }
    }

    const response = await axios.post("https://localhost:7057/api/Utilisateurs", payload);
    // ... success logic
  } catch (error) {
    if (error.response && error.response.status === 400) {
        // Handle specific "Already exists" errors
        const msg = error.response.data;
        if (msg.includes("email")) {
            errors.email = msg;
        } else if (msg.includes("téléphone")) {
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
<script>

export function getDepartementFromPostalCode(codePostal) {
  if (!codePostal) return null;
  

  if (codePostal.startsWith('20')) {

    return codePostal.startsWith('201') || codePostal.startsWith('200') ? '2A' : '2B';
  }
  
  
  return codePostal.substring(0, 2);
}


export function getRegionFromPostalCode(codePostal) {
  const dep = getDepartementFromPostalCode(codePostal);
  if (!dep) return null;

  for (const [region, deps] of Object.entries(regions)) {
  
    if (deps.includes(dep) || deps.includes(Number(dep))) {
      return region;
    }
  }

  return "Région Inconnue"; 
}


export const departements = {
  1: "Ain",
  2: "Aisne",
  3: "Allier",
  4: "Alpes-de-Haute-Provence",
  5: "Hautes-Alpes",
  6: "Alpes-Maritimes",
  7: "Ardèche",
  8: "Ardennes",
  9: "Ariège",
  10: "Aube",
  11: "Aude",
  12: "Aveyron",
  13: "Bouches-du-Rhône",
  14: "Calvados",
  15: "Cantal",
  16: "Charente",
  17: "Charente-Maritime",
  18: "Cher",
  19: "Corrèze",
  21: "Côte-d'Or",
  22: "Côtes-d'Armor",
  23: "Creuse",
  24: "Dordogne",
  25: "Doubs",
  26: "Drôme",
  27: "Eure",
  28: "Eure-et-Loir",
  29: "Finistère",
  30: "Gard",
  31: "Haute-Garonne",
  32: "Gers",
  33: "Gironde",
  34: "Hérault",
  35: "Ille-et-Vilaine",
  36: "Indre",
  37: "Indre-et-Loire",
  38: "Isère",
  39: "Jura",
  40: "Landes",
  41: "Loir-et-Cher",
  42: "Loire",
  43: "Haute-Loire",
  44: "Loire-Atlantique",
  45: "Loiret",
  46: "Lot",
  47: "Lot-et-Garonne",
  48: "Lozère",
  49: "Maine-et-Loire",
  50: "Manche",
  51: "Marne",
  52: "Haute-Marne",
  53: "Mayenne",
  54: "Meurthe-et-Moselle",
  55: "Meuse",
  56: "Morbihan",
  57: "Moselle",
  58: "Nièvre",
  59: "Nord",
  60: "Oise",
  61: "Orne",
  62: "Pas-de-Calais",
  63: "Puy-de-Dôme",
  64: "Pyrénées-Atlantiques",
  65: "Hautes-Pyrénées",
  66: "Pyrénées-Orientales",
  67: "Bas-Rhin",
  68: "Haut-Rhin",
  69: "Rhône",
  70: "Haute-Saône",
  71: "Saône-et-Loire",
  72: "Sarthe",
  73: "Savoie",
  74: "Haute-Savoie",
  75: "Paris",
  76: "Seine-Maritime",
  77: "Seine-et-Marne",
  78: "Yvelines",
  79: "Deux-Sèvres",
  80: "Somme",
  81: "Tarn",
  82: "Tarn-et-Garonne",
  83: "Var",
  84: "Vaucluse",
  85: "Vendée",
  86: "Vienne",
  87: "Haute-Vienne",
  88: "Vosges",
  89: "Yonne",
  90: "Territoire de Belfort",
  91: "Essonne",
  92: "Hauts-de-Seine",
  93: "Seine-Saint-Denis",
  94: "Val-de-Marne",
  95: "Val-d'Oise"
}
export const regions = {
  "Auvergne-Rhône-Alpes": [1,3,7,15,26,38,42,43,63,69,73,74],
  "Bourgogne-Franche-Comté": [21,25,39,58,70,71,89,90],
  "Bretagne": [22,29,35,56],
  "Centre-Val de Loire": [18,28,36,37,41,45],
  "Corse": ["2A","2B"],
  "Grand Est": [8,10,51,52,54,55,57,67,68,88],
  "Hauts-de-France": [2,59,60,62,80],
  "Île-de-France": [75,77,78,91,92,93,94,95],
  "Normandie": [14,27,50,61,76],
  "Nouvelle-Aquitaine": [16,17,19,23,24,33,40,47,64,79,86,87],
  "Occitanie": [9,11,12,30,31,32,34,46,48,65,66,81,82],
  "Pays de la Loire": [44,49,53,72,85],
  "Provence-Alpes-Côte d'Azur": [4,5,6,13,83,84]
}

</script>

<style scoped>

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
.error { color: red; text-align: center; margin-top: 10px; }
</style>