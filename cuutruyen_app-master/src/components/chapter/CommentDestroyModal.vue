<template>
  <div>
    <Modal v-model="show" @confirm="confirm" @cancel="cancel" v-if="show">
      <template v-slot:header>
        Xóa bình luận
      </template>

      <div>
        <p>Bạn có muốn xóa vĩnh viễn bình luận này?</p>
      </div>

      <template v-slot:footer>
        <button @click="cancel" type="button" class="button px-6 py-2 bg-gray-900 hover:bg-gray-800 text-gray-300 font-bold mr-3">Hủy bỏ</button>
        <button @click="confirm" type="button" class="button px-6 py-2 bg-red-800 hover:bg-red-900 font-bold text-red-100">Xác nhận</button>
      </template>
    </Modal>
  </div>
</template>

<script>
import Modal from '@/components/ModalDark'
import { mapGetters } from 'vuex'

export default {
  components: {
    Modal
  },

  props: {
    comment: Object,
    isShow: Boolean
  },

  computed: {
    ...mapGetters([
      'currentUser'
    ])
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
    },

    close () {
      this.$emit('')
    }
  },

  watch: {
    isShow (to, from) {
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
