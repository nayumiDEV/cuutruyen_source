<template>
  <div class="text-gray-600 flex flex-col gap-4">
    <div class="p-6 bg-white bg-opacity-40 rounded-lg">
      <h2 class="text-gray-600 text-md uppercase font-bold mb-4">Đổi mật khẩu</h2>
      <form @submit.prevent="onSubmit" class="text-gray-600 text-sm mb-4">
        <div class="mb-8">
          <label class="label" for="current_password">
            Mật khẩu hiện tại
          </label>
          <input
            class="input mt-4"
            type="password"
            id="current_password"
            required
            v-model="currentPassword"
          />
        </div>
        <div class="mb-8">
          <label class="label" for="new_password">
            Mật khẩu mới
          </label>
          <input
            class="input mt-4"
            type="password"
            id="new_password"
            required
            v-model="newPassword"
            :disabled="isSubmitting"
          />
          <div class="mt-4 validate" v-if="errors && errors.password">{{ errors.password[0] }}</div>
        </div>
        <div class="mb-8">
          <label class="label" for="confirm_password">
            Xác nhận mật khẩu
          </label>
          <input
            class="input mt-4"
            type="password"
            id="confirm_password"
            required
            v-model="passwordConfirmation"
            :disabled="isSubmitting"
          />
          <div class="mt-4 validate" v-if="errors && errors.password_confirmation">{{ errors.password_confirmation[0] }}</div>
        </div>
        <button class="button button-primary px-8 py-3" :disabled="isSubmitting">
          Đổi mật khẩu
        </button>
      </form>
    </div>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
import { changePassword } from '@/apis/user'

export default {
  data () {
    return {
      currentPassword: '',
      newPassword: '',
      passwordConfirmation: '',
      isSubmitting: false,
      errors: []
    }
  },

  computed: {
    ...mapGetters([
      'currentUser', 'authToken'
    ])
  },

  async mounted () {
  },

  methods: {
    async onSubmit () {
      this.isSubmitting = true
      try {
        await changePassword({
          current_password: this.currentPassword,
          password: this.newPassword,
          password_confirmation: this.passwordConfirmation
        })

        this.$notify({
          type: 'success',
          text: 'Bạn đã đổi mật khẩu thành công!'
        })

        this.errors = []
        this.$store.dispatch('cleanCurrentUser')
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
            text: 'Có lỗi không rõ nguyện nhân khi đổi mật khẩu!'
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
