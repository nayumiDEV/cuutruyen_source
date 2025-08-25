<template>
  <div class="relative"
  >
    <button class="button-circle px-4 py-2 h-11 w-11 flex justify-center items-center uppercase"
      @click.prevent="userDropdown = !userDropdown"
      :class="{
        'button-transparent-light': theme == 'light',
        'button-transparent-dark': theme != 'light'
        }"
    >
      <template v-if="currentUser">
        {{ currentUser.username[0] }}
      </template>

      <template v-else>
        <MenuIcon :size="16" />
      </template>
    </button>

    <div
      class="bg-white absolute shadow-lg rounded-lg mt-2 right-0 overflow-hidden flex flex-col whitespace-nowrap text-gray-800 z-10"
      v-if="userDropdown"
      v-click-outside="closeUserDropdown"
      ref="dropdownContainer"
    >
      <template v-if="currentUser">
        <div class="px-4 py-2">
          <div class="uppercase text-xs font-bold text-gray-500">Đã đăng nhập là:</div>
          <div class="font-bold">{{ currentUser.username }}</div>
        </div>

        <div class="border-b border-gray-300"></div>

        <template v-if="currentUser.teams.length > 0">
          <router-link
            v-for="team in currentUser.teams"
            :key="team.id"
            :to="{ name: 'TeamMangaManagement', params: { teamId: team.id } }"
            class="px-4 py-2 hover:bg-gray-200"
          >Quản lý nhóm <strong>{{ team.name }}</strong></router-link>
          <div class="border-b border-gray-300"></div>
        </template>

        <router-link :to="{ name: 'Following' }" class="px-4 py-2 hover:bg-gray-200 cursor-pointer">Danh sách theo dõi</router-link>
        <router-link :to="{ name: 'History' }" class="px-4 py-2 hover:bg-gray-200 cursor-pointer">Lịch sử đọc truyện</router-link>
        <router-link :to="{ name: 'Configuration' }" class="px-4 py-2 hover:bg-gray-200 cursor-pointer">Thiết lập</router-link>

        <template v-if="currentUser.level === 'admin'">
          <router-link
            :to="{ name: 'AdminUserManagement' }"
            class="px-4 py-2 hover:bg-gray-200"
          >Bảng điều khiển cho admin</router-link>
          <div class="border-b border-gray-300"></div>
        </template>

        <a @click.prevent="logout" class="px-4 py-2 hover:bg-gray-200 cursor-pointer">Đăng xuất</a>
      </template>

      <template v-else>
        <router-link :to="{ name: 'Login' }"
          class="px-4 py-2 hover:bg-gray-200"
        >Đăng nhập</router-link>
        <router-link :to="{ name: 'Register' }"
          class="px-4 py-2 hover:bg-gray-200"
        >Đăng ký</router-link>
      </template>

      <div class="border-b border-gray-300"></div>

      <router-link class="px-4 py-2 hover:bg-gray-200" :to="{ name: 'SavedOffline' }">Truyện đã tải xuống</router-link>

      <div class="lg:hidden flex flex-col">
        <div class="border-b border-gray-300"></div>

        <a href="https://www.facebook.com/CuuTruyenTranh/" target="_blank" rel="noopener noreferrer" class="px-4 py-2 hover:bg-gray-200">Fanpage</a>
        <a href="https://www.facebook.com/groups/cuutruyen2vn" target="_blank" rel="noopener noreferrer" class="px-4 py-2 hover:bg-gray-200">Hội kín</a>
        <a href="https://m.me/cuutruyentranh" target="_blank" rel="noopener noreferrer" class="px-4 py-2 hover:bg-gray-200">Đăng truyện</a>
        <router-link :to="{ name: 'Donate' }" class="px-4 py-2 hover:bg-gray-200">Ủng hộ</router-link>
      </div>
    </div>
  </div>
</template>

<script>
import vClickOutside from 'v-click-outside'
import MenuIcon from 'vue-material-design-icons/Menu.vue'

export default {
  directives: {
    clickOutside: vClickOutside.directive
  },

  components: {
    MenuIcon
  },

  props: {
    currentUser: Object,
    theme: String
  },

  data () {
    return {
      userDropdown: false
    }
  },

  methods: {
    closeUserDropdown () {
      this.userDropdown = false
    },

    async logout () {
      this.$store.dispatch('cleanCurrentUser')
      if (this.$route.name !== 'Home') {
        this.$router.push('/')
      }
    }
  },

  mounted () {
    this.$nextTick(() => {
      this.$el.addEventListener('click', () => {
        if (event.target.tagName === 'A') {
          this.userDropdown = false
        }
      })
    })
  },

  deactivated () {
    this.closeUserDropdown()
  }
}
</script>
