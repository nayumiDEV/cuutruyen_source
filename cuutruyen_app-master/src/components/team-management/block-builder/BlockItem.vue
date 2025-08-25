<template>
  <div class="block-item bg-gray-100 hover:shadow-sm rounded transition-all">
    <!-- Block Header -->
    <div class="flex items-center justify-between p-4">
      <div class="flex items-center gap-3">
        <!-- Drag Handle -->
        <div class="drag-handle cursor-move text-gray-400 hover:text-gray-600">
          <DragIcon :size="20" />
        </div>

        <!-- Block Type Badge -->
        <span class="px-2 py-1 bg-blue-100 text-blue-800 text-xs font-medium rounded w-[7rem] text-center whitespace-nowrap line-clamp-1">
          {{ getBlockTypeLabel(block.type) }}
        </span>

        <!-- Block Title -->
        <div class="font-medium text-gray-900">
          <span v-if="block.title">{{ block.title }}</span>
          <span v-else class="text-gray-400 italic">Không có tiêu đề</span>
        </div>
      </div>

      <!-- Actions -->
      <div class="flex items-center gap-2">
        <button
          @click="toggleExpanded"
          class="p-1 text-gray-400 hover:text-gray-600 rounded"
          :title="isExpanded ? 'Thu gọn' : 'Mở rộng'"
        >
          <ChevronDownIcon :size="16" :class="{ 'transform rotate-180': isExpanded }" />
        </button>
        <button
          @click="removeBlock"
          class="p-1 text-red-400 hover:text-red-600 rounded"
          title="Xóa khối"
        >
          <DeleteIcon :size="16" />
        </button>
      </div>
    </div>

    <!-- Block Content Editor -->
    <div v-if="isExpanded" class="p-4">
      <component
        :is="getBlockComponent(block.type)"
        :block="block"
        @update="updateBlock"
      />
    </div>
  </div>
</template>

<script>
import DragIcon from 'vue-material-design-icons/Drag.vue'
import ChevronDownIcon from 'vue-material-design-icons/ChevronDown.vue'
import DeleteIcon from 'vue-material-design-icons/Delete.vue'

// Import block builder components
import NewMangasBlockBuilder from './NewMangasBlockBuilder.vue'
import TopMangasBlockBuilder from './TopMangasBlockBuilder.vue'
import NewPostsBlockBuilder from './NewPostsBlockBuilder.vue'
import ImageBlockBuilder from './ImageBlockBuilder.vue'
import ParagraphBlockBuilder from './ParagraphBlockBuilder.vue'
import HtmlBlockBuilder from './HtmlBlockBuilder.vue'
import SpotlightBuilder from './SpotlightBuilder.vue'
import YoutubeBlockBuilder from './YoutubeBlockBuilder.vue'
import SoundcloudBlockBuilder from './SoundcloudBlockBuilder.vue'

export default {
  name: 'BlockItem',

  components: {
    DragIcon,
    ChevronDownIcon,
    DeleteIcon,
    NewMangasBlockBuilder,
    TopMangasBlockBuilder,
    NewPostsBlockBuilder,
    ImageBlockBuilder,
    ParagraphBlockBuilder,
    HtmlBlockBuilder,
    SpotlightBuilder,
    YoutubeBlockBuilder,
    SoundcloudBlockBuilder
  },

  props: {
    block: {
      type: Object,
      required: true
    },
    index: {
      type: Number,
      required: true
    }
  },

  data () {
    return {
      isExpanded: false
    }
  },

  methods: {
    getBlockTypeLabel (type) {
      const labels = {
        'new-mangas': 'Truyện mới',
        'top-mangas': 'Truyện nổi bật',
        'new-posts': 'Bài viết mới',
        image: 'Hình ảnh',
        youtube: 'YouTube',
        soundcloud: 'SoundCloud',
        paragraph: 'Đoạn văn',
        html: 'HTML',
        'spotlight-manga': 'Truyện Spotlight'
      }
      return labels[type] || type
    },

    getBlockComponent (type) {
      const components = {
        'new-mangas': 'NewMangasBlockBuilder',
        'top-mangas': 'TopMangasBlockBuilder',
        'new-posts': 'NewPostsBlockBuilder',
        image: 'ImageBlockBuilder',
        youtube: 'YoutubeBlockBuilder',
        soundcloud: 'SoundcloudBlockBuilder',
        paragraph: 'ParagraphBlockBuilder',
        html: 'HtmlBlockBuilder',
        'spotlight-manga': 'SpotlightBuilder'
      }
      return components[type] || 'div'
    },

    toggleExpanded () {
      this.isExpanded = !this.isExpanded
    },

    updateBlock (updatedBlock) {
      this.$emit('update', this.index, updatedBlock)
    },

    removeBlock () {
      if (confirm('Bạn có chắc chắn muốn xóa khối này?')) {
        this.$emit('remove', this.index)
      }
    }
  }
}
</script>

<style scoped>
.drag-handle {
  transition: color 0.2s ease;
}
</style>
