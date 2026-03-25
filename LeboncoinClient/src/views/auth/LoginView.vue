<script setup>
import { reactive, ref,onMounted } from 'vue'
import api from '@/api/axios'
import { useRouter } from 'vue-router'
import { authState } from '@/auth.js'

const router = useRouter()
const showPassword = ref(false)
const showPasswordConfirm = ref(false)
const form = reactive({
  email: '',
  password: '',
})

const errors = reactive({
  email: '',
  password: '',
})

const apiError = ref('')
const emailExists = ref(false)
const loginSuccess = ref(false)

async function login() {
  errors.email = ''
  apiError.value = ''

  if (!form.email) {
    errors.email = 'Email requis'
    return
  }
  const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
  if (!emailPattern.test(form.email)) {
    errors.email = 'Veuillez saisir une adresse email valide (ex: nom@domaine.com)'
    return
  }

  if (emailExists.value) {
    try {
      const response = await api.post(`/Utilisateurs/login`, {
        email: form.email,
        password: form.password,
      })

      authState.login(response.data)

      setTimeout(() => {
        router.push({ name: 'home' })
      }, 800)
    } catch (error) {
      if (error.response) {
        apiError.value =
          typeof error.response.data === 'string' ? error.response.data : 'Erreur de connexion.'
      } else {
        apiError.value = 'Le serveur est injoignable.'
      }
    }
    return
  }

  try {
    await api.get(`/Utilisateurs/email/${form.email}`)
    emailExists.value = true
  } catch (error) {
    if (error.response?.status === 404) {
      router.push({ name: 'register', query: { email: form.email } })
    } else {
      apiError.value = 'Erreur serveur.'
    }
  }
}
</script>

<template>
  <div class="login-container relative">
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
          Ravi de vous revoir, {{ authState.user?.pseudonyme }} !
        </h2>
        <p class="text-gray-500 mt-2">Nous vous redirigeons vers l'accueil...</p>
      </div>
    </div>

    <h1>Connectez-vous ou créez votre compte leboncoin</h1>

    <form @submit.prevent="login" v-if="!loginSuccess">
      <div class="field">
        <label>E-mail</label>
        <input
          v-model="form.email"
          type="email"
          placeholder="email@mail.com"
          :disabled="emailExists"
        />
        <span v-if="errors.email" class="error-text">{{ errors.email }}</span>
      </div>

      <div class="field" v-if="emailExists">
        <label>Mot de passe</label>
        <div class="password-wrapper">
        <input v-model="form.password"  :type="showPasswordConfirm ? 'text' : 'password'" placeholder="Mot de passe" autofocus/>
                  <button type="button" class="toggle-btn" @click="showPasswordConfirm = !showPasswordConfirm">
            {{ showPasswordConfirm ? 'Masquer' : 'Afficher' }}
          </button>
          </div>
      </div>

      <button type="submit" class="login-btn">Se connecter</button>

      <button type="button" @click="emailExists = false" class="modifier-btn" v-if="emailExists">
        Modifier l'email
      </button>
    </form>

    <p class="error" v-if="apiError">{{ apiError }}</p>
  </div>
</template>

<style src="../../assets/login.css" scoped></style>
