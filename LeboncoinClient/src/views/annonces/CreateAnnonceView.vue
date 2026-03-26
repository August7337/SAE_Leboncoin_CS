

<script  setup>
import { reactive, ref, onMounted, watch, computed } from 'vue'
import axios from 'axios'
import api from '@/api/axios'
import { useRouter } from 'vue-router'
import { authState } from '@/auth.js'
import { Cropper, CircleStencil } from 'vue-advanced-cropper';
import 'vue-advanced-cropper/dist/style.css';



const allCommodites = ref([]);
const selectedCommodites = ref([]);
const router = useRouter()
const isPublishing = ref(false)
const showSuccess = ref(false)
const apiError = ref('')
const cropperRef = ref(null)
const suggestions = ref([]);
const showSuggestions = ref(false);
const imageSource = ref(null); 
const photosList = ref([]); 
const isUploading = ref(false);
const photosLocal = ref([]);
const activeTab = ref('');  




const groupedCommodites = computed(() => {
  const groups = {}; 
  allCommodites.value.forEach(item => {
    const catName = item.idcategorieNavigation?.nomcategorie || 'Autres';
    if (!groups[catName]) {
      groups[catName] = [];
    }
    groups[catName].push(item);
  });
  return groups;
});
watch(groupedCommodites, (newVal) => {
  if (Object.keys(newVal).length > 0 && !activeTab.value) {
    activeTab.value = Object.keys(newVal);
  }
}, { immediate: true });

const typesHebergement = [
  { id: 1, nom: "Appartement" },
  { id: 2, nom: "Maison" },
  { id: 3, nom: "Chambre d'hôte" },
  { id: 4, nom: "Gîte" },
  { id: 5, nom: "Studio" },
  { id: 6, nom: "Loft" },
  { id: 7, nom: "Chalet" },
  { id: 8, nom: "Maison d'hôtes" },
  { id: 9, nom: "Bungalow" }
]
const fetchCommodites = async () => {
  try {
    const response = await api.get('/Commodites');
    allCommodites.value = response.data;
  } catch (error) {
    console.error("Erreur lors du chargement des commodités:", error);
  }
};

onMounted(() => {
  fetchCommodites();
});

const fetchAutocomplete = async () => {
  if (form.rue.length < 3) {
    suggestions.value = [];
    return;
  }

  try {
    const apiKey = 'd1f65bc8100b4c868d082eb1f125364e';
    const response = await axios.get(`https://api.geoapify.com/v1/geocode/autocomplete`, {
      params: {
        text: form.rue,
        apiKey: apiKey,
        lang: 'fr',
        filter: 'countrycode:fr' 
      }
    });
    suggestions.value = response.data.features;
    showSuggestions.value = true;
  } catch (error) {
    console.error("Error fetching autocomplete:", error);
  }
};

const selectSuggestion = (suggestion) => {
  const props = suggestion.properties;
  form.rue = props.housenumber ? `${props.housenumber} ${props.street}` : props.street || props.name;
  form.ville = props.city || props.town || '';
  form.codePostal = props.postcode || '';
  
  showSuggestions.value = false;
  suggestions.value = [];
};
const form = reactive({
  titreannonce: '',
  descriptionannonce: '',
  prixnuitee: 0,
  nombrepersonnesmax: 1,
  nbchambres: 1,
  nombrebebesmax: 0,
  liensphoto: [],
  rue: '',         
  ville: '',       
  codePostal: '',
  idtypehebergement: 1,
  possibiliteanimaux: false,
  possibilitefumeur: false,
  idheurearrivee: 14,
  idheuredepart: 10,
  minimumnuitee: 1, 
  acompte: 0,       
  isAcomptePercentage: true 
  
})

const apiErrors = ref([]) 

