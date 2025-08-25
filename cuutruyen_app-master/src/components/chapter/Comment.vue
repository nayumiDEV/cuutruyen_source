<template>
  <div v-if="!comment.is_shadow_removed || (currentUser && comment.user.username === currentUser.username)" class="mt-2 w-10/12 items-stretch"
    :class="{
      'flex flex-col items-end self-end': currentUser && comment.user.username === currentUser.username,
      }"
  >
    <div v-if="!comment.remover" class="rounded overflow-hidden mt-1.5 bg-opacity-70 inline-block max-w-full bg-gray-900 transition duration-400" :id="`c-${comment.id}`">
      <div class="mb-1.5 px-3 py-1">
        <router-link
          :to="{ name: 'AdminUserManagement', query: { q: comment.user.username } }"
          v-if="currentUser &&currentUser.level === 'admin'"
          class="font-bold text-gray-300 text-sm md:text-base mr-2 select-text"
          target="_blank"
        >{{ comment.user.username }}</router-link>
        <span v-else class="font-bold text-gray-300 text-sm md:text-base mr-2 select-text">{{ comment.user.username }}</span>
        <div class="inline-flex flex-wrap gap-1.5">
          <div
            v-if="comment.user.level === 'admin'"
            class="inline uppercase bg-yellow-800 text-yellow-100 text-xxs py-0.5 px-1 rounded-sm"
          >
            Admin
          </div>

          <template v-else>
            <div
              v-for="team in comment.user.teams"
              :key="'c-' + comment.id + '-' + team.id"
              class="inline uppercase bg-blue-700 text-blue-100 text-xxs py-0.5 px-1 rounded-sm truncate" style="max-width: 6.5rem"
            >
              {{ team.name }}
            </div>
          </template>
        </div>
      </div>

      <div class="px-3 py-1 text-gray-400 break-words text-sm comment-content select-text" v-html="comment.processed_content"></div>

      <div v-show="comment.replied_ids.length > 0" class="bg-gray-900 text-gray-500 px-2 py-1 max-w-full text-xs">
        <span>{{ comment.replied_ids.length }} trả lời: </span>
        <span v-for="(repliedId, index) in comment.replied_ids" :key="'child-' + comment.id + '-' + repliedId">
          <button @click="jumpToComment(repliedId)" class="group">
            <span class="text-gray-700 group-hover:text-green-700">^</span><span class="group-hover:text-green-500">{{ repliedId }}</span>
          </button>
          <span v-if="index < comment.replied_ids.length - 1">, </span>
        </span>
      </div>
    </div>

    <div v-else class="rounded overflow-hidden mt-1.5 bg-opacity-10 inline-block max-w-full bg-gray-900 border border-gray-900 transition duration-400" :id="`c-${comment.id}`">
      <div class="px-3 py-2.5 text-gray-500 break-words text-xs italic">
        <p>Bình luận này đã bị gỡ bỏ bởi {{ comment.remover.username }}</p>
        <p v-if="comment.remove_reason" class="mt-1">Lý do: {{ comment.remove_reason }}</p>
      </div>
    </div>

    <div class="text-gray-500 text-xs">
      <span :title="comment.created_at | humanizeTimeFull">{{ comment.created_at | humanizeTime }}</span>

      <template v-if="!comment.remover">
        <span class="mx-1"> · </span>
        <span class="font-xs"><span class="text-gray-700">^</span>{{ comment.id }}</span>

        <template v-if="currentUser && comment.user.id !== currentUser.id">
          <span class="mx-1"> · </span>
          <button class="text-gray-400 font-bold hover:text-gray-100 transition" @click="insertReply(comment)">Trả lời</button>
        </template>

        <template v-if="currentUser && (currentUser.level === 'admin' || comment.user.id === Number(currentUser.id) || currentUser.teams.map(t => Number(t.id)).includes(chapter.team.id))">
          <span class="mx-1"> · </span>
          <button class="text-red-400 text-opacity-60 font-bold hover:text-red-300 transition" @click="isShowRemoveModal = true">Gỡ bỏ</button>
        </template>
      </template>

      <template v-if="currentUser && currentUser.level === 'admin'">
        <span class="mx-1"> · </span>
        <button class="text-red-400 text-opacity-60 font-bold hover:text-red-300 transition" @click="isShowDestroyModal = true">Xóa</button>
      </template>
    </div>

    <portal>
      <CommentRemoveModal :comment="comment" :isShow="isShowRemoveModal" @cancel="isShowRemoveModal = false" @confirm="remove" />
      <CommentDestroyModal :comment="comment" :isShow="isShowDestroyModal" @cancel="isShowDestroyModal = false" @confirm="destroy" />
    </portal>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
import { removeComment, destroyComment } from '@/apis/user'
import CommentRemoveModal from './CommentRemoveModal'
import CommentDestroyModal from './CommentDestroyModal'

export default {
  components: {
    CommentRemoveModal,
    CommentDestroyModal
  },

  props: {
    comment: Object,
    chapter: Object
  },

  computed: {
    ...mapGetters([
      'currentUser'
    ])
  },

  data () {
    return {
      isShowRemoveModal: false,
      isShowDestroyModal: false
    }
  },

  methods: {
    insertReply () {
      this.$emit('insertReply', this.comment)
    },

    async remove (reason) {
      try {
        await removeComment(this.comment.id, {
          comment: {
            remove_reason: reason
          }
        })
        this.$notify({
          type: 'success',
          text: 'Bạn đã gỡ bỏ bình luận thành công!'
        })
        this.$emit('reloadComments')
      } catch (error) {
        console.error(error)
        this.$notify({
          type: 'error',
          text: 'Có lỗi xảy ra khi gỡ bỏ bình luận!'
        })
      }
    },

    async destroy () {
      try {
        await destroyComment(this.comment.id)
        this.$notify({
          type: 'success',
          text: 'Bạn đã gỡ bỏ bình luận thành công!'
        })
        this.$emit('reloadComments')
      } catch (error) {
        console.error(error)
        this.$notify({
          type: 'error',
          text: 'Có lỗi xảy ra khi gỡ bỏ bình luận!'
        })
      }
    },

    jumpToComment (repliedId) {
      this.$emit('jumpToComment', repliedId)
    }
  }
}
</script>
