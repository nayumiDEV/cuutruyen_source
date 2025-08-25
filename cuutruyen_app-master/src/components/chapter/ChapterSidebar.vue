<template>
  <div>
    <div class="h-screen fixed top-0 left-0 bottom-0 right-0 w-full z-40 bg-black transition-all fine-transition" @click.stop="overlayClicked"
      :class="{
        'bg-opacity-0 invisible': !isShowSidebar,
        'bg-opacity-80': isShowSidebar
        }"
    ></div>
    <aside class="fixed bottom-0 left-0 z-50 h-sidebar w-[92vw] max-w-[28rem] md:w-[28rem] h-[calc(100%-80px)] lg:h-screen bg-gray-900 overflow-hidden transition-transform transform mt-12 lg:mt-0 rounded-tr-lg lg:rounded-none"
      :class="{
        'shadow-sidebar': isShowSidebar,
        '-translate-x-full': !isShowSidebar
        }"
      v-click-outside="vcoConfig"
    >

      <div class="overflow-auto h-full w-full flex flex-col bg-gray-800 scroll-contain">
        <ChapterNavigation :chapter="chapter" :manga="manga" @hideSidebar="hideSidebar" />

        <div v-if="loading && !comments" class="h-full w-full flex justify-center items-center">
          <div class="spin text-gray-400"><LoadingIcon :size="64" /></div>
        </div>

        <div v-else-if="error" class="h-full w-full flex justify-center items-center">
          <div class="text-red-400"><AlertIcon :size="64" /></div>
        </div>

        <div v-else class="h-full text-gray-300 overflow-y-auto" style="overscroll-behavior-y: contain" ref="commentsList">
          <div v-if="comments && comments.length > 0" class="p-2 flex flex-col">
            <Comment v-for="comment in comments" :comment="comment" :chapter="chapter" :key="`comment-${comment.id}`" @insertReply="insertReply" @reloadComments="reloadComments" @jumpToComment="jumpToComment" />
          </div>

          <div v-else class="w-full h-full flex items-center justify-center text-sm text-center p-8 text-gray-600">
            Chưa có bình luận nào. Hãy là người đầu tiên bình luận!
          </div>
        </div>

        <CommentForm ref="commentForm" :chapter="chapter" @submitted="reloadComments" />
      </div>
    </aside>
  </div>
</template>

<script>
import vClickOutside from 'v-click-outside'
import LoadingIcon from 'vue-material-design-icons/Loading.vue'
import AlertIcon from 'vue-material-design-icons/Alert.vue'
import { mapGetters, mapMutations } from 'vuex'
import Comment from '@/components/chapter/Comment.vue'
import CommentForm from '@/components/chapter/CommentForm.vue'
import ChapterNavigation from '@/components/chapter/ChapterNavigation.vue'
import { getComments } from '@/apis/user'

