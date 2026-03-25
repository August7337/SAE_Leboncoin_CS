<template>
  <div class="register-container relative">
    <div
      v-if="loginSuccess"
      class="fixed inset-0 flex items-center justify-center bg-white/95 z-50 transition-opacity"
    >
      <div class="text-center">
        <div
          class="w-20 h-20 bg-orange-100 rounded-full flex items-center justify-center mx-auto mb-4 animate-pulse"
        >
          <svg
            xmlns="http://www.w3.org/2000/svg"
            class="h-10 w-10 text-[#ea580c]"
            fill="none"
            viewBox="0 0 24 24"
            stroke="currentColor"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="3"
              d="M5 13l4 4L19 7"
            />
          </svg>
        </div>
        <h2 class="text-2xl font-bold text-gray-900">
          Bienvenue, {{ authState.user?.pseudonyme }} !
        </h2>
        <p class="text-gray-500 mt-2">Votre compte professionnel est prêt.</p>
      </div>
    </div>
    <button type="button" class="back-arrow-btn" @click="goBack">
      <svg
        xmlns="http://www.w3.org/2000/svg"
        class="h-6 w-6"
        fill="none"
        viewBox="0 0 24 24"
        stroke="currentColor"
      >
        <path
          stroke-linecap="round"
          stroke-linejoin="round"
          stroke-width="2"
          d="M10 19l-7-7m0 0l7-7m-7 7h18"
        />
      </svg>
    </button>

    <h1>Finalisez votre profil</h1>
    <h2 style="margin-bottom: 4%">Etape 2/2 (Professionnel)</h2>

    <form @submit.prevent="submitFinal">
      <div class="field">
        <label>Nom de la société</label>
        <input v-model="proForm.nomsociete" type="text" :class="{ error: errors.nomsociete }" />
        <span v-if="errors.nomsociete" class="error-text">{{ errors.nomsociete }}</span>
      </div>

      <div class="field">
        <label>Numéro SIRET (14 chiffres)</label>
        <input
          v-model="proForm.numsiret"
          type="text"
          maxlength="14"
          :class="{ error: errors.numsiret }"
        />
        <span v-if="errors.numsiret" class="error-text">{{ errors.numsiret }}</span>
      </div>

      <div class="field">
        <label>Secteur d'activité</label>
        <select v-model="proForm.secteuractivite">
          <option value="Immobilier">Immobilier</option>
          <option value="Automobile">Automobile</option>
          <option value="Services">Services</option>
          <option value="Autre">Autre</option>
        </select>
      </div>

      <button type="submit">Créer mon compte professionnel</button>
    </form>
  </div>
</template>

<script setup>
import { onMounted, reactive, ref } from 'vue'
import { useRouter } from 'vue-router'
import api from '@/api/axios'
import { authState } from '@/auth'

const loginSuccess = ref(false)
const router = useRouter()
const dataFromStep1 = ref(null)

const proForm = reactive({
  nomsociete: '',
  numsiret: '',
  secteuractivite: 'Automobile',
})

const errors = reactive({ nomsociete: '', numsiret: '' })

onMounted(() => {
  const savedDraft = sessionStorage.getItem('registration_draft')
  if (savedDraft) {
    const data = JSON.parse(savedDraft)
    dataFromStep1.value = data
    if (data.numsiret) proForm.numsiret = data.numsiret
    if (data.nomsociete) proForm.nomsociete = data.nomsociete
    if (data.secteuractivite) proForm.secteuractivite = data.secteuractivite
  } else if (window.history.state?.payload) {
    dataFromStep1.value = window.history.state.payload
  }
})
const goBack = () => {
  const fullData = {
    ...(dataFromStep1.value || {}),
    ...proForm,
    typeUtilisateur: 'professionnel',
  }

  sessionStorage.setItem('registration_draft', JSON.stringify(fullData))

  router.push({ name: 'register' })
}
const validatePro = () => {
  Object.keys(errors).forEach((key) => (errors[key] = ''))
  let isValid = true
  if (!proForm.nomsociete.trim()) {
    errors.nomsociete = 'Requis.'
    isValid = false
  }
  if (!/^\d{14}$/.test(proForm.numsiret)) {
    errors.numsiret = '14 chiffres requis.'
    isValid = false
  }
  return isValid
}

const submitFinal = async () => {
  if (!validatePro()) return

  const fullData = {
    ...(dataFromStep1.value || {}),
    ...proForm,
    typeUtilisateur: 'professionnel',
  }

  const { passwordConfirm, typeUtilisateur, ...apiPayload } = fullData
  apiPayload.numsiret = parseFloat(proForm.numsiret)

  try {
    const response = await api.post(
      '/Utilisateurs/register-professionnel',
      apiPayload,
    )
    sessionStorage.removeItem('registration_draft')
    if (response.data.user) {
      authState.login(response.data)
    }

    loginSuccess.value = true

    setTimeout(() => {
      router.push({ name: 'home' })
    }, 800)
  } catch (error) {
    if (error.response && error.response.status === 409) {
      const { target, message } = error.response.data
      const isStep1Error = ['email', 'telephoneUtilisateur', 'pseudonyme'].includes(target)
      if (isStep1Error) {
        sessionStorage.setItem('registration_draft', JSON.stringify(fullData))
        router.push({
          name: 'register',
          state: { externalErrors: { [target]: message } },
        })
      } else {
        errors[target] = message
      }
    } else {
      alert('Erreur critique : ' + (error.response?.data?.message || 'Serveur injoignable'))
    }
  }
}
</script>

<style src="../../assets/register.css" scoped></style>
