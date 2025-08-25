<template>
  <div class="w-full h-full bg-gray-800 flex justify-center items-center">
    <div class="spin text-gray-400"><LoadingIcon :size="64" /></div>
  </div>
</template>

<script>
import LoadingIcon from 'vue-material-design-icons/Loading.vue'

export default {
  components: {
    LoadingIcon
  },

  props: {
    page: Object
  }
}
</script>
