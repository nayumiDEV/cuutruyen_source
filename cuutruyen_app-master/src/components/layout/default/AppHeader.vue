<template>
  <div class="relative mb-[5rem] md:mb-[6rem] flex justify-center">
    <div class="max-w-screen-md lg:max-w-screen-lg xl:max-w-screen-xl w-full mx-2 rounded-lg translate-y-[5rem] md:translate-y-[6rem] relative z-10 relative">
      <img v-if="manga" class="absolute w-full h-full top-0 left-0 object-cover rounded-lg z-10 bg-hero brightness-75" :src="manga.panoramaUrl | fullUrl" width="1280" height="600">
      <canvas class="rounded-lg w-full brightness-[.4] transition duration-500" width="1280" height="600" :style="`box-shadow: 0px 6px 20px 2px ${panoramaDominantColor}50; background-color: #111827`"></canvas>
      <div v-if="manga" class="hidden md:flex justify-end absolute w-full top-0 right-0 p-3 md:p-6 z-10 text-white text-xs text-opacity-50 uppercase font-bold">
        Cập nhật gần đây
      </div>
      <div class="absolute top-0 left-0 w-full h-full bg-hero z-10 rounded-lg"></div>
      <div v-if="manga" class="absolute w-full bottom-0 left-0 flex justify-between items-center p-3 md:p-6 z-10">
        <div class="flex flex-col gap-1 lg:gap-2 w-full overflow-hidden">
          <div class="max-w-[24rem] flex-0">
            <router-link :to="{ name: 'Manga', params: { id: manga.id } }">
              <h2 class="font-head font-bold overflow-ellipsis whitespace-nowrap overflow-hidden md:overflow-auto md:whitespace-normal break-words text-md md:text-lg lg:text-xl text-white text-opacity-75 tracking-wider">
                {{ manga.name }}
              </h2>
            </router-link>
          </div>

          <div class="flex-1 flex-grow max-w-[32rem]">
            <p class="w-full overflow-ellipsis whitespace-nowrap overflow-hidden md:overflow-auto md:whitespace-normal font-subhead font-light break-words text-white text-opacity-80 text-sm md:text-md lg:text-xl">
              {{ manga.description }}
            </p>
          </div>
        </div>

        <div class="hidden md:block flex-0 whitespace-nowrap">
          <router-link :to="{ name: 'Manga', params: { id: manga.id } }" class="inline-block button bg-blue-600 hover:bg-blue-800 bg-opacity-50 hover:bg-opacity-50 text-white px-2 lg:px-8 py-1 lg:py-2 text-sm uppercase font-bold">
            Xem thông tin
          </router-link>
        </div>
      </div>
    </div>
    <div class="absolute w-full h-[calc(5rem+70%)] md:h-[calc(6rem+70%)] top-0 left-0 brightness-[.4] py-4 transition duration-500" :style="`background: linear-gradient(132deg, ${panoramaDominantColor} 0%, ${panoramaDominantColor2} 100%)`"></div>
  </div>
</template>

<script>
import { fullUrl } from '@/utils/get-url'

const modelsLoader = () => import('@/models')

export default {
  filters: {
    fullUrl (path) {
      return fullUrl(path)
    }
  },

  computed: {
    panoramaDominantColor () {
      if (this.manga && this.manga.panoramaDominantColor) {
        return this.manga.panoramaDominantColor
      }

      return '#05070c'
    },

    panoramaDominantColor2 () {
      if (this.manga && this.manga.panoramaDominantColor2) {
        return this.manga.panoramaDominantColor2
      }

      return '#05070c'
    }
  },

  data () {
    return {
      manga: null
    }
  },

  mounted () {
    this.loadSpotlight()
  },

  methods: {
    async loadSpotlight () {
      try {
        const { Manga } = await modelsLoader()

        const manga = (await Manga.where({ status: 'processed', has_chapter: true }).order({ updated_at: 'desc' }).first()).data
        this.manga = manga
      } catch (error) {
        this.$handleError(error)
      }
    }
  }
}
</script>

<style scoped>
.bg-hero {
  background: linear-gradient(to top, hsla(0, 0%, 0%, .9), ease, hsla(0, 0%, 0%, 0));
}
</style>
