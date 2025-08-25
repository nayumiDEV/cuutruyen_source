<template>
  <nav class="px-2 z-30"
    :class="{ 'bg-white': theme == 'light',
      'glassy-light': theme == 'light' && glassy == true,
      'glassy-dark': theme == 'dark' && glassy == true }">
    <div class="max-w-screen-md lg:max-w-screen-lg xl:max-w-screen-xl mx-auto h-14 flex flex-col justify-center w-full">
      <div
        v-if="team"
        class="flex justify-between items-center py-4"
      >
        <div class="text-black text-opacity-80">
          Chào mừng, <strong>{{ team.name }}</strong>!
        </div>

        <div class="flex gap-6">
          <router-link :to="{ name: 'TeamDashboard' }" class="subnav-item" :class="{ 'subnav-item-active': $route.name === 'TeamDashboard' }">Tổng quan</router-link>
          <router-link :to="{ name: 'TeamNotification' }" class="subnav-item flex gap-1" :class="{ 'subnav-item-active': $route.name === 'TeamNotification' }">
            <span>Thông báo</span>
            <span class="w-6 h-6 flex justify-center items-center text-white text-xs rounded" :class="{ 'bg-gray-500': unreadCount === 0, 'bg-red-700': unreadCount > 0 }">{{ unreadCount }}</span>
          </router-link>
          <router-link :to="{ name: 'TeamMangaManagement' }" class="subnav-item" :class="{ 'subnav-item-active': $route.name === 'TeamMangaManagement' }">Quản lý truyện</router-link>
          <router-link :to="{ name: 'TeamPageManagement' }" class="subnav-item" :class="{ 'subnav-item-active': $route.name === 'TeamPageManagement' }">Quản lý trang nhóm</router-link>
          <router-link :to="{ name: 'TeamPreferences' }" class="subnav-item" :class="{ 'subnav-item-active': $route.name === 'TeamPreferences' }">Thiết lập</router-link>
        </div>
      </div>
    </div>
  </nav>
</template>

<script>
import { getTeamUnreadNotificationsCount } from '@/apis/team'

export default {
  props: {
    theme: {
      type: String,
      default: 'dark'
    },

    glassy: {
      type: Boolean,
      default: false
    },

    team: {
      type: Object,
      default: null
    }
  },

  data () {
    return {
      unreadCount: 0
    }
  },

  watch: {
    async team (to, from) {
      if (to) {
        const response = await getTeamUnreadNotificationsCount(this.team.id)
        this.unreadCount = response.data
      }
    }
  }
}
</script>

<style scoped>
.subnav-item {
  @apply text-black text-opacity-60 py-2;
}

.subnav-item-active {
  @apply text-opacity-100 text-blue-700 border-b-2 border-blue-700;
}

.subnav-item:hover {
  @apply text-opacity-70;
}
</style>
