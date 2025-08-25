<template>
  <div class="overflow-hidden min-h-screen">
    <div class="py-8 lg:py-16 px-2">
      <div class="pt-12" />
      <div class="common-container flex flex-col lg:flex-row gap-4 items-center justify-center">
        <div class="flex-1 mb-8 lg:mb-0">
          <div class="love-letter-container">
            <div class="relative z-10">
              <div class="flex justify-center w-full mb-4">
                <HeartIcon :size="48" class="text-pink-500 animate-pulse" />
              </div>
              <div class="love-letter-heading mb-7 text-center">
                Cứu Truyện tồn tại là nhờ có bạn!
              </div>
              <div class="love-letter-body">
                <p class="mb-4">
                  Cứu Truyện được thành lập vào năm 2020 với mong muốn xây dựng một cộng đồng truyện tranh lành mạnh, nơi
                  tôn trọng công sức của tác giả và các nhóm dịch truyện. Chúng mình hoạt động hoàn toàn phi lợi nhuận,
                  miễn phí và không có quảng cáo, để mọi người đều có thể tận hưởng truyện một cách trọn vẹn nhất.
                </p>
                <p class="mb-4">
                  Trong quá trình phát triển, Cứu Truyện đã nhận được rất nhiều tình cảm và sự ủng hộ từ các bạn. Để tiếp
                  tục duy trì và nâng cao chất lượng website, chúng mình rất mong nhận được sự đóng góp và đồng hành từ
                  bạn. <span class="love-letter-highlight">Mỗi sự ủng hộ của bạn đều là động lực lớn giúp Cứu Truyện ngày
                    càng phát triển!</span>
                </p>
              </div>
              <div class="love-letter-flourish">
                <svg width="60" height="24" viewBox="0 0 60 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                  <path d="M2 12 Q20 24 30 12 Q40 0 58 12" stroke="#f472b6" stroke-width="2" fill="none" />
                </svg>
              </div>
            </div>
            <div class="love-letter-background" />
          </div>
        </div>

        <div v-if="loading" class="flex-1 flex flex-col justify-center items-center w-full">
          <div class="animate-spin"><LoadingIcon :size="32" /></div>
        </div>

        <div v-else-if="!bankingOrder" class="flex-1 flex flex-col justify-center items-center w-full">
          <!-- Donation Amount Selection -->
          <div class="w-full mb-6">
            <label class="block text-lg font-semibold mb-2 text-gray-800">Số tiền quyên góp</label>
            <div class="grid grid-cols-2 gap-2">
              <button v-for="amount in amounts" :key="amount.value" type="button"
                class="donate-btn flex flex-col md:flex-row items-center justify-between"
                :class="selectedAmount === amount.value ? 'donate-btn--selected' : ''"
                @click="selectAmount(amount.value)">
                <span>{{ amount.label }}</span>
                <div class="flex ml-2 gap-[2px]">
                  <HeartOutlineIcon :size="16" v-for="n in amount.hearts" :key="n" class="text-pink-400" />
                </div>
              </button>
              <button type="button" class="donate-btn flex flex-col md:flex-row items-center justify-between"
                :class="isCustomAmount ? 'donate-btn--selected' : ''" @click="selectCustomAmount">
                <span>Chọn số tiền khác</span>
                <div class="flex ml-2">
                  <HelpCircleOutlineIcon :size="16" class="text-pink-400" />
                </div>
              </button>
            </div>

            <div v-if="isCustomAmount" class="flex items-center mt-4">
              <input v-model="customAmount" type="number" min="2000" step="1000" placeholder="Nhập số tiền (VND)"
                class="flex-1 rounded-lg px-3 py-2 focus:ring-2 focus:ring-pink-500 outline-none transition duration-500" />
            </div>
          </div>

          <!-- Donate As Selection -->
          <div class="w-full mb-6">
            <label class="block text-lg font-semibold mb-2 text-gray-800">Quyên góp với tư cách</label>
            <div class="flex flex-row gap-2">
              <button type="button" class="donate-btn flex-1"
                :class="donateAs === 'account' ? 'donate-btn--selected' : ''" @click="donateAs = 'account'"
                :disabled="!currentUser">
                <div>Dùng tài khoản Cứu Truyện</div>
                <div v-if="!currentUser" class="text-xs font-medium text-yellow-500">Vui lòng đăng nhập trước</div>
                <div v-else class="text-xs font-medium text-green-700">Đã đăng nhập là {{ currentUser.username }}</div>
              </button>
              <button type="button" class="donate-btn flex-1"
                :class="donateAs === 'anonymous' ? 'donate-btn--selected' : ''" @click="donateAs = 'anonymous'">
                Ẩn danh
              </button>
            </div>

            <div v-if="donateAs === 'account'" class="text-center text-xs text-gray-600 mt-2">
              Bạn sẽ nhận được
              <span class="text-blue-600 font-semibold inline-flex">{{ Math.round((selectedAmount || customAmount)/1000) }} <FireIcon :size="16" /></span> Chakra
              thay cho lời cảm ơn từ đội ngũ Cứu Truyện.
              Trong tương lai, bạn có thể sử dụng Chakra để đổi lấy một vài quyền lợi nho nhỏ trong Cứu Truyện.
            </div>
          </div>

          <!-- Say Something Good -->
          <div class="w-full mb-6">
            <label class="block text-lg font-semibold mb-2 text-gray-800">Gửi lời chúc tốt đẹp</label>
            <textarea v-model="message" maxlength="1000" rows="3"
              placeholder="Viết lời chúc, động viên... (tối đa 1000 ký tự)"
              class="w-full rounded-lg px-3 py-2 focus:ring-2 focus:ring-pink-500 outline-none resize-none transition duration-500"></textarea>
            <div class="text-right text-xs text-gray-700 mt-1">{{ message.length }}/1000 ký tự</div>
          </div>

          <!-- Submit Button -->
          <div class="w-full flex justify-center">
            <button @click="submitDonation"
              class="w-full bg-pink-500 hover:bg-pink-600 text-white font-semibold py-2 rounded-lg shadow transition duration-500">
              Tạo mã QR
            </button>
          </div>
        </div>

        <div v-else class="flex-1 flex flex-col justify-center items-center w-full">
          <template v-if="bankingOrder.paid_at">
            <div class="flex flex-col items-center gap-4 p-6 rounded-xl bg-green-50/50 mb-6">
              <div class="flex flex-row items-center gap-2 text-green-600">
                <CheckCircleIcon :size="32" class="text-green-500" />
                <p class="text-center text-sm uppercase font-bold">Cứu Truyện đã nhận được quyên góp của bạn!</p>
              </div>

              <div class="flex flex-row items-center gap-2">
                <div class="rounded-lg bg-white text-green-600 px-6 py-3 border border-green-200 shadow-sm">
                  <p class="text-center text-3xl font-bold">{{ Math.round(bankingOrder.amount).toLocaleString('vi-VN') }} VND</p>
                </div>
              </div>

              <div class="text-center text-gray-600 mt-2">
                <p class="mb-1 text-sm uppercase">Cảm ơn bạn đã ủng hộ Cứu Truyện!</p>
              </div>

              <div v-if="bankingOrder.message" class="mt-4 p-4 bg-white rounded-lg border border-gray-300 w-full">
                <p class="text-xs text-gray-500 mb-1 font-bold">Lời nhắn của bạn:</p>
                <p class="text-gray-700 font-medium">{{ bankingOrder.message }}</p>
              </div>
            </div>

            <div class="flex justify-center">
              <button
                type="button"
                class="close-btn"
                @click="clearOrder"
              >
                <CloseIcon :size="16" />
                <span>Đóng</span>
              </button>
            </div>
          </template>

          <template v-else>
            <div class="flex justify-center mb-8 w-[80%] max-w-[300px] aspect-square h-auto">
              <img :src="bankingOrder.qr_url" alt="" width="300" height="300" class="w-full h-full">
            </div>
            <div class="mb-4 w-full">
              <p class="text-xs font-bold uppercase text-center mb-2 text-gray-800">Chuyển khoản qua ngân hàng</p>
              <div class="grid grid-cols-[auto_1fr] gap-2">
                <div class="banking-label">Số tiền:</div>
                <div class="banking-value">{{ Math.round(bankingOrder.amount).toLocaleString('vi-VN') }} VND</div>
                <div class="banking-label">Nội dung:</div>
                <div class="banking-value">{{ bankingOrder.unique_code }}</div>
                <div class="banking-label">Ngân hàng:</div>
                <div class="banking-value">MB Bank</div>
                <div class="banking-label">Số tài khoản:</div>
                <div class="banking-value">0346515305</div>
                <div class="banking-label">Chủ tài khoản:</div>
                <div class="banking-value">DO NGUYEN PHI TIEN</div>
              </div>
            </div>

            <div class="text-xs text-yellow-800 italic mb-4 p-2 bg-yellow-50/50 rounded text-center">
              Đây là mã QR tạm thời và dùng một lần, vui lòng không lưu lại mã QR này.
              Nếu bạn cần hỗ trợ, hãy liên hệ với chúng mình qua Fanpage.
            </div>

            <div class="flex justify-center">
              <button
                type="button"
                class="close-btn"
                @click="clearOrder"
              >
                <CloseIcon :size="16" />
                <span>Đóng</span>
              </button>
            </div>
          </template>
        </div>
      </div>
    </div>

    <div class="py-8 lg:py-16 px-2">
      <CuuHeading>Quyên góp</CuuHeading>

      <!-- Total -->
      <div class="common-container">
        <div class="mb-4 p-4 flex items-center justify-between bg-pink-50 rounded-lg">
          <div class="flex items-center gap-2">
            <HeartIcon :size="18" class="text-pink-500" />
            <span class="font-bold uppercase text-sm text-pink-800">Quỹ còn lại hiện tại</span>
          </div>
          <div class="flex items-center gap-1">
            <span v-if="meta" class="text-xl font-semibold text-pink-700">{{ Math.round(meta.all_time_total).toLocaleString('vi-VN') }} VND</span>
            <span v-else class="text-gray-500">N/A</span>
          </div>
        </div>
      </div>

      <!-- Month Selector -->
      <div class="common-container mb-4 flex flex-col sm:flex-row justify-between items-center gap-4">
        <div class="flex items-center gap-2">
          <button
            @click="previousMonth"
            class="month-nav-btn"
            :disabled="isCurrentMonthFirst"
          >
            <ChevronLeftIcon :size="20" />
          </button>
          <div class="h-8 px-4 flex items-center bg-gray-50 rounded-lg font-bold text-xs text-gray-700">
            {{ currentMonthName }} {{ currentYear }}
          </div>
          <button
            @click="nextMonth"
            class="month-nav-btn"
            :disabled="isCurrentMonthLatest"
          >
            <ChevronRightIcon :size="20" />
          </button>
        </div>

        <div v-if="!donationsLoading && donations.length > 0" class="h-8 px-4 flex items-center bg-gray-50 rounded-lg font-bold text-xs text-gray-700">
          <CashIcon :size="20" />
          <div>
              <span class="text-green-700">{{ monthDonationsAmount.toLocaleString('vi-VN') }} VND</span>
            <span class="mx-2">/</span>
              <span class="text-red-700">{{ monthExpensesAmount.toLocaleString('vi-VN') }} VND</span>
          </div>
        </div>
      </div>

      <div v-if="donationsLoading" class="flex justify-center items-center min-h-[200px]">
        <LoadingIcon :size="32" />
      </div>

      <div v-else-if="donations.length === 0" class="flex justify-center items-center min-h-[200px]">
        <p class="text-gray-600">Không có dữ liệu</p>
      </div>

      <div v-else class="common-container overflow-y-auto shadow-lg rounded-lg">
        <table class="table overflow-hidden min-w-full bg-white">
          <thead>
            <tr class="text-center bg-gray-200 text-gray-600 uppercase text-sm font-semibold border-b-2 border-gray-300">
              <th class="text-right whitespace-nowrap">#</th>
              <th class="text-center whitespace-nowrap">Loại</th>
              <th class="text-left whitespace-nowrap">Người ủng hộ</th>
              <th class="text-left whitespace-nowrap">Thời gian</th>
              <th class="text-right whitespace-nowrap">Số tiền</th>
              <th class="text-left w-[40%] whitespace-nowrap">Lời nhắn</th>
            </tr>
          </thead>
          <tbody>
            <tr
              v-for="(donation, index) in donations"
              :key="donation.id"
              class="border-b border-gray-300 transition-colors even:bg-gray-100 even:bg-opacity-70"
            >
              <td class="text-right text-gray-600 text-sm">{{ index + 1 }}</td>
              <td class="text-center text-gray-600 text-sm">
                <span v-if="donation.amount > 0" class="text-green-700">Quyên góp</span>
                <span v-else class="text-red-700">Chi tiêu</span>
              </td>
              <td class="">
                <div
                  v-if="donation.amount < 0"
                  class="flex"
                >
                  <span class="font-bold text-xs px-1.5 py-0.5 bg-blue-700 text-white rounded-full">Cứu Truyện</span>
                </div>
                <div v-else>
                  <div v-if="donation.user" class="flex items-center gap-2 font-bold text-sm text-gray-600">
                    <div class="avatar">
                      {{ donation.user.username[0] }}
                    </div>
                    {{ donation.user.username }}
                  </div>
                  <div v-else class="text-gray-500">
                    Ẩn danh
                  </div>
                </div>
              </td>
              <td class="text-sm text-gray-600">{{ donation.created_at | humanizeTime }}</td>
              <td
                class="text-sm text-gray-600 text-right font-bold"
                :class="donation.amount > 0 ? 'text-green-700' : 'text-red-700'"
              >
                {{ Number(donation.amount).toLocaleString('vi-VN') }} VND
              </td>
              <td class="text-sm text-gray-600">{{ donation.message }}</td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
