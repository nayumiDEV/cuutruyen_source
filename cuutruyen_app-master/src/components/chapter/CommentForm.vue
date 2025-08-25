<template>
  <div class="p-1">
    <form v-if="currentUser && (!currentUser.user_ban || currentUser.user_ban.ban_type !== 'mute')" @submit.prevent="commentSubmit">
      <div class="flex justify-between rounded-t bg-gray-900 bg-opacity-70 p-1">
        <div class="flex items-center">
          <a href="https://www.markdownguide.org/basic-syntax/" target="_blank" rel="noopener noreferrer" class="text-sm button-bare text-gray-500 hover:text-gray-300 transition flex items-center"><LanguageMarkdownIcon class="inline mr-1" /> được hỗ trợ</a>
        </div>

        <button class="button-bare rounded bg-blue-700 hover:bg-blue-900 px-3 transition text-white"
          :class="{ 'button-disabled': isSending || content.length < 1 }"
          :disabled="isSending || content.length < 1"
        >
          <span class="font-bold">Gửi</span>
          <span class="text-xs ml-1 hidden lg:inline">ctrl+enter</span>
        </button>
      </div>
      <textarea
        ref="commentTextarea"
        v-model="content"
        class="w-full bg-gray-900 rounded-b shadow-lg p-2 resize-none focus:bg-opacity-60 text-gray-400 focus:text-gray-300 text-sm"
        placeholder="Nhập bình luận..."
        @keypress="keypressHandle"
      />
    </form>
    <div
      v-else-if="currentUser"
      class="w-full bg-gray-900 rounded shadow-lg p-2 resize-none focus:bg-opacity-60 text-gray-400 text-center select-text"
    >
      <div>Bạn đang bị giới hạn bình luận bởi quản trị viên.</div>
      <div v-if="currentUser.user_ban.banned_until">Giới hạn sẽ kết thúc vào <strong>{{ currentUser.user_ban.banned_until | humanizeTime }}</strong>.</div>
    </div>
    <div
      v-else
      class="w-full bg-gray-900 rounded shadow-lg p-2 resize-none focus:bg-opacity-60 text-gray-400 text-center select-text"
    >
      <router-link :to="{ name: 'Login' }" class="font-bold text-blue-400 hover:text-blue-200">Đăng nhập</router-link> hoặc <router-link :to="{ name: 'Register' }" class="font-bold text-blue-400 hover:text-blue-200">đăng ký tài khoản</router-link> để đăng bình luận.
    </div>
  </div>
</template>

<script>
import LanguageMarkdownIcon from 'vue-material-design-icons/LanguageMarkdown.vue'
import { mapGetters } from 'vuex'
import { createComment } from '@/apis/user'

export default {
  components: {
    LanguageMarkdownIcon
  },

  props: {
    chapter: Object
  },

  data () {
    return {
      content: '',
      isSending: false
    }
  },

  computed: {
    ...mapGetters([
      'currentUser'
    ])
  },

  methods: {
    async commentSubmit () {
      if (this.isSending === true) {
        return
      }

      try {
        this.isSending = true
        await createComment(this.chapter.id, { content: this.content })

        this.$notify({
          type: 'success',
          text: 'Thêm bình luận mới thành công!'
        })
        this.$gtag.event('add_comment')
        this.$emit('submitted')
        this.content = ''
      } catch (error) {
        if (error.response && error.response.status === 422) {
          this.$notify({
            type: 'warn',
            text: 'Vui lòng kiểm tra lại nội dung bạn nhập!'
          })
        } else {
          this.$notify({
            type: 'error',
            text: 'Có lỗi xảy ra khi đăng bình luận!'
          })
        }
      } finally {
        this.isSending = false
      }
    },

    keypressHandle (event) {
      if (event.keyCode === 13) {
        if (event.ctrlKey) {
          event.preventDefault()
          this.commentSubmit()
        }
      }
    },

    goToPage () {
      if (this.pinnedPage) {
        this.$emit('goToPage', this.pinnedPage)
      } else {
        this.$emit('goToPage', this.page)
      }
    },

    insertReply (comment) {
      this.content = this.content + `^${comment.id} `
      this.$refs.commentTextarea.focus()
    }
  }
}
</script>
