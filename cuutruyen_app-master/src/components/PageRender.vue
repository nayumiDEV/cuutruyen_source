<template>
  <canvas ref="canvas" class="w-full pointer-events-none" :width="width" :height="height" />
</template>

<script>
import * as cuudrm from '@/lib/cuudrm.js' // eslint-disable-line

export default {
  props: {
    page: {
      type: Object
    },

    image: {
      type: HTMLImageElement
    },

    visible: {
      type: Boolean
    }
  },

  data () {
    return {
      width: 0,
      height: 0
    }
  },

  methods: {
    renderCanvas () {
      const canvas = this.$refs.canvas
      this.width = this.page.width
      this.height = this.page.height

      this.$nextTick(() => {
        const ctx = canvas.getContext('2d')
        ctx.textAlign = 'right'
        cuudrm.render_image(this.image, ctx, this.page.drm_data, 1)
      })
    },

    destroyCanvas () {
      this.width = 0
      this.height = 0
    }
  },

  mounted () {
    if (this.visible) {
      this.renderCanvas()
    }

    this.$refs.canvas.addEventListener('contextmenu', event => {
      event.preventDefault()
    }, false)
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
