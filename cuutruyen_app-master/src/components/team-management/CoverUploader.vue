<template>
  <div class="flex">
    <div class="relative">
      <canvas class="invisible w-56" width="2" height="3"></canvas>
      <label v-if="!hasCover" for="cover" class="absolute w-full h-full top-0 left-0 upload-zone fine-transition">
        <PlusIcon class="mb-2 block" /><div>Chọn ảnh</div>
      </label>
      <div v-else>
        <img class="absolute w-full h-full top-0 left-0 rounded-lg object-cover" :src="coverPreview">

        <button v-if="!coverPreparing" @click="removeCover" type="button"
          class="absolute top-0 right-0 bg-gray-300 hover:bg-red-300 hover:text-red-800 p-1 m-1 rounded-full shadow focus:outline-none z-10"
        >
          <CloseIcon :size="16" />
        </button>

        <div class="text-white bg-black bg-opacity-70 absolute top-0 right-0 w-full h-full flex items-center justify-center" v-show="coverPreparing">
          <LoadingIcon class="spin rounded-full p-2" />
        </div>

        <div class="text-white bg-black bg-opacity-70 absolute top-0 right-0 w-full h-full flex items-center justify-center" v-show="coverDenied">
          <AlertCircleIcon class="rounded-full p-2" />
        </div>
      </div>
    </div>
    <input type="file" id="cover" ref="cover" @change="handleCoverUpload" class="hidden" accept="image/png, image/jpeg">
  </div>
</template>

<script>
import PlusIcon from 'vue-material-design-icons/Plus.vue'
import CloseIcon from 'vue-material-design-icons/Close.vue'
import AlertCircleIcon from 'vue-material-design-icons/AlertCircle.vue'
import LoadingIcon from 'vue-material-design-icons/Loading.vue'

export default {
  props: {
    hasCover: Boolean,
    coverPreparing: Boolean,
    coverDenied: Boolean,
    coverPreview: String
  },

  components: {
    PlusIcon,
    CloseIcon,
    LoadingIcon,
    AlertCircleIcon
  },

  methods: {
    removeCover () {
      this.$emit('removeCover')
    },

    handleCoverUpload (event) {
      if (event.target.files[0]) {
        this.$emit('uploadCover', event.target.files[0])
      }
    }
  }
}
</script>
