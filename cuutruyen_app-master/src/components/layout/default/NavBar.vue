<template>
  <nav class="px-2 z-40"
    :class="{
      'bg-white bg-opacity-60': theme == 'light' && !noBg,
      'bg-gray-900 bg-opacity-60': theme == 'dark' && !noBg,
      'backdrop-blur': glassy == true
      }">
    <div class="max-w-screen-md lg:max-w-screen-lg xl:max-w-screen-xl mx-auto">
      <div class="flex justify-between items-stretch py-2 gap-4">
        <div class="flex-1 items-center gap-3 hidden lg:flex">
          <a href="https://discord.gg/W7P8JwGArg" target="_blank" rel="noopener noreferrer" class="nav-link"
            :class="{
              'nav-link-light': theme == 'light',
              'nav-link-dark': theme != 'light'
              }"
          >Discord</a>
          <a href="https://www.facebook.com/groups/cuutruyen2vn" target="_blank" rel="noopener noreferrer" class="nav-link"
            :class="{
              'nav-link-light': theme == 'light',
              'nav-link-dark': theme != 'light'
              }"
          >Hội kín</a>
          <a href="https://m.me/cuutruyentranh" target="_blank" rel="noopener noreferrer" class="nav-link"
            :class="{
              'nav-link-light': theme == 'light',
              'nav-link-dark': theme != 'light'
              }"
          >Đăng truyện</a>
          <router-link :to="{ name: 'Donate' }" class="nav-link"
            :class="{
              'nav-link-light': theme == 'light',
              'nav-link-dark': theme != 'light'
              }"
          >Ủng hộ</router-link>
        </div>

        <div class="flex-1 flex lg:justify-center items-center max-w-full">
          <router-link :to="{ name: 'Home' }"
            class="font-display font-extrabold uppercase select-none rounded-full flex items-center h-11"
            :class="{
              'text-black text-opacity-60': theme == 'light',
              'text-white text-opacity-60': theme != 'light'
              }"
            id="phrase2"
          >
            Cứu Truyện
          </router-link>
        </div>

        <div class="flex-1 flex justify-end max-w-full">
          <div class="hidden" id="phrase">effort-mournful-county-flagstick</div>
          <router-link :to="{ name: 'Download' }" class="button-circle mr-2 w-11 h-11 relative" v-show="cumulativeDownloadProgress"
            :class="{
              'button-transparent-light': theme == 'light',
              'button-transparent-dark': theme != 'light'
              }"
          >
            <svg class="w-11 h-11 -rotate-90">
              <!-- <circle cx="22" cy="22" r="18" stroke="currentColor" stroke-width="4" fill="transparent"
                   class="text-gray-700" /> -->

              <circle v-show="cumulativeDownloadProgress < 1" cx="22" cy="22" r="18" stroke="currentColor" stroke-width="4" fill="transparent"
                :stroke-dasharray="circumference"
                :stroke-dashoffset="circumference - cumulativeDownloadProgress * circumference"
                class="text-blue-500" />
            </svg>

            <div class="absolute top-0 left-0 w-full h-full flex items-center justify-center">
              <DownloadIcon class="" />
            </div>
          </router-link>

          <button
            @click="showSearchBar"
            class="button-circle px-3 py-2 mr-2 h-11 w-11 flex justify-center items-center"
            :class="{
              'button-transparent-light': theme == 'light',
              'button-transparent-dark': theme != 'light'
              }"
          >
            <MagnifyIcon :size="16" />
          </button>

          <router-link
            v-if="currentUser"
            class="button-circle px-3 py-2 mr-2 h-11 w-11 flex justify-center items-center relative"
            :class="{
              'button-transparent-light': theme == 'light',
              'button-transparent-dark': theme != 'light'
              }"
            :to="{ name: 'Notification' }"
          >
            <BellIcon :size="16" />
            <div v-show="notificationUnreadCount > 0" class="absolute h-5 w-5 top-0 right-0 rounded-full bg-red-700 text-[10px] font-bold text-white flex items-center justify-center bg-opacity-70">
              {{ notificationUnreadCount }}
            </div>
          </router-link>

          <NavDropdown :currentUser="currentUser" :theme="theme" />
          <portal>
            <SearchPopup v-model="isShowSearch" />
          </portal>
        </div>
      </div>
    </div>
  </nav>
</template>

<script>
import { mapGetters } from 'vuex'
import MagnifyIcon from 'vue-material-design-icons/Magnify.vue'
import BellIcon from 'vue-material-design-icons/BellOutline.vue'
import DownloadIcon from 'vue-material-design-icons/DownloadOutline.vue'
import NavDropdown from './NavDropdown'
import SearchPopup from './SearchPopup'

export default {
  components: {
    MagnifyIcon,
    NavDropdown,
    SearchPopup,
    BellIcon,
    DownloadIcon
  },

  props: {
    theme: {
      type: String
    },

    glassy: {
      type: Boolean,
      default: false
    },

    noBg: {
      type: Boolean,
      default: false
    }
  },

  data () {
    return {
      expandSearchBar: false,
      showBackButton: false,
      isShowSearch: false,
      circumference: 2 * Math.PI * 18
    }
  },

  computed: {
    ...mapGetters([
      'currentUser', 'notificationUnreadCount', 'cumulativeDownloadProgress'
    ])
  },

  mounted () {
    this.checkPWA()
  },

  methods: {
    showSearchBar () {
      this.isShowSearch = true
      this.$gtag.event('use_search')
    },

    checkPWA () {
      if (window.matchMedia('(display-mode: standalone)').matches) {
        this.showBackButton = true
      }
    },

    historyBack () {
      window.history.back()
    }
  }
}
</script>

<style scoped>
.glassy {
  background-color: rgba(255, 255, 255, .95);
}

@supports ( backdrop-filter: blur(20px) ) {
  .glassy {
    background-color: rgba(255, 255, 255, .80);
    backdrop-filter: saturate(180%) blur(10px);
  }
}

.nav-link {
  @apply uppercase font-bold text-xs whitespace-nowrap;
}

.nav-link-dark {
  @apply text-white text-opacity-50;
}

.nav-link-dark:hover {
  @apply text-white text-opacity-80;
}

.nav-link-light {
  @apply text-black text-opacity-70;
}

.nav-link-light:hover {
  @apply text-black text-opacity-90;
}
</style>
