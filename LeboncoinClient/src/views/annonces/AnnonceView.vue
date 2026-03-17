<template>
  <div v-if="loading" class="flex justify-center items-center min-h-[60vh]">
    <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-[#ea580c]"></div>
  </div>

  <div v-else-if="annonce" class="max-w-6xl mx-auto px-4 md:px-12 xl:px-6 py-8">
    <nav class="flex mb-6 text-sm text-gray-500 items-center gap-2">
      <router-link to="/" class="hover:text-[#ea580c] transition-colors">Accueil</router-link>
      <span class="text-gray-300">/</span>
      <span class="font-medium text-gray-900 truncate">{{ annonce.titreannonce }}</span>
    </nav>

    <div class="mb-6">
      <h1 class="text-2xl md:text-3xl font-black text-gray-900 mb-2">{{ annonce.titreannonce }}</h1>
      <p class="text-gray-600 underline">
        {{ annonce.idadresseNavigation?.ville?.nomville || "Ville non renseignée" }}
      </p>
    </div>

    <div v-if="annonce.photos?.length" class="relative mb-8">
      <div class="overflow-hidden rounded-3xl shadow-sm bg-gray-100">
        <div
          class="flex transition-transform duration-500"
          :style="{ transform: `translateX(-${currentIndex * 100}%)` }"
        >
          <div
            v-for="(photo, index) in annonce.photos"
            :key="index"
            class="flex-shrink-0 w-full h-[400px]"
          >
            <img :src="photo.lienphoto" :alt="annonce.titreannonce" class="w-full h-full object-cover" />
          </div>
        </div>
      </div>

      <button
        v-if="annonce.photos.length > 1"
        @click="prevImage"
        class="absolute top-1/2 left-2 -translate-y-1/2 bg-white/80 rounded-full p-2 shadow hover:bg-white"
      >
        ‹
      </button>
      <button
        v-if="annonce.photos.length > 1"
        @click="nextImage"
        class="absolute top-1/2 right-2 -translate-y-1/2 bg-white/80 rounded-full p-2 shadow hover:bg-white"
      >
        ›
      </button>
    </div>

    <div class="grid grid-cols-1 lg:grid-cols-3 gap-10">
      <div class="lg:col-span-2">
        <h2 class="text-xl font-bold mb-4">À propos de ce logement</h2>
        <p class="text-gray-700">{{ annonce.descriptionannonce }}</p>
      </div>

      <div class="lg:col-span-1">
        <div class="sticky top-24 bg-white border border-gray-200 rounded-3xl p-6 shadow-xl">
          <div class="text-3xl font-black mb-6">
            {{ annonce.prixnuitee }}€ <span class="text-sm font-normal">/ nuit</span>
          </div>
          <button class="w-full bg-[#ea580c] text-white font-black py-4 rounded-2xl">
            Réserver
          </button>
        </div>
      </div>
    </div>
  </div>

  <div v-else class="text-center py-20">
    <p class="text-gray-500">Annonce introuvable</p>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import axios from 'axios'

const route = useRoute()
const annonce = ref(null)
const loading = ref(true)
const annonce = ref(null)

const currentIndex = ref(0)

const nextImage = () => {
  if (!annonce.value.photos) return
  currentIndex.value = (currentIndex.value + 1) % annonce.value.photos.length
}

const prevImage = () => {
  if (!annonce.value.photos) return
  currentIndex.value =
    (currentIndex.value - 1 + annonce.value.photos.length) % annonce.value.photos.length
}

async function fetchAnnonce() {
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

    <div v-else-if="annonce" class="max-w-6xl mx-auto px-4 py-8">
      <div class="grid grid-cols-1 lg:grid-cols-3 gap-12">
        
        <div class="lg:col-span-2 space-y-6">
          <img :src="annonce.lienphoto || 'https://via.placeholder.com/800x500'" class="w-full h-[450px] object-cover rounded-3xl shadow-sm" />
          
          <div class="border-b border-gray-100 pb-6">
            <h1 class="text-3xl font-black text-gray-900">{{ annonce.titreannonce }}</h1>
            <p class="text-gray-500 mt-2">{{ annonce.idadresseNavigation?.ville?.nomville || "Ville inconnue" }}</p>
          </div>

          <div>
            <h2 class="text-xl font-bold mb-4 text-gray-900">Description</h2>
            <p class="text-gray-600 leading-relaxed">{{ annonce.descriptionannonce }}</p>
          </div>
        </div>

        <div class="lg:col-span-1">
          <div class="sticky top-24 bg-white border border-gray-100 rounded-3xl p-8 shadow-xl">
            <div class="flex items-baseline gap-1 mb-8">
              <span class="text-3xl font-black">{{ annonce.prixnuitee }}€</span>
              <span class="text-gray-500">/ nuit</span>
            </div>

            <button class="w-full bg-[#ea580c] text-white font-black py-4 rounded-2xl hover:bg-[#c2410c] transition-all mb-4">
              Réserver maintenant
            </button>
            
            <p class="text-xs text-center text-gray-400">Paiement sécurisé via leboncoin</p>
          </div>
        </div>

      </div>
    </div>
  </div>
</template>