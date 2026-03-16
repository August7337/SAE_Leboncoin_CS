<script setup>
import { reactive, ref } from 'vue'
import axios from 'axios'
import { useRouter } from 'vue-router'   

const router = useRouter()             

const form = reactive({
  email: '',
  password: ''
})

const errors = reactive({
  email: '',
  password: ''
})

const apiError = ref('')
const emailExists = ref(false)

async function login() {
  errors.email = ''
  apiError.value = ''

  if (!form.email) {
    errors.email = 'Email requis'
    return
  }

 
  if (emailExists.value) {
    try {
      const response = await axios.post(`http://localhost:5150/api/Utilisateurs/login`, {
        email: form.email,
        password: form.password
      })
      
      localStorage.setItem('user', JSON.stringify(response.data));
      alert("Connecté !");
      router.push({ name: 'home' }); 
} catch (error) {
  if (error.response) {
    
    apiError.value = typeof error.response.data === 'string' 
                     ? error.response.data 
                     : "Erreur de connexion.";
  } else {
    apiError.value = "Le serveur est injoignable.";
  }
}
    return;
  }

  
  try {
    const response = await axios.get(`http://localhost:5150/api/Utilisateurs/email/${form.email}`)
    emailExists.value = true
  } catch (error) {
    if (error.response?.status === 404) {
      
      router.push({ name: 'register', query: { email: form.email } })
    } else {
      apiError.value = "Erreur serveur."
    }
  }
}
</script>

<template>
  <div class="login-container">
    <h1>Connectez-vous ou créez votre compte leboncoin</h1>

    <form @submit.prevent="login">

      
      <div class="field">
        <label>E-mail</label>
        <input v-model="form.email" type="email" placeholder="email@mail.com"/>
        <span v-if="errors.email">{{ errors.email }}</span>
      </div>

     
<div class="field" v-if="emailExists">
  <label>Mot de passe</label>
  <input v-model="form.password" type="password" placeholder="Mot de passe"/>
</div>

      <button type="submit">
        {{ emailExists ? "Se connecter" : "Continuer" }}
      </button>

    </form>

    <p class="error" v-if="apiError">{{ apiError }}</p>
  </div>
</template>

<style src='../../assets/login.css' scoped>
</style>