import { createRouter, createWebHistory } from 'vue-router'

const routes = [
  // --- Accueil ---
  {
    path: '/',
    name: 'home',
    component: () => import('../views/HomeView.vue')
  },

  // --- Annonces ---
  {
    path: '/annonce/:id',
    name: 'annonce-detail',
    component: () => import('../views/annonces/AnnonceView.vue')
  },
  {
    path: '/create-annonce',
    name: 'create-annonce',
    component: () => import('../views/annonces/CreateAnnonceView.vue')
  },
  {
    path: '/edit-annonce/:id',
    name: 'edit-annonce',
    component: () => import('../views/annonces/EditAnnonceView.vue')
  },
  {
    path: '/search',
    name: 'search',
    component: () => import('../views/annonces/AnnonceSearchView.vue')
  },

  // --- Espace Compte (Account) ---
  {
    path: '/my-annonces',
    name: 'my-annonces',
    component: () => import('../views/account/MyAnnoncesView.vue')
  },
  {
    path: '/messages',
    name: 'messages',
    component: () => import('../views/account/MessagesView.vue')
  },
  {
    path: '/login',
    name: 'login',
    component: () => import('../views/auth/LoginView.vue')
  },
  {
    path: '/favorites',
    name: 'favorites',
    component: () => import('../views/account/FavoritesView.vue')
  },
  {
    path: '/settings',
    name: 'settings',
    component: () => import('../views/account/AccountSettingsView.vue')
  },
  {
    path: '/register',
    name: 'register', 
    component: () => import('../views/auth/RegisterView.vue')
  },

  // --- Profil & Sécurité ---
  {
    path: '/profil',
    name: 'profile',
    component: () => import('../views/profile/ProfileView.vue')
  },
  {
    path: '/edit-profile',
    name: 'edit-profile',
    component: () => import('../views/profile/EditProfileView.vue')
  },
  {
    path: '/security',
    name: 'security',
    component: () => import('../views/profile/SecurityView.vue')
  },


]

const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router