import HeartIcon from 'vue-material-design-icons/Heart.vue'
import HeartOutlineIcon from 'vue-material-design-icons/HeartOutline.vue'
import HelpCircleOutlineIcon from 'vue-material-design-icons/HelpCircleOutline.vue'
import CloseIcon from 'vue-material-design-icons/Close.vue'
import LoadingIcon from 'vue-material-design-icons/Loading.vue'
import CheckCircleIcon from 'vue-material-design-icons/CheckCircle.vue'
import FireIcon from 'vue-material-design-icons/Fire.vue'
import ChevronLeftIcon from 'vue-material-design-icons/ChevronLeft.vue'
import ChevronRightIcon from 'vue-material-design-icons/ChevronRight.vue'
import CashIcon from 'vue-material-design-icons/Cash.vue'
import { createBankingOrder, getBankingOrder, getDonations } from '@/apis/user'
import { createConsumer } from '@rails/actioncable'
import dayjs from 'dayjs'

export default {
  name: 'Donate',
  components: {
    HeartIcon,
    HeartOutlineIcon,
    HelpCircleOutlineIcon,
    CloseIcon,
    LoadingIcon,
    CheckCircleIcon,
    FireIcon,
    ChevronLeftIcon,
    ChevronRightIcon,
    CashIcon
  },
  computed: {
    ...mapGetters([
      'currentUser'
    ]),
    currentMonthName () {
      const months = ['Tháng 1', 'Tháng 2', 'Tháng 3', 'Tháng 4', 'Tháng 5', 'Tháng 6', 'Tháng 7', 'Tháng 8', 'Tháng 9', 'Tháng 10', 'Tháng 11', 'Tháng 12']
      return months[this.currentMonth - 1]
    },
    monthDonationsAmount () {
      return this.donations.filter(donation => donation.amount > 0).reduce((total, donation) => total + Number(donation.amount), 0)
    },
    monthExpensesAmount () {
      return this.donations.filter(donation => donation.amount < 0).reduce((total, donation) => total + Number(donation.amount), 0)
    },
    isCurrentMonthLatest () {
      const now = dayjs()
      return this.currentYear === now.year() && this.currentMonth === now.month() + 1
    },
    isCurrentMonthFirst () {
      return this.currentYear === 2025 && this.currentMonth === 5
    }
  },
  data () {
    return {
      amounts: [
        { value: 10000, label: '10.000 VND', hearts: 1 },
        { value: 50000, label: '50.000 VND', hearts: 2 },
        { value: 100000, label: '100.000 VND', hearts: 3 },
        { value: 500000, label: '500.000 VND', hearts: 4 },
        { value: 1000000, label: '1.000.000 VND', hearts: 5 }
      ],
      selectedAmount: 10000,
      customAmount: 10000,
      isCustomAmount: false,
      donateAs: null,
      customName: '',
      message: '',
      bankingOrder: null,
      loading: true,
      consumer: null,
      channel: null,
      donations: [],
      donationsLoading: true,
      currentYear: dayjs().year(),
      currentMonth: dayjs().month() + 1,
      meta: null
    }
  },
  created () {
    this.consumer = createConsumer()
  },
  async mounted () {
    this.loading = true
    this.loadDonations()

    try {
      this.donateAs = this.currentUser ? 'account' : 'anonymous'
      if (this.$route.query.id) {
        await this.loadBankingOrder(this.$route.query.id)
      } else if (localStorage.getItem('bankingOrderId')) {
        this.$router.replace({ name: 'Donate', query: { id: localStorage.getItem('bankingOrderId') } })
        await this.loadBankingOrder(localStorage.getItem('bankingOrderId'))
      } else {
        this.bankingOrder = null
      }
    } catch (error) {
      this.$handleError(error)
    } finally {
      this.loading = false
    }
  },
  watch: {
    currentUser (newVal) {
      if (!newVal) {
        this.donateAs = 'anonymous'
      }
    },
    bankingOrder (newVal, oldVal) {
      if (newVal && !oldVal) {
        console.log('Banking order changed:', newVal)
        this.listenBankingOrder()
      } else if (!newVal) {
        console.log('Banking order cleared')
        if (this.channel) {
          this.channel.unsubscribe()
        }
      }
    }
  },
  methods: {
    listenBankingOrder () {
      this.channel = this.consumer.subscriptions.create({ channel: 'BankingOrderStatusChannel', banking_order_id: this.bankingOrder.id }, {
        received: (data) => {
          if (data.status === 'paid') {
            this.channel.unsubscribe()
            this.loadBankingOrder(this.bankingOrder.id)
          }
        }
      })
    },
    async loadBankingOrder (id) {
      const response = await getBankingOrder(id)
      this.bankingOrder = response.data
    },
    async loadDonations () {
      try {
        this.donationsLoading = true
        const response = await getDonations(this.currentYear, this.currentMonth)
        this.donations = response.data
        this.meta = response._metadata
      } catch (error) {
        this.$handleError(error)
      } finally {
        this.donationsLoading = false
      }
    },

    previousMonth () {
      if (this.currentMonth === 1) {
        this.currentMonth = 12
        this.currentYear--
      } else {
        this.currentMonth--
      }
      this.loadDonations()
    },

    nextMonth () {
      if (this.currentMonth === 12) {
        this.currentMonth = 1
        this.currentYear++
      } else {
        this.currentMonth++
      }
      this.loadDonations()
    },
    clearOrder () {
      this.bankingOrder = null
      localStorage.removeItem('bankingOrderId')
      this.$router.replace({ name: 'Donate' })
    },
    selectAmount (amount) {
      this.selectedAmount = amount
      this.isCustomAmount = false
    },
    selectCustomAmount () {
      this.selectedAmount = null
      this.isCustomAmount = true
    },
    getHeartCount (amount) {
      if (amount < 10000) return 0
      if (amount < 50000) return 1
      if (amount < 100000) return 2
      if (amount < 500000) return 3
      if (amount < 1000000) return 4
      return 5
    },
    async submitDonation () {
      console.log('Donation submitted:', this.selectedAmount || this.customAmount, this.donateAs, this.customName, this.message)
      const response = await createBankingOrder({
        banking_order: {
          amount: this.selectedAmount || this.customAmount,
          message: this.message,
          user_id: this.currentUser && this.donateAs === 'account' ? this.currentUser.id : null
        }
      })
      this.bankingOrder = response.data
      localStorage.setItem('bankingOrderId', response.data.id)
      this.$router.replace({ name: 'Donate', query: { id: response.data.id } })
    }
  }
}
</script>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Great+Vibes&family=Noto+Serif:ital,wght@0,400;0,600;1,400;1,600&family=Source+Serif+Pro:ital,wght@0,400;0,600;1,400;1,600&display=swap');

