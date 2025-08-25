<template>
  <div>
    <Modal v-model="show" @confirm="confirm" @cancel="cancel" v-if="value">
      <template v-slot:header>
        Cài đặt thông báo
      </template>

      <div>
        <p class="mb-4 text-gray-700">Trình duyệt của bạn hỗ trợ <strong>thông báo đẩy</strong>, nhưng bạn vẫn chưa cài đặt để nhận thông báo.
          Bạn có muốn vào <router-link :to="{ name: 'Configuration' }" class="text-gray-800 hover:text-blue-800 font-bold">thiết lập</router-link> để cài đặt nhận thông báo đẩy không?
        </p>

        <p class="text-gray-700">
          Nhờ thông báo đẩy, Cứu Truyện sẽ <strong>gửi thông báo tức thời</strong> cho bạn ngay khi truyện mà bạn đang theo dõi có chương mới đăng.
        </p>
      </div>

      <template v-slot:footer>
        <button @click="cancel" type="button" class="button px-6 py-2 bg-gray-300 hover:bg-gray-400 text-gray-600 hover:text-gray-700 font-bold mr-3">Lúc khác</button>
        <button @click="confirm" type="button" class="button px-6 py-2 bg-blue-800 hover:bg-blue-900 font-bold text-white">Thiết lập</button>
      </template>
    </Modal>
  </div>
</template>

<script>
import Modal from '@/components/Modal'

export default {
  components: {
    Modal
  },

  props: {
    value: Boolean
  },

  data () {
    return {
      show: false
    }
  },

  methods: {
    confirm () {
      this.$emit('confirm')
      this.$emit('input', false)
    },

    cancel () {
      this.$emit('input', false)
    }
  },

  watch: {
    value (to) {
      if (to) {
        this.show = true
      } else {
        this.show = false
      }
    },

    show (to, from) {
      if (!to) {
        this.cancel()
      }
    }
  }
}
</script>
