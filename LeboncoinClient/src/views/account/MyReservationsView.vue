<script setup>
import { ref, onMounted, computed } from 'vue'
import { authState } from '@/auth'
import reservationsService from '@/services/reservationsService'
import { useRouter } from 'vue-router'
import PhotoCarousel from '@/components/PhotoCarousel.vue'

const router = useRouter()
const reservations = ref([])
const loading = ref(true)
const error = ref(null)
const activeTab = ref('upcoming')

const fetchReservations = async () => {
  loading.value = true
  error.value = null
  try {
    const data = await reservationsService.getByUserId(authState.user.idutilisateur)
    console.log('Reservations data:', data)
    reservations.value = data
  } catch (err) {
    console.error('Error fetching reservations:', err)
    error.value = 'Impossible de charger vos réservations.'
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  if (!authState.isLoggedIn()) {
    router.push('/login')
    return
  }
  fetchReservations()
})

const upcomingReservations = computed(() => {
    const now = new Date()
    return reservations.value.filter(res => {
        const endDate = new Date(res.iddatefinreservationNavigation?.date1)
        return endDate >= now
    }).sort((a, b) => new Date(a.iddatedebutreservationNavigation?.date1) - new Date(b.iddatedebutreservationNavigation?.date1))
})

const pastReservations = computed(() => {
    const now = new Date()
    return reservations.value.filter(res => {
        const endDate = new Date(res.iddatefinreservationNavigation?.date1)
        return endDate < now
    }).sort((a, b) => new Date(b.iddatedebutreservationNavigation?.date1) - new Date(a.iddatedebutreservationNavigation?.date1))
})

const filteredReservations = computed(() => {
    return activeTab.value === 'upcoming' ? upcomingReservations.value : pastReservations.value
})

const formatDate = (dateStr) => {
  if (!dateStr) return 'N/A'
  return new Date(dateStr).toLocaleDateString('fr-FR', { day: 'numeric', month: 'long', year: 'numeric' })
}

const formatShortDate = (dateStr) => {
    if (!dateStr) return 'N/A'
    return new Date(dateStr).toLocaleDateString('fr-FR', { day: 'numeric', month: 'short' })
}

const getPhotoUrl = (photo) => {
    if (photo.lienphoto.startsWith('http')) return photo.lienphoto
    return `http://localhost:5091${photo.lienphoto}` // Adjust if needed
}

const goToEdit = (resId) => {
    router.push({ name: 'edit-reservation', params: { id: resId } })
}
</script>

