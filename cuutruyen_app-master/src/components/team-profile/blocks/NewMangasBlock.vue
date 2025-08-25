<template>
  <div class="py-14 lg:py-20 px-2">
    <CuuHeading v-if="block.title">{{ block.title }}</CuuHeading>

    <div class="common-container">
      <div v-if="loading" class="h-[300px] flex justify-center items-center">
        <span class="spin">
          <LoadingIcon :size="64" class="text-gray-500" />
        </span>
      </div>

      <div v-else-if="mangas.length === 0" class="text-gray-500 py-16 md:py-24 flex items-center justify-center">
        Không có truyện mới nào.
      </div>

      <div v-else>
        <div class="mb-4 lg:mb-6 grid grid-row-1 overflow-hidden grid-cols-3 sm:grid-cols-4 lg:grid-cols-6 gap-2 md:gap-4">
          <div v-for="manga in displayedMangas" :key="manga.id">
            <MangaItem :manga="manga" />
          </div>
        </div>

        <div class="flex justify-end">
          <router-link :to="{ name: 'TeamProfileMangasNew', params: { teamId: team.slug } }" class="cursor-pointer flex items-center text-gray-600 hover:text-blue-600 transition text-sm font-bold">
            <ChevronRightIcon mr-1 :size="16" />
            <span>Xem danh sách truyện</span>
          </router-link>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { getTeamMangasNew } from '@/apis/user'
import MangaItem from '@/components/MangaItem'
import ChevronRightIcon from 'vue-material-design-icons/ChevronRight.vue'
import LoadingIcon from 'vue-material-design-icons/Loading.vue'

export default {
  name: 'NewMangasBlock',

  components: {
    MangaItem,
    ChevronRightIcon,
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
      mangas: [],
      windowWidth: window.innerWidth
    }
  },

  mounted () {
    this.loadNewMangas()
    window.addEventListener('resize', this.handleResize)
    this.handleResize()
  },

  beforeDestroy () {
    window.removeEventListener('resize', this.handleResize)
  },

  computed: {
    displayedMangas () {
      let count = 3
      if (this.windowWidth >= 640 && this.windowWidth < 1024) {
        count = 4
      } else if (this.windowWidth >= 1024) {
        count = 6
      }
      return this.mangas.slice(0, count)
    }
  },

  methods: {
    handleResize () {
      this.windowWidth = window.innerWidth
    },

    async loadNewMangas () {
      try {
        this.loading = true
        const response = await getTeamMangasNew(this.team.id, 1, 12)
        this.mangas = response.data
        this.loading = false
        this.$nextTick(() => {
          this.$emit('block-loaded')
        })
      } catch (error) {
        this.$handleError(error)
        this.loading = false
        this.$emit('block-error')
      }
    }
  }
}
</script>
