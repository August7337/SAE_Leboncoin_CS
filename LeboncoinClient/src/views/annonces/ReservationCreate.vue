<template>
  <div>
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
            </section>

            <section>
              <div class="mb-4">
                <h2 class="text-xl font-bold text-slate-900">Vos informations</h2>
                <p class="text-sm text-slate-500 mt-1">
                  Ces informations seront partagées à l'hôte une fois votre demande de réservation acceptée.
                </p>
              </div>

              <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
                <div>
                  <label class="block text-sm font-medium text-slate-700 mb-1">Prénom *</label>
                  <input v-model="form.prenom" type="text" required
                         class="w-full border-gray-300 rounded-lg shadow-sm focus:border-orange-500 focus:ring-orange-500 h-12 px-4">
                </div>
                <div>
                  <label class="block text-sm font-medium text-slate-700 mb-1">Nom *</label>
                  <input v-model="form.nom" type="text" required
                         class="w-full border-gray-300 rounded-lg shadow-sm focus:border-orange-500 focus:ring-orange-500 h-12 px-4">
                </div>
              </div>

              <div class="mb-2">
                <label class="block text-sm font-medium text-slate-700 mb-1">Numéro de téléphone *</label>
                <input
                  v-model="form.telephone"
                  type="tel"
                  inputmode="numeric"
                  placeholder="06 12 34 56 78"
                  maxlength="14"
                  required
                  @input="formatTelephone"
                  class="w-full border-gray-300 rounded-lg shadow-sm focus:border-orange-500 focus:ring-orange-500 h-12 px-4"
                >
              </div>
            </section>

            <section>
              <h2 class="text-xl font-bold text-slate-900 mb-4">Voyageurs</h2>
              <div class="space-y-6">

                <div class="flex items-center justify-between py-2 border-b border-gray-50">
                  <div>
                    <div class="font-bold text-slate-900">Adultes</div>
                    <div class="text-sm text-slate-500">13 ans et plus</div>
                  </div>
                  <div class="flex items-center gap-4">
                    <button type="button" @click="guests.adults > 1 && guests.adults--"
                            class="w-10 h-10 rounded-full border border-gray-300 flex items-center justify-center hover:border-slate-900 disabled:opacity-30"
                            :disabled="guests.adults <= 1">-</button>
                    <span class="w-4 text-center font-medium">{{ guests.adults }}</span>
                    <button type="button" @click="totalGuests < maxCapacity && guests.adults++"
                            class="w-10 h-10 rounded-full border border-gray-300 flex items-center justify-center hover:border-slate-900 disabled:opacity-30"
                            :disabled="totalGuests >= maxCapacity">+</button>
                  </div>
                </div>

                <div class="flex items-center justify-between py-2 border-b border-gray-50">
                  <div>
                    <div class="font-bold text-slate-900">Enfants</div>
                    <div class="text-sm text-slate-500">De 2 à 12 ans</div>
                  </div>
                  <div class="flex items-center gap-4">
                    <button type="button" @click="guests.children > 0 && guests.children--"
                            class="w-10 h-10 rounded-full border border-gray-300 flex items-center justify-center hover:border-slate-900 disabled:opacity-30"
                            :disabled="guests.children <= 0">-</button>
                    <span class="w-4 text-center font-medium">{{ guests.children }}</span>
                    <button type="button" @click="totalGuests < maxCapacity && guests.children++"
                            class="w-10 h-10 rounded-full border border-gray-300 flex items-center justify-center hover:border-slate-900 disabled:opacity-30"
                            :disabled="totalGuests >= maxCapacity">+</button>
                  </div>
                </div>

                <div class="flex items-center justify-between py-2 border-b border-gray-50">
                  <div>
                    <div class="font-bold text-slate-900">Bébés</div>
                    <div class="text-sm text-slate-500">- de 2 ans</div>
                  </div>
                  <div class="flex items-center gap-4">
                    <button type="button" @click="guests.babies > 0 && guests.babies--"
                            class="w-10 h-10 rounded-full border border-gray-300 flex items-center justify-center hover:border-slate-900 disabled:opacity-30"
                            :disabled="guests.babies <= 0">-</button>
                    <span class="w-4 text-center font-medium">{{ guests.babies }}</span>
                    <button type="button" @click="guests.babies < maxBabies && guests.babies++"
                            class="w-10 h-10 rounded-full border border-gray-300 flex items-center justify-center hover:border-slate-900 disabled:opacity-30"
                            :disabled="guests.babies >= maxBabies">+</button>
                  </div>
                </div>

                <div v-if="acceptsPets" class="flex items-center justify-between py-2">
                  <div>
                    <div class="font-bold text-slate-900">Animaux</div>
                    <div class="text-sm text-slate-500">Animaux d'assistance acceptés</div>
                  </div>
                  <div class="flex items-center gap-4">
                    <button type="button" @click="guests.pets > 0 && guests.pets--"
                            class="w-10 h-10 rounded-full border border-gray-300 flex items-center justify-center hover:border-slate-900 disabled:opacity-30"
                            :disabled="guests.pets <= 0">-</button>
                    <span class="w-4 text-center font-medium">{{ guests.pets }}</span>
                    <button type="button" @click="guests.pets < MAX_PETS && guests.pets++"
                            class="w-10 h-10 rounded-full border border-gray-300 flex items-center justify-center hover:border-slate-900 disabled:opacity-30"
                            :disabled="guests.pets >= MAX_PETS">+</button>
                  </div>
                </div>

              </div>
            </section>
          </div>

          <div class="lg:col-span-1">
            <div class="sticky top-32 bg-white border border-gray-200 rounded-2xl p-6 shadow-sm">
              <h2 class="text-xl font-bold text-slate-900 mb-6">Détails du prix</h2>

              <div class="space-y-4 mb-6">
                <div class="flex justify-between text-slate-600">
                  <span>{{ formatPrice(pricePerNight) }} € x {{ nbNuits }} nuits</span>
                  <span>{{ formatPrice(totalRent) }} €</span>
                </div>
                <div class="flex justify-between text-slate-600">
                  <span>Frais de service leboncoin</span>
                  <span>{{ formatPrice(serviceFee) }} €</span>
                </div>
                <div class="flex justify-between text-slate-600">
                  <span>Taxes de séjour</span>
                  <span>{{ formatPrice(touristTax) }} €</span>
                </div>
              </div>

              <div class="pt-6 border-t border-gray-200 space-y-4">
                <div class="flex justify-between font-bold text-lg text-slate-900">
                  <span>Total (EUR)</span>
                  <span>{{ formatPrice(total) }} €</span>
                </div>

                <div class="bg-slate-50 p-4 rounded-xl">
                  <div class="flex justify-between font-bold text-slate-900">
                    <span>À payer maintenant</span>
                    <span>{{ formatPrice(payNow) }} €</span>
                  </div>
                  <p class="text-xs text-slate-500 mt-2">
                    L'acompte de 35% du loyer + frais de service et taxes de séjour.
                  </p>
                  <div class="mt-3 pt-3 border-t border-gray-200 flex justify-between text-sm text-slate-600">
                    <span>À payer sur place</span>
                    <span>{{ formatPrice(payOnSite) }} €</span>
                  </div>
                </div>
              </div>

              <div v-if="authState.user?.solde > 0" class="mt-6 p-4 bg-orange-50 border border-orange-200 rounded-xl">
                <div class="flex gap-3">
                  <svg class="w-5 h-5 text-orange-500 flex-shrink-0 mt-0.5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                          d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
                  </svg>
                  <p class="text-xs text-orange-800 leading-tight">
                    <span class="font-bold">Attention :</span> Vous êtes sur le point d'être débité par l'intermédiaire de votre solde leboncoin (tout ou partie du montant).
                  </p>
                </div>
              </div>

              <div class="mt-6 space-y-4">
                <label class="flex items-start gap-3 cursor-pointer">
                    <input v-model="form.cgv" type="checkbox" required class="mt-1 rounded border-gray-300 text-orange-600 focus:ring-orange-500">
                    <span class="text-xs text-slate-500 mt-0.5">
                        En cochant ce bouton, j'accepte les 
                        <router-link to="/cgv" target="_blank" class="font-bold underline hover:text-orange-600 transition-colors">
                        Conditions générales de vente
                        </router-link>.
                    </span>
                </label>

                <button
                  type="submit"
                  :disabled="isSubmitting || !form.cgv || nbNuits <= 0"
                  class="w-full bg-orange-600 text-white font-bold py-4 rounded-xl hover:bg-orange-700 transition-colors disabled:opacity-50 disabled:cursor-not-allowed shadow-lg shadow-orange-200"
                >
                  {{ isSubmitting ? 'Redirection...' : 'Confirmer et payer' }}
                </button>
              </div>
            </div>
          </div>

        </form>
      </div>
    </div>

    <!-- Modale de confirmation paiement par solde -->
    <Transition name="modal">
      <div v-if="showSoldeModal" class="fixed inset-0 z-50 flex items-center justify-center p-4">
        <div class="absolute inset-0 bg-slate-900/50 backdrop-blur-sm" @click="onModalCancel"></div>

        <div class="relative bg-white rounded-2xl shadow-2xl w-full max-w-md overflow-hidden">

          <div class="bg-orange-500 px-6 pt-6 pb-8">
            <div class="flex items-center gap-3 mb-1">
              <div class="w-10 h-10 rounded-full bg-white/20 flex items-center justify-center flex-shrink-0">
                <svg class="w-5 h-5 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                        d="M3 10h18M7 15h1m4 0h1m-7 4h12a3 3 0 003-3V8a3 3 0 00-3-3H6a3 3 0 00-3 3v8a3 3 0 003 3z" />
                </svg>
              </div>
              <h3 class="text-white font-bold text-lg leading-tight">Confirmation du paiement</h3>
            </div>
            <p class="text-orange-100 text-sm mt-2 leading-relaxed">
              Votre solde leboncoin va être utilisé pour cette réservation.
            </p>
          </div>

          <div class="-mt-4 mx-4 bg-white rounded-xl border border-gray-100 shadow-sm p-4 space-y-3">
            <div class="flex justify-between items-center text-sm">
              <span class="text-slate-500">Acompte à régler</span>
              <span class="font-bold text-slate-900">{{ formatPrice(payNow) }} €</span>
            </div>
            <div class="flex justify-between items-center text-sm">
              <span class="text-slate-500">Votre solde disponible</span>
              <span class="font-semibold text-orange-600">{{ formatPrice(authState.user?.solde || 0) }} €</span>
            </div>
            <div class="border-t border-dashed border-gray-200 pt-3 flex justify-between items-center text-sm">
              <span class="text-slate-500">Débité de votre solde</span>
              <span class="font-bold text-slate-900">{{ formatPrice(modalSoldeUsed) }} €</span>
            </div>
            <div v-if="modalRemainder > 0" class="flex justify-between items-center text-sm">
              <span class="text-slate-500">Reste à payer par carte</span>
              <span class="font-bold text-slate-900">{{ formatPrice(modalRemainder) }} €</span>
            </div>
          </div>

          <div class="px-4 pt-3 pb-2">
            <div v-if="modalRemainder === 0" class="flex items-center gap-2 bg-green-50 border border-green-100 rounded-lg px-3 py-2">
              <svg class="w-4 h-4 text-green-500 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
              </svg>
              <p class="text-xs text-green-800">Votre solde couvre la totalité de l'acompte. Aucune carte requise.</p>
            </div>
            <div v-else class="flex items-center gap-2 bg-blue-50 border border-blue-100 rounded-lg px-3 py-2">
              <svg class="w-4 h-4 text-blue-500 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                      d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
              </svg>
              <p class="text-xs text-blue-800">Votre solde est insuffisant. Vous serez redirigé vers le paiement par carte pour le reste.</p>
            </div>
          </div>

          <div class="flex gap-3 px-4 pt-2 pb-5">
            <button
              type="button"
              @click="onModalCancel"
              class="flex-1 py-3 rounded-xl border border-gray-200 text-sm font-semibold text-slate-700 hover:bg-slate-50 transition-colors"
            >
              Annuler
            </button>
            <button
              type="button"
              @click="onModalConfirm"
              class="flex-1 py-3 rounded-xl bg-orange-500 hover:bg-orange-600 text-white text-sm font-bold transition-colors shadow-md shadow-orange-200"
            >
              Confirmer le paiement
            </button>
          </div>

        </div>
      </div>
    </Transition>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import axios from 'axios';
