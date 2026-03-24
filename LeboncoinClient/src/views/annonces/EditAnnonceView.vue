<script setup>
import { ref, onMounted, reactive, computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import axios from 'axios'
import { authState } from '@/auth.js'

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

// Photos Drag & Drop
const isUploading = ref(false)
const dragOver = ref(false)
const fileInput = ref(null)

// Calendar variables
const currentYear = ref(new Date().getFullYear())
const currentMonth = ref(new Date().getMonth())
const isAddingUnavail = ref(false)
const selectionStart = ref(null)
const hoveredDate = ref(null)

const monthNames = ["Janvier","Février","Mars","Avril","Mai","Juin","Juillet","Août","Septembre","Octobre","Novembre","Décembre"]
const currentMonthName = computed(() => monthNames[currentMonth.value])

const blankDays = computed(() => {
  let firstDay = new Date(currentYear.value, currentMonth.value, 1).getDay()
  return firstDay === 0 ? 6 : firstDay - 1
})

const daysInMonth = computed(() => {
  let days = new Date(currentYear.value, currentMonth.value + 1, 0).getDate()
  let arr = []
  for(let i=1; i<=days; i++){
    let y = currentYear.value
    let m = String(currentMonth.value + 1).padStart(2, '0')
    let d = String(i).padStart(2, '0')
    arr.push({ dateNum: i, dateStr: `${y}-${m}-${d}` })
  }
  return arr
})

const today = new Date()
const todayStr = computed(() => {
  const y = today.getFullYear()
  const m = String(today.getMonth() + 1).padStart(2, '0')
  const day = String(today.getDate()).padStart(2, '0')
  return `${y}-${m}-${day}`
})

const blockPastNav = computed(() => {
  if (currentYear.value < today.getFullYear()) return true
  if (currentYear.value === today.getFullYear() && currentMonth.value <= today.getMonth()) return true
  return false
})

function isPastDate(dateStr) {
  return dateStr < todayStr.value
}

function changeMonth(delta) {
  if (delta === -1 && blockPastNav.value) return
  
  let newMonth = currentMonth.value + delta
  if (newMonth > 11) {
    newMonth = 0
    currentYear.value++
  } else if (newMonth < 0) {
    newMonth = 11
    currentYear.value--
  }
  currentMonth.value = newMonth
}

function isUnavailable(dateStr) {
  return unavailabilities.value.includes(dateStr)
}

function isSelectedOrHovered(dateStr) {
  if (!selectionStart.value) return false
  if (selectionStart.value === dateStr) return true
  if (hoveredDate.value) {
    const d = new Date(dateStr)
    const s = new Date(selectionStart.value)
    const h = new Date(hoveredDate.value)
    const min = new Date(Math.min(s, h))
    const max = new Date(Math.max(s, h))
    return d >= min && d <= max
  }
  return false
}

async function handleDayClick(dateStr) {
  if (isAddingUnavail.value) return

  if (!selectionStart.value) {
    selectionStart.value = dateStr
  } else {
    const start = selectionStart.value
    const end = dateStr
    selectionStart.value = null
    hoveredDate.value = null

    isAddingUnavail.value = true
    try {
      const isUnblocking = isUnavailable(start)
      const sDate = new Date(start)
      const eDate = new Date(end)
      const minStr = sDate <= eDate ? start : end
      const maxStr = sDate <= eDate ? end : start

      if (isUnblocking) {
         let curr = new Date(minStr)
         let endD = new Date(maxStr)
         while(curr <= endD) {
            let dStr = curr.toISOString().split('T')[0]
            unavailabilities.value = unavailabilities.value.filter(d => d !== dStr)
            try { await axios.delete(`https://localhost:7057/api/Annonces/${annonceId}/indisponibilites/${dStr}`) } catch(e){}
            curr.setDate(curr.getDate() + 1)
         }
      } else {
         await axios.post(`https://localhost:7057/api/Annonces/${annonceId}/indisponibilites`, {
           startDate: minStr,
           endDate: maxStr
         })
         await fetchUnavailabilities()
      }
    } catch(e) {
      console.error(e)
      alert("Erreur lors de la modification des disponibilités.")
    } finally {
      isAddingUnavail.value = false
    }
  }
}

async function fetchAnnonce() {
  try {
    const response = await axios.get(`https://localhost:7057/api/Annonces/${annonceId}`)
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
    const res = await axios.get(`https://localhost:7057/api/Annonces/${annonceId}/indisponibilites`)
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
    await axios.put(`https://localhost:7057/api/Annonces/${annonceId}`, form)
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
    await axios.delete(`https://localhost:7057/api/Annonces/${annonceId}`)
    router.push('/my-annonces')
  } catch (error) {
    errorMessage.value = "Erreur lors de la suppression."
  }
}

// ----------------------
// PHOTOS - Drag & Drop Upload
// ----------------------
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
    const res = await axios.post(`https://localhost:7057/api/Annonces/${annonceId}/upload-photo`, formData, {
      headers: { 'Content-Type': 'multipart/form-data' }
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
    await axios.delete(`https://localhost:7057/api/Annonces/photos/${photoId}`)
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
    <!-- Loader -->
    <div v-if="loading" class="flex justify-center items-center h-64">
      <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-orange-600"></div>
    </div>
    
    <main v-else class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
      
      <!-- HEADER matching Laravel Dashboard -->
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
        
        <!-- Informations Generales -->
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
          
          <!-- PHOTOS ZONE -->
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

          <!-- CALENDAR ZONE EXACT LY LIKE FLATPICKR -->
          <div class="bg-white border border-gray-200 rounded-xl shadow-sm p-6 flex flex-col items-center">
            <h2 class="text-lg font-bold text-gray-900 border-b border-gray-100 pb-3 mb-4 w-full text-left">Gérer les Indisponibilités</h2>
            
            <div class="flatpickr-calendar w-full max-w-[320px]">
              <div class="flatpickr-months">
                <span class="flatpickr-prev-month" @click="changeMonth(-1)" :class="{'opacity-30 cursor-not-allowed hover:!bg-transparent': blockPastNav}">
                  <svg version="1.1" xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 14 14"><path d="M9.5 12L4.5 7l5-5" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/></svg>
                </span>
                <div class="flatpickr-month">{{ currentMonthName }} {{ currentYear }}</div>
                <span class="flatpickr-next-month" @click="changeMonth(1)">
                  <svg version="1.1" xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 14 14"><path d="M4.5 12l5-5-5-5" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/></svg>
                </span>
              </div>
              
              <div class="flatpickr-innerContainer">
                <div class="flatpickr-days">
                  <div class="flatpickr-weekdays">
                    <span class="flatpickr-weekday" v-for="day in ['lun','mar','mer','jeu','ven','sam','dim']" :key="day">{{day}}</span>
                  </div>
                  <div class="grid grid-cols-7 place-items-center">
                    <span class="flatpickr-day prevMonthDay" v-for="blank in blankDays" :key="'blank-'+blank"></span>
                    <span 
                      v-for="d in daysInMonth" 
                      :key="d.dateStr"
                      @click="!isPastDate(d.dateStr) && handleDayClick(d.dateStr)"
                      @mouseenter="!isPastDate(d.dateStr) && (hoveredDate = d.dateStr)"
                      @mouseleave="hoveredDate = null"
                      class="flatpickr-day relative"
                      :class="{
                        'opacity-30 cursor-not-allowed hover:!bg-transparent': isPastDate(d.dateStr),
                        'disabled': isUnavailable(d.dateStr) && !isPastDate(d.dateStr),
                        'selected': isSelectedOrHovered(d.dateStr) && !isPastDate(d.dateStr),
                        '!bg-gray-200 !text-gray-400': isUnavailable(d.dateStr) && !isSelectedOrHovered(d.dateStr) && !isPastDate(d.dateStr),
                        'startRange': selectionStart === d.dateStr && !isPastDate(d.dateStr)
                      }"
                    >
                      {{ d.dateNum }}
                      <span v-if="isAddingUnavail && (isSelectedOrHovered(d.dateStr) || selectionStart === d.dateStr) && !isPastDate(d.dateStr)" class="absolute inset-0 bg-white/30 rounded"></span>
                    </span>
                  </div>
                </div>
              </div>
            </div>

            <p class="text-xs text-gray-500 mt-4 text-center">
              Cliquez ou sélectionnez une plage de dates pour les bloquer / débloquer.
            </p>

          </div>

        </div>
      </div>
    </main>
  </div>
</template>

<style scoped>
/* Exact replication of Laravel's flatpickr CSS */
.flatpickr-calendar {
    background: white;
    border: 1px solid #e5e7eb;
    border-radius: 12px;
    box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', 'Oxygen', 'Ubuntu', 'Cantarell', sans-serif;
    padding: 10px;
    width: 100%;
}

.flatpickr-months {
    display: flex;
    justify-content: space-between;
    align-items: center;
    background: white;
    margin-bottom: 8px;
    position: relative;
}

.flatpickr-month {
    font-weight: 600;
    font-size: 16px;
    color: #222;
    text-align: center;
}

.flatpickr-prev-month,
.flatpickr-next-month {
    color: #EA580C;
    cursor: pointer;
    transition: all 0.2s ease;
    height: 32px;
    width: 32px;
    display: flex;
    align-items: center;
    justify-content: center;
}

.flatpickr-prev-month:hover,
.flatpickr-next-month:hover {
    opacity: 0.7;
    background: #fff7ed;
    border-radius: 50%;
}

.flatpickr-weekdays {
    display: grid;
    grid-template-columns: repeat(7, 1fr);
    background: white;
    padding: 8px 0;
    font-weight: 500;
    font-size: 12px;
    color: #999;
    text-transform: lowercase;
    border-bottom: 1px solid #f0f0f0;
    margin-bottom: 8px;
}

.flatpickr-weekday {
    display: flex;
    align-items: center;
    justify-content: center;
    font-weight: 400;
}

.flatpickr-days {
    width: 100%;
}

.flatpickr-day {
    width: 36px;
    height: 36px;
    font-size: 14px;
    color: #222;
    border-radius: 6px;
    display: flex;
    align-items: center;
    justify-content: center;
    transition: all 0.15s ease;
    cursor: pointer;
    margin: 2px 0;
    font-weight: 500;
}

.flatpickr-day:hover:not(.disabled):not(.prevMonthDay) {
    background-color: #f3f4f6;
}

.flatpickr-day.selected,
.flatpickr-day.startRange {
    background-color: #222 !important;
    color: white !important;
    font-weight: 600;
}

/* Custom visual for unavailable blocked days (line-through disabled look) */
.flatpickr-day.disabled {
    background-color: white;
    color: #9ca3af !important;
    text-decoration: line-through;
    text-decoration-color: #ef4444;
    text-decoration-thickness: 2px;
}
.flatpickr-day.disabled:hover {
    background-color: #fee2e2 !important;
}

/* Active range coloring to match flatpickr's style */
.flatpickr-day.selected {
    background-color: #222 !important;
}
</style>
