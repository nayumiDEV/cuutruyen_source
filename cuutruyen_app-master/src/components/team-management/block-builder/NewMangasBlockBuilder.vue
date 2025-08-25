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

      <!-- Info -->
      <div class="p-3 bg-blue-50 rounded-lg">
        <div class="text-sm text-blue-800">
          <strong>Khối Truyện mới:</strong> Hiển thị danh sách các truyện được cập nhật gần đây nhất.
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
