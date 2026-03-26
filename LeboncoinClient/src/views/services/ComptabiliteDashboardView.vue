<template>
  <div class="bg-[#f8f9fb] min-h-screen pb-12">
    <main class="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 py-10">
      <div class="mb-8">
        <h1 class="text-3xl font-bold text-gray-900">Dashboard - Service Comptabilité</h1>
        <p class="text-gray-500 mt-2">Validation des remboursements</p>
      </div>

      <div v-if="loading" class="text-center py-12">
        <div class="inline-block">
          <div class="w-8 h-8 border-4 border-blue-200 border-t-blue-600 rounded-full animate-spin"></div>
        </div>
      </div>

      <div v-else-if="error" class="bg-red-50 border border-red-200 rounded-lg p-4 mb-6">
        <p class="text-red-700">{{ error }}</p>
      </div>

      <div v-else class="space-y-6">
        <div class="bg-blue-50 border border-blue-200 rounded-lg p-5 mb-6">
          <p class="text-blue-900 font-bold text-lg">
            {{ remboursements.length }} remboursement{{ remboursements.length > 1 ? 's' : '' }} en attente
          </p>
        </div>

        <div v-if="remboursements.length === 0" class="bg-white rounded-lg p-8 text-center border border-gray-200">
          <p class="text-gray-500">Aucun remboursement à valider.</p>
        </div>

        <div v-for="incident in remboursements" :key="incident.idincident" class="bg-white rounded-lg border border-gray-200 p-6 hover:shadow-md transition-shadow">
          <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
            <div>
              <h3 class="font-bold text-lg text-gray-900 mb-2">#{{ incident.idincident }}</h3>
              <div class="space-y-2 text-sm text-gray-600">
                <p><span class="font-semibold">Motif:</span> {{ incident.motifincident || 'Non spécifié' }}</p>
                <p><span class="font-semibold">Locataire ID:</span> {{ incident.idutilisateur }}</p>
                <p><span class="font-semibold">Réservation ID:</span> {{ incident.idreservation }}</p>
              </div>
            </div>

            <div>
              <div class="bg-green-50 border border-green-200 rounded-lg p-4">
                <p class="text-xs text-green-600 mb-1">STATUS</p>
                <p class="font-bold text-green-700">{{ incident.statut.libelle }}</p>
              </div>
            </div>
          </div>

          <div v-if="incident.descriptionincident" class="mb-6 p-4 bg-gray-50 rounded-lg">
            <p class="text-xs font-semibold text-gray-600 mb-2">DESCRIPTION</p>
            <p class="text-sm text-gray-700">{{ incident.descriptionincident }}</p>
          </div>

          <div class="flex gap-3">
            <button
              @click="validerRemboursement(incident)"
              class="flex-1 bg-green-600 text-white py-2 px-4 rounded-lg font-medium hover:bg-green-700 transition-colors"
            >
              Valider le remboursement
            </button>
            <button
              @click="goToDetail(incident.idincident)"
              class="flex-1 border border-gray-300 text-gray-700 py-2 px-4 rounded-lg font-medium hover:bg-gray-50 transition-colors"
            >
              Voir détails
            </button>
          </div>
        </div>
      </div>
    </main>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import incidentsService from '@/services/incidentsService'

const router = useRouter()
const incidents = ref([])
const loading = ref(true)
const error = ref(null)

const remboursements = computed(() => {
  return incidents.value.filter(i => i.statut.code === 'REMBOURSEMENT_ACCEPTE')
})

const validerRemboursement = async (incident) => {
  try {
    await incidentsService.validerRemboursement(incident.idincident)
    await loadIncidents()
  } catch (err) {
    error.value = err.message || 'Erreur lors de la validation'
  }
}

const goToDetail = (id) => {
  router.push({ name: 'incident-detail', params: { id } })
}

const loadIncidents = async () => {
  try {
    loading.value = true
    incidents.value = await incidentsService.getMesIncidents()
  } catch (err) {
    error.value = err.message || 'Erreur lors du chargement'
    console.error(err)
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  loadIncidents()
})
</script>
