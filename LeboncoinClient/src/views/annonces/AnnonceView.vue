<script setup>
import { ref, onMounted, computed } from 'vue'
import { useRoute } from 'vue-router'
import axios from 'axios'
import { buildAssetUrl } from '../../services/api'

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
  if (!annonce.value?.photos?.length) return
  currentIndex.value = (currentIndex.value + 1) % annonce.value.photos.length
}

const prevImage = () => {
  if (!annonce.value?.photos?.length) return
  currentIndex.value =
    (currentIndex.value - 1 + annonce.value.photos.length) % annonce.value.photos.length
}

async function fetchAnnonce() {
  loading.value = true
  try {
    const response = await axios.get(`https://localhost:7057/api/Annonces/${route.params.id}`)
    const data = response.data
    
    // Map photos to include full URL
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

    <div v-else-if="annonce" class="max-w-6xl mx-auto px-4 py-8">
      <!-- Breadcrumbs -->
      <nav class="flex mb-6 text-sm text-gray-500 items-center gap-2">
        <router-link to="/" class="hover:text-[#ea580c] transition-colors">Accueil</router-link>
        <span class="text-gray-300">/</span>
        <span class="font-medium text-gray-900 truncate">{{ annonce.titreannonce }}</span>
      </nav>

      <!-- Photos Section -->
      <div class="relative mb-8 group">
        <div v-if="annonce.photos && annonce.photos.length > 0" class="overflow-hidden rounded-3xl shadow-sm bg-gray-100">
          <div
            class="flex transition-transform duration-500 h-[450px]"
            :style="{ transform: `translateX(-${currentIndex * 100}%)` }"
          >
            <div
              v-for="(photo, index) in annonce.photos"
              :key="index"
              class="flex-shrink-0 w-full h-full"
            >
              <img :src="photo.lienphoto" :alt="annonce.titreannonce" class="w-full h-full object-cover" />
            </div>
          </div>
          
          <!-- Navigation Buttons -->
          <button
            v-if="annonce.photos.length > 1"
            @click="prevImage"
            class="absolute top-1/2 left-4 -translate-y-1/2 bg-white/80 hover:bg-white rounded-full p-3 shadow-lg transition-all opacity-0 group-hover:opacity-100"
          >
            <svg class="w-6 h-6 text-gray-900" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
            </svg>
          </button>
          <button
            v-if="annonce.photos.length > 1"
            @click="nextImage"
            class="absolute top-1/2 right-4 -translate-y-1/2 bg-white/80 hover:bg-white rounded-full p-3 shadow-lg transition-all opacity-0 group-hover:opacity-100"
          >
            <svg class="w-6 h-6 text-gray-900" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
            </svg>
          </button>
          
          <!-- Indicators -->
          <div v-if="annonce.photos.length > 1" class="absolute bottom-6 w-full flex justify-center gap-2">
            <div 
              v-for="(_, index) in annonce.photos" 
              :key="index"
              class="h-2 rounded-full transition-all duration-300"
              :class="currentIndex === index ? 'bg-white w-6' : 'bg-white/50 w-2'"
            ></div>
          </div>
        </div>
        
        <!-- Placeholder if no photos -->
        <div v-else class="w-full h-[450px] bg-gray-100 rounded-3xl flex items-center justify-center">
          <svg class="w-20 h-20 text-gray-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
          </svg>
        </div>
      </div>

      <div class="grid grid-cols-1 lg:grid-cols-3 gap-12">
        <!-- Content Column -->
        <div class="lg:col-span-2 space-y-8">
          <div class="pb-8 border-b border-gray-100">
            <h1 class="text-4xl font-black text-gray-900 mb-4">{{ annonce.titreannonce }}</h1>
            <div class="flex items-center gap-4 text-gray-600">
              <span class="flex items-center gap-1">
                <svg class="w-5 h-5 text-[#ea580c]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z" />
                </svg>
                {{ annonce.idadresseNavigation?.idvilleNavigation?.nomville || "Ville inconnue" }}
              </span>
              <span>·</span>
              <span>{{ annonce.idtypehebergementNavigation?.nomtypehebergement || "Logement" }}</span>
              <span>·</span>
              <span>{{ annonce.capacite || 0 }} voyageurs</span>
            </div>
        
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
            <h2 class="text-2xl font-bold mb-4 text-gray-900">À propos de ce logement</h2>
            <p class="text-gray-600 leading-relaxed whitespace-pre-line text-lg">
              {{ annonce.descriptionannonce }}
            </p>
          </div>
        </div>

        <!-- Sidebar Column -->
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

    <!-- Not Found State -->
    <div v-else class="flex flex-col items-center justify-center min-h-[60vh] px-4">
      <div class="bg-orange-50 p-6 rounded-full mb-6">
        <svg class="w-12 h-12 text-[#ea580c]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9.172 9.172a4 4 0 015.656 0M9 10h.01M15 10h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
        </svg>
      </div>
      <h2 class="text-2xl font-bold text-gray-900 mb-2">Annonce introuvable</h2>
      <p class="text-gray-500 mb-8 text-center max-w-md">
        Désolé, nous ne parvenons pas à trouver l'annonce que vous recherchez. Elle a peut-être été supprimée.
      </p>
      <router-link to="/" class="bg-gray-900 text-white font-bold py-3 px-8 rounded-xl hover:bg-gray-800 transition-all">
        Retour à l'accueil
      </router-link>
    </div>
  </div>
</template>

<style scoped>
.group:hover button {
  opacity: 1;
}
</style>