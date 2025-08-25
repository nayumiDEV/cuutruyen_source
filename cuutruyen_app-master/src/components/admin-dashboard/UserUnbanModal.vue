<template>
  <div>
    <Modal v-model="show" @confirm="confirm" @cancel="cancel" v-if="user">
      <template v-slot:header>
        Gỡ ban người dùng
      </template>

      <div>
        <p class="mb-8 text-gray-800">Bạn có muốn gỡ ban người dùng <strong>{{ user.username }}</strong>?</p>

        <div>
          <div class="mb-4">
            <label for="ban_type" class="label">Cách thức ban</label>

            <div v-if="user.user_ban.ban_type === 'mute'">Mute</div>
            <div v-else-if="user.user_ban.ban_type === 'ban'">Ban</div>
            <div v-else>Shadow Ban</div>
          </div>

          <div class="mb-4">
            <label for="ban_duration" class="label">Thời hạn</label>

            <div v-if="user.user_ban.banned_until">Hết hạn vào {{ user.user_ban.banned_until | humanizeTime }}</div>
            <div v-else>Vô thời hạn</div>
          </div>

          <div class="mb-4">
            <label for="ban_reason" class="label">Lý do</label>

            <div v-if="user.user_ban.reason">{{ user.user_ban.reason }}</div>
            <div v-else class="italic">Chưa ghi lý do</div>
          </div>
        </div>
      </div>

      <template v-slot:footer>
        <button @click="cancel" type="button" class="button px-6 py-2 bg-gray-300 hover:bg-gray-400 text-gray-600 hover:text-gray-700 font-bold mr-3" :disabled="loading">Hủy bỏ</button>
        <button @click="confirm" type="button" class="button px-6 py-2 bg-blue-800 hover:bg-blue-900 font-bold text-white" :disabled="loading">Gỡ ban</button>
      </template>
    </Modal>
  </div>
</template>

<script>
import Modal from '@/components/Modal'
import { unbanUser } from '@/apis/admin'

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
      loading: false
    }
  },

  methods: {
    async confirm () {
      this.loading = true

      try {
        await unbanUser(this.user.id)

        this.$notify({
          type: 'success',
          text: 'Gỡ ban người dùng thành công!'
        })
        this.$emit('confirm')
        this.show = false
      } catch (error) {
        this.$notify({
          type: 'error',
          text: 'Có lỗi xảy ra khi cấm người dùng này!'
        })
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

    show (to, from) {
      if (!to) {
        this.$emit('cancel')
      }
    }
  }
}
</script>
