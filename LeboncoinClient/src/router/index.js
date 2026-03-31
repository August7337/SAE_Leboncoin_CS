import { createRouter, createWebHistory } from 'vue-router'
import { authState } from '@/auth'

const routes = [
  {
    path: '/',
    name: 'home',
    component: () => import('../views/HomeView.vue'),
  },

  // --- Informations légales ---
  {
      path: '/cgv',
      name: 'Cgv',
      component: () => import('@/views/infos-legales/CgvView.vue'),
      meta: { title: 'Conditions générales de vente - leboncoin' }
  },
  {
      path: '/donnees-personnelles',
      name: 'PrivacyPolicy',
      component: () => import('@/views/infos-legales/PrivacyPolicyView.vue'),
      meta: { title: 'Données personnelles - leboncoin' }
  },
  {
    path: '/politique-cookies',
    name: 'CookiesPolicy',
    component: () => import('@/views/infos-legales/CookiesPolicyView.vue'),
    meta: { title: 'Politique de cookies - leboncoin' }
  },
  {
    path: '/mes-donnees-personnelles',
    name: 'gdpr-data',
    component: () => import('../views/account/GdprDataView.vue'),
    meta: { requiresAuth: true, requiresPermission: 'app.view.gdpr_data' },
  },

  // --- Réserver une annonce ---
  {
    path: '/reservation/create/:id',
    name: 'ReservationCreate',
    component: () => import('@/views/annonces/ReservationCreate.vue'),
    props: true
  },

  // --- Authentification & Inscription ---
  {
    path: '/login',
    name: 'login',
    component: () => import('../views/auth/LoginView.vue'),
  },
  {
    path: '/forgot-password',
    name: 'forgot-password',
    component: () => import('../views/auth/ForgotPasswordView.vue'),
  },
  {
    path: '/reset-password',
    name: 'reset-password',
    component: () => import('../views/auth/ResetPasswordView.vue'),
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
    meta: { requiresAuth: true, requiresPermission: 'app.view.my_annonces' },
  },
  {
    path: '/my-reservations',
    name: 'my-reservations',
    component: () => import('../views/account/MyReservationsView.vue'),
    meta: { requiresAuth: true, requiresPermission: 'app.view.my_reservations' },
  },
  {
    path: '/my-reservations/:id/edit',
    name: 'edit-reservation',
    component: () => import('../views/account/EditReservationView.vue'),
    meta: { requiresAuth: true, requiresPermission: 'app.view.my_reservations' },
    props: true
  },
  {
    path: '/my-incidents',
    name: 'my-incidents',
    component: () => import('../views/account/MyIncidentsView.vue'),
    meta: { requiresAuth: true, requiresPermission: 'app.view.my_incidents' },
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
    meta: { requiresPermission: 'app.view.home' },
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
  },
  {
    path: '/incidents/creer',
    name: 'incident-create',
    component: () => import('../views/incidents/CreateIncidentView.vue'),
    meta: { requiresAuth: true },
  },
  {
    path: '/incidents/:id',
    name: 'incident-detail',
    component: () => import('../views/incidents/IncidentDetailView.vue'),
    meta: { requiresAuth: true },
    props: true,
  },
  {
    path: '/incidents/:id/timeline',
    name: 'incident-timeline',
    component: () => import('../views/incidents/TimelineView.vue'),
    meta: { requiresAuth: true },
    props: true,
  },
  {
    path: '/incidents/:id/decision-locataire',
    name: 'locataire-decision',
    component: () => import('../views/incidents/LocataireDecisionView.vue'),
    meta: { requiresAuth: true },
    props: true,
  },
  {
    path: '/services/location',
    name: 'location-dashboard',
    component: () => import('../views/services/LocationDashboardView.vue'),
    meta: { requiresAuth: true, role: 'Service_Location' },
  },
  {
    path: '/services/comptabilite',
    name: 'comptabilite-dashboard',
    component: () => import('../views/services/ComptabiliteDashboardView.vue'),
    meta: { requiresAuth: true, role: 'Service_Comptabilite' },
  },
  {
    path: '/services/contentieux',
    name: 'contentieux-dashboard',
    component: () => import('../views/services/ContentieuxDashboardView.vue'),
    meta: { requiresAuth: true, role: 'Service_Contentieux' },
  },
  {
    path: '/incidents/:id/reponse-proprietaire',
    name: 'proprietaire-response',
    component: () => import('../views/services/ProprietaireResponseView.vue'),
    meta: { requiresAuth: true },
    props: true,
  },
  {
    path: '/dashboard-service',
    name: 'service-dashboard',
    component: () => import('../views/ServiceDashboardView.vue'),
    meta: { requiresAuth: true },
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes,
  
  scrollBehavior(to, from, savedPosition) {
    if (savedPosition) {
      return savedPosition
    } else {
      return { top: 0, behavior: 'smooth' }
    }
  }
})

router.beforeEach((to, from) => {
  const requiresAuth = to.matched.some((record) => record.meta.requiresAuth)
  const requiredPermission = to.matched.find((record) => record.meta.requiresPermission)?.meta.requiresPermission

  if (requiresAuth && !authState.isLoggedIn()) {
    return { name: 'login' }
  }

  if (requiredPermission && authState.isLoggedIn() && !authState.hasPermission(requiredPermission)) {
    return { name: 'service-dashboard' }
  }
})

export default router