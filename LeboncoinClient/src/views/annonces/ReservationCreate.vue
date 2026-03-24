<template>
  <div class="bg-white min-h-screen pt-32 pb-12">
    <div class="max-w-6xl mx-auto px-6 md:px-12 xl:px-6">
      <h1 class="text-3xl font-bold text-slate-900 mb-8">Votre réservation</h1>

      <form @submit.prevent="submitReservation" class="grid grid-cols-1 lg:grid-cols-3 gap-12">
        
        <div class="lg:col-span-2 space-y-10">
          
          <section>
            <h2 class="text-xl font-bold text-slate-900 mb-4">Vos dates de séjour</h2>
            <div class="grid grid-cols-2 gap-8 border-b border-gray-200 pb-8">
              <div>
                <span class="block text-sm font-bold text-slate-700">Arrivée</span>
                <span class="text-lg text-slate-900">{{ formatDate(startDate) }}</span>
              </div>
              <div>
                <span class="block text-sm font-bold text-slate-700">Départ</span>
                <span class="text-lg text-slate-900">{{ formatDate(endDate) }}</span>
              </div>
            </div>
            <div v-if="nbNuits <= 0" class="mt-4 p-4 bg-red-50 text-red-700 rounded-lg text-sm">
              Attention : Les dates semblent manquantes ou incorrectes. Veuillez retourner sur l'annonce pour sélectionner vos dates.
            </div>
          </section>

          <section class="border-b border-gray-200 pb-8">
            <h2 class="text-xl font-bold text-slate-900 mb-6">Nombre de voyageurs</h2>
            
            <div class="flex justify-between items-center mb-4">
              <div>
                <div class="font-medium text-slate-900">Adultes</div>
                <div class="text-sm text-slate-500">18 ans et plus</div>
              </div>
              <div class="flex items-center gap-3">
                <button type="button" @click="guests.adults--" :disabled="guests.adults <= 1" class="w-8 h-8 rounded-full border border-gray-300 flex items-center justify-center disabled:opacity-50 disabled:cursor-not-allowed hover:border-slate-800 hover:text-slate-800">-</button>
                <span class="w-4 text-center font-medium">{{ guests.adults }}</span>
                <button type="button" @click="guests.adults++" :disabled="totalGuests >= maxCapacity" class="w-8 h-8 rounded-full border border-gray-300 flex items-center justify-center disabled:opacity-50 disabled:cursor-not-allowed hover:border-slate-800 hover:text-slate-800">+</button>
              </div>
            </div>

            <div class="flex justify-between items-center mb-4">
              <div>
                <div class="font-medium text-slate-900">Enfants</div>
                <div class="text-sm text-slate-500">De 2 à 17 ans</div>
              </div>
              <div class="flex items-center gap-3">
                <button type="button" @click="guests.children--" :disabled="guests.children <= 0" class="w-8 h-8 rounded-full border border-gray-300 flex items-center justify-center disabled:opacity-50 disabled:cursor-not-allowed hover:border-slate-800 hover:text-slate-800">-</button>
                <span class="w-4 text-center font-medium">{{ guests.children }}</span>
                <button type="button" @click="guests.children++" :disabled="totalGuests >= maxCapacity" class="w-8 h-8 rounded-full border border-gray-300 flex items-center justify-center disabled:opacity-50 disabled:cursor-not-allowed hover:border-slate-800 hover:text-slate-800">+</button>
              </div>
            </div>

            <div class="flex justify-between items-center mb-4">
              <div>
                <div class="font-medium text-slate-900">Bébés</div>
                <div class="text-sm text-slate-500">Moins de 3 ans</div>
              </div>
              <div class="flex items-center gap-3">
                <button type="button" @click="guests.babies--" :disabled="guests.babies <= 0" class="w-8 h-8 rounded-full border border-gray-300 flex items-center justify-center disabled:opacity-50 disabled:cursor-not-allowed hover:border-slate-800 hover:text-slate-800">-</button>
                <span class="w-4 text-center font-medium">{{ guests.babies }}</span>
                <button type="button" @click="guests.babies++" :disabled="guests.babies >= maxBabies" class="w-8 h-8 rounded-full border border-gray-300 flex items-center justify-center disabled:opacity-50 disabled:cursor-not-allowed hover:border-slate-800 hover:text-slate-800">+</button>
              </div>
            </div>

            <div class="flex justify-between items-center mb-4">
              <div>
                <div class="font-medium text-slate-900">Animaux</div>
                <div class="text-sm flex items-center gap-1" :class="acceptsPets ? 'text-slate-500' : 'text-red-500 font-medium'">
                  {{ acceptsPets ? 'Animaux de compagnie' : 'Non acceptés' }}
                </div>
              </div>
              <div class="flex items-center gap-3">
                <button type="button" @click="guests.pets--" :disabled="guests.pets <= 0 || !acceptsPets" class="w-8 h-8 rounded-full border border-gray-300 flex items-center justify-center disabled:opacity-50 disabled:cursor-not-allowed hover:border-slate-800 hover:text-slate-800">-</button>
                <span class="w-4 text-center font-medium" :class="!acceptsPets ? 'text-gray-400' : ''">{{ guests.pets }}</span>
                <button type="button" @click="guests.pets++" :disabled="!acceptsPets" class="w-8 h-8 rounded-full border border-gray-300 flex items-center justify-center disabled:opacity-50 disabled:cursor-not-allowed hover:border-slate-800 hover:text-slate-800">+</button>
              </div>
            </div>

            <p class="text-xs text-gray-500 mt-2">
              Capacité maximale : <span class="font-bold">{{ maxCapacity }}</span> personnes | Maximum <span class="font-bold">{{ maxBabies }}</span> bébés | Au moins 1 adulte requis
            </p>
          </section>

          <section class="border-b border-gray-200 pb-8">
            <h2 class="text-xl font-bold text-slate-900 mb-6">Vos informations</h2>
            <p class="text-xs text-gray-500 mb-4">* Champs obligatoires</p>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
              <div>
                <label class="block text-sm font-medium text-slate-700 mb-1">Prénom *</label>
                <input v-model="form.prenom" type="text" required class="w-full border-gray-300 rounded-lg shadow-sm focus:border-orange-500 focus:ring-orange-500 h-12">
              </div>
              <div>
                <label class="block text-sm font-medium text-slate-700 mb-1">Nom *</label>
                <input v-model="form.nom" type="text" required class="w-full border-gray-300 rounded-lg shadow-sm focus:border-orange-500 focus:ring-orange-500 h-12">
              </div>
            </div>
            
            <div class="mb-2">
              <label class="block text-sm font-medium text-slate-700 mb-1">Numéro de téléphone</label>
              <input v-model="form.telephone" type="text" placeholder="06 12 34 56 78" maxlength="10" class="w-full border-gray-300 rounded-lg shadow-sm focus:border-orange-500 focus:ring-orange-500 h-12">
            </div>
            <p class="text-xs text-gray-500">Votre numéro de téléphone sera partagé à l'hôte une fois votre demande de réservation acceptée</p>
          </section>

          <section class="bg-gray-50 p-6 rounded-xl">
            <div class="flex items-start gap-3 mb-6">
              <input v-model="form.cgv" id="cgv" type="checkbox" required class="mt-1 w-5 h-5 text-orange-600 border-gray-300 rounded focus:ring-orange-500">
              <label for="cgv" class="text-sm text-slate-600">
                En validant, j'accepte les <a href="#" class="underline font-bold text-slate-900">conditions d'utilisation</a> et les <a href="#" class="underline font-bold text-slate-900">CGV</a>, et certifie que mes prénoms et mon nom sont conformes à ceux de mon état civil.
              </label>
            </div>
            
            <button type="submit" :disabled="isSubmitting || nbNuits <= 0" class="w-full sm:w-auto bg-[#f56b2a] hover:bg-[#e05a1a] text-white font-bold py-3 px-8 rounded-full transition shadow-md text-lg disabled:opacity-50 disabled:cursor-not-allowed">
              {{ isSubmitting ? 'Traitement en cours...' : 'Payer et valider ma réservation' }}
            </button>
          </section>
        </div>

        <div class="lg:col-span-1">
          <div class="sticky top-24 p-6 bg-white rounded-lg shadow-lg border border-gray-100">
            <h3 class="font-bold text-lg text-slate-900 mb-6">Récapitulatif du paiement</h3>
            
            <div class="space-y-4 text-sm text-slate-600">
              <div class="flex justify-between">
                <span>Montant de la location</span>
                <span>{{ formatPrice(totalRent) }} €</span>
              </div>
              <div class="flex justify-between">
                <span>Frais de service</span>
                <span>{{ formatPrice(serviceFee) }} €</span>
              </div>
              <div class="flex justify-between">
                <span>Taxe de séjour</span>
                <span>{{ formatPrice(touristTax) }} €</span>
              </div>
            </div>
            
            <hr class="border-gray-200 my-6">
            
            <div class="flex justify-between items-center font-bold text-lg text-slate-900 mb-6">
              <span>Total</span>
              <span>{{ formatPrice(total) }} €</span>
            </div>
            
            <div class="space-y-4">
              <div class="flex justify-between items-center text-[#EA580C] font-bold">
                <span>À payer maintenant</span>
                <span>{{ formatPrice(payNow) }} €</span>
              </div>
              <div class="flex justify-between items-center text-slate-600">
                <span>Restera à payer sur place</span>
                <span>{{ formatPrice(total - payNow) }} €</span>
              </div>
            </div>
          </div>
        </div>
        
      </form>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import axios from 'axios';

