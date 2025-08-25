<template>
  <div class="py-14 lg:py-20 px-2">
    <CuuHeading v-if="block.title">{{ block.title }}</CuuHeading>

    <div class="common-container flex justify-center">
      <div class="w-full max-w-4xl">
        <div class="relative bg-gray-100 rounded-lg overflow-hidden" :style="{ height: playerHeight }">
          <iframe
            v-if="soundcloudEmbedUrl"
            :src="soundcloudEmbedUrl"
            title="SoundCloud player"
            frameborder="0"
            scrolling="no"
            allow="autoplay"
            class="absolute inset-0 w-full h-full"
            @load="onPlayerLoaded"
            @error="onPlayerError"
          ></iframe>
          <div v-else class="absolute inset-0 flex items-center justify-center text-gray-500">
            <div class="text-center">
              <div class="text-lg mb-2">Âm thanh không khả dụng</div>
              <div class="text-sm">URL SoundCloud không hợp lệ</div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'SoundcloudBlock',

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
    soundcloudEmbedUrl () {
      if (!this.block.soundcloudUrl) return null

      // Build SoundCloud embed URL
      let embedUrl = 'https://w.soundcloud.com/player/?url=' + encodeURIComponent(this.block.soundcloudUrl)
      const params = new URLSearchParams()

      // Add visual options
      if (this.block.options && this.block.options.visual !== false) {
        params.append('visual', 'true')
      }

      // Add autoplay if enabled
      if (this.block.options && this.block.options.autoplay) {
        params.append('auto_play', 'true')
      }

      // Add hide related if specified
      if (this.block.options && this.block.options.hideRelated) {
        params.append('hide_related', 'true')
      }

      // Add show comments option
      if (this.block.options && this.block.options.showComments === false) {
        params.append('show_comments', 'false')
      }

      // Add show user option
      if (this.block.options && this.block.options.showUser === false) {
        params.append('show_user', 'false')
      }

      // Add show reposts option
      if (this.block.options && this.block.options.showReposts === false) {
        params.append('show_reposts', 'false')
      }

      // Add color theme
      if (this.block.options && this.block.options.color) {
        params.append('color', this.block.options.color.replace('#', ''))
      }

      const paramString = params.toString()
      if (paramString) {
        embedUrl += `&${paramString}`
      }

      return embedUrl
    },

    playerHeight () {
      // Visual mode uses larger height, audio-only uses smaller height
      if (this.block.options && this.block.options.visual !== false) {
        return '400px'
      }
      return '166px'
    }
  },

  data () {
    return {
      playerLoaded: false,
      playerError: false
    }
  },

  mounted () {
    // Emit loaded event immediately since iframe loading is handled separately
    this.$nextTick(() => {
      this.$emit('block-loaded')
    })
  },

  methods: {
    onPlayerLoaded () {
      this.playerLoaded = true
    },

    onPlayerError () {
      this.playerError = true
      this.$emit('block-error')
    }
  }
}
</script>

<style scoped>
/* Additional styles if needed */
</style>
