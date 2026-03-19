import axios from 'axios'

const API_URL = 'https://localhost:5001/api/auth'

export const registerUser = async (userData) => {
  const response = await axios.post(`${API_URL}/register`, userData)
  return response.data
}