.love-letter-container {
  padding: 2rem 1.5rem;
  position: relative;
}

.love-letter-background {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  width: 200%;
  height: 200%;
  pointer-events: none;

  background: radial-gradient(circle at center, rgba(249, 168, 212, 0.28) 0%, rgba(252, 231, 243, 0.19) 50%, transparent 70%);
}

.love-letter-heading {
  font-family: 'Great Vibes', cursive;
  font-size: 2rem;
  color: #db2777;
  /* pink-600 */
  font-weight: 700;
  letter-spacing: 0.02em;
  text-shadow: 0 2px 8px #fbcfe8;
}

.love-letter-body {
  font-size: 1.12rem;
  font-style: italic;
  color: #4e3b47;
  line-height: 2;
  font-family: 'Noto Serif', 'Source Serif Pro', 'Cambria', serif;
}

.love-letter-highlight {
  color: #db2777;
  font-weight: 600;
  background: linear-gradient(90deg, rgba(251, 207, 232, 0.2) 0%, rgba(247, 175, 212, 0.6) 100%);
  border-radius: 0.4em;
  padding: 0 0.2em;
}

.love-letter-flourish {
  display: flex;
  justify-content: center;
  margin-top: 1.5rem;
  opacity: 0.7;
}

.bg-donate {
  background: radial-gradient(at 50% 75%, rgb(48, 107, 235), ease, rgb(18, 36, 48));
  background-size: 100% 100%;
}

.donate-btn {
  @apply px-3 py-2 rounded-lg font-semibold text-sm border-2 transition duration-500 focus:outline-none bg-white text-gray-800 border-gray-300;
}

.donate-btn--selected {
  @apply border-pink-500 bg-pink-100;
}

.banking-label {
  @apply text-sm text-gray-700;
}

.banking-value {
  @apply text-sm text-right font-bold text-gray-900;
}

.close-btn {
  @apply flex items-center gap-1 text-gray-600 px-4 py-2 hover:bg-gray-200 rounded-lg transition text-xs font-bold uppercase;
}

.month-nav-btn {
  @apply h-8 w-8 rounded-lg flex items-center justify-center text-gray-600 hover:bg-gray-100 hover:disabled:bg-transparent transition-colors disabled:opacity-50 disabled:cursor-not-allowed;
}

.avatar {
  @apply flex items-center justify-center w-6 h-6 rounded-full bg-pink-100 text-pink-600 text-xs font-bold;
}
</style>
