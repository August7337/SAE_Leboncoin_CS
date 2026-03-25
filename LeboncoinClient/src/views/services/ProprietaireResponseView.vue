<template>
  <div class="bg-[#f8f9fb] min-h-screen pb-12">
    <main class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-10">
      
      <div class="mb-8 flex justify-between items-center">
        <button @click="$router.back()" class="text-gray-500 hover:text-gray-900 font-medium flex items-center gap-2">
          <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
          </svg>
          Retour à mes annonces
        </button>
      </div>

      <div v-if="loading" class="text-center py-12">
        <div class="w-8 h-8 border-4 border-orange-200 border-t-[#ea580c] rounded-full animate-spin mx-auto"></div>
      </div>

      <div v-else-if="incident" class="space-y-6">
        
        <div>
          <h1 class="text-3xl font-black text-gray-900">Dossier de litige #{{ incident.idincident }}</h1>
          <p class="text-gray-500 mt-1">Le service location vous demande des explications concernant cette réservation.</p>
        </div>

        <div class="bg-red-50 rounded-2xl border border-red-100 p-6 shadow-sm">
          <h2 class="text-lg font-black text-red-900 mb-4 border-b border-red-200 pb-2 flex items-center gap-2">
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" /></svg>
            Signalement du locataire
          </h2>
          
          <div class="mb-4">
            <p class="text-sm text-red-700 font-bold uppercase tracking-wider">Motif du signalement</p>
            <p class="text-base font-bold text-gray-900 mt-1">{{ incident.motifincident }}</p>
          </div>

          <div class="mb-6">
            <p class="text-sm text-red-700 font-bold uppercase tracking-wider">Description détaillée</p>
            <p class="text-gray-800 bg-white p-4 rounded-xl border border-red-100 mt-2 whitespace-pre-line">
              {{ incident.descriptionincident || "Aucune description fournie." }}
            </p>
          </div>

          <div>
            <p class="text-sm text-red-700 font-bold uppercase tracking-wider mb-2">Preuves apportées par le locataire</p>
            <div v-if="photosLocataire.length > 0" class="grid grid-cols-2 md:grid-cols-4 gap-4 mt-2">
              <div v-for="photo in photosLocataire" :key="photo.idphoto" class="relative aspect-square">
                <img :src="buildAssetUrl(photo.urlphoto)" class="w-full h-full object-cover rounded-xl border border-red-200" alt="Preuve locataire" />
              </div>
            </div>
            <p v-else class="text-sm text-gray-500 italic bg-white p-3 rounded-lg border border-red-100">Le locataire n'a fourni aucune photo.</p>
          </div>
        </div>

        <div class="bg-white rounded-2xl border border-gray-200 p-6 shadow-sm mt-8">
          <h2 class="text-xl font-black text-gray-900 mb-6">Votre réponse</h2>
          
          <form @submit.prevent="submitResponse">
            <div class="mb-6">
              <label class="block text-sm font-bold text-gray-700 mb-2">Rédigez vos explications *</label>
              <p class="text-xs text-gray-500 mb-2">Soyez précis et factuel. Ces informations seront lues par le Service Location pour trancher le litige.</p>
              <textarea 
                v-model="explicationText" 
                required 
                rows="6" 
                class="w-full border-gray-300 rounded-xl shadow-sm focus:border-[#ea580c] focus:ring-[#ea580c] resize-y"
                placeholder="Expliquez votre version des faits..."
              ></textarea>
            </div>

            <div class="mb-6">
              <label class="block text-sm font-bold text-gray-700 mb-2">Ajouter des photos (Optionnel)</label>
              <p class="text-xs text-gray-500 mb-2">Ajoutez des preuves photographiques pour appuyer vos dires (état des lieux, captures d'écran, etc.).</p>
              
              <input 
                type="file" 
                multiple 
                accept="image/jpeg, image/png, image/webp" 
                @change="handleFileUpload"
                class="block w-full text-sm text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded-full file:border-0 file:text-sm file:font-semibold file:bg-orange-50 file:text-[#ea580c] hover:file:bg-orange-100 cursor-pointer"
              />

              <div v-if="selectedFiles.length > 0" class="mt-4 grid grid-cols-3 md:grid-cols-5 gap-3">
                <div v-for="(file, index) in selectedFiles" :key="index" class="relative aspect-square group">
                  <img :src="file.preview" class="w-full h-full object-cover rounded-lg border border-gray-200" />
                  <button @click.prevent="removeFile(index)" class="absolute -top-2 -right-2 bg-red-500 text-white rounded-full p-1 shadow-md hover:bg-red-600">
                    <svg class="w-3 h-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" /></svg>
                  </button>
                </div>
              </div>
            </div>

            <div v-if="submitError" class="mb-4 bg-red-50 text-red-600 p-4 rounded-xl text-sm font-bold border border-red-100">
              {{ submitError }}
            </div>

            <div class="flex justify-end pt-4 border-t border-gray-100">
              <button 
                type="submit" 
                :disabled="isSubmitting"
                class="bg-[#ea580c] text-white font-bold py-3 px-8 rounded-xl shadow-lg shadow-orange-200 hover:bg-[#c2410c] transition-all disabled:opacity-50 flex items-center gap-2"
              >
                <span v-if="isSubmitting" class="w-5 h-5 border-2 border-white border-t-transparent rounded-full animate-spin"></span>
                {{ isSubmitting ? 'Envoi en cours...' : 'Envoyer ma réponse' }}
              </button>
            </div>
          </form>
        </div>

      </div>
    </main>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import api from '@/api/axios'
import { buildAssetUrl } from '@/services/api'

const route = useRoute()
const router = useRouter()
const incident = ref(null)
const loading = ref(true)

const explicationText = ref('')
const selectedFiles = ref([])
const isSubmitting = ref(false)
const submitError = ref('')

const photosLocataire = computed(() => {
  if (!incident.value || !incident.value.photos) return []
  return incident.value.photos.filter(p => p.originephoto === 1)
})

const loadIncident = async () => {
  try {
    const response = await api.get(`/Incidents/${route.params.id}`)
    incident.value = response.data
  } catch (error) {
    console.error("Erreur de chargement", error)
  } finally {
    loading.value = false
  }
}

const handleFileUpload = (event) => {
  const MAX_SIZE = 10 * 1024 * 1024 // 10 MB
  const files = Array.from(event.target.files)
  files.forEach(file => {
    if (file.size > MAX_SIZE) {
      submitError.value = `Le fichier "${file.name}" dépasse 10 Mo et a été ignoré.`
      return
    }
    selectedFiles.value.push({
      file: file,
      preview: URL.createObjectURL(file)
    })
  })
  event.target.value = ''
}

const removeFile = (index) => {
  URL.revokeObjectURL(selectedFiles.value[index].preview)
  selectedFiles.value.splice(index, 1)
}

const submitResponse = async () => {
  isSubmitting.value = true
  submitError.value = ''

  try {
    await api.post(`/Incidents/${incident.value.idincident}/explication-proprietaire`, {
      explication: explicationText.value
    })

    if (selectedFiles.value.length > 0) {
      for (const item of selectedFiles.value) {
        const formData = new FormData()
        formData.append('file', item.file)
        formData.append('origine', 2)

        await api.post(`/Incidents/${incident.value.idincident}/photos`, formData, {
          headers: { 'Content-Type': 'multipart/form-data' }
        })
      }
    }

    router.push({ name: 'my-annonces' })

  } catch (error) {
    console.error(error)
    submitError.value = "Une erreur est survenue lors de l'envoi de votre réponse."
    isSubmitting.value = false
  }
}

onMounted(() => {
  loadIncident()
})
</script>