import { createRouter, createWebHistory } from 'vue-router'

const routes = [
  {
    path: '/',
    name: 'home',
    component: () => import('../views/HomeView.vue')
  },
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
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router