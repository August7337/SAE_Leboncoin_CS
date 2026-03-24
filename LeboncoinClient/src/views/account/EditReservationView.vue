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
const adultes = ref(1)
const enfants = ref(0)
const bebes = ref(0)
const nomClient = ref('')
const prenomClient = ref('')
const telephoneClient = ref('')

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
        
        // Types: 1=Adulte, 2=Enfant, 3=Bébé
        adultes.value = data.inclures?.find(i => i.idtypevoyageur === 1)?.nombrevoyageur || 1
        enfants.value = data.inclures?.find(i => i.idtypevoyageur === 2)?.nombrevoyageur || 0
        bebes.value = data.inclures?.find(i => i.idtypevoyageur === 3)?.nombrevoyageur || 0
        
        nomClient.value = data.nomclient || ''
        prenomClient.value = data.prenomclient || ''
        telephoneClient.value = data.telephoneclient || ''
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

const totalTravelers = computed(() => (adultes.value || 0) + (enfants.value || 0))
const maxCapacite = computed(() => {
    const cap = reservation.value?.idannonceNavigation?.capacite
    return cap ? parseInt(cap) : 10
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
        const payload = {
            idreservation: parseInt(reservationId),
            idannonce: reservation.value.idannonce,
            iddatedebutreservation: reservation.value.iddatedebutreservation,
            iddatefinreservation: reservation.value.iddatefinreservation,
            idutilisateur: reservation.value.idutilisateur,
            nomclient: nomClient.value || '',
            prenomclient: prenomClient.value || '',
            telephoneclient: telephoneClient.value || '',
            iddatedebutreservationNavigation: { 
                iddate: reservation.value.iddatedebutreservation,
                date1: modifDates.value.start 
            },
            iddatefinreservationNavigation: { 
                iddate: reservation.value.iddatefinreservation,
                date1: modifDates.value.end 
            },
            inclures: [
                { idtypevoyageur: 1, nombrevoyageur: adultes.value },
                { idtypevoyageur: 2, nombrevoyageur: enfants.value },
                { idtypevoyageur: 3, nombrevoyageur: bebes.value }
            ].filter(i => i.nombrevoyageur > 0).map(i => ({
                idreservation: parseInt(reservationId),
                idtypevoyageur: i.idtypevoyageur,
                nombrevoyageur: i.nombrevoyageur
            }))
        }
        
        await reservationsService.update(reservationId, payload)
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
      <!-- Header -->
      <div class="mb-8 flex items-center justify-between">
        <div class="flex items-center gap-4">
            <button @click="router.back()" class="p-2 bg-white rounded-full text-gray-400 hover:text-gray-900 transition-all shadow-sm group border border-gray-100">
                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2.5" stroke="currentColor" class="w-5 h-5">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M15.75 19.5L8.25 12l7.5-7.5" />
                </svg>
            </button>
            <h1 class="text-2xl font-bold text-gray-900">Modifier la réservation</h1>
        </div>
      </div>

      <div v-if="loading" class="flex justify-center items-center py-32">
        <div class="animate-spin rounded-full h-10 w-10 border-4 border-orange-100 border-t-orange-600"></div>
      </div>

      <div v-else-if="error" class="bg-white p-8 rounded-2xl shadow-sm border border-red-100 text-center">
        <div class="w-16 h-16 bg-red-100 rounded-full flex items-center justify-center mx-auto mb-4 text-red-600">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" class="w-8 h-8">
                <path stroke-linecap="round" stroke-linejoin="round" d="M12 9v3.75m9-.75a9 9 0 11-18 0 9 9 0 0118 0zm-9 3.75h.008v.008H12v-.008z" />
            </svg>
        </div>
        <p class="text-gray-900 font-bold mb-4">{{ error }}</p>
        <button @click="fetchReservation" class="text-orange-600 font-bold hover:underline">Réessayer</button>
      </div>

      <div v-else class="space-y-6">
        <!-- Main Form Card -->
        <div class="bg-white rounded-2xl shadow-sm border border-gray-200 overflow-hidden">
            <!-- Summary Header -->
            <div class="p-6 border-b border-gray-100 flex items-center gap-4 bg-gray-50/50">
                <div class="w-20 h-20 rounded-xl overflow-hidden bg-gray-100 flex-shrink-0">
                    <img v-if="reservation.idannonceNavigation?.photos?.length > 0" :src="reservation.idannonceNavigation.photos[0].lienphoto" class="w-full h-full object-cover" />
                </div>
                <div>
                    <h3 class="font-bold text-gray-900">{{ reservation.idannonceNavigation?.titreannonce }}</h3>
                    <p class="text-sm text-gray-500">{{ reservation.idannonceNavigation?.idadresseNavigation?.idvilleNavigation?.nomville }}</p>
                </div>
            </div>

            <div class="p-6 md:p-8 space-y-8">
                <div v-if="updateError" class="p-4 bg-red-50 text-red-700 text-sm font-bold rounded-xl border border-red-100">
                    {{ updateError }}
                </div>

                <!-- Dates Section -->
                <div>
                    <h2 class="text-lg font-bold text-gray-900 mb-6 flex items-center gap-2">
                        <svg class="w-5 h-5 text-orange-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/>
                        </svg>
                        Dates du séjour
                    </h2>
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                        <div class="space-y-1.5">
                            <label class="text-xs font-bold text-gray-500 uppercase tracking-wider ml-1">Arrivée</label>
                            <input v-model="modifDates.start" type="date" class="w-full border border-gray-300 rounded-xl py-3 px-4 focus:ring-2 focus:ring-orange-500/20 focus:border-orange-600 outline-none transition-all font-medium" />
                        </div>
                        <div class="space-y-1.5">
                            <label class="text-xs font-bold text-gray-500 uppercase tracking-wider ml-1">Départ</label>
                            <input v-model="modifDates.end" type="date" class="w-full border border-gray-300 rounded-xl py-3 px-4 focus:ring-2 focus:ring-orange-500/20 focus:border-orange-600 outline-none transition-all font-medium" />
                        </div>
                    </div>
                </div>

                <!-- Travelers Section (Laravel Style) -->
                <div>
                    <h2 class="text-lg font-bold text-gray-900 mb-6 flex items-center gap-2">
                        <svg class="w-5 h-5 text-orange-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0z"/>
                        </svg>
                        Voyageurs
                    </h2>
                    <div class="space-y-6">
                        <!-- Adultes -->
                        <div class="flex items-center justify-between">
                            <div>
                                <p class="font-bold text-gray-900 leading-none">Adultes</p>
                                <p class="text-xs text-gray-500 mt-1">13 ans et plus</p>
                            </div>
                            <div class="flex items-center gap-4">
                                <button type="button" @click="adultes > 1 && adultes--" class="w-8 h-8 rounded-full border border-gray-300 flex items-center justify-center hover:border-gray-900 transition-colors">
                                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 12H4"/></svg>
                                </button>
                                <span class="font-bold text-lg w-4 text-center">{{ adultes }}</span>
                                <button type="button" @click="totalTravelers < maxCapacite && adultes++" class="w-8 h-8 rounded-full border border-gray-300 flex items-center justify-center hover:border-gray-900 transition-colors">
                                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/></svg>
                                </button>
                            </div>
                        </div>
                        <!-- Enfants -->
                        <div class="flex items-center justify-between">
                            <div>
                                <p class="font-bold text-gray-900 leading-none">Enfants</p>
                                <p class="text-xs text-gray-500 mt-1">De 2 à 12 ans</p>
                            </div>
                            <div class="flex items-center gap-4">
                                <button type="button" @click="enfants > 0 && enfants--" class="w-8 h-8 rounded-full border border-gray-300 flex items-center justify-center hover:border-gray-900 transition-colors">
                                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 12H4"/></svg>
                                </button>
                                <span class="font-bold text-lg w-4 text-center">{{ enfants }}</span>
                                <button type="button" @click="totalTravelers < maxCapacite && enfants++" class="w-8 h-8 rounded-full border border-gray-300 flex items-center justify-center hover:border-gray-900 transition-colors">
                                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/></svg>
                                </button>
                            </div>
                        </div>
                        <!-- Bébés -->
                        <div class="flex items-center justify-between">
                            <div>
                                <p class="font-bold text-gray-900 leading-none">Bébés</p>
                                <p class="text-xs text-gray-500 mt-1">Moins de 2 ans</p>
                            </div>
                            <div class="flex items-center gap-4">
                                <button type="button" @click="bebes > 0 && bebes--" class="w-8 h-8 rounded-full border border-gray-300 flex items-center justify-center hover:border-gray-900 transition-colors">
                                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 12H4"/></svg>
                                </button>
                                <span class="font-bold text-lg w-4 text-center">{{ bebes }}</span>
                                <button type="button" @click="bebes < 5 && bebes++" class="w-8 h-8 rounded-full border border-gray-300 flex items-center justify-center hover:border-gray-900 transition-colors">
                                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/></svg>
                                </button>
                            </div>
                        </div>
                    </div>
                    <p class="mt-4 text-[10px] text-gray-500 font-bold uppercase tracking-widest border-t border-gray-100 pt-4">
                        Capacité maximale : {{ maxCapacite }} voyageurs (hors bébés)
                    </p>
                </div>

                <!-- Personal Info -->
                <div class="pt-4">
                    <h2 class="text-lg font-bold text-gray-900 mb-6 flex items-center gap-2">
                        <svg class="w-5 h-5 text-orange-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/>
                        </svg>
                        Informations client
                    </h2>
                    <div class="space-y-4">
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                            <div class="space-y-1.5">
                                <label class="text-xs font-bold text-gray-500 uppercase tracking-wider ml-1">Prénom</label>
                                <input v-model="prenomClient" type="text" class="w-full border border-gray-300 rounded-xl py-3 px-4 focus:ring-2 focus:ring-orange-500/20 focus:border-orange-600 outline-none transition-all font-medium" />
                            </div>
                            <div class="space-y-1.5">
                                <label class="text-xs font-bold text-gray-500 uppercase tracking-wider ml-1">Nom</label>
                                <input v-model="nomClient" type="text" class="w-full border border-gray-300 rounded-xl py-3 px-4 focus:ring-2 focus:ring-orange-500/20 focus:border-orange-600 outline-none transition-all font-medium" />
                            </div>
                        </div>
                        <div class="space-y-1.5">
                            <label class="text-xs font-bold text-gray-500 uppercase tracking-wider ml-1">Téléphone</label>
                            <input v-model="telephoneClient" type="tel" class="w-full border border-gray-300 rounded-xl py-3 px-4 focus:ring-2 focus:ring-orange-500/20 focus:border-orange-600 outline-none transition-all font-medium" />
                        </div>
                    </div>
                </div>
            </div>

            <!-- Footer Section -->
            <div class="p-6 md:p-8 bg-gray-50 border-t border-gray-100">
                <div v-if="supplementAmount > 0" class="mb-6 flex items-center justify-between bg-orange-100/50 p-4 rounded-xl border border-orange-200">
                    <div>
                        <p class="text-orange-900 font-bold">Supplément à payer</p>
                        <p class="text-xs text-orange-700">Votre solde : {{ authState.user.solde }}€</p>
                    </div>
                    <p class="text-2xl font-black text-orange-600">{{ supplementAmount }}€</p>
                </div>
                
                <div class="flex flex-col sm:flex-row gap-3">
                    <button 
                        @click="handleUpdate" 
                        :disabled="updating || (supplementAmount > authState.user.solde)"
                        class="flex-1 py-4 bg-orange-600 text-white font-bold rounded-xl hover:bg-orange-700 transition active:scale-95 disabled:opacity-50 disabled:scale-100 flex items-center justify-center gap-2"
                    >
                        <span v-if="updating" class="w-5 h-5 border-2 border-white/20 border-t-white rounded-full animate-spin"></span>
                        {{ supplementAmount > 0 ? 'Payer et confirmer' : 'Enregistrer' }}
                    </button>
                    <button @click="router.back()" class="flex-1 py-4 bg-white text-gray-700 font-bold rounded-xl border border-gray-300 hover:bg-gray-50 transition active:scale-95">
                        Annuler
                    </button>
                </div>
                <p v-if="supplementAmount > authState.user.solde" class="text-center mt-3 text-xs text-red-600 font-bold">
                    Solde insuffisant pour confirmer ces modifications.
                </p>
            </div>
        </div>
      </div>
    </main>
  </div>
</template>

<style scoped>
input[type="date"]::-webkit-calendar-picker-indicator {
    cursor: pointer;
    filter: invert(48%) sepia(79%) saturate(2476%) hue-rotate(352deg) brightness(96%) contrast(92%);
}
</style>
