<template>
  <div v-if="isOpen" class="fixed inset-0 z-50 overflow-hidden">
    <!-- Overlay -->
    <div 
      class="absolute inset-0 bg-black/50 transition-opacity" 
      @click="$emit('close')"
    ></div>

    <!-- Sidebar Panel -->
    <div class="absolute inset-y-0 right-0 w-full max-w-[480px] bg-white shadow-2xl flex flex-col transform transition-transform duration-300">
      
      <!-- Header -->
      <div class="flex items-center justify-between px-6 py-4 border-b border-gray-100">
        <h2 class="text-xl font-bold text-slate-900">Tous les filtres</h2>
        <button 
          @click="$emit('close')"
          class="flex items-center justify-center w-10 h-10 bg-white border border-gray-200 rounded-[15px] shadow-sm hover:bg-gray-50 text-sm font-bold transition-colors"
        >
          ✕
        </button>
      </div>

      <!-- Content -->
      <div class="flex-1 overflow-y-auto p-6 space-y-8 scrollbar-hide">
        
        <!-- Dates -->
        <div>
          <div class="flex items-center gap-2 mb-4">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" class="w-5 h-5 text-slate-700">
              <path stroke-linecap="round" stroke-linejoin="round" d="M6.75 3v2.25M17.25 3v2.25M3 18.75V7.5a2.25 2.25 0 012.25-2.25h13.5A2.25 2.25 0 0121 7.5v11.25m-18 0A2.25 2.25 0 005.25 21h13.5A2.25 2.25 0 0021 18.75m-18 0v-7.5A2.25 2.25 0 015.25 9h13.5A2.25 2.25 0 0121 11.25v7.5" />
            </svg>
            <span class="text-lg font-medium text-slate-900">Dates</span>
          </div>

          <div class="flex gap-4 mb-6">
            <div class="flex-1">
              <label class="text-xs text-gray-500 block mb-1">Arrivée</label>
              <input 
                type="date" 
                v-model="localFilters.dateArrivee"
                class="w-full border border-gray-300 rounded-lg p-3 text-sm focus:ring-2 focus:ring-orange-500 outline-none"
              >
            </div>
            <div class="flex items-center text-sm text-gray-400 pt-5">au</div>
            <div class="flex-1">
              <label class="text-xs text-gray-500 block mb-1">Départ</label>
              <input 
                type="date" 
                v-model="localFilters.dateDepart"
                class="w-full border border-gray-300 rounded-lg p-3 text-sm focus:ring-2 focus:ring-orange-500 outline-none"
              >
            </div>
          </div>
        </div>

        <!-- Type d'hébergement -->
        <div class="py-6 border-b border-gray-200 border-t">
          <div @click="showTypes = !showTypes" class="cursor-pointer group">
            <div class="flex items-center justify-between">
              <div class="flex items-start gap-4">
                <div class="pt-1 text-slate-600">
                  <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M2.25 21h19.5m-18-18v18m10.5-18v18m6-13.5V21M6.75 6.75h.75m-.75 3h.75m-.75 3h.75m3-6h.75m-.75 3h.75m-.75 3h.75M6.75 21v-3.375c0-.621.504-1.125 1.125-1.125h2.25c.621 0 1.125.504 1.125 1.125V21M3 3h12m-.75 4.5H21m-3.75 3.75h.008v.008h-.008v-.008zm0 3h.008v.008h-.008v-.008zm0 3h.008v.008h-.008v-.008z" />
                  </svg>
                </div>
                <div>
                  <div class="text-lg font-medium text-slate-800 group-hover:underline decoration-1 underline-offset-2">Type d’hébergement</div>
                  <div class="text-sm text-gray-500 mt-1">
                    {{ localFilters.typeHebergementIds.length > 0 ? localFilters.typeHebergementIds.length + ' sélectionné(s)' : 'Appartement, Maison, Villa...' }}
                  </div>
                </div>
              </div>
              <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" 
                class="w-5 h-5 text-gray-400 transition-transform duration-200"
                :class="showTypes ? 'rotate-180' : ''">
                <path stroke-linecap="round" stroke-linejoin="round" d="M19.5 8.25l-7.5 7.5-7.5-7.5" />
              </svg>
            </div>
          </div>

          <div v-show="showTypes" class="mt-5 space-y-4 pl-10">
            <label v-for="type in typesHebergement" :key="type.idtypehebergement" class="flex items-center cursor-pointer group">
              <input 
                type="checkbox" 
                :value="type.idtypehebergement" 
                v-model="localFilters.typeHebergementIds"
                class="w-5 h-5 border-gray-300 rounded text-orange-600 focus:ring-orange-500"
              >
              <span class="ml-4 text-lg text-slate-700 flex-1">{{ type.nomtypehebergement }}</span>
            </label>
          </div>
        </div>

        <!-- Prix -->
        <div class="py-6 border-b border-gray-200">
          <div class="flex items-center gap-4 mb-4">
            <div class="w-6 h-6 rounded-full border border-slate-600 flex items-center justify-center text-slate-600 font-serif text-sm font-bold">€</div>
            <span class="text-lg font-medium text-slate-800">Prix par nuit</span>
          </div>

          <div class="flex items-center gap-4 mb-2">
            <div class="flex-1">
              <label class="text-slate-800 text-base mb-2 block">Minimum</label>
              <div class="flex items-center border border-slate-400 rounded-lg overflow-hidden focus-within:ring-1 focus-within:ring-slate-900 focus-within:border-slate-900 h-12">
                <input type="number" min="0" v-model="localFilters.minPrice" class="w-full h-full px-4 outline-none text-slate-900" placeholder="Min">
                <div class="h-full px-4 border-l border-slate-300 bg-white flex items-center text-slate-900">€</div>
              </div>
            </div>
            <div class="flex-1">
              <label class="text-slate-800 text-base mb-2 block">Maximum</label>
              <div class="flex items-center border border-slate-400 rounded-lg overflow-hidden focus-within:ring-1 focus-within:ring-slate-900 focus-within:border-slate-900 h-12">
                <input type="number" min="0" v-model="localFilters.maxPrice" class="w-full h-full px-4 outline-none text-slate-900" placeholder="Max">
                <div class="h-full px-4 border-l border-slate-300 bg-white flex items-center text-slate-900">€</div>
              </div>
            </div>
          </div>
        </div>

        <!-- Chambres -->
        <div class="py-6 border-b border-gray-200">
          <div class="flex items-center gap-2 mb-4">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" class="w-5 h-5 text-slate-700">
              <path stroke-linecap="round" stroke-linejoin="round" d="M15 19.128a9.38 9.38 0 002.625.372 9.337 9.337 0 004.121-.952 4.125 4.125 0 00-7.533-2.493M15 19.128v-.003c0-1.113-.285-2.16-.786-3.07M15 19.128v.106A12.318 12.318 0 018.624 21c-2.331 0-4.512-.645-6.374-1.766l-.001-.109a6.375 6.375 0 0111.964-3.07M12 6.375a3.375 3.375 0 11-6.75 0 3.375 3.375 0 016.75 0zm8.25 2.25a2.625 2.625 0 11-5.25 0 2.625 2.625 0 015.25 0z" />
            </svg>
            <span class="text-lg font-medium text-slate-900">Chambres</span>
          </div>

          <div class="flex flex-wrap gap-2 mt-4">
            <button 
              @click="localFilters.nbChambres = 0"
              type="button"
              class="border rounded-lg px-4 py-2 transition-colors"
              :class="localFilters.nbChambres === 0 ? 'bg-[#ea580c] text-white border-[#ea580c]' : 'border-gray-300 hover:border-slate-400 text-slate-700'"
            >
              Tout
            </button>
            <button 
              v-for="num in [1, 2, 3, 4, 5, 6]" 
              :key="num"
              @click="localFilters.nbChambres = num"
              type="button"
              class="border rounded-lg px-4 py-2 transition-colors"
              :class="localFilters.nbChambres === num ? 'bg-[#ea580c] text-white border-[#ea580c]' : 'border-gray-300 hover:border-slate-400 text-slate-700'"
            >
              {{ num }}{{ num === 6 ? '+' : '' }}
            </button>
          </div>
        </div>

      </div>

      <!-- Footer -->
      <div class="p-4 border-t border-gray-200 flex items-center justify-between bg-white">
        <button 
          @click="resetFilters" 
          class="text-slate-900 font-medium px-4 py-2 hover:underline decoration-1 underline-offset-4"
        >
          Tout Effacer
        </button>

        <button 
          @click="applyFilters"
          class="bg-[#ea580c] hover:bg-[#c2410c] text-white transition-colors font-bold py-3 px-8 rounded-xl"
        >
          Rechercher
        </button>
      </div>

    </div>
  </div>
