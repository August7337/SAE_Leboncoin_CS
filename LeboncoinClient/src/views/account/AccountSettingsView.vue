<script setup>
import { reactive, ref, onMounted } from 'vue'
import { authState } from '@/auth.js'
import api from '@/api/axios'

const isSaving = ref(false)
const message = ref({ text: '', type: '' })
const errors = reactive({}) // Track validation errors

const userType = ref(authState.user?.typeUtilisateur || 'particulier')

const form = reactive({
  pseudonyme: '',
  email: '',
  telephoneutilisateur: '',
  civilite: 'M.',
  nomutilisateur: '',
  prenomutilisateur: '',
  nomEntreprise: '',
  siret: '',
  secteuractivite: '',
})

onMounted(() => {
  const user = authState.user
  if (user) {
    form.pseudonyme = user.pseudonyme || ''
    form.email = user.email || ''
    form.telephoneutilisateur = user.telephone || ''
    userType.value = user.typeUtilisateur || 'particulier'

    if (userType.value === 'particulier') {
      form.civilite = user.civilite || 'M.'
      form.nomutilisateur = user.nomutilisateur || ''
      form.prenomutilisateur = user.prenomutilisateur || ''
} else {
  form.nomEntreprise = user.nomEntreprise || '';
  form.siret = String(user.siret || ''); 
  form.secteuractivite = user.secteuractivite || '';
}
  }
})

const validate = () => {
Object.keys(errors).forEach(key => delete errors[key]); 
  let isValid = true;
  if (form.pseudonyme.length < 3) {
    errors.pseudonyme = "Le pseudonyme doit faire au moins 3 caractères."
    isValid = false
  }

  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
  if (!emailRegex.test(form.email)) {
    errors.email = "Veuillez entrer une adresse email valide."
    isValid = false
  }
  const phoneRegex = /^(?:(?:\+|00)33|0)\s*[1-9](?:[\s.-]*\d{2}){4}$/
  if (!phoneRegex.test(form.telephoneutilisateur)) {
    errors.telephoneutilisateur = "Format de téléphone invalide (ex: 0612345678)."
    isValid = false
  }
if (userType.value === 'professionnel') {
    if (!form.nomEntreprise) {
      errors.nomEntreprise = "Le nom de l'entreprise est requis.";
      isValid = false;
    }

  
    const siretValue = String(form.siret || ''); 
    const cleanSiret = siretValue.replace(/\s/g, '');

    if (!/^\d{14}$/.test(cleanSiret)) {
      errors.siret = "Le SIRET doit contenir exactement 14 chiffres.";
      isValid = false;
    }

    if (!form.secteuractivite) {
      errors.secteuractivite = "Veuillez sélectionner un secteur.";
      isValid = false;
    }
  }

  return isValid
}

const updateAccount = async () => {
  if (!validate()) {
    message.value = { text: 'Veuillez corriger les erreurs ci-dessous.', type: 'error' }
    return
  }

  const userId = authState.user?.idutilisateur
  if (!userId) return

  isSaving.value = true
  message.value = { text: '', type: '' }

  const payload = {
    idutilisateur: userId,
    pseudonyme: form.pseudonyme,
    email: form.email,
    telephoneutilisateur: form.telephoneutilisateur,
    nomEntreprise: userType.value === 'professionnel' ? form.nomEntreprise : null,
    siret: userType.value === 'professionnel' ? form.siret : null,
    secteuractivite: userType.value === 'professionnel' ? form.secteuractivite : null,
    civilite: userType.value === 'particulier' ? form.civilite : null,
    nomutilisateur: userType.value === 'particulier' ? form.nomutilisateur : null,
    prenomutilisateur: userType.value === 'particulier' ? form.prenomutilisateur : null,
  }

  try {
    await api.put(`/Utilisateurs/${userId}`, payload)
    authState.setUser({ ...authState.user, ...payload, telephone: payload.telephoneutilisateur })
    message.value = { text: 'Modifications enregistrées !', type: 'success' }
  } catch (error) {
    message.value = { text: error.response?.data?.title || 'Erreur lors de la sauvegarde.', type: 'error' }
  } finally {
    isSaving.value = false
  }
}
</script>

<template>
  <div class="account-settings-page">
    <div class="content-wrapper">
      <div class="form-card">
        <div v-if="message.text" :class="['status-message', message.type]">
          {{ message.text }}
        </div>

        <div class="form-grid">
          <div class="input-group">
            <label>Pseudonyme</label>
            <input v-model="form.pseudonyme" type="text" :class="['input-field', { 'error-border': errors.pseudonyme }]" />
            <span v-if="errors.pseudonyme" class="error-text">{{ errors.pseudonyme }}</span>
          </div>
          <div class="input-group">
            <label>Téléphone</label>
            <input v-model="form.telephoneutilisateur" type="text" :class="['input-field', { 'error-border': errors.telephoneutilisateur }]" />
            <span v-if="errors.telephoneutilisateur" class="error-text">{{ errors.telephoneutilisateur }}</span>
          </div>
        </div>

        <div v-if="userType === 'particulier'" class="particulier-section">
          <div class="form-grid">
            <div class="input-group">
              <label>Nom</label>
              <input v-model="form.nomutilisateur" type="text" class="input-field" />
            </div>
            <div class="input-group">
              <label>Prénom</label>
              <input v-model="form.prenomutilisateur" type="text" class="input-field" />
            </div>
          </div>
        </div>

        <div class="input-group">
          <label>Adresse email</label>
          <input v-model="form.email" type="email" :class="['input-field', { 'error-border': errors.email }]" />
          <span v-if="errors.email" class="error-text">{{ errors.email }}</span>
        </div>

        <div v-if="userType === 'professionnel'" class="pro-section">
          <h3 class="section-divider">Informations Professionnelles</h3>
          <div class="input-group">
            <label>Nom de l'entreprise</label>
            <input v-model="form.nomEntreprise" type="text" :class="['input-field', { 'error-border': errors.nomEntreprise }]" />
            <span v-if="errors.nomEntreprise" class="error-text">{{ errors.nomEntreprise }}</span>
          </div>

          <div class="form-grid">
            <div class="input-group">
              <label>SIRET</label>
              <input 
  v-model="form.siret" 
  type="text" 
  maxlength="14"
  placeholder="14 chiffres"
  :class="['input-field', { 'error-border': errors.siret }]" 
