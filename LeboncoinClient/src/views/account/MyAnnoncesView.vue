<script setup>
import { ref, onMounted } from 'vue'
import api from '@/api/axios'
import { authState } from '@/auth.js'
import { buildAssetUrl } from '@/services/api'

const myAnnonces = ref([])
const loading = ref(true)

async function fetchMyAnnonces() {
  if (!authState.user) return

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
  <div class="min-h-screen bg-[#f5f5f5] py-10">
    <div class="max-w-4xl mx-auto px-4">
      <div class="flex justify-between items-center mb-10">
        <h1 class="text-3xl font-black text-gray-900">Mes annonces</h1>
        <router-link
          to="/create-annonce"
          class="bg-[#ea580c] text-white px-6 py-3 rounded-2xl font-bold shadow-md shadow-orange-100 hover:bg-[#c2410c] transition-all"
        >
          Déposer une annonce
        </router-link>
      </div>

      <div v-if="loading" class="text-center py-10">
        <div class="w-8 h-8 border-4 border-orange-200 border-t-[#ea580c] rounded-full animate-spin mx-auto"></div>
      </div>

      <div v-else-if="myAnnonces.length > 0" class="space-y-6">
        <div
          v-for="annonce in myAnnonces"
          :key="annonce.idannonce"
          class="bg-white p-5 rounded-3xl shadow-sm border border-gray-100 flex flex-col md:flex-row gap-6"
        >
          <div class="w-full md:w-48 h-32 flex-shrink-0 relative">
            <img
              :src="annonce.lienphoto || 'https://via.placeholder.com/150?text=Pas+d\'image'"
              class="w-full h-full object-cover rounded-2xl"
            />
          </div>

          <div class="flex-1 flex flex-col justify-between">
            <div class="flex justify-between items-start">
              <div>
                <h3 class="font-bold text-lg text-gray-900">{{ annonce.titreannonce }}</h3>
                <p class="text-sm text-gray-500 flex items-center gap-1 mt-1">
                  {{ annonce.nomville || 'Lieu inconnu' }}
                </p>
              </div>
              <p class="text-[#ea580c] text-lg font-black whitespace-nowrap">{{ annonce.prixnuitee }}€ / nuit</p>
            </div>

            <div class="mt-4 pt-4 border-t border-gray-100">
              <h4 class="text-sm font-semibold text-gray-800 mb-2">Réservations ({{ annonce.reservations.length }})</h4>
              
              <div v-if="annonce.reservations.length === 0" class="text-xs text-gray-500 italic">
                Aucune réservation.
              </div>
              
              <div v-else class="space-y-2 max-h-32 overflow-y-auto pr-2">
                <div v-for="res in annonce.reservations" :key="res.idreservation" 
                     class="bg-gray-50 border border-gray-200 rounded-lg px-3 py-2 flex items-center justify-between"
                     :class="{'opacity-60': isPast(res.datefinreservation)}">
                  
                  <div>
                    <div class="flex items-center gap-2">
                      <span class="text-sm font-semibold text-gray-900">{{ res.prenomclient }} {{ res.nomclient }}</span>
                      <span v-if="isPast(res.datefinreservation)" class="px-2 py-0.5 rounded-full text-[10px] bg-gray-200 text-gray-700">Passée</span>
                      <span v-else class="px-2 py-0.5 rounded-full text-[10px] bg-green-100 text-green-700">En cours</span>
                    </div>
                    <p class="text-xs text-gray-500">{{ formatDate(res.datedebutreservation) }} - {{ formatDate(res.datefinreservation) }}</p>
                  </div>

                  <div class="flex gap-2">
                    <router-link
                      v-for="incident in getIncidentsAJustifier(res)"
                      :key="incident.idincident"
                      :to="{ name: 'proprietaire-response', params: { id: incident.idincident } }"
                      class="flex items-center justify-center w-8 h-8 rounded-full bg-red-100 text-red-600 border border-red-200 hover:bg-red-500 hover:text-white transition animate-pulse"
                      title="Fournir une justification"
                    >
                      <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
                      </svg>
                    </router-link>
                  </div>
                </div>
              </div>
            </div>

            <div class="flex gap-2 mt-4">
              <router-link
                :to="'/edit-annonce/' + annonce.idannonce"
                class="px-4 py-2 bg-gray-50 text-gray-700 rounded-xl hover:bg-gray-100 transition-all font-bold text-sm"
              >
                Modifier l'annonce
              </router-link>
            </div>
          </div>
        </div>
      </div>

      <div v-else class="text-center py-20 bg-white rounded-3xl border border-gray-100 shadow-sm">
        <p class="text-gray-500 mb-4">Vous n'avez pas encore d'annonces.</p>
        <router-link to="/create-annonce" class="bg-[#ea580c] text-white px-6 py-2 rounded-xl font-bold">Déposer une annonce</router-link>
      </div>
    </div>
  </div>
</template>