<template>
  <div class="group relative">
    <div class="flex items-center justify-between mb-4">
      <div class="flex items-center gap-2">
        <Avatar
          :image-url="team.avatar_url"
          :name="team.name"
        />

        <div class="flex flex-col">
          <div class="text-gray-700 font-bold">
            {{ team.name }}
          </div>
          <div class="text-gray-500 text-xs">
            {{ post.created_at | humanizeTime }}
          </div>
        </div>
      </div>

      <!-- Action buttons for team members -->
      <div v-if="canManagePost && isShowEdit" class="flex items-center gap-2 transition-opacity">
        <button
          @click="$emit('edit-post', post)"
          class="p-1 text-gray-500 hover:text-blue-600 transition-colors"
          title="Chỉnh sửa bài viết"
        >
          <PencilIcon :size="16" />
        </button>
        <button
          @click="$emit('delete-post', post)"
          class="p-1 text-gray-500 hover:text-red-600 transition-colors"
          title="Xóa bài viết"
        >
          <DeleteIcon :size="16" />
        </button>
      </div>
    </div>
    <div class="relative">
      <div
        ref="contentRef"
        class="prose prose-a:text-blue-500 max-w-none"
        :class="{
          'overflow-hidden': isPreview,
          [previewClass]: isPreview
        }"
        v-html="post.content"
      ></div>
      <button v-if="isPreview && isOverflowing" class="show-more-container absolute bottom-0 left-0 right-0" @click.prevent="$emit('show-more')">
        <div class="bg-gradient-to-t from-gray-100 to-transparent h-[100px] flex items-end justify-center">
          <button type="button" class="text-gray-700 font-bold text-xs">Xem thêm</button>
        </div>
      </button>
    </div>
  </div>
</template>

<script>
import PencilIcon from 'vue-material-design-icons/Pencil'
import DeleteIcon from 'vue-material-design-icons/Delete'
import { mapGetters } from 'vuex'
import Avatar from '@/components/common/Avatar'

export default {
  name: 'TeamProfilePost',

  components: {
    PencilIcon,
    DeleteIcon,
    Avatar
  },

  props: {
    post: {
      type: Object,
      required: true
    },
    team: {
      type: Object,
      required: true
    },
    isPreview: {
      type: Boolean,
      default: false
    },
    previewClass: {
      type: String,
      default: 'max-h-[600px]'
    },
    isShowEdit: {
      type: Boolean,
      default: false
    }
  },

  data () {
    return {
      isOverflowing: false
    }
  },

  computed: {
    ...mapGetters([
      'currentUser'
    ]),
    canManagePost () {
      return this.currentUser && this.currentUser.teams.map(t => Number(t.id)).includes(this.team.id)
    }
  },

  mounted () {
    this.checkOverflow()
  },

  watch: {
    post: {
      handler () {
        this.$nextTick(this.checkOverflow)
      },
      deep: true
    },
    isPreview () {
      this.$nextTick(this.checkOverflow)
    }
  },

  methods: {
    checkOverflow () {
      const el = this.$refs.contentRef
      if (el) {
        this.isOverflowing = el.scrollHeight > 600
      }
    }
  }
}
</script>
