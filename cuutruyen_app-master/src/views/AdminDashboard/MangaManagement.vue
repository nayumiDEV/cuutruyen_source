<template>
  <div>
    <CuuHeading>Quản lý truyện</CuuHeading>

    <template v-if="loading">
      <LoadingScreen />
    </template>

    <div v-else-if="mangas && mangas.length > 0">
      <div class="common-container flex justify-end mb-4">
        <!-- Optional: Add new manga button for admin -->
        <!-- <router-link :to="{ name: 'AdminMangaNew' }" class="button bg-blue-600 hover:bg-blue-700 text-white px-6 py-3">Thêm mới</router-link> -->
      </div>

      <div class="common-container mb-4 flex justify-end">
        <form class="flex gap-2" @submit.prevent="doSearch">
          <input class="input input-mini" type="text" placeholder="Nhập từ khóa..." v-model="searchKeyword">
          <button class="button button-mini button-subtle-primary px-3 py-0.5 whitespace-nowrap text-xs">Tìm kiếm</button>
        </form>
      </div>

      <div class="common-container overflow-y-auto shadow-lg rounded-lg">
        <table class="table overflow-hidden min-w-full bg-white">
          <tr class="text-center bg-gray-200 text-gray-600 uppercase text-sm font-semibold border-b-2 border-gray-300">
            <th class="text-right whitespace-nowrap">ID</th>
            <th class="text-left whitespace-nowrap">Tên truyện</th>
            <th class="text-left whitespace-nowrap">Số chương</th>
            <th class="text-left whitespace-nowrap">Nhóm dịch</th>
            <th class="text-left whitespace-nowrap">Ngày tạo</th>
            <th class="text-right whitespace-nowrap">Hành động</th>
          </tr>

          <tr v-for="manga in mangas" :key="manga.id" class="text-center border-b border-gray-200 text-gray-800 text-sm even:bg-gray-100 even:bg-opacity-50">
            <td class="text-right whitespace-nowrap">{{ manga.id }}</td>
            <td class="text-left">
              <div class="flex">
                <div class="hidden md:block flex-none">
                  <img v-if="manga.cover_url" :src="manga.cover_url" class="w-12 mr-4 object-cover rounded">
                  <img v-else-if="manga.cover_original_url" :src="manga.cover_original_url" class="w-12 mr-4 object-cover rounded">
                </div>
                <div>
                  <div class="font-semibold mb-0.5">
                    <router-link :to="{ name: 'Manga', params: { id: manga.id } }" target="_blank">
                      {{ manga.name }}
                    </router-link>
                  </div>
                  <div class="text-gray-600 text-xs">{{ manga.author ? manga.author.name : '' }}</div>
                  <div class="text-xs">
                    <router-link class="text-blue-600 hover:text-blue-700 fine-transition flex items-center gap-0.5" :to="{ name: 'Manga', params: { id: manga.id } }" target="_blank">
                      {{ `${baseUrl}/mangas/${manga.id}` }}
                      <OpenInNewIcon class="inline" :size="14" />
                    </router-link>
                  </div>
                </div>
              </div>
            </td>
            <td class="text-left whitespace-nowrap">{{ manga.chapters_count }}</td>
            <td class="text-left flex">
              <div class="flex items-center gap-2">
                <div class="avatar">
                  {{ manga.team.name[0] }}
                </div>

                <div class="cursor-pointer font-bold text-gray-700 block"><router-link :to="{ name: 'TeamMangaManagement', params: { teamId: manga.team.id } }">{{ manga.team.name }}</router-link></div>
              </div>
            </td>
            <td class="text-left whitespace-nowrap">{{ manga.created_at | humanizeTime }}</td>
            <td class="flex justify-end gap-1">
              <router-link :to="{ name: 'Manga', params: { id: manga.id } }" class="button button-mini button-normal px-2.5 py-1.5" target="_blank">
                Xem
              </router-link>
              <router-link :to="{ name: 'AdminMangaEdit', params: { id: manga.id } }" class="button button-mini button-normal px-2.5 py-1.5">
                Sửa truyện
              </router-link>
            </td>
          </tr>
        </table>
      </div>

      <CuuPaginate routeName="AdminMangaManagement" :currentPage="currentPage" :totalPages="totalPages" />
    </div>

    <EmptyScreen v-else message="Không tìm thấy truyện nào!">
      <!-- Optional: Add new manga button for admin -->
    </EmptyScreen>
  </div>
</template>

<script>
import { getAdminMangas } from '@/apis/admin'
import LoadingScreen from '@/components/LoadingScreen'
import EmptyScreen from '@/components/EmptyScreen'
import OpenInNewIcon from 'vue-material-design-icons/OpenInNew.vue'

export default {
  components: {
    LoadingScreen,
    EmptyScreen,
    OpenInNewIcon
  },
  data () {
    return {
      mangas: null,
      meta: null,
      loading: true,
      searchKeyword: '',
      baseUrl: process.env.VUE_APP_API_BASE_URL
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
    if (this.$route.query.q) {
      this.searchKeyword = this.$route.query.q
    }
    await this.loadMangas(this.currentPage, this.searchKeyword)
  },
  methods: {
    async loadMangas (page = 1, q = '') {
      this.loading = true
      try {
        const response = await getAdminMangas(q, page)
        console.log(response)
        this.mangas = response.data
        this.meta = response._metadata
      } catch (error) {
        this.$handleError(error)
      } finally {
        this.loading = false
      }
    },
    doSearch () {
      this.$router.push({ name: 'AdminMangaManagement', query: { q: this.searchKeyword } })
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
