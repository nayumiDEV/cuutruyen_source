<template>
  <div>

    <!-- Draggable Block List -->
    <div class="flex flex-col gap-2">
      <draggable
        v-model="localBlocks"
        handle=".drag-handle"
        @start="isDragging = true"
        @end="isDragging = false"
        v-bind="{ animation: 200, ghostClass: 'ghost-block' }"
        class="flex flex-col gap-2"
      >
        <BlockItem
          v-for="(block, index) in localBlocks"
          :key="block.id"
          :block="block"
          :index="index"
          @update="updateBlock"
          @remove="removeBlock"
        />
      </draggable>
    </div>

    <!-- Empty State -->
    <div v-if="localBlocks.length === 0" class="text-center py-12 text-gray-500">
      <div class="text-lg mb-2">Chưa có khối nội dung nào</div>
      <div class="text-sm">Nhấn vào các nút bên trên để thêm khối mới</div>
    </div>

    <div class="mt-6">
      <!-- Add Block Buttons -->
      <div class="flex flex-wrap gap-2 mb-4">
        <button
          v-for="blockType in availableBlockTypes"
          :key="blockType.type"
          @click="addBlock(blockType.type)"
          class="px-2 py-1 bg-green-100 hover:bg-green-200 text-green-800 font-bold text-xs rounded-lg transition-colors"
        >
          + {{ blockType.label }}
        </button>
      </div>
    </div>

    <!-- Action Buttons -->
    <div class="flex justify-end gap-3 mt-8">
      <button
        @click="resetBlocks"
        class="px-6 py-2 button button-normal2"
      >
        Đặt lại
      </button>
      <button
        @click="saveBlocks"
        class="px-6 py-2 button button-primary"
      >
        Xác nhận lưu
      </button>
    </div>

    <!-- JSON Preview (for testing) -->
    <div v-if="showJsonPreview" class="mt-8 p-4 bg-gray-100 rounded-lg">
      <h4 class="font-semibold mb-2">JSON Preview:</h4>
      <pre class="text-sm overflow-auto">{{ JSON.stringify(localBlocks, null, 2) }}</pre>
    </div>
  </div>
</template>

<script>
import draggable from 'vuedraggable'
import BlockItem from './BlockItem.vue'
import { v4 as uuidv4 } from 'uuid'

export default {
  name: 'BlockBuilder',

  components: {
    draggable,
    BlockItem
  },

  props: {
    initialBlocks: {
      type: Array,
      default: () => []
    },
    showJsonPreview: {
      type: Boolean,
      default: true
    }
  },

  data () {
    return {
      localBlocks: [],
      isDragging: false,
      availableBlockTypes: [
        { type: 'new-mangas', label: 'Truyện mới' },
        { type: 'top-mangas', label: 'Truyện nổi bật' },
        { type: 'spotlight-manga', label: 'Truyện Spotlight' },
        { type: 'new-posts', label: 'Bài viết mới' },
        { type: 'image', label: 'Hình ảnh' },
        { type: 'youtube', label: 'YouTube' },
        { type: 'soundcloud', label: 'SoundCloud' },
        { type: 'paragraph', label: 'Đoạn văn' },
        { type: 'html', label: 'HTML' }
      ]
    }
  },

  mounted () {
    this.resetBlocks()
  },

  methods: {
    addBlock (type) {
      const newBlock = this.createBlock(type)
      this.localBlocks.push(newBlock)
      this.updateOrder()
    },

    createBlock (type) {
      const baseBlock = {
        id: uuidv4(),
        type,
        order: this.localBlocks.length + 1
      }

      // Set default values based on block type
      switch (type) {
        case 'new-mangas':
          return { ...baseBlock, title: 'Truyện mới' }
        case 'top-mangas':
          return { ...baseBlock, title: 'Truyện nổi bật' }
        case 'spotlight-manga':
          return { ...baseBlock, title: 'Spotlight', mangaId: '' }
        case 'new-posts':
          return { ...baseBlock, title: 'Bài viết mới' }
        case 'image':
          return {
            ...baseBlock,
            title: null,
            src: '',
            options: { mobileSrc: '' }
          }
        case 'youtube':
          return {
            ...baseBlock,
            title: 'Video YouTube',
            youtubeUrl: '',
            options: {
              autoplay: false,
              startTime: 0,
              showControls: true,
              showRelated: true
            }
          }
        case 'soundcloud':
          return {
            ...baseBlock,
            title: 'SoundCloud',
            soundcloudUrl: '',
            options: {
              visual: true,
              autoplay: false,
              hideRelated: false,
              showComments: true,
              showUser: true,
              showReposts: true,
              color: '#ff5500'
            }
          }
        case 'paragraph':
          return {
            ...baseBlock,
            title: 'Đoạn văn mới',
            content: '<p>Nội dung đoạn văn...</p>',
            options: {}
          }
        case 'html':
          return {
            ...baseBlock,
            title: null,
            content: '<div class="text-gray-900">HTML content...</div>',
            options: {}
          }
        default:
          return baseBlock
      }
    },

    updateBlock (index, updatedBlock) {
      this.$set(this.localBlocks, index, updatedBlock)
    },

    removeBlock (index) {
      this.localBlocks.splice(index, 1)
      this.updateOrder()
    },

    updateOrder () {
      this.localBlocks.forEach((block, index) => {
        block.order = index + 1
      })
    },

    resetBlocks () {
      // Copy initial blocks to avoid mutation
      this.localBlocks = JSON.parse(JSON.stringify(this.initialBlocks))
    },

    saveBlocks () {
      this.updateOrder()
      this.$emit('save', JSON.parse(JSON.stringify(this.localBlocks)))
    }
  },

  watch: {
    localBlocks: {
      handler () {
        this.updateOrder()
      },
      deep: true
    }
  }
}
</script>

<style scoped>
.ghost-block {
  @apply opacity-50;
}
</style>
