<template>
  <div id="good-pages" class="w-screen bg-gray-900 overflow-hidden relative select-none h-screen-ios" style="">
    <NavBar class="w-full fine-shadow fixed top-0 left-0 transition duration-400" :glassy="true" theme="dark"
      :class="{ '-translate-y-full': !isShowNavbar }"
    />

    <ChapterTooltipNew
      v-if="chapter && pages"
      :chapter="chapter"
      :pages="pages"
      :currentPage="currentPage"
      :totalPages="pages.length"
      :isShowSidebar="isShowSidebar"
      :direction="direction"
      @showSidebar="showSidebar"
      @toTop="toTop"
      @showQuickChaptersList="showQuickChaptersList = true"
      class="transition"
      :class="{ 'translate-y-full md:translate-y-16': !isShowNavbar }"
    />

    <ChapterSidebar
      v-if="chapter && pages"
      :chapter="chapter"
      :isShowSidebar="isShowSidebar"
      @hideSidebar="hideSidebar"
    />

    <div class="relative">
      <div class="flex gap-3 lg:gap-6 overflow-x-auto h-full hide-scrollbar" id="pages-container" ref="pagesContainer"
        :class="{
          'flex-row': direction === 'ltr',
          'flex-row-reverse': direction === 'rtl',
          'snap-x snap-mandatory': isSnapEnabled
          }"
      >
        <div class="snap-none w-0 hidden lg:block lg:w-[calc(15vw-1.5rem)] h-screen flex-none" style="scroll-snap-align: none">
        </div>

        <div class="snap-center w-[90vw] lg:w-[70vw] pt-[60px] pb-10 h-screen flex-none flex justify-center items-center" :class="{ 'invisible': isZoom }" id="heading" ref="heading">
          <ChapterHeading :manga="manga" :chapter="chapter" :team="team" :activeZoom="isZoom" @changeUI="changeUI" :direction="direction" :ui="'zen'" @toNextPage="toNextPage" @showUIHelpModal="$emit('showUIHelpModal')" />
        </div>

        <div class="h-screen max-w-[100vw] snap-center snap-stop-always flex-none flex justify-center items-center" id="banner" ref="banner">
          <a href="https://cuutruyen.net/donate" target="_blank" rel="noopener noreferrer" class="w-full h-full">
            <img
              src="@/assets/img/oneshot-dayruined.jpg"
              alt=""
              class="object-scale-down w-full h-full"
              width="2000"
              height="2000"
              @click="isShowNavbar = !isShowNavbar"
            >
          </a>
        </div>

        <div
          v-for="(page, index) in pages"
          :key="`page-container-${page.id}`"
          :id="`page-container-${page.id}`"
          :data-id="page.id"
          :data-index="index"
          class="w-screen h-screen snap-center snap-stop-always flex justify-center items-center"
          ref="pages"
        >
          <PageNew
            :data-id="page.id"
            :data-index="index"
            :index="index"
            :isActive="activePageIndex === index"
            :page="page"
            :pages="pages"
            :shouldLoad="pagesLoad[index]"
            :pagesVisible="pagesVisible"
            :isVisible="pagesVisible[index]"
            :pageIndex="index"
            :isShowSidebar="isShowSidebar"
            :marginless="manga.marginless"
            :activeZoom="isZoom"
            @pageLoaded="pageLoaded"
            @startZoom="handleStartZoom"
            @cancelZoom="isZoom = false"
            @toggleNavbar="isShowNavbar = !isShowNavbar"
            @toPage="toPageThrottled"
          />
        </div>

        <div class="snap-center w-[90vw] lg:w-[70vw] pt-[60px] pb-10 h-screen flex-none flex justify-center items-center" :class="{ 'invisible': isZoom }" id="trailing" ref="trailing">
          <ChapterTrailing :manga="manga" :chapter="chapter" :team="team" :activeZoom="isZoom" />
        </div>

        <div class="snap-none w-0 hidden lg:block lg:w-[calc(15vw-1.5rem)] h-screen flex-none" style="scroll-snap-align: none">
        </div>
      </div>

      <PageNavigation v-if="!isZoom" :isVisible="isNavigationButtonVisible" :direction="direction" action="next" @click="toNextPageThrottled" />
      <PageNavigation v-if="!isZoom" :isVisible="isNavigationButtonVisible" :direction="direction" action="prev" @click="toPreviousPageThrottled" />
      <QuickChaptersList v-model="showQuickChaptersList" />
    </div>
  </div>
</template>

