<template>
  <div class="container mx-auto p-8">
    <router-link to="/" class="text-blue-500 underline">← Retour à l'accueil</router-link>
    
    <div v-if="annonce" class="mt-6">
      <h1 class="text-3xl font-bold">{{ annonce.titreannonce }}</h1>
      <p class="text-gray-500">ID de l'annonce : {{ $route.params.id }}</p>
      <div class="bg-gray-100 p-10 mt-4 rounded-lg text-center">
        Contenu de l'annonce {{ $route.params.id }} (Simulation)
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRoute } from 'vue-router'

const route = useRoute()
const annonce = ref({ titreannonce: "Chargement..." })

onMounted(() => {
  // Ici on simule que l'annonce est trouvée
  annonce.value.titreannonce = "Détail de l'annonce " + route.params.id
})
</script>