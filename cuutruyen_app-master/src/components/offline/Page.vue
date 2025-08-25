<template>
  <RatioBox
    class="transition transform"
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
    <div v-if="loaded && !error" class="max-w-full xl:max-w-none h-full flex flex-col"
    >
      <PageRender class="w-full" :image="image" :page="page" :visible="isVisible" />
    </div>

    <LoadingPage v-else-if="!loaded && !error" class="max-w-full" :page="page" />

    <ErrorPage v-else :error="error" @retry="retryLoad" />
  </RatioBox>
</template>

<script>
import PageRender from '../PageRender'
import RatioBox from '../RatioBox'
import LoadingPage from '@/components/LoadingPage'
import ErrorPage from '@/components/ErrorPage'

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
    isShowSidebar: Boolean,
    currentPage: Object,
    shouldLoad: Boolean,
    pagesVisible: Array,
    offline: Boolean,
    marginless: Boolean,
    pageIndex: Number
  },

  computed: {
    isVisible () {
      return this.pagesVisible[this.pageIndex] || this.pagesVisible[this.pageIndex - 1] || this.pagesVisible[this.pageIndex - 2] || this.pagesVisible[this.pageIndex + 1]
    }
  },

  created () {
    this.image = new Image()
    if (this.shouldLoad === true) {
      this.executeLoad()
    }
  },

  methods: {
    doDispose () {
      this.image.removeEventListener('error', this.handleError)
      this.image.src = ''
      this.image = null
    },

    async getScrambledUrl () {
      return URL.createObjectURL(new Blob([this.page.imageBuffer], { type: this.page.imageBufferType }))
    },

    async executeLoad (retries = 0) {
      if (!this.image) {
        // The component is destroying
        return
      }

      this.image.src = await this.getScrambledUrl()
      this.image.addEventListener('load', this.executeDecryption)

      this.image.addEventListener('error', (error) => {
        if (!this.image) {
          // The component is destroying
          return
        }

        if (retries < 3) {
          retries += 1
          this.executeLoad(retries)
          console.log(error)
          console.error(`Error loading image! Retrying: ${retries}.`)
        } else {
          this.handleError()
        }
      })
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
      if (from === false && to === true) {
        this.executeLoad()
      }
    }
  },

  beforeDestroy () {
    this.doDispose()
  }
}
</script>
