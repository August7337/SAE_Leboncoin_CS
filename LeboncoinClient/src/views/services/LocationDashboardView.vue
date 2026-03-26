<template>
  <div class="bg-[#f8f9fb] min-h-screen pb-12">
    <main class="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 py-10">
      <div class="mb-8 flex justify-between items-center">
        <div>
          <h1 class="text-3xl font-bold text-gray-900">Dashboard - Service Location</h1>
          <p class="text-gray-500 mt-2">Gestion des incidents et dossiers</p>
        </div>
        <button
          @click="$router.push({ name: 'service-dashboard' })"
          class="text-blue-600 hover:text-blue-800 font-medium flex items-center gap-2"
        >
          <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
          </svg>
          Retour dashboard
        </button>
      </div>

      <div class="flex border-b border-gray-200 mb-6 gap-4">
        <button
          @click="activeTab = 'aTraiter'"
          :class="[
            'px-6 py-3 font-medium text-sm border-b-2 transition-all',
            activeTab === 'aTraiter'
              ? 'border-blue-600 text-blue-600'
              : 'border-transparent text-gray-600 hover:text-gray-900'
          ]"
        >
          À traiter (Les plus anciens en premier)
          <span v-if="aTraiterCount > 0" class="ml-2 bg-red-500 text-white text-xs px-2 py-1 rounded-full">
            {{ aTraiterCount }}
          </span>
        </button>
        <button
          @click="activeTab = 'mesDossiers'"
          :class="[
            'px-6 py-3 font-medium text-sm border-b-2 transition-all',
            activeTab === 'mesDossiers'
              ? 'border-blue-600 text-blue-600'
              : 'border-transparent text-gray-600 hover:text-gray-900'
          ]"
        >
          Mes dossiers en cours
          <span v-if="mesDossiersCount > 0" class="ml-2 bg-blue-500 text-white text-xs px-2 py-1 rounded-full">
            {{ mesDossiersCount }}
          </span>
        </button>
      </div>

      <div v-if="loading" class="text-center py-12">
        <div class="w-8 h-8 border-4 border-blue-200 border-t-blue-600 rounded-full animate-spin mx-auto"></div>
      </div>

      <div v-else-if="error" class="bg-red-50 border border-red-200 rounded-lg p-4 mb-6">
        <p class="text-red-700">{{ error }}</p>
      </div>

      <div v-else>
        <div v-if="activeTab === 'aTraiter'" class="space-y-4">
          <div v-if="aTraiterIncidents.length === 0" class="bg-blue-50 border border-blue-200 rounded-lg p-8 text-center">
            <p class="text-blue-900 font-medium">Aucun incident à traiter</p>
          </div>

          <div v-for="incident in aTraiterIncidents" :key="incident.idincident" class="bg-white rounded-lg border border-gray-200 p-5 hover:shadow-md transition-shadow">
            <div class="flex justify-between items-start mb-3">
              <div>
                <h3 class="font-bold text-lg text-gray-900">Dossier #{{ incident.idincident }}</h3>
                <p class="text-sm text-gray-600">Date de signalement : {{ incident.dateSignalement || 'Inconnue' }}</p>
              </div>
              <span class="inline-block bg-red-100 text-red-800 text-xs font-semibold px-3 py-1 rounded-full">
                Nouveau
              </span>
            </div>

            <p class="text-sm text-gray-700 mb-3 font-medium">Motif: {{ incident.motifincident }}</p>

            <div class="flex gap-2">
              <button @click="prendreEnCharge(incident)" class="flex-1 bg-blue-600 text-white py-2 px-4 rounded-lg font-medium text-sm hover:bg-blue-700 transition-colors">
                Prendre en charge
              </button>
            </div>
          </div>
        </div>

        <div v-else class="space-y-4">
          <div v-if="mesDossiersIncidents.length === 0" class="bg-white rounded-lg p-8 text-center border border-gray-200">
            <p class="text-gray-500">Vous n'avez aucun dossier en cours.</p>
          </div>

          <div v-for="incident in mesDossiersIncidents" :key="incident.idincident" class="bg-white rounded-lg border border-gray-200 p-5 hover:shadow-md transition-shadow">
            <div class="flex justify-between items-start mb-3">
              <div>
                <h3 class="font-bold text-lg text-gray-900">Dossier #{{ incident.idincident }}</h3>
                <p class="text-sm text-gray-600">Date de signalement : {{ incident.dateSignalement || 'Inconnue' }}</p>
              </div>
              
              <span class="inline-block px-3 py-1 rounded-full text-xs font-semibold"
                    :class="{
                      'bg-blue-100 text-blue-800': incident.statut.code === 'EN_ANALYSE_SERVICE_LOCATION',
                      'bg-orange-100 text-orange-800': incident.statut.code === 'EN_ATTENTE_EXPLICATION_PROPRIETAIRE',
                      'bg-green-100 text-green-800': incident.statut.code === 'EXPLICATION_PROPRIETAIRE_RECUE'
                    }">
                {{ incident.statut.libelle }}
              </span>
            </div>

            <p class="text-sm text-gray-700 mb-4 font-medium">Motif: {{ incident.motifincident }}</p>

            <div class="flex gap-2">
              <button @click="goToDetail(incident.idincident)" class="w-full bg-gray-900 text-white py-2 px-4 rounded-lg font-medium text-sm hover:bg-black transition-colors">
                Ouvrir le dossier
              </button>
            </div>
          </div>
        </div>
      </div>
    </main>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { authState } from '@/auth'
import api from '@/api/axios'

const router = useRouter()
const activeTab = ref('aTraiter')
const incidents = ref([])
const loading = ref(true)
const error = ref(null)

const aTraiterIncidents = computed(() => {
  return incidents.value
    .filter(i => i.statut.code === 'SIGNALE' && !i.idagentAssigne)
    .sort((a, b) => a.idincident - b.idincident)
})

const mesDossiersIncidents = computed(() => {
  // On inclut TOUS les états où l'agent a encore un rôle à jouer ou attend une réponse
  const statutsActifs = [
    'EN_ANALYSE_SERVICE_LOCATION',
    'EN_ATTENTE_EXPLICATION_PROPRIETAIRE',
    'EXPLICATION_PROPRIETAIRE_RECUE'
  ]
  return incidents.value
    .filter(i => statutsActifs.includes(i.statut.code) && i.idagentAssigne === authState.user?.idutilisateur)
    .sort((a, b) => a.idincident - b.idincident)
})

const aTraiterCount = computed(() => aTraiterIncidents.value.length)
const mesDossiersCount = computed(() => mesDossiersIncidents.value.length)

const loadIncidents = async () => {
  try {
    loading.value = true
    const response = await api.get('/Incidents/mes-incidents')
    incidents.value = response.data
  } catch (err) {
    error.value = 'Erreur lors du chargement des incidents'
    console.error(err)
  } finally {
    loading.value = false
  }
}

const prendreEnCharge = async (incident) => {
  try {
    await api.post(`/Incidents/${incident.idincident}/prise-en-charge`)
    await loadIncidents()
    activeTab.value = 'mesDossiers'
  } catch (err) {
    error.value = 'Erreur lors de la prise en charge'
  }
}

const goToDetail = (id) => {
  router.push({ name: 'incident-detail', params: { id } })
}

onMounted(() => {
  loadIncidents()
})
</script>