<script setup>
// Tu peux ajouter une logique ici plus tard pour l'état actif
</script>

<template>
  <header
    id="main-header"
    class="w-full border-b border-gray-200 bg-white py-3 sticky top-0 z-40 left-0 transition-shadow duration-200"
  >
    <div class="mx-auto h-16 flex items-center justify-between gap-4 max-w-6xl px-6 md:px-12 xl:px-6">
      
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
        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" class="w-6 h-6">
          <path stroke-linecap="round" stroke-linejoin="round" d="M12 9v6m3-3H9m12 0a9 9 0 11-18 0 9 9 0 0118 0z" />
        </svg>
        <span>Déposer une annonce</span>
      </router-link>

      <nav class="flex items-center gap-6 text-gray-700 shrink-0">
        
        <router-link
          to="/search"
          class="relative hidden md:flex flex-col items-center gap-1 group"
        >
          <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" class="w-6 h-6 group-hover:text-black transition-colors">
            <path stroke-linecap="round" stroke-linejoin="round" d="M21 21l-5.197-5.197m0 0A7.5 7.5 0 105.196 5.196a7.5 7.5 0 0010.607 10.607z" />
          </svg>
          <span class="text-xs font-medium group-hover:text-black transition-colors">Rechercher</span>
          <span class="absolute -bottom-3 left-1/2 w-0 h-[3px] -translate-x-1/2 bg-orange-600 transition-all duration-300 group-hover:w-full"></span>
        </router-link>

        <router-link
          to="/favorites"
          class="relative hidden md:flex flex-col items-center gap-1 group w-16"
        >
          <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" class="w-6 h-6 group-hover:text-black transition-colors">
            <path stroke-linecap="round" stroke-linejoin="round" d="M21 8.25c0-2.485-2.099-4.5-4.688-4.5-1.935 0-3.597 1.126-4.312 2.733-.715-1.607-2.377-2.733-4.313-2.733C5.1 3.75 3 5.765 3 8.25c0 7.22 9 12 9 12s9-4.78 9-12z" />
          </svg>
          <span class="text-xs font-medium group-hover:text-black transition-colors">Favoris</span>
          <span class="absolute -bottom-3 left-1/2 w-0 h-[3px] -translate-x-1/2 bg-orange-600 transition-all duration-300 group-hover:w-full"></span>
        </router-link>

        <router-link
          to="/profil"
          class="relative flex flex-col items-center gap-1 group"
        >
          <div class="h-6 w-6 rounded-full overflow-hidden border border-gray-200 group-hover:border-black transition-colors">
            <img src="https://augustin-tarit.dev/tim.jpeg" alt="Avatar" class="h-full w-full object-cover" />
          </div>
          <span class="text-xs font-medium group-hover:text-black transition-colors">Tim</span>
          <span class="absolute -bottom-3 left-1/2 w-0 h-[3px] -translate-x-1/2 bg-orange-600 transition-all duration-300 group-hover:w-full"></span>
        </router-link>

      </nav>
    </div>
  </header>
</template>