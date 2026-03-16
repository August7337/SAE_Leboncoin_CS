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

    <div class="rounded-3xl overflow-hidden shadow-sm mb-8 bg-gray-100">
      <img
        v-if="annonce.lienphoto"
        :src="annonce.lienphoto"
        :alt="annonce.titreannonce"
        class="w-full h-[400px] object-cover"
      />
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
import annoncesService from '@/services/annoncesService'

const route = useRoute()
const loading = ref(true)
const annonce = ref(null)

onMounted(async () => {
  try {
    const data = await annoncesService.getById(route.params.id)
    annonce.value = data
  } catch (error) {
    console.error('Erreur chargement annonce :', error)
  } finally {
    loading.value = false
  }
})
</script>