export default {
  directives: {
    clickOutside: vClickOutside.directive
  },

  components: {
    Comment,
    CommentForm,
    ChapterNavigation,
    LoadingIcon,
    AlertIcon
  },

  props: {
    chapter: Object,
    error: Boolean,
    isShowSidebar: {
      type: Boolean,
      default: false
    }
  },

  computed: {
    manga () {
      return this.chapter.manga
    },

    ...mapGetters([
      'currentUser'
    ])
  },

  data () {
    return {
      comments: null,
      isShow: false,
      vcoConfig: {
        handler: this.hideSidebarDummy,
        events: ['mousedown'],
        middleware: this.vcoMiddleware
      },
      newComment: null,
      loading: false
    }
  },

  methods: {
    ...mapMutations(['setMessengerVisible']),

    overlayClicked () {
      this.$emit('hideSidebar')
    },

    async loadComments (chapter) {
      this.loading = true
      try {
        const response = await getComments(this.chapter.id)
        this.comments = response.data

        this.$nextTick(() => {
          this.initReplyHandler()
          this.scrollToBottom()
        })
      } catch (error) {
        console.error(error)
        this.$notify({
          type: 'error',
          text: 'Gặp lỗi khi tải bình luận'
        })
      } finally {
        this.loading = false
      }
    },

    reloadComments () {
      this.loadComments()
    },

    scrollToBottom () {
      if (this.$refs.commentsList) {
        this.$refs.commentsList.scrollTop = this.$refs.commentsList.scrollHeight
      }
    },

    initReplyHandler () {
      if (this.$refs.commentsList) {
        this.$refs.commentsList.querySelectorAll('.reply-comment').forEach((node) => {
          const idNode = node.querySelector('.reply-comment-id')
          const commentId = Number(idNode.textContent.substring(1))

          node.addEventListener('click', (event) => {
            event.preventDefault()
            this.jumpToComment(commentId)
          })
        })
      }
    },

    jumpToComment (commentId) {
      const commentEl = this.$refs.commentsList.querySelector(`#c-${commentId}`)
      commentEl.scrollIntoView({ block: 'center', behavior: 'smooth' })
      commentEl.classList.add('comment-highlight')
      setTimeout(() => {
        commentEl.classList.remove('comment-highlight')
      }, 1000)
    },

    hideSidebarDummy () {
      // TODO
    },

    hideSidebar () {
      if (this.isShowSidebar) {
        this.$emit('hideSidebar')
      }
    },

    vcoMiddleware (event) {
      return this.isShowSidebar
    },

    insertReply (comment) {
      this.$refs.commentForm.insertReply(comment)
    }
  },

  created () {
    setTimeout(() => {
      if (!this.comments) {
        this.loadComments()
      }
    }, 1000)
  },

  beforeDestroy () {
    this.releaseBodyScroll()
  },

  watch: {
    chapter () {
      this.loadComments()
    },

    isShowSidebar (to) {
      if (to) {
        if (!this.comments) {
          this.loadComments()
        }

        this.lockBodyScroll()
        this.setMessengerVisible(false)
      } else {
        this.releaseBodyScroll()
        this.setMessengerVisible(true)
      }
    }
  }
}
</script>

<style>
.shadow-sidebar {
  box-shadow: 6px 0px 12px 6px rgba(17, 24, 39, 0.75);
}

.comment-highlight {
  @apply bg-green-900;
}

.mention-user {
  @apply inline-flex items-center text-yellow-300 font-bold bg-yellow-700 bg-opacity-40 hover:bg-yellow-800 transition text-xs p-0.5 mr-0.5 mb-0.5;
}

.reply-comment {
  @apply inline-flex gap-0.5 bg-green-700 text-green-300 font-bold bg-opacity-40 hover:bg-green-800 transition text-xs mr-0.5 mb-0.5;
}

.reply-comment-id {
  @apply flex items-center p-0.5;
}

.reply-comment-username {
  @apply flex items-center bg-green-600 bg-opacity-40 transition p-0.5 select-none;
}

.reply-comment:hover .reply-comment-username {
  @apply bg-green-700;
}

.mention-user-not-found {
  @apply text-red-500 font-bold line-through p-0.5 text-xs;
}

.reply-comment-not-found {
  @apply text-red-500 line-through font-bold p-0.5 text-xs rounded mr-0.5 mb-0.5;
}

.comment-content a:not(.mention-user,.reply-comment,.mention-user-not-found,.reply-comment-not-found,.linkified-img) {
  @apply text-blue-300 hover:text-blue-100 transition;
}

.comment-content .linkified-img {
  @apply text-purple-200 mr-0.5 mb-0.5 px-2 py-1 bg-purple-700 hover:bg-purple-900 transition font-bold text-xs inline-block rounded;
}

.comment-content p {
  @apply mb-2 text-sm;
}

.comment-content h1 {
  @apply font-extrabold text-base border-l-4 pl-2 border-blue-800 mb-1;
}

.comment-content h2 {
  @apply font-bold text-base border-b border-blue-800 mb-1;
}

.comment-content h3 {
  @apply font-semibold text-sm mb-1;
}

.comment-content :not(pre) > code {
  @apply bg-gray-600 px-1 py-0.5 font-mono text-sm;
}

.comment-content pre {
  @apply border-l-2 border-gray-500 bg-gray-800 p-2 font-mono overflow-auto text-sm;
}

.comment-content pre code {
  @apply font-mono text-sm;
}

.comment-content blockquote {
  @apply mx-2 my-2 border-l-2 border-green-500 pl-2;
}

.comment-content img {
  aspect-ratio: 1 / 1;
  width: 128px;
}
</style>
