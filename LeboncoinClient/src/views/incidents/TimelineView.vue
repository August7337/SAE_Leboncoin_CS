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
        <h1 class="text-3xl font-bold text-gray-900">Timeline du dossier</h1>
        <p class="text-gray-500 mt-2">Incident #{{ incidentId }}</p>
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
        <div v-if="timeline.length === 0" class="bg-white rounded-lg p-8 text-center border border-gray-200">
          <p class="text-gray-500">Aucun historique trouvé.</p>
        </div>

        <div v-else class="relative">
          <!-- Ligne verticale -->
          <div class="absolute left-5 top-0 bottom-0 w-0.5 bg-gray-200"></div>

          <div v-for="(event, index) in timeline" :key="index" class="relative pl-16 pb-6">
            <!-- Pastille -->
            <div class="absolute left-0 top-1 w-10 h-10 bg-white border-2 border-[#ea580c] rounded-full flex items-center justify-center shadow-sm">
              <span class="text-xs font-black text-[#ea580c]">{{ timeline.length - index }}</span>
            </div>

            <div class="bg-white rounded-xl border border-gray-200 shadow-sm overflow-hidden">
              <!-- Barre colorée en haut -->
              <div class="h-1 w-full" :class="index === 0 ? 'bg-[#ea580c]' : 'bg-gray-200'"></div>

              <div class="p-5">
                <!-- Statut + date -->
                <div class="flex items-start justify-between gap-4 mb-3">
                  <h3 class="font-black text-base text-gray-900 leading-snug">{{ event.statut.libelle }}</h3>
                  <time class="text-xs text-gray-400 whitespace-nowrap mt-0.5 flex-shrink-0">{{ formatDate(event.datechangement) }}</time>
                </div>

                <!-- Auteur -->
                <div v-if="event.modificateur" class="flex items-center gap-2 pt-3 border-t border-gray-100">
                  <div class="w-6 h-6 rounded-full bg-gray-100 flex items-center justify-center text-gray-500 flex-shrink-0">
                    <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
                    </svg>
                  </div>
                  <div class="min-w-0">
                    <span class="text-sm font-semibold text-gray-700 truncate">{{ event.modificateur.pseudonyme }}</span>
                    <span class="text-xs text-gray-400 ml-2">{{ event.modificateur.email }}</span>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </main>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import incidentsService from '@/services/incidentsService'

const route = useRoute()
const incidentId = route.params.id
const timeline = ref([])
const loading = ref(true)
const error = ref(null)

const formatDate = (dateString) => {
  const date = new Date(dateString)
  return new Intl.DateTimeFormat('fr-FR', {
    year: 'numeric',
    month: 'long',
    day: 'numeric',
    hour: '2-digit',
    minute: '2-digit'
  }).format(date)
}

onMounted(async () => {
  try {
    loading.value = true
    timeline.value = await incidentsService.getTimeline(incidentId)
  } catch (err) {
    error.value = err.message || 'Erreur lors du chargement de la timeline'
    console.error(err)
  } finally {
    loading.value = false
  }
})
</script>
