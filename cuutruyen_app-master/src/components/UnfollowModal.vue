<template>
  <div>
    <Modal v-model="show" @confirm="confirm" @cancel="cancel" v-if="value">
      <template v-slot:header>
        Hủy theo dõi
      </template>

      <div>
        <p class="text-gray-700">
          Bạn có muốn xóa truyện này khỏi <router-link class="text-gray-800 hover:text-blue-900 font-bold" :to="{ name: 'Following' }">danh sách theo dõi</router-link> của bạn?
        </p>
      </div>

      <template v-slot:footer>
        <button @click="cancel" type="button" class="button px-6 py-2 bg-gray-300 hover:bg-gray-400 text-gray-600 hover:text-gray-700 font-bold mr-3 text-sm">Hủy bỏ</button>
        <button @click="confirm" type="button" class="button px-6 py-2 bg-red-700 hover:bg-red-900 font-bold text-white text-sm">Đồng ý</button>
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
