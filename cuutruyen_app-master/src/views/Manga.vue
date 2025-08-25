<template>
  <div class="mx-2 my-12">
    <div class="mx-auto sm:max-w-screen-sm md:max-w-screen-md lg:max-w-screen-lg xl:max-w-screen-xl">
      <main class="bg-white rounded-lg overflow-hidden fine-shadow-spread">
        <div class="flex flex-col border-b-2 border-gray-300">
          <div class="relative">
            <canvas
              width="32"
              height="15"
              class="w-full bg-gray-500 hidden lg:block"
              :style="`box-shadow: 0px 6px 20px 2px ${panoramaDominantColor}50; background-color: #111827`"
            ></canvas>
            <canvas
              width="16"
              height="9"
              class="w-full bg-gray-500 lg:hidden"
              :style="`box-shadow: 0px 6px 20px 2px ${panoramaDominantColor}50; background-color: #111827`"
            ></canvas>
            <picture v-if="manga">
              <source :srcset="getUrl(manga.panorama_mobile_url)" media="(max-width: 640px)">
              <img
                :src="getUrl(manga.panorama_url)"
                :alt="manga.name"
                class="absolute top-0 left-0 w-full h-full object-cover object-center"
              >
            </picture>
            <div
              class="absolute z-20 w-full h-full top-0 left-0 brightness-60"
              :style="`background: linear-gradient(0deg, ${panoramaDominantColor} 0%, transparent 50%)`"
            ></div>
            <div class="absolute z-20 w-full h-full top-0 left-0">
              <div class="absolute bottom-0 transform w-full lg:w-auto mx-auto translate-y-3/4 lg:translate-x-24 lg:translate-y-1/2">
                <div class="mx-auto w-32 lg:w-56 rounded-lg">
                  <div class="overflow-hidden rounded-lg fine-shadow-bold relative">
                    <canvas width="32" height="48" class="w-full rounded-lg bg-gray-500"></canvas>
                    <picture v-if="manga">
                      <source :srcset="getUrl(manga.cover_mobile_url)" media="(max-width: 640px)">
                      <img
                        class="rounded-lg absolute w-full top-0 left-0"
                        :src="getUrl(manga.cover_url)"
                        width="320"
                        height="480"
                        :alt="manga.name"
                      >
                    </picture>
                  </div>
                </div>
              </div>
              <div v-if="manga" class="ml-fs absolute bottom-0 hidden lg:block">
                <h2 v-if="manga" class="m-4 mb-0 text-gray-200 text-opacity-75 text-sm font-head">{{ manga.author.name }}</h2>
                <h1 v-if="manga" class="m-4 mt-1 text-white text-opacity-90 text-2xl font-extrabold font-head">{{ manga.name }}</h1>
              </div>
              <div v-else class="ml-fs absolute bottom-0 hidden lg:block">
                <div class="bg-gray-500 h-4 w-32 m-4"></div>
                <div class="bg-gray-700 h-6 w-56 m-4"></div>
              </div>
            </div>
          </div>

          <div class="relative bg-gray-200 pb-4 overflow-hidden">
            <div class="mt-fs lg:mt-0 lg:ml-fs z-20 relative">
              <div class="lg:min-h-mm m-4 flex flex-col justify-between">
                <div class="mb-0 mt-4 lg:hidden text-center">
                  <h1 v-if="manga" class="text-black text-opacity-90 text-xl font-extrabold font-head">{{ manga.name }}</h1>
                  <div v-else class="bg-gray-500 h-6 w-5/6 mx-auto"></div>
                </div>
                <div class="mb-4 mt-1 lg:hidden text-center">
                  <h2 v-if="manga" class="text-gray-800 text-sm font-head">{{ manga.author.name }}</h2>
                  <div v-else class="bg-gray-400 h-4 w-3/6 mx-auto"></div>
                </div>

                <div>
                  <div class="text-gray-700 text-sm mb-4 flex justify-center lg:justify-start">
                    <div v-if="manga" class="flex"><ClockOutlineIcon class="mr-1" :size="20" /><span>{{ manga.newest_chapter_created_at | humanizeTime }}</span></div>
                  </div>
                  <div v-if="manga">
                    <div v-if="manga.tags.length" class="mb-4 flex flex-wrap gap-1">
                      <router-link
                        v-for="(tag, index) in manga.tags"
                        :key="index"
                        :to="{ name: 'Tag', params: { slug: tag.slug } }"
                        class="cursor-pointer px-2 lg:px-2.5 py-0.5 lg:py-1 rounded-full text-gray-700 bg-gray-100 text-xs lg:text-sm font-bold hover:bg-white transition"
                      >
                        {{ tag.name }}
                        <span class="rounded-full text-[9px] lg:text-[10px] bg-gray-300 px-1 lg:px-1.5 py-0 lg:py-0.5">{{ tag.tagging_count }}</span>
                      </router-link>
                    </div>

                    <p v-else class="text-gray-600 mb-4 text-justify text-sm">
                      {{ manga.description }}
                    </p>
                  </div>
                  <div v-else class="mb-4">
                    <div class="bg-gray-300 h-3 w-5/6 max-w-full mb-2"></div>
                    <div class="bg-gray-300 h-3 w-3/6 max-w-full mb-2"></div>
                    <div class="bg-gray-300 h-3 w-4/6 max-w-full mb-2"></div>
                  </div>
                </div>

                <div v-if="manga" class="flex flex-col md:flex-row gap-2 justify-center items-stretch lg:justify-start">
                  <button
                    v-if="!currentUser"
                    class="button px-6 py-2 bg-gray-100 focus:ring text-gray-500 font-bold text-sm md:text-md uppercase text-center cursor-default"
                    disabled
                  >
                    Đăng nhập để theo dõi
                  </button>
                  <button v-else-if="!manga.is_following"
                    class="button button-primary px-6 py-2"
                    @click.prevent="follow"
                  >
                    Theo dõi truyện
                  </button>
                  <button v-else-if="manga.is_following" class="button px-6 py-2 button-boring"
                    @click.prevent="showUnfollowModal = true"
                  >
                    Đã theo dõi
                  </button>

                  <router-link
                    v-if="chapters && chapters.length > 0"
                    :to="{ name: 'Chapter',
                      params: { mangaId: manga.id, id: chapters[chapters.length - 1].id },
                      query: { offline: $route.query.offline } }"
                    class="button px-6 py-2 button-normal2">
                    Đọc từ chương {{ chapters[chapters.length - 1].number }}
                  </router-link>

                  <button v-else class="button button-disabled px-6 py-2" disabled>
                    Đọc từ đầu
                  </button>
                </div>

                <div v-else class="flex flex-col md:flex-row justify-center items-stretch lg:justify-start gap-2">
                <div class="block bg-gray-300 min-w-[9rem] h-8"></div>
                <div class="block bg-gray-300 min-w-[9rem] h-8"></div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <div v-if="loading || chaptersLoading" class="h-screen"></div>

        <div v-else class="py-6 px-2 md:px-4 flex gap-8">
          <div class="grow overflow-hidden">
            <div class="mb-6 lg:mb-8 rounded bg-gray-200 bg-opacity-70 relative overflow-hidden" ref="descriptionBox" style="scroll-margin: 70px" :class="{ 'h-48 md:h-56': !isExpandedDescription && manga.full_description }">
              <div class="p-4">
                <div class="flex gap-2 items-start">
                  <Avatar
                    :image-url="team.avatar_url"
                    :name="team.name"
                    :link-to="{ name: 'TeamProfile', params: { teamSlug: team.slug } }"
                  />
                  <div class="flex items-start justify-between w-full">
                    <div>
                      <div class="text-sm font-bold uppercase text-blue-900 hover:text-blue-800 transition">
                        <router-link :to="{ name: 'TeamProfile', params: { teamSlug: team.slug } }">{{ team.name }}</router-link>
                      </div>
                      <div class="text-xs text-gray-600 uppercase">{{ team.translations_count }} truyện</div>
                      <div class="mt-2 flex justify-start">
                        <router-link
                          :to="{ name: 'TeamProfile', params: { teamSlug: team.slug } }"
                          class="flex items-center gap-1 rounded border border-blue-800 px-2 py-1 text-blue-800 text-xs font-bold hover:bg-blue-800 hover:text-white transition"
                        >
                          <AccountMultipleIcon :size="16" /> Xem trang nhóm
                        </router-link>
                      </div>
                    </div>
                    <div class="flex" v-if="team.facebook_address">
                      <div class="h-3/4 border-r border-gray-400 mx-1"></div>
                      <a
                        class="text-blue-700 hover:text-white hover:bg-blue-700 block transition rounded-lg text-sm flex items-center py-1 px-2 mr-1 bg-gray-50"
                        :href="`https://fb.com/${team.facebook_address}`"
                        target="_blank"
                        rel="noopener noreferrer"
                      >
                        <FacebookIcon :size="24" />
                        <span class="ml-0.5 text-xs font-bold hidden lg:inline">fb.com/{{ team.facebook_address }}</span>
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
                  </div>
                </div>
                <div v-html="manga.full_description" v-show="manga.full_description" class="mt-4 prose prose-p:text-sm prose-h3:text-base prose-p:text-gray-500 max-w-full prose-h3:text-gray-700 prose-a:text-blue-500"></div>
              </div>

              <div class="bg-gray-200 p-4">
                <div v-if="manga && manga.official_url">
                  <div class="text-sm font-bold uppercase text-gray-600 mb-2">Trang chính thức</div>
                  <div>
                    <a
                      class="text-gray-700 hover:text-gray-800 transition text-sm"
                      :href="manga.official_url"
                      target="_blank"
                      rel="noopener noreferrer"
                    >
                      {{ manga.official_url | onlyHostname }}
                    </a>
                  </div>
                </div>

                <div class="mt-4">
                  <div class="uppercase text-sm text-gray-600 font-bold font-head mb-2">Thông tin thêm</div>

                  <div class="text-gray-700 mb-1 flex items-center text-sm">
                    <div><strong>{{ manga.chapters_count }}</strong> chương đã đăng</div>
                  </div>

                  <div class="text-gray-700 flex items-center text-sm">
                    <div><strong>{{ manga.views_count | humanizeNumber }}</strong> lượt xem</div>
                  </div>
                </div>
              </div>

              <div class="absolute w-full h-16 bottom-0 left-0 from-gray-200 to-transparent flex items-end justify-center bg-gradient-to-t cursor-pointer" @click="expandDescription(true)" v-show="!isExpandedDescription && manga.full_description">
                <button type="button" class="text-gray-500 font-bold text-xs text-center pb-2">
                  Xem thêm
                </button>
              </div>

              <div class="absolute w-full bottom-0 left-0 flex items-end justify-center" v-show="isExpandedDescription && manga.full_description">
                <button type="button" @click.prevent="expandDescription(false)" class="text-gray-500 font-bold text-xs text-center pb-2">
                  Thu gọn
                </button>
              </div>
          </div>

          <div v-show="activeTab === 'chapterList'">
            <RecycleScroller
                v-show="!chaptersLoading && chapters.length > 0"
                ref="virtualList"
                class="h-[70vh] overflow-auto"
                :items="chapters"
                :item-size="60"
                v-slot="{ item, index }"
              >
                <ChapterItem :manga="manga" :chapter="item" :index="index" :histories="histories" />
              </RecycleScroller>

              <div v-show="chaptersLoading" class="min-h-[70vh] flex justify-center items-center">
                <LoadingIcon :size="64" class="spin text-gray-500" />
              </div>

              <EmptyScreen v-show="!chaptersLoading && chapters.length === 0" message="Truyện này chưa được đăng lên chương nào."></EmptyScreen>
            </div>

            <Description v-show="activeTab === 'description'" />
          </div>

          <!-- <Info class="flex-none w-72 hidden lg:block" :team="team" :manga="manga" :translation="translation" /> -->
          <div class="flex-none w-72 hidden lg:block">
            <div v-if="currentUser && (currentUser.teams.map(t => Number(t.id)).includes(team.id) || currentUser.level === 'admin')" class="mb-8">
              <div class="text-xs font-bold text-gray-600 uppercase mb-4">Công cụ</div>
              <div>
                <router-link v-if="currentUser.level === 'admin'" :to="{ name: 'TeamMangaManagement', params: { teamId: team.id } }" class="link block mb-1">Quản lý nhóm</router-link>

                <template v-if="currentUser.teams.map(t => Number(t.id)).includes(team.id) || currentUser.level === 'admin'">
                  <router-link :to="{ name: 'TeamChapterManagement', params: { teamId: team.id, mangaId: manga.id } }" class="link block mb-1">Quản lý chương truyện</router-link>
                  <router-link :to="{ name: 'TeamMangaEdit', params: { teamId: team.id, mangaId: manga.id } }" class="link block mb-1">Sửa thông tin truyện</router-link>
                </template>
              </div>
            </div>

            <div class="mb-8">
              <div class="text-xs font-bold text-gray-600 uppercase mb-4">Cùng nhóm dịch</div>
              <TeamMangas :mangas="suggestedTeamMangas" :loading="suggestedLoading" />
            </div>

            <div class="mb-8">
              <div class="text-xs font-bold text-gray-600 uppercase mb-4">Đề xuất</div>
              <SuggestedMangas :mangas="suggestedMangas" :loading="suggestedLoading" />
            </div>
          </div>
        </div>
      </main>

      <div
        v-if="!loading && manga && chapters && chapters.length > 0"
        class="text-gray-500 text-sm mt-12 h-40 md:h-36 overflow-auto max-w-md text-center mx-auto"
      >
        <div class="mb-2">
          Đọc truyện tranh manga (manhua, manhwa) <strong>{{ manga.name }}</strong>
          sớm nhất với bản đẹp chất lượng sắc nét chỉ có tại Cứu Truyện.
          Chương (chap, chapter) mới nhất là
          <span class="font-bold"> chap {{ chapters[0].number }}</span>,
          được cập nhật liên tục trên <strong>CuuTruyen.Net</strong>.
        </div>

        <div v-if="otherTitles.length > 0">
          Truyện <strong>{{ manga.name }}</strong> còn có những tên gọi khác như:
          <span v-for="(title, index) in otherTitles" :key="'title-' + title.id">
            <span class="font-bold">{{ title.name }}</span>
            <template v-if="index === manga.titles.length - 2">.</template>
            <template v-else>, </template>
          </span>
        </div>
      </div>
    </div>

    <InstallNotificationModal v-model="showInstallNotificationModal" @confirm="goToConfiguration()" />
    <UnfollowModal v-model="showUnfollowModal" @confirm="unfollow()" />
    <AgeVerificationModal v-model="showAgeVerificationModal" />
  </div>
