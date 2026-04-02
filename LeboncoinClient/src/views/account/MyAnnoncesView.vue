<script setup>
import { ref, onMounted, computed } from 'vue'
import api from '@/api/axios'
import { authState } from '@/auth.js'
import { buildAssetUrl } from '@/services/api'

const myAnnonces = ref([])
const loading = ref(true)
const activeTab = ref('en-ligne')

// Delete Modal state
const showDeleteConfirm = ref(false)
const annonceToDelete = ref(null)
const isDeleting = ref(false)

async function fetchMyAnnonces() {
  if (!authState.user) return
  loading.value = true

  try {
    const response = await api.get(`/Annonces/user/${authState.user.idutilisateur}`)
    
    myAnnonces.value = response.data.map((annonce) => ({
      ...annonce,
      lienphoto: annonce.photos && annonce.photos.length > 0
          ? buildAssetUrl(annonce.photos[0].lienphoto)
          : null,
      reservations: annonce.reservations || [] 
    }))
  } catch (error) {
    console.error('Erreur lors du chargement des annonces', error)
  } finally {
    loading.value = false
  }
}

const annoncesEnLigne = computed(() =>
  myAnnonces.value.filter(a => a.estverifie === true || a.Estverifie === true)
)
const annoncesInactives = computed(() =>
  myAnnonces.value.filter(a => a.estverifie === false || a.Estverifie === false || (a.estverifie === undefined && a.Estverifie === undefined))
)

function confirmDelete(annonce) {
  annonceToDelete.value = annonce
  showDeleteConfirm.value = true
}

async function handleDelete() {
  if (!annonceToDelete.value) return
  isDeleting.value = true
  try {
    await api.delete(`/Annonces/${annonceToDelete.value.idannonce}`)
    myAnnonces.value = myAnnonces.value.filter(a => a.idannonce !== annonceToDelete.value.idannonce)
    showDeleteConfirm.value = false
  } catch (error) {
    console.error('Erreur suppression', error)
    alert('Erreur lors de la suppression de l\'annonce.')
  } finally {
    isDeleting.value = false
    annonceToDelete.value = null
  }
}

const formatDate = (dateStr) => {
  if (!dateStr) return 'N/C'
  return new Date(dateStr).toLocaleDateString('fr-FR')
}

const isPast = (endDateStr) => {
  if (!endDateStr) return false
  return new Date(endDateStr) < new Date()
}

const getIncidentsAJustifier = (reservation) => {
  if (!reservation.incidents) return []
  return reservation.incidents.filter(inc =>
    inc.statut?.code === 'EN_ATTENTE_EXPLICATION_PROPRIETAIRE' ||
    inc.idstatutincident === 4
  )
}

onMounted(fetchMyAnnonces)
</script>

