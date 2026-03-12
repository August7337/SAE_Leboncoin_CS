<script setup>
import AnnonceList from '../../components/AnnonceList.vue'
import { ref } from 'vue'

const favoris = ref([
  {
    idannonce: 1,
    titreannonce: 'Villa Nice',
    prixnuitee: 150,
    adresse: { ville: { nomville: 'Nice' } },
    photos: [{ lienphoto: 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=800' }],
  },
])
</script>

<template>
  <div class="min-h-screen bg-[#f5f5f5] py-10">
    <div class="max-w-6xl mx-auto px-4">
      <h1 class="text-2xl font-black text-gray-900 mb-8">Mes favoris</h1>
      <AnnonceList :annonces="favoris" />
    </div>
  </div>
</template>
