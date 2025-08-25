<template>
  <div class="min-h-screen w-full flex justify-center items-center bg-gray-300">
    <div class="max-w-screen md:w-5/12 m-4 p-8">
      <div class="w-full flex justify-center">
        <h1 class="text-xl font-head font-bold text-gray-800 mb-12">Đăng ký</h1>
      </div>

      <form @submit.prevent="formSubmit">
        <div class="mb-8">
          <label for="username" class="label">Tên đăng nhập</label>
          <input
            v-model="user.username"
            id="username"
            class="input mt-4"
            type="text" placeholder="Tên đăng nhập"
            :disabled="loading"
          >
          <div class="mt-4 validate" v-if="errors && errors.username">{{ errors.username[0] }}</div>
        </div>

        <div class="mb-8">
          <label for="email" class="label">Email</label>
          <input
            v-model="user.email"
            id="email"
            class="input mt-4"
            type="text" placeholder="Email"
            :disabled="loading"
          >
          <div class="mt-4 validate" v-if="errors && errors.email">{{ errors.email[0] }}</div>
        </div>

        <div class="mb-8">
          <label for="password" class="label">Mật khẩu</label>
          <input
            v-model="user.password"
            id="password"
            class="input mt-4"
            type="password" placeholder="Mật khẩu"
            :disabled="loading"
          >
          <div class="mt-4 validate" v-if="errors && errors.password">{{ errors.password[0] }}</div>
        </div>

        <div class="mb-8">
          <label for="password-confirmation" class="label">Nhập lại mật khẩu</label>
          <input
            v-model="user.password_confirmation"
            id="password-confirmation"
            class="input mt-4"
            type="password" placeholder="Nhập lại mật khẩu"
            :disabled="loading"
          >
          <div class="mt-4 validate" v-if="errors && errors.password_confirmation">{{ errors.password_confirmation[0] }}</div>
        </div>

        <div class="mb-8">
          <div class="flex justify-center">
            <img :src="`data:image/png;base64, ${captchaBase64Image}`" alt="Captcha" width="390" height="120" class="w-full" />
          </div>

          <input
            v-model="user.captcha_phrase"
            id="captcha-phrase"
            class="input mt-4"
            type="text" placeholder="Nhập captcha"
            :disabled="loading"
          >

          <div class="mt-4 validate" v-if="errors && errors.captcha_phrase">{{ errors.captcha_phrase[0] }}</div>

          <div class="text-xs text-gray-500 mt-4">Captcha nhập vào là dạng tiếng Việt có dấu, không phân biệt chữ hoa hay thường.</div>
          <div class="text-xs text-gray-500 mt-4"><a href="#" @click.prevent="renewCaptcha" class="text-blue-600 hover:text-blue-700 text-xs">Làm mới captcha</a> nếu captcha bạn gặp phải quá khó đọc.</div>
        </div>

        <div class="mb-8">
          <div class="flex items-center">
            <input class="mr-2" type="checkbox" id="accept" value="false" v-model="user.accept"
              :disabled="loading"
            >
            <label class="text-xs uppercase tracking-wide text-gray-700 font-semibold" for="accept">Tôi đồng ý với <a href="https://cuutruyen.net/PrivacyPolicy" class="text-blue-500 hover:text-blue-700" target="_blank">điều khoản dịch vụ & chính sách bảo mật</a></label>
          </div>

          <div class="mt-4 validate" v-if="errors && errors.accept">{{ errors.accept[0] }}</div>
        </div>

        <div class="w-full flex justify-center mb-8">
          <button
            class="button button-primary px-8 py-3 text-lg"
            :class="{ 'button-disabled': loading }"
            :disabled="loading"
          >
            Đăng ký
          </button>
        </div>

        <div class="flex flex-col md:flex-row justify-center gap-4">
          <router-link
            :to="{ name: 'Login' }"
            class="text-sm font-bold text-blue-500 hover:text-blue-700 transition"
          >Đăng nhập</router-link>
          <router-link
            :to="{ name: 'RequestResetPassword' }"
            class="text-sm font-bold text-blue-500 hover:text-blue-700 transition"
          >Quên mật khẩu?</router-link>
        </div>
      </form>
    </div>
  </div>
</template>

<script>
import { mapActions } from 'vuex'
import { register, generateCaptcha } from '@/apis/user'

export default {
  data () {
    return {
      user: {
        username: '',
        password: '',
        password_confirmation: '',
        email: '',
        accept: false,
        captcha_identifer: null,
        captcha_phrase: ''
      },
      loading: false,
      captchaBase64Image: null,
      errors: null
    }
  },

  methods: {
    ...mapActions(['createCurrentUser']),

    async formSubmit () {
      this.loading = true

      try {
        const response = await register({ user: this.user })

        await this.createCurrentUser({ currentUser: response.data, authToken: response.auth_token, rememberMe: false })

        this.$notify({
          type: 'success',
          text: 'Bạn đã đăng ký tài khoản mới thành công!'
        })

        this.$gtag.event('sign_up')

        this.$router.push({ name: 'Home' })
      } catch (error) {
        this.renewCaptcha()
        if (error.response && error.response.status === 422) {
          const response = await error.response.json()
          this.errors = response.data

          const firstErrorField = Object.keys(response.data)[0]
          const firstErrorMessage = response.data[firstErrorField][0]

          this.$notify({
            type: 'warn',
            text: firstErrorMessage
          })
          console.error(error)
        } else {
          this.$notify({
            type: 'error',
            text: 'Có lỗi xảy ra khi đăng ký tài khoản.'
          })

          throw error
        }
      } finally {
        this.loading = false
      }
    },

    async renewCaptcha () {
      const response = await generateCaptcha()
      this.user.captcha_identifer = response.data.identifer
      this.user.captcha_phrase = ''
      this.captchaBase64Image = response.data.base64_image
    }
  },

  async mounted () {
    this.renewCaptcha()
  }
}
</script>
