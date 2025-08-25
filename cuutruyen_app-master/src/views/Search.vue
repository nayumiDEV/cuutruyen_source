<template>
  <div class="mx-2 py-8 lg:py-16">
    <template v-if="loading">
      <LoadingScreen />
    </template>

    <template v-else-if="error">
      <ErrorScreen />
    </template>

    <template v-else>
      <CuuHeading>Tìm với từ khóa <strong>{{ $route.params.keyword }}</strong> ({{ meta.total_count }} kết quả)</CuuHeading>

      <div class="common-container">
        <div v-if="mangas && mangas.length > 0" class="grid grid-cols-3 sm:grid-cols-4 lg:grid-cols-6 gap-3 xl:gap-5">
          <div v-for="manga in mangas" :key="manga.id">
            <MangaItem :manga="manga" />
          </div>
        </div>

        <EmptyScreen v-else message="Không tìm thấy truyện nào với từ khóa này!"></EmptyScreen>
      </div>

      <CuuPaginate routeName="Search" :currentPage="currentPage" :totalPages="totalPages" />
    </template>
  </div>
</template>

<script>
import { search } from '@/apis/user'
import MangaItem from '@/components/search/MangaItem'

export default {
  name: 'Search',

  metaInfo: {
    title: 'Tìm kiếm'
  },

  components: {
    MangaItem
  },

  data () {
    return {
      mangas: null,
      meta: null,
      loading: true,
      error: false
    }
  },

  computed: {
    currentPage () {
      if (this.$route.query.page) {
        return this.$route.query.page
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
    this.lockBodyScroll()
    await this.loadMangas(this.$route.params.keyword, this.currentPage)
  },

  methods: {
    async loadMangas (keyword, page) {
      this.loading = true
      try {
        const response = await search(keyword, page)
        this.mangas = response.data
        this.meta = response._metadata
      } catch (error) {
        this.error = true
        throw error
      } finally {
        this.loading = false
        this.releaseBodyScroll()
      }
    }
  },

  beforeRouteUpdate (to, from, next) {
    if (to.query.page !== from.query.page) {
      this.loadMangas(to.query.page)
    }
    next()
  },

  beforeDestroy () {
    this.releaseBodyScroll()
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

.button-active {
  @apply bg-blue-700 text-white;
}

.button-active:hover {
  @apply bg-blue-800;
}
</style>
