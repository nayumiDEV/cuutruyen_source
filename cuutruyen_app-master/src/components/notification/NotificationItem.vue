<template>
  <router-link
    :to="{ name: notificationRoute, params: { notificationId: notification.id } }"
    class="first:rounded-t-lg last:rounded-b-lg border-b-2 border-gray-300 last:border-b-0 bg-gray-200 px-8 py-4 flex flex-col-reverse md:flex-row gap-2 justify-between transition hover:bg-gray-100 overflow-hidden"
    :class="{ 'bg-opacity-40 hover:bg-opacity-40': notification.read_at }"
  >
    <div class="flex gap-4 flex-grow">
      <div class="w-12 h-12 md:w-16 h-16 overflow-hidden rounded-lg flex-none">
        <img class="object-cover rounded-lg w-full h-full" :src="notification.icon" alt="">
      </div>
      <div class="flex-grow overflow-hidden">
        <div class="font-bold text-gray-800 mb-2"
          :class="{ 'text-gray-600': notification.read_at }"
        >
          {{ notification.title }}
        </div>
        <div class="text-gray-600 text-sm break-words"
          :class="{ 'text-gray-500': notification.read_at }"
        >
          {{ notification.message }}
        </div>
      </div>
    </div>
    <div class="text-xs text-gray-500 flex-none">{{ notification.created_at | humanizeTime }}</div>
  </router-link>
</template>

<script>
export default {
  props: {
    notification: {
      type: Object
    },

    notificationType: {
      type: String,
      default: 'user'
    }
  },

  computed: {
    notificationRoute () {
      if (this.notificationType === 'user') {
        return 'NotificationRedirect'
      }

      return 'TeamNotificationRedirect'
    }
  }
}
</script>
