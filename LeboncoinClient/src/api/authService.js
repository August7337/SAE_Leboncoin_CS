import api from '@/api/axios'

export const registerUser = async (userData) => {
  const response = await api.post(`/register`, userData)
  return response.data
}
