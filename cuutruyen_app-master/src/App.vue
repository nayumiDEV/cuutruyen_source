<template>
  <div id="app">
    <template v-if="!isShowErrorPage && !isInvalidOrigin">
      <component :is="this.$route.meta.layout || LayoutNull">
        <template v-slot:default="slotProps">
          <router-view :key="$route.fullPath" :layoutProps="slotProps" />
        </template>
      </component>

      <notifications classes="m4u-notification" position="bottom center"/>
    </template>

    <ErrorPage v-else />

    <a class="fixed z-50 bottom-12 right-4 md:bottom-11 md:right-11" href="https://m.me/CuuTruyenTranh" target="_blank" rel="noopener noreferrer"
      :class="{
        invisible: !isMessengerVisible
        }"
    >
      <img class="w-8 h-8 md:w-12 md:h-12 lg:w-13 lg:h-13" style="filter: drop-shadow(3px 3px 7px rgba(69, 69, 69, 0.4))" src="@/assets/img/messenger.png" width="128" height="128" alt="Messenger">
    </a>
  </div>
</template>

<script>
import LayoutNull from '@/layouts/LayoutNull'
import ErrorPage from '@/components/error/ErrorPage'
import { mapGetters, mapMutations, mapActions } from 'vuex'

export default {
  metaInfo: {
    title: null,
    titleTemplate: (titleChunk) => titleChunk ? `${titleChunk} | Cứu Truyện` : 'Cứu Truyện',
    meta: [
      { vmid: 'description', name: 'description', content: 'Đọc truyện tranh manga và webtoon rõ nét, không bị phiền toái bởi quảng cáo & popup.' }
    ]
  },

  data () {
    return {
      LayoutNull,
      refreshing: false,
      registration: null,
      updateExists: false,
      lastScrollTop: 0,
      scrollTopDiff: 0,
      isInvalidOrigin: false
    }
  },

  computed: {
    ...mapGetters([
      'isShowErrorPage', 'isMessengerVisible', 'isShowToolbar', 'currentUser'
    ])
  },

  components: {
    ErrorPage
  },

  async created () {
    // this.checkGeo()
    this.findBestStorageServer()

    document.addEventListener('swUpdated', this.updateAvailable, { once: true })

    // if (navigator.serviceWorker) {
    //   navigator.serviceWorker.addEventListener('controllerchange', () => {
    //     // We'll also need to add 'refreshing' to our data originally set to false.
    //     if (this.refreshing) return
    //     this.refreshing = true
    //     // Here the actual reload of the page occurs
    //     window.location.reload()
    //   })
    // }

    if (process.env.NODE_ENV === 'production') {
      if (
        window.location.origin !== decodeURIComponent(atob('aHR0cHM6Ly9jdXV0cnV5ZW4ubmV0')) &&
        window.location.origin !== decodeURIComponent(atob('aHR0cHM6Ly9oZXRjdXV0cnV5ZW4ubmV0')) &&
        window.location.origin !== decodeURIComponent(atob('aHR0cHM6Ly9uZXR0cm9tLmNvbQ==')) &&
        !new RegExp(decodeURIComponent(atob('Xmh0dHBzOlwvXC9jdXV0cnV5ZW5bYS16MC05XXs1fVwuKHNpdGV8b25saW5lfHh5eikk'))).test(window.location.origin)
      ) {
        this.isInvalidOrigin = true
      }
    }
  },

  mounted () {
    this.lastScrollTop = window.pageYOffset

    window.addEventListener('scroll', () => {
      const scrollTop = window.pageYOffset
      const diff = this.scrollTopDiff + scrollTop - this.lastScrollTop

      if (diff > 60) {
        if (this.isShowToolbar) {
          this.hideToolbar()
        }
        this.scrollTopDiff = 0
      } else if (diff < -60) {
        if (!this.isShowToolbar) {
          this.showToolbar()
        }
        this.scrollTopDiff = 0
      } else {
        this.scrollTopDiff = diff
      }

      this.lastScrollTop = scrollTop

      document.documentElement.style.setProperty('--scroll-y', `${window.pageYOffset}px`)
    })

    this.setCocked(navigator.webdriver)
    this.refreshDownloadingChaptersData().then(() => this.updateDownloadingChaptersProgress())
  },

  methods: {
    ...mapMutations(['hideToolbar', 'showToolbar', 'setGeo', 'setIsSpider', 'setCocked']),
    ...mapActions(['restoreCurrentUser', 'reloadCurrentUser', 'refreshDownloadingChaptersData', 'updateDownloadingChaptersProgress', 'findBestStorageServer']),

    updateAvailable (event) {
      console.log('New CuuTruyen update is available!')
      this.registration = event.detail
      this.updateExists = true

      if (this.registration && this.registration.waiting) {
        console.log('Forcing update...')
        this.registration.waiting.postMessage({ type: 'SKIP_WAITING' })
      }
    },

    refreshApp () {
      this.updateExists = false
      if (!this.registration || !this.registration.waiting) return
      this.registration.waiting.postMessage({ type: 'SKIP_WAITING' })
    }
    //
    //     async checkGeo () {
    //       try {
    //         const response = await fetch('https://cuutruyen_flare.cuutruyen.workers.dev/geo')
    //         const data = await response.json()
    //
    //         this.setGeo(data.geo)
    //
    //         if (/bot|googlebot|crawler|spider|robot|crawling/i.test(navigator.userAgent)) {
    //           this.setIsSpider(true)
    //         }
    //       } catch (error) {
    //         console.error('Cannot detect client\'s geo location. Default to VN.')
    //       }
    //     }
  },

  watch: {
    $route (to, from) {
      document.documentElement.style.setProperty('--scroll-y', '0px')
    }
  }
}
</script>
