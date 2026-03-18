<script setup>
import { ref, onMounted, computed } from 'vue'
import { useRoute } from 'vue-router'
import axios from 'axios'
import { buildAssetUrl } from '../../services/api'
import PhotoCarousel from '../../components/PhotoCarousel.vue'

const route = useRoute()
const annonce = ref(null)
const loading = ref(true)

const googleApiKey = import.meta.env.VITE_GOOGLE_MAPS_API_KEY

const fullAddress = computed(() => {
  const addr = annonce.value?.idadresseNavigation
  if (!addr) return null
  
  const rue = addr.rue || ''
  const ville = addr.idvilleNavigation?.nomville || addr.ville?.nomville || ''
  const cp = addr.idvilleNavigation?.codepostal || addr.ville?.codepostal || ''
  
  return encodeURIComponent(`${rue}, ${cp} ${ville}, France`)
})

async function fetchAnnonce() {
  loading.value = true
  try {
    const response = await axios.get(`https://localhost:7057/api/Annonces/${route.params.id}`)
    const data = response.data
    
    if (data.photos && Array.isArray(data.photos)) {
      data.photos = data.photos.map(p => ({
        ...p,
        lienphoto: buildAssetUrl(p.lienphoto)
      }))
    }
    
    annonce.value = data
  } catch (error) {
    console.error("Erreur chargement annonce", error)
  } finally {
    loading.value = false
  }
}

onMounted(fetchAnnonce)
</script>

<template>
  <div class="min-h-screen bg-white">
    <div v-if="loading" class="flex justify-center items-center h-[60vh]">
      <div class="w-12 h-12 border-4 border-orange-100 border-t-[#ea580c] rounded-full animate-spin"></div>
    </div>

    <div v-else-if="annonce" class="max-w-6xl mx-auto px-4 md:px-12 xl:px-6 py-8">
      
      <nav class="flex mb-6 text-sm text-gray-500 items-center gap-2">
        <router-link to="/" class="hover:text-[#ea580c] transition-colors">Accueil</router-link>
        <span class="text-gray-300">/</span>
        <span class="font-medium text-gray-900 truncate">{{ annonce.titreannonce }}</span>
      </nav>

      <div class="mb-8">
        <PhotoCarousel :photos="annonce.photos" height="h-[450px]" />
      </div>

      <div class="grid grid-cols-1 lg:grid-cols-3 gap-12">
        <div class="lg:col-span-2 space-y-8">
          <div class="pb-8 border-b border-gray-100">
            <h1 class="text-4xl font-black text-gray-900 mb-4">{{ annonce.titreannonce }}</h1>
            <div class="flex items-center gap-4 text-gray-600">
              <span class="flex items-center gap-1">
                <svg class="w-5 h-5 text-[#ea580c]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
                </svg>
                {{ annonce.idadresseNavigation?.idvilleNavigation?.nomville || "Ville inconnue" }}
              </span>
              <span>·</span>
              <span>{{ annonce.idtypehebergementNavigation?.nomtypehebergement || "Logement" }}</span>
              <span>·</span>
              <span>{{ annonce.capacite || 0 }} voyageurs</span>
            </div>
          </div>

          <div>
            <h2 class="text-2xl font-bold mb-4 text-gray-900">À propos de ce logement</h2>
            <p class="text-gray-600 leading-relaxed text-lg whitespace-pre-line">
              {{ annonce.descriptionannonce }}
            </p>
          </div>

          <div class="pt-8 border-t border-gray-100">
            <h2 class="text-2xl font-bold mb-6 text-gray-900">Où se situe le logement</h2>
            <div class="w-full h-[400px] rounded-3xl overflow-hidden shadow-sm border border-gray-100 bg-gray-50">
              <iframe
                v-if="fullAddress"
                width="100%"
                height="100%"
                frameborder="0"
                style="border:0"
                :src="`https://www.google.com/maps/embed/v1/place?key=${googleApiKey}&q=${fullAddress}`"
                allowfullscreen
              ></iframe>
              <div v-else class="flex items-center justify-center h-full text-gray-400 italic">
                Localisation en cours de chargement...
              </div>
            </div>
            <p class="mt-4 text-sm text-gray-400">L'adresse exacte vous sera communiquée après la réservation.</p>
          </div>
        </div>

        <div class="lg:col-span-1">
          <div class="sticky top-24 bg-white border border-gray-100 rounded-3xl p-8 shadow-2xl">
            <div class="flex items-baseline gap-1 mb-8">
              <span class="text-4xl font-black text-gray-900">{{ annonce.prixnuitee }}€</span>
              <span class="text-gray-500 font-medium">/ nuit</span>
            </div>

            <button class="w-full bg-[#ea580c] text-white font-black py-4 rounded-2xl hover:bg-[#c2410c] hover:scale-[1.02] active:scale-[0.98] transition-all mb-4 text-lg">
              Réserver maintenant
            </button>
            
            <p class="text-sm text-center text-gray-400 font-medium">
              Aucun montant ne sera débité pour le moment
            </p>
          </div>
        </div>
      </div>
    </div>

    <div v-else class="flex flex-col items-center justify-center min-h-[60vh] px-4">
      <div class="bg-orange-50 p-6 rounded-full mb-6">
        <svg class="w-12 h-12 text-[#ea580c]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9.172 9.172a4 4 0 015.656 0M9 10h.01M15 10h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
        </svg>
      </div>
      <h2 class="text-2xl font-bold text-gray-900 mb-2">Annonce introuvable</h2>
      <router-link to="/" class="bg-gray-900 text-white font-bold py-3 px-8 rounded-xl hover:bg-gray-800 transition-all">
        Retour à l'accueil
      </router-link>
    </div>
  </div>
</template>

<style scoped>
.whitespace-pre-line {
  white-space: pre-line;
}
</style>