const validate = () => {
  const errors = []
  if (!form.titreannonce?.trim()) errors.push("Le titre est requis.")
  if (form.titreannonce?.length < 10) errors.push("Le titre doit faire au moins 10 caractères.")
  if (!form.rue?.trim()) errors.push("L'adresse (rue) est requise.")
  if (!form.ville?.trim()) errors.push("La ville est requise.")
  if (!/^\d{5}$/.test(form.codePostal)) errors.push("Le code postal doit comporter 5 chiffres.")
  if (photosLocal.value.length === 0) errors.push("Ajoutez au moins une photo.")
  if (form.prixnuitee <= 0) errors.push("Le prix doit être supérieur à 0€.")
  if (form.idheurearrivee === form.idheuredepart) {
    errors.push("L'heure d'arrivée ne peut pas être identique à l'heure de départ.")
  }
  if (form.acompte < 0) {
    errors.push("L'acompte ne peut pas être un nombre négatif.")
  }
  if (form.isAcomptePercentage) {
    if (form.acompte > 100) {
      errors.push("L'acompte en pourcentage ne peut pas dépasser 100%.")
    }
  } else {
    if (form.acompte > form.prixnuitee) {
      errors.push("L'acompte ne peut pas être supérieur au prix d'une nuitée.")
    }
  }
  if (form.isAcomptePercentage && (form.acompte < 0 || form.acompte > 100)) {
    errors.push("L'acompte doit être entre 0% et 100%.")
  }
  return errors.length > 0 ? errors : null
}

const removePhoto = (index) => {
  URL.revokeObjectURL(photosLocal.value[index].previewUrl);
  photosLocal.value.splice(index, 1);
};
var requestOptions = {
  method: 'GET',
};
const onFileChange = (event) => {
  const files = event.target.files;
  if (!files || files.length === 0) return;
  const file = files[0]; 
  if (!(file instanceof Blob)) {
    console.error("Le fichier sélectionné n'est pas valide."+ file);
    return;
  }
  if (imageSource.value && imageSource.value.startsWith('blob:')) {
    URL.revokeObjectURL(imageSource.value);
  }

  imageSource.value = URL.createObjectURL(file);
};

const addPhotoToList = () => {
  const { canvas } = cropperRef.value.getResult();
  if (!canvas) return;

  // Redimensionner à 1280px max pour éviter la saturation RAM
  const MAX_SIZE = 1280;
  let w = canvas.width;
  let h = canvas.height;
  if (w > MAX_SIZE || h > MAX_SIZE) {
    if (w > h) { h = Math.round(h * MAX_SIZE / w); w = MAX_SIZE; }
    else { w = Math.round(w * MAX_SIZE / h); h = MAX_SIZE; }
  }

  const scaled = document.createElement('canvas');
  scaled.width = w;
  scaled.height = h;
  scaled.getContext('2d').drawImage(canvas, 0, 0, w, h);

  // toBlob est bien plus léger que toDataURL (pas de chaîne Base64 en RAM)
  scaled.toBlob((blob) => {
    const previewUrl = URL.createObjectURL(blob);
    photosLocal.value.push({ blob, previewUrl });
    imageSource.value = null;
  }, 'image/jpeg', 0.80);
};

const publishAnnonce = async () => {
  apiErrors.value = []
  apiError.value = ''
  const validationErrors = validate()
  if (validationErrors) {
    apiErrors.value = validationErrors
    window.scrollTo({ top: 0, behavior: 'smooth' })
    return
  }

  isPublishing.value = true
  try {
    const payload = {
      ...form,
      idutilisateur: authState.user.idutilisateur,
      liensphoto: photosLocal.value.map(p => p.base64), 
      acomptefixe: !form.isAcomptePercentage ? Number(form.acompte) : 0,
      idcommodites: selectedCommodites.value,
      acomptepourcentage: form.isAcomptePercentage ? Number(form.acompte) : 0,
      minimumnuitee: Number(form.minimumnuitee),
      prixnuitee: Number(form.prixnuitee)
    };

    const response = await api.post(`/Annonces`, payload);

    const nouvelleAnnonceId = response.data.idannonce || response.data.annonceId || response.data.id;

    if (nouvelleAnnonceId && photosLocal.value.length > 0) {
      for (let i = 0; i < photosLocal.value.length; i++) {
        const photo = photosLocal.value[i];

        const formData = new FormData();
        formData.append('file', photo.blob, `photo_${i}.jpg`);

        await api.post(`/Annonces/${nouvelleAnnonceId}/upload-photo`, formData, {
          headers: { 'Content-Type': 'multipart/form-data' }
        });
      }
    }
    showSuccess.value = true
    setTimeout(() => router.push({ name: 'home' }), 1500)

  } catch (error) {
    if (error.response && error.response.data) {
      apiError.value = "Le serveur a refusé l'annonce ou l'upload d'une photo."
    } else {
      apiError.value = "Impossible de contacter le serveur."
    }
    console.error("Détail de l'erreur :", error)
  } finally {
    isPublishing.value = false
  }
}
</script>

