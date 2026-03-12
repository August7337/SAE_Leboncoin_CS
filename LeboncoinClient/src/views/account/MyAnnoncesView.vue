<script setup>
// Même si c'est vide pour l'instant, ce bloc est obligatoire pour que Vue compile la page
</script>

<template>
  <div class="min-h-screen bg-[#f5f5f5] py-10">
    <div class="max-w-4xl mx-auto px-4">
      <div class="flex justify-between items-center mb-8">
        <h1 class="text-2xl font-black text-gray-900">Mes annonces</h1>
        <router-link
          to="/create-annonce"
          class="bg-[#ea580c] text-white px-6 py-3 rounded-2xl font-bold hover:bg-[#c2410c] transition-all"
        >
          Publier une nouvelle annonce
        </router-link>
      </div>

      <div class="space-y-4">
        <div
          v-for="n in 3"
          :key="n"
          class="bg-white rounded-3xl p-4 shadow-sm border border-gray-100 flex gap-6 items-center"
        >
          <img
            src="https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=300"
            class="w-32 h-24 object-cover rounded-2xl"
          />
          <div class="flex-1">
            <h3 class="font-bold text-lg">Villa de test #{{ n }}</h3>
            <p class="text-[#ea580c] font-black">150 € / nuit</p>
          </div>
          <div class="flex gap-2">
            <router-link
              :to="'/edit-annonce/' + n"
              class="px-4 py-2 border border-gray-200 rounded-xl font-bold hover:bg-gray-50"
              >Modifier</router-link
            >
            <button
              class="px-4 py-2 border border-red-100 text-red-600 rounded-xl font-bold hover:bg-red-50"
            >
              Supprimer
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