</template>

<script>
import { getManga, getChapters, goFollow, goUnfollow, getSuggestedMangasA } from '@/apis/user'
import { listHistoriesByManga } from '@/spy-apis'
import { mapGetters } from 'vuex'
import ClockOutlineIcon from 'vue-material-design-icons/ClockOutline.vue'
import LoadingIcon from 'vue-material-design-icons/Loading.vue'
import FacebookIcon from 'vue-material-design-icons/Facebook.vue'
import FacebookMessengerIcon from 'vue-material-design-icons/FacebookMessenger.vue'
import AccountMultipleIcon from 'vue-material-design-icons/AccountMultiple.vue'
import { fullUrl } from '@/utils/get-url'
import Description from '@/components/manga-view/Description'
import SuggestedMangas from '@/components/manga-view/SuggestedMangas'
import TeamMangas from '@/components/manga-view/TeamMangas'
import InstallNotificationModal from '@/components/InstallNotificationModal'
import UnfollowModal from '@/components/UnfollowModal'
import AgeVerificationModal from '@/components/AgeVerificationModal'
import * as WebPush from '@/lib/web-push'
import { RegionNotSupported } from '@/utils/custom-errors'
import Avatar from '@/components/common/Avatar'

export default {
  metaInfo () {
    if (!this.manga) {
      return {}
    }

    return {
      title: `Đọc ${this.manga.name} chương mới nhất`,
      meta: [
        { vmid: 'description', name: 'description', content: `Đọc ${this.manga.name} - ${this.manga.description}` }
      ],
      link: [
        { rel: 'canonical', href: `${this.baseUrl}/mangas/${this.manga.id}` }
      ],
      script: [
        {
          vmid: 'jsonld',
          type: 'application/ld+json',
          json: {
            '@context': 'https://schema.org',
            '@type': 'Article',
            headline: `Đọc ${this.manga.name} chương mới nhất`,
            image: [
              this.getUrl(this.manga.cover_url),
              this.getUrl(this.manga.panorama_url)
            ],
            datePublished: this.manga.created_at,
            dateModified: this.manga.updated_at
          }
        },
        {
          vmid: 'jsonld-ls',
          type: 'application/ld+json',
          json: {
            '@context': 'https://schema.org',
            '@type': 'ItemList',
            itemListElement: this.itemList
          }
        }
      ]
    }
  },

  name: 'Manga',

  components: {
    InstallNotificationModal,
    UnfollowModal,
    AgeVerificationModal,
    ClockOutlineIcon,
    LoadingIcon,
    FacebookIcon,
    FacebookMessengerIcon,
    AccountMultipleIcon,
    ChapterItem: () => import('@/components/ChapterItem'),
    Description,
    SuggestedMangas,
    TeamMangas,
    Avatar
  },

  filters: {
    onlyHostname (url) {
      return (new URL(url)).hostname
    }
  },

  data () {
    return {
      manga: null,
      loading: true,
      suggestedTeamMangas: null,
      suggestedMangas: null,
      suggestedLoading: true,
      chaptersLoading: true,
      activeTab: 'chapterList',
      showInstallNotificationModal: false,
      showUnfollowModal: false,
      chapters: [],
      histories: [],
      isExpandedDescription: false,
      showAgeVerificationModal: false,
      baseUrl: process.env.VUE_APP_API_BASE_URL
    }
  },

  computed: {
    ...mapGetters([
      'currentUser', 'geo', 'isSpider', 'isClientRegionLimited', 'isStormRegion'
    ]),

    itemList () {
      return this.chapters.map((c, i) => ({
        '@type': 'ListItem',
        position: i + 1,
        url: window.location.origin + this.$router.resolve({ name: 'Chapter', params: { mangaId: this.manga.id, id: c.id } }).href
      }))
    },

    translation () {
      if (!this.manga || !this.manga.translations || this.manga.translations.length < 1) {
        return null
      }

      return this.manga.translations[0]
    },

    team () {
      if (!this.manga) {
        return null
      }

      return this.manga.team
    },

    otherTitles () {
      if (!this.manga) {
        return null
      }

      return this.manga.titles.filter(title => !title.primary)
    },

    panoramaDominantColor () {
      if (this.manga && this.manga.panorama_dominant_color) {
        return this.manga.panorama_dominant_color
      }

      return '#05070c'
    }
  },

  async mounted () {
    await Promise.all([this.loadManga(), this.loadChapters()])
    this.loadHistories()
    this.loadSuggested()
  },

  methods: {
    async loadManga () {
      this.lockBodyScroll()
      this.loading = true

      try {
        const response = await getManga(this.$route.params.id)
        this.manga = response.data

        if (this.manga.is_nsfw && !this.isSpider) {
          const isAgeVerified = Number(sessionStorage.getItem('isAgeVerified') || 0)
          if (isAgeVerified === 0) {
            this.showAgeVerificationModal = true
          }
        }

        this.$gtag.config({
          send_page_view: false
        })
        this.$gtag.pageview({ page_title: `Đọc ${this.manga.name} chương mới nhất` })
      } catch (error) {
        this.$handleError(error)
      } finally {
        this.loading = false
        this.releaseBodyScroll()
      }
    },

    async loadChapters () {
      this.chaptersLoading = true
      try {
        const response = await getChapters(this.$route.params.id)
        this.chapters = response.data
      } catch (error) {
        this.$handleError(error)
        this.releaseBodyScroll()
      } finally {
        this.chaptersLoading = false
      }
    },

    async loadHistories () {
      try {
        const response = await listHistoriesByManga(this.currentUser.id, this.manga.id)
        this.histories = response.data
      } catch (error) {
        console.error(error)
      }
    },

    async loadSuggested () {
      this.suggestedLoading = true
      try {
        const response = await getSuggestedMangasA(this.team.id)
        this.suggestedTeamMangas = response.data.same_team_mangas
        this.suggestedMangas = response.data.suggested_mangas
      } catch (error) {
        this.$notify({
          type: 'error',
          text: 'Có lỗi xảy ra khi lấy danh sách truyện được đề xuất.'
        })
        console.error(error)
      } finally {
        this.suggestedLoading = false
      }
    },

    getUrl (path) {
      return fullUrl(path)
    },

    async follow () {
      try {
        await goFollow(this.manga.id)

        if (WebPush.isPushApiSupported() && WebPush.getNotificationPermissionStatus() !== 'granted') {
          this.showInstallNotificationModal = true
        }

        this.$notify({
          type: 'success',
          text: 'Đã thêm truyện vào danh sách theo dõi!'
        })

        this.$gtag.event('follow_manga')
      } catch (error) {
        this.$notify({
          type: 'error',
          text: 'Có lỗi xảy ra khi theo dõi truyện.'
        })

        throw error
      } finally {
        const response = await getManga(this.$route.params.id)
        this.manga = response.data
      }
    },

    async unfollow () {
      try {
        await goUnfollow(this.manga.id)

        this.$notify({
          type: 'success',
          text: 'Đã hủy theo dõi truyện thành công!'
        })
      } catch (error) {
        this.$notify({
          type: 'error',
          text: 'Có lỗi xảy ra khi hủy theo dõi truyện'
        })

        throw error
      } finally {
        const response = await getManga(this.$route.params.id)
        this.manga = response.data
      }
    },

    goToConfiguration () {
      this.$router.push({ name: 'Configuration' })
    },

    recheckRegionLimited () {
      if (this.manga && this.manga.is_region_limited) {
        if (this.isClientRegionLimited) {
          this.$handleError(new RegionNotSupported(this.geo, this.isSpider))
        }
      }

      if (this.isStormRegion) {
        this.$handleError(new RegionNotSupported(this.geo, this.isSpider))
      }
    },
    expandDescription (isExpand = true) {
      if (isExpand) {
        this.isExpandedDescription = true
      } else {
        this.isExpandedDescription = false
      }
    }
  },

  watch: {
    manga () {
      this.recheckRegionLimited()
    },

    isClientRegionLimited () {
      this.recheckRegionLimited()
    }
  }
}
</script>

<style scoped>
.bg-gradient-dark {
  background: linear-gradient(to top, hsla(0, 0%, 0%, 1), ease, hsla(0, 0%, 0%, 0));
}

.feature-photo {
  min-height: 320px;
  max-height: 480px;
}
</style>
