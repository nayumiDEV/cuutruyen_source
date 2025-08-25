<template>
  <RatioBox
    class="transition transform"
    v-if="page.status === 'processed'"
    :width="page.width"
    :height="page.height"
    :isMarginless="marginless"
    :class="{
      'max-w-full mb-6 last:mb-0': !marginless,
      'lg:max-w-screen-lg': !marginless && page.width < page.height * 0.8,
      'max-w-screen-md w-full': marginless,
      'lg:translate-x-[14rem]': isShowSidebar
      }"
    :style="{
      width: marginless ? '100%' : `${page.width}px`
      }"
  >
    <div v-if="loaded && !error" class="max-w-full xl:max-w-none h-full flex flex-col">
      <PageRender class="w-full" :image="image" :page="page" :visible="isVisible" />
    </div>

    <LoadingPage v-else-if="!loaded && !error" class="max-w-full" :page="page" />

    <ErrorPage v-else :error="error" @retry="retryLoad" />
  </RatioBox>
</template>

<script>
import PageRender from './PageRender'
import RatioBox from './RatioBox'
import LoadingPage from '@/components/LoadingPage'
import ErrorPage from '@/components/ErrorPage'
import { mapGetters } from 'vuex'

export default {
  components: {
    PageRender,
    LoadingPage,
    ErrorPage,
    RatioBox
  },

  data () {
    return {
      image: null,
      parts: [],
      loaded: false,
      error: null
    }
  },

  props: {
    page: {
      type: Object
    },
    // pages: Array,
    isShowSidebar: Boolean,
    currentPage: Object,
    shouldLoad: Boolean,
    pagesVisible: Array,
    offline: Boolean,
    marginless: Boolean,
    pageIndex: Number
  },

  computed: {
    ...mapGetters(['isCocked', 'bestStorageServer']),

    // TODO cocked for legacy page
    // curPage () {
    //   if (this.isCocked && this.pageIndex > 4 && Math.floor(Math.random() * 3) === 0) {
    //     if (this.pages[this.pageIndex - 2]) {
    //       return this.pages[this.pageIndex - 2]
    //     }
    //   }
    //
    //   return this.page
    // },

    isVisible () {
      return this.pagesVisible[this.pageIndex] || this.pagesVisible[this.pageIndex - 1] || this.pagesVisible[this.pageIndex - 2] || this.pagesVisible[this.pageIndex + 1]
    }
  },

  created () {
    this.image = new Image()
    if (this.shouldLoad && this.bestStorageServer) {
      this.executeLoad()
    }
  },

  methods: {
    doDispose () {
      this.image.removeEventListener('error', this.handleError)
      this.image.src = ''
      this.image = null
    },

    async executeLoad (retries = 0) {
      if (!this.image) {
        // The component is destroying
        return
      }

      if (this.page.status === 'processed') {
        if (this.page.image_path) {
          this.image.src = `${this.bestStorageServer}${this.page.image_path}`
        } else {
          this.image.src = this.page.image_url
        }
        this.image.addEventListener('load', this.executeDecryption)

        this.image.addEventListener('error', () => {
          if (!this.image) {
            // The component is destroying
            return
          }

          if (retries < 3) {
            retries += 1
            this.executeLoad(retries)
            console.error(`Error loading image! Retrying: ${retries}.`)
          } else {
            this.handleError()
          }
        })
      } else {
        this.$emit('pageLoaded', this.pageIndex)
      }
    },

    async retryLoad () {
      this.error = null
      this.executeLoad()
    },

    handleError () {
      this.error = new Error('Không nhận được phản hồi từ server ảnh.')
      this.$emit('pageLoaded', this.pageIndex)
      console.error(this.error)
    },

    executeRenderNormal () {
      this.$emit('pageLoaded', this.pageIndex)
      this.loaded = true
    },

    executeDecryption () {
      this.$emit('pageLoaded', this.pageIndex)
      this.loaded = true
    }
  },

  watch: {
    shouldLoad (to, from) {
      if (!from && to && this.bestStorageServer) {
        this.executeLoad()
      }
    },

    bestStorageServer (to, from) {
      if (!from && to && this.shouldLoad) {
        this.executeLoad()
      }
    }
  },

  beforeDestroy () {
    this.doDispose()
  }
}
</script>
