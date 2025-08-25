<template>
  <div>
    <Modal v-model="show" @confirm="confirm" @cancel="cancel" v-if="currentDonation">
      <template v-slot:header>
        Xóa quyên góp
      </template>

      <div>
        <p class="mb-8">Bạn có chắc chắn muốn xóa quyên góp này?</p>

        <div class="mb-4">
          <label class="label">Mã chuyển khoản</label>
          <div class="mt-2">
            {{ currentDonation.unique_code }}
          </div>
        </div>

        <div class="mb-4">
          <label class="label">Sepay ID</label>
          <div class="mt-2">
            {{ currentDonation.sepay_id }}
          </div>
        </div>

        <div class="mb-4">
          <label class="label">Sepay Reference Code</label>
          <div class="mt-2">
            {{ currentDonation.sepay_reference_code }}
          </div>
        </div>

        <div class="mb-4">
          <label class="label">Người quyên góp</label>
          <div class="mt-2">
            <div v-if="currentDonation.user" class="flex items-center gap-2 font-bold text-sm text-gray-600">
                <div class="avatar">
                  {{ currentDonation.user.username[0] }}
                </div>
                {{ currentDonation.user.username }}
              </div>
            <div v-else>
              Ẩn danh
            </div>
          </div>
        </div>

        <div class="mb-4">
          <label for="donation_amount" class="label">Số tiền</label>
          <div class="flex items-center gap-2 mt-2">
            {{ currentDonation.amount | formatCurrency }}
          </div>
        </div>

        <div class="mb-4">
          <label for="donation_message" class="label">Nội dung</label>
          <div class="mt-2">
            {{ currentDonation.message }}
          </div>
        </div>

        <div class="mb-4">
          <label for="donation_message" class="label">Thời gian</label>
          <div class="mt-2">
            {{ currentDonation.created_at | humanizeTime }}
          </div>
        </div>
      </div>

      <template v-slot:footer>
        <div class="flex gap-2">
          <button @click="cancel" type="button" class="button px-6 py-2 button-bare" :disabled="loading">Hủy bỏ</button>
          <button @click="confirm" type="button" class="button px-6 py-2 button-danger-primary" :disabled="loading">Xác nhận</button>
        </div>
      </template>
    </Modal>
  </div>
</template>

<script>
import Modal from '@/components/Modal'
import { deleteAdminDonation } from '@/apis/admin'
import dayjs from 'dayjs'
import 'dayjs/locale/vi'
dayjs.locale('vi')

export default {
  components: {
    Modal
  },

  props: {
    donation: Object
  },

  data () {
    return {
      show: false,
      loading: false,
      currentDonation: null
    }
  },

  filters: {
    formatCurrency (amount) {
      return new Intl.NumberFormat('vi-VN', {
        style: 'currency',
        currency: 'VND',
        minimumFractionDigits: 0,
        maximumFractionDigits: 0
      }).format(amount)
    }
  },

  methods: {
    async confirm () {
      this.loading = true

      try {
        await deleteAdminDonation(this.currentDonation.id)

        this.$notify({
          type: 'success',
          text: 'Xóa quyên góp thành công!'
        })
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
            text: 'Có lỗi xảy ra khi xóa quyên góp!'
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
    donation (to, from) {
      if (to) {
        this.currentDonation = structuredClone(to)
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
