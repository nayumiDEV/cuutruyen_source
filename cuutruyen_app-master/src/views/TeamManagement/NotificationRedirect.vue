<template>
  <div>
  </div>
</template>

<script>
import { markTeamNotificationAsRead } from '@/apis/team'
import { mapGetters } from 'vuex'

export default {
  props: {
    layoutProps: {
      type: Object,
      default: null
    }
  },

  computed: {
    ...mapGetters([
      'currentUser'
    ])
  },

  async mounted () {
    try {
      const response = await markTeamNotificationAsRead(this.$route.params.teamId, this.$route.params.notificationId)
      this.$router.replace({ path: response.data.url })
    } catch (error) {
      this.$handleError(error)
    }
  }
}
</script>
