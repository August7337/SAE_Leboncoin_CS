<script setup>
import { ref, onMounted } from 'vue'
import { useRoute } from 'vue-router'

const route = useRoute()
const annonce = ref({ titre: '', prix: 0 })

onMounted(() => {
  annonce.value = { titre: 'Superbe villa avec piscine', prix: 150 }
})
</script>

<template>
  <div class="min-h-screen bg-[#f5f5f5] py-10">
    <div class="max-w-3xl mx-auto px-4">
      <div class="flex justify-between items-center mb-8">
        <h1 class="text-2xl font-black text-gray-900">Modifier : {{ annonce.titre }}</h1>
        <button class="bg-red-50 text-red-600 px-4 py-2 rounded-xl font-bold hover:bg-red-100">
          Supprimer
        </button>
      </div>

      <div class="bg-white rounded-3xl p-8 shadow-sm space-y-6">
        <div>
          <label class="block font-bold mb-2">Modifier le titre</label>
          <input
            v-model="annonce.titre"
            type="text"
            class="w-full px-4 py-3 rounded-xl border border-gray-200 focus:border-[#ea580c] outline-none"
          />
        </div>
        <button class="w-full bg-[#ea580c] text-white font-black py-4 rounded-2xl">
          Mettre à jour l'annonce
        </button>
      </div>
    </div>
  </div>
</template>
