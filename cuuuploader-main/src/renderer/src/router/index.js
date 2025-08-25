import { createRouter, createWebHashHistory } from 'vue-router'

import Home from '../views/Home.vue'
import Login from '../views/Login.vue'
import Manga from '../views/Manga.vue'
import UploadStepOne from '../views/upload/StepOne.vue'
import UploadStepTwo from '../views/upload/StepTwo.vue'
import UploadStepThree from '../views/upload/StepThree.vue'

const router = createRouter({
  history: createWebHashHistory(),
  routes: [
    { path: '/', component: Home },
    { path: '/login', component: Login },
    { path: '/manga/:id', component: Manga },
    { path: '/upload/:id', component: UploadStepOne },
    { path: '/upload/:id/step-two', component: UploadStepTwo },
    { path: '/upload/:id/step-three', component: UploadStepThree }
  ]
})

export default router
