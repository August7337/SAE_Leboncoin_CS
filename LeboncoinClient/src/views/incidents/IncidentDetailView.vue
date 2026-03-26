<template>
  <div class="bg-[#f8f9fb] min-h-screen pb-12">
    <main class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-10">
      
      <div class="mb-8 flex justify-between items-center">
        <button @click="$router.back()" class="text-gray-500 hover:text-gray-900 font-medium flex items-center gap-2">
          <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
          </svg>
          Retour aux dossiers
        </button>
      </div>

      <div v-if="loading" class="text-center py-12">
        <div class="w-8 h-8 border-4 border-blue-200 border-t-blue-600 rounded-full animate-spin mx-auto"></div>
      </div>

      <div v-else-if="incident" class="space-y-6">
        
        <div>
          <h1 class="text-3xl font-black text-gray-900">Dossier de litige #{{ incident.idincident }}</h1>
          <p class="text-gray-500 mt-1">Ouvert le {{ incident.dateSignalement || 'Date inconnue' }}</p>
        </div>

        <div class="bg-white rounded-2xl border border-gray-200 p-6 shadow-sm">
          <h2 class="text-lg font-bold text-gray-900 mb-4 border-b pb-2">Informations Générales</h2>
          <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div>
              <p class="text-sm text-gray-500 font-medium">Motif du signalement</p>
              <p class="text-base font-bold text-gray-900 mt-1">{{ incident.motifincident }}</p>
            </div>
            <div>
              <p class="text-sm text-gray-500 font-medium">ID Réservation concernée</p>
              <p class="text-base font-bold text-gray-900 mt-1">#{{ incident.idreservation }}</p>
            </div>
            <div>
              <p class="text-sm text-gray-500 font-medium">ID Locataire (Plaignant)</p>
              <p class="text-base font-bold text-gray-900 mt-1">Utilisateur #{{ incident.idutilisateur }}</p>
            </div>
          </div>
        </div>

        <div class="bg-white rounded-2xl border border-gray-200 p-6 shadow-sm">
          <h2 class="text-lg font-bold text-gray-900 mb-4 border-b pb-2">Description du Locataire</h2>
          <p class="text-gray-700 whitespace-pre-line leading-relaxed">
            {{ incident.descriptionincident || "Aucune description fournie par le locataire." }}
          </p>
        </div>

        <div v-if="incident.explicationproprietaire" class="bg-white rounded-2xl border border-gray-200 p-6 shadow-sm">
          <h2 class="text-lg font-bold text-gray-900 mb-4 border-b pb-2">Explications du Propriétaire</h2>
          <p class="text-gray-700 whitespace-pre-line leading-relaxed">
            {{ incident.explicationproprietaire }}
          </p>
        </div>

        <div class="bg-white rounded-2xl border border-gray-200 p-6 shadow-sm">
          <h2 class="text-lg font-bold text-gray-900 mb-4 border-b pb-2">Preuves photographiques</h2>
          
          <div v-if="incident.photos && incident.photos.length > 0" class="grid grid-cols-2 md:grid-cols-4 gap-4">
            <div v-for="photo in incident.photos" :key="photo.idphoto" class="relative aspect-square">
              <img :src="buildAssetUrl(photo.urlphoto)" class="w-full h-full object-cover rounded-xl border border-gray-200" alt="Preuve" />
              <span class="absolute bottom-2 right-2 bg-black/70 text-white text-[10px] px-2 py-1 rounded-lg">
                {{ photo.originephoto === 1 ? 'Locataire' : 'Propriétaire' }}
              </span>
            </div>
          </div>
          <p v-else class="text-gray-500 italic text-sm">Aucune photo attachée à ce dossier.</p>
        </div>

        <div v-if="actionError" class="mb-4 bg-red-50 text-red-600 p-4 rounded-xl text-sm font-bold border border-red-100">
          {{ actionError }}
        </div>

        <div v-if="isAgentLocation && incident.statut.code === 'EN_ANALYSE_SERVICE_LOCATION'" class="bg-blue-50 rounded-2xl border border-blue-200 p-6 mt-8">
          <h2 class="text-lg font-black text-blue-900 mb-2">Décision du Service Location (Étape 1)</h2>
          <p class="text-sm text-blue-800 mb-6">En tant qu'agent en charge de ce dossier, quelle est la suite à donner ?</p>
          
          <div class="flex flex-col md:flex-row gap-4">
            <button 
              @click="classerSansSuite" 
              :disabled="isProcessing"
              class="flex-1 bg-white border-2 border-gray-300 text-gray-700 font-bold py-3 px-4 rounded-xl hover:bg-gray-50 hover:border-gray-400 transition-all disabled:opacity-50"
            >
              Classer sans suite (Fermer)
            </button>
            <button 
              @click="demanderExplications" 
              :disabled="isProcessing"
              class="flex-1 bg-blue-600 text-white font-bold py-3 px-4 rounded-xl shadow-lg shadow-blue-200 hover:bg-blue-700 transition-all disabled:opacity-50"
            >
              Demander des explications au propriétaire
            </button>
          </div>
        </div>

        <div v-if="isAgentLocation && incident.statut.code === 'EN_ATTENTE_EXPLICATION_PROPRIETAIRE'" class="bg-orange-50 rounded-2xl border border-orange-200 p-6 mt-8 text-center">
          <h2 class="text-lg font-black text-orange-900 mb-2">En attente du propriétaire</h2>
          <p class="text-sm text-orange-800">Une demande d'explication a été envoyée au propriétaire. Le dossier est bloqué jusqu'à sa réponse.</p>
        </div>

        <div v-if="isAgentLocation && incident.statut.code === 'EXPLICATION_PROPRIETAIRE_RECUE'" class="bg-blue-50 rounded-2xl border border-blue-200 p-6 mt-8">
          <h2 class="text-lg font-black text-blue-900 mb-2">Décision Finale (Étape 2)</h2>
          <p class="text-sm text-blue-800 mb-6">Le propriétaire a répondu. Veuillez prendre une décision finale pour ce litige.</p>
          
          <div class="flex flex-col md:flex-row gap-4">
            <button 
              @click="soumettreDecision('REFUS_REMBOURSEMENT')" 
              :disabled="isProcessing"
              class="flex-1 bg-white border-2 border-red-300 text-red-600 font-bold py-3 px-4 rounded-xl hover:bg-red-50 transition-all disabled:opacity-50"
            >
              Refuser le remboursement
            </button>
            <button 
              @click="soumettreDecision('REMBOURSEMENT_ACCEPTE')" 
              :disabled="isProcessing"
              class="flex-1 bg-green-600 text-white font-bold py-3 px-4 rounded-xl shadow-lg shadow-green-200 hover:bg-green-700 transition-all disabled:opacity-50"
            >
              Accepter le remboursement
            </button>
          </div>
        </div>

      </div>
    </main>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import api from '@/api/axios'
