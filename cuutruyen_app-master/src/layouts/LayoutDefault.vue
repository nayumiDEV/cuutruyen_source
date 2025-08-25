<template>
  <div class="bg-gray-300 min-h-screen flex flex-col relative">
    <intersect @enter="isTop = true" @leave="isTop = false" :threshold="[0]">
      <div class="absolute top-0 left-0 w-5 h-5"></div>
    </intersect>
    <NavBar class="top-0 left-0 w-full fixed" :class="{ 'fine-shadow': !isTransparent }" :theme="isTransparent ? null : 'light'" :glassy="!isTransparent" />
    <router-view class="flex-grow" />
    <AppFooter />
  </div>
</template>

<script>
import AppFooter from '@/components/layout/AppFooter'
import Intersect from 'vue-intersect'
import NavBar from '@/components/layout/default/NavBar'

export default {
  name: 'LayoutDefault',

  components: {
    AppFooter,
    Intersect,
    NavBar
  },

  data () {
    return {
      isTop: true
    }
  },

  computed: {
    isTransparent () {
      return this.isTop
    }
  }
}
</script>
