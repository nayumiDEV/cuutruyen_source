<template>
  <div class="mx-2 py-8 lg:py-16">
    <CuuHeading>Truyện nổi bật</CuuHeading>

    <div class="common-container">
      <div class="flex justify-end py-8">
        <div class="rounded-full flex bg-gray-100">
          <button class="time-range-tab-item" :class="{'active': viewsCountType === 'week'}" @click="viewsCountType = 'week'">Tuần</button>
          <button class="time-range-tab-item" :class="{'active': viewsCountType === 'month'}" @click="viewsCountType = 'month'">Tháng</button>
          <button class="time-range-tab-item" :class="{'active': viewsCountType === 'all'}" @click="viewsCountType = 'all'">Mọi lúc</button>
        </div>
      </div>

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

      <EmptyScreen v-else message="Chưa có truyện nào được đăng lên đây!"></EmptyScreen>
    </div>

    <CuuPaginate routeName="TeamProfileMangasTop" :currentPage="currentPage" :totalPages="totalPages" />
  </div>
</template>

<script>
import { getTeamMangasTop } from '@/apis/user'
import LoadingIcon from 'vue-material-design-icons/Loading.vue'
import MangaItem from '@/components/MangaItem'

export default {
  name: 'TeamProfileMangasTop',

  metaInfo () {
    return {
      title: `Truyện nổi bật - ${this.team.name}`
    }
  },

  components: {
    MangaItem,
    LoadingIcon
  },

  props: {
    layoutProps: {
      type: Object,
      required: true
    }
  },

  data () {
    return {
      mangas: [],
      meta: {},
      loading: false,
      error: false,
      viewsCountType: 'week'
    }
  },

  computed: {
    team () {
      return this.layoutProps.team
    },

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
    this.$gtag.pageview({ page_title: `Truyện nổi bật - ${this.team.name}` })
    this.loadMangas(this.currentPage)
    this.lockBodyScroll()
  },

  methods: {
    async loadMangas (page) {
      this.loading = true
      try {
        const response = await getTeamMangasTop(this.team.id, this.viewsCountType, page, 30)
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
  },

  watch: {
    viewsCountType (to, from) {
      if (to !== from) {
        this.loadMangas(this.currentPage)
      }
    }
  }
}
</script>

<style scoped>
.time-range-tab-item {
  @apply rounded-full py-1 md:py-2 m-1 w-20 md:w-24 flex justify-center items-center text-gray-700 uppercase text-xs font-bold transition hover:bg-gray-200;
}

.time-range-tab-item.active {
  @apply bg-blue-700 hover:bg-blue-600 text-blue-100;
}
</style>
