import { createApp } from 'vue'
import { createPinia } from 'pinia'

import App from './App.vue'
import router from './router'
import './main.css'
import axios from 'axios'
import { authState } from './auth'

axios.interceptors.request.use((config) => {
    if (authState.token) {
        config.headers.Authorization = `Bearer ${authState.token}`;
    }
    return config;
}, (error) => {
    return Promise.reject(error);
});

axios.interceptors.response.use(
    (response) => response,
    (error) => {
        if (error.response && error.response.status === 401) {
            authState.logout();
        }
        return Promise.reject(error);
    }
);

const app = createApp(App)

app.use(createPinia())
app.use(router)

app.mount('#app')
