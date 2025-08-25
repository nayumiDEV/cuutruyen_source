<template>
  <div class="flex shadow-lg">
    <main class="my-12 flex-grow transition origin-top w-full overflow-hidden" ref="main">
      <template v-if="loading">
        <LoadingScreen />
      </template>

      <template v-else-if="error">
        <div class="h-screen common-container flex flex-col justify-center items-center">
          <div class="text-yellow-400 text-center mb-6">
            Chương mà bạn đang cố xem offline có vẻ là chưa được tải xuống từ trước, hoặc quá trình tải xuống đã bị lỗi.
          </div>

          <router-link
            :to="{ name: 'SavedOffline', query: { mangaId: $route.params.mangaId } }"
            class="text-xl mb-2 text-gray-400 hover:text-gray-200 py-1 flex items-center"
          >
            <ArrowLeftIcon class="inline-block mr-1" /> Danh sách truyện đã tải xuống
          </router-link>
        </div>
      </template>

      <template v-else-if="manga">
        <OfflineNotify :toRoute="{ name: 'Chapter', params: { mangaId: manga.id, id: chapter.id } }" />

        <div class="max-w-screen-md lg:max-w-screen-lg xl:max-w-screen-xl mx-auto px-2 mb-16">
          <router-link
            :to="{ name: 'SavedOffline', query: { mangaId: manga.id } }"
            class="text-xl mb-2 text-gray-400 hover:text-gray-200 py-1 flex items-center">
            <ArrowLeftIcon class="inline-block mr-1" /> {{ manga.name }}
          </router-link>
          <h1 class="text-3xl text-gray-100 mb-6">
            <span>Chương {{ chapter.number }}</span>
            <span v-if="chapter.name">. {{ chapter.name }}</span>
          </h1>
        </div>

        <template v-if="pages.length > 0">
          <div ref="content" class="select-none flex flex-col items-center">
            <Page
              v-for="(page, index) in pages"
              :key="`page-${page.id}`"
              :id="`page-${page.id}`"
              :data-id="page.id"
              :data-index="index"
              :offline="true"
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

          <div class="text-gray-600 text-sm flex flex-col items-center mt-12">
            <div class="max-w-screen-sm w-full flex">
              <button class="uppercase button bg-gray-800 text-gray-300 w-full px-2 py-4 text-center" @click.prevent="toTop">Lên đầu</button>
            </div>
          </div>
        </template>
        <EmptyScreen v-else message="Chưa có trang nào trong chương truyện bạn đang xem. Nếu bạn nhìn thấy thông báo này, có thể là do các trang đang được upload hoặc đang xử lý." />
      </template>
    </main>
  </div>
</template>

<script>
import ArrowLeftIcon from 'vue-material-design-icons/ArrowLeft.vue'
import db from '@/db'
import Page from '@/components/offline/Page'
import OfflineNotify from '@/components/OfflineNotify'

export default {
  metaInfo () {
    if (!this.chapter) {
      return {}
    }

    return {
      title: `Chương ${this.chapter.number} - Đọc ${this.manga.name}`,
      meta: [
        { vmid: 'description', name: 'description', content: `Đọc chương ${this.chapter.number} - ${this.manga.description}` }
      ]
    }
  },

  components: {
    Page,
    OfflineNotify,
    ArrowLeftIcon
  },

  data () {
    return {
      chapter: null,
      manga: null,
      previousChapter: null,
      nextChapter: null,
      loading: false,
      error: false,
      pages: null,
      pagesLoad: [],
      pagesVisible: [],
      offline: null,
      doIncrement: null,
      sb: null,
      currentScale: 1,
      currentPage: null,
      isShowSidebar: false,
      visiblePageObserver: null
    }
  },

  async mounted () {
    await this.loadChapter()

    this.$nextTick(() => {
      this.detectVisiblePage()
    })
  },

  methods: {
    getUrl (path) {
      return `${process.env.VUE_APP_API_BASE_URL}${path}`
    },

    toTop () {
      window.scrollTo(0, 0)
    },

    async loadChapter () {
      this.loading = true
      try {
        const chapter = await db.chapters.get({ id: Number(this.$route.params.id) })
        this.manga = await db.mangas.get({ id: Number(this.$route.params.mangaId) })
        const pages = await db
          .pages
          .where({ 'chapter.id': chapter.id })
          .toArray()
        this.pages = pages.sort((a, b) => {
          return a.order - b.order
        })
        this.pagesLoad = Array(this.pages.length).fill(false)
        this.pagesVisible = Array(this.pages.length).fill(false)
        this.chapter = chapter
        this.$set(this.pagesLoad, 0, true)
      } catch (error) {
        this.error = true
        console.error(error)
      } finally {
        this.loading = false
      }
    },

    pageLoaded (index) {
      setTimeout(() => {
        if (index + 1 < this.pagesLoad.length) {
          this.$set(this.pagesLoad, index + 1, true)
        }
      }, 0)
    },

    detectVisiblePage () {
      if (this.pages.length === 0) {
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
    },

    showSidebar () {
      this.isShowSidebar = true
    },

    hideSidebar () {
      this.isShowSidebar = false
    }
  },

  beforeDestroy () {
    clearTimeout(this.doIncrement)
  },

  watch: {
    $route (to, from) {
      this.loadChapter()
    }
  }
}
</script>
