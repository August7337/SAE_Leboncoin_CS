<template>
  <transition
    enter-active-class="transition ease-out duration-300 transform"
    enter-from-class="translate-y-full opacity-0"
    enter-to-class="translate-y-0 opacity-100"
    leave-active-class="transition ease-in duration-200 transform"
    leave-from-class="translate-y-0 opacity-100"
    leave-to-class="translate-y-full opacity-0"
  >
    <div v-if="!cookieState.hasAnswered" class="fixed bottom-0 left-0 right-0 z-50 p-4 md:p-6 bg-white shadow-[0_-4px_6px_-1px_rgba(0,0,0,0.1)] border-t border-gray-100">
      <div class="max-w-7xl mx-auto flex flex-col md:flex-row items-center justify-between gap-6">
        
        <div class="flex-1">
          <h2 class="text-lg font-bold text-gray-900 mb-2">Votre vie privée nous importe</h2>
          <p class="text-sm text-gray-600">
            Chez Leboncoin, nous utilisons des cookies pour assurer le bon fonctionnement de nos services,
            mesurer l'audience et vous proposer des fonctionnalités sociales. Vous pouvez tout accepter, tout refuser ou
            personnaliser vos choix. 
            <router-link to="/politique-cookies" class="text-orange-600 hover:text-orange-700 underline font-medium">
              Voir notre politique de cookies
            </router-link>.
          </p>
        </div>

        <div class="flex flex-col sm:flex-row items-center gap-3 shrink-0 w-full md:w-auto">
          <button @click="rejectAll" class="w-full sm:w-auto px-6 py-2.5 rounded-lg border-2 border-orange-600 text-orange-600 font-bold hover:bg-orange-50 transition-colors">
            Tout refuser
          </button>
          <button @click="openCookieSettings" class="w-full sm:w-auto px-6 py-2.5 rounded-lg border border-gray-300 text-gray-700 font-bold hover:bg-gray-50 transition-colors">
            Paramétrer
          </button>
          <button @click="acceptAll" class="w-full sm:w-auto px-6 py-2.5 rounded-lg bg-orange-600 text-white font-bold hover:bg-orange-700 shadow-sm transition-colors">
            Tout accepter
          </button>
        </div>

      </div>
    </div>
  </transition>
</template>

<script setup>
import { cookieState, acceptAll, rejectAll, openCookieSettings } from '@/cookieManager.js';
</script>