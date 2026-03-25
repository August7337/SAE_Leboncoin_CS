import api from '@/api/axios'

const BASE_PATH = '/Annonces'

export const annoncesService = {
  getAll: async () => {
    const response = await api.get(BASE_PATH)
    return response.data
  },
  
  getById: async (id) => {
    const response = await api.get(`${BASE_PATH}/${id}`)
    return response.data
  },
  
  searchByLocation: async (query, filters = {}) => {
    let url = `${BASE_PATH}/search?q=${encodeURIComponent(query ?? '')}`
    if (filters.minPrice) url += `&minPrice=${filters.minPrice}`
    if (filters.maxPrice) url += `&maxPrice=${filters.maxPrice}`
    if (filters.nbChambres) url += `&nbChambres=${filters.nbChambres}`
    if (filters.typeHebergementIds && filters.typeHebergementIds.length > 0)
      url += `&typeHebergementIds=${filters.typeHebergementIds.join(',')}`
    if (filters.commoditeIds && filters.commoditeIds.length > 0)
      url += `&commoditeIds=${filters.commoditeIds.join(',')}`
    if (filters.dateArrivee) url += `&dateArrivee=${filters.dateArrivee}`
    if (filters.dateDepart) url += `&dateDepart=${filters.dateDepart}`
    
    const response = await api.get(url)
    return response.data
  },
  
  getTypeHebergements: async () => {
    const response = await api.get('/TypeHebergements')
    return response.data
  },
  
  getCommoditesByCategories: async () => {
    const response = await api.get('/Commodites/by-categories')
    return response.data
  },
  
  getFavorites: async (userId) => {
    const response = await api.get(`${BASE_PATH}/favorites/${userId}`)
    return response.data
  },
  
  getFavoriteIds: async (userId) => {
    const response = await api.get(`${BASE_PATH}/favorites/ids/${userId}`)
    return response.data
  },
  
  addFavorite: async (annonceId, userId) => {
    const response = await api.post(`${BASE_PATH}/${annonceId}/favorite/${userId}`, {})
    return response.data
  },
  
  removeFavorite: async (annonceId, userId) => {
    const response = await api.delete(`${BASE_PATH}/${annonceId}/favorite/${userId}`)
    return response.data
  },
}

export default annoncesService