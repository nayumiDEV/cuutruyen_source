<template>
  <div class="youtube-block-builder">
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

      <!-- YouTube URL Input -->
      <div>
        <label class="block text-sm font-medium text-gray-700 mb-2">
          URL YouTube <span class="text-red-500">*</span>
        </label>
        <input
          v-model="localBlock.youtubeUrl"
          type="url"
          class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
          placeholder="https://www.youtube.com/watch?v=..."
          @input="updateBlock"
        />
        <p class="text-xs text-gray-500 mt-1">
          Hỗ trợ các định dạng: youtube.com/watch?v=..., youtu.be/..., youtube.com/embed/...
        </p>
      </div>

      <!-- Player Options -->
      <div class="border border-gray-200 rounded-lg p-4">
        <h4 class="text-sm font-medium text-gray-700 mb-3">Tùy chọn phát video</h4>
        <!-- Autoplay -->
        <div class="flex items-center mb-3">
          <input
            v-model="localBlock.options.autoplay"
            type="checkbox"
            id="autoplay"
            class="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded"
            @change="updateBlock"
          />
          <label for="autoplay" class="ml-2 text-sm text-gray-700">
            Tự động phát video khi tải trang
          </label>
        </div>

        <!-- Start Time -->
        <!-- <div class="mb-3">
          <label class="block text-sm font-medium text-gray-700 mb-1">
            Thời gian bắt đầu (giây)
          </label>
          <input
            v-model.number="localBlock.options.startTime"
            type="number"
            min="0"
            class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
            placeholder="0"
            @input="updateBlock"
          />
          <p class="text-xs text-gray-500 mt-1">Để trống hoặc 0 để bắt đầu từ đầu</p>
        </div> -->

        <!-- Show Controls -->
        <div class="flex items-center mb-3">
          <input
            v-model="localBlock.options.showControls"
            type="checkbox"
            id="showControls"
            class="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded"
            @change="updateBlock"
          />
          <label for="showControls" class="ml-2 text-sm text-gray-700">
            Hiển thị thanh điều khiển video
          </label>
        </div>

        <!-- Show Related Videos -->
        <div class="flex items-center">
          <input
            v-model="localBlock.options.showRelated"
            type="checkbox"
            id="showRelated"
            class="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded"
            @change="updateBlock"
          />
          <label for="showRelated" class="ml-2 text-sm text-gray-700">
            Hiển thị video liên quan khi kết thúc
          </label>
        </div>
      </div>

      <!-- Info -->
      <div class="p-3 bg-blue-50 rounded-lg">
        <div class="text-sm text-blue-800">
          <strong>Khối YouTube:</strong> Nhúng video YouTube vào trang. Video sẽ hiển thị với tỷ lệ 16:9 và responsive trên mọi thiết bị.
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'YoutubeBlockBuilder',

  props: {
    block: {
      type: Object,
      required: true
    }
  },

  data () {
    return {
      localBlock: { ...this.block }
    }
  },

  methods: {
    updateBlock () {
      this.$emit('update', { ...this.localBlock })
    }
  },

  watch: {
    block: {
      handler (newBlock) {
        this.localBlock = { ...newBlock }
      },
      deep: true
    }
  }
}
</script>
