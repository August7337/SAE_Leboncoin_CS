import { reactive } from 'vue'
import api from '@/api/axios'

export const authState = reactive({
  user: JSON.parse(localStorage.getItem('user')) || null,
  token: localStorage.getItem('token') || null,
login(data) {
    const userToSave = data.user || (data.idutilisateur ? data : null);
    const tokenToSave = data.token || data.Token || localStorage.getItem('token');

    if (userToSave) {
        this.user = userToSave;
        localStorage.setItem('user', JSON.stringify(userToSave));
    }

    if (tokenToSave) {
        this.token = tokenToSave;
        localStorage.setItem('token', tokenToSave);
    }

    console.log("Auth System Check:", { 
        hasUser: !!this.user, 
        hasToken: !!this.token,
        fullUser: this.user 
    });
},

  setUser(userData) {
    this.user = userData
    localStorage.setItem('user', JSON.stringify(userData))
  },

  isLoggedIn() {
    return !!this.user && !!this.token
  },

  clearUser() {
    this.user = null
    this.token = null
    localStorage.removeItem('user')
    localStorage.removeItem('token')
  },

  async refreshUser() {
    if (!this.user?.idutilisateur || !this.token) return
    try {
      const response = await api.get(`/utilisateurs/${this.user.idutilisateur}`)
      
      const fresh = response.data
      this.setUser({
        ...this.user,
        solde: fresh.solde,
      })
    } catch (e) {
      console.error('Erreur lors du rafraîchissement du profil utilisateur', e)
      if (e.response && e.response.status === 401) {
        this.clearUser()
      }
    }
  },
})