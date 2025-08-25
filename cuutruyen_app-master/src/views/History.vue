<template>
  <div class="mx-2 py-8 lg:py-16">
    <CuuHeading>Lịch sử đọc truyện</CuuHeading>

    <div class="common-container">
      <div v-if="loading" class="h-screen flex justify-center items-center">
        <span class="spin">
          <LoadingIcon :size="64" class="text-gray-500" />
        </span>
      </div>

      <div v-else-if="histories && histories.length > 0" class="flex flex-col">
        <div v-for="(historyGroup, index) in groupedHistories" :key="index" class="flex gap-3 md:gap-6">
          <div class="hidden md:block text-sm text-gray-700 w-[12rem] text-right">{{ historyGroup[0].updated_at | humanizeTime }}</div>
          <div class="flex flex-col items-center">
            <CircleDoubleIcon />
            <div class="h-full border-l-[3px] border-gray-800"></div>
          </div>
          <div class="w-full mb-12">
            <div class="flex gap-2 mb-2">
              <router-link :to="{ name: 'Manga', params: { id: historyGroup[0].manga_id } }" class="font-bold text-gray-900">
                <img class="w-16 h-auto object-cover rounded shadow" :src="historyGroup[0].manga_cover_url"
                  :alt="historyGroup[0].manga_name" loading="lazy" width="320" height="480">
              </router-link>
              <router-link :to="{ name: 'Manga', params: { id: historyGroup[0].manga_id } }">
                <div class="font-bold text-gray-900">
                  {{ historyGroup[0].manga_name }}
                </div>
                <div class="md:hidden text-xs text-gray-700">{{ historyGroup[0].updated_at | humanizeTime }}</div>
              </router-link>
            </div>

            <router-link
              v-for="history in historyGroup"
              :key="history.id"
              :to="{ name: 'Chapter', params: { mangaId: history.manga_id, id: history.chapter_id } }"
              class="block rounded-lg mb-2"
            >
              <div>
                <span class="text-sm text-gray-700" v-if="history.chapter_name" href="#"><strong>Chương {{ history.chapter_number }}:</strong> {{ history.chapter_name }}</span>
                <span class="text-sm text-gray-700" v-else href="#"><strong>Chương {{ history.chapter_number }}</strong></span>
              </div>

              <div class="max-w-[24rem] flex items-center gap-1">
                <div
                  class="text-xs text-blue-600"
                  :class="{
                    'text-blue-600': history.read_pages / history.total_pages != 1,
                    'text-green-600': history.read_pages / history.total_pages == 1
                    }"
                >
                  {{ (history.read_pages / history.total_pages * 100).toFixed(0) + '%' }}
                </div>
                <div class="w-full bg-gray-200 rounded-full h-1">
                  <div
                    class="bg-blue-600 h-1 rounded-full"
                    :class="{
                      'bg-blue-600': history.read_pages / history.total_pages != 1,
                      'bg-green-600': history.read_pages / history.total_pages == 1
                      }"
                    :style="{ width: history.read_pages / history.total_pages * 100 + '%' }"
                  ></div>
                </div>
              </div>
            </router-link>
          </div>
        </div>

        <div v-if="nextCursor" class="flex gap-3 md:gap-6">
          <div class="hidden md:block text-sm text-gray-700 w-[12rem] text-right"></div>
          <div class="flex flex-col items-center">
            <CircleDoubleIcon />
            <div class="h-full border-l-[3px] border-gray-800"></div>
          </div>
          <div class="w-full mb-12">
            <button v-if="!moreLoading" class="text-sm font-bold text-gray-700 hover:text-gray-900 transition" @click.prevent="loadMore">Xem thêm...</button>
            <div v-else class="flex">
              <div class="spin">
                <LoadingIcon class="text-gray-700" />
              </div>
            </div>
          </div>
      </div>
    </div>

      <EmptyScreen v-else message="Bạn chưa từng xem truyện nào. Lịch sử các truyện mà bạn đã xem sẽ được hiển thị ở đây."></EmptyScreen>
    </div>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
import { listHistoriesByUser } from '@/spy-apis'
import LoadingIcon from 'vue-material-design-icons/Loading.vue'
import CircleDoubleIcon from 'vue-material-design-icons/CircleDouble.vue'

export default {
  metaInfo: {
    title: 'Lịch sử đọc truyện'
  },

  components: {
    LoadingIcon,
    CircleDoubleIcon
  },

  data () {
    return {
      histories: [],
      nextCursor: null,
      loading: false,
      moreLoading: false,
      error: false
    }
  },

  computed: {
    ...mapGetters([
      'currentUser'
    ]),
    groupedHistories () {
      return this.histories.reduce((acc, curr) => {
        if (acc.length === 0 || acc[acc.length - 1][0].manga_id !== curr.manga_id) {
          acc.push([curr])
        } else {
          acc[acc.length - 1].push(curr)
        }
        return acc
      }, [])
    }
  },

  async mounted () {
    this.$gtag.config({
      send_page_view: false
    })
    this.$gtag.pageview({ page_title: 'Lịch sử' })
    this.loadHistories()
  },

  methods: {
    async loadHistories (nextCursor = null) {
      if (!nextCursor) {
        this.loading = true
      } else {
        this.moreLoading = true
      }

      try {
        const response = await listHistoriesByUser(this.currentUser.id, nextCursor, 50)
        this.histories.push(...response.data)
        this.nextCursor = response.next_cursor
      } catch (error) {
        this.error = true

        this.$handleError(error)
      } finally {
        this.loading = false
        this.moreLoading = false
      }
    },

    loadMore () {
      if (this.nextCursor) {
        this.loadHistories(this.nextCursor)
      }
    }
  }
}
</script>
