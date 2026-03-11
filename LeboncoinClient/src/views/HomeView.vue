<template>
  <div class="min-h-screen bg-[#f5f5f5]">
    <div class="max-w-6xl mx-auto px-4 md:px-12 xl:px-6 py-8">
      <div class="mb-8">
        <h1 class="text-2xl md:text-3xl font-black text-gray-900 tracking-tight">
          Locations de vacances
        </h1>
        <p class="text-gray-500 text-sm mt-1 font-medium">
          {{ annonces.length }} logements disponibles
        </p>
      </div>

      <div v-if="isLoading" class="text-center py-12 text-gray-500 italic">
        Chargement des annonces...
      </div>

      <div v-else-if="errorMessage" class="text-center py-12 text-red-600 font-medium">
        {{ errorMessage }}
      </div>

      <AnnonceList v-else :annonces="annonces" />
    </div>
  </div>
</template>

<script setup>
import { onMounted, ref } from 'vue'
import AnnonceList from '../components/AnnonceList.vue'

const API_BASE_URL = 'https://localhost:7057'

const annonces = ref([])
const isLoading = ref(false)
const errorMessage = ref('')

const normalizePhotoUrl = (photoPath) => {
  if (!photoPath) return ''
  if (photoPath.startsWith('http://') || photoPath.startsWith('https://')) {
    return photoPath
  }

  return `${API_BASE_URL}/${photoPath.replace(/^\/+/, '')}`
}

const mapAnnonceFromApi = (annonceApi) => ({
  idannonce: annonceApi.annonceId,
  titreannonce: annonceApi.titreAnnonce,
  prixnuitee: annonceApi.prixNuitee,
  nombreetoilesleboncoin: annonceApi.nombreEtoilesLeBonCoin,
  capacite: annonceApi.capacite,
  typehebergement: {
    nomtypehebergement: annonceApi.typeHebergementAssocie?.nomTypeHebergement || 'Logement',
  },
  adresse: annonceApi.adresseAnnonce
    ? {
        ville: {
          nomville: annonceApi.adresseAnnonce.ville?.nomVille,
          codepostal: annonceApi.adresseAnnonce.ville?.codePostal,
        },
      }
    : null,
  photos: annonceApi.lienPhoto ? [{ lienphoto: normalizePhotoUrl(annonceApi.lienPhoto) }] : [],
})

const loadAnnonces = async () => {
  isLoading.value = true
  errorMessage.value = ''

  try {
    const response = await fetch(`${API_BASE_URL}/api/annonces`)

    if (!response.ok) {
      throw new Error(`Erreur HTTP ${response.status}`)
    }

    const data = await response.json()
    annonces.value = Array.isArray(data) ? data.map(mapAnnonceFromApi) : []
  } catch (error) {
    errorMessage.value = 'Impossible de charger les annonces.'
  } finally {
    isLoading.value = false
  }
}

onMounted(loadAnnonces)
</script>
