<template>
  <div>
    <CuuHeading>Thông báo nhóm</CuuHeading>

    <div v-if="loading" class="common-container h-[70vh] flex justify-center items-center">
      <span class="spin">
        <LoadingIcon :size="64" class="text-gray-500" />
      </span>
    </div>

    <div v-else-if="unreadNotifications.length > 0 || readNotifications.length > 0" class="common-container">
      <div class="flex justify-end mb-4">
        <button
          class="text-gray-500 hover:bg-gray-700 hover:text-gray-100 bg-gray-200 px-4 py-2 rounded-lg font-bold text-sm uppercase flex items-center gap-2 transition"
          @click="markAllAsRead"
        >
          <CheckIcon :size="16" />
          Đánh dấu tất cả là đã đọc
        </button>
      </div>

      <div v-if="unreadNotifications.length > 0">
        <div class="text-sm uppercase font-bold text-gray-600 mb-2">
          Chưa đọc
        </div>

        <div>
          <NotificationItem v-for="notification in unreadNotifications" :key="'notification-' + notification.id" :notification="notification" notificationType="team" />
        </div>
      </div>

      <div v-if="readNotifications.length > 0" class="mt-4">
        <div class="text-sm uppercase font-bold text-gray-600 mb-2">
          Đã đọc
        </div>

        <div>
          <NotificationItem v-for="notification in readNotifications" :key="'notification-' + notification.id" :notification="notification" notificationType="team" />
        </div>
      </div>
    </div>

    <EmptyScreen v-else message="Nhóm của bạn chưa có thông báo mới nào!"></EmptyScreen>
  </div>
</template>

<script>
import { getTeamNotifications, markAllTeamNotificationsAsRead } from '@/apis/team'
import NotificationItem from '@/components/notification/NotificationItem'
import { mapGetters } from 'vuex'
import CheckIcon from 'vue-material-design-icons/Check.vue'
import LoadingIcon from 'vue-material-design-icons/Loading.vue'

export default {
  metaInfo: {
    title: 'Thông báo nhóm'
  },

  components: {
    NotificationItem,
    CheckIcon,
    LoadingIcon
  },

  data () {
    return {
      unreadNotifications: [],
      readNotifications: [],
      loading: true,
      autoMarkAsReadTimeout: null
    }
  },

  props: {
    layoutProps: {
      type: Object,
      default: null
    }
  },

  computed: {
    ...mapGetters([
      'currentUser'
    ]),

    team () {
      return this.layoutProps.team
    }
  },

  mounted () {
    this.$gtag.config({
      send_page_view: false
    })
    this.$gtag.pageview({ page_title: 'Thông báo nhóm' })
    this.loadNotifications()
  },

  methods: {
    async loadNotifications () {
      this.loading = true
      try {
        const response = await getTeamNotifications(this.team.id)
        this.unreadNotifications = response.data.unread
        this.readNotifications = response.data.read
        this.autoMarkAsReadTimeout = setTimeout(async () => {
          await markAllTeamNotificationsAsRead(this.team.id)
        }, 3000)
      } catch (error) {
        this.$handleError(error)
      } finally {
        this.loading = false
      }
    },

    async markAllAsRead () {
      try {
        await markAllTeamNotificationsAsRead(this.team.id)
        this.loadNotifications()
      } catch (error) {
        this.$notify({
          type: 'error',
          text: 'Có lỗi xảy ra!'
        })
      }
    }
  },

  beforeDestroy () {
    if (this.autoMarkAsReadTimeout) {
      clearTimeout(this.autoMarkAsReadTimeout)
    }
  }
}
</script>