<template>
  <div class="min-h-screen bg-[#f5f5f5] py-10">
    <div v-if="showSuccess" class="fixed inset-0 flex items-center justify-center bg-white/95 z-50">
      <div class="text-center">
        <div class="w-20 h-20 bg-orange-100 rounded-full flex items-center justify-center mx-auto mb-4 animate-pulse">
          <svg xmlns="http://www.w3.org/2000/svg" class="h-10 w-10 text-[#ea580c]" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M5 13l4 4L19 7" />
          </svg>
        </div>
        <h2 class="text-2xl font-bold text-gray-900">Annonce publiée !</h2>
        <p class="text-gray-500 mt-2">Elle est désormais visible par tous.</p>
      </div>
    </div>

    <div class="max-w-3xl mx-auto px-4">
      <h1 class="text-2xl font-black text-gray-900 mb-8">Déposer une annonce</h1>

      <form @submit.prevent="publishAnnonce" class="space-y-6">
<div 
  v-if="apiErrors.length > 0" 
  class="bg-red-50 border-l-4 border-red-500 p-5 rounded-2xl mb-8 shadow-sm"
>
  <div class="flex items-center mb-3">
    <svg class="h-6 w-6 text-red-600 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
    </svg>
    <h3 class="text-red-800 font-black text-lg">Champs requis manquants</h3>
  </div>
  <ul class="space-y-1 ml-8">
    <li v-for="(error, index) in apiErrors" :key="index" class="text-red-700 text-sm font-bold list-disc">
      {{ error }}
    </li>
  </ul>
</div>

<div class="bg-white rounded-3xl p-6 shadow-sm border" 
     :class="apiErrors.some(e => e.includes('titre')) ? 'border-red-500' : 'border-gray-100'">
  <label class="block text-sm font-bold mb-2">Titre de l'annonce</label>
  <input
    v-model="form.titreannonce"
    type="text"
    :class="{'border-red-300 bg-red-50': apiErrors.some(e => e.includes('titre'))}"
    class="w-full px-4 py-3 rounded-xl border border-gray-200 focus:border-[#ea580c] outline-none transition-all"
  />
</div>
        <div class="edit-pfp-container">
      <h1 style="font-weight: bold;">Ajouter une photo a l'annonce</h1>
  <div class="bg-white rounded-3xl p-6 shadow-sm border border-gray-100">
    <h2 class="font-bold mb-4">Photos de l'annonce ({{ photosLocal.length }})</h2>

    <div v-if="photosLocal.length > 0" class="grid grid-cols-3 gap-4 mb-6">
  <div v-for="(photo, index) in photosLocal" :key="index" class="relative group">
    <img :src="photo.previewUrl" class="w-full h-24 object-cover rounded-xl border" />
<button 
  type="button"
  @click="removePhoto(index)"
  class="absolute -top-2 -right-2 bg-red-500 text-white rounded-full w-6 h-6 flex items-center justify-center shadow-lg hover:bg-red-600 text-xs font-bold"
>
  ✕
</button>
  </div>
