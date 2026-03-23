// src/services/recherchesService.js

const RECHERCHES_STORAGE_KEY = 'leboncoin_recherches_sauvegardees'

export const recherchesService = {
  /**
   * Sauvegarde une recherche dans le localStorage
   * @param {string} query - Le terme de recherche (ex: ville)
   * @returns {object|null} La recherche sauvegardée ou null si déjà existante
   */
  saveSearch(query, filters = {}) {
    const q = query ? query.trim() : ''

    const hasFilters = Object.values(filters).some(v => {
      if (Array.isArray(v)) return v.length > 0
      if (v === null || v === '') return false
      if (typeof v === 'number' && v === 0) return false
      return true
    })

    if (q === '' && !hasFilters) return null

    const searches = this.getSavedSearches()
    const queryLower = q.toLowerCase()

    const isSame = (s) => {
      const sameQuery = (s.query || '').toLowerCase() === queryLower
      const sameFilters = JSON.stringify(s.filters || {}) === JSON.stringify(filters || {})
      return sameQuery && sameFilters
    }

    if (searches.some(isSame)) {
      return null
    }

    const newSearch = {
      id: Date.now().toString(),
      query: q,
      filters: JSON.parse(JSON.stringify(filters || {})),
      date: new Date().toISOString()
    }

    searches.unshift(newSearch)
    localStorage.setItem(RECHERCHES_STORAGE_KEY, JSON.stringify(searches))
    return newSearch
  },

  /**
   * Récupère la liste des recherches sauvegardées
   * @returns {Array} Liste des recherches
   */
  getSavedSearches() {
    try {
      const stored = localStorage.getItem(RECHERCHES_STORAGE_KEY)
      return stored ? JSON.parse(stored) : []
    } catch (e) {
      console.error('Erreur lors de la lecture des recherches sauvegardées', e)
      return []
    }
  },

  /**
   * Supprime une recherche sauvegardée avec son ID
   * @param {string} id - ID de la recherche à supprimer
   */
  deleteSearch(id) {
    let searches = this.getSavedSearches()
    searches = searches.filter(s => s.id !== id)
    localStorage.setItem(RECHERCHES_STORAGE_KEY, JSON.stringify(searches))
  },

  /**
   * Vérifie si une recherche est déjà sauvegardée
   * @param {string} query 
   * @returns {boolean}
   */
  isSearchSaved(query, filters = {}) {
    const q = query ? query.trim() : ''

    const hasFilters = Object.values(filters).some(v => {
      if (Array.isArray(v)) return v.length > 0
      if (v === null || v === '') return false
      if (typeof v === 'number' && v === 0) return false
      return true
    })

    if (q === '' && !hasFilters) return false

    const searches = this.getSavedSearches()
    const queryLower = q.toLowerCase()

    return searches.some(s => {
      const sameQuery = (s.query || '').toLowerCase() === queryLower
      const sameFilters = JSON.stringify(s.filters || {}) === JSON.stringify(filters || {})
      return sameQuery && sameFilters
    })
  }
}

export default recherchesService
