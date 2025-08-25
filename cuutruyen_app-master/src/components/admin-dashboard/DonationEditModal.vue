<template>
  <div>
    <Modal v-model="show" @confirm="confirm" @cancel="cancel" v-if="currentDonation">
      <template v-slot:header>
        Sửa quyên góp
      </template>

      <div>
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
            <input
              v-model.number="amount"
              id="donation_amount"
              class="input2"
              type="number"
              placeholder="Số tiền"
              :disabled="loading"
              step="1"
              min="0"
            >
            <div class="text-gray-600">VNĐ</div>
          </div>
        </div>

        <div class="mb-4">
          <label for="donation_message" class="label">Nội dung</label>
          <textarea
            v-model="currentDonation.message"
            id="donation_message"
            class="textarea2 mt-2"
            placeholder="Nội dung"
            :disabled="loading"
          ></textarea>
        </div>

        <div class="mb-4">
          <label for="donation_message" class="label">Thời gian</label>
          <input
            v-model="formattedDate"
            id="donation_message"
            class="input2 mt-2"
            type="datetime-local"
            placeholder="Thời gian"
            :disabled="loading"
            step="1"
          >
        </div>
      </div>

      <template v-slot:footer>
        <div class="flex gap-2">
          <button @click="cancel" type="button" class="button px-6 py-2 button-bare" :disabled="loading">Hủy bỏ</button>
          <button @click="confirm" type="button" class="button px-6 py-2 button-primary" :disabled="loading">Xác nhận</button>
        </div>
      </template>
    </Modal>
  </div>
</template>

<script>
import Modal from '@/components/Modal'
import { updateAdminDonation } from '@/apis/admin'
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

  computed: {
    amount: {
      get () {
        return Math.floor(this.currentDonation?.amount || 0)
      },
      set (value) {
        if (this.currentDonation) {
          this.currentDonation.amount = Math.floor(Number(value) || 0)
        }
      }
    },
    formattedDate: {
      get () {
        return this.currentDonation?.created_at
          ? dayjs(this.currentDonation.created_at).format('YYYY-MM-DDTHH:mm:ss')
          : ''
      },
      set (value) {
        if (this.currentDonation && value) {
          this.currentDonation.created_at = dayjs(value).toISOString()
        }
      }
    }
  },

  methods: {
    async confirm () {
      this.loading = true

      try {
        await updateAdminDonation(this.currentDonation.id, {
          donation: {
            unique_code: this.currentDonation.unique_code,
            sepay_id: this.currentDonation.sepay_id,
            sepay_reference_code: this.currentDonation.sepay_reference_code,
            amount: this.currentDonation.amount,
            message: this.currentDonation.message,
            created_at: this.currentDonation.created_at
          }
        })

        this.$notify({
          type: 'success',
          text: 'Sửa quyên góp thành công!'
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
            text: 'Có lỗi xảy ra khi sửa quyên góp!'
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
