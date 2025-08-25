<template>
  <div v-if="loading">
    <LoadingScreen />
  </div>

  <div v-else-if="team">
    <CuuHeading>Quản lý truyện</CuuHeading>
    <div v-if="(mangas && mangas.length > 0) || $route.query.q">
      <div class="common-container flex justify-end mb-12">
        <router-link :to="{ name: 'TeamMangaNew', params: { teamId: team.id } }" class="button button-primary px-6 py-3">Thêm mới</router-link>
      </div>

      <div class="common-container mb-4 flex justify-end">
        <form class="flex gap-2" @submit.prevent="doSearch">
          <input class="input input-mini" type="text" placeholder="Nhập từ khóa..." v-model="searchKeyword">
          <button class="button button-mini button-subtle-primary px-3 py-0.5 whitespace-nowrap text-xs">Tìm truyện</button>
        </form>
      </div>

      <div class="common-container overflow-y-auto shadow-lg rounded-lg">
        <table class="table overflow-hidden min-w-full bg-white">
          <thead>
            <tr class="text-center bg-gray-200 text-sm text-gray-600 uppercase font-semibold border-b-2 border-gray-300">
              <th class="text-right">#</th>
              <th class="text-left whitespace-nowrap">Tên truyện</th>
              <th class="text-right">Số chương</th>
              <th class="whitespace-nowrap">Tạo lúc</th>
              <th class="whitespace-nowrap">Chương mới lúc</th>
              <th class="text-right">Hành động</th>
            </tr>
          </thead>

          <tbody v-if="mangas && mangas.length > 0">
            <tr v-for="(manga, index) in mangas" :key="manga.id" class="text-center border-b border-gray-200 text-gray-800 even:bg-gray-100 even:bg-opacity-50 fine-transition">
              <td class="text-right">{{ meta.per_page * (meta.current_page - 1) + index + 1 }}</td>
              <td class="text-left flex">
                <div class="hidden md:block flex-none">
                  <img v-if="manga.cover_url" :src="manga.cover_url" class="w-12 mr-4 object-cover rounded">
                  <img v-else-if="manga.cover_original_url" :src="manga.cover_original_url" class="w-12 mr-4 object-cover rounded">
                </div>
                <div>
                  <div class="font-semibold mb-0.5">
                    <router-link :to="{ name: 'TeamChapterManagement', params: { mangaId: manga.id } }">
                      {{ manga.name }}
                    </router-link>
                  </div>
                  <div class="text-gray-600 text-xs mb-1.5">{{ manga.author.name }}</div>
                  <div class="text-xs">
                    <router-link class="text-blue-600 hover:text-blue-700 fine-transition flex items-center gap-0.5" :to="{ name: 'Manga', params: { id: manga.id } }" target="_blank">
                      {{ `${baseUrl}/mangas/${manga.id}` }}
                      <OpenInNewIcon class="inline" :size="14" />
                    </router-link>
                  </div>
                </div>
              </td>
              <td class="text-right text-sm">{{ manga.chapters_count }}</td>
              <td class="whitespace-nowrap text-sm">{{ manga.created_at | humanizeTime }}</td>
              <td class="whitespace-nowrap text-sm">{{ manga.newest_chapter_created_at | humanizeTime }}</td>
              <td class="text-right">
                <div class="flex justify-end gap-1">
                  <router-link :to="{ name: 'TeamChapterManagement', params: { teamId: team.id, mangaId: manga.id } }" class="button button-mini button-normal px-2.5 py-1.5">QL Chương</router-link>
                  <router-link :to="{ name: 'TeamMangaEdit', params: { teamId: team.id, mangaId: manga.id } }" class="button button-mini button-normal px-2.5 py-1.5">Sửa truyện</router-link>
                  <button type="button" @click.prevent="deletingManga = manga" class="button button-mini button-danger px-2.5 py-1.5">Gỡ bỏ</button>
                </div>
              </td>
            </tr>
          </tbody>

          <tbody v-else>
            <td colspan="6" class="text-center text-gray-600 text-sm"><div class="px-2 py-8">Không tìm thấy truyện nào phù hợp với từ khóa tìm kiếm của bạn</div></td>
          </tbody>
        </table>
      </div>

      <CuuPaginate routeName="TeamMangaManagement" :routeParams="{ teamId: team.id }" :routeQuery="{ q: $route.query.q }" :currentPage="currentPage" :totalPages="totalPages" />
    </div>

    <EmptyScreen v-else message="Nhóm của bạn chưa thêm hay quản lý truyện nào.">
      <router-link :to="{ name: 'TeamMangaNew', params: { teamId: team.id } }" class="button block bg-blue-600 hover:bg-blue-700 text-white px-8 py-4">Thêm truyện mới</router-link>
    </EmptyScreen>

    <MangaDeleteModal :manga="deletingManga" @cancel="deletingManga = null" @confirm="removeManga(deletingManga)" />
  </div>
</template>

<script>
import { getTeamMangas, deleteTeamManga } from '@/apis/team'
import MangaDeleteModal from '@/components/team-management/MangaDeleteModal'
import OpenInNewIcon from 'vue-material-design-icons/OpenInNew.vue'

export default {
  components: {
    MangaDeleteModal,
    OpenInNewIcon
  },

  props: {
    layoutProps: {
      type: Object,
      default: null
    }
  },

  data () {
    return {
      mangas: null,
      deletingManga: null,
      meta: null,
      loading: false,
      searchKeyword: '',
      baseUrl: process.env.VUE_APP_API_BASE_URL
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
    if (this.$route.query.q) {
      this.searchKeyword = this.$route.query.q
    }

    this.loadMangas(this.currentPage, this.searchKeyword)
  },

  methods: {
    async loadMangas (page = 1, q = '') {
      this.loading = true
      try {
        const response = await getTeamMangas(this.team.id, q, page, 20)
        this.mangas = response.data
        this.meta = response._metadata
      } catch (error) {
        this.$handleError(error)
      } finally {
        if (q) {
          this.searchKeyword = q
        }
        this.loading = false
      }
    },

    doSearch () {
      this.$router.push({ name: 'TeamMangaManagement', params: { teamId: this.team.id }, query: { q: this.searchKeyword } })
    },

    async removeManga (manga) {
      try {
        await deleteTeamManga(this.team.id, manga.id)

        this.$notify({
          type: 'success',
          text: 'Xóa truyện thành công!'
        })

        this.loadMangas(this.currentPage, this.$route.query.q)
      } catch (error) {
        this.$notify({
          type: 'error',
          text: 'Có lỗi xảy ra khi xóa truyện.'
        })

        throw error
      }
    }
  },

  watch: {
    team (to, from) {
      if (to !== from) {
        this.loadMangas()
      }
    }
  }
}
</script>
