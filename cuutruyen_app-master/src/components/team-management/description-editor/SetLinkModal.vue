<template>
  <div>
    <Modal v-model="show" @confirm="confirm" @cancel="cancel" v-if="value">
      <template v-slot:header>
        Chèn liên kết
      </template>

      <div>
        <input v-model="href" type="text" class="h-10 w-full px-4 py-2 rounded-lg fine-transition bg-gray-100 placeholder-gray-400 outline-none focus:ring" placeholder="https://">
      </div>

      <template v-slot:footer>
        <button @click="cancel" type="button" class="button px-6 py-2 bg-gray-300 hover:bg-gray-400 text-gray-600 hover:text-gray-700 font-bold mr-3">Hủy</button>
        <button @click="confirm" type="button" class="button button-primary px-6 py-2" :class="{ 'button-disabled': !href }" :disabled="!href">Xác nhận</button>
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
      show: false,
      href: ''
    }
  },

  methods: {
    confirm () {
      this.$emit('confirm', this.href)
      this.href = ''
      this.$emit('input', false)
    },

    cancel () {
      this.href = ''
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