</template>

<script setup>
import { ref, watch, onMounted } from 'vue'
import annoncesService from '../services/annoncesService'

const props = defineProps({
  isOpen: Boolean,
  initialFilters: {
    type: Object,
    default: () => ({
      dateArrivee: '',
      dateDepart: '',
      minPrice: null,
      maxPrice: null,
      nbChambres: 0,
      typeHebergementIds: []
    })
  }
})

const emit = defineEmits(['close', 'apply'])

const showTypes = ref(false)
const typesHebergement = ref([])
const localFilters = ref({ ...props.initialFilters })

watch(() => props.isOpen, (newVal) => {
  if (newVal) {
    localFilters.value = { ...props.initialFilters, typeHebergementIds: [...props.initialFilters.typeHebergementIds] }
    loadTypes()
  }
})

const loadTypes = async () => {
  try {
    const data = await annoncesService.getTypeHebergements()
    typesHebergement.value = data
  } catch (error) {
    console.error('Erreur lors du chargement des types:', error)
  }
}

const resetFilters = () => {
  localFilters.value = {
    dateArrivee: '',
    dateDepart: '',
    minPrice: null,
    maxPrice: null,
    nbChambres: 0,
    typeHebergementIds: []
  }
}

const applyFilters = () => {
  emit('apply', { ...localFilters.value })
  emit('close')
}

onMounted(loadTypes)
</script>

<style scoped>
.scrollbar-hide::-webkit-scrollbar {
  display: none;
}
.scrollbar-hide {
  -ms-overflow-style: none;
  scrollbar-width: none;
}
</style>
