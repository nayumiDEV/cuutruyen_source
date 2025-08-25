<template>
  <div class="relative">
    <div class="snap-container overflow-x-auto" :class="customClass" ref="snapContainer">
      <slot />
    </div>

    <button
      class="hidden md:flex absolute h-full top-0 left-0 w-6 lg:w-11 z-10 justify-center items-center focus:outline-none fine-transition"
      :class="{ 'opacity-80 hover:opacity-100': canScrollLeft, 'opacity-0 hover:opacity-50 cursor-default': !canScrollLeft, 'bg-gradient-to-r from-gray-300': theme === 'light', 'bg-gradient-to-r from-gray-700': theme === 'dark' }"
      @click="scrollSnapLeft"
    >
      <ChevronLeftIcon class="rounded-full block shadow-lg p-1 fine-transition"
        :class="{
          'bg-gray-200 text-gray-700': canScrollLeft && theme === 'light',
          'bg-gray-700 text-gray-200': canScrollLeft && theme === 'dark',
          'bg-gray-300 text-gray-400': !canScrollLeft && theme === 'light',
          'bg-gray-400 text-gray-300': !canScrollLeft && theme === 'dark'
          }"
      />
    </button>
    <button
      class="hidden md:flex absolute h-full top-0 right-0 w-6 lg:w-11 transform -translate-full z-10 justify-center items-center focus:outline-none fine-transition"
      :class="{ 'opacity-90 hover:opacity-100': canScrollRight, 'opacity-0 hover:opacity-50 cursor-default': !canScrollRight, 'bg-gradient-to-l from-gray-300': theme === 'light', 'bg-gradient-to-l from-gray-700': theme === 'dark' }"
      @click="scrollSnapRight"
    >
      <ChevronRightIcon class="rounded-full block shadow-lg p-1 fine-transition"
        :class="{
          'bg-gray-200 text-gray-700': canScrollRight && theme === 'light',
          'bg-gray-700 text-gray-200': canScrollRight && theme === 'dark',
          'bg-gray-300 text-gray-400': !canScrollRight && theme === 'light',
          'bg-gray-400 text-gray-300': !canScrollRight && theme === 'dark'
          }"
      />
    </button>
  </div>
</template>

<script>
import ChevronLeftIcon from 'vue-material-design-icons/ChevronLeft.vue'
import ChevronRightIcon from 'vue-material-design-icons/ChevronRight.vue'
import _debounce from 'lodash.debounce'

export default {
  components: {
    ChevronLeftIcon,
    ChevronRightIcon
  },

  props: {
    customClass: {
      type: String,
      default: null
    },
    theme: {
      type: String,
      default: 'light'
    }
  },

  data () {
    return {
      canScrollLeft: false,
      canScrollRight: false,
      scrollPos: 0
    }
  },

  mounted () {
    this.$nextTick(() => {
      this.checkScroll()

      this.$refs.snapContainer.addEventListener('scroll', _debounce(this.checkScroll, 100))

      this.$refs.snapContainer.addEventListener('resize', _debounce(this.checkScroll, 100))
    })
  },

  activated () {
    const snapContainer = this.$refs.snapContainer
    snapContainer.scrollLeft = this.scrollPos
  },

  methods: {
    checkScroll () {
      const snapContainer = this.$refs.snapContainer

      if (!snapContainer) {
        return
      }

      if (snapContainer.scrollLeft >= snapContainer.scrollWidth - snapContainer.clientWidth - 1) {
        this.canScrollRight = false
      } else {
        this.canScrollRight = true
      }

      if (snapContainer.scrollLeft <= 0) {
        this.canScrollLeft = false
      } else {
        this.canScrollLeft = true
      }

      this.scrollPos = snapContainer.scrollLeft
    },

    scrollSnapLeft () {
      const snapContainer = this.$refs.snapContainer

      if (!snapContainer) {
        return
      }

      if (snapContainer.scrollLeft >= snapContainer.offsetWidth * 0.6) {
        snapContainer.scrollLeft -= snapContainer.offsetWidth * 0.6
      } else {
        snapContainer.scrollLeft = 0
      }
    },

    scrollSnapRight () {
      const snapContainer = this.$refs.snapContainer

      if (!snapContainer) {
        return
      }

      snapContainer.scrollLeft += snapContainer.offsetWidth * 0.6
    }
  }
}
</script>

<style scoped>
.snap-container {
  -ms-overflow-style: none;  /* IE and Edge */
  scrollbar-width: none;  /* Firefox */
  scroll-behavior: smooth;
  scroll-snap-type: x mandatory;
}

.snap-mask {
  pointer-events: none;
}

.snap-container::-webkit-scrollbar {
    width: 0px;
    background: transparent;
}

.snap-button-left {
  background: linear-gradient(to right, rgba(209, 213, 219, 1), rgba(209, 213, 219, 0.1));
}

.snap-button-right {
  background: linear-gradient(to left, rgba(209, 213, 219, 1), rgba(209, 213, 219, 0.1));
}

.snap-button-no-bg {
  background: none;
}
</style>
