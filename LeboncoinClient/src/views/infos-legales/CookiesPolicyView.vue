<template>
  <div class="py-24 bg-gray-50 min-h-screen">
    <div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
      <div class="bg-white overflow-hidden shadow-sm sm:rounded-2xl border border-gray-100 p-8 sm:p-12">
        <h1 class="text-3xl font-black mb-6 text-gray-900">Politique d'utilisation des cookies</h1>
        
        <section class="mb-10">
          <p class="text-gray-700 leading-relaxed">
            Chez <strong>Leboncoin</strong>, nous accordons une grande importance à la transparence. Cette page vous explique comment nous utilisons les cookies et autres traceurs pour améliorer votre expérience sur notre plateforme de location saisonnière.
          </p>
        </section>

        <section class="mb-10">
          <h2 class="text-xl font-bold mb-4 text-gray-900">1. Qu'est-ce qu'un cookie ?</h2>
          <p class="text-gray-700 leading-relaxed">
            Un cookie est un petit fichier texte enregistré sur votre appareil (ordinateur, tablette, smartphone) lorsque vous visitez un site. Il permet de conserver des données utilisateur afin de faciliter la navigation et de permettre certaines fonctionnalités.
          </p>
        </section>

        <section class="mb-10">
          <h2 class="text-xl font-bold mb-4 text-gray-900">2. Vos choix</h2>
          <div class="bg-orange-50 border border-orange-100 rounded-xl p-6 flex flex-col md:flex-row items-center justify-between gap-6">
            <div>
              <h3 class="text-lg font-bold text-orange-900 mb-2">Gérez vos préférences à tout moment</h3>
              <p class="text-orange-800 text-sm">
                Vous pouvez modifier vos consentements pour les fonctionnalités non essentielles (cartes interactives, chat) via notre panneau de configuration.
              </p>
            </div>
            <button @click="openCookieSettings" class="bg-orange-600 hover:bg-orange-700 text-white font-bold py-3 px-6 rounded-xl transition-colors whitespace-nowrap shadow-sm">
              Gérer mes cookies
            </button>
          </div>
        </section>

        <section class="mb-10">
          <h2 class="text-xl font-bold mb-6 text-gray-900">3. Liste détaillée des cookies</h2>

          <div class="mb-8">
            <div class="flex items-center gap-3 mb-4">
              <span class="bg-gray-200 text-gray-800 text-xs font-black px-3 py-1 rounded-md uppercase tracking-wide">Nécessaire</span>
              <h3 class="text-lg font-bold text-gray-900">Cookies Techniques & Fonctionnels (Strictement Nécessaires)</h3>
            </div>
            <p class="text-gray-600 text-sm mb-4">
              Ces cookies sont indispensables au bon fonctionnement du site et à sa sécurité. Ils ne requièrent pas votre consentement préalable.
            </p>
            <div class="overflow-x-auto border border-gray-200 rounded-xl">
              <table class="min-w-full text-sm text-left text-gray-600">
                <thead class="text-xs text-gray-700 uppercase bg-gray-50 border-b border-gray-200">
                  <tr>
                    <th scope="col" class="px-6 py-4">Nom</th>
                    <th scope="col" class="px-6 py-4">Finalité</th>
                    <th scope="col" class="px-6 py-4">Fournisseur</th>
                    <th scope="col" class="px-6 py-4">Conservation</th>
                  </tr>
                </thead>
                <tbody class="divide-y divide-gray-200">
                  <tr class="bg-white">
                    <td class="px-6 py-4 font-bold text-gray-900 whitespace-nowrap">leboncoin_session</td>
                    <td class="px-6 py-4">Maintien de votre session de connexion.</td>
                    <td class="px-6 py-4">Leboncoin (Interne)</td>
                    <td class="px-6 py-4">Session</td>
                  </tr>
                  <tr class="bg-white">
                    <td class="px-6 py-4 font-bold text-gray-900 whitespace-nowrap">XSRF-TOKEN</td>
                    <td class="px-6 py-4">Sécurisation des formulaires contre les attaques CSRF.</td>
                    <td class="px-6 py-4">Leboncoin (Interne)</td>
                    <td class="px-6 py-4">2 heures</td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>

          <div class="mb-8">
            <div class="flex items-center gap-3 mb-4">
              <span class="bg-blue-100 text-blue-800 text-xs font-black px-3 py-1 rounded-md uppercase tracking-wide">Fonctionnel</span>
              <h3 class="text-lg font-bold text-gray-900">Cookies de Préférences</h3>
            </div>
            <p class="text-gray-600 text-sm mb-4">
              Ces cookies permettent d'activer des fonctionnalités demandées explicitement (ex: "Se souvenir de moi").
            </p>
            <div class="overflow-x-auto border border-gray-200 rounded-xl">
              <table class="min-w-full text-sm text-left text-gray-600">
                <thead class="text-xs text-gray-700 uppercase bg-gray-50 border-b border-gray-200">
                  <tr>
                    <th scope="col" class="px-6 py-4">Nom</th>
                    <th scope="col" class="px-6 py-4">Finalité</th>
                    <th scope="col" class="px-6 py-4">Fournisseur</th>
                    <th scope="col" class="px-6 py-4">Conservation</th>
                  </tr>
                </thead>
                <tbody class="divide-y divide-gray-200">
                  <tr class="bg-white">
                    <td class="px-6 py-4 font-bold text-gray-900 whitespace-nowrap">remember_web_*</td>
                    <td class="px-6 py-4">Permet de rester connecté automatiquement si vous avez coché "Se souvenir de moi".</td>
                    <td class="px-6 py-4">Leboncoin (Interne)</td>
                    <td class="px-6 py-4">5 ans</td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>

          <div class="mb-6">
            <div class="flex items-center gap-3 mb-4">
              <span class="bg-purple-100 text-purple-800 text-xs font-black px-3 py-1 rounded-md uppercase tracking-wide">Tiers</span>
              <h3 class="text-lg font-bold text-gray-900">Cookies Tiers et Fonctionnalités Avancées</h3>
            </div>
            <p class="text-gray-600 text-sm mb-4">
              Ces cookies sont liés à des services externes intégrés à notre site. Ils nécessitent votre consentement.
            </p>
            <div class="overflow-x-auto border border-gray-200 rounded-xl">
              <table class="min-w-full text-sm text-left text-gray-600">
                <thead class="text-xs text-gray-700 uppercase bg-gray-50 border-b border-gray-200">
                  <tr>
                    <th scope="col" class="px-6 py-4">Nom</th>
                    <th scope="col" class="px-6 py-4">Finalité</th>
                    <th scope="col" class="px-6 py-4">Fournisseur</th>
                    <th scope="col" class="px-6 py-4">Conservation</th>
                  </tr>
                </thead>
                <tbody class="divide-y divide-gray-200">
                  <tr class="bg-white">
                    <td class="px-6 py-4 font-bold text-gray-900 whitespace-nowrap">NID / CONSENT</td>
                    <td class="px-6 py-4">Affichage des cartes interactives pour localiser les biens.</td>
                    <td class="px-6 py-4">Google Maps</td>
                    <td class="px-6 py-4">6 mois</td>
                  </tr>
                  <tr class="bg-white">
                    <td class="px-6 py-4 font-bold text-gray-900 whitespace-nowrap">Stockage Local (Chat)</td>
                    <td class="px-6 py-4">Gestion de la conversation avec l'assistant virtuel.</td>
                    <td class="px-6 py-4">Leboncoin (Interne)</td>
                    <td class="px-6 py-4">Persistant</td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        </section>

        <section>
          <h2 class="text-xl font-bold mb-6 text-gray-900">4. Vos droits sur vos données</h2>
          <div class="bg-slate-900 text-white rounded-2xl p-8 sm:p-10">
            <div class="grid md:grid-cols-2 gap-10">
              <div>
                <h3 class="text-lg font-bold mb-6 text-white">Exercer vos droits</h3>
                <ul class="space-y-4 text-slate-300">
                  <li class="flex items-center gap-3">
                    <svg class="w-5 h-5 text-orange-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path></svg>
                    <span>Droit d'accès</span>
                  </li>
                  <li class="flex items-center gap-3">
                    <svg class="w-5 h-5 text-orange-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path></svg>
                    <span>Rectification</span>
                  </li>
                  <li class="flex items-center gap-3">
                    <svg class="w-5 h-5 text-orange-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path></svg>
                    <span>Effacement (Oubli)</span>
                  </li>
                  <li class="flex items-center gap-3">
                    <svg class="w-5 h-5 text-orange-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path></svg>
                    <span>Portabilité</span>
                  </li>
                </ul>
              </div>
              <div class="flex flex-col justify-center items-start border-t md:border-t-0 md:border-l border-slate-700 pt-8 md:pt-0 md:pl-10">
                <p class="mb-6 text-slate-300 leading-relaxed">
                  Pour toute question relative à cette politique ou pour exercer vos droits, vous pouvez contacter notre Délégué à la Protection des Données (DPO).
                </p>
                <a href="mailto:dpo@leboncoin.fr" class="bg-orange-600 hover:bg-orange-700 text-white font-bold py-3 px-8 rounded-xl transition-colors shadow-sm">
                  Exercer mes droits par email
                </a>
              </div>
            </div>
          </div>
        </section>

      </div>
    </div>
  </div>
</template>

<script setup>
import { openCookieSettings } from '@/cookieManager.js';
</script>