<template>
  <div class="bg-[#f8f9fb] min-h-screen pb-12">
    <main class="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 py-10">
      <div class="mb-10 flex flex-col md:flex-row md:items-end md:justify-between gap-6">
        <div>
          <h1 class="text-3xl font-black text-gray-900 tracking-tight">Mes voyages</h1>
          <p class="text-gray-500 mt-2 font-medium">Retrouvez tous vos séjours passés et à venir.</p>
        </div>
        <router-link to="/" class="hidden md:flex items-center gap-2 text-sm font-black text-orange-600 hover:text-orange-700 transition-colors">
            <span>Explorer plus d'annonces</span>
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2.5" stroke="currentColor" class="w-4 h-4">
                <path stroke-linecap="round" stroke-linejoin="round" d="M13.5 4.5L21 12m0 0l-7.5 7.5M21 12H3" />
            </svg>
        </router-link>
      </div>

      <!-- Tabs -->
      <div class="flex border-b border-gray-200 mb-8 text-sm font-medium">
        <button 
            @click="activeTab = 'upcoming'"
            :class="{ 'border-orange-600 text-orange-600': activeTab === 'upcoming', 'border-transparent text-gray-500 hover:text-gray-700': activeTab !== 'upcoming' }"
            class="px-6 py-4 border-b-2 font-black transition-all duration-200 focus:outline-none uppercase tracking-wider"
        >
            À venir ({{ upcomingReservations.length }})
        </button>
        <button 
            @click="activeTab = 'history'"
            :class="{ 'border-orange-600 text-orange-600': activeTab === 'history', 'border-transparent text-gray-500 hover:text-gray-700': activeTab !== 'history' }"
            class="px-6 py-4 border-b-2 font-black transition-all duration-200 focus:outline-none uppercase tracking-wider"
        >
            Historique ({{ pastReservations.length }})
        </button>
      </div>

      <div v-if="loading" class="flex justify-center items-center py-32">
        <div class="animate-spin rounded-full h-12 w-12 border-4 border-orange-100 border-t-orange-600"></div>
      </div>

      <div v-else-if="error" class="bg-red-50 border border-red-200 text-red-700 px-6 py-4 rounded-2xl shadow-sm font-medium">
        {{ error }}
      </div>

      <div v-else-if="filteredReservations.length === 0" class="bg-white border border-gray-200 rounded-3xl p-16 text-center shadow-sm">
        <div class="w-24 h-24 bg-gray-50 rounded-full flex items-center justify-center mx-auto mb-6 text-gray-300">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-12 h-12">
                <path stroke-linecap="round" stroke-linejoin="round" d="M21 12a2.25 2.25 0 00-2.25-2.25H15a3 3 0 11-6 0H5.25A2.25 2.25 0 003 12m18 0v6a2.25 2.25 0 01-2.25 2.25H5.25A2.25 2.25 0 013 18v-6m18 0V9M3 12V9m18 0a2.25 2.25 0 00-2.25-2.25H5.25A2.25 2.25 0 003 9m18 0V6a2.25 2.25 0 00-2.25-2.25H5.25A2.25 2.25 0 003 6v3" />
            </svg>
        </div>
        <h2 class="text-2xl font-black text-gray-900 mb-2">
            {{ activeTab === 'upcoming' ? "Vous n'avez aucun voyage prévu" : "Votre historique est vide" }}
        </h2>
        <p class="text-gray-500 mb-10 max-w-sm mx-auto font-medium">
            {{ activeTab === 'upcoming' ? "Le monde vous attend, commencez à explorer !" : "Vos voyages passés apparaîtront ici." }}
        </p>
        <router-link to="/" class="inline-flex items-center px-8 py-4 border border-transparent text-lg font-black rounded-2xl text-white bg-orange-600 hover:bg-orange-700 transition-all shadow-xl shadow-orange-100 uppercase tracking-wide">
            Explorer les logements
        </router-link>
      </div>

      <div v-else class="space-y-6">
        <div v-for="res in filteredReservations" :key="res.idreservation" class="bg-white border border-gray-200 rounded-3xl overflow-hidden shadow-sm hover:shadow-md transition-all duration-300 flex flex-col sm:flex-row min-h-[200px]">
            <!-- Image Section -->
            <div class="w-full sm:w-64 h-48 sm:h-auto flex-shrink-0 relative overflow-hidden group">
                <PhotoCarousel v-if="res.idannonceNavigation?.photos" :photos="res.idannonceNavigation.photos" height="h-full" />
                <img v-else src="https://via.placeholder.com/400x300?text=Pas+d'image" class="w-full h-full object-cover" />
                
                <!-- Status Badge -->
                <div class="absolute top-4 left-4 z-10">
                    <span v-if="activeTab === 'upcoming'" class="bg-blue-600 text-white text-[10px] font-black uppercase tracking-widest px-3 py-1.5 rounded-full shadow-lg flex items-center gap-1.5">
                        <span class="w-1.5 h-1.5 rounded-full bg-white animate-pulse"></span> Confirmée
                    </span>
                    <span v-else class="bg-gray-100 text-gray-600 text-[10px] font-black uppercase tracking-widest px-3 py-1.5 rounded-full shadow-sm flex items-center gap-1.5 border border-gray-200">
                        Terminée
                    </span>
                </div>
            </div>
            
            <!-- Content Section -->
            <div class="p-6 flex-grow flex flex-col justify-between">
                <div>
                    <div class="flex justify-between items-start gap-4 mb-3">
                        <div class="flex-grow">
                            <h3 class="text-xl font-black text-gray-900 leading-tight mb-1 line-clamp-1">{{ res.idannonceNavigation?.titreannonce || 'Annonce sans titre' }}</h3>
                            <div class="flex items-center gap-1.5 text-sm text-gray-500 font-medium">
                                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" class="w-3.5 h-3.5">
                                    <path stroke-linecap="round" stroke-linejoin="round" d="M15 10.5a3 3 0 11-6 0 3 3 0 016 0z" />
                                    <path stroke-linecap="round" stroke-linejoin="round" d="M19.5 10.5c0 7.142-7.5 11.25-7.5 11.25S4.5 17.642 4.5 10.5a7.5 7.5 0 1115 0z" />
                                </svg>
                                <span>{{ res.idannonceNavigation?.idadresseNavigation?.idvilleNavigation?.nomville || 'Ville non spécifiée' }}</span>
                            </div>
                        </div>
                        <div class="flex flex-col items-end flex-shrink-0">
                            <span class="text-xl font-black text-gray-900 tracking-tight">{{ res.idannonceNavigation?.prixnuitee || 0 }}€</span>
                            <span class="text-[9px] text-gray-400 font-bold uppercase tracking-widest">par nuit</span>
                        </div>
                    </div>
                    
                    <div class="flex flex-wrap items-center gap-x-6 gap-y-2 mt-4 text-[13px] text-gray-600 font-medium">
                        <div class="flex items-center gap-2">
                            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" class="w-4 h-4 text-gray-400">
                                <path stroke-linecap="round" stroke-linejoin="round" d="M6.75 3v2.25M17.25 3v2.25M3 18.75V7.5a2.25 2.25 0 012.25-2.25h13.5A2.25 2.25 0 0121 7.5v11.25m-18 0A2.25 2.25 0 005.25 21h13.5A2.25 2.25 0 0021 18.75m-18 0v-7.5A2.25 2.25 0 015.25 9h13.5A2.25 2.25 0 0121 11.25v7.5" />
                            </svg>
                            <span>Du {{ formatShortDate(res.iddatedebutreservationNavigation?.date1) }} au {{ formatDate(res.iddatefinreservationNavigation?.date1) }}</span>
                        </div>
                        <div class="flex items-center gap-2">
                            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" class="w-4 h-4 text-gray-400">
                                <path stroke-linecap="round" stroke-linejoin="round" d="M15.75 6a3.75 3.75 0 11-7.5 0 3.75 3.75 0 017.5 0zM4.501 20.118a7.5 7.5 0 0114.998 0A17.933 17.933 0 0112 21.75c-2.676 0-5.216-.584-7.499-1.632z" />
                                </svg>
                            <span>{{ res.inclures?.reduce((acc, c) => acc + c.nombrevoyageur, 0) || 0 }} voyageur(s)</span>
                        </div>
                    </div>
                </div>

                <div class="flex items-center justify-between gap-4 mt-6 pt-4 border-t border-gray-50">
                    <div class="flex items-center gap-4">
                        <button class="text-xs font-black text-gray-500 hover:text-orange-600 transition-colors uppercase tracking-wider flex items-center gap-1.5">
                            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2.5" stroke="currentColor" class="w-4 h-4">
                                <path stroke-linecap="round" stroke-linejoin="round" d="M7.5 8.25h9m-9 3H12m-9.75 1.51c0 1.6 1.123 2.994 2.707 3.227 1.129.166 2.27.293 3.423.379.35.026.67.21.865.501L12 21l2.755-4.133a1.14 1.14 0 01.865-.501 48.172 48.172 0 003.423-.379c1.584-.233 2.707-1.626 2.707-3.228V6.741c0-1.602-1.123-2.995-2.707-3.228A48.394 48.394 0 0012 3c-2.392 0-4.744.175-7.043.513C3.373 3.746 2.25 5.14 2.25 6.741v6.018z" />
                            </svg>
                            Message
                        </button>
                        <button v-if="activeTab === 'upcoming'" @click="goToEdit(res.idreservation)" class="text-xs font-black text-gray-500 hover:text-orange-600 transition-colors uppercase tracking-wider flex items-center gap-1.5">
                            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2.5" stroke="currentColor" class="w-4 h-4">
                                <path stroke-linecap="round" stroke-linejoin="round" d="M16.862 4.487l1.687-1.688a1.875 1.875 0 112.652 2.652L10.582 16.07a4.5 4.5 0 01-1.897 1.13L6 18l.8-2.685a4.5 4.5 0 011.13-1.897l8.932-8.931zm0 0L19.5 7.125M18 14v4.75A2.25 2.25 0 0115.75 21H5.25A2.25 2.25 0 013 18.75V8.25A2.25 2.25 0 015.25 6H10" />
                            </svg>
                            Modifier
                        </button>
                    </div>
                    
                    <button v-if="activeTab === 'upcoming'" class="text-xs font-black text-gray-400 hover:text-red-600 transition-colors uppercase tracking-wider">
                        Annuler
                    </button>
                </div>
            </div>
        </div>
      </div>
    </main>
  </div>
</template>

<style scoped>
.line-clamp-1 {
    display: -webkit-box;
    -webkit-line-clamp: 1;
    -webkit-box-orient: vertical;
    overflow: hidden;
}
</style>
