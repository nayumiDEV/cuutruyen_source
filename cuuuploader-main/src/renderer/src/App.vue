<template>
  <div class="w-screen h-screen flex flex-col overflow-hidden">
    <RouterView v-if="isInitialized" />
    <div v-else class="flex items-center justify-center h-screen">
      <Loading />
    </div>
  </div>

  <ModalsContainer />
</template>

<script setup>
import { useStore } from './composables/store'
import { onMounted } from 'vue'
import { ModalsContainer } from 'vue-final-modal'

const { isInitialized, initialize } = useStore()

onMounted(async () => {
  await initialize()
})
</script>
