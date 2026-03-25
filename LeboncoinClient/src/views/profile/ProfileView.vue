<script setup>
import { useRouter } from 'vue-router'
import { authState } from '@/auth.js'

const router = useRouter()

const navigation = () => {
  router.push({ name: 'profile-picture' }) 
}

const handleLogout = () => {
  authState.clearUser()
  router.push('/login')
}
</script>

<template>
  <div class="bg-[#f8f9fb] min-h-screen pb-12">
    <main class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
      
      <!-- Top Card matching Laravel Dashboard -->
      <div class="flex flex-col md:flex-row gap-6 mb-8">
        <div class="bg-white border border-gray-200 flex w-full grow flex-col rounded-xl shadow-sm">
          <div class="p-6">
            <div class="flex items-center justify-between">
              <div class="flex items-center gap-6">
                <!-- Avatar -->
                <div class="relative flex-shrink-0 cursor-pointer group" @click="navigation">
                  <div class="w-24 h-24 rounded-full overflow-hidden bg-gray-100 border border-gray-200 flex items-center justify-center text-3xl font-bold text-gray-400 shadow-sm transition-transform group-hover:scale-105">
                    <img v-if="authState.user?.profilePhotoPath" :src="authState.user.profilePhotoPath" class="w-full h-full object-cover" />
                    <span v-else>{{ authState.user?.pseudonyme?.charAt(0).toUpperCase() }}</span>
                  </div>
                  <!-- Edit Icon overlay -->
                  <div class="absolute bottom-0 right-0 bg-white text-gray-700 p-2 rounded-full shadow-md border border-gray-100 group-hover:bg-gray-50 flex items-center justify-center">
                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" class="w-4 h-4">
                      <path d="M21.731 2.269a2.625 2.625 0 113.71 3.71l-9.399 9.399-1.127 1.127a2.25 2.25 0 01-1.59.659h-5.376a.75.75 0 01-.75-.75v-5.376a2.25 2.25 0 01.659-1.59l1.128-1.127 9.399-9.399zM8.679 13.72a.75.75 0 10-1.06-1.06L5.25 15.031v2.421l2.421.26 2.369-2.369z" />
                    </svg>
                  </div>
                </div>

                <!-- User Info -->
                <div class="flex flex-col">
                  <h2 class="text-2xl font-bold text-gray-900 mb-1">
                    {{ authState.user?.prenomutilisateur && authState.user?.nomutilisateur ? authState.user.prenomutilisateur + ' ' + authState.user.nomutilisateur : authState.user?.pseudonyme }}
                  </h2>
                  <span v-if="authState.user?.typeUtilisateur" class="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full border border-orange-200 bg-orange-50 text-orange-700 text-xs font-semibold shadow-sm w-fit capitalize">
                    {{ authState.user.typeUtilisateur }}
                  </span>
                  <div class="flex items-center text-sm text-gray-600 mt-2">
                    <span class="font-medium">{{ authState.user?.email }}</span>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Action Grid -->
      <div class="grid gap-6 md:grid-cols-2 lg:grid-cols-3">
        
        <!-- Mes Annonces -->
        <router-link to="/my-annonces" class="bg-white p-6 rounded-xl shadow-sm border border-gray-200 hover:shadow-md transition-shadow flex items-start gap-4">
          <div class="w-10 h-10 flex-shrink-0 bg-blue-50 rounded-lg flex items-center justify-center text-blue-600">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6">
              <path stroke-linecap="round" stroke-linejoin="round" d="M19.5 14.25v-2.625a3.375 3.375 0 00-3.375-3.375h-1.5A1.125 1.125 0 0113.5 7.125v-1.5a3.375 3.375 0 00-3.375-3.375H8.25m0 12.75h7.5m-7.5 3H12M10.5 2.25H5.625c-.621 0-1.125.504-1.125 1.125v17.25c0 .621.504 1.125 1.125 1.125h12.75c.621 0 1.125-.504 1.125-1.125V11.25a9 9 0 00-9-9z" />
            </svg>
          </div>
          <div>
            <h2 class="text-lg font-bold text-gray-900">Mes Annonces</h2>
            <p class="text-gray-500 text-sm mt-1">Gérer vos publications</p>
          </div>
        </router-link>

        <!-- Mes Réservations -->
        <router-link to="/my-reservations" class="bg-white p-6 rounded-xl shadow-sm border border-gray-200 hover:shadow-md transition-shadow flex items-start gap-4">
          <div class="w-10 h-10 flex-shrink-0 bg-yellow-50 rounded-lg flex items-center justify-center text-yellow-600">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6">
              <path stroke-linecap="round" stroke-linejoin="round" d="M6.75 3v2.25M17.25 3v2.25M3 18.75V7.5a2.25 2.25 0 012.25-2.25h13.5A2.25 2.25 0 0121 7.5v11.25m-18 0A2.25 2.25 0 005.25 21h13.5A2.25 2.25 0 0021 18.75m-18 0v-7.5A2.25 2.25 0 015.25 9h13.5A2.25 2.25 0 0121 11.25v7.5m-9-6h.008v.008H12v-.008zM12 15h.008v.008H12V15zm0 2.25h.008v.008H12v-.008zM9.75 15h.008v.008H9.75V15zm0 2.25h.008v.008H9.75v-.008zM7.5 15h.008v.008H7.5V15zm0 2.25h.008v.008H7.5v-.008zm6.75-4.5h.008v.008h-.008v-.008zm0 2.25h.008v.008h-.008V15zm0 2.25h.008v.008h-.008v-.008zm2.25-4.5h.008v.008H16.5v-.008zm0 2.25h.008v.008H16.5V15z" />
            </svg>
          </div>
          <div>
            <h2 class="text-lg font-bold text-gray-900">Mes Réservations</h2>
            <p class="text-gray-500 text-sm mt-1">Gérer vos séjours</p>
          </div>
        </router-link>

        <!-- Favoris -->
        <router-link to="/favorites" class="bg-white p-6 rounded-xl shadow-sm border border-gray-200 hover:shadow-md transition-shadow flex items-start gap-4">
          <div class="w-10 h-10 flex-shrink-0 bg-red-50 rounded-lg flex items-center justify-center text-red-600">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6">
              <path stroke-linecap="round" stroke-linejoin="round" d="M21 8.25c0-2.485-2.099-4.5-4.688-4.5-1.935 0-3.597 1.126-4.312 2.733-.715-1.607-2.377-2.733-4.313-2.733C5.1 3.75 3 5.765 3 8.25c0 7.22 9 12 9 12s9-4.78 9-12z" />
            </svg>
          </div>
          <div>
            <h2 class="text-lg font-bold text-gray-900">Favoris</h2>
            <p class="text-gray-500 text-sm mt-1">Annonces sauvegardées</p>
          </div>
        </router-link>

        <!-- Paramètres -->
        <router-link to="/account-settings" class="bg-white p-6 rounded-xl shadow-sm border border-gray-200 hover:shadow-md transition-shadow flex items-start gap-4">
          <div class="w-10 h-10 flex-shrink-0 bg-gray-100 rounded-lg flex items-center justify-center text-gray-600">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6">
              <path stroke-linecap="round" stroke-linejoin="round" d="M9.594 3.94c.09-.542.56-.94 1.11-.94h2.593c.55 0 1.02.398 1.11.94l.213 1.281c.063.374.313.686.645.87.074.04.147.083.22.127.324.196.72.257 1.075.124l1.217-.456a1.125 1.125 0 011.37.49l1.296 2.247a1.125 1.125 0 01-.26 1.431l-1.003.827c-.293.24-.438.613-.431.992a6.759 6.759 0 010 .255c-.007.378.138.75.43.99l1.005.828c.424.35.534.954.26 1.43l-1.298 2.247a1.125 1.125 0 01-1.369.491l-1.217-.456c-.355-.133-.75-.072-1.076.124a6.57 6.57 0 01-.22.128c-.331.183-.581.495-.644.869l-.212 1.28c-.09.543-.56.941-1.11.941h-2.594c-.55 0-1.02-.398-1.11-.94l-.213-1.281c-.062-.374-.312-.686-.644-.87a6.52 6.52 0 01-.22-.127c-.325-.196-.72-.257-1.076-.124l-1.217.456a1.125 1.125 0 01-1.369-.49l-1.297-2.247a1.125 1.125 0 01.26-1.431l1.004-.827c.292-.24.437-.613.43-.992a6.932 6.932 0 010-.255c.007-.378-.138-.75-.43-.99l-1.004-.828a1.125 1.125 0 01-.26-1.43l1.297-2.247a1.125 1.125 0 011.37-.491l1.216.456c.356.133.751.072 1.076-.124.072-.044.146-.087.22-.128.332-.183.582-.495.644-.869l.214-1.281z" />
              <path stroke-linecap="round" stroke-linejoin="round" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
            </svg>
          </div>
          <div>
            <h2 class="text-lg font-bold text-gray-900">Paramètres</h2>
            <p class="text-gray-500 text-sm mt-1">Infos privées</p>
          </div>
        </router-link>

        <!-- Sécurité -->
        <router-link to="/security" class="bg-white p-6 rounded-xl shadow-sm border border-gray-200 hover:shadow-md transition-shadow flex items-start gap-4">
          <div class="w-10 h-10 flex-shrink-0 bg-gray-100 rounded-lg flex items-center justify-center text-gray-600">
             <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6">
               <path stroke-linecap="round" stroke-linejoin="round" d="M16.5 10.5V6.75a4.5 4.5 0 10-9 0v3.75m-.75 11.25h10.5a2.25 2.25 0 002.25-2.25v-6.75a2.25 2.25 0 00-2.25-2.25H6.75a2.25 2.25 0 00-2.25 2.25v6.75a2.25 2.25 0 002.25 2.25z" />
             </svg>
          </div>
          <div>
            <h2 class="text-lg font-bold text-gray-900">Sécurité</h2>
            <p class="text-gray-500 text-sm mt-1">Connexion du compte</p>
          </div>
        </router-link>

        <!-- Gdpr -->
        <router-link to="/mes-donnees-personnelles" class="bg-white p-6 rounded-xl shadow-sm border border-gray-200 hover:shadow-md transition-shadow flex items-start gap-4">
          <div class="w-10 h-10 flex-shrink-0 bg-purple-50 rounded-lg flex items-center justify-center text-purple-600">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6">
              <path stroke-linecap="round" stroke-linejoin="round" d="M9 12h3.75M9 15h3.75M9 18h3.75m3 .75H18a2.25 2.25 0 002.25-2.25V6.108c0-1.135-.845-2.098-1.976-2.192a48.424 48.424 0 00-1.123-.08m-5.801 0c-.065.21-.1.433-.1.664 0 .414.336.75.75.75h4.5a.75.75 0 00.75-.75 2.25 2.25 0 00-.1-.664m-5.8 0A2.251 2.251 0 0113.5 2.25H15c1.012 0 1.867.668 2.15 1.586m-5.8 0c-.376.023-.75.05-1.124.08C9.095 4.01 8.25 4.973 8.25 6.108V8.25m0 0H4.875c-.621 0-1.125.504-1.125 1.125v11.25c0 .621.504 1.125 1.125 1.125h9.75c.621 0 1.125-.504 1.125-1.125V9.375c0-.621-.504-1.125-1.125-1.125H8.25zM6.75 12h.008v.008H6.75V12zm0 3h.008v.008H6.75V15zm0 3h.008v.008H6.75V18z" />
            </svg>
          </div>
          <div>
            <h2 class="text-lg font-bold text-gray-900">Données (RGPD)</h2>
            <p class="text-gray-500 text-sm mt-1">Consulter / Supprimer</p>
          </div>
        </router-link>

      </div>

      <div class="mt-8 flex justify-end md:justify-start">
        <button @click="handleLogout" class="px-6 py-2.5 border border-gray-900 text-gray-900 font-bold rounded-xl hover:bg-gray-100 transition-colors shadow-sm">
          Me déconnecter
        </button>
      </div>

    </main>
  </div>
</template>
