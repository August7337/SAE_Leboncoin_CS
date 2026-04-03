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
      const [profileResult, authResult] = await Promise.allSettled([
        api.get(`/utilisateurs/${this.user.idutilisateur}`),
        api.get(`/utilisateurs/${this.user.idutilisateur}/auth-profile`),
      ])

      if (profileResult.status === 'rejected') {
        const e = profileResult.reason
        console.error('[refreshUser] Erreur profil :', e?.response?.status, e?.response?.data ?? e?.message)
        if (e?.response?.status === 401) { this.clearUser(); return }
      }

      if (authResult.status === 'rejected') {
        console.error('[refreshUser] Erreur auth-profile :', authResult.reason?.response?.status, authResult.reason?.response?.data ?? authResult.reason?.message)
      }

      this.setUser({
        ...this.user,
        ...(profileResult.status === 'fulfilled' ? { solde: profileResult.value.data.solde } : {}),
        ...(authResult.status === 'fulfilled' ? { roles: authResult.value.data.roles, permissions: authResult.value.data.permissions } : {}),
      })
    } catch (e) {
      console.error('[refreshUser] Erreur inattendue :', e?.message)
    }
  },
})