import { reactive } from 'vue'

export const authState = reactive({

  user: JSON.parse(localStorage.getItem('user')) || null,
  
  setUser(userData) {
    this.user = userData; // This line triggers the UI update
    localStorage.setItem('user', JSON.stringify(userData));
  },
  
  clearUser() {
    this.user = null;
    localStorage.removeItem('user');
  }
})