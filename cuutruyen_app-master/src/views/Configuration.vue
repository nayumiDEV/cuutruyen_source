<template>
  <div class="mx-2 py-8 lg:py-16" v-if="currentUser">
    <CuuHeading>{{ currentTab.title }}</CuuHeading>
    <div class="common-container flex flex-col md:flex-row gap-4">
      <aside class="md:w-64 flex-0 shrink-0 whitespace-nowrap flex md:flex-col gap-2">
        <router-link
          class="block rounded-lg font-bold px-4 py-2"
          :class="{
            'text-gray-700 bg-white bg-opacity-40': tab.name === currentTabName,
            'text-gray-500': tab.name !== currentTabName
            }"
          v-for="tab in tabs"
          :key="'tab-' + tab.name"
          :to="{ name: 'Configuration', query: { section: tab.name } }"
          replace
        >
          {{ tab.title }}
        </router-link>
      </aside>

      <main class="flex-grow">
        <component :is="currentTab.component || NullSection"></component>
      </main>
    </div>
  </div>
</template>

<script>
import NullSection from '@/components/configuration/NullSection'
import NotificationSection from '@/components/configuration/NotificationSection'
import ChangePasswordSection from '@/components/configuration/ChangePasswordSection'
import { mapGetters } from 'vuex'

export default {
  metaInfo: {
    title: 'Thiết lập'
  },

  components: {
    NullSection,
    NotificationSection,
    ChangePasswordSection
  },

  data () {
    return {
      tabs: [
        { name: 'notification', title: 'Thiết lập thông báo', component: NotificationSection },
        { name: 'change-password', title: 'Đổi mật khẩu', component: ChangePasswordSection },
        { name: 'profile', title: 'Thông tin cá nhân', component: NullSection }
      ],

      currentTabName: 'notification'
    }
  },

  computed: {
    ...mapGetters([
      'currentUser'
    ]),

    currentTab () {
      return this.tabs.find(t => t.name === this.currentTabName)
    }
  },

  mounted () {
    if (this.$route.query.section) {
      this.currentTabName = this.$route.query.section
    }
  },

  methods: {
    switchTab (tabName) {
      this.currentTabName = tabName
    }
  },

  watch: {
    $route (to, from) {
      if (to.name === 'Configuration' && from.name === 'Configuration') {
        this.switchTab(to.query.section)
      }
    }
  }
}
</script>
