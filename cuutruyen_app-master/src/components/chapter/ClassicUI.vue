<template>
  <div class="flex flex-col bg-gray-900">
    <NavBar class="w-full fine-shadow z-40 transition duration-400" :glassy="true" theme="dark" />

    <ChapterTooltip
      v-if="chapter && pages && currentPage"
      :chapter="chapter"
      :pages="pages"
      :currentPage="currentPage"
      :totalPages="pages.length"
      :isShowSidebar="isShowSidebar"
      @showSidebar="showSidebar"
      @toTop="toTop"
      @showQuickChaptersList="showQuickChaptersList = true"
    />

    <ChapterSidebar
      v-if="chapter && pages"
      :chapter="chapter"
      :error="error"
      :isShowSidebar="isShowSidebar"
      @hideSidebar="hideSidebar"
    />

    <main class="my-12 flex-grow transition origin-top w-full overflow-hidden min-h-screen" ref="main">
      <template v-if="loading || !chapter || !pages">
        <LoadingScreen />
      </template>

      <template v-else>
        <div class="w-full max-w-screen-sm mx-auto px-2 mb-12">
          <div v-if="showUIChooser" class="flex justify-center items-center mb-4">
            <UIChooser :ui="'classic'" @changeUI="changeUI" @showUIHelpModal="$emit('showUIHelpModal')" />
          </div>

          <div class="flex justify-between mb-12">
            <router-link
              :to="{ name: 'Manga', params: { id: manga.id } }"
              class="text-sm mb-2 text-gray-400 hover:text-gray-200 py-1 flex items-center">
              <ArrowLeftIcon class="inline-block mr-1" :size="16" /> {{ manga.name }}
            </router-link>
          </div>

          <h1 class="text-xl text-gray-100 mb-6">
            <span>Chương {{ chapter.number }}</span>
            <span v-if="chapter.name">: {{ chapter.name }}</span>
          </h1>

          <div class="flex items-stretch flex-col gap-2">
            <div>
              <router-link
                v-if="chapter.next_chapter_id"
                :to="{ name: 'Chapter', params: { mangaId: manga.id, id: chapter.next_chapter_id } }"
                class="flex justify-center items-center button bg-blue-900 hover:bg-blue-800 text-blue-100 px-3 py-2 text-sm uppercase font-bold"
              >
                Chương sau
              </router-link>

              <button
                v-else
                class="flex justify-center items-center button bg-gray-800 bg-opacity-20 text-gray-100 text-opacity-20 px-3 py-2 text-sm uppercase font-bold cursor-default w-full"
                disabled
              >
                Chương sau
              </button>
            </div>

            <div>
              <router-link
                v-if="chapter.previous_chapter_id"
                :to="{ name: 'Chapter', params: { mangaId: manga.id, id: chapter.previous_chapter_id } }"
                class="flex justify-center items-center button bg-gray-800 hover:bg-gray-700 text-gray-100 px-3 py-2 text-sm uppercase font-bold"
              >
                Chương trước
              </router-link>

              <button
                v-else
                class="flex justify-center items-center button bg-gray-900 bg-opacity-20 text-gray-100 text-opacity-20 px-3 py-2 text-sm uppercase font-bold cursor-default w-full"
                disabled
              >
                Chương trước
              </button>
            </div>
          </div>

          <div class="text-sm flex flex-col items-center mt-3">
            <div class="max-w-md text-center">
              <a href="https://www.messenger.com/channel/CuuTruyenTranh" target="_blank" class="text-yellow-400 hover:text-yellow-200 transition font-bold flex gap-2 items-center">
                <span>Tham gia kênh thông báo của Cứu Truyện</span>
              </a>
            </div>
          </div>

        </div>

        <template v-if="pages.length > 0 && pagesLoad.length > 0 && pagesVisible.length > 0">
          <div ref="content" class="select-none flex flex-col items-center">
            <div
              id="banner"
              ref="banner"
              :class="{
                'lg:max-w-screen-lg max-w-full mb-6 last:mb-0': !manga.marginless,
                'max-w-screen-md w-full': manga.marginless,
                }"
            >
              <a href="https://cuutruyen.net/donate" target="_blank" rel="noopener noreferrer">
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

            <Page
              v-for="(page, index) in pages"
              :key="`page-${page.id}`"
              :id="`page-${page.id}`"
              :data-id="page.id"
              :data-index="index"
              :page="page"
              :shouldLoad="pagesLoad[index]"
              :pagesVisible="pagesVisible"
              :isVisible="pagesVisible[index]"
              :pageIndex="index"
              :isShowSidebar="isShowSidebar"
              :currentPage="currentPage"
              :marginless="manga.marginless"
              @pageLoaded="pageLoaded"
              ref="pages"
            />
          </div>

          <div class="mt-12 w-full flex justify-center">
            <router-link
              v-if="chapter.next_chapter_id"
              :to="{ name: 'Chapter', params: { mangaId: manga.id, id: chapter.next_chapter_id } }"
              class="button w-full max-w-screen-sm button-primary py-3 px-3 text-center">
              <div class="uppercase font-bold">Xem tiếp chương {{ chapter.next_chapter_number }}</div>
              <div v-if="chapter.next_chapter_name" class="text-sm">{{ chapter.next_chapter_name }}</div>
            </router-link>

            <button v-else class="button w-full max-w-screen-sm py-3 px-3 button-disabled text-center" disabled>Đây là chương mới nhất</button>
          </div>
          <div class="mt-2 w-full flex justify-center">
            <div class="max-w-screen-sm w-full flex">
              <router-link
                v-if="chapter.previous_chapter_id"
                :to="{ name: 'Chapter', params: { mangaId: manga.id, id: chapter.previous_chapter_id } }"
                class="uppercase button bg-gray-800 text-gray-300 w-full px-1 py-1 mr-1 text-center">
                Chương trước - {{ chapter.previous_chapter_number }}
              </router-link>

              <button v-else class="uppercase button cursor-default border border-gray-800 text-gray-700 w-full px-1 py-1 mr-1 text-center" disabled>Chương cũ nhất</button>

              <button class="uppercase button bg-gray-800 text-gray-300 w-full px-1 py-1 ml-1 text-center" @click.prevent="toTop">Lên đầu</button>
            </div>
          </div>

          <div class="text-gray-600 text-sm flex flex-col items-center mt-12">
            <div class="max-w-md text-center">
              <div class="mb-2">
                Bạn đang xem và đọc truyện tranh manga (manhua, manhwa) <strong>{{ chapter.manga.name }}</strong> tại Cứu Truyện.
              </div>

              <div class="mb-2">
                Chương (chapter, chap) hiện tại mà bạn đang đọc là <strong>chapter {{ chapter.number }}</strong>
                <span v-if="chapter.name && chapter.name.length > 0"> ({{ chapter.name }})</span>.
              </div>

              <div v-if="chapter.next_chapter_id" class="mb-2">
                <span>Chương kế tiếp của truyện là <strong>chapter {{ chapter.next_chapter_number }}</strong></span>.
              </div>

              <div>{{ manga.description }}</div>
            </div>
          </div>
        </template>

        <EmptyScreen v-else message="Chưa có trang nào trong chương truyện bạn đang xem. Nếu bạn nhìn thấy thông báo này, có thể là do các trang đang được upload hoặc đang xử lý." />
      </template>
    </main>

    <AppFooter />
    <QuickChaptersList v-model="showQuickChaptersList" />
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
import Page from '@/components/Page'
import ChapterSidebar from '@/components/chapter/ChapterSidebar'
import ChapterTooltip from '@/components/chapter/ChapterTooltip'
import NavBar from '@/components/layout/default/NavBar'
import AppFooter from '@/components/layout/AppFooter'
import UIChooser from '@/components/chapter/UIChooser'
import ArrowLeftIcon from 'vue-material-design-icons/ArrowLeft.vue'
import QuickChaptersList from '@/components/chapter/QuickChaptersList'
import { addHistory, listHistoriesByChapter } from '@/spy-apis'

