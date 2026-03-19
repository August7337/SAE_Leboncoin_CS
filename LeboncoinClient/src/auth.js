import { reactive } from 'vue'

export const authState = reactive({

  user: JSON.parse(localStorage.getItem('user')) || null,
  
  setUser(userData) {
    this.user = userData; 
    localStorage.setItem('user', JSON.stringify(userData));
    console.log(this.user)
  },
  
  isLoggedIn() {
    return !!this.user;
  },
  
  clearUser() {
    this.user = null;
    localStorage.removeItem('user');
  }
})