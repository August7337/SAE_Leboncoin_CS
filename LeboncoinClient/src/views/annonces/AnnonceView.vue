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
      <div class="flex items-center gap-2 text-gray-600">
        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-5 h-5">
          <path stroke-linecap="round" stroke-linejoin="round" d="M15 10.5a3 3 0 1 1-6 0 3 3 0 0 1 6 0Z" />
          <path stroke-linecap="round" stroke-linejoin="round" d="M19.5 10.5c0 7.142-7.5 11.25-7.5 11.25S4.5 17.642 4.5 10.5a7.5 7.5 0 1 1 15 0Z" />
        </svg>
        <span class="underline decoration-gray-300">{{ annonce.adresse?.ville?.nomville }} ({{ annonce.adresse?.ville?.codepostal }})</span>
      </div>
    </div>

    <div class="rounded-3xl overflow-hidden shadow-sm mb-8 bg-gray-100">
      <img 
        :src="annonce.photos[0]?.lienphoto" 
        class="w-full h-[300px] md:h-[500px] object-cover" 
        :alt="annonce.titreannonce"
      />
    </div>

    <div class="grid grid-cols-1 lg:grid-cols-3 gap-10">
      <div class="lg:col-span-2">
        <section class="border-b border-gray-100 pb-8 mb-8">
          <h2 class="text-xl font-bold text-gray-900 mb-4">À propos de ce logement</h2>
          <div class="flex gap-4 mb-6">
            <div class="bg-gray-50 rounded-2xl p-4 flex-1 text-center border border-gray-100">
              <span class="block text-lg font-black text-[#ea580c]">{{ formatPrice(annonce.prixnuitee) }} €</span>
              <span class="text-gray-500 text-xs font-bold uppercase">Par nuit</span>
            </div>
            <div class="bg-gray-50 rounded-2xl p-4 flex-1 text-center border border-gray-100">
              <span class="block text-lg font-black text-gray-900">{{ annonce.adresse?.ville?.nomville }}</span>
              <span class="text-gray-500 text-xs font-bold uppercase">Ville</span>
            </div>
          </div>
          <p class="text-gray-700 leading-relaxed">
            Profitez de cette superbe villa avec piscine située à Nice. Un cadre idyllique pour vos vacances. 
            Ce logement offre tout le confort nécessaire pour un séjour inoubliable sur la Côte d'Azur.
          </p>
        </section>

        <section class="mb-8">
          <h2 class="text-xl font-bold text-gray-900 mb-6">Équipements inclus</h2>
          <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div class="flex items-center gap-3 text-gray-700">
                <div class="w-2 h-2 bg-[#ea580c] rounded-full"></div>
                Piscine privée
              </div>
              <div class="flex items-center gap-3 text-gray-700">
                <div class="w-2 h-2 bg-[#ea580c] rounded-full"></div>
                Wi-Fi
              </div>
              <div class="flex items-center gap-3 text-gray-700">
                <div class="w-2 h-2 bg-[#ea580c] rounded-full"></div>
                Climatisation
              </div>
          </div>
        </section>
      </div>

      <div class="lg:col-span-1">
        <div class="sticky top-24 bg-white border border-gray-200 rounded-3xl p-6 shadow-xl shadow-gray-100/50">
          <div class="mb-6">
            <span class="text-3xl font-black text-gray-900">{{ formatPrice(annonce.prixnuitee) }}€</span>
            <span class="text-gray-500 ml-1">/ nuit</span>
          </div>

          <button class="w-full bg-[#ea580c] hover:bg-[#c2410c] text-white font-black py-4 rounded-2xl shadow-lg shadow-orange-200 transition-all active:scale-95 text-lg mb-4">
            Réserver maintenant
          </button>
          
          <div class="flex items-center justify-center gap-2 text-gray-400 text-sm">
             <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" class="w-4 h-4 text-green-500">
                <path stroke-linecap="round" stroke-linejoin="round" d="M9 12.75 11.25 15 15 9.75M21 12a9 9 0 1 1-18 0 9 9 0 0 1 18 0Z" />
              </svg>
             Annulation gratuite sous 48h
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { useRoute } from 'vue-router';

const route = useRoute();
const loading = ref(true);
const annonce = ref(null);

const loadData = () => {
  loading.value = true;
  // Simulation API
  setTimeout(() => {
    annonce.value = {
      idannonce: 1,
      titreannonce: 'Superbe villa avec piscine',
      prixnuitee: '150.00',
      adresse: { ville: { nomville: 'Nice', codepostal: '06000' } },
      photos: [{ lienphoto: 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=800' }],
    };
    loading.value = false;
  }, 300);
};

const formatPrice = (p) => parseFloat(p).toFixed(0);

onMounted(loadData);
</script>