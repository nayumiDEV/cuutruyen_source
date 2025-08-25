<template>
  <div class="mx-2 py-8 lg:py-16">
    <CuuHeading>Mới cập nhật</CuuHeading>

    <div class="common-container">
      <div v-if="loading" class="h-screen flex justify-center items-center">
        <span class="spin">
          <LoadingIcon :size="64" class="text-gray-500" />
        </span>
      </div>

      <div v-else-if="mangas" class="grid grid-cols-3 sm:grid-cols-4 lg:grid-cols-6 gap-2 md:gap-4">
        <div v-for="manga in mangas" :key="manga.id">
          <MangaItem :manga="manga" />
        </div>
      </div>

      <EmptyScreen v-else message="Chưa có truyện nào được đăng lên đây. Nếu bạn là tác giả/nhóm dịch, hãy đăng ký tài khoản và đăng truyện ngay!"></EmptyScreen>
    </div>

    <CuuPaginate routeName="Newest" :currentPage="currentPage" :totalPages="totalPages" />
  </div>
</template>

<script>
import { recentlyUpdated } from '@/apis/user'
import LoadingIcon from 'vue-material-design-icons/Loading.vue'
import MangaItem from '@/components/MangaItem'

export default {
  name: 'Newest',

  metaInfo: {
    title: 'Mới cập nhật'
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
    this.$gtag.pageview({ page_title: 'Mới cập nhật' })
    this.loadMangas(this.currentPage)
    this.lockBodyScroll()
  },

  methods: {
    async loadMangas (page) {
      this.loading = true
      try {
        const response = await recentlyUpdated(page, 30)
        this.mangas = response.data
        this.meta = response._metadata
      } catch (error) {
        this.error = true

        this.$handleError(error)
      } finally {
        this.loading = false
        this.releaseBodyScroll()
      }
    }
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
