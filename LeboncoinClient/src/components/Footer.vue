<script setup></script>

<template>
  <footer class="bg-gray-100 border-t border-gray-200 py-6 mt-12">
    <div
      class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 flex flex-col md:flex-row justify-between items-center gap-4 text-sm text-gray-600"
    >
      <div>&copy; {{ new Date().getFullYear() }} Leboncoin. Tous droits réservés.</div>
      <div class="flex gap-6">
        <a href="#" class="hover:text-orange-600 hover:underline">Données personnelles</a>
        <a href="#" class="hover:text-orange-600 hover:underline">Politique de cookies</a>
        <a href="#" class="hover:text-orange-600 hover:underline">Gestion des cookies</a>
      </div>
    </div>
  </footer>
</template>
