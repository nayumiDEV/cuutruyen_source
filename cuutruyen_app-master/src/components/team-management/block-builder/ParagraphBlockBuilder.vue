<template>
  <div class="paragraph-block-builder">
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

      <!-- Content Editor -->
      <div>
        <label class="block text-sm font-medium text-gray-700 mb-2">
          Nội dung
        </label>
        <DescriptionEditor
          v-model="localBlock.content"
          @input="updateBlock"
        />
      </div>

      <!-- Info -->
      <div class="p-3 bg-blue-50 rounded-lg">
        <div class="text-sm text-blue-800">
          <strong>Khối Đoạn văn:</strong> Hiển thị nội dung văn bản với định dạng phong phú (WYSIWYG).
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import DescriptionEditor from '@/components/team-management/DescriptionEditor.vue'

export default {
  name: 'ParagraphBlockBuilder',

  components: {
    DescriptionEditor
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
      }
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
