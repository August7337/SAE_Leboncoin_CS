<script setup>
import { ref, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import api from '@/api/axios'
import AnnonceList from '@/components/AnnonceList.vue'

const route = useRoute()
const sellerId = route.params.id

const seller = ref(null)
const annonces = ref([])
const loading = ref(true)
const error = ref(null)

function formatDate(dateStr) {
  if (!dateStr) return 'Date inconnue'
  return new Intl.DateTimeFormat('fr-FR', { month: 'long', year: 'numeric' }).format(new Date(dateStr))
}

async function fetchData() {
  loading.value = true
  try {
    const [userRes, annoncesRes] = await Promise.all([
      api.get(`/Utilisateurs/${sellerId}/public`),
      api.get(`/Annonces/user/${sellerId}`)
    ])
    seller.value = userRes.data
    annonces.value = annoncesRes.data
  } catch (err) {
    console.error('Erreur lors du chargement du profil:', err)
    error.value = 'Impossible de charger le profil du vendeur.'
  } finally {
    loading.value = false
  }
}

onMounted(fetchData)
</script>

<template>
  <div class="min-h-screen bg-white">
    <div class="max-w-6xl mx-auto px-4 md:px-12 xl:px-6 py-8">
      <div v-if="loading" class="flex justify-center items-center h-[60vh]">
        <div class="w-12 h-12 border-4 border-orange-100 border-t-[#ea580c] rounded-full animate-spin"></div>
      </div>

      <div v-else-if="error" class="text-center py-20">
        <p class="text-red-500 font-bold">{{ error }}</p>
        <router-link to="/" class="text-blue-500 hover:underline mt-4 inline-block">Retour à l'accueil</router-link>
      </div>

      <div v-else-if="seller" class="space-y-8">
        <!-- Breadcrumb -->
        <nav class="flex text-sm text-gray-500 items-center gap-2 mb-6">
          <router-link to="/" class="hover:text-[#ea580c] transition-colors">Accueil</router-link>
          <span class="text-gray-300">/</span>
          <span class="font-medium text-gray-900 truncate">Profil de {{ seller.pseudonyme }}</span>
        </nav>

        <!-- Seller Card (Matching AnnonceView style) -->
        <div class="bg-slate-50 border border-slate-100 rounded-3xl p-8 transition-all hover:shadow-md">
          <div class="flex flex-col md:flex-row gap-8 items-start md:items-center">
            <div class="relative flex-shrink-0">
              <img
                :src="
                  seller.profilePhotoPath ||
                  'https://ui-avatars.com/api/?name=' +
                    encodeURIComponent(seller.pseudonyme || 'U')
                "
                :alt="seller.pseudonyme"
                class="w-24 h-24 rounded-full object-cover border-4 border-white shadow-sm"
              />
              <div 
                v-if="seller.identityVerified"
                class="absolute -bottom-1 -right-1 bg-blue-500 text-white p-1.5 rounded-full border-2 border-white shadow-sm"
                title="Identité vérifiée"
              >
                <svg class="w-4 h-4" fill="currentColor" viewBox="0 0 20 20">
                  <path fill-rule="evenodd" d="M2.166 4.9L9.03 9.069a2.25 2.25 0 002.49 0l6.861-4.17a2.25 2.25 0 00.32-3.619l-7.5-5.25a2.25 2.25 0 00-2.43 0l-7.5 5.25a2.25 2.25 0 00.395 3.62zM1.8 11.458l6.83 4.148a2.25 2.25 0 002.49 0l6.83-4.148a.75.75 0 01.765 1.284l-6.83 4.148a3.75 3.75 0 01-4.15 0L.785 12.742a.75.75 0 11.765-1.284z" clip-rule="evenodd" />
                  <path d="M10 11a1 1 0 100-2 1 1 0 000 2z" />
                  <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" />
                </svg>
              </div>
            </div>

            <div class="flex-1 space-y-4 w-full">
              <div class="flex flex-col md:flex-row md:items-center justify-between gap-4">
                <div>
                  <h1 class="text-2xl font-black text-slate-900 mb-1">
                    {{ seller.pseudonyme }}
                  </h1>
                  <p class="text-slate-500 font-medium flex items-center gap-2">
                    Membre depuis {{ formatDate(seller.dateInscription) }}
                  </p>
                </div>
                
                <div class="flex gap-2">
                  <span 
                    v-if="seller.phoneVerified"
                    class="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-full text-sm font-bold bg-green-50 text-green-700 border border-green-100"
                  >
                    <svg class="w-4 h-4" fill="currentColor" viewBox="0 0 20 20">
                      <path d="M2.003 5.884L10 9.882l7.997-3.998A2 2 0 0016 4H4a2 2 0 00-1.997 1.884z" />
                      <path d="M18 8.118l-8 4-8-4V14a2 2 0 002 2h12a2 2 0 002-2V8.118z" />
                    </svg>
                    Téléphone vérifié
                  </span>
                </div>
              </div>

              <div class="grid grid-cols-1 sm:grid-cols-2 gap-4 pt-4 border-t border-slate-200">
                <div class="flex items-center gap-3">
                  <div class="p-2.5 bg-white rounded-xl shadow-sm border border-slate-100">
                    <svg class="w-5 h-5 text-orange-500 fill-current" viewBox="0 0 24 24">
                      <path d="M11.0437 2.29647C10.7942 2.46286 10.5447 2.71245 10.3784 3.04524L8.29938 7.6211L3.55925 8.28668C3.22661 8.28668 2.97713 8.45307 2.64449 8.61947C2.39501 8.86906 2.14553 9.11865 2.06237 9.45144C1.97921 9.86742 1.97921 10.2002 2.06237 10.533C2.14553 10.8658 2.31185 11.1986 2.56133 11.4482L6.05405 14.9425L5.22245 19.9343C5.13929 20.2671 5.22245 20.5999 5.30561 20.9327C5.38877 21.2655 5.63825 21.5151 5.88773 21.6814C6.13721 21.8478 6.46985 22.0142 6.8025 22.0142C7.13514 22.0142 7.46778 21.931 7.71726 21.8478L12.0416 19.5183L16.3659 21.8478C16.6154 22.0142 16.948 22.0974 17.2807 22.0142C17.6133 22.0142 17.9459 21.8478 18.1954 21.6814C18.4449 21.5151 18.6944 21.1823 18.7775 20.9327C18.8607 20.5999 18.9439 20.2671 18.8607 19.9343L18.0291 14.9425L21.4387 11.365C21.6882 11.1154 21.8545 10.8658 21.9376 10.533C22.0208 10.2002 22.0208 9.86742 21.9376 9.53464C21.8545 9.20185 21.6882 8.95225 21.4387 8.70266C21.1892 8.45307 20.8566 8.36987 20.6071 8.28668L15.8669 7.5379L13.7048 3.04524C13.5385 2.71245 13.3721 2.46286 13.0395 2.29647C12.79 2.13007 12.5405 2.04688 12.2911 2.04688H11.9584C11.5426 2.13007 11.2931 2.21327 11.0437 2.29647Z"></path>
                    </svg>
                  </div>
                  <div class="flex flex-col">
                    <span class="font-bold text-slate-900">
                      {{ seller.noteMoyenne ? Number(seller.noteMoyenne).toFixed(1) : '∅' }}
                    </span>
                    <span class="text-xs text-slate-500">{{ seller.nombreAvis || 0 }} avis</span>
                  </div>
                </div>

                <div class="flex items-center gap-3">
                  <div class="p-2.5 bg-white rounded-xl shadow-sm border border-slate-100 text-slate-700">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10" />
                    </svg>
                  </div>
                  <div class="flex flex-col">
                    <span class="font-bold text-slate-900">{{ seller.nombreAnnonces || 0 }}</span>
                    <span class="text-xs text-slate-500">annonces en ligne</span>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Ads Section -->
        <div>
          <h2 class="text-2xl font-bold mb-6">
            Annonces de {{ seller.pseudonyme }}
          </h2>
          
          <div v-if="annonces.length > 0">
            <AnnonceList :annonces="annonces" />
          </div>
          <div v-else class="bg-slate-50 border-2 border-dashed border-slate-200 rounded-3xl p-12 text-center">
            <p class="text-slate-500 font-medium">Ce vendeur n'a aucune annonce en ligne pour le moment.</p>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