import { authState } from '@/auth.js';

const route = useRoute();
const router = useRouter();

const annonceId = route.params.id;
const pricePerNight = ref(0);
const maxCapacity = ref(2);
const maxBabies = ref(0);
const acceptsPets = ref(false);
const MAX_PETS = 10;

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
const showSoldeModal = ref(false);
let resolveModal = null;

const modalSoldeUsed = computed(() => Math.min(authState.user?.solde || 0, payNow.value));
const modalRemainder = computed(() => Math.max(0, payNow.value - (authState.user?.solde || 0)));

function openSoldeModal() {
  showSoldeModal.value = true;
  return new Promise((resolve) => { resolveModal = resolve; });
}

function onModalConfirm() {
  showSoldeModal.value = false;
  if (resolveModal) resolveModal(true);
}

function onModalCancel() {
  showSoldeModal.value = false;
  if (resolveModal) resolveModal(false);
}

function formatTelephone(event) {
  const input = event.target;
  const cursorPos = input.selectionStart;
  const digits = input.value.replace(/\D/g, '').substring(0, 10);

  let formatted = '';
  for (let i = 0; i < digits.length; i++) {
    if (i > 0 && i % 2 === 0) formatted += ' ';
    formatted += digits[i];
  }

  form.value.telephone = formatted;
  adjustCursor(input, cursorPos, input.value, formatted);
}

