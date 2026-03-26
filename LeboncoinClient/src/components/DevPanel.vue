<script setup>
import { ref } from 'vue'
import api from '@/api/axios'
import { authState } from '@/auth.js'
import { useRouter } from 'vue-router'

const router = useRouter()
const open = ref(false)
const userId = ref('')
const error = ref('')
const loading = ref(false)

const SERVICE_ACCOUNTS = [
  {
    label: 'Location',
    sub: 'service.location@leboncoin.local',
    email: 'service.location@leboncoin.local',
    password: 'Service123!',
    dot: 'bg-orange-400',
    btn: 'hover:bg-orange-50 border-orange-200 text-orange-700',
  },
  {
    label: 'Comptabilité',
    sub: 'service.comptabilite@leboncoin.local',
    email: 'service.comptabilite@leboncoin.local',
    password: 'Service123!',
    dot: 'bg-green-400',
    btn: 'hover:bg-green-50 border-green-200 text-green-700',
  },
  {
    label: 'Contentieux',
    sub: 'service.contentieux@leboncoin.local',
    email: 'service.contentieux@leboncoin.local',
    password: 'Service123!',
    dot: 'bg-red-400',
    btn: 'hover:bg-red-50 border-red-200 text-red-700',
  },
]

async function loginAs(email, password) {
  error.value = ''
  loading.value = true
  try {
    const res = await api.post('/Utilisateurs/login', { email, password })
    authState.login(res.data)
    redirect()
  } catch (e) {
    error.value = typeof e?.response?.data === 'string' ? e.response.data : 'Erreur de connexion'
  } finally {
    loading.value = false
  }
}

async function impersonate() {
  const id = parseInt(userId.value)
  if (!id || id <= 0) {
    error.value = 'ID invalide'
    return
  }
  error.value = ''
  loading.value = true
  try {
    const res = await api.post(`/Utilisateurs/dev/impersonate/${id}`)
    authState.login(res.data)
    redirect()
  } catch (e) {
    error.value =
      typeof e?.response?.data === 'string'
        ? e.response.data
        : `Utilisateur #${id} introuvable`
  } finally {
    loading.value = false
  }
}

function disconnect() {
  authState.clearUser()
  router.push({ name: 'login' })
}

function redirect() {
  if (authState.hasPermission('app.view.home')) {
    router.push({ name: 'home' })
  } else {
    router.push({ name: 'service-dashboard' })
  }
}
</script>

<template>
  <div class="fixed bottom-4 right-4 z-[9999] select-none">
    <!-- Toggle button -->
    <button
      @click="open = !open"
      class="flex items-center gap-1.5 bg-gray-900 text-white text-xs font-mono px-3 py-1.5 rounded-full shadow-lg hover:bg-gray-700 transition-colors"
      title="Panneau développeur"
    >
      <span class="text-yellow-400">⚙</span>
      <span>Dev</span>
      <span class="text-gray-400 text-[10px]">{{ open ? '▲' : '▼' }}</span>
    </button>

    <!-- Panel -->
    <Transition
      enter-active-class="transition ease-out duration-150"
      enter-from-class="opacity-0 translate-y-2"
      enter-to-class="opacity-100 translate-y-0"
      leave-active-class="transition ease-in duration-100"
      leave-from-class="opacity-100 translate-y-0"
      leave-to-class="opacity-0 translate-y-2"
    >
      <div
        v-if="open"
        class="absolute bottom-10 right-0 w-72 bg-white border border-gray-200 rounded-xl shadow-2xl overflow-hidden font-mono text-xs"
      >
        <!-- Header -->
        <div class="bg-gray-900 text-white px-3 py-2 flex items-center justify-between">
          <span class="text-yellow-400 font-semibold">⚙ Dev Panel</span>
          <span
            v-if="authState.user"
            class="text-gray-300 truncate max-w-[160px]"
            :title="authState.user.email"
          >
            {{ authState.user.pseudonyme }}
            <span class="text-gray-500">(#{{ authState.user.idutilisateur }})</span>
          </span>
          <span v-else class="text-gray-500 italic">non connecté</span>
        </div>

        <div class="p-3 space-y-3">
          <!-- Service accounts -->
          <div>
            <p class="text-gray-400 uppercase tracking-widest text-[10px] mb-1.5">Comptes service</p>
            <div class="space-y-1">
              <button
                v-for="acc in SERVICE_ACCOUNTS"
                :key="acc.email"
                :disabled="loading"
                @click="loginAs(acc.email, acc.password)"
                class="w-full flex items-center gap-2 border rounded-lg px-2.5 py-1.5 transition-colors disabled:opacity-40 cursor-pointer"
                :class="acc.btn"
              >
                <span class="w-2 h-2 rounded-full flex-shrink-0" :class="acc.dot"></span>
                <span class="font-semibold">{{ acc.label }}</span>
                <span class="text-[10px] text-gray-400 ml-auto truncate">{{ acc.sub.split('@')[0] }}</span>
              </button>
            </div>
          </div>

          <!-- Divider -->
          <div class="border-t border-gray-100"></div>

          <!-- Impersonate by ID -->
          <div>
            <p class="text-gray-400 uppercase tracking-widest text-[10px] mb-1.5">Connexion par ID</p>
            <div class="flex gap-1.5">
              <input
                v-model="userId"
                type="number"
                min="1"
                placeholder="ID utilisateur"
                @keyup.enter="impersonate"
                class="flex-1 border border-gray-200 rounded-lg px-2 py-1.5 text-gray-700 placeholder-gray-300 focus:outline-none focus:border-blue-400 focus:ring-1 focus:ring-blue-200 transition"
              />
              <button
                :disabled="loading || !userId"
                @click="impersonate"
                class="bg-blue-600 text-white px-3 py-1.5 rounded-lg hover:bg-blue-700 disabled:opacity-40 transition-colors cursor-pointer font-semibold"
              >
                Go
              </button>
            </div>
          </div>

          <!-- Error -->
          <p v-if="error" class="text-red-500 bg-red-50 border border-red-200 rounded-lg px-2 py-1">
            {{ error }}
          </p>

          <!-- Disconnect -->
          <div v-if="authState.user" class="border-t border-gray-100 pt-2">
            <button
              @click="disconnect"
              class="w-full text-gray-500 hover:text-red-600 hover:bg-red-50 border border-gray-200 hover:border-red-200 rounded-lg px-2 py-1.5 transition-colors cursor-pointer"
            >
              Déconnexion
            </button>
          </div>
        </div>
      </div>
    </Transition>
  </div>
</template>
