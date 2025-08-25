<template>
  <div class="min-h-screen w-full flex justify-center items-center bg-gray-300">
    <div class="max-w-screen md:w-5/12 m-4 p-8">
      <div class="w-full flex justify-center">
        <h1 class="text-xl font-head font-bold text-gray-800 mb-12">Quên mật khẩu</h1>
      </div>

      <form @submit.prevent="onSubmit">
        <div class="mb-8">
          <label for="email" class="label">Địa chỉ Email</label>
          <input
            v-model="email"
            id="email"
            class="input mt-4"
            type="email" placeholder="Nhập địa chỉ Email của bạn"
            :disabled="isSubmitting"
          >
        </div>

        <div class="w-full flex justify-center mb-8">
          <button
            class="button button-primary px-8 py-3"
            :class="{ 'button-disabled': isSubmitting }"
            :disabled="isSubmitting"
          >
            Khôi phục mật khẩu
          </button>
        </div>

        <div class="flex flex-col md:flex-row justify-center gap-4">
          <router-link
            :to="{ name: 'Login' }"
            class="text-sm font-bold text-blue-500 hover:text-blue-700 transition"
          >Đăng nhập</router-link>
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
import { requestResetPassword } from '@/apis/user'

export default {
  data () {
    return {
      email: '',
      isSubmitting: false
    }
  },

  methods: {
    async onSubmit () {
      this.isSubmitting = true
      try {
        await requestResetPassword({
          email: this.email
        })

        this.$notify({
          type: 'success',
          text: 'Yêu cầu khôi phục mật khẩu thành công. Vui lòng kiểm tra Email vừa được Cứu Truyện gửi đến hòm thư của bạn.'
        })

        this.$router.push('/login')
      } catch (error) {
        const response = await error.response.json()
        if (response) {
          this.$notify({
            type: 'error',
            text: response.message
          })
        } else {
          this.$notify({
            type: 'error',
            text: 'Có lỗi không rõ nguyện nhân khi gửi yêu cầu khôi phục mật khẩu!'
          })
          console.error(error)
        }
      } finally {
        this.isSubmitting = false
      }
    }
  }
}
</script>
