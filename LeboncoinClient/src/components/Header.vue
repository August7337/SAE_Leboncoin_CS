<script setup>
import { useRouter } from 'vue-router'
import { authState } from '@/auth.js'

const router = useRouter()

const logout = () => {
  authState.clearUser()
  router.push('/login')
}
</script>

<template>
  <header
    id="main-header"
    class="w-full border-b border-gray-200 bg-white py-3 sticky top-0 z-40 left-0 transition-shadow duration-200"
  >
    <div
      class="mx-auto h-16 flex items-center justify-between gap-4 max-w-6xl px-6 md:px-12 xl:px-6"
    >
      <div class="flex items-center gap-4">
        <router-link to="/" class="flex-shrink-0">
          <img
            src="/assets/Leboncoin_logo.svg"
            alt="Logo leboncoin"
            class="h-8 w-auto object-contain"
          />
        </router-link>
      </div>

      <router-link
        to="/create-annonce"
        class="hidden md:flex items-center gap-2 bg-[#ea580c] hover:bg-[#c2410c] text-white transition-colors font-bold py-2.5 px-5 rounded-xl shadow-sm"
      >
        <svg
          xmlns="http://www.w3.org/2000/svg"
          fill="none"
          viewBox="0 0 24 24"
          stroke-width="2"
          stroke="currentColor"
          class="w-6 h-6"
        >
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            d="M12 9v6m3-3H9m12 0a9 9 0 11-18 0 9 9 0 0118 0z"
          />
        </svg>
        <span>Déposer une annonce</span>
      </router-link>

      <nav class="flex items-center gap-6 text-gray-700 shrink-0">

        <router-link
          to="/mes-recherches"
          class="relative hidden md:flex flex-col items-center gap-1 group w-20"
        >
          <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" class="w-6 h-6 group-hover:text-black transition-colors">
            <path stroke-linecap="round" stroke-linejoin="round" d="M17.593 3.322c1.1.128 1.907 1.077 1.907 2.185V21L12 17.25 4.5 21V5.507c0-1.108.806-2.057 1.907-2.185a48.507 48.507 0 0111.186 0z" />
          </svg>
          <span class="text-xs font-medium group-hover:text-black transition-colors text-center leading-tight mt-1">Recherches</span>
          <span class="absolute -bottom-3 left-1/2 w-0 h-[3px] -translate-x-1/2 bg-orange-600 transition-all duration-300 group-hover:w-full"></span>
        </router-link>

        <router-link
          to="/favorites"
          class="relative hidden md:flex flex-col items-center gap-1 group w-16"
        >
          <svg
            xmlns="http://www.w3.org/2000/svg"
            fill="none"
            viewBox="0 0 24 24"
            stroke-width="2"
            stroke="currentColor"
            class="w-6 h-6 group-hover:text-black transition-colors"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              d="M21 8.25c0-2.485-2.099-4.5-4.688-4.5-1.935 0-3.597 1.126-4.312 2.733-.715-1.607-2.377-2.733-4.313-2.733C5.1 3.75 3 5.765 3 8.25c0 7.22 9 12 9 12s9-4.78 9-12z"
            />
          </svg>
          <span class="text-xs font-medium group-hover:text-black transition-colors">Favoris</span>
          <span
            class="absolute -bottom-3 left-1/2 w-0 h-[3px] -translate-x-1/2 bg-orange-600 transition-all duration-300 group-hover:w-full"
          ></span>
        </router-link>

  <router-link :to="authState.user ? '/profil' : '/login'" class="relative flex flex-col items-center gap-1 group">
    <div class="h-6 w-6 rounded-full overflow-hidden border border-gray-200 group-hover:border-black transition-colors bg-gray-100 flex items-center justify-center">
      <img
        v-if="authState.user"
        :src="authState.user.profilePhotoPath || 'https://cdn-icons-png.flaticon.com/512/149/149071.png'"
        alt="Avatar"
        class="h-full w-full object-cover"
      />
      <svg v-else xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-4 h-4">
        <path stroke-linecap="round" stroke-linejoin="round" d="M15.75 6a3.75 3.75 0 11-7.5 0 3.75 3.75 0 017.5 0zM4.501 20.118a7.5 7.5 0 0114.998 0A17.933 17.933 0 0112 21.75c-2.676 0-5.216-.584-7.499-1.632z" />
      </svg>
    </div>
    <span class="text-xs font-medium group-hover:text-black transition-colors">
      {{ authState.user ? authState.user.pseudonyme : 'Se connecter' }}
    </span>
    <span class="absolute -bottom-3 left-1/2 w-0 h-[3px] -translate-x-1/2 bg-orange-600 transition-all duration-300 group-hover:w-full"></span>
  </router-link>

  <button v-if="authState.user" @click="logout" class="text-xs text-gray-400 hover:text-red-600 transition-colors">
    Quitter
  </button>

</nav>
    </div>
  </header>
</template>
