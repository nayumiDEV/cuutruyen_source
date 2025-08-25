<template>
  <div class="soundcloud-block-builder">
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

      <!-- SoundCloud URL Input -->
      <div>
        <label class="block text-sm font-medium text-gray-700 mb-2">
          URL SoundCloud <span class="text-red-500">*</span>
        </label>
        <input
          v-model="localBlock.soundcloudUrl"
          type="url"
          class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
          placeholder="https://soundcloud.com/..."
          @input="updateBlock"
        />
        <p class="text-xs text-gray-500 mt-1">
          URL của track, playlist hoặc user SoundCloud
        </p>
      </div>

      <!-- Player Options -->
      <div class="border border-gray-200 rounded-lg p-4">
        <h4 class="text-sm font-medium text-gray-700 mb-3">Tùy chọn phát nhạc</h4>
        <!-- Visual Mode -->
        <div class="flex items-center mb-3">
          <input
            v-model="localBlock.options.visual"
            type="checkbox"
            id="visual"
            class="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded"
            @change="updateBlock"
          />
          <label for="visual" class="ml-2 text-sm text-gray-700">
            Chế độ hiển thị hình ảnh (400px cao, nếu không chỉ 166px)
          </label>
        </div>

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
            Tự động phát nhạc khi tải trang
          </label>
        </div>

        <!-- Hide Related -->
        <div class="flex items-center mb-3">
          <input
            v-model="localBlock.options.hideRelated"
            type="checkbox"
            id="hideRelated"
            class="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded"
            @change="updateBlock"
          />
          <label for="hideRelated" class="ml-2 text-sm text-gray-700">
            Ẩn các track liên quan
          </label>
        </div>

        <!-- Show Comments -->
        <div class="flex items-center mb-3">
          <input
            v-model="localBlock.options.showComments"
            type="checkbox"
            id="showComments"
            class="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded"
            @change="updateBlock"
          />
          <label for="showComments" class="ml-2 text-sm text-gray-700">
            Hiển thị bình luận
          </label>
        </div>

        <!-- Show User -->
        <div class="flex items-center mb-3">
          <input
            v-model="localBlock.options.showUser"
            type="checkbox"
            id="showUser"
            class="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded"
            @change="updateBlock"
          />
          <label for="showUser" class="ml-2 text-sm text-gray-700">
            Hiển thị thông tin người dùng
          </label>
        </div>

        <!-- Show Reposts -->
        <!-- <div class="flex items-center mb-3">
          <input
            v-model="localBlock.options.showReposts"
            type="checkbox"
            id="showReposts"
            class="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded"
            @change="updateBlock"
          />
          <label for="showReposts" class="ml-2 text-sm text-gray-700">
            Hiển thị reposts
          </label>
        </div> -->

        <!-- Color Theme -->
        <!-- <div>
          <label class="block text-sm font-medium text-gray-700 mb-1">
            Màu chủ đề
          </label>
          <input
            v-model="localBlock.options.color"
            type="color"
            class="w-16 h-8 border border-gray-300 rounded cursor-pointer"
            @input="updateBlock"
          />
          <p class="text-xs text-gray-500 mt-1">Màu của thanh tiến trình và các nút</p>
        </div> -->
      </div>

      <!-- Info -->
      <div class="p-3 bg-blue-50 rounded-lg">
        <div class="text-sm text-blue-800">
          <strong>Khối SoundCloud:</strong> Nhúng track, playlist hoặc profile SoundCloud vào trang. Hỗ trợ cả chế độ hiển thị hình ảnh và chỉ âm thanh.
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'SoundcloudBlockBuilder',

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
