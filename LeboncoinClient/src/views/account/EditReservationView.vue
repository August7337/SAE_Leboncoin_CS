<script setup>
import { ref, onMounted, computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { authState } from '@/auth'
import reservationsService from '@/services/reservationsService'

const route = useRoute()
const router = useRouter()
const reservationId = route.params.id

const reservation = ref(null)
const loading = ref(true)
const error = ref(null)

const modifDates = ref({ start: '', end: '' })
const modifPeople = ref(1)
const updating = ref(false)
const updateError = ref(null)

const fetchReservation = async () => {
    loading.value = true
    error.value = null
    try {
        const data = await reservationsService.getById(reservationId)
        reservation.value = data
        modifDates.value = {
            start: data.iddatedebutreservationNavigation?.date1?.split('T')[0] || '',
            end: data.iddatefinreservationNavigation?.date1?.split('T')[0] || ''
        }
        modifPeople.value = data.inclures?.reduce((acc, c) => acc + c.nombrevoyageur, 0) || 1
    } catch (err) {
        console.error('Error fetching reservation:', err)
        error.value = 'Impossible de charger les détails de la réservation.'
    } finally {
        loading.value = false
    }
}

onMounted(() => {
    if (!authState.isLoggedIn()) {
        router.push('/login')
        return
    }
    fetchReservation()
})

const supplementAmount = computed(() => {
    if (!reservation.value || !modifDates.value.start || !modifDates.value.end) return 0
    
    const oldStart = new Date(reservation.value.iddatedebutreservationNavigation?.date1)
    const oldEnd = new Date(reservation.value.iddatefinreservationNavigation?.date1)
    const newStart = new Date(modifDates.value.start)
    const newEnd = new Date(modifDates.value.end)
    
    const oldNights = Math.ceil((oldEnd - oldStart) / (1000 * 60 * 60 * 24))
    const newNights = Math.ceil((newEnd - newStart) / (1000 * 60 * 60 * 24))
    
    if (newNights > oldNights) {
        const pricePerNight = reservation.value.idannonceNavigation?.prixnuitee || 0
        return (newNights - oldNights) * pricePerNight
    }
    return 0
})

const handleUpdate = async () => {
    updating.value = true
    updateError.value = null
    try {
        const updatedRes = {
            ...reservation.value,
            iddatedebutreservationNavigation: { ...reservation.value.iddatedebutreservationNavigation, date1: modifDates.value.start },
            iddatefinreservationNavigation: { ...reservation.value.iddatefinreservationNavigation, date1: modifDates.value.end },
            inclures: reservation.value.inclures?.length > 0 
                ? [{ ...reservation.value.inclures[0], nombrevoyageur: modifPeople.value }]
                : [{ idtypevoyageur: 1, nombrevoyageur: modifPeople.value }]
        }
        
        await reservationsService.update(reservationId, updatedRes)
        if (supplementAmount.value > 0) {
            authState.user.solde -= supplementAmount.value
        }
        router.push('/my-reservations')
    } catch (err) {
        console.error('Error updating reservation:', err)
        updateError.value = err.response?.data || 'Erreur lors de la mise à jour.'
    } finally {
        updating.value = false
    }
}

const formatDate = (dateStr) => {
    if (!dateStr) return 'N/A'
    return new Date(dateStr).toLocaleDateString('fr-FR', { day: 'numeric', month: 'long', year: 'numeric' })
}
</script>

<template>
  <div class="bg-[#f8f9fb] min-h-screen pb-12">
    <main class="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8 py-10">
      <div class="mb-8 flex items-center gap-4">
        <button @click="router.back()" class="p-3 bg-white border border-gray-200 rounded-2xl text-gray-400 hover:text-gray-900 transition-all shadow-sm">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2.5" stroke="currentColor" class="w-5 h-5">
                <path stroke-linecap="round" stroke-linejoin="round" d="M10.5 19.5L3 12m0 0l7.5-7.5M3 12h18" />
            </svg>
        </button>
        <div>
            <h1 class="text-3xl font-black text-gray-900 tracking-tight">Modifier mon voyage</h1>
            <p class="text-gray-500 font-medium">Ajustez vos dates ou le nombre de voyageurs.</p>
        </div>
      </div>

      <div v-if="loading" class="flex justify-center items-center py-32">
        <div class="animate-spin rounded-full h-12 w-12 border-4 border-orange-100 border-t-orange-600"></div>
      </div>

      <div v-else-if="error" class="bg-red-50 border border-red-200 text-red-700 px-6 py-4 rounded-2xl shadow-sm font-medium">
        {{ error }}
      </div>

      <div v-else class="space-y-6">
        <!-- Annonce Card -->
        <div class="bg-white border border-gray-200 rounded-3xl p-6 shadow-sm flex items-center gap-6">
            <div class="w-32 h-24 rounded-2xl overflow-hidden flex-shrink-0 bg-gray-100">
                <img v-if="reservation.idannonceNavigation?.photos?.length > 0" :src="reservation.idannonceNavigation.photos[0].lienphoto" class="w-full h-full object-cover" />
                <div v-else class="w-full h-full flex items-center justify-center text-gray-300">
                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-8 h-8">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M2.25 15.75l5.159-5.159a2.25 2.25 0 013.182 0l5.159 5.159m-1.5-1.5l1.409-1.409a2.25 2.25 0 013.182 0l2.909 2.909m-18 3.75h16.5a1.5 1.5 0 001.5-1.5V6a1.5 1.5 0 00-1.5-1.5H3.75A1.5 1.5 0 002.25 6v12a1.5 1.5 0 001.5 1.5zm10.5-11.25h.008v.008h-.008V8.25zm.375 0a.375.375 0 11-.75 0 .375.375 0 01.75 0z" />
                    </svg>
                </div>
            </div>
            <div>
                <h3 class="text-xl font-black text-gray-900 leading-tight mb-1">{{ reservation.idannonceNavigation?.titreannonce }}</h3>
                <p class="text-gray-500 text-sm font-medium">{{ reservation.idannonceNavigation?.idadresseNavigation?.idvilleNavigation?.nomville }}</p>
                <div class="mt-2 flex items-center gap-2">
                    <span class="text-lg font-black text-orange-600">{{ reservation.idannonceNavigation?.prixnuitee }}€</span>
                    <span class="text-[10px] text-gray-400 font-bold uppercase tracking-widest">par nuit</span>
                </div>
            </div>
        </div>

        <!-- Form Section -->
        <div class="bg-white border border-gray-200 rounded-[40px] p-10 shadow-sm">
            <div v-if="updateError" class="mb-8 p-4 bg-red-50 text-red-700 text-sm font-bold rounded-2xl border border-red-100 flex items-center gap-3">
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" class="w-5 h-5 flex-shrink-0">
                    <path fill-rule="evenodd" d="M9.401 3.003c1.155-2 4.043-2 5.197 0l7.355 12.748c1.154 2-.29 4.5-2.599 4.5H4.645c-2.309 0-3.752-2.5-2.598-4.5L9.401 3.003zM12 8.25a.75.75 0 01.75.75v3.75a.75.75 0 01-1.5 0V9a.75.75 0 01.75-.75zm0 8.25a.75.75 0 100-1.5.75.75 0 000 1.5z" clip-rule="evenodd" />
                </svg>
                {{ updateError }}
            </div>

            <div class="space-y-10">
                <!-- Date Section -->
                <section>
                    <div class="flex items-center gap-3 mb-6">
                        <div class="w-8 h-8 bg-orange-100 rounded-lg flex items-center justify-center text-orange-600">
                            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 16 16" stroke-width="1.5" stroke="currentColor" class="w-5 h-5">
                                <rect x="2" y="3" width="12" height="11" rx="2" stroke-width="1.2"/>
                                <path d="M2 7H14" stroke-width="1.2"/>
                                <path d="M5 2V4" stroke-width="1.2"/>
                                <path d="M11 2V4" stroke-width="1.2"/>
                            </svg>
                        </div>
                        <h2 class="text-xl font-black text-gray-900">Dates du séjour</h2>
                    </div>
                    
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <div class="space-y-2">
                            <label class="block text-[10px] font-black text-gray-400 uppercase tracking-widest ml-1">Arrivée</label>
                            <input v-model="modifDates.start" type="date" class="w-full px-5 py-4 rounded-2xl border border-gray-200 focus:ring-4 focus:ring-orange-100 focus:border-orange-500 outline-none transition-all font-bold text-gray-900 bg-gray-50/30" />
                        </div>
                        <div class="space-y-2">
                            <label class="block text-[10px] font-black text-gray-400 uppercase tracking-widest ml-1">Départ</label>
                            <input v-model="modifDates.end" type="date" class="w-full px-5 py-4 rounded-2xl border border-gray-200 focus:ring-4 focus:ring-orange-100 focus:border-orange-500 outline-none transition-all font-bold text-gray-900 bg-gray-50/30" />
                        </div>
                    </div>
                    <div class="mt-4 p-4 bg-blue-50/50 rounded-2xl flex items-center justify-between text-blue-700 font-medium text-sm border border-blue-100/50">
                        <span>Période actuelle :</span>
                        <span>{{ formatDate(reservation.iddatedebutreservationNavigation?.date1) }} - {{ formatDate(reservation.iddatefinreservationNavigation?.date1) }}</span>
                    </div>
                </section>

                <!-- Travelers Section -->
                <section>
                    <div class="flex items-center gap-3 mb-6">
                        <div class="w-8 h-8 bg-purple-100 rounded-lg flex items-center justify-center text-purple-600">
                            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" class="w-5 h-5">
                                <path stroke-linecap="round" stroke-linejoin="round" d="M15.75 6a3.75 3.75 0 11-7.5 0 3.75 3.75 0 017.5 0zM4.501 20.118a7.5 7.5 0 0114.998 0A17.933 17.933 0 0112 21.75c-2.676 0-5.216-.584-7.499-1.632z" />
                            </svg>
                        </div>
                        <h2 class="text-xl font-black text-gray-900">Voyageurs</h2>
                    </div>

                    <div class="flex items-center justify-between bg-gray-50/50 p-6 rounded-[30px] border border-gray-100">
                        <div>
                            <p class="font-black text-gray-900">Nombre total</p>
                            <p class="text-xs text-gray-500 font-medium">Capacité max: {{ reservation.idannonceNavigation?.capacite || 10 }} personnes</p>
                        </div>
                        <div class="flex items-center gap-6">
                            <button @click="modifPeople > 1 && modifPeople--" class="w-12 h-12 flex items-center justify-center border-2 border-white rounded-2xl bg-white shadow-sm hover:bg-gray-50 active:scale-95 transition-all text-gray-400 hover:text-gray-900">
                                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="3" stroke="currentColor" class="w-5 h-5">
                                    <path stroke-linecap="round" stroke-linejoin="round" d="M19.5 12h-15" />
                                </svg>
                            </button>
                            <span class="text-2xl font-black w-10 text-center text-gray-900 tabular-nums">{{ modifPeople }}</span>
                            <button @click="modifPeople < (reservation.idannonceNavigation?.capacite || 10) && modifPeople++" class="w-12 h-12 flex items-center justify-center border-2 border-white rounded-2xl bg-white shadow-sm hover:bg-gray-50 active:scale-95 transition-all text-gray-400 hover:text-gray-900">
                                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="3" stroke="currentColor" class="w-5 h-5">
                                    <path stroke-linecap="round" stroke-linejoin="round" d="M12 4.5v15m7.5-7.5h-15" />
                                </svg>
                            </button>
                        </div>
                    </div>
                </section>

                <!-- Payment Summary -->
                <transition enter-active-class="transition duration-300 ease-out" enter-from-class="opacity-0 translate-y-4" enter-to-class="opacity-100 translate-y-0">
                    <div v-if="supplementAmount > 0" class="p-8 bg-orange-600 rounded-[35px] shadow-2xl shadow-orange-100 text-white">
                        <div class="flex flex-col md:flex-row justify-between items-center gap-6">
                            <div class="flex items-center gap-5">
                                <div class="w-14 h-14 bg-white/20 rounded-2xl flex items-center justify-center backdrop-blur-sm border border-white/20">
                                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" class="w-8 h-8">
                                        <path stroke-linecap="round" stroke-linejoin="round" d="M12 6v12m-3-2.818l.879.659c1.171.879 3.07.879 4.242 0 1.172-.879 1.172-2.303 0-3.182C13.536 12.219 12.768 12 12 12c-.725 0-1.45-.22-2.003-.659-1.106-.879-1.106-2.303 0-3.182s2.9-.879 4.006 0l.415.33M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                                    </svg>
                                </div>
                                <div class="text-center md:text-left">
                                    <p class="text-[10px] font-black uppercase tracking-[0.2em] opacity-80">Supplément dû</p>
                                    <p class="text-4xl font-black">+{{ supplementAmount }}€</p>
                                </div>
                            </div>
                            <div class="flex flex-col items-center md:items-end">
                                <p class="text-[10px] font-black uppercase tracking-[0.2em] opacity-80 mb-1">Votre solde actuel</p>
                                <p class="text-2xl font-bold flex items-center gap-2">
                                    {{ authState.user.solde }}€
                                    <svg v-if="supplementAmount > authState.user.solde" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" class="w-6 h-6 text-red-200">
                                        <path fill-rule="evenodd" d="M9.401 3.003c1.155-2 4.043-2 5.197 0l7.355 12.748c1.154 2-.29 4.5-2.599 4.5H4.645c-2.309 0-3.752-2.5-2.598-4.5L9.401 3.003zM12 8.25a.75.75 0 01.75.75v3.75a.75.75 0 01-1.5 0V9a.75.75 0 01.75-.75zm0 8.25a.75.75 0 100-1.5.75.75 0 000 1.5z" clip-rule="evenodd" />
                                    </svg>
                                </p>
                                <p v-if="supplementAmount > authState.user.solde" class="text-[10px] font-black uppercase text-red-100 mt-2">Solde insuffisant</p>
                            </div>
                        </div>
                    </div>
                </transition>

                <!-- Actions -->
                <div class="pt-6">
                    <button 
                        @click="handleUpdate" 
                        :disabled="updating || (supplementAmount > authState.user.solde)"
                        class="w-full py-6 bg-gray-900 text-white font-black text-xl rounded-[28px] shadow-2xl shadow-gray-200 hover:bg-black hover:shadow-gray-300 active:scale-[0.98] transition-all disabled:opacity-30 disabled:scale-100 disabled:shadow-none uppercase tracking-widest flex items-center justify-center gap-4 group"
                    >
                        <span v-if="updating" class="flex items-center gap-3">
                            <div class="w-6 h-6 border-4 border-white/20 border-b-white rounded-full animate-spin"></div>
                            Traitement...
                        </span>
                        <span v-else class="flex items-center gap-3">
                            {{ supplementAmount > 0 ? 'Payer & Confirmer' : 'Mettre à jour' }}
                            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2.5" stroke="currentColor" class="w-6 h-6 group-hover:translate-x-1 transition-transform">
                                <path stroke-linecap="round" stroke-linejoin="round" d="M13.5 4.5L21 12m0 0l-7.5 7.5M21 12H3" />
                            </svg>
                        </span>
                    </button>
                    <button @click="router.back()" class="w-full mt-4 py-4 text-gray-400 font-bold hover:text-gray-900 transition-colors uppercase text-xs tracking-widest">
                        Annuler et revenir
                    </button>
                </div>
            </div>
        </div>
      </div>
    </main>
  </div>
</template>

<style scoped>
input[type="date"]::-webkit-calendar-picker-indicator {
    cursor: pointer;
    opacity: 0.6;
    transition: opacity 0.2s;
}
input[type="date"]:hover::-webkit-calendar-picker-indicator {
    opacity: 1;
}
</style>
