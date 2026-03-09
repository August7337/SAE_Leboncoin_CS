import { createRouter, createWebHistory } from "vue-router"

// Pages principales
import HomeView from "../views/HomeView.vue"
import DashboardView from "../views/DashboardView.vue"
import NotFoundView from "../views/NotFoundView.vue"

// Annonces
import AnnonceView from "../views/annonces/AnnonceView.vue"
import CreateAnnonceView from "../views/annonces/CreateAnnonceView.vue"
import EditAnnonceView from "../views/annonces/EditAnnonceView.vue"
import AnnonceSearchView from "../views/annonces/AnnonceSearchView.vue"

// Auth
import LoginView from "../views/auth/LoginView.vue"
import RegisterView from "../views/auth/RegisterView.vue"
import ForgotPasswordView from "../views/auth/ForgotPasswordView.vue"
import ResetPasswordView from "../views/auth/ResetPasswordView.vue"
import VerifyEmailView from "../views/auth/VerifyEmailView.vue"

// Profil
import ProfileView from "../views/profile/ProfileView.vue"
import EditProfileView from "../views/profile/EditProfileView.vue"
import SecurityView from "../views/profile/SecurityView.vue"

// Compte
import MyAnnoncesView from "../views/account/MyAnnoncesView.vue"
import FavoritesView from "../views/account/FavoritesView.vue"
import MessagesView from "../views/account/MessagesView.vue"
import AccountSettingsView from "../views/account/AccountSettingsView.vue"

// Messages
import ConversationView from "../views/messages/ConversationView.vue"

// Services
import ServiceCatalogueView from "../views/services/ServiceCatalogueView.vue"
import ServiceDetailView from "../views/services/ServiceDetailView.vue"

const routes = [
  // Home
  {
    path: "/",
    name: "home",
    component: HomeView
  },

  {
    path: "/dashboard",
    name: "dashboard",
    component: DashboardView
  },

  // Annonces
  {
    path: "/annonces",
    name: "annonces-search",
    component: AnnonceSearchView
  },

  {
    path: "/annonce/:id",
    name: "annonce",
    component: AnnonceView,
    props: true
  },

  {
    path: "/deposer",
    name: "create-annonce",
    component: CreateAnnonceView
  },

  {
    path: "/annonce/edit/:id",
    name: "edit-annonce",
    component: EditAnnonceView,
    props: true
  },

  // Auth
  {
    path: "/login",
    name: "login",
    component: LoginView
  },

  {
    path: "/register",
    name: "register",
    component: RegisterView
  },

  {
    path: "/forgot-password",
    name: "forgot-password",
    component: ForgotPasswordView
  },

  {
    path: "/reset-password",
    name: "reset-password",
    component: ResetPasswordView
  },

  {
    path: "/verify-email",
    name: "verify-email",
    component: VerifyEmailView
  },

  // Profil
  {
    path: "/profile",
    name: "profile",
    component: ProfileView
  },

  {
    path: "/profile/edit",
    name: "edit-profile",
    component: EditProfileView
  },

  {
    path: "/profile/security",
    name: "security",
    component: SecurityView
  },

  // Compte utilisateur
  {
    path: "/mes-annonces",
    name: "my-annonces",
    component: MyAnnoncesView
  },

  {
    path: "/favoris",
    name: "favorites",
    component: FavoritesView
  },

  {
    path: "/messages",
    name: "messages",
    component: MessagesView
  },

  {
    path: "/compte",
    name: "account-settings",
    component: AccountSettingsView
  },

  // Conversation
  {
    path: "/conversation/:id",
    name: "conversation",
    component: ConversationView,
    props: true
  },

  // Services
  {
    path: "/services",
    name: "services",
    component: ServiceCatalogueView
  },

  {
    path: "/services/:id",
    name: "service-detail",
    component: ServiceDetailView,
    props: true
  },

  // 404
  {
    path: "/:pathMatch(.*)*",
    name: "not-found",
    component: NotFoundView
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router