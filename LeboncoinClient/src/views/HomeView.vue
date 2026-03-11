<template>
  <div class="min-h-screen bg-[#f5f5f5]">
    <div class="max-w-6xl mx-auto px-4 md:px-12 xl:px-6 py-8">
      
      <div class="mb-8">
        <h1 class="text-2xl md:text-3xl font-black text-gray-900 tracking-tight">
          Locations de vacances
        </h1>
        <p class="text-gray-500 text-sm mt-1 font-medium">
          {{ annonces.length }} logements disponibles à Nice et alentours
        </p>
      </div>

      <AnnonceList :annonces="annonces" />

      <div v-if="annonces.length > 0" class="mt-12 flex justify-center">
        <button class="px-8 py-3 border-2 border-gray-200 rounded-2xl font-black text-gray-700 hover:border-[#ea580c] hover:text-[#ea580c] transition-all bg-white shadow-sm active:scale-95">
          Charger plus de résultats
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue';
// Vérifie bien le nombre de "../" selon l'emplacement du fichier
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
    photos: [{ lienphoto: 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=800' }],
  },
  {
    idannonce: 2,
    titreannonce: 'Appartement vue mer',
    prixnuitee: '85.00',
    nombreetoilesleboncoin: 4.2,
    capacite: 2,
    typehebergement: { nomtypehebergement: 'Appartement' },
    adresse: { ville: { nomville: 'Antibes', codepostal: '06600' } },
    photos: [{ lienphoto: 'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=800' }],
  }
]);
</script>