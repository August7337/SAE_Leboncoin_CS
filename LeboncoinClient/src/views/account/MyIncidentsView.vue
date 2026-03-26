<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import incidentsService from '@/services/incidentsService'
import { authState } from '@/auth.js'

const router = useRouter()
const incidents = ref([])
const loading = ref(true)
const error = ref(null)

const myId = computed(() => authState.user?.idutilisateur)

const incidentsDeclares = computed(() =>
  incidents.value.filter(i => i.idutilisateur === myId.value)
)

const incidentsAccuses = computed(() =>
  incidents.value.filter(i => i.idutilisateur !== myId.value)
)

const STATUT_COLORS = {
  OUVERT:                               'bg-blue-100 text-blue-800',
  EN_ANALYSE_SERVICE_LOCATION:          'bg-yellow-100 text-yellow-800',
  EN_COURS:                             'bg-yellow-100 text-yellow-800',
  EN_ATTENTE_EXPLICATION_PROPRIETAIRE:  'bg-orange-100 text-orange-800',
  EXPLICATION_PROPRIETAIRE_RECUE:       'bg-orange-100 text-orange-700',
  REMBOURSEMENT_ACCEPTE:                'bg-green-100 text-green-800',
  REFUS_REMBOURSEMENT:                  'bg-red-100 text-red-700',
  DECISION_PRISE:                       'bg-purple-100 text-purple-800',
  REMBOURSEMENT_APPROUVE:               'bg-green-100 text-green-800',
  REMBOURSEMENT_EFFECTUE:               'bg-green-100 text-green-700',
  CLASSE_SANS_SUITE:                    'bg-gray-100 text-gray-600',
  TRANSFERE_CONTENTIEUX:                'bg-red-100 text-red-800',
  EN_CONTENTIEUX:                       'bg-red-100 text-red-800',
  CONTESTE:                             'bg-red-100 text-red-700',
  CLOTURE_SANS_REMBOURSEMENT:           'bg-gray-100 text-gray-500',
  CLOS:                                 'bg-gray-100 text-gray-500',
}

function statutColor(code) {
  return STATUT_COLORS[code] ?? 'bg-gray-100 text-gray-600'
}

function goTimeline(id) {
  router.push({ name: 'incident-timeline', params: { id } })
}

onMounted(async () => {
  try {
    incidents.value = await incidentsService.getMesIncidents()
  } catch (e) {
    error.value = 'Impossible de charger vos litiges.'
    console.error(e)
  } finally {
    loading.value = false
  }
})
</script>

