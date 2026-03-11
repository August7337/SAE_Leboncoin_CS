<script setup>
import { ref, computed } from 'vue';
import AnnonceList from '../../components/AnnonceList.vue';

const allAnnonces = ref([
  { 
    idannonce: 1, 
    titreannonce: 'Villa Nice', 
    prixnuitee: 150, 
    adresse: { ville: { nomville: 'Nice' } }, 
    photos: [{ lienphoto: 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=800' }],
    nombreetoilesleboncoin: 4.5
  },
  { 
    idannonce: 2, 
    titreannonce: 'Appart Paris', 
    prixnuitee: 90, 
    adresse: { ville: { nomville: 'Paris' } }, 
    photos: [{ lienphoto: 'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=800' }],
    nombreetoilesleboncoin: 4.0
  }
]);

const searchQuery = ref('');

const filteredAnnonces = computed(() => {
  if (!searchQuery.value) return allAnnonces.value;
  return allAnnonces.value.filter(a => 
    a.adresse.ville.nomville.toLowerCase().includes(searchQuery.value.toLowerCase()) ||
    a.titreannonce.toLowerCase().includes(searchQuery.value.toLowerCase())
  );
});
</script>

<template>
  <div class="min-h-screen bg-[#f5f5f5]">
    <div class="bg-white border-b border-gray-200 py-6 sticky top-[73px] z-30 shadow-sm">
      <div class="max-w-6xl mx-auto px-6">
        <div class="relative flex items-center group">
          <input 
            v-model="searchQuery" 
            type="text" 
            placeholder="Où cherchez-vous ? (ex: Nice, Paris...)" 
            class="w-full pl-14 pr-4 py-4 bg-gray-100 rounded-2xl border-2 border-transparent focus:border-[#ea580c] focus:bg-white focus:ring-0 outline-none transition-all text-lg" 
          />
          <svg class="w-6 h-6 absolute left-5 text-gray-400 group-focus-within:text-[#ea580c] transition-colors" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path>
          </svg>
        </div>
      </div>
    </div>

    <div class="max-w-6xl mx-auto px-6 py-10">
      <div class="flex justify-between items-end mb-8">
        <div>
          <h1 class="text-2xl font-black text-gray-900">
            {{ searchQuery ? `Résultats pour "${searchQuery}"` : "Toutes les annonces" }}
          </h1>
          <p class="text-gray-500 font-medium">{{ filteredAnnonces.length }} logements disponibles</p>
        </div>
        
        <div class="hidden md:flex gap-2">
          <button class="px-4 py-2 bg-white border border-gray-200 rounded-xl text-sm font-bold hover:border-black transition-all">Prix croissant</button>
          <button class="px-4 py-2 bg-white border border-gray-200 rounded-xl text-sm font-bold hover:border-black transition-all">Les mieux notés</button>
        </div>
      </div>

      <div v-if="filteredAnnonces.length > 0">
        <AnnonceList :annonces="filteredAnnonces" />
      </div>
      
      <div v-else class="bg-white rounded-3xl p-12 text-center shadow-sm border border-gray-100 mt-10">
        <div class="bg-orange-50 w-20 h-20 rounded-full flex items-center justify-center mx-auto mb-4">
            <svg class="w-10 h-10 text-[#ea580c]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9.172 9.172a4 4 0 015.656 0M9 10h.01M15 10h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path>
            </svg>
        </div>
        <h2 class="text-xl font-bold text-gray-900">Aucun résultat trouvé</h2>
        <p class="text-gray-500 mt-2">Essayez de modifier votre recherche ou de supprimer les filtres.</p>
        <button @click="searchQuery = ''" class="mt-6 text-[#ea580c] font-black hover:underline">Voir toutes les annonces</button>
      </div>
    </div>
  </div>
</template>