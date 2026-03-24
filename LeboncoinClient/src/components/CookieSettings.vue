<template>
  <div v-if="cookieState.showSettings" class="fixed inset-0 z-[60]" role="dialog" aria-modal="true">
    <div class="absolute inset-0 bg-black/50 transition-opacity" @click="closeCookieSettings"></div>

    <div class="relative min-h-screen flex items-center justify-center p-4">
      <div class="bg-white rounded-xl shadow-2xl max-w-2xl w-full max-h-[90vh] overflow-y-auto flex flex-col">
        
        <div class="p-6 border-b border-gray-100 flex items-center justify-between sticky top-0 bg-white z-10">
          <h2 class="text-xl font-bold text-gray-900">Préférences de cookies</h2>
          <button @click="closeCookieSettings" class="text-gray-400 hover:text-gray-600 p-2">
            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg>
          </button>
        </div>

        <div class="p-6 space-y-6">
          <p class="text-sm text-gray-600">
            Lorsque vous naviguez sur notre site, des cookies sont déposés sur votre navigateur. Vous pouvez ici personnaliser vos consentements pour chaque catégorie ou chaque cookie spécifique.
          </p>

          <div class="flex items-center justify-between p-4 bg-orange-50 rounded-lg border border-orange-100 mb-6">
            <div>
              <h3 class="font-bold text-gray-900">Activer toutes les fonctionnalités optionnelles</h3>
              <p class="text-xs text-orange-800">Cochez pour activer Google Maps et le Chatbot.</p>
            </div>
            <label class="relative inline-flex items-center cursor-pointer">
              <input type="checkbox" v-model="toggleAll" class="sr-only peer">
              <div class="w-11 h-6 bg-gray-200 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-orange-300 rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-orange-600"></div>
            </label>
          </div>

          <button @click="showDetails = !showDetails" class="flex items-center justify-between w-full text-left text-gray-700 hover:text-orange-600 font-semibold focus:outline-none transition-colors">
            <span>Visualiser tous les cookies (Détails)</span>
            <svg class="w-5 h-5 transform transition-transform" :class="{'rotate-180': showDetails}" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"></path></svg>
          </button>

          <div v-show="showDetails" class="space-y-4 border-l-2 border-gray-100 pl-4 mt-2">
            
            <div class="pt-2">
              <h4 class="text-sm font-bold text-gray-500 uppercase tracking-wider mb-2">Techniques & Strictement Nécessaires</h4>
              <div class="flex items-center justify-between py-2 border-b border-gray-50">
                <div>
                  <p class="font-medium text-gray-900">Session Leboncoin & Sécurité (CSRF)</p>
                  <p class="text-xs text-gray-500">Maintien de la connexion et protection des formulaires.</p>
                </div>
                <input type="checkbox" checked disabled class="text-gray-400 rounded cursor-not-allowed">
              </div>
            </div>

            <div class="pt-4">
              <h4 class="text-sm font-bold text-orange-500 uppercase tracking-wider mb-2">Fonctionnalités & Tiers</h4>
              
              <div class="flex items-center justify-between py-2 border-b border-gray-50">
                <div>
                  <p class="font-medium text-gray-900">Google Maps</p>
                  <p class="text-xs text-gray-500">Affichage de cartes interactives.</p>
                </div>
                <label class="relative inline-flex items-center cursor-pointer">
                  <input type="checkbox" v-model="localPreferences.maps" class="sr-only peer">
                  <div class="w-9 h-5 bg-gray-200 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-orange-300 rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-4 after:w-4 after:transition-all peer-checked:bg-orange-600"></div>
                </label>
              </div>

              <div class="flex items-center justify-between py-2 border-b border-gray-50">
                <div>
                  <p class="font-medium text-gray-900">Assistant Leboncoin</p>
                  <p class="text-xs text-gray-500">Chatbot et support (Stockage Local).</p>
                </div>
                <label class="relative inline-flex items-center cursor-pointer">
                  <input type="checkbox" v-model="localPreferences.chatbot" class="sr-only peer">
                  <div class="w-9 h-5 bg-gray-200 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-orange-300 rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-4 after:w-4 after:transition-all peer-checked:bg-orange-600"></div>
                </label>
              </div>
            </div>

          </div>
        </div>

        <div class="p-6 border-t border-gray-100 flex flex-col sm:flex-row justify-end gap-3 sticky bottom-0 bg-white z-10">
          <button @click="rejectAll" class="px-5 py-2.5 rounded-lg border border-gray-300 text-gray-700 font-bold hover:bg-gray-50 transition-colors">
            Tout refuser
          </button>
          <button @click="savePreferences" class="px-5 py-2.5 rounded-lg bg-orange-600 text-white font-bold hover:bg-orange-700 shadow-sm transition-colors">
            Enregistrer mes choix
          </button>
        </div>

      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, watch } from 'vue';
import { cookieState, saveCookiePreferences, closeCookieSettings, rejectAll } from '@/cookieManager.js';

const showDetails = ref(false);

const localPreferences = ref({ ...cookieState.preferences });

watch(() => cookieState.showSettings, (newVal) => {
  if (newVal) localPreferences.value = { ...cookieState.preferences };
});

const toggleAll = computed({
  get: () => localPreferences.value.maps && localPreferences.value.chatbot,
  set: (val) => {
    localPreferences.value.maps = val;
    localPreferences.value.chatbot = val;
  }
});

const savePreferences = () => {
  saveCookiePreferences(localPreferences.value);
};
</script>