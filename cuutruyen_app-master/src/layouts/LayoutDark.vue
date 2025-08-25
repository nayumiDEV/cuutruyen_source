<template>
  <div>
    <NavBar class="w-full fine-shadow relative" :glassy="true" theme="dark" />
    <slot />
    <AppFooter />
  </div>
</template>

<script>
import NavBar from '@/components/layout/default/NavBar'
import AppFooter from '@/components/layout/AppFooter'

export default {
  components: {
    NavBar,
    AppFooter
  }
}
</script>

<style>
body {
  @apply bg-gray-900;
}
</style>
