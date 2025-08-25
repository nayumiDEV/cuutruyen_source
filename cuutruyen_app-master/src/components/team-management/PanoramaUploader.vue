<template>
  <div class="flex flex-col">
    <div class="relative mb-4">
      <canvas class="invisible w-full" width="32" height="15"></canvas>

      <label v-if="!hasPanorama" for="panorama" class="absolute w-full h-full top-0 left-0 upload-zone fine-transition">
        <PlusIcon class="mb-2 block" /><div>Chọn ảnh</div>
      </label>

      <div v-else>
        <img class="w-full rounded-lg absolute w-full h-full top-0 left-0 object-cover" :src="panoramaPreview">

        <button v-if="!panoramaPreparing" @click="removePanorama" type="button"
          class="absolute top-0 right-0 bg-gray-300 hover:bg-red-300 hover:text-red-800 p-1 m-1 rounded-full shadow focus:outline-none z-10"
        >
          <CloseIcon :size="16" />
        </button>

        <div class="text-white bg-black bg-opacity-70 absolute top-0 right-0 w-full h-full flex items-center justify-center" v-show="panoramaPreparing">
          <LoadingIcon class="spin rounded-full p-2" />
        </div>

        <div class="text-white bg-black bg-opacity-70 absolute top-0 right-0 w-full h-full flex items-center justify-center" v-show="panoramaDenied">
          <AlertCircleIcon class="rounded-full p-2" />
        </div>
      </div>
    </div>

    <input type="file" id="panorama" @change="handlePanoramaUpload" class="hidden" accept="image/png, image/jpeg">
  </div>
</template>

<script>
import PlusIcon from 'vue-material-design-icons/Plus.vue'
import CloseIcon from 'vue-material-design-icons/Close.vue'
import AlertCircleIcon from 'vue-material-design-icons/AlertCircle.vue'
import LoadingIcon from 'vue-material-design-icons/Loading.vue'

export default {
  props: {
    hasPanorama: Boolean,
    panoramaPreparing: Boolean,
    panoramaDenied: Boolean,
    panoramaPreview: String,
    focusX: Number,
    focusY: Number
  },

  components: {
    PlusIcon,
    CloseIcon,
    LoadingIcon,
    AlertCircleIcon
  },

  methods: {
    removePanorama () {
      this.$emit('removePanorama')
    },

    handlePanoramaUpload (event) {
      if (event.target.files[0]) {
        this.$emit('uploadPanorama', event.target.files[0])
      }
    }
  }
}
</script>
