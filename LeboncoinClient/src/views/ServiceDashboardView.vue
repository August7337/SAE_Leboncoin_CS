<template>
  <div class="bg-[#f8f9fb] min-h-screen pb-12">
    <main class="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 py-10">
      <div class="mb-10">
        <h1 class="text-4xl font-bold text-gray-900">Dashboard</h1>
        <p class="text-gray-600 mt-2">Bienvenue, {{ authState.user?.pseudonyme }}</p>
      </div>

      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        <div
          v-if="authState.hasPermission('dashboard.incidents.location')"
          @click="navigateTo('location-dashboard')"
          class="group cursor-pointer bg-white rounded-lg border border-gray-200 p-8 hover:shadow-lg hover:border-orange-400 transition-all"
        >
          <div class="flex items-center justify-between mb-4">
            <div class="w-14 h-14 bg-orange-100 rounded-lg flex items-center justify-center group-hover:bg-orange-200 transition-colors">
              <svg class="w-7 h-7 text-orange-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m7.5-1.5a7.5 7.5 0 11-15 0 7.5 7.5 0 0115 0z" />
              </svg>
            </div>
            <svg class="w-6 h-6 text-gray-400 group-hover:text-orange-600 transition-colors" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
            </svg>
          </div>
          <h3 class="text-xl font-bold text-gray-900 mb-2">Dossiers Locataires</h3>
          <p class="text-gray-600 text-sm">Gérez les litiges et les dossiers des locataires</p>
        </div>

        <div
          v-if="authState.hasPermission('dashboard.incidents.comptabilite')"
          @click="navigateTo('comptabilite-dashboard')"
          class="group cursor-pointer bg-white rounded-lg border border-gray-200 p-8 hover:shadow-lg hover:border-green-400 transition-all"
        >
          <div class="flex items-center justify-between mb-4">
            <div class="w-14 h-14 bg-green-100 rounded-lg flex items-center justify-center group-hover:bg-green-200 transition-colors">
              <svg class="w-7 h-7 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
              </svg>
            </div>
            <svg class="w-6 h-6 text-gray-400 group-hover:text-green-600 transition-colors" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
            </svg>
          </div>
          <h3 class="text-xl font-bold text-gray-900 mb-2">Remboursements</h3>
          <p class="text-gray-600 text-sm">Validez et traitez les remboursements approuvés</p>
        </div>

        <div
          v-if="authState.hasPermission('dashboard.incidents.contentieux')"
          @click="navigateTo('contentieux-dashboard')"
          class="group cursor-pointer bg-white rounded-lg border border-gray-200 p-8 hover:shadow-lg hover:border-red-400 transition-all"
        >
          <div class="flex items-center justify-between mb-4">
            <div class="w-14 h-14 bg-red-100 rounded-lg flex items-center justify-center group-hover:bg-red-200 transition-colors">
              <svg class="w-7 h-7 text-red-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z" />
              </svg>
            </div>
            <svg class="w-6 h-6 text-gray-400 group-hover:text-red-600 transition-colors" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
            </svg>
          </div>
          <h3 class="text-xl font-bold text-gray-900 mb-2">Litiges Contentieux</h3>
          <p class="text-gray-600 text-sm">Traitez les dossiers en contentieux et procédures juridiques</p>
        </div>

        <div
          v-if="authState.hasPermission('app.view.home')"
          @click="navigateTo('home')"
          class="group cursor-pointer bg-white rounded-lg border border-gray-200 p-8 hover:shadow-lg hover:border-purple-400 transition-all"
        >
          <div class="flex items-center justify-between mb-4">
            <div class="w-14 h-14 bg-purple-100 rounded-lg flex items-center justify-center group-hover:bg-purple-200 transition-colors">
              <svg class="w-7 h-7 text-purple-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-3m0 0l7-4 7 4M5 9v10a1 1 0 001 1h12a1 1 0 001-1V9m-9 16l7-4m-7 4l-7-4m7 4v-10" />
              </svg>
            </div>
            <svg class="w-6 h-6 text-gray-400 group-hover:text-purple-600 transition-colors" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
            </svg>
          </div>
          <h3 class="text-xl font-bold text-gray-900 mb-2">Accueil Public</h3>
          <p class="text-gray-600 text-sm">Explorez les annonces disponibles sur la plateforme</p>
        </div>
      </div>
    </main>
  </div>
</template>

<script setup>
import { authState } from '@/auth'
import { useRouter } from 'vue-router'

const router = useRouter()

const navigateTo = (route) => {
  router.push({ name: route })
}
</script>
