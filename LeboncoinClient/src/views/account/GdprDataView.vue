<template>
  <div class="min-h-screen bg-[#f5f5f5] py-10">
    <div class="max-w-4xl mx-auto px-4">
      
      <div class="flex flex-col md:flex-row items-start md:items-center justify-between mb-8 gap-4">
        <div>
          <h1 class="text-2xl font-black text-gray-900">Mes données personnelles (RGPD)</h1>
          <p class="text-sm text-gray-500 mt-1">Conformément à la réglementation, voici l'intégralité des données rattachées à votre compte.</p>
        </div>
        <button @click="demanderSuppression" :disabled="isDeleting" class="bg-red-100 text-red-700 hover:bg-red-200 font-bold py-2.5 px-5 rounded-xl transition-colors flex items-center gap-2">
          <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" class="w-5 h-5">
            <path stroke-linecap="round" stroke-linejoin="round" d="M14.74 9l-.346 9m-4.788 0L9.26 9m9.968-3.21c.342.052.682.107 1.022.166m-1.022-.165L18.16 19.673a2.25 2.25 0 01-2.244 2.077H8.084a2.25 2.25 0 01-2.244-2.077L4.772 5.79m14.456 0a48.108 48.108 0 00-3.478-.397m-12 .562c.34-.059.68-.114 1.022-.165m0 0a48.11 48.11 0 013.478-.397m7.5 0v-.916c0-1.18-.91-2.164-2.09-2.201a51.964 51.964 0 00-3.32 0c-1.18.037-2.09 1.022-2.09 2.201v.916m7.5 0a48.667 48.667 0 00-7.5 0" />
          </svg>
          {{ isDeleting ? 'Demande en cours...' : 'Demander la suppression' }}
        </button>
      </div>

      <div v-if="message.text" :class="message.type === 'success' ? 'bg-green-50 border-green-200 text-green-800' : 'bg-red-50 border-red-200 text-red-800'" class="p-4 rounded-xl border mb-6 text-sm font-medium">
        {{ message.text }}
      </div>

      <div v-if="isLoading" class="text-center py-12 text-gray-500 font-medium">
        Collecte de vos données en cours...
      </div>

      <div v-else-if="gdprData" class="space-y-6">
        
        <div class="bg-white rounded-3xl p-6 shadow-sm border border-gray-100">
          <h2 class="text-lg font-bold text-gray-900 mb-4 border-b pb-2">1. Informations de Profil</h2>
          <pre class="bg-gray-50 p-4 rounded-lg text-sm text-gray-700 overflow-x-auto">{{ JSON.stringify(gdprData.profil, null, 2) }}</pre>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
          <div class="bg-white rounded-3xl p-6 shadow-sm border border-gray-100">
            <h2 class="text-lg font-bold text-gray-900 mb-4 border-b pb-2">2. Annonces Publiées ({{ gdprData.annoncesPubliees.length }})</h2>
            <ul class="space-y-2 text-sm text-gray-600 list-disc list-inside">
              <li v-for="annonce in gdprData.annoncesPubliees" :key="annonce.idannonce">
                {{ annonce.titreannonce }} ({{ annonce.prixnuitee }}€)
              </li>
              <li v-if="!gdprData.annoncesPubliees.length" class="list-none italic">Aucune annonce publiée.</li>
            </ul>
          </div>

          <div class="bg-white rounded-3xl p-6 shadow-sm border border-gray-100">
            <h2 class="text-lg font-bold text-gray-900 mb-4 border-b pb-2">3. Favoris ({{ gdprData.favoris.length }})</h2>
            <ul class="space-y-2 text-sm text-gray-600 list-disc list-inside">
              <li v-for="favori in gdprData.favoris" :key="favori.idannonce">
                {{ favori.titreannonce }}
              </li>
              <li v-if="!gdprData.favoris.length" class="list-none italic">Aucun favori sauvegardé.</li>
            </ul>
          </div>
        </div>

        <div class="bg-white rounded-3xl p-6 shadow-sm border border-gray-100">
          <h2 class="text-lg font-bold text-gray-900 mb-4 border-b pb-2">4. Historique (Réservations & Transactions)</h2>
          <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div>
              <h3 class="font-bold text-sm text-gray-700 mb-2">Réservations ({{ gdprData.reservationsEffectuees.length }})</h3>
              <pre class="bg-gray-50 p-3 rounded-lg text-xs text-gray-700 overflow-x-auto">{{ JSON.stringify(gdprData.reservationsEffectuees, null, 2) }}</pre>
            </div>
            <div>
              <h3 class="font-bold text-sm text-gray-700 mb-2">Transactions ({{ gdprData.transactions.length }})</h3>
              <pre class="bg-gray-50 p-3 rounded-lg text-xs text-gray-700 overflow-x-auto">{{ JSON.stringify(gdprData.transactions, null, 2) }}</pre>
            </div>
          </div>
        </div>

        <div class="bg-white rounded-3xl p-6 shadow-sm border border-gray-100">
          <h2 class="text-lg font-bold text-gray-900 mb-4 border-b pb-2">5. Activité sur la plateforme</h2>
          <div class="space-y-4">
            <div>
              <h3 class="font-bold text-sm text-gray-700">Avis publiés ({{ gdprData.avisPublies.length }})</h3>
              <p class="text-xs text-gray-500" v-if="!gdprData.avisPublies.length">Aucun avis.</p>
            </div>
            <div>
              <h3 class="font-bold text-sm text-gray-700">Incidents signalés ({{ gdprData.incidentsSignales.length }})</h3>
              <p class="text-xs text-gray-500" v-if="!gdprData.incidentsSignales.length">Aucun incident.</p>
            </div>
            <div>
              <h3 class="font-bold text-sm text-gray-700">Recherches sauvegardées ({{ gdprData.recherchesSauvegardees.length }})</h3>
              <p class="text-xs text-gray-500" v-if="!gdprData.recherchesSauvegardees.length">Aucune recherche.</p>
            </div>
          </div>
        </div>

        <div class="bg-white rounded-3xl p-6 shadow-sm border border-gray-100">
          <h2 class="text-lg font-bold text-gray-900 mb-4 border-b pb-2">6. Messagerie</h2>
          <p class="text-sm text-gray-600">
            <strong>Envoyés :</strong> {{ gdprData.messagesEnvoyes.length }} messages<br>
            <strong>Reçus :</strong> {{ gdprData.messagesRecus.length }} messages
          </p>
        </div>

      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import api from '@/api/axios';
