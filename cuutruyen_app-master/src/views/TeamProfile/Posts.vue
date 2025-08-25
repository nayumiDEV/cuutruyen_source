<template>
  <div class="mx-2 py-8 lg:py-16">
    <CuuHeading>Bài viết</CuuHeading>

    <div class="common-container">
      <template v-if="currentUser && currentUser.teams.map(t => Number(t.id)).includes(team.id)">
        <div v-if="isHideEditor">
          <!-- Fake textarea -->
          <div
            @click="showEditor"
            class="text-gray-500 rounded-lg bg-gray-200 p-4 h-20 mt-4 cursor-text flex items-center gap-2"
          >
            <PenIcon class="text-gray-400" :size="16" />
            <span class="text-sm">Thêm bài viết mới...</span>
          </div>
        </div>

        <div v-else>
          <DescriptionEditor ref="postEditor" v-model="newPostContent" class="mt-4" @blur="handleEditorBlur" />
          <button type="submit" class="button button-primary px-4 py-2 mt-4" @click.prevent="addPost">Thêm bài viết</button>
        </div>
      </template>

      <div v-if="loading" class="h-screen flex justify-center items-center">
        <span class="spin">
          <LoadingIcon :size="64" class="text-gray-500" />
        </span>
      </div>

      <div v-else-if="posts && posts.length > 0" class="mt-10 flex flex-col gap-4">
        <Post
          v-for="post in posts"
          :key="post.id"
          :post="post"
          :team="team"
          :isPreview="true"
          :isShowEdit="true"
          class="p-4 rounded-lg bg-gray-100"
          @show-more="showPost(post)"
          @edit-post="editPost"
          @delete-post="confirmDeletePost"
        />
      </div>

      <EmptyScreen v-else message="Chưa có bài viết nào được đăng lên đây!"></EmptyScreen>
    </div>

    <CuuPaginate routeName="TeamProfilePosts" :currentPage="currentPage" :totalPages="totalPages" />

    <PostModal
      :post="selectedPost"
      :team="team"
      :isEditing="!!editingPost"
      :editContent="editPostContent"
      @cancel="cancelEdit"
      @save-edit="updatePost"
      @cancel-edit="cancelEdit"
    />

    <PostDeleteModal
      :post="deletingPost"
      :team="team"
      @cancel="deletingPost = null"
      @confirm="deletePost(deletingPost)"
    />
  </div>
</template>

<script>
import DescriptionEditor from '@/components/team-management/DescriptionEditor'
import Post from '@/components/team-profile/Post'
import PostModal from '@/components/team-profile/PostModal'
import PostDeleteModal from '@/components/team-management/PostDeleteModal'
import PenIcon from 'vue-material-design-icons/Pen.vue'
import { getTeamPosts } from '@/apis/user'
import { createTeamPost, updateTeamPost, deleteTeamPost } from '@/apis/team'
import { mapGetters } from 'vuex'

export default {
  name: 'TeamProfilePosts',

  metaInfo () {
    return {
      title: `Bài viết - ${this.team.name}`
    }
  },

  components: {
    DescriptionEditor,
    Post,
    PostModal,
    PostDeleteModal,
    PenIcon
  },

  props: {
    layoutProps: {
      type: Object,
      required: true
    }
  },

  data () {
    return {
      loading: false,
      posts: null,
      currentPage: 1,
      totalPages: 1,
      newPostContent: '',
      isHideEditor: true,
      selectedPost: null,
      editingPost: null,
      editPostContent: '',
      deletingPost: null
    }
  },

  computed: {
    ...mapGetters([
      'currentUser'
    ]),
    team () {
      return this.layoutProps.team
    }
  },

  async mounted () {
    this.$gtag.config({
      send_page_view: false
    })
    this.$gtag.pageview({ page_title: `Bài viết - ${this.team.name}` })
    this.loadPosts(this.currentPage)
  },

  methods: {
    showEditor () {
      this.isHideEditor = false
      this.$nextTick(() => {
        this.$refs.postEditor.focus()
      })
    },

    showPost (post) {
      this.selectedPost = post
    },

    async loadPosts (page) {
      this.loading = true
      try {
        const response = await getTeamPosts(this.team.id, page, 30)
        this.posts = response.data
        this.meta = response._metadata
      } catch (error) {
        this.error = true

        this.$handleError(error)
      } finally {
        this.loading = false
        this.releaseBodyScroll()
      }
    },

    async addPost () {
      try {
        await createTeamPost(this.team.id, { content: this.newPostContent })
        this.isHideEditor = true
        this.newPostContent = ''
        this.$notify({
          type: 'success',
          text: 'Thêm bài viết thành công!'
        })
        this.loadPosts(1)
      } catch (error) {
        console.error(error)
        if (error.response && error.response.status === 422) {
          this.$notify({
            type: 'warn',
            text: 'Vui lòng kiểm tra lại nội dung bạn nhập!'
          })
        } else {
          this.$notify({
            type: 'error',
            text: 'Thêm bài viết thất bại!'
          })
        }
      }
    },

    editPost (post) {
      this.editingPost = post
      this.editPostContent = post.content
      this.selectedPost = post
    },

    async updatePost (newContent) {
      if (!this.editingPost) return

      // Use the passed content or fall back to editPostContent
      const contentToUpdate = newContent || this.editPostContent

      try {
        await updateTeamPost(this.team.id, this.editingPost.id, { content: contentToUpdate })

        // Update the post in the local posts array
        const postIndex = this.posts.findIndex(p => p.id === this.editingPost.id)
        if (postIndex !== -1) {
          this.posts[postIndex].content = contentToUpdate
        }

        this.editingPost = null
        this.editPostContent = ''
        this.selectedPost = null

        this.$notify({
          type: 'success',
          text: 'Cập nhật bài viết thành công!'
        })
      } catch (error) {
        console.error(error)
        if (error.response && error.response.status === 422) {
          this.$notify({
            type: 'warn',
            text: 'Vui lòng kiểm tra lại nội dung bạn nhập!'
          })
        } else {
          this.$notify({
            type: 'error',
            text: 'Cập nhật bài viết thất bại!'
          })
        }
      }
    },

    cancelEdit () {
      this.editingPost = null
      this.editPostContent = ''
      this.selectedPost = null
    },

    confirmDeletePost (post) {
      this.deletingPost = post
    },

    async deletePost (post) {
      try {
        await deleteTeamPost(this.team.id, post.id)

        // Remove the post from the local posts array
        this.posts = this.posts.filter(p => p.id !== post.id)

        this.$notify({
          type: 'success',
          text: 'Xóa bài viết thành công!'
        })
      } catch (error) {
        console.error(error)
        this.$notify({
          type: 'error',
          text: 'Xóa bài viết thất bại!'
        })
      }
    },

    handleEditorBlur () {
      // const strippedContent = this.newPostContent.replace(/<[^>]*>/g, '').trim()
      // if (!strippedContent) {
      //   this.isHideEditor = true
      // }
    }
  }
}
</script>
