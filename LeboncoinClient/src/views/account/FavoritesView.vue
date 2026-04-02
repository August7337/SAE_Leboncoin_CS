<script setup>
import { ref, onMounted } from 'vue'
import api from '@/api/axios'
import { authState } from '@/auth.js'
import AnnonceList from '@/components/AnnonceList.vue'
import annoncesService from '@/services/annoncesService'
import EmptyState from '@/components/EmptyState.vue'
import { buildAssetUrl } from '@/services/api'

const favorites = ref([])
const loading = ref(true)

const mapAnnonceFromApi = (annonceApi) => {
  return {
    idannonce: annonceApi.idannonce,
    titreannonce: annonceApi.titreannonce || 'Sans titre',
    prixnuitee: annonceApi.prixnuitee || 0,
    capacite: annonceApi.capacite,
    typehebergement: {
      nomtypehebergement: annonceApi.typeHebergement || 'Logement',
    },
    adresse: annonceApi.nomville ? {
      ville: {
        nomville: annonceApi.nomville,
        codepostal: annonceApi.codepostal,
      },
      adresseComplete: annonceApi.adresse
    } : null,
    photos: Array.isArray(annonceApi.photos)
      ? annonceApi.photos.map(p => ({
          ...p,
          lienphoto: buildAssetUrl(p.lienphoto)
        }))
      : [],
    dateDepot: annonceApi.dateDepot ? new Date(annonceApi.dateDepot).toLocaleDateString('fr-FR') : null,
    nombreetoilesleboncoin: annonceApi.nombreetoilesleboncoin
  }
}

async function fetchFavorites() {
  if (!authState.user) return
  try {
    const data = await annoncesService.getFavorites(authState.user.idutilisateur)
    favorites.value = Array.isArray(data) ? data.map(mapAnnonceFromApi) : []
  } catch (error) {
    console.error('Erreur favoris', error)
  } finally {
    loading.value = false
  }
}

onMounted(fetchFavorites)
</script>

<template>
  <div class="min-h-screen bg-[#f5f5f5] py-10">
    <div class="max-w-4xl mx-auto px-4">
      <h1 class="text-3xl font-black text-gray-900 mb-8">Mes favoris</h1>

      <div v-if="loading" class="text-center py-20 text-gray-400">Chargement...</div>

      <div v-else-if="favorites.length > 0">
        <AnnonceList 
          :annonces="favorites" 
          :favorite-ids="favorites.map(f => f.idannonce)" 
          @update-favorites="(newIds) => favorites = favorites.filter(f => newIds.includes(f.idannonce))" 
        />
      </div>

      <EmptyState
        v-else
        title="Aucun favori pour le moment"
        description="Parcourez les annonces et cliquez sur le cœur pour les retrouver ici."
        link-label="Explorer les annonces"
      >
        <template #icon>
          <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-10 h-10 text-[#ea580c]">
            <path stroke-linecap="round" stroke-linejoin="round" d="M21 8.25c0-2.485-2.099-4.5-4.688-4.5-1.935 0-3.597 1.126-4.312 2.733-.715-1.607-2.377-2.733-4.313-2.733C5.1 3.75 3 5.765 3 8.25c0 4.875 6.426 9.06 9 10.5 2.574-1.44 9-5.625 9-10.5z" />
          </svg>
        </template>
      </EmptyState>
    </div>
  </div>
</template>
