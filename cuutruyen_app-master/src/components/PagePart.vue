<template>
  <canvas ref="canvas" :class="{ 'flex-grow': lastIndex }" :style="{ height: showHeight }" :width="width" :height="height" />
</template>

<script>
export default {
  props: {
    part: {
      type: Object
    },

    image: {
      type: HTMLImageElement
    },

    visible: {
      type: Boolean
    },

    index: {
      type: Number
    },

    lastIndex: {
      type: Boolean
    }
  },

  data () {
    return {
      width: 0,
      height: 0,
      showHeight: 'auto'
    }
  },

  methods: {
    renderCanvas () {
      const canvas = this.$refs.canvas
      this.width = this.part.width
      this.height = this.part.height

      this.$nextTick(() => {
        const ctx = canvas.getContext('2d')

        ctx.drawImage(
          this.image,
          this.part.sx, this.part.sy, this.part.sWidth, this.part.sHeight,
          this.part.dx, this.part.dy, this.part.dWidth, this.part.dHeight
        )

        if (navigator.userAgent.toLowerCase().indexOf('firefox') > -1 ||
          navigator.userAgent.toLowerCase().indexOf('cpu iphone os') > -1 ||
          navigator.userAgent.toLowerCase().indexOf('cpu os') > -1) {
          this.fixSubpixel()
          window.addEventListener('resize', this.fixSubpixel)
        }
      })
    },

    fixSubpixel () {
      const canvas = this.$refs.canvas
      this.showHeight = 'auto'
      this.$nextTick(() => {
        if (this.lastIndex) {
          this.showHeight = '100%'
        } else if (this.index % 3 === 0) {
          this.showHeight = Math.floor(canvas.getBoundingClientRect().height) + 'px'
        } else {
          this.showHeight = Math.floor(canvas.getBoundingClientRect().height) + 'px'
        }
      })
    },

    destroyCanvas () {
      this.width = 0
      this.height = 0
      this.showHeight = 'auto'

      if (navigator.userAgent.toLowerCase().indexOf('firefox') > -1 ||
          navigator.userAgent.toLowerCase().indexOf('cpu iphone os') > -1 ||
          navigator.userAgent.toLowerCase().indexOf('cpu os') > -1) {
        window.removeEventListener('resize', this.fixSubpixel)
      }
    }
  },

  mounted () {
    if (this.visible) {
      this.renderCanvas()
    }
  },

  beforeDestroy () {
    this.destroyCanvas()
  },

  watch: {
    visible (to, from) {
      if (to && !from) {
        this.renderCanvas()
      } else if (!to && from) {
        this.destroyCanvas()
      }
    }
  }
}
</script>
