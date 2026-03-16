import { deleteRequest, getJson, postJson, putJson } from './api'

const BASE_PATH = '/api/annonces'

export const annoncesService = {
  getAll: () => getJson(BASE_PATH),
  getById: (id) => getJson(`${BASE_PATH}/${id}`),
  searchByLocation: (query) => getJson(`${BASE_PATH}/search?q=${encodeURIComponent(query ?? '')}`),
  create: (annonce) => postJson(BASE_PATH, annonce),
  update: (id, annonce) => putJson(`${BASE_PATH}/${id}`, annonce),
  remove: (id) => deleteRequest(`${BASE_PATH}/${id}`),
}

export default annoncesService
