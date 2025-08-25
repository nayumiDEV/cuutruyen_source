<template>
  <div class="flex-none max-w-screen-md lg:max-w-screen-md xl:max-w-screen-lg 2xl:max-w-screen-xl w-full rounded-lg overflow-hidden relative z-10 snap-center snap-always transition" :class="{'opacity-50': !isActive}">
    <picture v-if="manga">
      <source :srcset="getUrl(manga.panorama_mobile_url)" media="(max-width: 640px)">
      <img class="absolute w-full h-full top-0 left-0 object-cover object-center rounded-lg z-10 bg-hero brightness-75"
        :src="getUrl(manga.panorama_url)"
        :alt="manga.name"
      >
    </picture>
    <canvas class="md:hidden rounded-lg w-full brightness-75 transition duration-500" width="16" height="9" :style="`box-shadow: 0px 6px 20px 2px ${panoramaDominantColor}50; background-color: #111827`"></canvas>
    <canvas class="hidden md:block rounded-lg w-full brightness-75 transition duration-500" width="32" height="15" :style="`box-shadow: 0px 6px 20px 2px ${panoramaDominantColor}50; background-color: #111827`"></canvas>
    <div
      class="absolute top-0 left-0 w-full h-full z-10 rounded-lg brightness-75"
      :style="`background: linear-gradient(0deg, ${panoramaDominantColor} 0%, transparent 100%)`"
    ></div>
    <div v-if="manga" class="absolute w-full bottom-0 left-0 flex justify-between items-center p-3 md:p-6 z-10">
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
    <div class="absolute w-full h-full top-0 left-0 z-10 transition-all duration-1000 hidden md:block" :class="{ 'opacity-0 pointer-events-none': isActive, 'opacity-80': !isActive }" :style="{ backgroundColor: activeColor }" @click="$emit('active', index)"></div>
  </div>
</template>

<script>
import { fullUrl } from '@/utils/get-url'

export default {
  props: {
    manga: Object,
    isActive: Boolean,
    index: Number,
    activeColor: String
  },

  computed: {
    panoramaDominantColor () {
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

        l = 10

        console.log(`hsl(${h}, ${s}%, ${l}%)`)

        return `hsl(${h}, ${s}%, ${l}%)`
      }

      return '#05070c'
    }
  },

  filters: {
    fullUrl (path) {
      return fullUrl(path)
    }
  },

  methods: {
    getUrl (path) {
      return fullUrl(path)
    }
  }
}
</script>

<style scoped>
.bg-hero {
  background: linear-gradient(to top, hsla(0, 0%, 0%, .9), ease, hsla(0, 0%, 0%, 0));
  }
</style>