</div>
</div>
    <div v-if="imageSource" class="mb-4">
      <div class="cropper-wrapper">
        <cropper
          ref="cropperRef"
          class="cropper"
          :src="imageSource"
          :stencil-props="{ aspectRatio: 1.5 }" 
        />
      </div>
      <button 
        type="button"
        @click="addPhotoToList" 
        :disabled="isUploading"
        class="mt-2 w-full bg-green-600 text-white py-2 rounded-xl font-bold"
      >
        {{ isUploading ? 'Chargement...' : 'Valider et ajouter cette photo' }}
      </button>
    </div>

    <label v-if="!imageSource" class="cursor-pointer block border-2 border-dashed border-gray-200 p-8 rounded-2xl text-center hover:bg-gray-50 transition-all">
      <span class="text-gray-500 font-medium">+ Ajouter une photo</span>
      <input type="file" @change="onFileChange" accept="image/*" hidden />
    </label>
  </div>
        <div class="bg-white rounded-3xl p-6 shadow-sm border border-gray-100">
  <label class="block text-sm font-bold mb-2">Type d'hébergement</label>
  <select 
    v-model="form.idtypehebergement"
    class="w-full px-4 py-3 rounded-xl border border-gray-200 focus:border-[#ea580c] outline-none bg-white transition-all"
  >
    <option v-for="type in typesHebergement" :key="type.id" :value="type.id">
      {{ type.nom }}
    </option>
  </select>
</div>
<div class="bg-white rounded-3xl p-6 shadow-sm border border-gray-100 space-y-4">
  <h2 class="font-bold text-lg mb-2">Localisation du bien</h2>
  <div class="relative">
    <label class="block text-sm font-bold mb-2">Rue et numéro</label>
    <input 
      v-model="form.rue" 
      @input="fetchAutocomplete"
      type="text" 
      placeholder="Commencez à taper votre adresse..." 
      class="w-full px-4 py-3 rounded-xl border border-gray-200 outline-none focus:border-[#ea580c]" 
    />

    <ul v-if="showSuggestions && suggestions.length" class="absolute z-50 w-full bg-white border border-gray-200 rounded-xl mt-1 shadow-xl max-h-60 overflow-auto">
      <li 
        v-for="(s, index) in suggestions" 
        :key="index"
        @click="selectSuggestion(s)"
        class="px-4 py-3 hover:bg-orange-50 cursor-pointer border-b last:border-b-0 text-sm"
      >
        <span class="font-bold">{{ s.properties.formatted }}</span>
      </li>
    </ul>
  </div>

  <div class="grid grid-cols-2 gap-4">
    <div>
      <label class="block text-sm font-bold mb-2">Code Postal</label>
      <input v-model="form.codePostal" type="text" placeholder="75001" class="w-full px-4 py-3 rounded-xl border border-gray-200 outline-none" />
    </div>
    <div>
      <label class="block text-sm font-bold mb-2">Ville</label>
      <input v-model="form.ville" type="text" placeholder="Paris" class="w-full px-4 py-3 rounded-xl border border-gray-200 outline-none" />
    </div>
  </div>
</div>
<div class="bg-white rounded-3xl p-6 shadow-sm border border-gray-100 flex gap-8">
  <label class="flex items-center space-x-3 cursor-pointer">
    <input 
      type="checkbox" 
      v-model="form.possibiliteanimaux" 
      class="w-5 h-5 accent-[#ea580c]"
    />
    <span class="text-sm font-bold text-gray-700">Animaux acceptés</span>
  </label>

  <label class="flex items-center space-x-3 cursor-pointer">
    <input 
      type="checkbox" 
      v-model="form.possibilitefumeur" 
      class="w-5 h-5 accent-[#ea580c]"
    />
    <span class="text-sm font-bold text-gray-700">Fumeurs acceptés</span>
  </label>
