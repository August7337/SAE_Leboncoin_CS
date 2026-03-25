import axios from 'axios'
import { authState } from '@/auth.js'

const api = axios.create({
  baseURL: 'https://localhost:7057/api'
})

api.interceptors.request.use((config) => {
  if (authState.token) {
    config.headers.Authorization = `Bearer ${authState.token}`
  }
  return config
}, (error) => {
  return Promise.reject(error)
})

export default api