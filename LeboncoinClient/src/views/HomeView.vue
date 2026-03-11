<template>
  <div class="min-h-screen bg-[#f5f5f5]">
    
    <div class="max-w-6xl mx-auto px-4 md:px-12 xl:px-6 py-8">
      
      <div class="mb-8">
        <h1 class="text-2xl md:text-3xl font-black text-gray-900 tracking-tight">
          Locations de vacances
        </h1>
        <p class="text-gray-500 text-sm mt-1">
          {{ annonces.length }} logements disponibles à Nice et alentours
        </p>
      </div>

      <AnnonceList :annonces="annonces" />

      <div v-if="annonces.length > 0" class="mt-12 flex justify-center">
        <button class="px-8 py-3 border-2 border-gray-200 rounded-xl font-bold text-gray-700 hover:border-[#ea580c] hover:text-[#ea580c] transition-all">
          Charger plus de résultats
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import AnnonceList from '../components/AnnonceList.vue';

const annonces = ref([
  {
    idannonce: 1,
    titreannonce: 'Superbe villa avec piscine',
    prixnuitee: '150.00',
    nombreetoilesleboncoin: 4.8,
    capacite: 6,
    typehebergement: { nomtypehebergement: 'Villa' },
    adresse: { ville: { nomville: 'Nice', codepostal: '06000' } },
    photos: [
      { lienphoto: 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?auto=format&fit=crop&w=800&q=80' },
      { lienphoto: 'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?auto=format&fit=crop&w=800&q=80' }
    ],
  }
]);
</script>