</div><div class="bg-white rounded-3xl p-6 shadow-sm border border-gray-100 grid grid-cols-2 md:grid-cols-4 gap-4">
  <div>
    <label class="block text-sm font-bold mb-2">Prix / nuit (€)</label>
    <input v-model.number="form.prixnuitee" type="number" min="1" class="w-full px-4 py-3 rounded-xl border border-gray-200 focus:border-[#ea580c] outline-none" />
  </div>
  <div>
    <label class="block text-sm font-bold mb-2">Voyageurs max</label>
    <input v-model.number="form.nombrepersonnesmax" type="number" min="1" class="w-full px-4 py-3 rounded-xl border border-gray-200 focus:border-[#ea580c] outline-none" />
  </div>
  <div>
    <label class="block text-sm font-bold mb-2">Chambres</label>
    <input v-model.number="form.nbchambres" type="number" min="1" class="w-full px-4 py-3 rounded-xl border border-gray-200 focus:border-[#ea580c] outline-none" />
  </div>
  <div>
    <label class="block text-sm font-bold mb-2">Bébés max</label>
    <input v-model.number="form.nombrebebesmax" type="number" min="0" class="w-full px-4 py-3 rounded-xl border border-gray-200 focus:border-[#ea580c] outline-none" />
  </div>
  
</div>
<div class="bg-white rounded-3xl p-6 shadow-sm border border-gray-100 grid grid-cols-1 md:grid-cols-2 gap-6">
  <div>
    <label class="block text-sm font-bold mb-2">Séjour minimum</label>
    <input v-model.number="form.minimumnuitee" type="number" min="1" class="w-full px-4 py-3 rounded-xl border border-gray-200 focus:border-[#ea580c] outline-none" />
  </div>

  <div>
    <label class="block text-sm font-bold mb-2">Acompte</label>
    <div class="flex items-center bg-gray-50 rounded-xl p-1 border border-gray-200">
<input 
  v-model.number="form.acompte" 
  type="number" 
  min="0" 
  :max="form.isAcomptePercentage ? 100 : undefined"
  class="flex-1 bg-transparent px-3 py-2 outline-none font-bold"
  :placeholder="form.isAcomptePercentage ? 'Ex: 30%' : 'Ex: 50€'"
/>
      <button 
        type="button"
        @click="form.isAcomptePercentage = true"
        :class="form.isAcomptePercentage ? 'bg-white shadow-sm text-[#ea580c]' : 'text-gray-400'"
        class="px-4 py-2 rounded-lg font-bold transition-all"
      >%</button>
      <button 
        type="button"
        @click="form.isAcomptePercentage = false"
        :class="!form.isAcomptePercentage ? 'bg-white shadow-sm text-[#ea580c]' : 'text-gray-400'"
        class="px-4 py-2 rounded-lg font-bold transition-all"
      >€</button>
    </div>
  </div>
</div>
<div class="bg-white rounded-3xl p-6 shadow-sm border border-gray-100 grid grid-cols-1 md:grid-cols-2 gap-6">
  <div>
    <label class="block text-sm font-bold mb-2">Heure d'arrivée (à partir de)</label>
<select 
  v-model="form.idheurearrivee"
  class="w-full px-4 py-3 rounded-xl border border-gray-200 focus:border-[#ea580c] outline-none bg-white transition-all"
>
  <option v-for="h in 48" :key="h" :value="h">
    {{ Math.floor((h - 1) / 2).toString().padStart(2, '0') }}:{{ (h % 2 === 0) ? '30' : '00' }}
  </option>
</select>
  </div>

  <div>
    <label class="max-w-5xl mx-auto px-4">Heure de départ (avant)</label>
<select 
  v-model="form.idheuredepart"
  class="w-full px-4 py-3 rounded-xl border border-gray-200 focus:border-[#ea580c] outline-none bg-white transition-all"
>
  <option v-for="h in 48" :key="h" :value="h">
    {{ Math.floor((h - 1) / 2).toString().padStart(2, '0') }}:{{ (h % 2 === 0) ? '30' : '00' }}
  </option>
</select>
  </div>
