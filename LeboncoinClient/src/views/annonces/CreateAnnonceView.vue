<script setup>
import { ref } from 'vue';

const form = ref({
  titre: '',
  description: '',
  prix: '',
  capacite: 1,
  ville_id: '',
  photos: []
});

const submit = () => {
  console.log("Envoi des données...", form.value);
};
</script>

<template>
  <div class="min-h-screen bg-[#f5f5f5] py-10">
    <div class="max-w-3xl mx-auto px-4">
      <h1 class="text-2xl font-black text-gray-900 mb-8">Déposer une annonce</h1>

      <form @submit.prevent="submit" class="space-y-6">
        <div class="bg-white rounded-3xl p-6 shadow-sm border border-gray-100">
          <label class="block text-lg font-bold mb-4">Quel est le titre de votre annonce ?</label>
          <input v-model="form.titre" type="text" placeholder="Ex: Studio centre-ville" 
                 class="w-full px-4 py-3 rounded-xl border border-gray-200 focus:border-[#ea580c] outline-none" required />
        </div>

        <div class="bg-white rounded-3xl p-6 shadow-sm border border-gray-100 grid grid-cols-2 gap-4">
          <div>
            <label class="block text-sm font-bold mb-2">Prix par nuit (€)</label>
            <input v-model="form.prix" type="number" class="w-full px-4 py-3 rounded-xl border border-gray-200 focus:border-[#ea580c] outline-none" />
          </div>
          <div>
            <label class="block text-sm font-bold mb-2">Voyageurs max</label>
            <select v-model="form.capacite" class="w-full px-4 py-3 rounded-xl border border-gray-200 focus:border-[#ea580c] outline-none bg-white">
              <option v-for="n in 10" :key="n" :value="n">{{ n }} personnes</option>
            </select>
          </div>
        </div>

        <div class="bg-white rounded-3xl p-6 shadow-sm border border-gray-100">
          <label class="block text-lg font-bold mb-4">Description du bien</label>
          <textarea v-model="form.description" rows="5" class="w-full px-4 py-3 rounded-xl border border-gray-200 focus:border-[#ea580c] outline-none resize-none" placeholder="Décrivez les équipements..."></textarea>
        </div>

        <button type="submit" class="w-full bg-[#ea580c] hover:bg-[#c2410c] text-white font-black py-4 rounded-2xl shadow-lg transition-all text-lg">
          Publier l'annonce
        </button>
      </form>
    </div>
  </div>
</template>