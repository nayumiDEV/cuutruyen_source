<template>
  <div class="w-full h-full bg-gray-900 bg-opacity-50 flex flex-col justify-center items-center p-8">
    <div class="flex justify-center items-center mb-6 text-white"><AlertIcon :size="32" /></div>
    <div class="text-sm text-white mb-2 text-center">Trang truyện này gặp lỗi khi tải xuống</div>
    <div class="text-sm text-white mb-6 text-center">{{ error.message }}</div>
    <div class="flex justify-center items-center"><button class="button px-4 py-2 bg-gray-800 hover:bg-gray-700 text-gray-200 uppercase font-bold text-xs transition" @click.prevent="$emit('retry')">Thử lại</button></div>
  </div>
</template>

<script>
import AlertIcon from 'vue-material-design-icons/Alert.vue'

export default {
  components: {
    AlertIcon
  },

  props: {
    error: Error
  }
}
</script>
