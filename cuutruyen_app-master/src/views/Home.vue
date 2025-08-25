<template>
  <div class="flex flex-col overflow-hidden">
    <Spotlight :mangas="spotlightMangas" />

    <section id="new-update" class="py-14 lg:py-20 px-2">
      <CuuHeading>Mới cập nhật</CuuHeading>

      <div class="common-container relative w-full mb-8 lg:mb-16 py-2" v-show="newMangasLoading">
        <div class="hidden md:block md:h-[37rem] lg:h-[43rem]"></div>
        <div class="h-[28.25rem] md:hidden"></div>

        <div class="absolute top-0 left-0 w-full h-full flex items-center justify-center rounded-lg bg-gray-200">
          <LoadingIcon :size="64" class="spin text-gray-500" />
        </div>
      </div>

      <SnapView v-if="!newMangasLoading" ref="snapView" class="common-container mb-4 lg:mb-6" customClass="grid grid-flow-col grid-rows-5 md:grid-rows-2 gap-2 md:gap-4 h-full py-2">
        <MangaItem v-for="(manga, index) in newMangas" :key="'new-manga-' + manga.id" class="snap-start snap-stop-always" :manga="manga" :index="index" />
      </SnapView>

      <div class="common-container flex justify-end">
        <router-link :to="{ name: 'Newest' }" class="cursor-pointer flex items-center text-gray-600 hover:text-blue-600 transition text-sm font-bold">
          <ChevronRightIcon mr-1 :size="16" />
          <span>Xem danh sách truyện</span>
        </router-link>
      </div>
    </section>

    <section id="best-mangas" class="py-14 lg:py-20 px-2">
      <CuuHeading headingClass="text-blue-100">Truyện nổi bật</CuuHeading>

      <div class="common-container flex justify-end py-8">
        <div class="rounded-full flex bg-gray-100">
          <button class="time-range-tab-item" :class="{'active': viewsCountType === 'week'}" @click="viewsCountType = 'week'">Tuần</button>
          <button class="time-range-tab-item" :class="{'active': viewsCountType === 'month'}" @click="viewsCountType = 'month'">Tháng</button>
          <button class="time-range-tab-item" :class="{'active': viewsCountType === 'all'}" @click="viewsCountType = 'all'">Mọi lúc</button>
        </div>
      </div>

      <div class="h-96 lg:h-96 mb-8 lg:mb-16" v-show="bestMangasLoading">
        <div class="w-full h-full flex items-center justify-center rounded-lg bg-gray-200 bg-opacity-20 common-container">
          <LoadingIcon :size="64" class="spin text-black text-opacity-40" />
        </div>
      </div>

      <SnapView v-if="!bestMangasLoading" ref="snapView2" class="common-container h-96 lg:h-96" customClass="grid grid-flow-col grid-rows-3 gap-4 h-full">
        <BestMangaItem
          v-for="(manga, index) in bestMangas"
          :key="'best-manga-' + manga.id"
          class="snap-start snap-stop-always"
          :manga="manga"
          :index="index"
          :viewsCountType="viewsCountType"
        />
      </SnapView>
    </section>

    <section id="best-teams" class="py-14 lg:py-20 px-2">
      <CuuHeading>Nhóm dịch hàng đầu</CuuHeading>

      <div class="common-container flex justify-end py-8">
        <div class="rounded-full flex bg-gray-100">
          <button class="time-range-tab-item" :class="{'active': bestTeamsViewsCountType === 'week'}" @click="bestTeamsViewsCountType = 'week'">Tuần</button>
          <button class="time-range-tab-item" :class="{'active': bestTeamsViewsCountType === 'month'}" @click="bestTeamsViewsCountType = 'month'">Tháng</button>
          <button class="time-range-tab-item" :class="{'active': bestTeamsViewsCountType === 'all'}" @click="bestTeamsViewsCountType = 'all'">Mọi lúc</button>
        </div>
      </div>

      <div class="common-container flex mb-8 lg:mb-16">
        <div class="relative w-full" v-show="bestTeamsLoading">
          <div class="mb-2 h-20"></div>
          <div class="mb-2 h-20"></div>
          <div class="mb-2 h-20"></div>
          <div class="mb-2 h-20"></div>
          <div class="mb-2 h-20"></div>

          <div class="absolute top-0 left-0 w-full h-full flex items-center justify-center rounded-lg bg-gray-200">
            <LoadingIcon :size="64" class="spin text-gray-500" />
          </div>
        </div>

        <div v-if="!bestTeamsLoading" class="flex flex-col flex-1">
          <BestTeamItem
            v-for="(team, index) in bestTeams"
            :key="'team-' + team.id"
            :team="team"
            :index="index"
            :viewsCountType="bestTeamsViewsCountType"
            class="h-20"
          />
        </div>
      </div>
    </section>

    <!-- <div class="connector-3 overflow-hidden">
         <img src="@/assets/img/connector-3.svg" class="max-w-none" width="2500" height="150" alt="">
         </div> -->
  </div>
