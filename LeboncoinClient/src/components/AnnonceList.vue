<script setup>
import { ref } from 'vue'

const props = defineProps({
  annonces: { type: Array, default: () => [] },
  favoriteIds: { type: Array, default: () => [] },
  isAuth: { type: Boolean, default: false },
})

const carouselIndices = ref({})

const formatPrice = (price) => {
  if (!price) return '0'
  return parseFloat(price).toString()
}

const scrollLeft = (id) => {
  const el = document.getElementById(`carousel-${id}`)
  if (el) el.scrollLeft -= el.offsetWidth
}

const scrollRight = (id) => {
  const el = document.getElementById(`carousel-${id}`)
  if (el) el.scrollLeft += el.offsetWidth
}

const onScroll = (e, id) => {
  const el = e.target
  const index = Math.round(el.scrollLeft / el.offsetWidth)
  carouselIndices.value[id] = index
}

const initCarouselIndex = (id) => {
  return carouselIndices.value[id] || 0
}

const isFavorite = (id) => props.favoriteIds.includes(id)
const toggleFavorite = (id) => {
  console.log("Toggle favori pour l'ID:", id)
}
</script>

<template>
  <div class="max-w-5xl mx-auto px-4 py-6">
    <div v-if="!annonces.length" class="text-center py-10">
      <p class="text-gray-500 italic">Aucune annonce disponible pour le moment.</p>
    </div>

    <div v-else>
      <div
        v-for="annonce in annonces"
        :key="annonce.idannonce"
        class="flex flex-col md:flex-row mb-8 gap-6 bg-white md:bg-transparent rounded-2xl md:rounded-none shadow-sm md:shadow-none p-3 md:p-0 border md:border-0 border-gray-100"
      >
        <div class="relative w-full h-64 md:w-80 md:h-52 flex-shrink-0 group">
          <button
            @click.prevent="scrollLeft(annonce.idannonce)"
            class="absolute left-2 top-1/2 -translate-y-1/2 bg-black/40 text-white rounded-full w-8 h-8 flex items-center justify-center z-10 hover:bg-black/60 transition opacity-0 group-hover:opacity-100"
          >
            ‹
          </button>

          <button
            @click.prevent="scrollRight(annonce.idannonce)"
            class="absolute right-2 top-1/2 -translate-y-1/2 bg-black/40 text-white rounded-full w-8 h-8 flex items-center justify-center z-10 hover:bg-black/60 transition opacity-0 group-hover:opacity-100"
          >
            ›
          </button>

          <div
            :id="`carousel-${annonce.idannonce}`"
            @scroll="(e) => onScroll(e, annonce.idannonce)"
            class="w-full h-full overflow-x-auto flex rounded-2xl scroll-smooth snap-x snap-mandatory scrollbar-hide"
            style="scrollbar-width: none; -ms-overflow-style: none"
          >
            <template v-if="annonce.photos?.length > 0">
              <div
                v-for="(photo, index) in annonce.photos"
                :key="index"
                class="min-w-full h-full snap-start overflow-hidden"
              >
                <img :src="photo.lienphoto" class="w-full h-full object-cover" loading="lazy" />
              </div>
            </template>
            <div
              v-else
              class="min-w-full h-full snap-start bg-gray-200 flex items-center justify-center"
            >
              <span class="text-gray-400">Pas d'image</span>
            </div>
          </div>

          <div class="absolute bottom-3 w-full flex justify-center gap-1.5 z-10">
            <div
              v-for="(_, index) in annonce.photos?.length > 1 ? annonce.photos : []"
              :key="index"
              class="rounded-full transition-all duration-300"
              :class="
                initCarouselIndex(annonce.idannonce) === index
                  ? 'bg-white w-2 h-2'
                  : 'bg-white/50 w-1.5 h-1.5'
              "
            ></div>
          </div>

          <div class="absolute top-2 right-2 z-20">
            <button
              @click.prevent="toggleFavorite(annonce.idannonce)"
              class="bg-white/90 backdrop-blur-sm p-2 rounded-full shadow-md hover:scale-110 transition"
            >
              <svg
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 24 24"
                stroke-width="1.5"
                stroke="currentColor"
                class="w-5 h-5 transition-colors"
                :class="
                  isFavorite(annonce.idannonce) ? 'text-red-500 fill-red-500' : 'text-gray-600'
                "
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  d="M21 8.25c0-2.485-2.099-4.5-4.688-4.5-1.935 0-3.597 1.126-4.312 2.733-.715-1.607-2.377-2.733-4.313-2.733C5.1 3.75 3 5.765 3 8.25c0 7.22 9 12 9 12s9-4.78 9-12z"
                />
              </svg>
            </button>
          </div>
        </div>

        <router-link
          :to="`/annonce/${annonce.idannonce}`"
          class="flex flex-col justify-between w-full py-1 hover:opacity-80 transition-opacity"
        >
          <div>
            <div class="flex items-center justify-between w-full mb-1">
              <h2 class="text-lg font-bold text-gray-900 leading-tight">
                {{ annonce.titreannonce }}
              </h2>
              <div class="flex items-center bg-gray-100 px-2 py-0.5 rounded-md">
                <svg
                  class="w-3.5 h-3.5 text-orange-600 mr-1"
                  fill="currentColor"
                  viewBox="0 0 24 24"
                >
                  <path
                    d="M11.0437 2.29647C10.7942 2.46286 10.5447 2.71245 10.3784 3.04524L8.29938 7.6211L3.55925 8.28668C3.22661 8.28668 2.97713 8.45307 2.64449 8.61947C2.39501 8.86906 2.14553 9.11865 2.06237 9.45144C1.97921 9.86742 1.97921 10.2002 2.06237 10.533C2.14553 10.8658 2.31185 11.1986 2.56133 11.4482L6.05405 14.9425L5.22245 19.9343C5.13929 20.2671 5.22245 20.5999 5.30561 20.9327C5.38877 21.2655 5.63825 21.5151 5.88773 21.6814C6.13721 21.8478 6.46985 22.0142 6.8025 22.0142C7.13514 22.0142 7.46778 21.931 7.71726 21.8478L12.0416 19.5183L16.3659 21.8478C16.6154 22.0142 16.948 22.0974 17.2807 22.0142C17.6133 22.0142 17.9459 21.8478 18.1954 21.6814C18.4449 21.5151 18.6944 21.1823 18.7775 20.9327C18.8607 20.5999 18.9439 20.2671 18.8607 19.9343L18.0291 14.9425L21.4387 11.365C21.6882 11.1154 21.8545 10.8658 21.9376 10.533C22.0208 10.2002 22.0208 9.86742 21.9376 9.53464C21.8545 9.20185 21.6882 8.95225 21.4387 8.70266C21.1892 8.45307 20.8566 8.36987 20.6071 8.28668L15.8669 7.5379L13.7048 3.04524C13.5385 2.71245 13.3721 2.46286 13.0395 2.29647Z"
                  />
                </svg>
                <span class="text-xs font-bold">{{ annonce.nombreetoilesleboncoin || 0 }}</span>
              </div>
            </div>

            <div class="text-sm text-gray-600 flex items-center gap-1 mt-1">
              <span>{{ annonce.capacite || '?' }} pers.</span>
              <span class="font-bold">·</span>
              <span>{{ annonce.typehebergement?.nomtypehebergement || 'Logement' }}</span>
            </div>
          </div>

          <div class="mt-4 md:mt-0">
            <p class="font-bold text-lg text-gray-900">
              {{ formatPrice(annonce.prixnuitee) }} €
              <span class="text-sm font-normal text-gray-500">/ nuit</span>
            </p>
            <p class="text-xs text-gray-500 mt-1" v-if="annonce.adresse?.ville">
              {{ annonce.adresse.ville.nomville }} ({{ annonce.adresse.ville.codepostal }})
            </p>
          </div>
        </router-link>
      </div>
      <hr class="my-6 border-gray-100" />
    </div>
  </div>
</template>

<style scoped>
.scrollbar-hide::-webkit-scrollbar {
  display: none;
}
</style>