<template>
  <div class="py-14 lg:py-20 px-2">
    <CuuHeading v-if="block.title">{{ block.title }}</CuuHeading>

    <div class="common-container">
      <div v-if="loading" class="h-[300px] flex justify-center items-center">
        <span class="spin">
          <LoadingIcon :size="64" class="text-gray-500" />
        </span>
      </div>

      <div v-else-if="manga === null" class="text-gray-500 py-16 md:py-24 flex items-center justify-center">
        Không tìm thấy truyện được dùng cho Spotlight
      </div>

      <div v-else>
        <div class="flex-none w-full rounded-lg overflow-hidden relative z-10 snap-center snap-always transition">
          <picture>
            <source :srcset="manga.panorama_mobile_url" media="(max-width: 640px)">
            <img class="w-full object-cover object-center rounded-lg z-10"
              :src="manga.panorama_url"
              :alt="manga.name"
            >
          </picture>
          <div
            class="absolute top-0 left-0 w-full h-full z-10 rounded-lg brightness-60"
            :style="`background: linear-gradient(0deg, ${panoramaDominantColor} 0%, transparent 50%)`"
          ></div>
          <div class="absolute w-full bottom-0 left-0 flex justify-between items-center p-3 md:p-6 z-10">
            <div class="flex flex-col gap-1 xl:gap-2 w-full overflow-hidden">
              <div class="max-w-[24rem] flex-0">
                <router-link :to="{ name: 'Manga', params: { id: manga.id } }">
                  <h2 class="font-head font-bold overflow-ellipsis whitespace-nowrap overflow-hidden md:overflow-auto md:whitespace-normal break-words text-base md:text-lg xl:text-xl text-white text-opacity-75">
                    {{ manga.name }}
                  </h2>
                </router-link>
              </div>

              <div class="flex-1 flex-grow max-w-[32rem]">
                <p class="w-full overflow-ellipsis whitespace-nowrap overflow-hidden md:overflow-auto md:whitespace-normal break-words text-white text-opacity-80 text-sm xl:text-base">
                  {{ manga.description }}
                </p>
              </div>
            </div>

            <div class="hidden md:block flex-0 whitespace-nowrap">
              <router-link
                :to="{ name: 'Manga', params: { id: manga.id } }"
                class="inline-block button text-white px-2 md:px-8 py-1 md:py-2 text-sm uppercase font-bold brightness-150"
                :style="`background-color: ${panoramaDominantColorDarken}`"
              >
                Xem thông tin
              </router-link>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { getManga } from '@/apis/user'
import LoadingIcon from 'vue-material-design-icons/Loading.vue'

export default {
  name: 'SpotlightBlock',

  components: {
    LoadingIcon
  },

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

  data () {
    return {
      loading: true,
      manga: null
    }
  },

  computed: {
    panoramaDominantColor () {
      console.log(this.manga)
      if (this.manga && this.manga.panorama_dominant_color) {
        return this.manga.panorama_dominant_color
      }

      return '#05070c'
    },

    panoramaDominantColorDarken () {
      if (this.manga && this.manga.panorama_dominant_color) {
        const hex = this.manga.panorama_dominant_color.replace('#', '')
        const r = parseInt(hex.substr(0, 2), 16) / 255
        const g = parseInt(hex.substr(2, 2), 16) / 255
        const b = parseInt(hex.substr(4, 2), 16) / 255

        // Convert RGB to HSL
        const max = Math.max(r, g, b)
        const min = Math.min(r, g, b)
        let h
        let s
        let l = (max + min) / 2

        if (max === min) {
          h = 0
          s = 0 // achromatic
        } else {
          const d = max - min
          s = l > 0.5 ? d / (2 - max - min) : d / (max + min)

          switch (max) {
            case r: h = (g - b) / d + (g < b ? 6 : 0); break
            case g: h = (b - r) / d + 2; break
            case b: h = (r - g) / d + 4; break
          }
          h /= 6
        }

        h = Math.round(h * 360)
        s = Math.round(s * 100)

        l = Math.max(Math.round(l * 100) - 50, 10)

        console.log(`hsl(${h}, ${s}%, ${l}%)`)

        return `hsl(${h}, ${s}%, ${l}%)`
      }

      return '#05070c'
    }
  },

  mounted () {
    this.fetchData()
  },

  beforeDestroy () {
    window.removeEventListener('resize', this.handleResize)
  },

  methods: {
    async fetchData () {
      try {
        this.loading = true
        const response = await getManga(this.block.mangaId)
        this.manga = response.data
        this.loading = false
        this.$nextTick(() => {
          this.$emit('block-loaded')
        })
      } catch (error) {
        this.$handleError(error)
        this.loading = false
        this.$emit('block-error')
      }
    }
  }
}
</script>
