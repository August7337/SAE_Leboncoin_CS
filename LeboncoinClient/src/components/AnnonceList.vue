<script setup>
import { ref } from 'vue'

// Props pour recevoir les données des annonces
const props = defineProps({
  annonces: {
    type: Array,
    default: () => [],
  },
  favoriteIds: {
    type: Array,
    default: () => [],
  },
  isAuth: {
    type: Boolean,
    default: false,
  },
})

// Fonction pour formater le prix (équivalent au preg_replace/number_format PHP)
const formatPrice = (price) => {
  if (!price) return '0'
  return parseFloat(price).toString() // Enlève les .00 inutiles
}

// Gestion des favoris côté invité (localStorage)
const guestFavorites = ref(JSON.parse(localStorage.getItem('guest_favorites') || '[]'))

const isFavorite = (id) => {
  if (props.isAuth) {
    return props.favoriteIds.includes(id)
  }
  return guestFavorites.value.includes(id)
}

const toggleFavorite = async (id) => {
  if (props.isAuth) {
    // Logique d'appel API pour utilisateur connecté (à adapter avec votre vrai store/API)
    try {
      /* Exemple d'appel API:
      await fetch('/api/favorites/toggle', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: JSON.stringify({ idannonce: id })
      })
      */
      console.log('Toggle favori connecté pour', id)
      // Il faudrait idéalement émettre un événement pour mettre à jour la liste des favoris du parent
    } catch (error) {
      console.error('Erreur lors du changement de favori:', error)
    }
  } else {
    // Logique invité (localStorage)
    if (guestFavorites.value.includes(id)) {
      guestFavorites.value = guestFavorites.value.filter((f) => f !== id)
    } else {
      guestFavorites.value.push(id)
    }
    localStorage.setItem('guest_favorites', JSON.stringify(guestFavorites.value))
  }
}

// État pour savoir quelle photo est affichée dans le carrousel de chaque annonce
const currentPhotoIndex = ref({})

const initCarouselIndex = (id) => {
  if (currentPhotoIndex.value[id] === undefined) {
    currentPhotoIndex.value[id] = 0
  }
  return currentPhotoIndex.value[id]
}

const scrollLeft = (id, totalPhotos) => {
  const currentIndex = currentPhotoIndex.value[id] || 0
  const carousel = document.getElementById(`carousel-${id}`)

  if (currentIndex > 0) {
    currentPhotoIndex.value[id] = currentIndex - 1
    carousel.scrollTo({
      left: carousel.clientWidth * currentPhotoIndex.value[id],
      behavior: 'smooth',
    })
  } else {
    // Boucler à la fin
    currentPhotoIndex.value[id] = totalPhotos - 1
    carousel.scrollTo({ left: carousel.scrollWidth, behavior: 'smooth' })
  }
}

const scrollRight = (id, totalPhotos) => {
  const currentIndex = currentPhotoIndex.value[id] || 0
  const carousel = document.getElementById(`carousel-${id}`)

  if (currentIndex < totalPhotos - 1) {
    currentPhotoIndex.value[id] = currentIndex + 1
    carousel.scrollTo({
      left: carousel.clientWidth * currentPhotoIndex.value[id],
      behavior: 'smooth',
    })
  } else {
    // Boucler au début
    currentPhotoIndex.value[id] = 0
    carousel.scrollTo({ left: 0, behavior: 'smooth' })
  }
}

const onScroll = (e, id) => {
  const el = e.target
  currentPhotoIndex.value[id] = Math.round(el.scrollLeft / el.clientWidth)
}
</script>

