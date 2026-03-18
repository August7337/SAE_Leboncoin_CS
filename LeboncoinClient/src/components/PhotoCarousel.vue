<script setup>
import { ref } from 'vue'

const props = defineProps({
  photos: { type: Array, default: () => [] },
  height: { type: String, default: 'h-[450px]' }
})

const currentIndex = ref(0)

const next = () => {
  currentIndex.value = (currentIndex.value + 1) % props.photos.length
}

const prev = () => {
  currentIndex.value = (currentIndex.value - 1 + props.photos.length) % props.photos.length
}
</script>

<template>
  <div class="relative group overflow-hidden rounded-2xl" :class="height">

    <div v-if="photos.length > 0" class="w-full h-full">
      <div
        class="flex transition-transform duration-500 h-full"
        :style="{ transform: `translateX(-${currentIndex * 100}%)` }"
      >
        <div v-for="(photo, index) in photos" :key="index" class="flex-shrink-0 w-full h-full">
          <img :src="photo.lienphoto" class="w-full h-full object-cover" loading="lazy" />
        </div>
      </div>

      <button v-if="photos.length > 1" @click.prevent="prev"
        class="absolute top-1/2 left-3 -translate-y-1/2 bg-white/80 hover:bg-white rounded-full p-2 shadow-lg transition-all opacity-0 group-hover:opacity-100 z-10">
        <svg class="w-5 h-5 text-gray-900" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
        </svg>
      </button>
      <button v-if="photos.length > 1" @click.prevent="next"
        class="absolute top-1/2 right-3 -translate-y-1/2 bg-white/80 hover:bg-white rounded-full p-2 shadow-lg transition-all opacity-0 group-hover:opacity-100 z-10">
        <svg class="w-5 h-5 text-gray-900" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
        </svg>
      </button>

      <div v-if="photos.length > 1" class="absolute bottom-3 w-full flex justify-center gap-1.5 z-10">
        <div v-for="(_, index) in photos" :key="index"
          class="h-2 rounded-full transition-all duration-300"
          :class="currentIndex === index ? 'bg-white w-6' : 'bg-white/50 w-2'">
        </div>
      </div>
    </div>

    <div v-else class="w-full h-full bg-gray-200 flex items-center justify-center rounded-2xl">
      <span class="text-gray-400">Pas d'image</span>
    </div>

  </div>
</template>