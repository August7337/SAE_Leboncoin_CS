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

  hasPermission(permissionName) {
    if (!this.user || !this.user.permissions) return false
    return this.user.permissions.includes(permissionName)
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
      const [profileRes, authRes] = await Promise.all([
        api.get(`/utilisateurs/${this.user.idutilisateur}`),
        api.get(`/utilisateurs/${this.user.idutilisateur}/auth-profile`),
      ])

      this.setUser({
        ...this.user,
        solde: profileRes.data.solde,
        roles: authRes.data.roles,
        permissions: authRes.data.permissions,
      })
    } catch (e) {
      console.error('[refreshUser] Erreur lors du rafraîchissement :', e?.response?.status, e?.response?.data ?? e?.message)
      if (e.response && e.response.status === 401) {
        this.clearUser()
      }
    }
  },
})