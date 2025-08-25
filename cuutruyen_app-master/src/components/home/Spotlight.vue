<template>
  <div class="flex flex-col">
    <div class="relative mb-[calc(5rem)] md:mb-[calc(8rem)] flex justify-center box-content">
      <transition name="fade" mode="in-out" :duration="1000">
        <div v-if="!mangas || mangas.length === 0" class="max-w-screen-md lg:max-w-screen-md xl:max-w-screen-lg 2xl:max-w-screen-xl w-full mx-2 rounded-lg translate-y-[calc(5rem)] md:translate-y-[calc(7rem)] relative z-10">
          <canvas class="md:hidden rounded-lg w-full brightness-75 transition duration-500" width="16" height="9" :style="`box-shadow: 0px 6px 20px 2px ${panoramaDominantColor}50; background-color: #111827`"></canvas>
          <canvas class="hidden md:block rounded-lg w-full brightness-75 transition duration-500" width="32" height="15" :style="`box-shadow: 0px 6px 20px 2px ${panoramaDominantColor}50; background-color: #111827`"></canvas>
        </div>

        <div v-else ref="spotlightContainer" class="scroll-smooth snap-x snap-mandatory overflow-x-auto flex w-full translate-y-[calc(5rem)] md:translate-y-[calc(7rem)] relative z-10 hide-scrollbar gap-4 snap px-2 select-none scroll-smooth">
          <div class="snap-align-none snap-none hidden md:block flex-none 2xl:w-[calc((100vw-1280px-2rem)/2)] xl:w-[calc((100vw-1024px-2rem)/2)] lg:w-[calc((100vw-768px-2rem)/2)] md:w-[calc((100vw-768px-2rem)/2)]">
          </div>

          <SpotlightItem ref="spotlightItems" v-for="(manga, index) in mangas" :key="'spotlight-' + manga.id" :manga="manga" :index="index" :isActive="index === activeSpotlightIndex" :data-index="index" @active="scrollToSpotlight(index)" :activeColor="panoramaDominantColor" />

          <div class="snap-align-none snap-none hidden md:block flex-none 2xl:w-[calc((100vw-1280px-2rem)/2)] xl:w-[calc((100vw-1024px-2rem)/2)] lg:w-[calc((100vw-768px-2rem)/2)] md:w-[calc((100vw-768px-2rem)/2)]">
          </div>
        </div>
      </transition>

      <transition name="fade" mode="in-out" :duration="1000">
        <div
          class="absolute w-full h-[calc(5rem+80%)] md:h-[calc(7rem+80%)] top-0 left-0 brightness-75 py-4"
          :style="`background: linear-gradient(132deg, ${panoramaDominantColor} 0%, ${panoramaDominantColor2} 100%)`"
          :key="`color-${panoramaDominantColor}-${panoramaDominantColor2}`"
        ></div>
      </transition>
    </div>

    <div class="flex justify-center gap-1 mt-3 h-2.5 md:h-3">
      <button v-for="(dot, index) in dots" class="flex-none rounded-full w-2.5 h-2.5 md:w-3 md:h-3 bg-gray-800 transition" :key="'dot-' + index" :class="{'bg-opacity-30': !dot}" @click.prevent="scrollToSpotlight(index)"></button>
    </div>
  </div>
</template>

<script>
import SpotlightItem from './SpotlightItem.vue'

export default {
  components: {
    SpotlightItem
  },

  props: {
    mangas: {
      type: Array
    }
  },

  data () {
    return {
      activeSpotlightObserver: null,
      activeSpotlightIndex: 0
    }
  },

  computed: {
    dots () {
      if (!this.mangas || this.mangas.length === 0) {
        const dots = new Array(this.mangas.length).fill(false)
        return dots
      }

      const dots = new Array(this.mangas.length).fill(false)
      dots[this.activeSpotlightIndex] = true
      return dots
    },

    activeManga () {
      if (!this.mangas || this.mangas.length === 0) {
        return null
      }

      return this.mangas[this.activeSpotlightIndex]
    },

    panoramaDominantColor () {
      if (this.activeManga && this.activeManga.panorama_dominant_color) {
        return this.activeManga.panorama_dominant_color
      }

      return '#05070c'
    },

    panoramaDominantColor2 () {
      if (this.activeManga && this.activeManga.panorama_dominant_color_2) {
        return this.activeManga.panorama_dominant_color_2
      }

      return '#05070c'
    }
  },

  mounted () {
    this.checkActiveSpotlight()
  },

  methods: {
    checkActiveSpotlight () {
      if (!this.$refs.spotlightItems) {
        return
      }

      this.activeSpotlightObserver = new IntersectionObserver((entries, observer) => {
        entries.forEach(entry => {
          if (entry.isIntersecting) {
            const index = Number(entry.target.dataset.index)
            this.activeSpotlightIndex = index
          }
        })
      }, {
        root: this.$refs.spotlightContainer,
        rootMargin: '0px -50% 0px -50%',
        threshold: [0]
      })

      this.$refs.spotlightItems.forEach(spotlightItem => {
        this.activeSpotlightObserver.observe(spotlightItem.$el)
      })
    },

    scrollToSpotlight (index) {
      // this.$refs.spotlightItems[index].$el.scrollIntoView({ behavior: 'smooth', block: 'start', inline: 'center' })
      const spotlightItemScrollLeft = this.$refs.spotlightItems[index].$el.offsetLeft
      this.$refs.spotlightContainer.scroll({ left: spotlightItemScrollLeft, behavior: 'smooth' })
    }
  },

  watch: {
    mangas (to, from) {
      if (to.length > 0 && !this.activeSpotlightObserver) {
        this.$nextTick(() => {
          this.checkActiveSpotlight()
        })
      }
    },

    activeSpotlightIndex (to, from) {
      console.log(this.activeSpotlightIndex)
    }
  },

  beforeDestroy () {
    if (this.activeSpotlightObserver) {
      this.activeSpotlightObserver.disconnect()
    }
  }
}
</script>

<style scoped>
.bg-hero {
  background: linear-gradient(to top, hsla(0, 0%, 0%, .9), ease, hsla(0, 0%, 0%, 0));
}

.fade-enter-active, .fade-leave-active {
  transition: opacity 1s;
}

.hide-scrollbar {
  -ms-overflow-style: none;  /* IE and Edge */
  scrollbar-width: none;  /* Firefox */
}

.hide-scrollbar::-webkit-scrollbar {
  width: 0px;
  background: transparent;
}
</style>