/>
              <span v-if="errors.siret" class="error-text">{{ errors.siret }}</span>
            </div>

            <div class="input-group">
              <label>Secteur d'activité</label>
<select 
        v-model="form.secteuractivite" 
        :class="['input-field', { 'error-border': errors.secteuractivite }]"
      >
        <option disabled value="">Sélectionnez un secteur</option>
        <option value="Agriculture">Agriculture</option>
        <option value="Artisanat">Artisanat</option>
        <option value="Automobile">Automobile</option>
        <option value="BTP">BTP / Construction</option>
        <option value="Commerce">Commerce / Retail</option>
        <option value="Hôtellerie">Hôtellerie</option>
        <option value="Immobilier">Immobilier</option>
        <option value="Informatique">Informatique / Tech</option>
        <option value="Restauration">Restauration</option>
        <option value="Sante">Santé / Bien-être</option>
        <option value="Services">Services aux entreprises</option>
        <option value="Transport">Transport / Logistique</option>
        <option value="Autre">Autre</option>
      </select>
              <span v-if="errors.secteuractivite" class="error-text">{{ errors.secteuractivite }}</span>
            </div>
          </div>
        </div>

        <button @click="updateAccount" :disabled="isSaving" class="submit-button">
          {{ isSaving ? 'Chargement...' : 'Enregistrer les modifications' }}
        </button>
      </div>
    </div>
  </div>
</template>

<style scoped>
/* Layout Containers */
.account-settings-page {
  min-height: 100vh;
  background-color: #f5f5f5;
  padding: 40px 16px;
  font-family: sans-serif;
}
.error-text {
  color: #b91c1c;
  font-size: 12px;
  font-weight: 600;
  margin-top: 4px;
  display: block;
}

.error-border {
  border-color: #f87171 !important;
}

.error-border:focus {
  border-color: #b91c1c !important;
  box-shadow: 0 0 0 1px #b91c1c;
}
.content-wrapper {
  max-width: 650px;
  margin: 0 auto;
}

/* Header & Badge */
.header-section {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 15px;
  margin-bottom: 30px;
}

.page-title {
  font-size: 24px;
  font-weight: 900;
  color: #111827;
  margin: 0;
  text-align: right;
  flex: 1;
}

.badge-container {
  flex: 1;
}

.type-badge {
  background-color: #ffedd5;
  color: #ea580c;
  padding: 6px 16px;
  border-radius: 999px;
  font-size: 12px;
  font-weight: 800;
  text-transform: uppercase;
  letter-spacing: 0.05em;
}

/* Card Style */
.form-card {
  background: white;
  border-radius: 24px;
  padding: 32px;
  box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
  border: 1px solid #f3f4f6;
}

/* Form Elements */
.form-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 20px;
  margin-bottom: 20px;
}

.input-group {
  margin-bottom: 20px;
}

label {
  display: block;
  font-size: 14px;
  font-weight: 700;
  color: #111827;
  margin-bottom: 8px;
}

.input-field {
  width: 100%;
  padding: 12px 16px;
  border-radius: 12px;
  border: 1px solid #e5e7eb;
  outline: none;
  transition: border-color 0.2s;
  box-sizing: border-box; /* Crucial for padding */
}

.input-field:focus {
  border-color: #ea580c;
}

/* Pro Section Divider */
.pro-section {
  margin-top: 30px;
  padding-top: 20px;
  border-top: 1px solid #f3f4f6;
}

.section-divider {
  font-size: 12px;
  font-weight: 800;
  color: #9ca3af;
  text-transform: uppercase;
  margin-bottom: 20px;
}

/* Button */
.submit-button {
  width: 100%;
  background-color: #ea580c;
  color: white;
  font-weight: 700;
  padding: 16px;
  border: none;
  border-radius: 16px;
  cursor: pointer;
  transition: all 0.2s;
  box-shadow: 0 10px 15px -3px rgba(234, 88, 12, 0.2);
  margin-top: 10px;
}

.submit-button:hover {
  background-color: #c2410c;
  transform: translateY(-1px);
}

.submit-button:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

/* Status Messages */
.status-message {
  padding: 16px;
  border-radius: 12px;
  font-size: 14px;
  font-weight: 700;
  text-align: center;
  margin-bottom: 20px;
}

.status-message.success {
  background-color: #f0fdf4;
  color: #15803d;
}

.status-message.error {
  background-color: #fef2f2;
  color: #b91c1c;
}

/* Responsive */
@media (max-width: 640px) {
  .form-grid {
    grid-template-columns: 1fr;
  }
  .header-section {
    flex-direction: column;
    text-align: center;
  }
  .page-title {
    text-align: center;
  }
}
</style>

<style src="../../assets/register.css" scoped></style>
