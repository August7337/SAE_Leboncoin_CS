<template>
  <div class="min-h-screen bg-[#f5f5f5] py-10">
    <div class="max-w-2xl mx-auto px-4">
      <h1 class="text-2xl font-black text-gray-900 mb-8">Paramètres du compte</h1>

      <div class="bg-white rounded-3xl p-8 shadow-sm border border-gray-100 space-y-6">
        <div>
          <label class="block text-sm font-bold mb-2">Nom complet</label>
          <input
            type="text"
            value="Tim"
            class="w-full px-4 py-3 rounded-xl border border-gray-200 outline-none focus:border-[#ea580c]"
          />
        </div>
        <div>
          <label class="block text-sm font-bold mb-2">Adresse email</label>
          <input
            type="email"
            value="tim@example.com"
            class="w-full px-4 py-3 rounded-xl border border-gray-200 outline-none focus:border-[#ea580c]"
          />
        </div>
        <button
          class="w-full bg-black text-white font-bold py-4 rounded-2xl transition-all hover:bg-gray-800"
        >
          Enregistrer les modifications
        </button>
      </div>
    </div>
  </div>
</template>