export default {
  components: {
    NavBar,
    AppFooter,
    Page,
    ChapterSidebar,
    ChapterTooltip,
    UIChooser,
    ArrowLeftIcon,
    QuickChaptersList
  },

  computed: {
    ...mapGetters([
      'currentUser', 'geo', 'isSpider'
    ])
  },

  props: {
    manga: Object,
    chapter: Object,
    pages: Array,
    team: Object,
    showUIChooser: Boolean
  },

  data () {
    return {
      loading: false,
      error: false,
      pagesLoad: [],
      pagesVisible: [],
      doIncrement: null,
      currentPage: null,
      activePageIndex: null,
      highestReadPages: -1,
      isShowSidebar: false,
      showQuickChaptersList: false,
      currentPageObserver: null,
      visiblePageObserver: null,
      keydownEventListener: (event) => {
        if (this.isShowSidebar) {
          return
        }

        switch (event.key) {
          case 'PageUp':
            event.preventDefault()

            if (this.chapter.next_chapter_id) {
              this.$router.push({ name: 'Chapter', params: { mangaId: this.manga.id, id: this.chapter.next_chapter_id } })
            }
            break
          case 'PageDown':
            event.preventDefault()

            if (this.chapter.previous_chapter_id) {
              this.$router.push({ name: 'Chapter', params: { mangaId: this.manga.id, id: this.chapter.previous_chapter_id } })
            }
            break
        }
      }
    }
  },

  async mounted () {
    this.pagesLoad = Array(this.pages.length).fill(false)
    this.pagesVisible = Array(this.pages.length).fill(false)
    this.$set(this.pagesLoad, 0, true)

    window.addEventListener('keydown', this.keydownEventListener)

    this.$nextTick(() => {
      this.detectCurrentPage()
      this.detectVisiblePage()
      this.toReadingPage()
    })
  },

  methods: {
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

    toPage (pageIndex) {
      if (!this.$refs.pages) {
        return
      }

      const page = this.$refs.pages[pageIndex]
      page.$el.scrollIntoView({ behavior: 'smooth' })
    },

    changeUI (ui) {
      this.$emit('changeUI', ui)
    },

    getUrl (path) {
      return `${process.env.VUE_APP_API_BASE_URL}${path}`
    },

    toTop () {
      window.scrollTo(0, 0)
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

    detectCurrentPage () {
      this.currentPage = this.pages[0]

      this.currentPageObserver = new IntersectionObserver((entries, observer) => {
        entries.forEach(entry => {
          if (entry.isIntersecting) {
            const index = Number(entry.target.dataset.index)
            this.activePageIndex = index
            this.currentPage = this.pages[index]
          }
        })
      }, {
        rootMargin: '-50% 0px -50% 0px',
        threshold: [0]
      })

      this.$nextTick(() => {
        this.$refs.pages.forEach(pageElement => {
          this.currentPageObserver.observe(pageElement.$el)
        })
      })
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
          this.visiblePageObserver.observe(pageElement.$el)
        })
      })
    }
  },

  watch: {
    activePageIndex (to, from) {
      console.log(to)
      if (to !== null) {
        if (!this.currentUser) {
          return
        }

        const readPages = this.activePageIndex + 1

        if (this.highestReadPages < readPages) {
          this.highestReadPages = readPages

          addHistory({
            userId: Number(this.currentUser.id),
            mangaId: Number(this.manga.id),
            mangaName: this.manga.name,
            mangaCoverUrl: this.manga.cover_url,
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
    window.removeEventListener('keydown', this.keydownEventListener)
    clearTimeout(this.doIncrement)
    if (this.currentPageObserver) {
      this.currentPageObserver.disconnect()
    }

    this.releaseBodyScroll()
  }
}
</script>