<template>
  <div>
    <div v-if="!annonces || annonces.length === 0" class="p-10 text-center text-gray-500">
      Aucune annonce trouvée pour cette recherche.
    </div>

    <!-- Liste des annonces -->
    <div v-else>
      <div
        v-for="annonce in annonces"
        :key="annonce.idannonce"
        class="flex flex-col md:flex-row mb-6 gap-4 bg-white md:bg-transparent rounded-2xl md:rounded-none shadow-sm md:shadow-none p-3 md:p-0"
      >
        <div class="relative w-full h-56 md:w-80 md:h-56 flex-shrink-0">
          <button
            @click.prevent="scrollLeft(annonce.idannonce, annonce.photos?.length || 1)"
            class="absolute left-2 top-1/2 -translate-y-1/2 bg-black/40 text-white rounded-full w-8 h-8 flex items-center justify-center z-10 hover:bg-black/60 transition"
          >
            ‹
          </button>
          <button
            @click.prevent="scrollRight(annonce.idannonce, annonce.photos?.length || 1)"
            class="absolute right-2 top-1/2 -translate-y-1/2 bg-black/40 text-white rounded-full w-8 h-8 flex items-center justify-center z-10 hover:bg-black/60 transition"
          >
            ›
          </button>

          <div
            :id="`carousel-${annonce.idannonce}`"
            @scroll="(e) => onScroll(e, annonce.idannonce)"
            class="w-full h-full overflow-x-auto flex gap-2 rounded-3xl scroll-smooth snap-x snap-mandatory scroll r-hide scrollbar-hide"
            style="scrollbar-width: none; -ms-overflow-style: none"
          >
            <template v-if="annonce.photos && annonce.photos.length > 0">
              <div
                v-for="(photo, index) in annonce.photos"
                :key="index"
                class="min-w-full h-full snap-start rounded-3xl overflow-hidden"
              >
                <img
                  :src="photo.lienphoto"
                  :alt="`${annonce.titreannonce} - Photo ${index + 1}`"
                  loading="lazy"
                  class="w-full h-full object-cover"
                />
              </div>
            </template>
            <template v-else>
              <div
                class="min-w-full h-full snap-start rounded-3xl overflow-hidden bg-gray-200 flex items-center justify-center"
              >
                <span class="text-gray-400">Pas d'image</span>
              </div>
            </template>
          </div>

          <div class="absolute bottom-1 w-full flex justify-center gap-2">
            <div
              v-for="(_, index) in annonce.photos || [1]"
              :key="index"
              class="rounded-full transition-all duration-300"
              :class="
                initCarouselIndex(annonce.idannonce) === index
                  ? 'bg-white w-3 h-3'
                  : 'bg-white/50 w-2 h-2'
              "
            ></div>
          </div>

          <div class="absolute top-2 right-2 z-20">
            <button
              @click.prevent="toggleFavorite(annonce.idannonce)"
              class="bg-white/80 backdrop-blur-sm p-2 rounded-full shadow hover:bg-white transition relative"
            >
              <svg
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 24 24"
                stroke-width="1.5"
                stroke="currentColor"
                class="w-5 h-5 transition-colors duration-300"
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
          class="flex h-auto flex-col justify-between w-full"
        >
          <div>
            <div class="gap-x-sm flex items-center justify-between w-full">
              <h2 class="font-black">{{ annonce.titreannonce }}</h2>
              <div class="flex">
                <svg
                  class="mr-0.5"
                  style="fill: #b84a14; height: 18px"
                  viewBox="0 0 24 24"
                  xmlns="http://www.w3.org/2000/svg"
                  fill="currentColor"
                >
                  <path
                    d="M11.0437 2.29647C10.7942 2.46286 10.5447 2.71245 10.3784 3.04524L8.29938 7.6211L3.55925 8.28668C3.22661 8.28668 2.97713 8.45307 2.64449 8.61947C2.39501 8.86906 2.14553 9.11865 2.06237 9.45144C1.97921 9.86742 1.97921 10.2002 2.06237 10.533C2.14553 10.8658 2.31185 11.1986 2.56133 11.4482L6.05405 14.9425L5.22245 19.9343C5.13929 20.2671 5.22245 20.5999 5.30561 20.9327C5.38877 21.2655 5.63825 21.5151 5.88773 21.6814C6.13721 21.8478 6.46985 22.0142 6.8025 22.0142C7.13514 22.0142 7.46778 21.931 7.71726 21.8478L12.0416 19.5183L16.3659 21.8478C16.6154 22.0142 16.948 22.0974 17.2807 22.0142C17.6133 22.0142 17.9459 21.8478 18.1954 21.6814C18.4449 21.5151 18.6944 21.1823 18.7775 20.9327C18.8607 20.5999 18.9439 20.2671 18.8607 19.9343L18.0291 14.9425L21.4387 11.365C21.6882 11.1154 21.8545 10.8658 21.9376 10.533C22.0208 10.2002 22.0208 9.86742 21.9376 9.53464C21.8545 9.20185 21.6882 8.95225 21.4387 8.70266C21.1892 8.45307 20.8566 8.36987 20.6071 8.28668L15.8669 7.5379L13.7048 3.04524C13.5385 2.71245 13.3721 2.46286 13.0395 2.29647C12.79 2.13007 12.5405 2.04688 12.2911 2.04688H11.9584C11.5426 2.13007 11.2931 2.21327 11.0437 2.29647Z"
                  ></path>
                </svg>
                <span class="text-sm opacity-75">{{ annonce.nombreetoilesleboncoin || 0 }}</span>
              </div>
            </div>

            <p v-if="annonce.nombreetoilesleboncoin">{{ annonce.nombreetoilesleboncoin }} / 5</p>

            <div class="text-sm">
              {{ annonce.capacite || '?' }} pers.
              <span class="mx-1 text-neutral inline-block font-bold">·</span>
              {{ annonce.typehebergement?.nomtypehebergement || 'Non spécifié' }}
            </div>
          </div>

          <div>
            <p class="font-bold text-sm">
              <small>à partir de </small>{{ formatPrice(annonce.prixnuitee) }} €
              <small> / nuit</small>
            </p>
            <p class="text-xs opacity-75" v-if="annonce.adresse?.ville">
              {{ annonce.adresse.ville.nomville }} {{ annonce.adresse.ville.codepostal }}
            </p>
          </div>
        </router-link>
      </div>
      <hr class="my-6 opacity-50" />
    </div>
  </div>
</template>

<style scoped>
/* Pour cacher la scrollbar mais garder le scroll actif */
.scrollbar-hide::-webkit-scrollbar {
  display: none;
}
</style>
