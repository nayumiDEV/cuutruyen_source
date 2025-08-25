<template>
  <div v-if="!loading" class="mx-2 py-8 lg:py-16">
    <CuuHeading>{{ tag.name }}</CuuHeading>

    <div class="common-container">
      <div v-if="mangas" class="grid grid-cols-3 sm:grid-cols-4 lg:grid-cols-6 gap-2 md:gap-4">
        <div v-for="manga in mangas" :key="manga.id">
          <MangaItem :manga="manga" />
        </div>
      </div>

      <EmptyScreen v-else message="Chưa có truyện nào được đăng lên đây. Nếu bạn là tác giả/nhóm dịch, hãy đăng ký tài khoản và đăng truyện ngay!"></EmptyScreen>
    </div>

    <CuuPaginate routeName="Tag" :currentPage="currentPage" :totalPages="totalPages" />
  </div>

  <LoadingScreen v-else />
</template>

<script>
import { getTag } from '@/apis/user'
import MangaItem from '@/components/MangaItem'

export default {
  name: 'Tag',

  metaInfo () {
    if (!this.tag) {
      return {}
    }

    return {
      title: this.tag.name,
      meta: [
        { vmid: 'description', name: 'description', content: `Truyện với thể loại ${this.tag.name}, được gắn thẻ ${this.tag.name} hay nhất ở Cứu Truyện` }
      ]
    }
  },

  components: {
    MangaItem
  },

  data () {
    return {
      tag: null,
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
    this.lockBodyScroll()
    this.loadMangas(this.currentPage)
  },

  methods: {
    async loadMangas (page) {
      this.loading = true
      try {
        const response = await getTag(this.$route.params.slug, page, 30)
        this.tag = response.data.tag
        this.mangas = response.data.mangas
        this.meta = response._metadata
        this.$gtag.config({
          send_page_view: false
        })
        this.$gtag.pageview({ page_title: this.tag.name })
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
