<script setup>
import { ref, onMounted } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { authState } from '@/auth'
import api from '@/api/axios'
import reservationsService from '@/services/reservationsService'
import FileUploader from '@/components/FileUploader.vue'

const router = useRouter()
const route = useRoute()

const reservationId = ref(route.query.reservationId ? Number(route.query.reservationId) : null)
const reservations = ref([])
const loadingRes = ref(false)
const submitting = ref(false)
const errorMessage = ref(null)
const successMessage = ref(null)

const photoFiles = ref([])

const form = ref({
  idreservation: reservationId.value ?? '',
  motifincident: '',
  descriptionincident: '',
})

const motifs = [
  "Logement non conforme a l'annonce",
  'Probleme de proprete',
  'Equipements defaillants ou absents',
  'Probleme de securite',
  'Annulation de derniere minute par le proprietaire',
  'Autre',
]

onMounted(async () => {
  if (!authState.isLoggedIn()) {
    router.push('/login')
    return
  }

  loadingRes.value = true
  try {
    const data = await reservationsService.getByUserId(authState.user.idutilisateur)
    const now = new Date()
    reservations.value = data
      .filter((reservation) => new Date(reservation.iddatedebutreservationNavigation?.date1) <= now)
      .sort(
        (first, second) =>
          new Date(second.iddatedebutreservationNavigation?.date1) -
          new Date(first.iddatedebutreservationNavigation?.date1),
      )
  } catch {
    errorMessage.value = 'Impossible de charger vos reservations.'
  } finally {
    loadingRes.value = false
  }
})

const formatDate = (dateValue) => {
  if (!dateValue) return '?'
  return new Date(dateValue).toLocaleDateString('fr-FR', {
    day: 'numeric', month: 'short', year: 'numeric',
  })
}

const submit = async () => {
  errorMessage.value = null
  successMessage.value = null

  if (!form.value.idreservation || !form.value.motifincident || !form.value.descriptionincident?.trim()) {
    errorMessage.value = 'Veuillez remplir tous les champs obligatoires.'
    return
  }

  submitting.value = true
  try {
    const response = await api.post('/Incidents', {
      idreservation: Number(form.value.idreservation),
      motifincident: form.value.motifincident,
      descriptionincident: form.value.descriptionincident.trim(),
    })
    
    const incidentCree = response.data

    for (const file of photoFiles.value) {
      const formData = new FormData()
      formData.append('file', file)
      formData.append('origine', 1)

      await api.post(`/Incidents/${incidentCree.idincident}/photos`, formData, {
        headers: { 'Content-Type': 'multipart/form-data' }
      })
    }

    successMessage.value = 'Votre incident a bien ete signale.'
    setTimeout(() => {
      router.push({ name: 'incident-detail', params: { id: incidentCree.idincident } })
    }, 1200)

  } catch (error) {
    console.error(error)
    errorMessage.value = error.response?.data?.message ?? "Une erreur est survenue lors du signalement."
  } finally {
    submitting.value = false
  }
}
</script>

<template>
  <div class="bg-[#f8f9fb] min-h-screen pb-16">
    <main class="max-w-2xl mx-auto px-4 sm:px-6 py-10">
      <div class="mb-8">
        <button @click="router.back()" class="text-sm text-gray-500 hover:text-orange-600 flex items-center gap-1 mb-4 font-medium transition-colors">
          <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" /></svg> Retour
        </button>
        <h1 class="text-2xl font-black text-gray-900">Signaler un incident</h1>
        <p class="text-sm text-gray-500 mt-1 font-medium">Décrivez le problème rencontré lors de votre séjour.</p>
      </div>

      <div v-if="errorMessage" class="mb-6 bg-red-50 border border-red-200 text-red-700 px-5 py-4 rounded-xl text-sm font-medium">{{ errorMessage }}</div>
      <div v-if="successMessage" class="mb-6 bg-green-50 border border-green-200 text-green-700 px-5 py-4 rounded-xl text-sm font-medium flex items-center gap-2">
        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" /></svg>
        {{ successMessage }}
      </div>

      <div class="bg-white border border-gray-200 rounded-2xl shadow-sm p-6 space-y-6">
        
        <div>
          <label class="block text-sm font-bold text-gray-700 mb-2">Reservation concernée *</label>
          <div v-if="loadingRes" class="text-sm text-gray-400 font-medium py-2">Chargement...</div>
          <select v-else v-model="form.idreservation" class="w-full border border-gray-300 rounded-xl px-4 py-3 text-sm text-gray-800 focus:ring-2 focus:ring-orange-400 bg-white">
            <option value="" disabled>Sélectionner une réservation</option>
            <option v-for="res in reservations" :key="res.idreservation" :value="res.idreservation">
              {{ res.idannonceNavigation?.titreannonce || 'Réservation #' + res.idreservation }}
              - du {{ formatDate(res.iddatedebutreservationNavigation?.date1) }} au {{ formatDate(res.iddatefinreservationNavigation?.date1) }}
            </option>
          </select>
        </div>

        <div>
          <label class="block text-sm font-bold text-gray-700 mb-2">Motif de l'incident *</label>
          <select v-model="form.motifincident" class="w-full border border-gray-300 rounded-xl px-4 py-3 text-sm text-gray-800 focus:ring-2 focus:ring-orange-400 bg-white">
            <option value="" disabled>Choisir un motif</option>
            <option v-for="motif in motifs" :key="motif" :value="motif">{{ motif }}</option>
          </select>
        </div>

        <div>
          <label class="block text-sm font-bold text-gray-700 mb-2">Description détaillée *</label>
          <textarea v-model="form.descriptionincident" rows="5" maxlength="2000" class="w-full border border-gray-300 rounded-xl px-4 py-3 text-sm text-gray-800 focus:ring-2 focus:ring-orange-400 resize-none" placeholder="Expliquez en détail le problème que vous avez rencontré..."></textarea>
        </div>

        <div>
          <label class="block text-sm font-bold text-gray-700 mb-2">Photos (preuves optionnelles)</label>
          <FileUploader v-model="photoFiles" />
        </div>

        <div class="flex justify-end pt-4 border-t border-gray-100">
          <button @click="submit" :disabled="submitting" class="inline-flex items-center gap-2 px-8 py-3 bg-orange-600 hover:bg-orange-700 disabled:opacity-60 text-white font-bold rounded-xl transition-colors shadow-sm text-sm">
            <svg v-if="submitting" class="animate-spin w-4 h-4" fill="none" viewBox="0 0 24 24">
              <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4" />
              <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8v8H4z" />
            </svg>
            {{ submitting ? 'Envoi en cours...' : "Signaler l'incident" }}
          </button>
        </div>

      </div>
    </main>
  </div>
</template>