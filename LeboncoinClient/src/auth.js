import { reactive } from 'vue'
import axios from 'axios'

export const authState = reactive({
  user: JSON.parse(localStorage.getItem('user')) || null,

  setUser(userData) {
    this.user = userData
    localStorage.setItem('user', JSON.stringify(userData))
  },

  isLoggedIn() {
    return !!this.user
  },

  clearUser() {
    this.user = null
    localStorage.removeItem('user')
  },

  async refreshUser() {
    if (!this.user?.idutilisateur) return
    try {
      const response = await axios.get(`/api/utilisateurs/${this.user.idutilisateur}`)
      const fresh = response.data
      this.setUser({
        ...this.user,
        solde: fresh.solde,
      })
    } catch (e) {
      console.error('Erreur lors du rafraîchissement du profil utilisateur', e)
    }
  },
})