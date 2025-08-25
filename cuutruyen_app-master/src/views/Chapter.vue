<template>
  <div v-if="!loading">
    <div v-if="chapter.status === 'processed'">
      <ClassicUI v-if="ui === 'classic'" :manga="manga" :chapter="chapter" :team="team" :pages="pages" @changeUI="changeUI" :showUIChooser="showUIChooser" @showUIHelpModal="showUIHelpModal = true" />
      <ZenUI v-if="ui === 'zen'" :manga="manga" :chapter="chapter" :team="team" :pages="pages" @changeUI="changeUI" @showUIHelpModal="showUIHelpModal = true" />

      <UIHelpModal v-model="showUIHelpModal" :defaultUI="ui" @confirm="confirmUI" />
    </div>

    <ChapterNotReady v-else :chapter="chapter" />
    <AgeVerificationModal v-model="showAgeVerificationModal" />
  </div>

  <LoadingScreen class="bg-gray-900" v-else />
</template>

<script>
import { mapGetters } from 'vuex'
import { fullUrl } from '@/utils/get-url'
import ChapterNotReady from '@/components/chapter/ChapterNotReady'
import ClassicUI from '@/components/chapter/ClassicUI'
import ZenUI from '@/components/chapter/ZenUI'
import UIHelpModal from '@/components/UIHelpModal'
import AgeVerificationModal from '@/components/AgeVerificationModal'
import { RegionNotSupported } from '@/utils/custom-errors'
import { getChapter } from '@/apis/user'
import { incrementView } from '@/spy-apis'

export default {
  metaInfo () {
    if (!this.chapter) {
      return {}
    }

    return {
      title: `Chương ${this.chapter.number} - Đọc ${this.chapter.manga.name}`,
      meta: [
        { vmid: 'description', name: 'description', content: `Đọc chương ${this.chapter.number} - ${this.chapter.manga.description}` }
      ],
      link: [
        { rel: 'canonical', href: `${this.baseUrl}/mangas/${this.manga.id}/chapters/${this.chapter.id}` }
      ],
      script: [
        {
          vmid: 'jsonld',
          type: 'application/ld+json',
          json: {
            '@context': 'https://schema.org',
            '@type': 'Article',
            headline: `Chương ${this.chapter.number} - Đọc ${this.chapter.manga.name}`,
            image: [
              fullUrl(this.chapter.manga.cover_url),
              fullUrl(this.chapter.manga.panorama_url)
            ],
            datePublished: this.chapter.created_at,
            dateModified: this.chapter.updated_at
          }
        }
      ]
    }
  },

  components: {
    ChapterNotReady,
    ClassicUI,
    ZenUI,
    UIHelpModal,
    AgeVerificationModal
  },

  computed: {
    ...mapGetters([
      'currentUser', 'geo', 'isSpider', 'isClientRegionLimited', 'isStormRegion'
    ]),

    manga () {
      if (!this.chapter) {
        return null
      }

      return this.chapter.manga
    },

    team () {
      if (!this.chapter) {
        return null
      }

      return this.chapter.team
    }
  },

  data () {
    return {
      chapter: null,
      pages: null,
      loading: true,
      doIncrement: null,
      ui: null,
      showUIChooser: false,
      showUIHelpModal: false,
      showAgeVerificationModal: false,
      baseUrl: process.env.VUE_APP_API_BASE_URL
    }
  },

  async mounted () {
    this.lockBodyScroll()
    this.loading = true

    try {
      await this.loadChapter()

      // var isMobile = Math.min(window.screen.width, window.screen.height) < 768 || navigator.userAgent.indexOf('Mobi') > -1

      if (this.manga.marginless) {
        this.ui = 'classic'
        this.showUIChooser = false
      } else {
        this.ui = this.getUIPreference()
        this.showUIChooser = true

        if (!localStorage.getItem('UIPreferenceConfirmed')) {
          this.showUIHelpModal = true
        }
      }

      if (this.manga.is_region_limited) {
        if (this.isClientRegionLimited) {
          throw new RegionNotSupported(this.geo, this.isSpider)
        }
      }

      if (this.isStormRegion) {
        throw new RegionNotSupported(this.geo, this.isSpider)
      }

      if (this.manga.is_nsfw && !this.isSpider) {
        const isAgeVerified = Number(sessionStorage.getItem('isAgeVerified') || 0)
        if (isAgeVerified === 0) {
          this.showAgeVerificationModal = true
        }
      }

      this.$gtag.config({
        send_page_view: false
      })
      this.$gtag.pageview({ page_title: `Chương ${this.chapter.number} - Đọc ${this.chapter.manga.name}` })

      this.doIncrement = setTimeout(() => {
        // fetch(`${process.env.VUE_APP_API_NAMESPACE}/chapters/${this.chapter.id}/increment`, {
        //   method: 'PATCH'
        // })
        incrementView(this.chapter.id)
      }, 10000)
    } catch (error) {
      this.error = true
      this.$handleError(error)
    } finally {
      this.loading = false
      this.releaseBodyScroll()
    }
  },

  methods: {
    getUIPreference () {
      // const isMobile = Math.min(window.screen.width, window.screen.height) < 768 || navigator.userAgent.indexOf('Mobi') > -1
      const isApple = /(iPhone|iPod|iPad|Macintosh).*AppleWebKit/i.test(navigator.userAgent)
      if (isApple) {
        return localStorage.getItem('UIPreference3') || 'classic'
      } else {
        return localStorage.getItem('UIPreference3') || 'zen'
      }
    },

    changeUI (ui) {
      this.ui = ui
      localStorage.setItem('UIPreference3', this.ui)
    },

    confirmUI (ui) {
      this.ui = ui
      localStorage.setItem('UIPreference3', this.ui)
      localStorage.setItem('UIPreferenceConfirmed', true)
    },

    async loadChapter () {
      const response = await getChapter(this.$route.params.id)
      this.chapter = response.data
      this.pages = response.data.pages
    }
  },

  beforeDestroy () {
    clearTimeout(this.doIncrement)
    if (this.currentPageObserver) {
      this.currentPageObserver.disconnect()
    }

    this.releaseBodyScroll()
  }
}
</script>