</template>

<script>
import { homeA, top, topTeams } from '@/apis/user'
import Spotlight from '@/components/home/Spotlight'
import MangaItem from '@/components/home/MangaItem'
import BestMangaItem from '@/components/home/BestMangaItem'
import BestTeamItem from '@/components/home/BestTeamItem'
import SnapView from '@/components/SnapView'
import ChevronRightIcon from 'vue-material-design-icons/ChevronRight.vue'
import LoadingIcon from 'vue-material-design-icons/Loading.vue'

export default {
  name: 'Home',

  metaInfo: {
    title: 'Trang chủ'
  },

  components: {
    ChevronRightIcon,
    LoadingIcon,
    SnapView,
    MangaItem,
    BestMangaItem,
    BestTeamItem,
    Spotlight
  },

  data () {
    return {
      spotlightMangas: [],
      newMangas: [],
      bestMangas: [],
      bestTeams: [],
      newMangasLoading: true,
      bestMangasLoading: true,
      bestTeamsLoading: true,
      viewsCountType: 'week',
      bestTeamsViewsCountType: 'week',
      isProduction: process.env.NODE_ENV === 'production'
    }
  },

  async mounted () {
    this.$gtag.config({
      send_page_view: false
    })
    this.$gtag.pageview({ page_title: 'Trang chủ' })

    this.loadHomeA()

    setTimeout(() => {
      this.loadBestMangas()
      this.loadBestTeams()
    }, 1)
  },

  methods: {
    async loadHomeA () {
      try {
        this.newMangasLoading = true
        const response = await homeA()
        this.spotlightMangas = response.data.spotlight_mangas
        this.newMangas = response.data.new_chapter_mangas
      } catch (error) {
        this.$handleError(error)
      } finally {
        this.newMangasLoading = false

        this.$nextTick(() => {
          if (this.$refs.snapView) {
            this.$refs.snapView.checkScroll()
          }
        })
      }
    },

    async loadBestMangas () {
      try {
        this.bestMangasLoading = true
        const response = await top(this.viewsCountType)
        this.bestMangas = response.data
      } catch (error) {
        this.$handleError(error)
      } finally {
        this.bestMangasLoading = false

        this.$nextTick(() => {
          if (this.$refs.snapView2) {
            this.$refs.snapView2.checkScroll()
          }
        })
      }
    },

    async loadBestTeams () {
      try {
        this.bestTeamsLoading = true
        const response = await topTeams(this.bestTeamsViewsCountType, 1, 5)
        this.bestTeams = response.data
      } catch (error) {
        this.$handleError(error)
      } finally {
        this.bestTeamsLoading = false
      }
    }
  },

  watch: {
    viewsCountType (to, from) {
      if (to !== from) {
        this.loadBestMangas()
      }
    },

    bestTeamsViewsCountType (to, from) {
      if (to !== from) {
        this.loadBestTeams()
      }
    }
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

#best-mangas {
  background-color: #004cbb;
  background-image: url(../assets/img/stacked.svg);
  background-repeat: repeat-x;
  background-size: auto 100%;
  /* background-image: url("data:image/svg+xml,%3Csvg width='20' height='20' viewBox='0 0 20 20' xmlns='http://www.w3.org/2000/svg'%3E%3Cg fill='%23ffffff' fill-opacity='0.02' fill-rule='evenodd'%3E%3Ccircle cx='3' cy='3' r='3'/%3E%3Ccircle cx='13' cy='13' r='3'/%3E%3C/g%3E%3C/svg%3E"); */
}

.time-range-tab-item {
  @apply rounded-full py-1 md:py-2 m-1 w-20 md:w-24 flex justify-center items-center text-gray-700 uppercase text-xs font-bold transition hover:bg-gray-200;
}

.time-range-tab-item.active {
  @apply bg-blue-700 hover:bg-blue-600 text-blue-100;
}
</style>
