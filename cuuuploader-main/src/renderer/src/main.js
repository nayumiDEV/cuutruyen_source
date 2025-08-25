import './assets/main.css'
import 'vue-final-modal/style.css'
import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import { createVfm } from 'vue-final-modal'
import Loading from './components/Loading.vue'
import Toast from 'vue-toastification'
import 'vue-toastification/dist/index.css'

const vfm = createVfm()

createApp(App).use(router).use(vfm).use(Toast).component('Loading', Loading).mount('#app')
