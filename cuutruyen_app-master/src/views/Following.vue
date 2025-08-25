<template>
  <div class="mx-2 py-8 lg:py-16">
    <CuuHeading>Đang theo dõi</CuuHeading>

    <div class="common-container">
      <div v-if="loading" class="h-screen flex justify-center items-center">
        <span class="spin">
          <LoadingIcon :size="64" class="text-gray-500" />
        </span>
      </div>

      <div v-else-if="mangas && mangas.length > 0">
        <div class="grid grid-cols-3 sm:grid-cols-4 lg:grid-cols-6 gap-3 xl:gap-5">
          <div v-for="manga in mangas" :key="manga.id">
            <MangaItem :manga="manga" @unfollow="unfollowManga(manga)" />
          </div>
        </div>

        <CuuPaginate routeName="Following" :currentPage="currentPage" :totalPages="totalPages" />
      </div>

      <EmptyScreen v-else message="Chưa có truyện nào được bạn theo dõi!"></EmptyScreen>
    </div>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
import { following, goUnfollow } from '@/apis/user'
import LoadingIcon from 'vue-material-design-icons/Loading.vue'
import MangaItem from '@/components/following/MangaItem'

export default {
  metaInfo: {
    title: 'Đang theo dõi'
  },

  components: {
    MangaItem,
    LoadingIcon
  },

  data () {
    return {
      mangas: [],
      meta: {},
      loading: false,
      error: false
    }
  },

  computed: {
    ...mapGetters([
      'currentUser'
    ]),

    currentPage () {
      if (this.$route.query.page) {
        return Number(this.$route.query.page)
      } else {
        return 1
      }
    },

    totalPages () {
      if (this.meta) {
        return this.meta.total_pages
      } else {
        return 1
      }
    }
  },

  async mounted () {
    this.$gtag.config({
      send_page_view: false
    })
    this.$gtag.pageview({ page_title: 'Đang theo dõi' })
    this.loadMangas(this.currentPage)
  },

  methods: {
    async loadMangas (page) {
      this.loading = true
      try {
        const response = await following(page)
        this.mangas = response.data
        this.meta = response._metadata
      } catch (error) {
        this.error = true

        this.$handleError(error)
      } finally {
        this.loading = false
      }
    },

    async unfollowManga (manga) {
      try {
        await goUnfollow(manga.id)

        this.$notify({
          type: 'success',
          text: 'Đã hủy theo dõi truyện thành công!'
        })

        this.loadMangas(this.currentPage)
      } catch (error) {
        if (error.message) {
          this.$notify({
            type: 'error',
            text: `Có lỗi xảy ra khi hủy theo dõi truyện: ${error.message}`
          })
        } else {
          this.$notify({
            type: 'error',
            text: 'Có lỗi không rõ nguyện nhân khi hủy theo dõi truyện'
          })
        }
        throw error
      }
    }
  },

  beforeRouteUpdate (to, from, next) {
    if (to.query.page !== from.query.page) {
      this.loadMangas(to.query.page)
    }
    next()
  }
}
</script>

<style scoped>
.bg-dominant-fade {
  background-repeat: no-repeat;
  background-position: bottom;
  background-size:auto 50%;
}

.cover-img:hover {
  filter: brightness(0.3);
}
</style>
