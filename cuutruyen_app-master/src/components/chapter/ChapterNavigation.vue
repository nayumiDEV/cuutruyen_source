<template>
  <div>
    <div class="px-2 py-1 bg-black bg-opacity-30">
      <div class="flex justify-between items-center">
        <span class="text-gray-200 text-md pt-1 font-extrabold font-head truncate mr-2">
          Bình luận
        </span>
        <button class="button button-normal bg-gray-700 text-gray-400 hover:bg-red-700"
          @click="$emit('hideSidebar')"
        ><CloseIcon :size="24" /></button>
      </div>
    </div>
  </div>
</template>

<script>
import CloseIcon from 'vue-material-design-icons/Close.vue'

export default {
  props: {
    chapter: Object,
    manga: Object
  },

  components: {
    CloseIcon
  }
}
</script>
