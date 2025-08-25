<template>
  <div>
    <CuuHeading>Quản lý người dùng</CuuHeading>

    <template v-if="loading">
      <LoadingScreen />
    </template>

    <div v-else-if="users && users.length > 0">
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
            <th class="text-left whitespace-nowrap">Tên đăng nhập</th>
            <th class="text-left whitespace-nowrap">Email</th>
            <th class="text-left whitespace-nowrap">Ngày đăng ký</th>
            <th class="text-center whitespace-nowrap w-18">Trạng thái</th>
            <th class="text-right whitespace-nowrap">Hành động</th>
          </tr>

          <tr v-for="user in users" :key="user.id" class="text-center border-b border-gray-200 text-gray-800 text-sm even:bg-gray-100 even:bg-opacity-50">
            <td class="text-right whitespace-nowrap">{{ user.id }}</td>
            <td class="text-left whitespace-nowrap font-bold">
              <div class="flex items-center gap-2">
                <div class="avatar">
                  {{ user.username[0] }}
                </div>
                <div v-if="user.user_ban" class=" line-through text-gray-500">{{ user.username }}</div>
                <div v-else>{{ user.username }}</div>
              </div>
            </td>
            <td class="text-left whitespace-nowrap">
              <div v-if="user.user_ban" class=" line-through text-gray-500">{{ user.email }}</div>
              <div v-else>{{ user.email }}</div>
            </td>
            <td class="text-left whitespace-nowrap">{{ user.created_at | humanizeTime }}</td>
            <td class="text-center w-18 whitespace-nowrap">
              <div v-if="user.user_ban">
                <div class="text-red-700 font-bold">
                  <span v-if="user.user_ban.ban_type === 'mute'">
                    Mute
                  </span>
                  <span v-else-if="user.user_ban.ban_type === 'ban'">
                    Ban
                  </span>
                  <span v-else>
                    Shadow Ban
                  </span>
                </div>
                <!--
                  <div v-if="user.user_ban.banned_until">Hết hạn vào {{ user.user_ban.banned_until | humanizeTime }}</div>
                  <div v-else>Vô thời hạn</div>
                -->
              </div>
            </td>
            <td class="flex justify-end gap-1">
              <router-link to="#" class="button button-mini button-normal px-2.5 py-1.5">Quản lý</router-link>
              <button v-if="!user.user_ban" @click.prevent="banningUser = user" type="button" class="button button-mini button-danger w-20 px-2.5 py-1.5">Ban</button>
              <button v-else @click.prevent="unbanningUser = user" type="button" class="button button-mini button-warning w-20 px-2.5 py-1.5">Gỡ ban</button>
            </td>
          </tr>
        </table>
      </div>

      <CuuPaginate routeName="AdminUserManagement" :currentPage="currentPage" :totalPages="totalPages" />
    </div>

    <UserBanModal :user="banningUser" @confirm="reloadCurrentList" @cancel="banningUser = null" />
    <UserUnbanModal :user="unbanningUser" @confirm="reloadCurrentList" @cancel="unbanningUser = null" />
  </div>
</template>

<script>
import { getAdminUsers } from '@/apis/admin'
import UserBanModal from '@/components/admin-dashboard/UserBanModal'
import UserUnbanModal from '@/components/admin-dashboard/UserUnbanModal'

export default {
  components: {
    UserBanModal,
    UserUnbanModal
  },

  data () {
    return {
      users: null,
      meta: null,
      loading: true,
      banningUser: null,
      unbanningUser: null,
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

    await this.loadUsers(this.currentPage, this.searchKeyword)
  },

  methods: {
    async loadUsers (page = 1, q = '') {
      this.loading = true
      try {
        const response = await getAdminUsers(q, this.currentPage)
        this.users = response.data
        this.meta = response._metadata
      } catch (error) {
        this.$handleError(error)
      } finally {
        this.loading = false
        this.releaseBodyScroll()
      }
    },

    async reloadCurrentList () {
      await this.loadUsers(this.currentPage, this.searchKeyword)
    },

    doSearch () {
      this.$router.push({ name: 'AdminUserManagement', query: { q: this.searchKeyword } })
    }
  },

  beforeRouteUpdate (to, from, next) {
    if (to.query.page !== from.query.page) {
      this.loadUsers(to.query.page)
    }
    next()
  },

  beforeDestroy () {
    this.releaseBodyScroll()
  }
}
</script>
