<template>
  <div :class="{'z-30': isActive}">
    <div ref="pageEl" class="" :class="{
      'fixed top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 z-50': isZoom,
      'invisible': activeZoom && !isActive
    }">
      <div
        :style="{
          width: `${displayWidth}px`,
          height: `${displayHeight}px`,
          transform: `scale(${scale})`,
          transformOrigin: transformOrigin,
          touchAction: touchAction
          }"
        class="transition duration-300"
        :class="{
          'lg:brightness-[0.2]': !isActive,
          'z-30 shadow-lg': isActive,
          'invisible': isZoom && !isActive
          }"
      >
        <div v-if="loaded && !error" class="w-full h-full"
        >
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

export default {
  components: {
    PageRender,
    LoadingPage,
    ErrorPage
  },

  data () {
    return {
      image: null,
      parts: [],
      loaded: false,
      error: null,
      displayWidth: null,
      displayHeight: null,
      clicks: 0,
      clickCoords: [],
      scale: 1,
      // translate: '0%, 0%',
      originX: 'center',
      originY: 'center',
      touchAction: 'auto',
      isMobile: false,
      windowResizeListener: (event) => {
        this.updateDisplaySize()
      }
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

    transformOrigin () {
      if (!this.originX || !this.originY) {
        return 'center'
      } else {
        return `${this.originX}px ${this.originY}px`
      }
    },

    isZoom () {
      if (this.scale > 1) {
        return true
      }

      return false
    },

    translate () {
      if (this.isZoom) {
        return '-50%, -50%'
      }

      return '0%, 0%'
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

    this.registerEvents()
  },

  methods: {
    registerEvents () {
      window.addEventListener('resize', this.windowResizeListener)

      this.$refs.pageEl.addEventListener('pointerup', (event) => {
        event.preventDefault()
        if (this.isActive && !this.isMove) {
          const rect = event.target.getBoundingClientRect()
          const x = event.clientX - rect.left
          const y = event.clientY - rect.top

          this.clicks += 1
          this.clickCoords.push([x, y])

          if (this.clicks === 1) {
            setTimeout(() => {
              if (this.clicks === 1) {
                if (!this.isZoom) {
                  this.$emit('toggleNavbar')
                }
              }
            }, 250)
          } else if (this.clicks >= 2) {
            // double click
            const currentClickCoord = this.clickCoords[this.clickCoords.length - 1]
            const previousClickCoord = this.clickCoords[this.clickCoords.length - 2]
            if (currentClickCoord[0] < previousClickCoord[0] + 20 &&
                currentClickCoord[0] > previousClickCoord[0] - 20 &&
                currentClickCoord[1] < previousClickCoord[1] + 20 &&
                currentClickCoord[1] > previousClickCoord[1] - 20
            ) {
              // real double click
              if (this.scale === 1) {
                this.scale = 1.6
                this.originX = (x / this.displayWidth) * this.displayWidth
                this.originY = (y / this.displayHeight) * this.displayHeight
                this.touchAction = 'none'
                this.$emit('startZoom')
              } else {
                this.scale = 1
                this.touchAction = 'auto'
                this.$emit('cancelZoom')
              }
            }
          }

          setTimeout(() => {
            this.clicks = 0
            this.clickCoords = []
          }, 250)
        } else if (!this.isMove) {
          this.$emit('toPage', this.index)
        }
      }, true)

      this.$refs.pageEl.addEventListener('pointermove', (event) => {
        const deltaX = event.movementX
        const deltaY = event.movementY

        if (this.scale !== 1 && this.isDown) {
          let originX
          let originY

          originX = this.originX - deltaX * 1.6
          originY = this.originY - deltaY * 1.6

          if (originX < this.displayWidth * (-0.2)) {
            originX = this.displayWidth * (-0.2)
          }

          if (originX > this.displayWidth * 1.2) {
            originX = this.displayWidth * 1.2
          }

          if (originY < this.displayHeight * (-0.2)) {
            originY = this.displayHeight * (-0.2)
          }

          if (originY > this.displayHeight * 1.2) {
            originY = this.displayHeight * 1.2
          }

          this.originX = originX
          this.originY = originY
        }
      })
    },

    resetModify () {
      this.scale = 1
      this.touchAction = 'auto'
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