</div>
<div class="bg-white rounded-3xl p-6 shadow-sm border border-gray-100">
  <div class="flex items-center justify-between mb-6">
    <h2 class="font-bold text-lg text-gray-900">Équipements et services</h2>
    <span class="text-xs font-bold text-orange-600 bg-orange-50 px-2 py-1 rounded-lg">
      {{ selectedCommodites.length }} sélectionné(s)
    </span>
  </div>

  <div class="flex flex-wrap gap-2 border-b border-gray-100 pb-4 mb-6">
    <button 
      v-for="(items, catName) in groupedCommodites" 
      :key="catName"
      type="button"
      @click="activeTab = catName"
      :class="[
        'px-4 py-2 rounded-xl text-xs font-black transition-all',
        activeTab === catName 
          ? 'bg-[#ea580c] text-white shadow-md' 
          : 'bg-gray-50 text-gray-500 hover:bg-gray-100'
      ]"
    >
      {{ catName }}
    </button>
  </div>

  <div v-if="activeTab" class="grid grid-cols-2 md:grid-cols-4 gap-3">
    <label 
      v-for="item in groupedCommodites[activeTab]" 
      :key="item.idcommodite" 
      :class="[
        'flex items-center p-3 rounded-2xl border transition-all cursor-pointer group',
        selectedCommodites.includes(item.idcommodite) 
          ? 'border-orange-200 bg-orange-50 ring-1 ring-orange-200' 
          : 'border-gray-50 hover:border-gray-100 hover:bg-gray-100'
      ]"
    >
      <input 
        type="checkbox" 
        :value="item.idcommodite" 
        v-model="selectedCommodites"
        class="h-4 w-4 accent-[#ea580c] rounded"
      />
      <span class="ml-3 text-xs font-bold text-gray-700 truncate group-hover:text-gray-900">
        {{ item.nomcommodite }}
      </span>
    </label>
  </div>
</div>
        <div class="bg-white rounded-3xl p-6 shadow-sm border border-gray-100">
          <label class="block text-sm font-bold mb-4">Description</label>
          <textarea
            v-model="form.descriptionannonce"
            rows="5"
            class="w-full px-4 py-3 rounded-xl border border-gray-200 focus:border-[#ea580c] outline-none resize-none transition-all"
            placeholder="Décrivez votre bien..."
          ></textarea>
        </div>

<button
  type="submit"
  :disabled="isPublishing"
  class="w-full bg-[#ea580c] text-white font-black py-5 rounded-2xl shadow-lg shadow-orange-100 hover:bg-[#c2410c] transition-all disabled:opacity-50 disabled:cursor-not-allowed flex items-center justify-center gap-3"
>
  <template v-if="isPublishing">
    <svg class="animate-spin h-5 w-5 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
      <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
      <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
    </svg>
    Traitement des images et publication...
  </template>
  <template v-else>
    Publier mon annonce
  </template>
</button>
      </form>
    </div>
  </div>
</template>

<style scoped>
@keyframes pulse {
  0%, 100% { opacity: 1; }
  50% { opacity: 0.5; }
}
.animate-pulse {
  animation: pulse 2s infinite;
}

  .edit-pfp-container {
    max-width: 400px;
    margin: 10px auto;
    text-align: center;
    padding: 20px;
  }
  
:deep(.vue-circle-stencil) {
  border: 2px solid #ea580c; 
}
  
  .cropper-wrapper {
    width: 100%;
    height: 250px;
    background: #ddd;
    border-radius: 12px;
    overflow: hidden;
    margin-bottom: 10px;
  }
  
  .cropper {
    width: 100%;
    height: 100%;
  }
  
  .controls {
    display: flex;
    gap: 15px;
    justify-content: center;
  }
  
  .upload-btn, .save-btn {
    padding: 12px 24px;
    border-radius: 8px;
    font-weight: bold;
    cursor: pointer;
    transition: 0.2s;
  }
  
  .upload-btn {
    background: #f3f4f6;
    color: #374151;
  }
  
  .save-btn {
    background: #ea580c;
    color: white;
    border: none;
  }
  
  .save-btn:disabled {
    opacity: 0.5;
    cursor: not-allowed;
  }
  
</style>