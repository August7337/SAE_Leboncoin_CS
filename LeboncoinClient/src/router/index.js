import { createRouter, createWebHistory } from 'vue-router'
import { authState } from '@/auth'

const routes = [
  {
    path: '/',
    name: 'home',
    component: () => import('../views/HomeView.vue'),
  },

  // --- Authentification & Inscription ---
  {
    path: '/login',
    name: 'login',
    component: () => import('../views/auth/LoginView.vue'),
  },
  {
    path: '/register',
    name: 'register',
    component: () => import('../views/auth/RegisterView.vue'),
  },
  {
    path: '/login/particulier',
    name: 'particulier',
    component: () => import('../views/auth/ParticulierView.vue'),
  },
  {
    path: '/login/professionnel',
    name: 'professionnel',
    component: () => import('../views/auth/ProfessionnelView.vue'),
  },

  // --- Annonces ---
  {
    path: '/annonce/:id',
    name: 'annonce-detail',
    component: () => import('../views/annonces/AnnonceView.vue'),
  },
  {
    path: '/create-annonce',
    name: 'create-annonce',
    component: () => import('../views/annonces/CreateAnnonceView.vue'),
    meta: { requiresAuth: true },
  },
  {
    path: '/edit-annonce/:id',
    name: 'edit-annonce',
    component: () => import('../views/annonces/EditAnnonceView.vue'),
    meta: { requiresAuth: true },
  },

  // --- Espace Compte & Profil (Protected) ---
  {
    path: '/my-annonces',
    name: 'my-annonces',
    component: () => import('../views/account/MyAnnoncesView.vue'),
    meta: { requiresAuth: true },
  },
  {
    path: '/my-reservations',
    name: 'my-reservations',
    component: () => import('../views/account/MyReservationsView.vue'),
    meta: { requiresAuth: true },
  },
  {
    path: '/my-reservations/:id/edit',
    name: 'edit-reservation',
    component: () => import('../views/account/EditReservationView.vue'),
    meta: { requiresAuth: true },
    props: true
  },
  {
    path: '/messages',
    name: 'messages',
    component: () => import('../views/account/MessagesView.vue'),
    meta: { requiresAuth: true },
  },
  {
    path: '/conversation/:id',
    name: 'conversation',
    component: () => import('../views/messages/ConversationView.vue'),
    meta: { requiresAuth: true },
  },
  {
    path: '/favorites',
    name: 'favorites',
    component: () => import('../views/account/FavoritesView.vue'),
    meta: { requiresAuth: true },
  },
  {
    path: '/mes-recherches',
    name: 'saved-searches',
    component: () => import('../views/account/SavedSearchesView.vue'),
    // No requiresAuth since both visitors & users can use it
  },
  {
    path: '/account-settings',
    name: 'settings',
    component: () => import('../views/account/AccountSettingsView.vue'),
    meta: { requiresAuth: true },
  },
  {
    path: '/profil',
    name: 'profile',
    component: () => import('../views/profile/ProfileView.vue'),
    meta: { requiresAuth: true },
  },
  {
    path: '/edit-profile',
    name: 'edit-profile',
    component: () => import('../views/profile/EditProfileView.vue'),
    meta: { requiresAuth: true },
  },
  {
    path: '/vendeur/:id',
    name: 'vendeur-profile',
    component: () => import('../views/profile/PublicProfileView.vue'),
  },
  {
    path: '/security',
    name: 'security',
    component: () => import('../views/profile/SecurityView.vue'),
    meta: { requiresAuth: true }
  },
  {
    path: '/profile-picture',
    name: 'profile-picture',
    component: () => import('../views/account/AccountProfilePictureView.vue'),
    meta: { requiresAuth: true }
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes,
})

router.beforeEach((to, from) => {
  const requiresAuth = to.matched.some((record) => record.meta.requiresAuth)

  if (requiresAuth && !authState.isLoggedIn()) {
    return { name: 'login' }
  }
})

export default router
