<template>
  <div>
    <Modal v-model="show" @confirm="confirm" @cancel="cancel" v-if="value">
      <template v-slot:header>
        Chèn hình ảnh
      </template>

      <div>
        <div class="relative rounded-lg overflow-hidden">
          <canvas class="invisible w-full" width="16" height="9"></canvas>
          <label v-if="!hasImage" for="image" class="absolute w-full h-full top-0 left-0 upload-zone fine-transition">
            <PlusIcon class="mb-2 block" /><div>Chọn ảnh</div>
          </label>
          <div v-else>
            <img class="absolute w-full h-full top-0 left-0 rounded-lg object-contain bg-gray-100" :src="imagePreview">

            <button v-if="!imagePreparing" @click="removeImage" type="button"
              class="absolute top-0 right-0 bg-gray-300 hover:bg-red-300 hover:text-red-800 p-1 m-1 rounded-full shadow focus:outline-none z-10"
            >
              <CloseIcon :size="16" />
            </button>

            <div class="text-white bg-black bg-opacity-70 absolute top-0 right-0 w-full h-full flex items-center justify-center" v-show="imagePreparing">
              <LoadingIcon class="spin rounded-full p-2" />
            </div>

            <div class="text-white bg-black bg-opacity-70 absolute top-0 right-0 w-full h-full flex items-center justify-center" v-show="imageDenied">
              <AlertCircleIcon class="rounded-full p-2" />
            </div>
          </div>
        </div>
        <input type="file" id="image" ref="image" @change="handleImageUpload" class="hidden" accept="image/png, image/jpeg">
      </div>

      <template v-slot:footer>
        <button @click="cancel" type="button" class="button px-6 py-2 bg-gray-300 hover:bg-gray-400 text-gray-600 hover:text-gray-700 font-bold mr-3">Hủy</button>
        <button @click="confirm" type="button" class="button px-6 py-2 bg-blue-800 hover:bg-blue-900 font-bold text-white" :class="{ 'button-disabled': !imageData }" :disabled="!imageData">Xác nhận</button>
      </template>
    </Modal>
  </div>
</template>

<script>
import Modal from '@/components/Modal'
import PlusIcon from 'vue-material-design-icons/Plus.vue'
import CloseIcon from 'vue-material-design-icons/Close.vue'
import AlertCircleIcon from 'vue-material-design-icons/AlertCircle.vue'
import LoadingIcon from 'vue-material-design-icons/Loading.vue'
import { createAbitraryPhoto } from '@/apis/user'

export default {
  components: {
    PlusIcon,
    CloseIcon,
    LoadingIcon,
    AlertCircleIcon,
    Modal
  },

  props: {
    value: Boolean
  },

  data () {
    return {
      show: false,
      hasImage: false,
      imagePreparing: false,
      imageDenied: false,
      imagePreview: null,
      imageData: null
    }
  },

  methods: {
    confirm () {
      this.$emit('confirm', this.imageData)
      this.$emit('input', false)
    },

    cancel () {
      this.$emit('input', false)
    },

    handleImageUpload () {
      if (event.target.files[0]) {
        this.uploadImage(event.target.files[0])
      }
    },

    async uploadImage (file) {
      this.hasImage = true
      this.imagePreparing = true
      this.imageDenied = false

      try {
        this.imagePreview = URL.createObjectURL(file)

        const formData = new FormData()
        formData.append('file', file)

        const uploadResponse = await fetch(`${process.env.VUE_APP_API_NAMESPACEV2}/upload/abitrary_photo`, {
          method: 'POST',
          body: formData
        })

        if (!uploadResponse.ok) {
          throw new Error('Có lỗi xảy ra khi tải lên ảnh.')
        }
        const data = await uploadResponse.json()

        const createResponse = await createAbitraryPhoto({
          abitrary_photo: {
            abitrary_photo: JSON.stringify(data)
          }
        })

        this.imageData = createResponse
      } catch (error) {
        this.imageDenied = true
        this.$notify({
          type: 'error',
          text: error.message
        })

        throw error
      } finally {
        this.imagePreparing = false
      }
    },

    removeImage () {
      this.hasImage = false
      this.imageData = null
    }
  },

  watch: {
    value (to) {
      if (to) {
        this.show = true
      } else {
        this.show = false
      }
    },

    show (to, from) {
      if (!to) {
        this.cancel()
      }
    }
  }
}
</script>
