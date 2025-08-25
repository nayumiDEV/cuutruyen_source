<template>
  <div>
    <Modal v-model="show" @confirm="confirm" @cancel="cancel" v-if="show">
      <template v-slot:header>
        Gỡ bỏ bình luận
      </template>

      <div v-if="comment.user.username === currentUser.username">
        <p>Bạn có muốn gỡ bỏ bình luận này?</p>
      </div>

      <div v-else>
        <p class="mb-4">Vui lòng nhập lý do gỡ bỏ bình luận</p>

        <select v-model="selectedReason" class="input-dark">
          <option v-for="(reason, index) in reasons" :value="index" :key="index">{{ reason }}</option>
        </select>

        <textarea v-if="selectedReason === reasons.length - 1" class="textarea-dark mt-4" v-model="reason" placeholder="Nhập lý do gỡ bỏ bình luận..."></textarea>
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
      show: false,
      reasons: [
        'Spam hoặc quảng cáo',
        'Sử dụng ngôn từ thô tục',
        'Nội dung không lành mạnh hoặc không hợp pháp',
        'Lý do khác'
      ],
      selectedReason: 0,
      reason: ''
    }
  },

  methods: {
    confirm () {
      this.$emit('confirm', this.reason)
      this.show = false
    },

    cancel () {
      this.show = false
    },

    close () {
      this.$emit('')
    }
  },

  mounted () {
    this.reason = this.reasons[0]
  },

  watch: {
    isShow (to, from) {
      if (to & !from) {
        this.show = true
        this.selectedReason = 0
        this.reason = ''
      }
    },

    selectedReason (to, from) {
      if (to !== this.reasons.length - 1) {
        this.reason = this.reasons[to]
      } else {
        this.reason = ''
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
