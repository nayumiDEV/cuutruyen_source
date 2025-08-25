<template>
  <vue-final-modal
    v-model="show"
    classes="flex w-screen-xl justify-center items-center mx-2"
    content-class="max-w-screen-xl max-h-full w-full flex flex-col shadow-lg bg-white overflow-hidden"
  >
    <div class="flex justify-between items-center overflow-hidden h-12 flex-none">
      <div class="grow font-head font-bold text-xl text-gray-700 p-4 truncate">
        {{ isEditing ? 'Chỉnh sửa bài viết' : 'Bài viết' }}
      </div>

      <div class="flex-none flex items-center gap-2 p-4">
        <template v-if="isEditing">
          <button
            class="px-4 py-1 button hover:bg-gray-100 text-gray-700"
            @click="cancelEdit"
          >
            Hủy
          </button>
          <button
            class="px-4 py-1 button button-primary"
            @click="saveEdit"
          >
            Lưu
          </button>
        </template>
        <button v-else class="text-gray-800" @click="cancel">
          <CloseIcon />
        </button>
      </div>
    </div>

    <div class="flex-grow overflow-y-auto px-4 py-3 text-gray-200">
      <template v-if="post">
        <div v-if="isEditing">
          <DescriptionEditor ref="editEditor" v-model="localEditContent" class="mt-4 border" />
        </div>
        <Post v-else :post="post" :team="team" />
      </template>
    </div>
  </vue-final-modal>
</template>

<script>
import CloseIcon from 'vue-material-design-icons/Close'
import Post from './Post'
import DescriptionEditor from '@/components/team-management/DescriptionEditor'

export default {
  props: {
    post: Object,
    team: Object,
    isEditing: {
      type: Boolean,
      default: false
    },
    editContent: {
      type: String,
      default: ''
    }
  },

  components: {
    CloseIcon,
    Post,
    DescriptionEditor
  },

  data () {
    return {
      show: false,
      localEditContent: ''
    }
  },

  methods: {
    cancel () {
      this.show = false
    },

    saveEdit () {
      this.$emit('save-edit', this.localEditContent)
    },

    cancelEdit () {
      this.$emit('cancel-edit')
    }
  },

  watch: {
    post (to) {
      if (to) {
        this.show = true
      } else {
        this.show = false
      }
    },

    editContent (to) {
      this.localEditContent = to
    },

    show (to, from) {
      if (!to) {
        this.$emit('cancel')
      }
    }
  }
}
</script>
