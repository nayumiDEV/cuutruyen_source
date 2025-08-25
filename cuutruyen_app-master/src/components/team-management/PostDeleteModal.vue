<template>
  <div>
    <Modal v-model="show" @confirm="confirm" @cancel="cancel" v-if="post">
      <template v-slot:header>
        Xóa bài viết
      </template>

      <div>
        <p class="mb-4 text-gray-800">Bạn có muốn xóa bài viết không? Bài viết này sẽ bị xóa vĩnh viễn.</p>
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
    post: Object,
    team: Object
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
    post (to, from) {
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

<style scoped>
.line-clamp-3 {
  display: -webkit-box;
  -webkit-line-clamp: 3;
  line-clamp: 3;
  -webkit-box-orient: vertical;
  overflow: hidden;
}
</style>
