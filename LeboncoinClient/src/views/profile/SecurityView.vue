<script setup>
import { ref } from 'vue'

const passwords = ref({
  current: '',
  new: '',
  confirm: '',
})
</script>

<template>
  <div class="min-h-screen bg-[#f5f5f5] py-10">
    <div class="max-w-2xl mx-auto px-4">
      <h1 class="text-2xl font-black text-gray-900 mb-8">Sécurité du compte</h1>

      <div class="bg-white rounded-3xl p-8 shadow-sm border border-gray-100">
        <h2 class="text-lg font-bold mb-6">Changer mon mot de passe</h2>

        <div class="space-y-4">
          <div>
            <label class="block text-sm font-bold mb-2 text-gray-700">Mot de passe actuel</label>
            <input
              v-model="passwords.current"
              type="password"
              class="w-full px-4 py-3 rounded-xl border border-gray-200 outline-none focus:border-[#ea580c]"
            />
          </div>
          <hr class="my-4 border-gray-100" />
          <div>
            <label class="block text-sm font-bold mb-2 text-gray-700">Nouveau mot de passe</label>
            <input
              v-model="passwords.new"
              type="password"
              class="w-full px-4 py-3 rounded-xl border border-gray-200 outline-none focus:border-[#ea580c]"
            />
          </div>
          <div>
            <label class="block text-sm font-bold mb-2 text-gray-700"
              >Confirmer le nouveau mot de passe</label
            >
            <input
              v-model="passwords.confirm"
              type="password"
              class="w-full px-4 py-3 rounded-xl border border-gray-200 outline-none focus:border-[#ea580c]"
            />
          </div>
        </div>

        <button
          class="w-full mt-8 bg-black text-white font-black py-4 rounded-2xl hover:bg-gray-800 transition-all"
        >
          Mettre à jour le mot de passe
        </button>
      </div>
    </div>
  </div>
</template>
