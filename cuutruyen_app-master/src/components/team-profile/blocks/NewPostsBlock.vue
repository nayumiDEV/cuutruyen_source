<template>
  <div class="py-14 lg:py-20 px-2">
    <CuuHeading v-if="block.title">{{ block.title }}</CuuHeading>

    <div class="common-container">
      <div v-if="loading" class="h-[300px] flex justify-center items-center">
        <span class="spin">
          <LoadingIcon :size="64" class="text-gray-500" />
        </span>
      </div>
      <div v-else-if="posts.length === 0" class="text-gray-500 py-16 md:py-24 flex items-center justify-center">
        Không có bài viết mới nào.
      </div>
      <div v-else>
        <div class="mb-4 lg:mb-6 grid grid-cols-1 md:grid-cols-2 gap-4">
          <Post v-for="post in displayedPosts" :key="post.id" :post="post" :team="team" :isPreview="true" :previewClass="'max-h-[300px]'" class="p-4 rounded-lg bg-gray-100" @show-more="showPost(post)" />
        </div>

        <div class="flex justify-end">
          <router-link :to="{ name: 'TeamProfilePosts', params: { teamId: team.slug } }" class="cursor-pointer flex items-center text-gray-600 hover:text-blue-600 transition text-sm font-bold">
            <ChevronRightIcon mr-1 :size="16" />
            <span>Xem danh sách bài viết</span>
          </router-link>
        </div>
      </div>
    </div>

    <PostModal :post="selectedPost" :team="team" @cancel="selectedPost = null" />
  </div>
</template>

<script>
import { getTeamPosts } from '@/apis/user'
import Post from '@/components/team-profile/Post'
import ChevronRightIcon from 'vue-material-design-icons/ChevronRight.vue'
import PostModal from '@/components/team-profile/PostModal'
import LoadingIcon from 'vue-material-design-icons/Loading.vue'

export default {
  name: 'NewPostsBlock',

  components: {
    Post,
    ChevronRightIcon,
    PostModal,
    LoadingIcon
  },

  props: {
    block: {
      type: Object,
      required: true
    },
    team: {
      type: Object,
      required: true
    }
  },

  data () {
    return {
      loading: true,
      posts: [],
      selectedPost: null
    }
  },

  computed: {
    displayedPosts () {
      return this.posts.slice(0, 2)
    }
  },

  mounted () {
    this.fetchData()
  },

  methods: {
    async fetchData () {
      try {
        this.loading = true
        const response = await getTeamPosts(this.team.id, 1, 2)
        this.posts = response.data
        this.loading = false
        this.$nextTick(() => {
          this.$emit('block-loaded')
        })
      } catch (error) {
        this.$handleError(error)
        this.loading = false
        this.$emit('block-error')
      }
    },

    showPost (post) {
      this.selectedPost = post
    }
  }
}
</script>

<style scoped>
.block-container {
  @apply bg-white rounded-lg p-4 shadow-sm;
}

.line-clamp-2 {
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}
</style>
