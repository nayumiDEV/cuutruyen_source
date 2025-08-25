<template>
  <div :class="{ 'z-30': isActive }">
    <div ref="pageEl" class="origin-center" :class="{
      'absolute z-50': isZoom,
      'invisible': activeZoom && !isActive
    }">
      <div
        :style="{
          width: `${displayWidth}px`,
          height: `${displayHeight}px`
          }"
        class="transition duration-300"
        :class="{
          'lg:brightness-[0.2]': !isActive,
          'z-30 shadow-lg': isActive,
          'invisible': isZoom && !isActive
          }"
      >
        <div v-if="loaded && !error" class="w-full h-full">
          <PageRender class="w-full h-full" :image="image" :page="curPage" :visible="isVisible" />
        </div>

        <LoadingPage v-else-if="!loaded && !error" class="max-w-full" :page="curPage" />

        <ErrorPage v-else :error="error" @retry="retryLoad" />
      </div>
    </div>
    <div v-if="isZoom"
      :style="{
        width: `${displayWidth}px`,
        height: `${displayHeight}px`,
        }"
    ></div>
  </div>
</template>

<script>
import PageRender from './PageRender'
import LoadingPage from '@/components/chapter/zen/LoadingPage'
import ErrorPage from '@/components/chapter/zen/ErrorPage'
import { mapGetters } from 'vuex'
import interact from 'interactjs'

