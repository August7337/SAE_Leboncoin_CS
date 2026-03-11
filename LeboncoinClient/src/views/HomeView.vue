<template>
  <div class="max-w-5xl mx-auto w-full px-4 sm:px-6 lg:px-8 mt-8">
    <h1 class="text-xl font-bold mb-6">Annonces Location vacances</h1>
    <AnnonceList :annonces="testAnnonces" />
  </div>
</template>

<script setup>
import { ref } from 'vue'
import AnnonceList from '../components/AnnonceList.vue' // Vérifie bien le chemin

const testAnnonces = ref([
  {
    idannonce: 1,
    titreannonce: 'Superbe villa avec piscine',
    prixnuitee: '150.00',
    adresse: { ville: { nomville: 'Nice', codepostal: '06000' } },
    photos: [{ lienphoto: 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=800' }],
  },
  {
    idannonce: 2,
    titreannonce: 'Appartement cosy centre-ville',
    prixnuitee: '85.00',
    adresse: { ville: { nomville: 'Lyon', codepostal: '69001' } },
    photos: [{ lienphoto: 'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=800' }],
  }
])
</script>