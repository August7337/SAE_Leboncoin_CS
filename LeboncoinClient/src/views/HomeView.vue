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

const getFirstDefined = (source, keys, fallback = null) => {
  for (const key of keys) {
    const value = source?.[key]
    if (value !== undefined && value !== null) {
      return value
    }
  }

  return fallback
}

const mapAnnonceFromApi = (annonceApi) => ({
  idannonce: getFirstDefined(annonceApi, ['idannonce', 'annonceId']),
  titreannonce: getFirstDefined(annonceApi, ['titreannonce', 'titreAnnonce'], 'Sans titre'),
  prixnuitee: getFirstDefined(annonceApi, ['prixnuitee', 'prixNuitee'], 0),
  nombreetoilesleboncoin: getFirstDefined(annonceApi, [
    'nombreetoilesleboncoin',
    'nombreEtoilesLeBonCoin',
  ]),
  capacite: annonceApi.capacite,
  typehebergement: {
    nomtypehebergement:
      annonceApi.idtypehebergementNavigation?.nomtypehebergement ||
      annonceApi.typeHebergementAssocie?.nomTypeHebergement ||
      'Logement',
  },
  adresse:
    annonceApi.idadresseNavigation || annonceApi.adresseAnnonce
    ? {
        ville: {
          nomville:
            annonceApi.idadresseNavigation?.idvilleNavigation?.nomville ||
            annonceApi.adresseAnnonce?.ville?.nomVille ||
            null,
          codepostal:
            annonceApi.idadresseNavigation?.idvilleNavigation?.codepostal ||
            annonceApi.adresseAnnonce?.ville?.codePostal ||
            null,
        },
      }
    : null,
  photos:
    getFirstDefined(annonceApi, ['lienphoto', 'lienPhoto'])
      ? [{ lienphoto: buildAssetUrl(getFirstDefined(annonceApi, ['lienphoto', 'lienPhoto'])) }]
      : [],
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