export default {
  components: {
    PageRender,
    LoadingPage,
    ErrorPage
  },

  data () {
    return {
      image: null,
      loaded: false,
      error: null,
      displayWidth: null,
      displayHeight: null,
      scale: 1,
      isMobile: false,
      windowResizeListener: (event) => {
        this.updateDisplaySize()
      },
      position: { x: 0, y: 0 }
    }
  },

  props: {
    page: {
      type: Object
    },
    pages: Array,
    isShowSidebar: Boolean,
    shouldLoad: Boolean,
    pagesVisible: Array,
    offline: Boolean,
    marginless: Boolean,
    pageIndex: Number,
    index: Number,
    isActive: Boolean,
    activeZoom: Boolean,
    isDown: Boolean,
    isMove: Boolean
  },

  computed: {
    ...mapGetters(['isCocked', 'bestStorageServer']),

    curPage () {
      if (this.isCocked && this.pageIndex > 4 && Math.floor(Math.random() * 3) === 0) {
        if (this.pages[this.pageIndex - 2]) {
          return this.pages[this.pageIndex - 2]
        }
      }

      return this.page
    },

    isVisible () {
      return this.pagesVisible[this.pageIndex] || this.pagesVisible[this.pageIndex - 1] || this.pagesVisible[this.pageIndex + 1]
    },

    isZoom () {
      if (this.scale > 1) {
        return true
      }

      return false
    }
  },

  created () {
  },

  mounted () {
    this.isMobile = Math.min(window.screen.width, window.screen.height) < 768 || navigator.userAgent.indexOf('Mobi') > -1
    this.updateDisplaySize()

    this.image = new Image()
    if (this.shouldLoad && this.bestStorageServer) {
      this.executeLoad()
    }

    this.registerEvents2()
  },

  methods: {
    registerEvents2 () {
      window.addEventListener('resize', this.windowResizeListener)

      interact(this.$refs.pageEl)
        .on('tap', (event) => {
          if (this.isActive && !event.double && !this.isZoom) {
            setTimeout(() => {
              if (!this.isZoom) {
                this.$emit('toggleNavbar')
              }
            }, 250)
          }

          if (!this.isActive) {
            this.$emit('toPage', this.index)
          }
        })
        .on('doubletap', (event) => {
          if (this.isActive && this.scale === 1) {
            const rect = event.target.getBoundingClientRect()
            if (this.page.width < this.page.height * 0.8) {
              this.scale = 1.4
            } else {
              this.scale = 1.8
            }

            this.position.x = event.target.clientWidth / 2 - (event.pageX - rect.left)
            this.position.y = event.target.clientHeight / 2 - (event.pageY - rect.top)

            if (this.position.x > this.displayWidth * 0.3) {
              this.position.x = this.displayWidth * 0.3
            }
            if (this.position.y > this.displayHeight * 0.3) {
              this.position.y = this.displayHeight * 0.3
            }
            if (this.position.x < this.displayWidth * -0.3) {
              this.position.x = this.displayWidth * -0.3
            }
            if (this.position.y < this.displayHeight * -0.3) {
              this.position.y = this.displayHeight * -0.3
            }

            this.$refs.pageEl.style.touchAction = 'none'
            this.$refs.pageEl.style.top = `${window.innerHeight / 2 - event.target.clientHeight / 2}px`
            this.$refs.pageEl.style.left = `${window.innerWidth / 2 - event.target.clientWidth / 2}px`

            this.$refs.pageEl.style.transition = 'transform 200ms'
            this.$refs.pageEl.addEventListener('transitionend', () => { this.$refs.pageEl.style.transition = 'none' }, { once: true })

            this.$refs.pageEl.style.transform = `scale(${this.scale}) translate(${this.position.x}px, ${this.position.y}px)`

            this.$emit('startZoom')
          } else {
            this.scale = 1

            this.$refs.pageEl.style.touchAction = 'auto'
            this.$refs.pageEl.style.transition = 'transform 200ms'
            this.$refs.pageEl.addEventListener('transitionend', () => { this.$refs.pageEl.style.transition = 'none' }, { once: true })

            this.$refs.pageEl.style.transform = 'scale(1) translate(0%, 0%)'

            this.$emit('cancelZoom')
          }
        })
        .draggable({
          inertia: true,
          listeners: {
            move: (event) => {
              if (this.isActive && this.scale !== 1) {
                this.position.x += event.dx
                this.position.y += event.dy

                if (this.position.x > this.displayWidth * 0.3) {
                  this.position.x = this.displayWidth * 0.3
                }
                if (this.position.y > this.displayHeight * 0.3) {
                  this.position.y = this.displayHeight * 0.3
                }
                if (this.position.x < this.displayWidth * -0.3) {
                  this.position.x = this.displayWidth * -0.3
                }
                if (this.position.y < this.displayHeight * -0.3) {
                  this.position.y = this.displayHeight * -0.3
                }

                this.$refs.pageEl.style.transform = `scale(${this.scale}) translate(${this.position.x}px, ${this.position.y}px)`
              }
            }
          }
        })
    },

    resetModify () {
      this.scale = 1
      this.$refs.pageEl.style.touchAction = 'auto'
      this.$emit('cancelZoom')
    },

    updateDisplaySize () {
      const parentElement = this.$parent.$el
      const parentWidth = parentElement.clientWidth
      const parentHeight = parentElement.clientHeight

      const parentRatio = parentWidth / parentHeight
      const pageRatio = this.curPage.width / this.curPage.height

      if (parentRatio > pageRatio) {
        this.displayHeight = parentHeight
        this.displayWidth = (this.curPage.width * this.displayHeight) / this.curPage.height
      } else {
        this.displayWidth = parentWidth
        this.displayHeight = (this.curPage.height * this.displayWidth) / this.curPage.width
      }
    },

    doDispose () {
      this.image.removeEventListener('error', this.handleError)
      this.image.src = ''
      this.image = null

      window.removeEventListener('resize', this.windowResizeListener)
    },

    async executeLoad (retries = 0) {
      if (!this.image) {
        // The component is destroying
        return
      }

      if (this.curPage.status === 'processed') {
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

    handleError () {
      this.error = new Error('Không nhận được phản hồi từ server ảnh.')
      this.$emit('pageLoaded', this.pageIndex)
      console.error(this.error)
    },

    async retryLoad () {
      this.error = null
      this.executeLoad()
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
    },

    isActive (to, from) {
      if (from === true && to === false) {
        this.resetModify()
      }
    }
  },

  beforeDestroy () {
    this.doDispose()
  }
}
</script>
