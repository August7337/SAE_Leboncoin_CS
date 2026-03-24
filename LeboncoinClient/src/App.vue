<script setup>
import Header from './components/Header.vue'
import Footer from './components/Footer.vue'
import SuccessNotification from './components/SuccessNotification.vue'
</script>

<template>
  <div class="min-h-screen flex flex-col">
    <Header />

    <main class="flex-grow">
      <router-view />
    </main>

    <Footer />

    <SuccessNotification />
  </div>
</template>