<template>
  <div class="bg-[#f8f9fb] min-h-screen py-8">
    <div class="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8">
      <div class="flex justify-between items-center mb-6">
        <h1 class="text-3xl font-black text-gray-900">Mes annonces</h1>
        <router-link
          to="/create-annonce"
          class="bg-orange-600 text-white px-6 py-3 rounded-xl font-bold hover:bg-orange-700 transition"
        >
          Déposer une annonce
        </router-link>
      </div>

      <!-- Tabs -->
      <div class="flex border-b border-gray-200 mb-6 text-sm font-medium">
        <button 
          @click="activeTab = 'en-ligne'"
          :class="[
            'px-6 py-3 border-b-2 transition-all',
            activeTab === 'en-ligne' 
              ? 'border-orange-600 text-orange-600 font-bold' 
              : 'border-transparent text-gray-500 hover:text-gray-700'
          ]"
        >
          En ligne ({{ annoncesEnLigne.length }})
        </button>
        <button 
          @click="activeTab = 'inactives'"
          :class="[
            'px-6 py-3 border-b-2 transition-all',
            activeTab === 'inactives' 
              ? 'border-orange-600 text-orange-600 font-bold' 
              : 'border-transparent text-gray-500 hover:text-gray-700'
          ]"
        >
          Inactives ({{ annoncesInactives.length }})
        </button>
      </div>

      <div v-if="loading" class="text-center py-20">
        <div class="inline-block animate-spin rounded-full h-8 w-8 border-4 border-orange-600 border-t-transparent"></div>
        <p class="mt-4 text-gray-500">Chargement de vos annonces...</p>
      </div>

      <div v-else>
        <!-- En Ligne Tab -->
        <div v-if="activeTab === 'en-ligne'">
          <div v-if="annoncesEnLigne.length === 0" class="bg-white p-12 rounded-xl shadow-sm text-center border border-gray-200">
            <div class="text-5xl mb-4">ðŸ“¦</div>
            <h3 class="text-xl font-bold text-gray-900">Vous n'avez aucune annonce en ligne</h3>
            <p class="text-gray-500 mt-2 mb-6">C'est le moment de faire du tri !</p>
            <router-link to="/create-annonce" class="bg-orange-600 text-white px-6 py-3 rounded-xl font-bold hover:bg-orange-700 transition">
              Déposer une annonce
            </router-link>
          </div>

          <div v-else class="space-y-4">
            <div 
              v-for="annonce in annoncesEnLigne" 
              :key="annonce.idannonce"
              class="bg-white p-4 rounded-xl shadow-sm border border-gray-200 flex flex-col sm:flex-row gap-4 hover:shadow-md transition relative group"
            >
              <div class="w-full sm:w-48 h-32 bg-gray-100 rounded-lg overflow-hidden flex-shrink-0 relative">
                <img 
                  :src="annonce.lienphoto || 'https://via.placeholder.com/300x200?text=Pas+d\'image'" 
                  class="w-full h-full object-cover"
                />
                <span class="absolute top-2 left-2 bg-green-100 text-green-800 text-[10px] font-bold px-2 py-0.5 rounded flex items-center gap-1 shadow-sm">
                  <span class="w-1.5 h-1.5 rounded-full bg-green-600"></span> En ligne
                </span>
              </div>

              <div class="flex-grow flex flex-col justify-between">
                <div>
                  <div class="flex justify-between items-start">
                    <h3 class="font-bold text-lg text-gray-900 line-clamp-1 capitalize">{{ annonce.titreannonce }}</h3>
                    <span class="font-bold text-gray-900 text-lg">{{ annonce.prixnuitee }} €</span>
                  </div>
                  <p class="text-gray-500 text-sm mt-1 flex items-center gap-1">
                    <svg class="w-3 h-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z"/></svg>
                    {{ annonce.nomville || 'Lieu inconnu' }}
                    <span class="mx-1">•</span>
                    {{ annonce.typeHebergement || 'Logement' }}
                  </p>
                </div>

                <div class="mt-4 border-t border-gray-100 pt-3">
                  <div class="flex items-center justify-between text-sm font-semibold text-gray-800">
                    <span>Réservations ({{ annonce.reservations?.length || 0 }})</span>
                    <span v-if="annonce.reservations?.length > 2" class="text-xs text-gray-500">Défilez pour voir tout</span>
                  </div>
                  
                  <div v-if="!annonce.reservations || annonce.reservations.length === 0" class="text-sm text-gray-500 mt-2">
                    Aucune réservation pour cette annonce.
                  </div>
                  
                  <div v-else class="mt-2 space-y-2 max-h-32 overflow-y-auto pr-1 custom-scrollbar">
                    <div 
                      v-for="res in annonce.reservations" 
                      :key="res.idreservation"
                      class="bg-white/70 border border-gray-200 rounded-lg px-3 py-2 flex flex-col gap-1 hover:border-orange-200 hover:shadow-sm transition"
                      :class="{ 'opacity-60 bg-gray-50': isPast(res.datefinreservation) }"
                    >
                      <div class="flex items-center justify-between gap-2">
                        <div class="flex items-center gap-2 text-sm font-semibold text-gray-900">
                          <span>{{ res.prenomclient }} {{ res.nomclient }}</span>
                          <span v-if="isPast(res.datefinreservation)" class="inline-flex items-center px-2 py-0.5 rounded-full text-[10px] font-semibold bg-gray-200 text-gray-700">Passée</span>
                          <span v-else class="inline-flex items-center px-2 py-0.5 rounded-full text-[10px] font-semibold bg-green-100 text-green-700">En cours</span>
                        </div>
                        <span class="text-xs text-gray-500">{{ formatDate(res.datedebutreservation) }} – {{ formatDate(res.datefinreservation) }}</span>
                      </div>
                      <!-- Incident alert buttons -->
                      <div v-if="getIncidentsAJustifier(res).length" class="flex gap-2 pt-1">
                        <router-link
                          v-for="incident in getIncidentsAJustifier(res)"
                          :key="incident.idincident"
                          :to="{ name: 'proprietaire-response', params: { id: incident.idincident } }"
                          class="flex items-center gap-1.5 text-[11px] font-bold text-red-600 bg-red-50 border border-red-200 px-2 py-1 rounded-lg hover:bg-red-500 hover:text-white transition animate-pulse"
                          title="Fournir une justification"
                        >
                          <svg class="w-3 h-3" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
                          </svg>
                          Justifier ce litige
                        </router-link>
                      </div>
                    </div>
                  </div>
                </div>

                <div class="flex items-center gap-6 mt-4 pt-3 border-t border-gray-100 text-sm font-bold">
                  <router-link :to="'/edit-annonce/' + annonce.idannonce" class="text-gray-700 hover:text-orange-600 flex items-center gap-1 transition group">
                    <svg class="w-4 h-4 text-gray-400 group-hover:text-orange-600" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"/></svg>
                    Modifier
                  </router-link>
                  <button @click="confirmDelete(annonce)" class="text-gray-700 hover:text-red-600 flex items-center gap-1 transition ml-auto group">
                    <svg class="w-4 h-4 text-gray-400 group-hover:text-red-600" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/></svg>
                    Supprimer
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Inactives Tab -->
        <div v-if="activeTab === 'inactives'">
          <div v-if="annoncesInactives.length === 0" class="bg-white p-12 rounded-xl shadow-sm text-center border border-gray-200">
            <p class="text-gray-500">Aucune annonce inactive pour le moment.</p>
          </div>

          <div v-else class="space-y-4">
            <div 
              v-for="annonce in annoncesInactives" 
              :key="annonce.idannonce"
              class="bg-white p-4 rounded-xl shadow-sm border border-gray-200 flex flex-col sm:flex-row gap-4 hover:shadow-md transition relative group"
            >
              <div class="w-full sm:w-48 h-32 bg-gray-100 rounded-lg overflow-hidden flex-shrink-0 relative">
                <img 
                  :src="annonce.lienphoto || 'https://via.placeholder.com/300x200?text=Pas+d\'image'" 
                  class="w-full h-full object-cover grayscale"
                />
                <span class="absolute top-2 left-2 bg-gray-100 text-gray-800 text-[10px] font-bold px-2 py-0.5 rounded flex items-center gap-1 shadow-sm">
                  <span class="w-1.5 h-1.5 rounded-full bg-gray-500"></span> Non vérifiée
                </span>
              </div>

              <div class="flex-grow flex flex-col justify-between">
                <div>
                  <div class="flex justify-between items-start">
                    <h3 class="font-bold text-lg text-gray-900 line-clamp-1 opacity-75 capitalize">{{ annonce.titreannonce }}</h3>
                    <span class="font-bold text-gray-900 text-lg">{{ annonce.prixnuitee }} €</span>
                  </div>
                  <p class="text-gray-500 text-sm mt-1">En attente de vérification par notre équipe</p>
                </div>

                <div class="flex items-center gap-6 mt-4 pt-3 border-t border-gray-100 text-sm font-bold">
                  <router-link :to="'/edit-annonce/' + annonce.idannonce" class="text-gray-700 hover:text-orange-600 flex items-center gap-1 transition">
                    Modifier
                  </router-link>
                  <button @click="confirmDelete(annonce)" class="text-gray-700 hover:text-red-600 flex items-center gap-1 transition ml-auto">
                    Supprimer
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Delete Modal -->
    <div v-if="showDeleteConfirm" class="fixed inset-0 bg-black/50 z-50 flex items-center justify-center p-4">
      <div class="bg-white rounded-2xl shadow-xl max-w-md w-full p-6">
        <div class="flex items-center gap-3 mb-4">
          <div class="w-12 h-12 rounded-full bg-red-100 flex items-center justify-center flex-shrink-0">
            <svg class="w-6 h-6 text-red-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
            </svg>
          </div>
          <h3 class="text-lg font-bold text-gray-900">Supprimer l'annonce</h3>
        </div>
        
        <p class="text-sm text-gray-600 mb-6">
          Vous êtes sur le point de supprimer l'annonce <strong class="text-gray-900">« {{ annonceToDelete?.titreannonce }} »</strong>.
          <span class="text-red-600 font-semibold block mt-2">Cette action est irréversible.</span>
        </p>

        <div class="flex gap-3">
          <button 
            @click="showDeleteConfirm = false" 
            class="flex-1 px-4 py-2.5 text-sm font-bold text-gray-700 bg-gray-100 hover:bg-gray-200 rounded-xl transition"
          >
            Annuler
          </button>
          <button 
            @click="handleDelete" 
            :disabled="isDeleting"
            class="flex-1 px-4 py-2.5 text-sm font-bold text-white bg-red-600 hover:bg-red-700 rounded-xl transition disabled:opacity-50"
          >
            {{ isDeleting ? 'Suppression...' : 'Supprimer' }}
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.custom-scrollbar::-webkit-scrollbar {
  width: 4px;
}
.custom-scrollbar::-webkit-scrollbar-track {
  background: transparent;
}
.custom-scrollbar::-webkit-scrollbar-thumb {
  background: #e5e7eb;
  border-radius: 10px;
}
.custom-scrollbar::-webkit-scrollbar-thumb:hover {
  background: #d1d5db;
}

.line-clamp-1 {
  display: -webkit-box;
  -webkit-line-clamp: 1;
  line-clamp: 1;
  -webkit-box-orient: vertical;
  overflow: hidden;
}
</style>