function adjustCursor(input, oldCursor, oldValue, newValue) {
  const digitsBeforeCursor = oldValue.substring(0, oldCursor).replace(/\D/g, '').length;
  let newCursor = 0;
  let count = 0;
  for (let i = 0; i < newValue.length; i++) {
    if (newValue[i] !== ' ') count++;
    if (count === digitsBeforeCursor) { newCursor = i + 1; break; }
    newCursor = i + 1;
  }
  requestAnimationFrame(() => {
    input.setSelectionRange(newCursor, newCursor);
  });
}

onMounted(async () => {
  await authState.refreshUser?.();
  try {
    const response = await axios.get(`/api/annonces/${annonceId}`);
    const annonce = response.data;

    pricePerNight.value = annonce.prixnuitee;
    maxCapacity.value = annonce.capacite;
    maxBabies.value = annonce.nombrebebesmax;
    acceptsPets.value = annonce.possibiliteanimaux;

    // Pré-remplissage uniquement pour les particuliers avec nom et prénom renseignés
    const user = authState.user;
    if (user?.typeUtilisateur === 'particulier' && user.prenomutilisateur && user.nomutilisateur) {
      form.value.prenom = user.prenomutilisateur;
      form.value.nom = user.nomutilisateur;
    }
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
const totalRent   = computed(() => pricePerNight.value * (nbNuits.value > 0 ? nbNuits.value : 1));
const serviceFee  = computed(() => totalRent.value * 0.14);
const touristTax  = computed(() => 4.00 * nbNuits.value * guests.value.adults);
const total       = computed(() => totalRent.value + serviceFee.value + touristTax.value);
const payNow      = computed(() => serviceFee.value + (totalRent.value * 0.35) + touristTax.value);
const payOnSite   = computed(() => Math.max(0, total.value - payNow.value));

const formatPrice = (value) =>
  value.toFixed(2).replace('.', ',').replace(/\B(?=(\d{3})+(?!\d))/g, '\u202f');

const formatDate = (dateString) => {
  if (!dateString) return '-';
  return new Date(dateString).toLocaleDateString('fr-FR');
};

const submitReservation = async () => {
  if (nbNuits.value <= 0 || !form.value.cgv) return;

  const digitsOnly = form.value.telephone.replace(/\D/g, '');
  if (digitsOnly.length !== 10) {
    alert('Veuillez saisir un numéro de téléphone valide (10 chiffres).');
    return;
  }

  const userSolde = authState.user?.solde || 0;
  if (userSolde > 0) {
    const confirmed = await openSoldeModal();
    if (!confirmed) return;
  }

  isSubmitting.value = true;

  try {
    const voyageursInclures = [{ idtypevoyageur: 1, nombrevoyageur: guests.value.adults }];
    if (guests.value.children > 0)
      voyageursInclures.push({ idtypevoyageur: 2, nombrevoyageur: guests.value.children });
    if (guests.value.babies > 0)
      voyageursInclures.push({ idtypevoyageur: 3, nombrevoyageur: guests.value.babies });
    if (guests.value.pets > 0)
      voyageursInclures.push({ idtypevoyageur: 4, nombrevoyageur: guests.value.pets });

    const payload = {
      idannonce:       parseInt(annonceId),
      idutilisateur:   authState.user.idutilisateur,
      dateDebut:       startDate.value,
      dateFin:         endDate.value,
      nomclient:       form.value.nom,
      prenomclient:    form.value.prenom,
      telephoneclient: digitsOnly,
      inclures:        voyageursInclures
    };

    const response = await axios.post('/api/reservations/create-checkout-session', payload);
    window.location.href = response.data.url;

  } catch (error) {
    console.error('Erreur réservation:', error);
    alert('Une erreur est survenue lors de la réservation.');
    isSubmitting.value = false;
  }
};
</script>

<style scoped>
.modal-enter-active,
.modal-leave-active {
  transition: opacity 0.2s ease;
}
.modal-enter-active .relative,
.modal-leave-active .relative {
  transition: transform 0.2s ease, opacity 0.2s ease;
}
.modal-enter-from,
.modal-leave-to {
  opacity: 0;
}
.modal-enter-from .relative {
  transform: scale(0.95) translateY(8px);
  opacity: 0;
}
.modal-leave-to .relative {
  transform: scale(0.95) translateY(8px);
  opacity: 0;
}
</style>