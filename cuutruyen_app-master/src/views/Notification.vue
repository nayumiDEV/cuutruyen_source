<template>
  <div class="mx-2 py-8 lg:py-16">
    <CuuHeading>Thông báo</CuuHeading>

    <div v-if="loading" class="common-container h-[70vh] flex justify-center items-center">
        <span class="spin">
          <LoadingIcon :size="64" class="text-gray-500" />
        </span>
    </div>

    <div v-else-if="unreadNotifications.length > 0 || readNotifications.length > 0" class="common-container">
      <div v-if="webPushBegging" class="text-yellow-700 bg-yellow-200 px-6 py-3 rounded-lg mb-4 text-center">
          Trình duyệt của bạn hỗ trợ <strong>thông báo đẩy</strong>, nhưng bạn vẫn chưa cài đặt để nhận thông báo.
          Vào mục <router-link :to="{ name: 'Configuration' }" class="text-yellow-700 hover:text-blue-900 font-bold">thiết lập</router-link> để cài đặt nhận thông báo đẩy.
      </div>
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
          <NotificationItem v-for="notification in unreadNotifications" :key="'notification-' + notification.id" :notification="notification" />
        </div>
      </div>

      <div v-if="readNotifications.length > 0" class="mt-4">
        <div class="text-sm uppercase font-bold text-gray-600 mb-2">
          Đã đọc
        </div>

        <div>
          <NotificationItem v-for="notification in readNotifications" :key="'notification-' + notification.id" :notification="notification" />
        </div>
      </div>
    </div>

    <EmptyScreen v-else message="Bạn chưa có thông báo mới nào!"></EmptyScreen>
  </div>
</template>

<script>
import { getNotifications, markAllNotificationsAsRead } from '@/apis/user'
import NotificationItem from '@/components/notification/NotificationItem'
import { mapGetters, mapActions } from 'vuex'
import CheckIcon from 'vue-material-design-icons/Check.vue'
import LoadingIcon from 'vue-material-design-icons/Loading.vue'
import * as WebPush from '@/lib/web-push'

export default {
  metaInfo: {
    title: 'Thông báo'
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
      webPushBegging: false,
      loading: true,
      autoMarkAsReadTimeout: null
    }
  },

  computed: {
    ...mapGetters([
      'currentUser'
    ])
  },

  mounted () {
    this.lockBodyScroll()
    this.$gtag.config({
      send_page_view: false
    })
    this.$gtag.pageview({ page_title: 'Thông báo' })
    this.loadNotifications()

    if (WebPush.isPushApiSupported() && WebPush.getNotificationPermissionStatus() !== 'granted') {
      this.webPushBegging = true
    }
  },

  methods: {
    ...mapActions(['reloadNotificationUnreadCount']),

    async loadNotifications () {
      this.loading = true
      try {
        const response = await getNotifications()
        this.unreadNotifications = response.data.unread
        this.readNotifications = response.data.read
        this.autoMarkAsReadTimeout = setTimeout(async () => {
          await markAllNotificationsAsRead()
          this.reloadNotificationUnreadCount()
        }, 3000)
      } catch (error) {
        this.$handleError(error)
      } finally {
        this.loading = false
        this.releaseBodyScroll()
      }
    },

    async markAllAsRead () {
      try {
        await markAllNotificationsAsRead()
        this.loadNotifications()
        this.reloadNotificationUnreadCount()
      } catch (error) {
        console.error(error)
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
