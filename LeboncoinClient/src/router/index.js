import { createRouter, createWebHistory } from 'vue-router'
import { authState } from '@/auth' // Importé en haut, c'est plus propre

const routes = [
  {
    path: '/',
    name: 'home',
    component: () => import('../views/HomeView.vue')
  },

  // --- Authentification & Inscription ---
  {
    path: '/login',
    name: 'login',
    component: () => import('../views/auth/LoginView.vue')
  },
  {
    path: '/register',
    name: 'register', 
    component: () => import('../views/auth/RegisterView.vue')
  },
  {
    path: '/login/particulier',
    name: 'particulier',
    component: () => import('../views/auth/ParticulierView.vue')
  },
  {
    path: '/login/professionnel',
    name: 'professionnel',
    component: () => import('../views/auth/ProfessionnelView.vue')
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
    path: '/create-annonce',
    name: 'create-annonce',
    component: () => import('../views/annonces/CreateAnnonceView.vue'),
    meta: { requiresAuth: true } // Ajouté pour protéger la route
  },
  {
    path: '/edit-annonce/:id',
    name: 'edit-annonce',
    component: () => import('../views/annonces/EditAnnonceView.vue')
  },
  {
  {
    path: '/edit-annonce/:id',
    name: 'edit-annonce',
    component: () => import('../views/annonces/EditAnnonceView.vue'),
    meta: { requiresAuth: true }
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
  // --- Espace Compte ---
  {
    path: '/my-annonces',
    name: 'my-annonces',
    component: () => import('../views/account/MyAnnoncesView.vue'),
    meta: { requiresAuth: true }
  },
  {
    path: '/messages',
    name: 'messages',
    component: () => import('../views/account/MessagesView.vue'),
    meta: { requiresAuth: true }
  },
  {
    path: '/favorites',
    name: 'favorites',
    component: () => import('../views/account/FavoritesView.vue')
    path: '/favorites',
    name: 'favorites',
    component: () => import('../views/account/FavoritesView.vue'),
    meta: { requiresAuth: true }
  },
  {
    path: '/settings',
    name: 'settings',
    component: () => import('../views/account/AccountSettingsView.vue')
    path: '/settings',
    name: 'settings',
    component: () => import('../views/account/AccountSettingsView.vue'),
    meta: { requiresAuth: true }
  },
  // --- Profil ---
  {
    path: '/register',
    name: 'register', 
    component: () => import('../views/auth/RegisterView.vue')
    path: '/profil',
    name: 'profile',
    component: () => import('../views/profile/ProfileView.vue'),
    meta: { requiresAuth: true }
  },
  {
    path: '/edit-profile',
    name: 'edit-profile',
    component: () => import('../views/profile/EditProfileView.vue')
  },
  {
    path: '/profil',
    name: 'profile',
    component: () => import('../views/profile/ProfileView.vue')
    component: () => import('../views/profile/EditProfileView.vue'),
    meta: { requiresAuth: true }
  },
  {
    path: '/security',
    name: 'security',
    component: () => import('../views/profile/SecurityView.vue')
  },


  {
    path: '/security',
    name: 'security',
    component: () => import('../views/profile/SecurityView.vue'),
    meta: { requiresAuth: true }
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes,
})


router.beforeEach((to, from) => {
  const requiresAuth = to.matched.some(record => record.meta.requiresAuth);

  if (requiresAuth && !authState.isLoggedIn()) {
    return { name: 'login' }; 
  }
  
});

export default router;