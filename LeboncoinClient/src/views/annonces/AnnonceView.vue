<script setup>
import { ref, onMounted, computed } from 'vue'
import { useRoute } from 'vue-router'
import axios from 'axios'

const route = useRoute()
const annonce = ref(null)
const loading = ref(true)
const currentIndex = ref(0)

const googleApiKey = import.meta.env.VITE_GOOGLE_MAPS_API_KEY

const fullAddress = computed(() => {
  const addr = annonce.value?.idadresseNavigation
  if (!addr) return null
  
  const rue = addr.rue || ''
  const ville = addr.idvilleNavigation?.nomville || addr.ville?.nomville || ''
  const cp = addr.idvilleNavigation?.codepostal || addr.ville?.codepostal || ''
  
  return encodeURIComponent(`${rue}, ${cp} ${ville}, France`)
})

const nextImage = () => {
  if (!annonce.value?.photos) return
  currentIndex.value = (currentIndex.value + 1) % annonce.value.photos.length
}

const prevImage = () => {
  if (!annonce.value?.photos) return
  currentIndex.value =
    (currentIndex.value - 1 + annonce.value.photos.length) % annonce.value.photos.length
}

async function fetchAnnonce() {
  loading.value = true
  try {
    const response = await axios.get(`https://localhost:7057/api/Annonces/${route.params.id}`)
    annonce.value = response.data
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

      <div class="grid grid-cols-1 lg:grid-cols-3 gap-12">
        
        <div class="lg:col-span-2 space-y-8">
          
          <div v-if="annonce.photos?.length || annonce.lienphoto" class="relative">
            <div class="overflow-hidden rounded-3xl shadow-sm bg-gray-100 h-[450px]">
              <div v-if="annonce.photos?.length" 
                   class="flex h-full transition-transform duration-500"
                   :style="{ transform: `translateX(-${currentIndex * 100}%)` }">
                <div v-for="(photo, index) in annonce.photos" :key="index" class="flex-shrink-0 w-full h-full">
                  <img :src="photo.lienphoto" class="w-full h-full object-cover" />
                </div>
              </div>
              <img v-else :src="annonce.lienphoto" class="w-full h-full object-cover" />
            </div>

            <template v-if="annonce.photos?.length > 1">
              <button @click="prevImage" class="absolute top-1/2 left-4 -translate-y-1/2 bg-white/90 p-3 rounded-full shadow-lg hover:bg-white transition-all">‹</button>
              <button @click="nextImage" class="absolute top-1/2 right-4 -translate-y-1/2 bg-white/90 p-3 rounded-full shadow-lg hover:bg-white transition-all">›</button>
            </template>
          </div>

          <div class="border-b border-gray-100 pb-6">
            <h1 class="text-3xl font-black text-gray-900">{{ annonce.titreannonce }}</h1>
            <p class="text-gray-500 mt-2 flex items-center gap-1">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
              </svg>
              {{ annonce.idadresseNavigation?.idvilleNavigation?.nomville || "Lieu non précisé" }}
            </p>
          </div>

          <div>
            <h2 class="text-xl font-bold mb-4 text-gray-900">À propos de ce logement</h2>
            <p class="text-gray-600 leading-relaxed whitespace-pre-line">{{ annonce.descriptionannonce }}</p>
          </div>

          <div class="pt-8 border-t border-gray-100">
            <h2 class="text-xl font-bold mb-6 text-gray-900">Où se situe le logement</h2>
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
            <p class="mt-4 text-xs text-gray-400">L'adresse exacte vous sera communiquée après confirmation.</p>
          </div>
        </div>

        <div class="lg:col-span-1">
          <div class="sticky top-24 bg-white border border-gray-100 rounded-3xl p-8 shadow-xl">
            <div class="flex items-baseline gap-1 mb-8">
              <span class="text-3xl font-black">{{ annonce.prixnuitee }}€</span>
              <span class="text-gray-500">/ nuit</span>
            </div>

            <button class="w-full bg-[#ea580c] hover:bg-[#c2410c] text-white font-black py-4 rounded-2xl transition-all shadow-md shadow-orange-200 mb-4">
              Réserver maintenant
            </button>
            
            <div class="space-y-3 mt-6">
              <div class="flex justify-between text-sm text-gray-600">
                <span class="underline">Frais de service</span>
                <span>0€</span>
              </div>
              <div class="pt-3 border-t border-gray-100 flex justify-between font-bold text-gray-900">
                <span>Total</span>
                <span>{{ annonce.prixnuitee }}€</span>
              </div>
            </div>

            <p class="text-[10px] text-center text-gray-400 mt-6 uppercase tracking-widest font-bold">
              Paiement sécurisé via leboncoin
            </p>
          </div>
        </div>

      </div>
    </div>

    <div v-else class="text-center py-20">
      <p class="text-gray-500 italic">Cette annonce n'existe plus ou a été supprimée.</p>
      <router-link to="/" class="text-[#ea580c] font-bold underline mt-4 block">Retour à l'accueil</router-link>
    </div>
  </div>
</template>

<style scoped>
.whitespace-pre-line {
  white-space: pre-line;
}
</style>