<template>
  <div class="py-14 lg:py-20 px-2">
    <CuuHeading v-if="block.title">{{ block.title }}</CuuHeading>

    <div class="common-container flex justify-center">
      <template v-if="block.options && block.options.link">
        <a :href="block.options.link" target="_blank" rel="noopener noreferrer nofollow">
          <img
            :src="imageSrc"
            :alt="block.title || 'Team image'"
            class="max-w-full h-auto rounded-lg cursor-pointer hover:opacity-90 transition"
            @load="onImageLoaded"
            @error="onImageError"
            ref="imageElement"
          />
        </a>
      </template>
      <template v-else>
        <img
          :src="imageSrc"
          :alt="block.title || 'Team image'"
          class="max-w-full h-auto rounded-lg"
          @load="onImageLoaded"
          @error="onImageError"
          ref="imageElement"
        />
      </template>
    </div>
  </div>
</template>

<script>
export default {
  name: 'ImageBlock',

  props: {
    block: {
      type: Object,
      required: true
    },
    team: {
      type: Object,
      required: true
    }
  },

  computed: {
    imageSrc () {
      // Check if we should use mobile image based on screen width
      if (this.block.options &&
          this.block.options.mobileSrc &&
          window.innerWidth < 768) {
        return this.block.options.mobileSrc
      }
      return this.block.src || ''
    }
  },

  data () {
    return {
      imageLoaded: false,
      imageError: false
    }
  },

  mounted () {
    // Add resize listener to update image source when screen size changes
    window.addEventListener('resize', this.handleResize)

    // Check if image is already cached
    this.$nextTick(() => {
      if (this.$refs.imageElement) {
        const img = this.$refs.imageElement
        if (img.complete) {
          this.onImageLoaded()
        }
      }
    })
  },

  beforeDestroy () {
    // Clean up event listener
    window.removeEventListener('resize', this.handleResize)
  },

  methods: {
    handleResize () {
      // Force re-evaluation of computed property
      this.$forceUpdate()
    },

    onImageLoaded () {
      this.imageLoaded = true
      this.$emit('block-loaded')
    },

    onImageError () {
      this.imageError = true
      this.$emit('block-error')
    }
  }
}
</script>

<style scoped>
.block-container {
  @apply bg-white rounded-lg p-4 shadow-sm;
}

.image-container {
  @apply overflow-hidden;
}
</style>
