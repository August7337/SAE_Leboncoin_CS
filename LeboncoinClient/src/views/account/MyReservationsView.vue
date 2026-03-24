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

const goToEdit = (resId) => {
    router.push({ name: 'edit-reservation', params: { id: resId } })
}
</script>

<template>
  <div class="bg-[#f8f9fb] min-h-screen pb-12">
    <main class="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 py-10">
      <div class="mb-6 flex flex-col md:flex-row md:items-end md:justify-between gap-6">
        <div>
          <h1 class="text-3xl font-bold text-gray-900 mb-6">Mes voyages</h1>
        </div>
      </div>

      <!-- Tabs Style Laravel -->
      <div class="flex border-b border-gray-200 mb-6 text-sm font-medium">
        <button 
            @click="activeTab = 'upcoming'"
            :class="activeTab === 'upcoming' ? 'border-orange-600 text-orange-600' : 'border-transparent text-gray-500 hover:text-gray-700'"
            class="px-6 py-3 border-b-2 font-bold transition-colors duration-200 focus:outline-none"
        >
            En cours ({{ upcomingReservations.length }})
        </button>
        <button 
            @click="activeTab = 'history'"
            :class="activeTab === 'history' ? 'border-orange-600 text-orange-600' : 'border-transparent text-gray-500 hover:text-gray-700'"
            class="px-6 py-3 border-b-2 font-bold transition-colors duration-200 focus:outline-none"
        >
            Historique ({{ pastReservations.length }})
        </button>
      </div>

      <div v-if="loading" class="flex justify-center items-center py-32">
        <div class="animate-spin rounded-full h-10 w-10 border-4 border-orange-100 border-t-orange-600"></div>
      </div>

      <div v-else-if="error" class="bg-red-50 border border-red-200 text-red-700 px-6 py-4 rounded-xl shadow-sm font-medium">
        {{ error }}
      </div>

      <div v-else-if="filteredReservations.length === 0" class="bg-white border border-gray-200 rounded-xl p-12 text-center shadow-sm">
        <div class="text-5xl mb-4">
            {{ activeTab === 'upcoming' ? "🧳" : "📜" }}
        </div>
        <h2 class="text-xl font-bold text-gray-900 mb-2">
            {{ activeTab === 'upcoming' ? "Vous n'avez aucun voyage prévu" : "Votre historique est vide" }}
        </h2>
        <p class="text-gray-500 mb-8 max-w-sm mx-auto font-medium">
            {{ activeTab === 'upcoming' ? "Le monde vous attend, commencez à explorer !" : "Vos voyages passés apparaîtront ici." }}
        </p>
        <router-link to="/" class="inline-flex items-center px-8 py-3.5 border border-transparent text-base font-bold rounded-xl text-white bg-orange-600 hover:bg-orange-700 transition shadow-sm">
            Explorer les logements
        </router-link>
      </div>

      <div v-else class="space-y-4">
        <div v-for="res in filteredReservations" :key="res.idreservation" class="bg-white border border-gray-200 rounded-xl overflow-hidden shadow-sm hover:shadow-md transition-all duration-300 flex flex-col sm:flex-row group relative">
            <!-- Image Section -->
            <div class="w-full sm:w-48 h-32 bg-gray-100 flex-shrink-0 relative overflow-hidden">
                <img v-if="res.idannonceNavigation?.photos?.length > 0" :src="res.idannonceNavigation.photos[0].lienphoto" class="w-full h-full object-cover transition-transform duration-500 group-hover:scale-105" :class="{ 'grayscale': activeTab === 'history' }" />
                <div v-else class="w-full h-full flex items-center justify-center text-gray-400 text-xs">Sans photo</div>
                
                <!-- Status Badge -->
                <div class="absolute top-2 left-2 z-10">
                    <span v-if="activeTab === 'upcoming'" class="bg-blue-100 text-blue-800 text-[10px] font-bold px-2 py-0.5 rounded flex items-center gap-1 shadow-sm">
                        <span class="w-1.5 h-1.5 rounded-full bg-blue-600"></span> Confirmée
                    </span>
                    <span v-else class="bg-gray-100 text-gray-600 text-[10px] font-bold px-2 py-0.5 rounded flex items-center gap-1 shadow-sm border border-gray-200">
                        Terminée
                    </span>
                </div>
            </div>
            
            <!-- Content Section -->
            <div class="p-4 flex-grow flex flex-col justify-between">
                <div>
                    <div class="flex justify-between items-start">
                        <h3 class="font-bold text-lg text-gray-900 line-clamp-1 pr-4">{{ res.idannonceNavigation?.titreannonce }}</h3>
                        <span class="font-bold text-gray-900 text-lg flex-shrink-0">{{ res.idannonceNavigation?.prixnuitee * 1 }} €</span>
                    </div>
                    <p class="text-gray-500 text-xs mt-1 flex items-center gap-1 font-medium">
                        <svg class="w-3 h-3 text-gray-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 10.5a3 3 0 11-6 0 3 3 0 016 0z" />
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19.5 10.5c0 7.142-7.5 11.25-7.5 11.25S4.5 17.642 4.5 10.5a7.5 7.5 0 1115 0z" />
                        </svg>                        
                        {{ res.idannonceNavigation?.idadresseNavigation?.idvilleNavigation?.nomville }}
                    </p>
                    <div class="mt-3 flex gap-4 text-xs text-gray-500 font-medium whitespace-nowrap overflow-hidden">
                        <span class="flex items-center gap-1">
                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/></svg>
                            Du {{ formatShortDate(res.iddatedebutreservationNavigation?.date1) }} au {{ formatDate(res.iddatefinreservationNavigation?.date1) }}
                        </span>
                        <span class="flex items-center gap-1">
                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0z"/></svg>
                            {{ res.inclures?.reduce((acc, c) => acc + c.nombrevoyageur, 0) || 0 }} voyageur(s)
                        </span>
                        <span class="text-xs font-bold text-gray-400 ml-auto hidden md:block">
                            Reste à payer : 0,00 €
                        </span>
                    </div>
                </div>

                <!-- Actions -->
                <div class="flex items-center gap-6 mt-4 pt-3 border-t border-gray-100 text-xs font-bold whitespace-nowrap overflow-x-auto hide-scrollbar">
                    <button class="text-gray-700 hover:text-orange-600 flex items-center gap-1.5 transition-colors">
                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-4.03 8-9 8a9.863 9.863 0 01-4.255-.949L3 20l1.395-3.72C3.512 15.042 3 13.574 3 12c0-4.418 4.03-8 9-8s9 3.582 9 8z"/></svg>
                        Message
                    </button>
                    <button v-if="activeTab === 'upcoming'" @click="goToEdit(res.idreservation)" class="text-gray-700 hover:text-orange-600 flex items-center gap-1.5 transition-colors">
                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"/></svg>
                        Modifier
                    </button>
                    <button class="text-gray-700 hover:text-red-600 flex items-center gap-1.5 transition-colors">
                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"/></svg>
                        Signaler un incident
                    </button>
                    <button v-if="activeTab === 'upcoming'" class="text-gray-400 hover:text-red-600 transition-colors ml-auto uppercase tracking-wider text-[10px]">
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
.hide-scrollbar::-webkit-scrollbar {
  display: none;
}
.hide-scrollbar {
  -ms-overflow-style: none;
  scrollbar-width: none;
}
.line-clamp-1 {
    display: -webkit-box;
    -webkit-line-clamp: 1;
    -webkit-box-orient: vertical;
    overflow: hidden;
}
</style>
