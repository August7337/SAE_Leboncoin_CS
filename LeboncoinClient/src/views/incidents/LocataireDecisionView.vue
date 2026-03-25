<template>
  <div class="bg-[#f8f9fb] min-h-screen pb-12">
    <main class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-10">
      <div class="mb-8">
        <button
          @click="$router.back()"
          class="text-blue-600 hover:text-blue-800 font-medium mb-4 flex items-center gap-2"
        >
          <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
          </svg>
          Retour
        </button>
        <h1 class="text-3xl font-bold text-gray-900">Décision de remboursement</h1>
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
        <div class="bg-orange-50 border border-orange-300 rounded-lg p-6 mb-6">
          <h2 class="text-lg font-bold text-orange-900 mb-2">Remboursement refusé par le Service Location</h2>
          <p class="text-orange-700 mb-4">
            Le Service Location a examiné votre dossier et a décidé de <strong>ne pas accorder le remboursement</strong>.
            Vous pouvez accepter cette décision ou la contester auprès du Service Contentieux.
          </p>
        </div>

        <div v-if="incident?.descriptionincident" class="bg-white rounded-lg border border-gray-200 p-6">
          <h3 class="font-bold text-gray-900 mb-3">Détails du litige</h3>
          <p class="text-gray-700 text-sm">{{ incident.descriptionincident }}</p>
        </div>

        <div class="bg-yellow-50 border border-yellow-200 rounded-lg p-5">
          <p class="text-yellow-800 font-medium text-sm">
            ⚠️ Important : Si vous contestez la décision, votre dossier sera transmis au Service Contentieux pour arbitrage final. Cette action est irréversible.
          </p>
        </div>

        <div class="flex gap-4">
          <button
            @click="accepterDecision"
            :disabled="isSubmitting"
            class="flex-1 bg-gray-600 text-white py-3 px-6 rounded-lg font-medium hover:bg-gray-700 transition-colors disabled:opacity-50"
          >
            {{ isSubmitting ? 'Traitement...' : '✓ Accepter la décision' }}
          </button>
          <button
            @click="contesterDecision"
            :disabled="isSubmitting"
            class="flex-1 bg-orange-600 text-white py-3 px-6 rounded-lg font-medium hover:bg-orange-700 transition-colors disabled:opacity-50"
          >
            {{ isSubmitting ? 'Traitement...' : '⚖ Contester la décision' }}
          </button>
        </div>

        <button
          @click="$router.back()"
          class="w-full border border-gray-300 text-gray-700 py-2 px-4 rounded-lg font-medium hover:bg-gray-50 transition-colors"
        >
          Annuler
        </button>
      </div>
    </main>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import incidentsService from '@/services/incidentsService'

const route = useRoute()
const router = useRouter()
const incidentId = route.params.id

const incident = ref(null)
const loading = ref(true)
const error = ref(null)
const isSubmitting = ref(false)

const accepterDecision = async () => {
  try {
    isSubmitting.value = true
    error.value = null
    await incidentsService.decisionLocataire(incidentId, 'CLOTURE_SANS_REMBOURSEMENT')
    router.push({ name: 'incident-timeline', params: { id: incidentId } })
  } catch (err) {
    error.value = err.message || 'Erreur lors de la soumission'
  } finally {
    isSubmitting.value = false
  }
}

const contesterDecision = async () => {
  try {
    isSubmitting.value = true
    error.value = null
    await incidentsService.decisionLocataire(incidentId, 'TRANSFERE_CONTENTIEUX')
    router.push({ name: 'incident-timeline', params: { id: incidentId } })
  } catch (err) {
    error.value = err.message || 'Erreur lors de la soumission'
  } finally {
    isSubmitting.value = false
  }
}

const loadIncident = async () => {
  try {
    loading.value = true
    incident.value = await incidentsService.getById(incidentId)
  } catch (err) {
    error.value = err.message || 'Erreur lors du chargement'
    console.error(err)
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  loadIncident()
})
</script>
