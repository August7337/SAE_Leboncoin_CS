<script setup>
defineProps({
  title: { type: String, required: true },
  description: { type: String, required: true },
  linkTo: { type: String, default: '/' },
  linkLabel: { type: String, required: true },
})
</script>

<template>
  <div class="bg-white rounded-3xl p-12 text-center shadow-sm border border-gray-100">
    <div class="bg-orange-50 w-20 h-20 rounded-full flex items-center justify-center mx-auto mb-4">
      <slot name="icon" />
    </div>
    <h2 class="text-xl font-bold text-gray-900">{{ title }}</h2>
    <p class="text-gray-500 mt-2">{{ description }}</p>
    <router-link
      :to="linkTo"
      class="inline-block mt-6 bg-[#ea580c] hover:bg-[#c2410c] text-white font-bold py-3 px-6 rounded-xl transition-colors"
    >
      {{ linkLabel }}
    </router-link>
  </div>
</template>
