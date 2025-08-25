<template>
  <div class="image-block-builder">
    <div class="space-y-4">
      <!-- Title Input -->
      <div>
        <label class="block text-sm font-medium text-gray-700 mb-2">
          Tiêu đề khối (tùy chọn)
        </label>
        <input
          v-model="localBlock.title"
          type="text"
          class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
          placeholder="Để trống nếu không cần tiêu đề..."
          @input="updateBlock"
        />
      </div>

      <!-- External Link Input -->
      <div>
        <label class="block text-sm font-medium text-gray-700 mb-2">
          Liên kết ngoài (tùy chọn)
        </label>
        <input
          v-model="localBlock.options.link"
          type="url"
          class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
          placeholder="https://example.com/"
          @input="updateBlock"
        />
        <p class="text-xs text-gray-500 mt-1">Khi đặt, nhấp vào ảnh sẽ mở liên kết này ở tab mới (nên bắt đầu bằng https://)</p>
      </div>

      <!-- Image Upload -->
      <div>
        <label class="block text-sm font-medium text-gray-700 mb-2">
          Hình ảnh chính
        </label>
        <div class="">
          <div v-if="!localBlock.src" class="text-center">
            <button
              @click="openImageModal"
              class="px-4 py-2 button button-normal"
            >
              Chọn hình ảnh
            </button>
          </div>
          <div v-else class="space-y-3">
            <img :src="localBlock.src" alt="Preview" class="max-w-full h-48 object-contain mx-auto rounded" />
            <div class="flex justify-center gap-2">
              <button
                @click="openImageModal"
                class="px-2 py-1 font-bold uppercase text-xs"
              >
                Thay đổi
              </button>
              <button
                @click="removeImage"
                class="px-2 py-1 font-bold uppercase text-xs text-red-600"
              >
                Xóa
              </button>
            </div>
          </div>
        </div>
      </div>

      <!-- Mobile Image Upload -->
      <div v-if="this.localBlock.src && false">
        <label class="block text-sm font-medium text-gray-700 mb-2">
          Hình ảnh mobile (tùy chọn)
        </label>
        <div class="rounded-lg p-4">
          <div v-if="!localBlock.options.mobileSrc" class="text-center">
            <button
              @click="openMobileImageModal"
              class="px-4 py-2 button button-normal"
            >
              Chọn hình ảnh mobile
            </button>
            <p class="text-xs text-gray-500 mt-2">Để tối ưu hiển thị trên thiết bị di động</p>
          </div>
          <div v-else class="space-y-3">
            <img :src="localBlock.options.mobileSrc" alt="Mobile Preview" class="max-w-full h-32 object-contain mx-auto rounded" />
            <div class="flex justify-center gap-2">
              <button
                @click="openMobileImageModal"
                class="px-2 py-1 font-bold uppercase text-xs"
              >
                Thay đổi
              </button>
              <button
                @click="removeMobileImage"
                class="px-2 py-1 font-bold uppercase text-xs text-red-600"
              >
                Xóa
              </button>
            </div>
          </div>
        </div>
      </div>

      <!-- Info -->
      <div class="p-3 bg-blue-50 rounded-lg">
        <div class="text-sm text-blue-800">
          <strong>Khối Hình ảnh:</strong> Hiển thị hình ảnh tùy chỉnh.
        </div>
      </div>
    </div>

    <!-- Image Upload Modal -->
    <SetImageModal v-model="showImageModal" @confirm="confirmSetImage" />
    <SetImageModal v-model="showMobileImageModal" @confirm="confirmSetMobileImage" />
  </div>
</template>

<script>
import SetImageModal from '@/components/team-management/description-editor/SetImageModal.vue'

export default {
  name: 'ImageBlockBuilder',

  components: {
    SetImageModal
  },

  props: {
    block: {
      type: Object,
      required: true
    }
  },

  data () {
    return {
      localBlock: {
        ...this.block,
        options: { ...this.block.options }
      },
      showImageModal: false,
      showMobileImageModal: false
    }
  },

  methods: {
    updateBlock () {
      this.$emit('update', { ...this.localBlock })
    },

    openImageModal () {
      this.showImageModal = true
    },

    openMobileImageModal () {
      this.showMobileImageModal = true
    },

    confirmSetImage (imageData) {
      if (imageData && imageData.src) {
        this.localBlock.src = imageData.src
        this.updateBlock()
      }
    },

    confirmSetMobileImage (imageData) {
      if (imageData && imageData.src) {
        this.localBlock.options.mobileSrc = imageData.src
        this.updateBlock()
      }
    },

    removeImage () {
      this.localBlock.src = ''
      this.updateBlock()
    },

    removeMobileImage () {
      this.localBlock.options.mobileSrc = ''
      this.updateBlock()
    }
  },

  watch: {
    block: {
      handler (newBlock) {
        this.localBlock = {
          ...newBlock,
          options: { ...newBlock.options }
        }
      },
      deep: true
    }
  }
}
</script>
