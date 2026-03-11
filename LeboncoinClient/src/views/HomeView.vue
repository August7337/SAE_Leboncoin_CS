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
import { buildAssetUrl } from '../services/api'
import annoncesService from '../services/annoncesService'

const annonces = ref([])
const isLoading = ref(false)
const errorMessage = ref('')

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
  photos: annonceApi.lienPhoto ? [{ lienphoto: buildAssetUrl(annonceApi.lienPhoto) }] : [],
})

const loadAnnonces = async () => {
  isLoading.value = true
  errorMessage.value = ''

  try {
    const data = await annoncesService.getAll()
    annonces.value = Array.isArray(data) ? data.map(mapAnnonceFromApi) : []
  } catch (error) {
    errorMessage.value = 'Impossible de charger les annonces.'
  } finally {
    isLoading.value = false
  }
}

onMounted(loadAnnonces)
</script>
