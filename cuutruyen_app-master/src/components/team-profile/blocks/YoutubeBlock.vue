<template>
  <div class="py-14 lg:py-20 px-2">
    <CuuHeading v-if="block.title">{{ block.title }}</CuuHeading>

    <div class="common-container flex justify-center">
      <div class="w-full max-w-4xl">
        <div class="relative aspect-video bg-gray-100 rounded-lg overflow-hidden">
          <iframe
            v-if="youtubeEmbedUrl"
            :src="youtubeEmbedUrl"
            title="YouTube video player"
            frameborder="0"
            allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
            allowfullscreen
            class="absolute inset-0 w-full h-full"
            @load="onVideoLoaded"
            @error="onVideoError"
          ></iframe>
          <div v-else class="absolute inset-0 flex items-center justify-center text-gray-500">
            <div class="text-center">
              <div class="text-lg mb-2">Video không khả dụng</div>
              <div class="text-sm">URL YouTube không hợp lệ</div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'YoutubeBlock',

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
    youtubeEmbedUrl () {
      if (!this.block.youtubeUrl) return null

      // Extract video ID from various YouTube URL formats
      const videoId = this.extractYouTubeVideoId(this.block.youtubeUrl)
      if (!videoId) return null

      // Build embed URL with options
      let embedUrl = `https://www.youtube.com/embed/${videoId}`
      const params = new URLSearchParams()

      // Add autoplay if enabled
      if (this.block.options && this.block.options.autoplay) {
        params.append('autoplay', '1')
      }

      // Add start time if specified
      if (this.block.options && this.block.options.startTime) {
        params.append('start', this.block.options.startTime)
      }

      // Add other options
      if (this.block.options && this.block.options.showControls === false) {
        params.append('controls', '0')
      }

      if (this.block.options && this.block.options.showRelated === false) {
        params.append('rel', '0')
      }

      const paramString = params.toString()
      if (paramString) {
        embedUrl += `?${paramString}`
      }

      return embedUrl
    }
  },

  data () {
    return {
      videoLoaded: false,
      videoError: false
    }
  },

  mounted () {
    // Emit loaded event immediately since iframe loading is handled separately
    this.$nextTick(() => {
      this.$emit('block-loaded')
    })
  },

  methods: {
    extractYouTubeVideoId (url) {
      if (!url) return null

      // Handle various YouTube URL formats
      const patterns = [
        /(?:youtube\.com\/watch\?v=|youtu\.be\/|youtube\.com\/embed\/)([^&\n?#]+)/,
        /youtube\.com\/watch\?.*v=([^&\n?#]+)/
      ]

      for (const pattern of patterns) {
        const match = url.match(pattern)
        if (match && match[1]) {
          return match[1]
        }
      }

      return null
    },

    onVideoLoaded () {
      this.videoLoaded = true
    },

    onVideoError () {
      this.videoError = true
      this.$emit('block-error')
    }
  }
}
</script>

<style scoped>
.aspect-video {
  aspect-ratio: 16 / 9;
}
</style>
