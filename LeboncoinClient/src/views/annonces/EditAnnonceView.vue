<script setup>
import { ref, onMounted, reactive, computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import api from '@/api/axios'
import { authState } from '@/auth.js'
import UnavailabilityCalendar from '@/components/UnavailabilityCalendar.vue'

const route = useRoute()
const router = useRouter()
const annonceId = route.params.id

const loading = ref(true)
const saving = ref(false)
const errorMessage = ref('')
const successMessage = ref('')

const form = reactive({
  idannonce: 0,
  titreannonce: '',
  descriptionannonce: '',
  prixnuitee: 0,
  capacite: 0,
  nbchambres: 0,
  minimumnuitee: 0,
  nombrebebesmax: 0,
  possibiliteanimaux: false,
  possibilitefumeur: false,
})

const photos = ref([])
const unavailabilities = ref([])

async function fetchAnnonce() {
  try {
    const response = await api.get(`/Annonces/${annonceId}`)
    const data = response.data
    Object.assign(form, {
      idannonce: data.idannonce,
      titreannonce: data.titreannonce || '',
      descriptionannonce: data.descriptionannonce || '',
      prixnuitee: data.prixnuitee || 0,
      capacite: data.capacite || 0,
      nbchambres: data.nbchambres || 0,
      minimumnuitee: data.minimumnuitee || 0,
      nombrebebesmax: data.nombrebebesmax || 0,
      possibiliteanimaux: data.possibiliteanimaux || false,
      possibilitefumeur: data.possibilitefumeur || false,
    })
    photos.value = data.photos || []
    
    if (authState.user && data.idutilisateur !== authState.user.idutilisateur) {
      router.push('/')
    }
  } catch (error) {
    errorMessage.value = "Impossible de charger l'annonce."
  }
}

async function fetchUnavailabilities() {
  try {
    const res = await api.get(`/Annonces/${annonceId}/indisponibilites`)
    unavailabilities.value = res.data
  } catch (error) {
    console.error("Erreur unavailabilities", error)
  }
}

async function init() {
  loading.value = true
  await fetchAnnonce()
  await fetchUnavailabilities()
  loading.value = false
}

// ----------------------
// UPDATE INFOS
// ----------------------
async function saveAnnonce() {
  saving.value = true
  errorMessage.value = ''
  successMessage.value = ''
  try {
    await api.put(`/Annonces/${annonceId}`, form)
    successMessage.value = 'Annonce mise à jour avec succès.'
    setTimeout(() => successMessage.value = '', 3000)
    window.scrollTo({ top: 0, behavior: 'smooth' })
  } catch (error) {
    errorMessage.value = "Erreur lors de la sauvegarde."
  } finally {
    saving.value = false
  }
}

// ----------------------
// DELETE ANNONCE
// ----------------------
async function deleteAnnonce() {
  if (!confirm("Voulez-vous vraiment supprimer cette annonce ? Cette action est irréversible.")) return
  try {
    await api.delete(`/Annonces/${annonceId}`)
    router.push('/my-annonces')
  } catch (error) {
    errorMessage.value = "Erreur lors de la suppression."
  }
}

// ----------------------
// PHOTOS - Drag & Drop Upload
// ----------------------
const isUploading = ref(false)
const dragOver = ref(false)
const fileInput = ref(null)

function triggerFileInput() {
  fileInput.value.click()
}

function handleFileSelect(event) {
  const file = event.target.files[0]
  if (file) uploadFile(file)
}

function handleDrop(event) {
  dragOver.value = false
  const file = event.dataTransfer.files[0]
  if (file && file.type.startsWith('image/')) uploadFile(file)
}

async function uploadFile(file) {
  isUploading.value = true
  const formData = new FormData()
  formData.append('file', file)

  try {
    const res = await api.post(`/Annonces/${annonceId}/upload-photo`, formData, {
      headers: { 
        'Content-Type': 'multipart/form-data'
      }
    })
    photos.value.push(res.data)
  } catch (error) {
    alert("Erreur lors de l'upload de l'image.")
  } finally {
    isUploading.value = false
    if (fileInput.value) fileInput.value.value = ''
  }
}

async function deletePhoto(photoId) {
  if (!confirm("Voulez-vous supprimer cette photo ?")) return
  try {
    await api.delete(`/Annonces/photos/${photoId}`)
    photos.value = photos.value.filter(p => p.idphoto !== photoId)
  } catch (error) {
    alert("Erreur suppression photo")
  }
}

onMounted(() => {
  if (!authState.isLoggedIn()) {
    router.push('/login')
    return
  }
  init()
})
</script>

<template>
  <div class="bg-[#f8f9fb] min-h-screen pb-12 font-sans">
    <div v-if="loading" class="flex justify-center items-center h-64">
      <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-orange-600"></div>
    </div>
    
    <main v-else class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
      
      <div class="flex flex-col md:flex-row justify-between items-start md:items-center mb-8 gap-4">
        <div>
          <router-link to="/my-annonces" class="text-sm font-medium text-gray-500 hover:text-gray-900 mb-2 inline-flex items-center gap-1">
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"></path></svg>
            Retour
          </router-link>
          <h2 class="font-semibold text-xl text-gray-800 leading-tight">Modifier l'annonce</h2>
        </div>
        <button @click="deleteAnnonce" class="flex items-center gap-2 px-6 py-2.5 border border-red-200 bg-red-50 text-red-600 font-bold rounded-xl hover:bg-red-100 transition-colors shadow-sm">
          <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"></path></svg>
          Supprimer
        </button>
      </div>

      <div v-if="successMessage" class="bg-green-50 text-green-700 p-4 rounded-xl mb-6 font-medium border border-green-200 shadow-sm flex items-center gap-3">
        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path></svg>
        {{ successMessage }}
      </div>
      <div v-if="errorMessage" class="bg-red-50 text-red-700 p-4 rounded-xl mb-6 font-medium border border-red-200 shadow-sm flex items-center gap-3">
        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg>
        {{ errorMessage }}
      </div>

      <div class="grid grid-cols-1 lg:grid-cols-12 gap-6">
        
        <div class="lg:col-span-7 space-y-6">
          <form @submit.prevent="saveAnnonce" class="bg-white border border-gray-200 rounded-xl shadow-sm p-6 space-y-6">
            <h2 class="text-lg font-bold text-gray-900 border-b border-gray-100 pb-3">Informations Générales</h2>
            
            <div>
              <label class="block font-semibold text-gray-800 mb-2 text-sm">Titre de l'annonce</label>
              <input v-model="form.titreannonce" type="text" class="w-full rounded-xl border border-gray-200 bg-gray-50 px-4 py-3 text-base shadow-sm focus:bg-white focus:border-[#EA580C] focus:ring-4 focus:ring-orange-500/10 transition-all outline-none" placeholder="Ex: Magnifique appartement face mer..." />
            </div>
            
            <div>
              <label class="block font-semibold text-gray-800 mb-2 text-sm">Description</label>
              <textarea v-model="form.descriptionannonce" rows="6" class="w-full rounded-xl border border-gray-200 bg-gray-50 px-4 py-3 text-base shadow-sm focus:bg-white focus:border-[#EA580C] focus:ring-4 focus:ring-orange-500/10 transition-all outline-none resize-y" placeholder="Détaillez les atouts de votre propriété..."></textarea>
            </div>
            
            <div class="grid grid-cols-2 gap-6">
              <div>
                <label class="block font-semibold text-gray-800 mb-2 text-sm">Prix par nuit (€)</label>
                <input v-model="form.prixnuitee" type="number" step="0.01" class="w-full rounded-xl border border-gray-200 bg-gray-50 px-4 py-3 text-base shadow-sm focus:bg-white focus:border-[#EA580C] focus:ring-4 focus:ring-orange-500/10 transition-all outline-none" />
              </div>
              <div>
                <label class="block font-semibold text-gray-800 mb-2 text-sm">Capacité max</label>
                <input v-model="form.capacite" type="number" class="w-full rounded-xl border border-gray-200 bg-gray-50 px-4 py-3 text-base shadow-sm focus:bg-white focus:border-[#EA580C] focus:ring-4 focus:ring-orange-500/10 transition-all outline-none" />
              </div>
              <div>
                <label class="block font-semibold text-gray-800 mb-2 text-sm">Chambres</label>
                <input v-model="form.nbchambres" type="number" class="w-full rounded-xl border border-gray-200 bg-gray-50 px-4 py-3 text-base shadow-sm focus:bg-white focus:border-[#EA580C] focus:ring-4 focus:ring-orange-500/10 transition-all outline-none" />
              </div>
              <div>
                <label class="block font-semibold text-gray-800 mb-2 text-sm">Min. nuitées</label>
                <input v-model="form.minimumnuitee" type="number" class="w-full rounded-xl border border-gray-200 bg-gray-50 px-4 py-3 text-base shadow-sm focus:bg-white focus:border-[#EA580C] focus:ring-4 focus:ring-orange-500/10 transition-all outline-none" />
              </div>
            </div>

            <div class="flex gap-8 mt-6 pt-6 border-t border-gray-100">
              <label class="flex items-center gap-3 cursor-pointer group">
                <input v-model="form.possibiliteanimaux" type="checkbox" class="w-5 h-5 rounded border-gray-300 text-[#ea580c] shadow-sm focus:ring-[#ea580c] transition-colors" />
                <span class="text-base font-medium text-gray-800">Animaux autorisés</span>
              </label>
              <label class="flex items-center gap-3 cursor-pointer group">
                <input v-model="form.possibilitefumeur" type="checkbox" class="w-5 h-5 rounded border-gray-300 text-[#ea580c] shadow-sm focus:ring-[#ea580c] transition-colors" />
                <span class="text-base font-medium text-gray-800">Fumeur autorisé</span>
              </label>
            </div>

            <div class="flex justify-end pt-6">
                <button type="submit" :disabled="saving" class="inline-flex items-center px-6 py-3 bg-gray-900 border border-transparent rounded-xl font-bold text-base text-white hover:bg-gray-800 transition ease-in-out duration-150 disabled:opacity-50">
                {{ saving ? 'Enregistrement...' : 'Enregistrer' }}
                </button>
            </div>
          </form>
        </div>

        <div class="lg:col-span-5 space-y-6">
          
          <div class="bg-white border border-gray-200 rounded-xl shadow-sm p-6">
            <h2 class="text-lg font-bold text-gray-900 border-b border-gray-100 pb-3 mb-4">Photos de l'annonce</h2>
            
            <div 
              class="border border-dashed border-gray-300 rounded-lg p-6 mb-4 text-center cursor-pointer transition-colors flex flex-col items-center justify-center gap-2"
              @dragover.prevent="dragOver = true"
              @dragleave.prevent="dragOver = false"
              @drop.prevent="handleDrop"
              @click="triggerFileInput"
              :class="dragOver ? 'bg-orange-50 border-[#ea580c]' : 'bg-gray-50 hover:bg-gray-100'"
            >
              <svg class="w-8 h-8 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-8l-4-4m0 0L8 8m4-4v12"></path></svg>
              <div v-if="!isUploading">
                <p class="font-medium text-gray-700 text-sm">Glissez-déposez une photo</p>
                <p class="text-xs text-gray-500 mt-1">ou parcourez vos fichiers</p>
              </div>
              <div v-else class="flex flex-col items-center">
                <div class="w-5 h-5 border-2 border-orange-200 border-t-[#ea580c] rounded-full animate-spin"></div>
                <p class="text-xs font-bold text-[#ea580c] mt-2">Chargement...</p>
              </div>
              <input type="file" ref="fileInput" class="hidden" @change="handleFileSelect" accept="image/*" />
            </div>

            <div v-if="photos.length > 0" class="grid grid-cols-3 gap-2">
              <div v-for="photo in photos" :key="photo.idphoto" class="relative group aspect-square">
                <img :src="photo.lienphoto" class="w-full h-full object-cover rounded-lg border border-gray-200" />
                <button @click="deletePhoto(photo.idphoto)" class="absolute top-1 right-1 bg-white text-gray-500 hover:text-red-500 rounded p-1 shadow-sm opacity-0 group-hover:opacity-100 transition-opacity">
                  <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg>
                </button>
              </div>
            </div>
            <p v-else class="text-xs text-gray-400 text-center">Aucune photo enregistrée.</p>
          </div>

          <div class="bg-white border border-gray-200 rounded-xl shadow-sm p-6 flex flex-col items-center">
            <h2 class="text-lg font-bold text-gray-900 border-b border-gray-100 pb-3 mb-4 w-full text-left">Gérer les Indisponibilités</h2>
            
            <UnavailabilityCalendar
              :annonce-id="annonceId"
              v-model="unavailabilities"
            />

            <p class="text-xs text-gray-500 mt-4 text-center">
              Cliquez ou sélectionnez une plage de dates pour les bloquer / débloquer.
            </p>

          </div>

        </div>
      </div>
    </main>
  </div>
</template>
