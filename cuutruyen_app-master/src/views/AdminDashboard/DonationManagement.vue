<template>
  <div>
    <CuuHeading>Quản lý quyên góp</CuuHeading>

    <template v-if="loading">
      <LoadingScreen />
    </template>

    <div v-else>
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

        <div class="text-sm text-gray-600">
          Tổng cộng: <span class="font-bold">{{ donations.length }}</span> quyên góp
        </div>
      </div>

      <div v-if="donations && donations.length > 0" class="common-container overflow-y-auto shadow-lg rounded-lg">
        <table class="table overflow-hidden min-w-full bg-white">
          <tr class="text-center bg-gray-200 text-gray-600 uppercase text-sm font-semibold border-b-2 border-gray-300">
            <th class="text-center whitespace-nowrap">Mã</th>
            <th class="text-left whitespace-nowrap">Người quyên góp</th>
            <th class="text-right whitespace-nowrap">Số tiền</th>
            <th class="text-left whitespace-nowrap">Nội dung</th>
            <th class="text-center whitespace-nowrap">Thời gian</th>
            <th class="text-center whitespace-nowrap">Hành động</th>
          </tr>

          <tr
            v-for="donation in donations"
            :key="donation.id"
            class="text-center border-b border-gray-200 text-gray-800 text-sm even:bg-gray-100 even:bg-opacity-50"
          >
            <td class="text-center font-mono text-xs">
              {{ donation.unique_code }}
            </td>
            <td class="p-4 text-left">
              <div v-if="donation.user" class="flex items-center gap-2 font-bold text-sm text-gray-600">
                <div class="avatar">
                  {{ donation.user.username[0] }}
                </div>
                {{ donation.user.username }}
              </div>
              <div v-else class="text-gray-500">
                Ẩn danh
              </div>
            </td>
            <td class="text-right font-bold" :class="donation.amount > 0 ? 'text-green-700' : 'text-red-700'">
              {{ formatCurrency(donation.amount) }}
            </td>
            <td class="text-left max-w-xs truncate" :title="donation.message">
              <span v-if="donation.message" class="truncate">{{ donation.message }}</span>
              <span v-else class="text-gray-500 italic">Không có nội dung</span>
            </td>
            <td class="text-center whitespace-nowrap text-xs">
              {{ donation.created_at | humanizeTime }}
            </td>
            <td class="flex justify-end gap-1">
              <button
                @click="editingDonation = donation"
                class="button button-mini button-normal px-2.5 py-1.5"
              >
                Sửa
              </button>
              <button
                @click="deletingDonation = donation"
                class="button button-mini button-danger px-2.5 py-1.5"
              >
                Xóa
              </button>
            </td>
          </tr>
        </table>
      </div>

      <EmptyScreen v-else message="Không có quyên góp nào!" />

      <DonationEditModal
        :donation="editingDonation"
        @confirm="reloadCurrentList"
        @cancel="editingDonation = null"
      />
      <DonationDeleteModal
        :donation="deletingDonation"
        @confirm="reloadCurrentList"
        @cancel="deletingDonation = null"
      />
    </div>
  </div>
</template>

<script>
import { getAdminDonations } from '@/apis/admin'
import ChevronLeftIcon from 'vue-material-design-icons/ChevronLeft.vue'
import ChevronRightIcon from 'vue-material-design-icons/ChevronRight.vue'
import dayjs from 'dayjs'
import DonationEditModal from '@/components/admin-dashboard/DonationEditModal.vue'
import DonationDeleteModal from '@/components/admin-dashboard/DonationDeleteModal.vue'

export default {
  name: 'DonationManagement',

  components: {
    ChevronLeftIcon,
    ChevronRightIcon,
    DonationEditModal,
    DonationDeleteModal
  },
  data () {
    return {
      donations: null,
      loading: true,
      currentYear: dayjs().year(),
      currentMonth: dayjs().month() + 1,
      meta: null,
      editingDonation: null,
      deletingDonation: null
    }
  },

  computed: {
    currentPage () {
      if (this.$route.query.page) {
        return Number(this.$route.query.page)
      } else {
        return 1
      }
    },

    totalPages () {
      if (this.meta) {
        return this.meta.total_pages
      } else {
        return 1
      }
    },

    currentMonthName () {
      const months = [
        'Tháng 1', 'Tháng 2', 'Tháng 3', 'Tháng 4', 'Tháng 5', 'Tháng 6',
        'Tháng 7', 'Tháng 8', 'Tháng 9', 'Tháng 10', 'Tháng 11', 'Tháng 12'
      ]
      return months[this.currentMonth - 1]
    },

    totalDonationAmount () {
      if (!this.donations) return 0
      return this.donations.reduce((total, donation) => total + Number(donation.amount), 0)
    },

    isCurrentMonthLatest () {
      const now = dayjs()
      return this.currentYear === now.year() && this.currentMonth === now.month() + 1
    },

    isCurrentMonthFirst () {
      return this.currentYear === 2024 && this.currentMonth === 1 // Assuming the first month with data is Jan 2024
    }
  },

  async mounted () {
    await this.loadDonations(this.currentYear, this.currentMonth)
  },

  methods: {
    async loadDonations (year, month) {
      this.loading = true
      try {
        const response = await getAdminDonations(year, month)
        this.donations = response.data
        this.meta = response._metadata
      } catch (error) {
        this.$handleError(error)
      } finally {
        this.loading = false
      }
    },

    async reloadCurrentList () {
      await this.loadDonations(this.currentYear, this.currentMonth)
    },

    doSearch () {
      this.$router.push({ name: 'AdminDonationManagement', query: { q: this.searchKeyword } })
    },

    viewDetails (donation) {
      this.selectedDonation = donation
    },

    formatCurrency (amount) {
      return new Intl.NumberFormat('vi-VN', {
        style: 'currency',
        currency: 'VND',
        minimumFractionDigits: 0,
        maximumFractionDigits: 0
      }).format(amount)
    },

    formatDate (dateString) {
      if (!dateString) return ''
      const date = new Date(dateString)
      return date.toLocaleDateString('vi-VN')
    },

    formatFullDate (dateString) {
      if (!dateString) return ''
      const date = new Date(dateString)
      return date.toLocaleString('vi-VN', {
        day: '2-digit',
        month: '2-digit',
        year: 'numeric',
        hour: '2-digit',
        minute: '2-digit'
      })
    },

    previousMonth () {
      if (this.currentMonth === 1) {
        this.currentMonth = 12
        this.currentYear--
      } else {
        this.currentMonth--
      }
      this.loadDonations(this.currentYear, this.currentMonth)
    },

    nextMonth () {
      if (this.currentMonth === 12) {
        this.currentMonth = 1
        this.currentYear++
      } else {
        this.currentMonth++
      }
      this.loadDonations(this.currentYear, this.currentMonth)
    }
  },

  beforeRouteUpdate (to, from, next) {
    if (to.query.page !== from.query.page || to.query.q !== from.query.q) {
      this.loadDonations(this.currentYear, this.currentMonth)
    }
    next()
  }
}
</script>

<style scoped>
.month-nav-btn {
  @apply p-1.5 rounded-full text-gray-600 hover:bg-gray-100 transition-colors;
  @apply disabled:opacity-30 disabled:cursor-not-allowed;
}

.month-nav-btn:not(:disabled):hover {
  @apply bg-gray-100 text-gray-800;
}
</style>