import { authState } from '@/auth'
import { buildAssetUrl } from '@/services/api'

const route = useRoute()
const router = useRouter()
const incident = ref(null)
const loading = ref(true)
const isProcessing = ref(false)
const actionError = ref('')

const isAgentLocation = computed(() => authState.hasPermission('dashboard.incidents.location'))

const loadIncident = async () => {
  try {
    const response = await api.get(`/Incidents/${route.params.id}`)
    incident.value = response.data
  } catch (error) {
    console.error("Erreur de chargement", error)
  } finally {
    loading.value = false
  }
}

const classerSansSuite = async () => {
  if (!confirm("Voulez-vous vraiment classer ce dossier sans suite ?")) return;
  isProcessing.value = true;
  actionError.value = '';
  try {
    await api.post(`/Incidents/${incident.value.idincident}/classe-sans-suite`);
    router.push({ name: 'location-dashboard' }); 
  } catch (error) {
    actionError.value = "Erreur lors du classement sans suite.";
    isProcessing.value = false;
  }
}

const demanderExplications = async () => {
  isProcessing.value = true;
  actionError.value = '';
  try {
    await api.post(`/Incidents/${incident.value.idincident}/demande-explication-proprietaire`);
    router.push({ name: 'location-dashboard' });
  } catch (error) {
    actionError.value = "Erreur lors de la demande d'explications.";
    isProcessing.value = false;
  }
}

const soumettreDecision = async (codeStatutCible) => {
  const libelle = codeStatutCible === 'REMBOURSEMENT_ACCEPTE' ? 'accepter' : 'refuser';
  if (!confirm(`Confirmez-vous vouloir ${libelle} le remboursement ?`)) return;
  
  isProcessing.value = true;
  actionError.value = '';
  try {
    await api.post(`/Incidents/${incident.value.idincident}/decision-service-location`, {
      codeStatutCible: codeStatutCible
    });
    router.push({ name: 'location-dashboard' });
  } catch (error) {
    actionError.value = "Erreur lors de la soumission de la décision.";
    isProcessing.value = false;
  }
}

onMounted(() => {
  loadIncident()
})
</script>