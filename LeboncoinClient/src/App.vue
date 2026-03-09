<script setup>
import { ref } from 'vue'
import Header from './components/Header.vue'
import Footer from './components/Footer.vue'
import AnnonceList from './components/AnnonceList.vue'

const testAnnonces = ref([
  {
    idannonce: 1,
    titreannonce: 'Superbe villa avec piscine',
    prixnuitee: '150.00',
    nombreetoilesleboncoin: 4.5,
    capacite: 6,
    typehebergement: { nomtypehebergement: 'Villa' },
    adresse: { ville: { nomville: 'Nice', codepostal: '06000' } },
    photos: [
      {
        lienphoto:
          'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?auto=format&fit=crop&w=800&q=80',
      },
      {
        lienphoto:
          'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?auto=format&fit=crop&w=800&q=80',
      },
    ],
  },
  {
    idannonce: 2,
    titreannonce: 'Appartement cosy centre-ville',
    prixnuitee: '85.00',
    nombreetoilesleboncoin: 4.8,
    capacite: 2,
    typehebergement: { nomtypehebergement: 'Appartement' },
    adresse: { ville: { nomville: 'Lyon', codepostal: '69001' } },
    photos: [
      {
        lienphoto:
          'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?auto=format&fit=crop&w=800&q=80',
      },
    ],
  },
])
</script>

<template>
  <div class="min-h-screen flex flex-col">
    <Header />

    <main class="flex-grow max-w-5xl mx-auto w-full px-4 sm:px-6 lg:px-8 mt-8">
      <div class="p-4 md:p-8">
        <h1 class="text-xl font-bold mb-6">Annonces Location vacances</h1>

        <AnnonceList :annonces="testAnnonces" />
      </div>
    </main>

    <Footer />
  </div>
</template>

<style scoped></style>
