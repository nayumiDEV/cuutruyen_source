<template>
  <div class="bg-gray-300">
    <NavBar class="sticky top-0 w-full fine-shadow" :glassy="true" theme="light" />
    <div class="flex-grow min-h-screen">
      <slot />
    </div>
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
