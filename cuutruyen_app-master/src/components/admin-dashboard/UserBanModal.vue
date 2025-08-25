<template>
  <div>
    <Modal v-model="show" @confirm="confirm" @cancel="cancel" v-if="user">
      <template v-slot:header>
        Ban người dùng
      </template>

      <div>
        <p class="mb-4 text-gray-800">Bạn đang chuẩn bị ban người dùng <strong>{{ user.username }}</strong>.</p>

        <div>
          <div class="mb-8">
            <label for="ban_type" class="label">Cách thức ban</label>
            <select v-model="banType" id="ban_type" class="input2 mt-4" :disabled="loading">
              <option value="mute">Mute</option>
              <option value="ban">Ban</option>
              <option value="shadow_ban">Shadow ban</option>
            </select>
          </div>

          <div v-show="banType !== 'shadow_ban'" class="mb-8">
            <label for="ban_duration" class="label">Thời hạn</label>
            <select v-model="banDuration" id="ban_duration" class="input2 mt-4" :disabled="loading">
              <option value="3_days">3 ngày</option>
              <option value="7_days">7 ngày</option>
              <option value="30_days">1 tháng</option>
              <option value="permanent">Vĩnh viễn</option>
            </select>
          </div>

          <div class="mb-8">
            <label for="ban_reason" class="label">Lý do</label>
            <input
              v-model="banReason"
              id="ban_reason"
              class="input2 mt-4"
              type="text" placeholder="Vi phạm điều khoản dịch vụ,..."
              :disabled="loading"
            >
          </div>
        </div>
      </div>

      <template v-slot:footer>
        <button @click="cancel" type="button" class="button px-6 py-2 bg-gray-300 hover:bg-gray-400 text-gray-600 hover:text-gray-700 font-bold mr-3" :disabled="loading">Hủy bỏ</button>
        <button @click="confirm" type="button" class="button px-6 py-2 bg-red-800 hover:bg-red-900 font-bold text-white" :disabled="loading">Xác nhận</button>
      </template>
    </Modal>
  </div>
</template>

<script>
import Modal from '@/components/Modal'
import { banUser } from '@/apis/admin'
import dayjs from 'dayjs'
dayjs.locale('vi')

const bannedUntilConvert = (banDuration) => {
  switch (banDuration) {
    case '3_days':
      return dayjs().add(3, 'day').toISOString()
    case '7_days':
      return dayjs().add(7, 'day').toISOString()
    case '30_days':
      return dayjs().add(30, 'day').toISOString()
    case 'permanent':
      return null
  }
}

export default {
  components: {
    Modal
  },

  props: {
    user: Object
  },

  data () {
    return {
      show: false,
      loading: false,
      banType: 'mute',
      banDuration: '3_days',
      banReason: ''
    }
  },

  methods: {
    async confirm () {
      this.loading = true

      try {
        const bannedUntil = bannedUntilConvert(this.banDuration)

        await banUser(this.user.id, {
          user_ban: {
            ban_type: this.banType,
            banned_until: bannedUntil,
            reason: this.banReason
          }
        })

        this.$notify({
          type: 'success',
          text: 'Ban người dùng thành công!'
        })
        this.banType = 'mute'
        this.banDuration = '3_days'
        this.banReason = ''
        this.$emit('confirm')
        this.show = false
      } catch (error) {
        if (error.response && error.response.status === 422) {
          this.$notify({
            type: 'warn',
            text: 'Vui lòng kiểm tra lại nội dung bạn nhập!'
          })
        } else {
          this.$notify({
            type: 'error',
            text: 'Có lỗi xảy ra khi cấm người dùng này!'
          })
        }
        console.error(error)
      } finally {
        this.loading = false
      }
    },

    cancel () {
      this.show = false
    },

    close () {
      this.$emit('')
    }
  },

  watch: {
    user (to, from) {
      if (to) {
        this.show = true
      }
    },

    banType (to, from) {
      if (to === 'shadow_ban' && from !== 'shadow_ban') {
        this.banDuration = 'permanent'
      }
      if (to !== 'shadow_ban' && from === 'shadow_ban') {
        this.banDuration = '3_days'
      }
    },

    show (to, from) {
      if (!to) {
        this.$emit('cancel')
      }
    }
  }
}
</script>