import { authState } from '@/auth.js';

const gdprData = ref(null);
const isLoading = ref(true);
const isDeleting = ref(false);
const message = ref({ text: '', type: '' });

onMounted(async () => {
  try {
    const userId = authState.user?.idutilisateur;
    if (!userId) return;

    const response = await api.get(`/Utilisateurs/${userId}/export-rgpd`);
    
    gdprData.value = response.data;
  } catch (error) {
    message.value = { text: "Erreur lors de la récupération de vos données.", type: 'error' };
    console.error(error);
  } finally {
    isLoading.value = false;
  }
});

const demanderSuppression = async () => {
  if(!confirm("Êtes-vous sûr de vouloir demander la suppression de toutes vos données ? Cette action enverra une demande à notre DPO.")) return;
  
  isDeleting.value = true;
  message.value = { text: '', type: '' };

  try {
    const userId = authState.user?.idutilisateur;
    const response = await api.post(`/Utilisateurs/${userId}/demande-suppression`, {});
    message.value = { text: response.data.message || "Votre demande a bien été envoyée.", type: 'success' };
  } catch (error) {
    message.value = { 
        text: error.response?.data?.message || "Une erreur est survenue, ou une demande est déjà en cours.", 
        type: 'error' 
    };
  } finally {
    isDeleting.value = false;
  }
};
</script>