<template>
  <div class="new-mangas-block-builder">
    <div class="space-y-4">
      <!-- Title Input -->
      <div>
        <label class="block text-sm font-medium text-gray-700 mb-2">
          Tiêu đề khối
        </label>
        <input
          v-model="localBlock.title"
          type="text"
          class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
          placeholder="Nhập tiêu đề..."
          @input="updateBlock"
        />
      </div>

      <div>
        <label class="block text-sm font-medium text-gray-700 mb-2">
          ID truyện
        </label>
        <input
          v-model="localBlock.mangaId"
          type="number"
          class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
          placeholder="Nhập ID truyện..."
          @input="updateBlock"
        />
        <p class="text-xs text-gray-500 mt-1">
          ID của truyện, ví dụ 106 cho https://cuutruyen.net/mangas/106, không nhất thiết phải là truyện cùng nhóm.
        </p>
      </div>

      <!-- Info -->
      <div class="p-3 bg-blue-50 rounded-lg">
        <div class="text-sm text-blue-800">
          <strong>Khối Truyện Spotlight:</strong> Hiển thị truyện đơn tùy ý, chiếm toàn chiều rộng trang.
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'NewMangasBlockBuilder',

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