<script>
import { mapGetters, mapMutations } from 'vuex'
import NavBar from '@/components/layout/default/NavBar'
import PageNew from '@/components/Page2'
import ChapterHeading from '@/components/chapter/ChapterHeading'
import ChapterTrailing from '@/components/chapter/ChapterTrailing'
import ChapterSidebar from '@/components/chapter/ChapterSidebar'
import ChapterTooltipNew from '@/components/chapter/ChapterTooltipNew'
import PageNavigation from '@/components/chapter/zen/PageNavigation'
import QuickChaptersList from '@/components/chapter/QuickChaptersList'
import _throttle from 'lodash.throttle'
import { addHistory, listHistoriesByChapter } from '@/spy-apis'

export default {
  components: {
    NavBar,
    PageNew,
    ChapterHeading,
    ChapterTrailing,
    ChapterSidebar,
    ChapterTooltipNew,
    PageNavigation,
    QuickChaptersList
  },

  computed: {
    direction () {
      if (!this.manga) {
        return null
      }

      return this.manga.direction || 'rtl'
    },
    ...mapGetters([
      'currentUser'
    ])
  },

  props: {
    manga: Object,
    chapter: Object,
    team: Object,
    pages: Array
  },

  data () {
    return {
      pagesLoad: [],
      pagesVisible: [],
      currentPage: null,
      activePageIndex: null,
      highestReadPages: -1,
      isShowSidebar: false,
      visiblePageObserver: null,
      activePageObserver: null,
      isShowNavbar: true,
      isNavigationButtonVisible: true,
      isZoom: false,
      isSnapEnabled: true,
      isScrollAnimating: false,
      isFirefox: navigator.userAgent.toLowerCase().indexOf('firefox') > -1,
      showQuickChaptersList: false,
      keydownEventListener: (event) => {
        if (this.isShowSidebar) {
          return
        }

        switch (event.key) {
          case 'ArrowLeft':
            event.preventDefault()

            if (this.direction === 'rtl') {
              this.toNextPageThrottled()
            } else {
              this.toPreviousPageThrottled()
            }
            break
          case 'ArrowRight':
            event.preventDefault()

            if (this.direction === 'rtl') {
              this.toPreviousPageThrottled()
            } else {
              this.toNextPageThrottled()
            }
            break
          case 'PageUp':
          case 'ArrowUp':
            event.preventDefault()

            if (this.chapter.next_chapter_id) {
              this.$router.push({ name: 'Chapter', params: { mangaId: this.manga.id, id: this.chapter.next_chapter_id } })
            }
            break
          case 'PageDown':
          case 'ArrowDown':
            event.preventDefault()

            if (this.chapter.previous_chapter_id) {
              this.$router.push({ name: 'Chapter', params: { mangaId: this.manga.id, id: this.chapter.previous_chapter_id } })
            }
            break
        }
      },
      resizeEventListener: (event) => {
        this.reorder()
      },
      wheelHandlerThrottled: _throttle((event) => {
        if (this.isShowSidebar) {
          return
        }

        if (event.deltaY < 0) {
          this.toPreviousPage()
        } else {
          this.toNextPage()
        }
      }, 100, { leading: true, trailing: false }),
      windowWheelListener: (event) => {
        event.preventDefault()
        event.stopPropagation()
        this.wheelHandlerThrottled(event)
      },
      toNextPageThrottled: _throttle(() => {
        this.toNextPage()
      }, 100, { leading: true, trailing: false }),
      toPageThrottled: _throttle((pageIndex) => {
        this.toPage(pageIndex)
      }, 100, { leading: true, trailing: false }),
      toPreviousPageThrottled: _throttle(() => {
        this.toPreviousPage()
      }, 100, { leading: true, trailing: false })
    }
  },

  created () {
    this.pagesLoad = Array(this.pages.length).fill(false)
    this.pagesVisible = Array(this.pages.length).fill(false)
    this.$set(this.pagesLoad, 0, true)
  },

  async mounted () {
    this.$nextTick(async () => {
      this.detectVisiblePage()
      this.checkActivePage()
      this.detectKeyPresses()

      window.addEventListener('resize', this.resizeEventListener)
      this.$refs.pagesContainer.addEventListener('wheel', this.windowWheelListener, { passive: false, capture: true })

      this.toReadingPage()
    })
  },

  methods: {
    ...mapMutations(['setMessengerVisible']),

    async toReadingPage () {
      const history = await this.getHistory()

      if (history && history.read_pages > 0 && history.read_pages < this.pages.length) {
        const pageIndex = history.read_pages - 1
        this.$set(this.pagesLoad, pageIndex, true)
        this.toPage(pageIndex)
      }
    },

    async getHistory () {
      const response = await listHistoriesByChapter(this.currentUser.id, this.manga.id, this.chapter.id)
      const histories = response.data

      if (histories.length > 0) {
        return histories[0]
      }

      return null
    },

    reorder () {
      if (this.$refs.pagesContainer) {
        this.$refs.pagesContainer.scrollLeft += 1
      }
    },

    changeUI (ui) {
      this.$emit('changeUI', ui)
    },

    getUrl (path) {
      return `${process.env.VUE_APP_API_BASE_URL}${path}`
    },

    toTop () {
      this.toHeading()
    },

    handleStartZoom () {
      this.isZoom = true
      this.isShowNavbar = false
    },

    detectKeyPresses () {
      window.addEventListener('keydown', this.keydownEventListener)
    },

    emulatedSmoothScroll (itemScrollLeft, duration = 400) {
      this.isSnapEnabled = false
      this.isScrollAnimating = true
      const startTime = performance.now()
      const startScrollLeft = this.$refs.pagesContainer.scrollLeft

      const animFn = (x) => 1 - (1 - x) * (1 - x)

      const scroll = (currentTime) => {
        const elapsedTime = (currentTime - startTime) > 0 ? (currentTime - startTime) : 0
        if (elapsedTime > duration) {
          this.$refs.pagesContainer.scroll({ left: itemScrollLeft })
          this.isSnapEnabled = true
          this.isScrollAnimating = false
        } else {
          const timeRate = (1.0 * elapsedTime) / duration
          const numberRate = animFn(timeRate)
          const currentScrollDistance = (itemScrollLeft - startScrollLeft) * numberRate
          const currentScrollLeft = startScrollLeft + currentScrollDistance
          this.$refs.pagesContainer.scroll({ left: currentScrollLeft })
          requestAnimationFrame(scroll)
        }
      }

      requestAnimationFrame(scroll)
    },

    toNextPage () {
      if (!this.$refs.pages || this.isZoom || this.isScrollAnimating) {
        return
      }

      const itemScrollLeft = this.nextActivePage().offsetLeft - (this.$refs.pagesContainer.offsetWidth / 2) + (this.nextActivePage().offsetWidth / 2)
      this.emulatedSmoothScroll(itemScrollLeft, 350)
    },

    toPage (pageIndex) {
      if (!this.$refs.pages || this.isZoom || this.isScrollAnimating) {
        return
      }

      const page = this.$refs.pages[pageIndex]
      const itemScrollLeft = page.offsetLeft - (this.$refs.pagesContainer.offsetWidth / 2) + (page.offsetWidth / 2)
      this.emulatedSmoothScroll(itemScrollLeft, 350)
    },

    toPreviousPage () {
      if (!this.$refs.pages || this.isZoom || this.isScrollAnimating) {
        return
      }

      const itemScrollLeft = this.previousActivePage().offsetLeft - (this.$refs.pagesContainer.offsetWidth / 2) + (this.previousActivePage().offsetWidth / 2)
      this.emulatedSmoothScroll(itemScrollLeft, 350)
    },

    toHeading () {
      if (!this.$refs.pages || this.isZoom || this.isScrollAnimating) {
        return
      }

      const itemScrollLeft = this.$refs.heading.offsetLeft - (this.$refs.pagesContainer.offsetWidth / 2) + (this.$refs.heading.offsetWidth / 2)
      this.emulatedSmoothScroll(itemScrollLeft, 350)
    },

    toTrailing () {
      if (!this.$refs.pages || this.isZoom || this.isScrollAnimating) {
        return
      }

      const itemScrollLeft = this.$refs.trailing.offsetLeft - (this.$refs.pagesContainer.offsetWidth / 2) + (this.$refs.trailing.offsetWidth / 2)
      this.emulatedSmoothScroll(itemScrollLeft, 350)
    },

    nextActivePage () {
      if (this.activePageIndex === 'trailing') {
        return this.$refs.trailing
      } else if (this.activePageIndex === 'banner') {
        return this.$refs.pages[0]
      } else if (this.activePageIndex === 'heading') {
        if (this.$refs.banner) {
          return this.$refs.banner
        } else {
          return this.$refs.pages[0]
        }
      } else if (this.activePageIndex === this.$refs.pages.length - 1) {
        return this.$refs.trailing
      } else {
        return this.$refs.pages[this.activePageIndex + 1]
      }
    },

    previousActivePage () {
      console.log(this.activePageIndex)
      if (this.activePageIndex === 'trailing') {
        return this.$refs.pages[this.$refs.pages.length - 1]
      } else if (this.activePageIndex === 'banner') {
        return this.$refs.heading
      } else if (this.activePageIndex === 'heading') {
        return this.$refs.heading
      } else if (this.activePageIndex === 0) {
        if (this.$refs.banner) {
          return this.$refs.banner
        } else {
          return this.$refs.heading
        }
      } else {
        return this.$refs.pages[this.activePageIndex - 1]
      }
    },

    checkActivePage () {
      if (!this.$refs.pages) {
        return
      }

      this.activePageObserver = new IntersectionObserver((entries, observer) => {
        if (this.isZoom) {
          return
        }

        entries.forEach(entry => {
          if (entry.isIntersecting) {
            if (entry.target.dataset.index) {
              const index = Number(entry.target.dataset.index)
              this.activePageIndex = index
              this.currentPage = this.pages[index]
              this.isShowNavbar = false

              if (this.activePageIndex === 'banner' || this.activePageIndex >= 0) {
                this.isNavigationButtonVisible = false
              }
            } else if (entry.target.id === 'heading') {
              this.activePageIndex = 'heading'
              this.currentPage = this.pages[0]
              this.isShowNavbar = true
            } else if (entry.target.id === 'trailing') {
              this.activePageIndex = 'trailing'
              this.currentPage = this.pages[this.pages.length - 1]
              this.isShowNavbar = true
            } else if (entry.target.id === 'banner') {
              this.activePageIndex = 'banner'
              this.currentPage = this.pages[0]
              this.isShowNavbar = false
            }
          }
        })
      }, {
        root: this.$refs.pagesContainer,
        rootMargin: '0px -50% 0px -50%',
        threshold: [0]
      })

      this.$refs.pages.forEach(pageElement => {
        this.activePageObserver.observe(pageElement)
      })
      this.activePageObserver.observe(this.$refs.heading)
      if (this.$refs.banner) {
        this.activePageObserver.observe(this.$refs.banner)
      }
      this.activePageObserver.observe(this.$refs.trailing)
    },

    pageLoaded (index) {
      const nextIndex = index + 1

      if (nextIndex < this.pagesLoad.length && !this.pagesLoad[nextIndex]) {
        this.$set(this.pagesLoad, nextIndex, true)
      }
    },

    showSidebar () {
      this.isShowSidebar = true
      this.$gtag.event('show_comment')
    },

    hideSidebar () {
      this.isShowSidebar = false
    },

    detectVisiblePage () {
      if (this.pages.length === 0 || !this.$refs.pages) {
        return
      }

      this.visiblePageObserver = new IntersectionObserver((entries, observer) => {
        entries.forEach(entry => {
          const index = Number(entry.target.dataset.index)

          if (entry.isIntersecting) {
            this.$set(this.pagesVisible, index, true)
          } else {
            this.$set(this.pagesVisible, index, false)
          }
        })
      }, {
        threshold: [0]
      })

      this.$nextTick(() => {
        this.$refs.pages.forEach(pageElement => {
          this.visiblePageObserver.observe(pageElement)
        })
      })
    }
  },

  watch: {
    isShowNavbar (to, from) {
      if (to) {
        this.setMessengerVisible(true)
      } else {
        this.setMessengerVisible(false)
      }
    },
    activePageIndex (to, from) {
      if (to !== null) {
        if (!this.currentUser) {
          return
        }

        let readPages

        if (this.activePageIndex === 'heading' || this.activePageIndex === 'banner') {
          console.log('record', this.activePageIndex)
        } else if (this.activePageIndex === 'trailing') {
          console.log('record', this.activePageIndex)
          readPages = this.pages.length
        } else {
          console.log('record', this.activePageIndex)
          readPages = this.activePageIndex + 1
        }

        if (this.highestReadPages < readPages) {
          this.highestReadPages = readPages

          addHistory({
            userId: Number(this.currentUser.id),
            mangaId: Number(this.manga.id),
            mangaName: this.manga.name,
            mangaCoverUrl: this.manga.cover_mobile_url,
            chapterId: Number(this.chapter.id),
            chapterNumber: this.chapter.number || '',
            chapterName: this.chapter.name || '',
            readPages: Number(readPages),
            totalPages: Number(this.pages.length)
          })
        }
      }
    }
  },

  beforeDestroy () {
    this.releaseBodyScroll()
    this.setMessengerVisible(true)
    window.removeEventListener('keydown', this.keydownEventListener)
    this.$refs.pagesContainer.removeEventListener('wheel', this.windowWheelListener, { passive: false, capture: true })
  }
}
</script>

<style scoped>
.pages-container-snap {
  @apply snap-x snap-mandatory;
}

.h-screen-ios {
  height: 100vh;
  height: -webkit-fill-available;
}
</style>
