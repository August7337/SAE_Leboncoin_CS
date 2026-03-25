<template>
  <footer class="bg-gray-100 border-t border-gray-200 py-6 mt-12">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 flex flex-col md:flex-row justify-between items-center gap-4 text-sm text-gray-600">
      <div>
        &copy; {{ currentYear }} Leboncoin. Tous droits réservés.
      </div>
      <div class="flex gap-6">
        <router-link to="/donnees-personnelles" class="hover:text-orange-600 hover:underline">
          Données personnelles
        </router-link>
        
        <router-link to="/politique-cookies" class="hover:text-orange-600 hover:underline">
          Politique de cookies
        </router-link>
        
        <button type="button" @click="openCookieSettings" class="hover:text-orange-600 hover:underline">
          Gestion des cookies
        </button>
      </div>
    </div>
  </footer>
</template>

<script setup>
import { computed } from 'vue';
import { openCookieSettings } from '@/cookieManager.js';

const currentYear = computed(() => new Date().getFullYear());
</script>
