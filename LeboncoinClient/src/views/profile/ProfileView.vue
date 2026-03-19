<script setup>
import { useRouter } from 'vue-router'
import { authState } from '@/auth.js'

const router = useRouter()

const menuItems = [
  { title: 'Mes annonces', icon: 'list', path: '/my-annonces', desc: 'Gérer vos publications' },
  { title: 'Mes messages', icon: 'chat', path: '/messages', desc: 'Vos conversations en cours' },
  { title: 'Favoris', icon: 'heart', path: '/favorites', desc: 'Annonces sauvegardées' },
  {
    title: 'Paramètres',
    icon: 'settings',
    path: '/account-settings',
    desc: 'Modifier vos informations',
  },
  { title: 'Sécurité', icon: 'lock', path: '/security', desc: 'Mot de passe et protection' },
]

const handleLogout = () => {
  authState.clearUser()
  router.push('/login')
}
</script>

<template>
  <div class="min-h-screen bg-[#f5f5f5] py-10">
    <div class="max-w-2xl mx-auto px-4">
      <div
        v-if="authState.user"
        class="bg-white rounded-3xl p-8 shadow-sm border border-gray-100 mb-6 flex items-center gap-6"
      >
        <img
          :src="
            authState.user.profilePhoto ||
            `https://ui-avatars.com/api/?name=${authState.user.pseudonyme}&background=ea580c&color=fff`
          "
          class="w-20 h-20 rounded-full border-4 border-orange-50 object-cover shadow-sm"
        />
        <div>
          <h1 class="text-2xl font-black text-gray-900">{{ authState.user.pseudonyme }}</h1>
          <p class="text-gray-500 font-medium">{{ authState.user.email }}</p>
        </div>
      </div>

      <div class="grid grid-cols-1 gap-4">
        <router-link
          v-for="item in menuItems"
          :key="item.path"
          :to="item.path"
          class="bg-white p-6 rounded-3xl shadow-sm border border-gray-100 hover:border-[#ea580c] transition-all flex justify-between items-center group"
        >
          <div>
            <h2 class="font-bold text-lg group-hover:text-[#ea580c] transition-colors">
              {{ item.title }}
            </h2>
            <p class="text-sm text-gray-400">{{ item.desc }}</p>
          </div>
          <svg
            class="w-6 h-6 text-gray-300 group-hover:text-[#ea580c] transform group-hover:translate-x-1 transition-all"
            fill="none"
            stroke="currentColor"
            viewBox="0 0 24 24"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M9 5l7 7-7 7"
            />
          </svg>
        </router-link>
      </div>

      <button
        @click="handleLogout"
        class="w-full mt-8 py-4 text-red-600 font-black hover:bg-red-50 rounded-2xl transition-all border-2 border-transparent hover:border-red-100"
      >
        Déconnexion
      </button>
    </div>
  </div>
</template>
