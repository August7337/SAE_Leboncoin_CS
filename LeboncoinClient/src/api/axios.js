import axios from 'axios'
import { authState } from '@/auth.js'

const api = axios.create({
  baseURL: import.meta.env.VITE_API_BASE_URL
    ? `${import.meta.env.VITE_API_BASE_URL}/api`
    : 'https://leboncoinapi-b0b2bmazh9ebdqef.spaincentral-01.azurewebsites.net/api'
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