<template>
  <div class="bg-[#f8f9fb] min-h-screen pb-12">
    <main class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10">

      <!-- Header -->
      <div class="mb-8">
        <h1 class="text-3xl font-black text-gray-900">Mes litiges</h1>
      </div>

      <!-- Loading -->
      <div v-if="loading" class="flex justify-center py-20">
        <div class="w-8 h-8 border-4 border-orange-200 border-t-[#ea580c] rounded-full animate-spin"></div>
      </div>

      <!-- Error -->
      <div v-else-if="error" class="bg-red-50 border border-red-200 rounded-xl p-6 text-red-700">
        {{ error }}
      </div>

      <!-- Content -->
      <div v-else class="grid grid-cols-1 lg:grid-cols-2 gap-8">

        <!-- Litiges que j'ai déclarés -->
        <section>
          <div class="flex items-center gap-2 mb-4">
            <div class="w-8 h-8 bg-red-100 rounded-lg flex items-center justify-center flex-shrink-0">
              <svg class="w-4 h-4 text-red-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
              </svg>
            </div>
            <div>
              <h2 class="text-lg font-black text-gray-900">Litiges déclarés</h2>
              <p class="text-xs text-gray-500">Signalements que vous avez initiés</p>
            </div>
            <span class="ml-auto text-sm font-bold text-gray-500 bg-gray-100 rounded-full px-2.5 py-0.5">
              {{ incidentsDeclares.length }}
            </span>
          </div>

          <div v-if="incidentsDeclares.length === 0" class="bg-white rounded-xl border border-dashed border-gray-200 p-8 text-center text-gray-400 text-sm">
            Aucun litige déclaré pour le moment.
          </div>

          <div v-else class="space-y-3">
            <div
              v-for="inc in incidentsDeclares"
              :key="inc.idincident"
              @click="goTimeline(inc.idincident)"
              class="bg-white rounded-xl border border-gray-200 p-4 hover:shadow-md hover:border-red-300 transition-all cursor-pointer group"
            >
              <div class="flex items-start justify-between gap-3 mb-2">
                <div class="flex-1 min-w-0">
                  <p class="text-xs text-gray-400 font-mono mb-0.5">#{{ inc.idincident }} · Résa. #{{ inc.idreservation }}</p>
                  <p class="font-bold text-gray-900 truncate text-sm">{{ inc.motifincident }}</p>
                </div>
                <span class="text-xs font-semibold px-2.5 py-1 rounded-full flex-shrink-0" :class="statutColor(inc.statut?.code)">
                  {{ inc.statut?.libelle }}
                </span>
              </div>
              <p v-if="inc.descriptionincident" class="text-xs text-gray-500 line-clamp-2 mb-3">
                {{ inc.descriptionincident }}
              </p>
              <div class="flex items-center justify-between">
                <span class="text-xs text-gray-400">{{ inc.dateSignalement }}</span>
                <span class="text-xs text-[#ea580c] font-semibold group-hover:underline flex items-center gap-1">
                  Voir la timeline
                  <svg class="w-3 h-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
                  </svg>
                </span>
              </div>

              <!-- CTA locataire : décision sur refus de remboursement -->
              <div v-if="inc.statut?.code === 'REFUS_REMBOURSEMENT'" class="mt-3 pt-3 border-t border-red-100" @click.stop>
                <button
                  @click.stop="router.push({ name: 'locataire-decision', params: { id: inc.idincident } })"
                  class="w-full flex items-center justify-center gap-2 py-2.5 rounded-xl text-sm font-bold text-white bg-red-600 hover:bg-red-700 transition-colors shadow-sm"
                >
                  <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 6l3 1m0 0l-3 9a5.002 5.002 0 006.001 0M6 7l3 9M6 7l6-2m6 2l3-1m-3 1l-3 9a5.002 5.002 0 006.001 0M18 7l3 9m-3-9l-6-2m0-2v2m0 16V5m0 16H9m3 0h3" />
                  </svg>
                  Répondre à la décision
                </button>
              </div>
            </div>
          </div>
        </section>

        <!-- Litiges dont je suis accusé -->
        <section>
          <div class="flex items-center gap-2 mb-4">
            <div class="w-8 h-8 bg-amber-100 rounded-lg flex items-center justify-center flex-shrink-0">
              <svg class="w-4 h-4 text-amber-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9" />
              </svg>
            </div>
            <div>
              <h2 class="text-lg font-black text-gray-900">Litiges me concernant</h2>
              <p class="text-xs text-gray-500">Signalements déposés contre vos annonces</p>
            </div>
            <span class="ml-auto text-sm font-bold text-gray-500 bg-gray-100 rounded-full px-2.5 py-0.5">
              {{ incidentsAccuses.length }}
            </span>
          </div>

          <div v-if="incidentsAccuses.length === 0" class="bg-white rounded-xl border border-dashed border-gray-200 p-8 text-center text-gray-400 text-sm">
            Aucun litige signalé contre vous.
          </div>

          <div v-else class="space-y-3">
            <div
              v-for="inc in incidentsAccuses"
              :key="inc.idincident"
              @click="goTimeline(inc.idincident)"
              class="bg-white rounded-xl border border-gray-200 p-4 hover:shadow-md hover:border-amber-300 transition-all cursor-pointer group"
            >
              <div class="flex items-start justify-between gap-3 mb-2">
                <div class="flex-1 min-w-0">
                  <p class="text-xs text-gray-400 font-mono mb-0.5">#{{ inc.idincident }} · Résa. #{{ inc.idreservation }}</p>
                  <p class="font-bold text-gray-900 truncate text-sm">{{ inc.motifincident }}</p>
                </div>
                <span class="text-xs font-semibold px-2.5 py-1 rounded-full flex-shrink-0" :class="statutColor(inc.statut?.code)">
                  {{ inc.statut?.libelle }}
                </span>
              </div>
              <p v-if="inc.descriptionincident" class="text-xs text-gray-500 line-clamp-2 mb-3">
                {{ inc.descriptionincident }}
              </p>
              <div class="flex items-center justify-between">
                <span class="text-xs text-gray-400">{{ inc.dateSignalement }}</span>
                <span class="text-xs text-amber-600 font-semibold group-hover:underline flex items-center gap-1">
                  Voir la timeline
                  <svg class="w-3 h-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
                  </svg>
                </span>
              </div>

              <!-- CTA propriétaire : fournir ses explications -->
              <div v-if="inc.statut?.code === 'EN_ATTENTE_EXPLICATION_PROPRIETAIRE'" class="mt-3 pt-3 border-t border-orange-100" @click.stop>
                <button
                  @click.stop="router.push({ name: 'proprietaire-response', params: { id: inc.idincident } })"
                  class="w-full flex items-center justify-center gap-2 py-2.5 rounded-xl text-sm font-bold text-white bg-[#ea580c] hover:bg-[#c2410c] transition-colors shadow-sm shadow-orange-200"
                >
                  <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.572L16.732 3.732z" />
                  </svg>
                  Donner mes explications
                </button>
              </div>
            </div>
          </div>
        </section>

      </div>
    </main>
  </div>
</template>
