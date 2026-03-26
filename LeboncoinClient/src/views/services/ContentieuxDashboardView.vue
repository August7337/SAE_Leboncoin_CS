<template>
  <div class="bg-[#f8f9fb] min-h-screen pb-12">
    <main class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10">
      <div class="mb-8">
        <h1 class="text-3xl font-bold text-gray-900">Dashboard - Service Contentieux</h1>
        <p class="text-gray-500 mt-2">Litiges en attente de décision juridique</p>
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
        <div class="bg-red-50 border border-red-200 rounded-lg p-5 mb-6">
          <p class="text-red-900 font-bold text-lg">
            {{ litiges.length }} litige{{ litiges.length > 1 ? 's' : '' }} en attente
          </p>
        </div>

        <div v-if="litiges.length === 0" class="bg-white rounded-lg p-8 text-center border border-gray-200">
          <p class="text-gray-500">Aucun litige à traiter.</p>
        </div>

        <div v-for="incident in litiges" :key="incident.idincident" class="bg-white rounded-lg border border-gray-200 overflow-hidden">
          <div class="p-6 border-b border-gray-200">
            <div class="flex justify-between items-start mb-4">
              <div>
                <h3 class="font-bold text-lg text-gray-900 mb-2">#{{ incident.idincident }}</h3>
                <div class="grid grid-cols-2 gap-4 text-sm text-gray-600">
                  <p><span class="font-semibold">Motif:</span> {{ incident.motifincident || 'Non spécifié' }}</p>
                  <p><span class="font-semibold">Réservation:</span> {{ incident.idreservation }}</p>
                </div>
              </div>
              <div class="bg-red-50 border border-red-200 rounded-lg p-3">
                <p class="text-xs text-red-600 mb-1">STATUS</p>
                <p class="font-bold text-red-700">{{ incident.statut.libelle }}</p>
              </div>
            </div>

            <div v-if="incident.descriptionincident" class="p-4 bg-gray-50 rounded-lg">
              <p class="text-xs font-semibold text-gray-600 mb-2">DESCRIPTION</p>
              <p class="text-sm text-gray-700">{{ incident.descriptionincident }}</p>
            </div>
          </div>

          <div class="grid grid-cols-1 md:grid-cols-2 bg-gray-50">
            <div class="p-6 border-r border-gray-200 md:border-r md:border-gray-200">
              <h4 class="font-bold text-gray-900 mb-4">Photos du Locataire</h4>
              <div v-if="getPhotosByOrigin(incident, 'Locataire').length" class="space-y-4">
                <div v-for="photo in getPhotosByOrigin(incident, 'Locataire')" :key="photo.idphoto" class="cursor-pointer">
                  <img
                    :src="buildAssetUrl(photo.urlphoto)"
                    :alt="`Photo ${photo.idphoto}`"
                    class="w-full h-48 object-cover rounded-lg border border-gray-300 hover:shadow-md transition-shadow"
                    @click="openPhotoModal(photo)"
                  />
                </div>
              </div>
              <div v-else class="text-center py-8 text-gray-500">
                <p>Aucune photo fournie</p>
              </div>
            </div>

            <div class="p-6">
              <h4 class="font-bold text-gray-900 mb-4">Photos du Propriétaire</h4>
              <div v-if="getPhotosByOrigin(incident, 'Proprietaire').length" class="space-y-4">
                <div v-for="photo in getPhotosByOrigin(incident, 'Proprietaire')" :key="photo.idphoto" class="cursor-pointer">
                  <img
                    :src="buildAssetUrl(photo.urlphoto)"
                    :alt="`Photo ${photo.idphoto}`"
                    class="w-full h-48 object-cover rounded-lg border border-gray-300 hover:shadow-md transition-shadow"
                    @click="openPhotoModal(photo)"
                  />
                </div>
              </div>
              <div v-else class="text-center py-8 text-gray-500">
                <p>Aucune photo fournie</p>
              </div>
            </div>
          </div>

          <div class="p-6 border-t border-gray-200 flex gap-3">
            <button
              @click="prondreDecision(incident, 'CLOTURE_SANS_REMBOURSEMENT')"
              class="flex-1 bg-green-600 text-white py-2 px-4 rounded-lg font-medium hover:bg-green-700 transition-colors"
            >
              Clôturer (Raison Propriétaire)
            </button>
            <button
              @click="prondreDecision(incident, 'PROCEDURE_JURIDIQUE_ENGAGEE')"
              class="flex-1 bg-orange-600 text-white py-2 px-4 rounded-lg font-medium hover:bg-orange-700 transition-colors"
            >
              Procédure Juridique
            </button>
            <button
              @click="goToDetail(incident.idincident)"
              class="flex-1 border border-gray-300 text-gray-700 py-2 px-4 rounded-lg font-medium hover:bg-gray-50 transition-colors"
            >
              Détails complets
            </button>
          </div>
        </div>
      </div>
    </main>

    <div v-if="selectedPhoto" class="fixed inset-0 bg-black bg-opacity-75 flex items-center justify-center p-4 z-50" @click="selectedPhoto = null">
      <div class="bg-white rounded-lg max-w-2xl w-full max-h-screen overflow-auto" @click.stop>
        <div class="sticky top-0 bg-white border-b border-gray-200 p-4 flex justify-between items-center">
          <p class="text-sm font-semibold text-gray-600">{{ selectedPhoto.originephoto === 1 ? 'Photo Locataire' : 'Photo Propriétaire' }}</p>
          <button @click="selectedPhoto = null" class="text-gray-400 hover:text-gray-600">
            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
            </svg>
          </button>
        </div>
        <img :src="buildAssetUrl(selectedPhoto.urlphoto)" :alt="selectedPhoto.idphoto" class="w-full" />
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import incidentsService from '@/services/incidentsService'
import { buildAssetUrl } from '@/services/api'

const router = useRouter()
const incidents = ref([])
const loading = ref(true)
const error = ref(null)
const selectedPhoto = ref(null)

const litiges = computed(() => {
  return incidents.value.filter(i => i.statut.code === 'TRANSFERE_CONTENTIEUX')
})

const getPhotosByOrigin = (incident, origin) => {
  if (!incident.photos) return []
  const originCode = origin === 'Locataire' ? 1 : 2
  return incident.photos.filter(p => p.originephoto === originCode)
}

const prondreDecision = async (incident, codeStatut) => {
  try {
    await incidentsService.decisionContentieux(incident.idincident, codeStatut)
    await loadIncidents()
  } catch (err) {
    error.value = err.message || 'Erreur lors de la prise de décision'
  }
}

const goToDetail = (id) => {
  router.push({ name: 'incident-detail', params: { id } })
}

const openPhotoModal = (photo) => {
  selectedPhoto.value = photo
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