const route = useRoute();
const router = useRouter();

const annonceId = route.params.id;
const pricePerNight = ref(0); 
const maxCapacity = ref(2);
const maxBabies = ref(0);
const acceptsPets = ref(false);

const startDate = ref(route.query.start || '');
const endDate = ref(route.query.end || '');

const form = ref({
  nom: '', 
  prenom: '',
  telephone: '',
  cgv: false
});

const guests = ref({
  adults: 1,
  children: 0,
  babies: 0,
  pets: 0
});

const isSubmitting = ref(false);

onMounted(async () => {
  try {
    const response = await axios.get(`/api/annonces/${annonceId}`);
    const annonce = response.data;
    
    pricePerNight.value = annonce.prixnuitee;
    maxCapacity.value = annonce.capacite;
    maxBabies.value = annonce.nombrebebesmax;
    acceptsPets.value = annonce.possibiliteanimaux;
  } catch (e) {
    console.error("Erreur au chargement de l'annonce", e);
  }
});

const nbNuits = computed(() => {
  if (!startDate.value || !endDate.value) return 0;
  const start = new Date(startDate.value);
  const end = new Date(endDate.value);
  const diffTime = end - start;
  return diffTime > 0 ? Math.ceil(diffTime / (1000 * 60 * 60 * 24)) : 0;
});

