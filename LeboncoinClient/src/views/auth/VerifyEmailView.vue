<template>
    <div class="min-h-[80vh] flex items-center justify-center px-4 text-center">
      <div class="max-w-md bg-white p-10 rounded-3xl shadow-xl border border-gray-100">
        <div class="w-20 h-20 bg-green-100 text-green-600 rounded-full flex items-center justify-center mx-auto mb-6 text-4xl">
          ✉️
        </div>
        <h1 class="text-2xl font-black text-gray-900 mb-4">Vérifiez vos emails</h1>
        <p class="text-gray-600 mb-8">
          Nous avons envoyé un lien de confirmation à votre adresse. Merci de cliquer dessus pour activer votre compte.
        </p>
        
        <div class="space-y-4">
          <button class="text-orange-600 font-bold hover:underline">Je n'ai rien reçu, renvoyer</button>
          <div class="pt-4 border-t border-gray-100">
            <router-link to="/" class="inline-block bg-gray-900 text-white px-8 py-3 rounded-xl font-bold">Retour à l'accueil</router-link>
          </div>
        </div>
      </div>
    </div>
  </template>