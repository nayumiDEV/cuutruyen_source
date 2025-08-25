<template>
  <div class="bg-gray-300 min-h-screen flex flex-col relative">
    <template v-if="isLoading">
      <LoadingScreen />
    </template>

    <template v-else>
      <intersect @enter="isTop = true" @leave="isTop = false" :threshold="[0]">
        <div class="absolute top-0 left-0 w-5 h-5"></div>
      </intersect>
      <NavBar class="top-0 left-0 w-full fixed" :class="{ 'fine-shadow': !isTransparent }" :theme="'light'"
        :glassy="!isTransparent" :noBg="isTop" />

      <div class="flex flex-col min-h-screen">
        <div>
          <div v-if="team" class="bg-gray-200 pt-20 flex flex-col items-center justify-center gap-4 shadow">
            <Avatar
              :image-url="team.avatar_url"
              :name="team.name"
              size="large"
            />

            <div class="text-gray-700 text-lg font-bold">
              {{ team.name }}
            </div>

            <div class="flex" v-if="team.facebook_address">
              <div class="h-3/4 border-r border-gray-400 mx-1"></div>
              <a
                class="text-blue-700 hover:text-white hover:bg-blue-700 block transition rounded-lg text-sm flex items-center py-1 px-2 mr-1 bg-gray-50"
                :href="`https://fb.com/${team.facebook_address}`"
                target="_blank"
                rel="noopener noreferrer"
              >
                <FacebookIcon class="mr-0.5" :size="24" />
                <span class="text-xs font-bold hidden lg:inline">fb.com/{{ team.facebook_address }}</span>
              </a>
              <a
                class="text-blue-700 hover:text-white hover:bg-blue-700 block transition rounded-lg text-sm py-1 px-2 bg-gray-50"
                :href="`https://m.me/${team.facebook_address}`"
                target="_blank"
                rel="noopener noreferrer"
              >
                <FacebookMessengerIcon class="" :size="24" />
              </a>
            </div>

            <!-- Tab Bar -->
            <div class="mt-4 w-full">
              <div class="mx-auto flex justify-center overflow-x-auto">
                <router-link
                  v-for="(tab, index) in tabs"
                  :key="index"
                  class="text-xs font-bold uppercase px-2 md:px-4 py-2 border-b-2 transition-colors text-center"
                  :class="{
                    'text-blue-600 font-bold border-blue-600': $route.name === tab.routeName,
                    'text-gray-500 border-transparent': $route.name !== tab.routeName
                  }"
                  :to="{ name: tab.routeName }"
                >
                  {{ tab.name }}
                </router-link>
              </div>
            </div>

            <div
              v-if="currentUser && currentUser.teams.map(t => Number(t.id)).includes(team.id)"
              class="absolute top-0 left-1/2 -translate-x-1/2 w-full pt-20 max-w-[1280px] mx-auto flex justify-end"
            >
              <router-link
                :to="{ name: 'TeamPageManagement', params: { teamId: team.id } }"
                class="rounded-full px-3 py-1 bg-gray-100 text-gray-800 hover:bg-gray-300 transition-colors text-xs uppercase flex items-center gap-1 block"
              >
                <PencilIcon :size="16" />
                Sửa trang nhóm
              </router-link>
            </div>
          </div>

          <slot :team="team" v-if="team" />
        </div>
      </div>

      <AppFooter />
    </template>
  </div>
</template>

<script>
import AppFooter from '@/components/layout/AppFooter'
import Intersect from 'vue-intersect'
import NavBar from '@/components/layout/default/NavBar'
import { getTeamBySlug, getTeam } from '@/apis/user'
import FacebookIcon from 'vue-material-design-icons/Facebook'
import FacebookMessengerIcon from 'vue-material-design-icons/FacebookMessenger'
import PencilIcon from 'vue-material-design-icons/Pencil.vue'
import Avatar from '@/components/common/Avatar'
import { mapGetters } from 'vuex'

export default {
  name: 'LayoutDefault',

  components: {
    AppFooter,
    Intersect,
    NavBar,
    FacebookIcon,
    FacebookMessengerIcon,
    Avatar,
    PencilIcon
  },

  data () {
    return {
      team: null,
      isTop: true,
      isLoading: true,
      tabs: [
        { name: 'trang chính', routeName: 'TeamProfile' },
        { name: 'bài viết', routeName: 'TeamProfilePosts' },
        { name: 'truyện mới', routeName: 'TeamProfileMangasNew' },
        { name: 'truyện nổi bật', routeName: 'TeamProfileMangasTop' }
      ]
    }
  },

  computed: {
    ...mapGetters([
      'currentUser'
    ]),

    isTransparent () {
      return this.isTop
    }
  },

  async created () {
    this.isLoading = true
    try {
      if (this.$route.params.teamSlug.startsWith('+')) {
        const teamId = this.$route.params.teamSlug.slice(1)
        const response = await getTeam(teamId)
        this.team = response.data
      } else {
        const response = await getTeamBySlug(this.$route.params.teamSlug)
        this.team = response.data
      }
    } catch (error) {
      this.$handleError(error)
    } finally {
      this.isLoading = false
    }
  }
}
</script>