const totalGuests = computed(() => guests.value.adults + guests.value.children);

const totalRent = computed(() => pricePerNight.value * (nbNuits.value > 0 ? nbNuits.value : 1));
const serviceFee = computed(() => totalRent.value * 0.14);
const touristTax = computed(() => 4.00 * nbNuits.value * guests.value.adults);
const total = computed(() => totalRent.value + serviceFee.value + touristTax.value);
const payNow = computed(() => serviceFee.value + (totalRent.value * 0.35) + touristTax.value);

const formatPrice = (value) => value.toFixed(2).replace('.', ',').replace(/\B(?=(\d{3})+(?!\d))/g, ' ');
const formatDate = (dateString) => {
  if (!dateString) return '-';
  return new Date(dateString).toLocaleDateString('fr-FR');
};

const submitReservation = async () => {
  if (nbNuits.value <= 0 || !form.value.cgv) return;
  isSubmitting.value = true;

  try {
    const voyageursInclures = [];
    
    if (guests.value.adults > 0) {
      voyageursInclures.push({ idtypevoyageur: 1, nombrevoyageur: guests.value.adults });
    }
    if (guests.value.children > 0) {
      voyageursInclures.push({ idtypevoyageur: 2, nombrevoyageur: guests.value.children });
    }
    if (guests.value.babies > 0) {
      voyageursInclures.push({ idtypevoyageur: 3, nombrevoyageur: guests.value.babies });
    }
    if (guests.value.pets > 0) {
      voyageursInclures.push({ idtypevoyageur: 4, nombrevoyageur: guests.value.pets });
    }

    const payload = {
      idannonce: parseInt(annonceId),
      idutilisateur: 1,
      dateDebut: startDate.value,
      dateFin: endDate.value,
      nomclient: form.value.nom,
      prenomclient: form.value.prenom,
      telephoneclient: form.value.telephone,
      inclures: voyageursInclures
    };

    await axios.post('/api/reservations', payload);
    
    alert("Réservation réussie !");
    router.push('/');
    
  } catch (error) {
    console.error("Erreur lors de la réservation:", error);
    alert("Une erreur est survenue lors de la création de votre réservation.");
  } finally {
    isSubmitting.value = false;
  }
};
</script>