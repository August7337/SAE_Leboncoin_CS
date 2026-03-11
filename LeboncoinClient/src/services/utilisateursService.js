import { deleteRequest, getJson, postJson, putJson } from './api'

const BASE_PATH = '/api/utilisateurs'

export const utilisateursService = {
  getAll: () => getJson(BASE_PATH),
  getById: (id) => getJson(`${BASE_PATH}/${id}`),
  getByEmail: (email) => getJson(`${BASE_PATH}/email/${encodeURIComponent(email)}`),
  create: (utilisateur) => postJson(BASE_PATH, utilisateur),
  update: (id, utilisateur) => putJson(`${BASE_PATH}/${id}`, utilisateur),
  remove: (id) => deleteRequest(`${BASE_PATH}/${id}`),
}

export default utilisateursService
