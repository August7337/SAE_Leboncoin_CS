<template>
  <div class="pt-24 pb-16 bg-gray-50 min-h-screen">
    <div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
      <div class="bg-white overflow-hidden shadow-sm sm:rounded-2xl border border-gray-100 p-8 sm:p-12">
        <h1 class="text-3xl font-black mb-8 text-gray-900">Politique de protection des données personnelles</h1>
        
        <section class="mb-10">
          <h2 class="text-xl font-bold mb-4 text-gray-900">Identité du responsable de traitement</h2>
          <div class="bg-gray-50 rounded-xl p-6 border border-gray-100">
            <p class="mb-2"><strong>Qui :</strong> Leboncoin, 9 rue de l’arc en ciel, Annecy, France.</p>
            <p><strong>Contact DPO :</strong> Pour toute question relative à vos données, vous pouvez contacter notre Délégué à la Protection des Données à l'adresse suivante : <a href="mailto:dpo@leboncoin.fr" class="text-orange-600 font-medium hover:underline">dpo@leboncoin.fr</a></p>
          </div>
        </section>

        <section class="mb-10">
          <h2 class="text-xl font-bold mb-4 text-gray-900">Données collectées et finalité des traitements</h2>
          <p class="text-gray-700 mb-6">Nous collectons et traitons vos données pour des objectifs précis, liés à l'utilisation de notre plateforme.</p>

          <div class="space-y-6">
            <div class="border-l-4 border-orange-500 pl-4 py-3 bg-orange-50 rounded-r-xl">
              <h3 class="text-lg font-bold text-gray-900">Création et Gestion de Compte (Particulier et Professionnel)</h3>
              <p class="mt-2 text-gray-700"><strong>Finalité :</strong> Vous permettre de créer votre espace personnel, gérer votre profil, sauvegarder vos favoris, déposer des annonces et effectuer des réservations.</p>
              <p class="mt-1 text-gray-700"><strong>Données collectées :</strong> Nom, prénom, adresse mail, mot de passe (stocké de manière chiffrée), date de naissance. Pour les comptes Professionnels : N° SIRET, nom de la société.</p>
              <p class="mt-1 text-gray-600 italic"><strong>Base légale :</strong> Exécution du contrat (Conditions Générales d'Utilisation).</p>
            </div>

            <div class="border-l-4 border-blue-500 pl-4 py-3 bg-blue-50 rounded-r-xl">
              <h3 class="text-lg font-bold text-gray-900">Dépôt et Gestion d'Annonces</h3>
              <p class="mt-2 text-gray-700"><strong>Finalité :</strong> Publier vos offres de location saisonnière et vérifier l'identité des propriétaires pour lutter contre la fraude.</p>
              <p class="mt-1 text-gray-700"><strong>Données collectées :</strong> Descriptif du bien, photos, prix, calendrier de disponibilité, adresse (ville), équipements, numéro de téléphone. Copie de la Carte Nationale d'Identité (CNI) ou du Passeport pour la vérification.</p>
              <p class="mt-1 text-gray-600 italic"><strong>Base légale :</strong> Exécution du contrat ; Obligation légale (lutte contre la fraude et blanchiment).</p>
            </div>

            <div class="border-l-4 border-green-500 pl-4 py-3 bg-green-50 rounded-r-xl">
              <h3 class="text-lg font-bold text-gray-900">Réservation et Paiement en Ligne</h3>
              <p class="mt-2 text-gray-700"><strong>Finalité :</strong> Traiter les demandes de réservation, gérer les paiements (acomptes, soldes), et percevoir les frais de service ainsi que la taxe de séjour.</p>
              <p class="mt-1 text-gray-700"><strong>Données collectées :</strong> Dates de séjour, nombre et typologie des voyageurs (adultes, enfants, bébés, animaux), informations de paiement (numéro de carte, cryptogramme - traitées de manière sécurisée via nos prestataires).</p>
              <p class="mt-1 text-gray-600 italic"><strong>Base légale :</strong> Exécution du contrat.</p>
            </div>

            <div class="border-l-4 border-purple-500 pl-4 py-3 bg-purple-50 rounded-r-xl">
              <h3 class="text-lg font-bold text-gray-900">Gestion du Support Client</h3>
              <p class="mt-2 text-gray-700"><strong>Finalité :</strong> Répondre à vos demandes techniques, questions ou réclamations via notre formulaire de contact ou notre Chatbot.</p>
              <p class="mt-1 text-gray-700"><strong>Données collectées :</strong> Nom, mail, contenu du message, historique des échanges.</p>
              <p class="mt-1 text-gray-600 italic"><strong>Base légale :</strong> Intérêt légitime (fournir une assistance aux utilisateurs).</p>
            </div>
          </div>
        </section>

        <section class="mb-10">
          <h2 class="text-xl font-bold mb-4 text-gray-900">Destinataires des données</h2>
          <p class="text-gray-700 mb-4">Vos données sont confidentielles et ne sont transmises qu'aux destinataires suivants, dans la stricte limite de leurs besoins :</p>
          <ul class="list-disc list-inside space-y-2 text-gray-700 ml-4">
            <li><strong>Autres utilisateurs :</strong> Vos nom et prénom sont transmis au propriétaire (ou au locataire) uniquement lors de la validation d'une réservation pour permettre la mise en relation.</li>
            <li><strong>Services internes :</strong> Service client, service technique, service comptable et service juridique en cas de litige.</li>
            <li><strong>Sous-traitants et Prestataires techniques :</strong>
              <ul class="list-[circle] list-inside ml-6 mt-2 space-y-1 text-gray-600">
                <li>Paiement : Stripe (pour la sécurisation des transactions).</li>
                <li>Hébergement : OVHcloud (stockage sécurisé des données en France/UE).</li>
                <li>Services Tiers : Google Maps (géolocalisation), API de Chatbot.</li>
              </ul>
            </li>
            <li><strong>Autorités administratives et judiciaires :</strong> Organismes publics pour la collecte de la taxe de séjour ou autorités judiciaires sur réquisition légale.</li>
          </ul>
        </section>

        <section class="mb-10">
          <h2 class="text-xl font-bold mb-4 text-gray-900">Durées de conservation</h2>
          <p class="text-gray-700 mb-4">Nous conservons vos données uniquement le temps nécessaire aux finalités poursuivies :</p>
          <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div class="bg-gray-50 p-5 rounded-xl border border-gray-100">
              <strong class="text-gray-900 block mb-1">Données de compte actif :</strong>
              <p class="text-sm text-gray-600">Conservées tant que votre compte est actif. Elles sont anonymisées ou supprimées après 3 ans d'inactivité.</p>
            </div>
            <div class="bg-gray-50 p-5 rounded-xl border border-gray-100">
              <strong class="text-gray-900 block mb-1">Données de facturation et réservation :</strong>
              <p class="text-sm text-gray-600">Conservées 10 ans pour respecter nos obligations légales et comptables.</p>
            </div>
            <div class="bg-gray-50 p-5 rounded-xl border border-gray-100">
              <strong class="text-gray-900 block mb-1">Pièces d'identité (CNI/Passeport) :</strong>
              <p class="text-sm text-gray-600">Conservées uniquement le temps de la vérification de l'identité du propriétaire, puis immédiatement supprimées de nos serveurs actifs.</p>
            </div>
            <div class="bg-gray-50 p-5 rounded-xl border border-gray-100">
              <strong class="text-gray-900 block mb-1">Données bancaires :</strong>
              <p class="text-sm text-gray-600">Supprimées une fois la transaction réalisée, sauf si vous consentez à leur enregistrement (conservation sécurisée jusqu'à expiration ou retrait du consentement).</p>
            </div>
          </div>
        </section>

        <section class="mb-10">
          <h2 class="text-xl font-bold mb-4 text-gray-900">Transfert de données hors Union Européenne</h2>
          <p class="text-gray-700">
            Certains de nos prestataires techniques (ex: Google, Stripe, outils de Chatbot) peuvent traiter des données aux États-Unis. Nous nous assurons que ces transferts sont encadrés par des garanties appropriées, telles que les Clauses Contractuelles Types de la Commission Européenne, assurant un niveau de protection équivalent à celui du RGPD.
          </p>
        </section>

        <section class="mb-10">
          <h2 class="text-xl font-bold mb-4 text-gray-900">Vos droits sur vos données</h2>
          <p class="text-gray-700 mb-6">Conformément à la réglementation en vigueur, vous disposez des droits suivants sur vos données personnelles :</p>
          <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4 mb-8">
            <div class="p-5 border border-gray-200 rounded-xl bg-white shadow-sm">
              <strong class="text-orange-600 block mb-1">Droit d'accès</strong>
              <p class="text-xs text-gray-500">Obtenir la confirmation que vos données sont traitées et en recevoir une copie.</p>
            </div>
            <div class="p-5 border border-gray-200 rounded-xl bg-white shadow-sm">
              <strong class="text-orange-600 block mb-1">Droit de rectification</strong>
              <p class="text-xs text-gray-500">Demander la correction de données inexactes ou incomplètes.</p>
            </div>
            <div class="p-5 border border-gray-200 rounded-xl bg-white shadow-sm">
              <strong class="text-orange-600 block mb-1">Droit à l'effacement</strong>
              <p class="text-xs text-gray-500">Demander la suppression de vos données (sous réserve de nos obligations légales).</p>
            </div>
            <div class="p-5 border border-gray-200 rounded-xl bg-white shadow-sm">
              <strong class="text-orange-600 block mb-1">Droit à la limitation</strong>
              <p class="text-xs text-gray-500">Demander le gel temporaire de l'utilisation de certaines données.</p>
            </div>
            <div class="p-5 border border-gray-200 rounded-xl bg-white shadow-sm">
              <strong class="text-orange-600 block mb-1">Droit à la portabilité</strong>
              <p class="text-xs text-gray-500">Recevoir vos données dans un format structuré.</p>
            </div>
            <div class="p-5 border border-gray-200 rounded-xl bg-white shadow-sm">
              <strong class="text-orange-600 block mb-1">Droit d'opposition</strong>
              <p class="text-xs text-gray-500">Vous opposer à tout moment à l'utilisation de vos données pour de la prospection.</p>
            </div>
          </div>
          <div class="bg-slate-900 text-white p-8 rounded-2xl flex flex-col md:flex-row items-center justify-between gap-6 mt-8">
            <div>
              <h3 class="font-bold text-lg mb-2">Exercez vos droits en un clic</h3>
              <p class="text-slate-300 text-sm">Consultez toutes les données que nous possédons sur vous ou demandez leur suppression directement depuis votre espace.</p>
            </div>
            <button @click="consulterMesDonnees" class="bg-orange-600 text-white font-bold py-3 px-8 rounded-xl hover:bg-orange-700 transition-colors shadow-sm whitespace-nowrap">
              Accéder à mes données
            </button>
          </div>

          <div class="mt-4 text-center">
            <p class="text-sm text-gray-500">Pour toute autre question, contactez notre DPO : <a href="mailto:dpo@leboncoin.fr" class="text-orange-600 font-bold hover:underline">dpo@leboncoin.fr</a></p>
          </div>
        </section>

      </div>
    </div>
  </div>
</template>

<script setup>
import { useRouter } from 'vue-router';
import { authState } from '@/auth.js';

const router = useRouter();

const consulterMesDonnees = () => {
  if (authState.isLoggedIn()) {
    router.push('/mes-donnees-personnelles');
  } else {
    router.push('/login?redirect=/mes-donnees-personnelles');
  }
};
</script>