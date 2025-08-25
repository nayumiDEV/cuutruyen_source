<template>
  <div class="min-h-screen w-full flex justify-center items-center bg-gray-300">
    <div class="max-w-screen md:w-5/12 m-4 p-8">
      <div class="w-full flex justify-center">
        <h1 class="text-xl font-head font-bold text-gray-800 mb-12">Đặt lại mật khẩu</h1>
      </div>

      <form @submit.prevent="onSubmit">
        <div class="mb-8">
          <div class="label">
            Email đang đặt lại mật khẩu:
          </div>
          <div class="mt-4 text-sm text-gray-700">
            {{ $route.query.email }}
          </div>
        </div>
        <div class="mb-8">
          <label for="password" class="label">Mật khẩu mới</label>
          <input
            v-model="password"
            id="password"
            class="input mt-4"
            type="password" placeholder="Mật khẩu"
            :disabled="isSubmitting"
          >
          <div class="mb-4 validate" v-if="errors && errors.password">{{ errors.password[0] }}</div>
        </div>

        <div class="mb-8">
          <label for="passwordConfirmation" class="label">Nhập lại mật khẩu mới</label>
          <input
            v-model="passwordConfirmation"
            id="passwordConfirmation"
            class="input mt-4"
            type="password" placeholder="Nhập lại mật khẩu"
            :disabled="isSubmitting"
          >
          <div class="mt-4 validate" v-if="errors && errors.password_confirmation">{{ errors.password_confirmation[0] }}</div>
        </div>

        <div class="w-full flex justify-center mb-8">
          <button
            class="button button-primary px-8 py-3"
            :class="{ 'button-disabled': isSubmitting }"
            :disabled="isSubmitting"
          >
            Đặt lại mật khẩu
          </button>
        </div>
      </form>
    </div>
  </div>
</template>

<script>
import { resetPassword } from '@/apis/user'

export default {
  data () {
    return {
      password: '',
      passwordConfirmation: '',
      isSubmitting: false,
      errors: []
    }
  },

  methods: {
    async onSubmit () {
      this.isSubmitting = true
      try {
        await resetPassword({
          email: this.$route.query.email,
          token: this.$route.query.token,
          password: this.password,
          password_confirmation: this.passwordConfirmation
        })

        this.$notify({
          type: 'success',
          text: 'Đã thay đổi mật khẩu thành công! Vui lòng đăng nhập lại.'
        })

        this.errors = []
        this.$router.push('/login')
      } catch (error) {
        const response = await error.response.json()
        if (response) {
          this.$notify({
            type: 'error',
            text: response.message
          })
          this.errors = response.data
        } else {
          this.$notify({
            type: 'error',
            text: 'Có lỗi không rõ nguyện nhân khi đặt lại mật khẩu!'
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
