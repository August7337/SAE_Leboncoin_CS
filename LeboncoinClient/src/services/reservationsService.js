import { deleteRequest, getJson, postJson, putJson } from './api'

const BASE_PATH = '/api/reservations'

export const reservationsService = {
  getAll: () => getJson(BASE_PATH),
  getById: (id) => getJson(`${BASE_PATH}/${id}`),
  create: (reservation) => postJson(BASE_PATH, reservation),
  getByUserId: (userId) => getJson(`${BASE_PATH}/user/${userId}`),
  update: (id, reservation) => putJson(`${BASE_PATH}/${id}`, reservation),
  createUpdateSession: (reservation) => postJson(`${BASE_PATH}/create-update-checkout-session`, reservation),
  remove: (id) => deleteRequest(`${BASE_PATH}/${id}`),
}

export default reservationsService
