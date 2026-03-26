<script setup>
import Header from './components/Header.vue'
import Footer from './components/Footer.vue'
import SuccessNotification from './components/SuccessNotification.vue'
import CookieBanner from './components/CookieBanner.vue'
import CookieSettings from './components/CookieSettings.vue'
import DevPanel from './components/DevPanel.vue'

const isDev = import.meta.env.DEV
</script>

<template>
  <div class="min-h-screen flex flex-col">
    <Header />

    <main class="flex-grow">
      <router-view />
    </main>

    <Footer />
    
    <SuccessNotification />
    
    <CookieBanner />
    <CookieSettings />

    <DevPanel v-if="isDev" />
  </div>
</template>