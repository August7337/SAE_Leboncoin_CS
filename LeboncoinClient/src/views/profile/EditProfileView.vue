<script setup>
import { ref } from 'vue'

const user = ref({
  name: 'Tim',
  email: 'tim@example.com',
  avatar: 'https://ui-avatars.com/api/?name=Tim&background=ea580c&color=fff',
})

const saveProfile = () => {
  console.log('Profil mis à jour :', user.value)
}
</script>

<template>
  <div class="min-h-screen bg-[#f5f5f5] py-10">
    <div class="max-w-2xl mx-auto px-4">
      <h1 class="text-2xl font-black text-gray-900 mb-8">Modifier mon profil</h1>

      <div class="bg-white rounded-3xl p-8 shadow-sm border border-gray-100 space-y-8">
        <div class="flex flex-col items-center gap-4">
          <img :src="user.avatar" class="w-32 h-32 rounded-full border-4 border-orange-50" />
          <button class="text-[#ea580c] font-bold text-sm hover:underline">Changer la photo</button>
        </div>

        <div class="space-y-4">
          <div>
            <label class="block text-sm font-bold mb-2 text-gray-700">Nom complet</label>
            <input
              v-model="user.name"
              type="text"
              class="w-full px-4 py-3 rounded-xl border border-gray-200 outline-none focus:border-[#ea580c] transition-all"
            />
          </div>
          <div>
            <label class="block text-sm font-bold mb-2 text-gray-700">Adresse email</label>
            <input
              v-model="user.email"
              type="email"
              class="w-full px-4 py-3 rounded-xl border border-gray-200 outline-none focus:border-[#ea580c] transition-all"
            />
          </div>
        </div>

        <button
          @click="saveProfile"
          class="w-full bg-[#ea580c] text-white font-black py-4 rounded-2xl shadow-lg shadow-orange-100 hover:bg-[#c2410c] transition-all"
        >
          Enregistrer les modifications
        </button>
      </div>
    </div>
  </div>
</template>
