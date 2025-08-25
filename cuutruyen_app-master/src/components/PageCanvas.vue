<template>
  <canvas ref="canvas" class="w-full" :width="width" :height="height" />
</template>

<script>
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

        ctx.drawImage(this.image, 0, 0)
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
