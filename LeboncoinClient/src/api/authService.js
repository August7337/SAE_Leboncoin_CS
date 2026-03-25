import axios from 'axios'
import api from '@/api/axios'
const API_URL = 'https://localhost:5001/api/auth'

export const registerUser = async (userData) => {
  const response = await api.post(`/register`, userData)
  return response.data
}
