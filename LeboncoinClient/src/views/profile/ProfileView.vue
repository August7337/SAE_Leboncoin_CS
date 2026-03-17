<script setup>
import { useRouter } from 'vue-router'
import { authState } from '@/auth.js'

const router = useRouter()


const menuItems = [
  { title: 'Mes annonces', icon: 'list', path: '/my-annonces', desc: 'Gérer vos publications' },
  { title: 'Mes messages', icon: 'chat', path: '/messages', desc: 'Vos conversations en cours' },
  { title: 'Favoris', icon: 'heart', path: '/favorites', desc: 'Annonces sauvegardées' },
  { title: 'Paramètres', icon: 'cog', path: '/settings', desc: 'Modifier vos informations' },
]

const handleLogout = () => {
  authState.clearUser()
  router.push('/login')
}
</script>

<template>
  <div class="min-h-screen bg-[#f5f5f5] py-10">
    <div class="max-w-2xl mx-auto px-4">
      
      <div v-if="authState.user"
        class="bg-white rounded-3xl p-8 shadow-sm border border-gray-100 mb-6 flex items-center gap-6"
      >
        <img 
          :src="authState.user.profilePhoto || `https://ui-avatars.com/api/?name=${authState.user.pseudonyme}&background=ea580c&color=fff`" 
          class="w-20 h-20 rounded-full border-4 border-orange-50 object-cover" 
        />
        <div>
          <h1 class="text-2xl font-black text-gray-900">Bonjour, {{ authState.user.pseudonyme }}</h1>
          <p class="text-gray-500">{{ authState.user.email }}</p>
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
            class="w-6 h-6 text-gray-300 group-hover:text-[#ea580c]"
            fill="none"
            stroke="currentColor"
            viewBox="0 0 24 24"
          >
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
          </svg>
        </router-link>
      </div>

      <button
        @click="handleLogout"
        class="w-full mt-8 py-4 text-red-600 font-bold hover:bg-red-50 rounded-2xl transition-colors"
      >
        Se déconnecter
      </button>

      <div v-if="!authState.user" class="text-center py-10">
        <p class="text-gray-500 mb-4">Oups ! Vous n'êtes pas connecté.</p>
        <router-link to="/login" class="text-orange-600 font-bold">Retourner à la connexion</router-link>
      </div>

    </div>
  </div>
</template>