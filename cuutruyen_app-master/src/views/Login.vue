<template>
  <div class="min-h-screen w-full flex justify-center items-center bg-gray-300">
    <div class="max-w-screen md:w-5/12 m-4 p-8">
      <div class="w-full flex justify-center">
        <h1 class="text-xl font-head font-bold text-gray-800 mb-12">Đăng nhập</h1>
      </div>

      <form @submit.prevent="formSubmit">
        <div class="mb-8">
          <label for="username" class="label">Tên đăng nhập</label>
          <input
            v-model="username"
            id="username"
            class="input mt-4"
            type="text" placeholder="Tên đăng nhập"
            :disabled="logining"
          >
        </div>

        <div class="mb-8">
          <label for="password" class="label mb-2">Mật khẩu</label>
          <input
            v-model="password"
            id="password"
            class="input mt-4"
            type="password" placeholder="Mật khẩu"
            :disabled="logining"
          >
        </div>

        <div class="mb-8 flex items-center">
          <input class="mr-2" type="checkbox" id="rememberMe" value="false" v-model="rememberMe"
            :disabled="logining"
          >
          <label class="label" for="rememberMe">Ghi nhớ mật khẩu</label>
        </div>

        <div class="w-full flex justify-center mb-8">
          <button
            class="button button-primary px-8 py-3"
            :class="{ 'button-disabled': logining }"
            :disabled="logining"
          >
            Đăng nhập
          </button>
        </div>

        <div class="flex flex-col md:flex-row justify-center gap-4">
          <router-link
            :to="{ name: 'RequestResetPassword' }"
            class="text-sm font-bold text-blue-500 hover:text-blue-700 transition"
          >Quên mật khẩu?</router-link>
          <router-link
            :to="{ name: 'Register' }"
            class="text-sm font-bold text-blue-500 hover:text-blue-700 transition"
          >Đăng ký tài khoản</router-link>
        </div>
      </form>
    </div>
  </div>
</template>

<script>
import { mapActions } from 'vuex'
import { login } from '@/apis/user'
import db from '@/db'
import * as WebPush from '@/lib/web-push'

export default {
  data () {
    return {
      username: '',
      password: '',
      rememberMe: false,
      logining: false
    }
  },

  methods: {
    ...mapActions(['createCurrentUser']),

    async formSubmit () {
      try {
        this.logining = true

        const response = await login(this.username, this.password)

        const currentUser = response.data

        await this.createCurrentUser({ currentUser: currentUser, authToken: response.auth_token, rememberMe: this.rememberMe, db: db })

        this.$notify({
          type: 'success',
          text: 'Đăng nhập thành công!'
        })

        this.$gtag.event('login')

        await WebPush.subscribe(currentUser.id)

        this.$router.push({ name: 'Home' })
      } catch (error) {
        if (error.response && error.response.status === 422) {
          this.$notify({
            type: 'warn',
            text: 'Sai tên đăng nhập hoặc mật khẩu!'
          })
        } else {
          this.$notify({
            type: 'error',
            text: 'Lỗi không xác định đã xảy ra, mong bạn thử lại sau!'
          })
        }
        console.error(error)
      } finally {
        this.logining = false
      }
    }
  }
}
</script>
