<template>
  <div
    :style="{
      width: `${width}px`,
      }"
  >
    <div
      class="overflow-hidden relative w-full"
    >
      <canvas ref="canvas" :style="{ height: showHeight }" class="relative w-full h-auto" :width="width" :height="height"></canvas>
      <div class="absolute w-full h-full top-0 left-0"
        :style="{
          containIntrinsicSize: `${height}px`
          }"
      >
        <slot />
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    width: Number,
    height: Number,
    isMarginless: Boolean
  },

  data () {
    return {
      showHeight: 'auto'
    }
  },

  mounted () {
    this.fixSubpixel()
    window.addEventListener('resize', this.fixSubpixel)
  },

  methods: {
    fixSubpixel () {
      this.showHeight = 'auto'

      this.$nextTick(() => {
        const canvas = this.$refs.canvas
        const trueHeight = canvas.getBoundingClientRect().height
        this.showHeight = Math.floor(trueHeight) + 'px'
      })
    }
  },

  beforeDestroy () {
    window.removeEventListener('resize', this.fixSubpixel)
  }
}
</script>
