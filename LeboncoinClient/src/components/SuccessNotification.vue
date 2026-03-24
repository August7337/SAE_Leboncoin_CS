<template>
  <transition
    enter-active-class="transform ease-out duration-300 transition"
    enter-from-class="translate-y-2 opacity-0 sm:translate-y-0 sm:translate-x-2"
    enter-to-class="translate-y-0 opacity-100 sm:translate-x-0"
    leave-active-class="transition ease-in duration-100"
    leave-from-class="opacity-100"
    leave-to-class="opacity-0"
  >
    <div v-if="notificationState.show" class="fixed bottom-4 right-4 z-[9999] max-w-sm w-full bg-white shadow-2xl rounded-2xl pointer-events-auto border border-green-100 overflow-hidden">
      <div class="p-4">
        <div class="flex items-start">
          <div class="flex-shrink-0">
            <svg class="h-6 w-6 text-green-500" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" d="M9 12.75L11.25 15 15 9.75M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
            </svg>
          </div>
          <div class="ml-3 w-0 flex-1 pt-0.5">
            <p class="text-sm font-bold text-gray-900">Succès</p>
            <p class="mt-1 text-sm text-gray-500">{{ notificationState.message }}</p>
          </div>
          <div class="ml-4 flex-shrink-0 flex">
            <button @click="notificationState.show = false" class="bg-white rounded-md inline-flex text-gray-400 hover:text-gray-500 focus:outline-none">
              <span class="sr-only">Fermer</span>
              <svg class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                <path d="M6.28 5.22a.75.75 0 00-1.06 1.06L8.94 10l-3.72 3.72a.75.75 0 101.06 1.06L10 11.06l3.72 3.72a.75.75 0 101.06-1.06L11.06 10l3.72-3.72a.75.75 0 00-1.06-1.06L10 8.94 6.28 5.22z" />
              </svg>
            </button>
          </div>
        </div>
      </div>
      <div class="bg-green-500 h-1 w-full animate-shrink"></div>
    </div>
  </transition>
</template>

<script setup>
import { notificationState } from '@/notification.js';
</script>

<style scoped>
.animate-shrink {
  animation: shrink 5s linear forwards;
}

@keyframes shrink {
  from { width: 100%; }
  to { width: 0%; }
}
</style>