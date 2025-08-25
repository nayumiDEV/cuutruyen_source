<template>
  <div>
    <Modal v-model="show" @confirm="confirm" @cancel="cancel" v-if="chapter && manga">
      <template v-slot:header>
        Xóa chương
      </template>

      <div>
        <p class="mb-4 text-gray-800">Bạn có muốn xóa
          <b>Chương {{ chapter.number }}</b>
          <span v-if="chapter.name" class="font-bold">. {{ chapter.name }}</span>
          của truyện <b>{{ manga.name }}</b> không?
        </p>
      </div>

      <template v-slot:footer>
        <button @click="cancel" type="button" class="button px-6 py-2 bg-gray-300 hover:bg-gray-400 text-gray-600 hover:text-gray-700 font-bold mr-3">Hủy bỏ</button>
        <button @click="confirm" type="button" class="button px-6 py-2 bg-red-800 hover:bg-red-900 font-bold text-white">Xóa</button>
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
    chapter: Object,
    manga: Object
  },

  data () {
    return {
      show: false
    }
  },

  methods: {
    confirm () {
      this.$emit('confirm')
      this.show = false
    },

    cancel () {
      this.show = false
    }
  },

  watch: {
    chapter (to, from) {
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
