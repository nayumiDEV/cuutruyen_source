<template>
  <div>
  </div>
</template>

<script>
import { Notification } from '@/models'
import { mapGetters, mapActions } from 'vuex'

export default {
  computed: {
    ...mapGetters([
      'currentUser'
    ])
  },

  async mounted () {
    try {
      const notification = (await Notification.where({ recipient_type: 'User', recipient_id: this.currentUser.id, id: this.$route.params.notificationId }).first()).data
      this.$router.replace({ path: notification.url })
      notification.readAt = new Date()
      await notification.save()
      this.reloadNotificationUnreadCount()
    } catch (error) {
      this.$handleError(error)
    }
  },

  methods: {
    ...mapActions(['reloadNotificationUnreadCount'])
  }
}
</script>
