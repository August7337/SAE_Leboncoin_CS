import { deleteRequest, getJson, postJson, putJson } from './api'

const BASE_PATH = '/api/annonces'

export const annoncesService = {
  getAll: () => getJson(BASE_PATH),
  getById: (id) => getJson(`${BASE_PATH}/${id}`),
  searchByLocation: (query, filters = {}) => {
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
    return getJson(url)
  },
  getTypeHebergements: () => getJson('/api/TypeHebergements'),
  getCommoditesByCategories: () => getJson('/api/Commodites/by-categories'),
}

export default annoncesService
