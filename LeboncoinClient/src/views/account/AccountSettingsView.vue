<script setup>
import { reactive, ref, onMounted } from 'vue'
import { authState } from '@/auth.js'
import axios from 'axios'

const isSaving = ref(false)
const message = ref({ text: '', type: '' })

const userType = ref(authState.user?.typeUtilisateur || 'particulier')
onMounted(() => {
  const user = authState.user
  if (user) {
    form.pseudonyme = user.pseudonyme || ''
    form.email = user.email || ''
    form.telephone = user.telephone || ''
    userType.value = user.typeUtilisateur || 'particulier'

    if (userType.value === 'particulier') {
      form.civilite = user.civilite || 'M.'
      form.nomutilisateur = user.nomutilisateur || ''
      form.prenomutilisateur = user.prenomutilisateur || ''
    } else {
      form.nomEntreprise = user.nomEntreprise || ''
      form.siret = user.siret || ''
      form.siteWeb = user.secteuractivite || ''
    }
  }
})
const form = reactive({
  pseudonyme: authState.user?.pseudonyme || '',
  email: authState.user?.email || '',
  telephone: authState.user?.telephoneutilisateur || '',
  // Particulier specific fields
  civilite: authState.user?.civilite || 'M.',
  nomutilisateur: authState.user?.nomutilisateur || '',
  prenomutilisateur: authState.user?.prenomutilisateur || '',
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

  const payload = {
    idutilisateur: userId,
    pseudonyme: form.pseudonyme,
    email: form.email,
    telephoneutilisateur: form.telephone,
  }

  if (userType.value === 'particulier') {
    payload.civilite = form.civilite
    payload.nomutilisateur = form.nomutilisateur
    payload.prenomutilisateur = form.prenomutilisateur
  }
  if (userType.value === 'professionnel') {
    payload.nomEntreprise = form.nomEntreprise;
    payload.siret = form.siret;
    payload.siteWeb = form.siteWeb;
  }

  try {
    await axios.put(`https://localhost:7057/api/Utilisateurs/${userId}`, payload)

    const updatedUser = { ...authState.user, ...payload }
    authState.setUser(updatedUser)

    message.value = { text: 'Modifications enregistrées !', type: 'success' }
  } catch (error) {
    console.error('Save error:', error.response?.data)
    message.value = {
      text: error.response?.data?.title || 'Erreur lors de la sauvegarde.',
      type: 'error',
    }
  } finally {
    isSaving.value = false
  }
}
</script>

<template>
  <div class="account-settings-page">
    <div class="content-wrapper">
      <div class="header-section">
        <h1 class="page-title">Paramètres du compte</h1>
        <div class="badge-container">
          <span class="type-badge">{{ userType }}</span>
        </div>
      </div>

      <div class="form-card">
        <div v-if="message.text" :class="['status-message', message.type]">
          {{ message.text }}
        </div>

        <div class="form-grid">
          <div class="input-group">
            <label>Pseudonyme</label>
            <input v-model="form.pseudonyme" type="text" class="input-field" />
          </div>
          <div class="input-group">
            <label>Téléphone</label>
            <input v-model="form.telephone" type="text" class="input-field" />
          </div>
        </div>
        <div v-if="userType === 'particulier'" class="particulier-section">
          <div class="input-group">
            <label>Civilité</label>
            <select v-model="form.civilite" class="input-field">
              <option value="M.">Monsieur</option>
              <option value="Mme">Madame</option>
              <option value="Autre">Autre</option>
            </select>
          </div>

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
          <input v-model="form.email" type="email" class="input-field" />
        </div>

        <div v-if="userType === 'professionnel'" class="pro-section">
          <h3 class="section-divider">Informations Professionnelles</h3>

          <div class="input-group">
            <label>Nom de l'entreprise</label>
            <input v-model="form.nomEntreprise" type="text" class="input-field" />
          </div>

          <div class="form-grid">
            <div class="input-group">
              <label>SIRET</label>
              <input v-model="form.siret" type="text" class="input-field" />
            </div>
            <div class="input-group">
              <label>Site Web</label>
              <input
                v-model="form.siteWeb"
                type="text"
                class="input-field"
                placeholder="https://..."
              />
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
