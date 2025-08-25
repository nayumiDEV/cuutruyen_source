<template>
  <div>
    <CuuHeading>Quản lý nhóm dịch</CuuHeading>

    <template v-if="loading">
      <LoadingScreen />
    </template>

    <div v-else-if="teams && teams.length > 0">
      <div class="common-container flex justify-end mb-4">
        <router-link :to="{ name: 'AdminTeamNew' }" class="button bg-blue-600 hover:bg-blue-700 text-white px-6 py-3">Thêm mới</router-link>
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
            <th class="text-left whitespace-nowrap">Tên nhóm</th>
            <th class="text-left whitespace-nowrap">Số truyện</th>
            <th class="text-left whitespace-nowrap">Lượt xem</th>
            <th class="whitespace-nowrap">Tạo lúc</th>
            <th class="text-right whitespace-nowrap">Hành động</th>
          </tr>

          <tr v-for="team in teams" :key="team.id" class="text-center border-b border-gray-200 text-gray-800 text-sm even:bg-gray-100 even:bg-opacity-50">
            <td class="text-right whitespace-nowrap">{{ team.id }}</td>
            <td class="text-left flex">
              <div class="flex items-center gap-2">
                <div class="avatar">
                  {{ team.name[0] }}
                </div>

                <div class="cursor-pointer font-bold text-gray-700 block"><router-link :to="{ name: 'TeamMangaManagement', params: { teamId: team.id } }">{{ team.name }}</router-link></div>
              </div>
            </td>
            <td class="whitespace-nowrap">{{ team.translations_count }}</td>
            <td class="whitespace-nowrap">{{ team.views_count }}</td>
            <td class="whitespace-nowrap">{{ team.created_at | humanizeTime }}</td>
            <td class="text-right">
              <router-link :to="{ name: 'TeamMangaManagement', params: { teamId: team.id } }" class="button button-mini button-normal px-2.5 py-1.5">Quản lý</router-link>
            </td>
          </tr>
        </table>
      </div>

      <CuuPaginate routeName="AdminTeamManagement" :currentPage="currentPage" :totalPages="totalPages" />
    </div>

    <EmptyScreen v-else message="Không tìm thấy nhóm dịch nào!">
      <router-link :to="{ name: 'AdminTeamNew' }" class="button block bg-blue-600 hover:bg-blue-700 text-white px-8 py-4">Thêm nhóm mới</router-link>
    </EmptyScreen>
  </div>
</template>

<script>
import { getAdminTeams } from '@/apis/admin'

export default {
  data () {
    return {
      teams: null,
      meta: null,
      loading: true,
      searchKeyword: ''
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

    if (this.$route.query.q) {
      this.searchKeyword = this.$route.query.q
    }

    await this.loadTeams(this.currentPage, this.searchKeyword)
  },

  methods: {
    async loadTeams (page = 1, q = '') {
      this.loading = true
      try {
        const response = await getAdminTeams(q, this.currentPage)
        this.teams = response.data
        this.meta = response._metadata
      } catch (error) {
        this.$handleError(error)
      } finally {
        this.loading = false
        this.releaseBodyScroll()
      }
    },

    doSearch () {
      this.$router.push({ name: 'AdminTeamManagement', query: { q: this.searchKeyword } })
    }
  },

  beforeRouteUpdate (to, from, next) {
    if (to.query.page !== from.query.page) {
      this.loadTeams(to.query.page)
    }
    next()
  },

  beforeDestroy () {
    this.releaseBodyScroll()
  }
}
</script>
