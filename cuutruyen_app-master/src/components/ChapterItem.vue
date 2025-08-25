<template>
  <div
    class="flex fine-transition overflow-hidden hover:bg-gray-200 mb-1 h-[56px]"
    :class="{
      'bg-gray-50': index % 2 == 0,
      'bg-gray-100': index % 2 != 0
      }"
    :to="{ name: 'Chapter', params: { mangaId: manga.id, id: chapter.id } }"
  >
    <div class="w-1.5 h-full">
      <div v-if="history" class="w-full h-full bg-gray-200 flex flex-col justify-end">
        <div
          class="bg-blue-600 w-full"
          :class="{
            'bg-blue-600': history.read_pages / history.total_pages != 1,
            'bg-green-600': history.read_pages / history.total_pages == 1
            }"
          :style="{ height: history.read_pages / history.total_pages * 100 + '%' }"
        ></div>
      </div>
      <div v-else class="w-full h-full bg-gray-200"></div>
    </div>
    <router-link
      :to="{ name: 'Chapter', params: { mangaId: manga.id, id: chapter.id } }"
      class="pl-2 truncate flex-grow flex items-center group outline-none focus:ring fine-transition">
      <div class="p-1 flex font-bold text-gray-800">
        <span class="hidden md:inline mr-1">Chương</span>
        <span class="md:hidden inline mr-1">C.</span>
        <span class="">{{ chapter.number }}</span>
      </div>
      <div class="p-2 flex flex-col flex-grow justify-between overflow-hidden">
        <div class="truncate flex-grow text-gray-800 text-left">
          <span v-if="chapter.name && chapter.name.trim().length > 0">{{ chapter.name }}</span>
          <span v-else class="text-gray-600 italic">Không có tiêu đề</span>
        </div>

        <div class="flex">
          <AlertIcon v-if="chapter.status === 'failed'" :size="16" class="mr-2 text-red-600" />
          <LoadingIcon v-else-if="chapter.status === 'processing' || chapter.status === 'enqueued'" :size="16" class="mr-2 spin text-yellow-600" />
          <div class="text-gray-500 text-xs font-thin md:text-sm md:font-normal">
            {{ chapter.created_at | humanizeTime }} - {{ chapter.views_count | humanizeNumber }} lượt xem - {{ chapter.comments_count | humanizeNumber }} bình luận
          </div>
        </div>
      </div>
    </router-link>

    <div class="flex items-center pr-2">
      <button
        v-if="isIndexedDB && chapter.status === 'processed'"
        class="focus:outline-none text-gray-800 flex justify-center"
        @click="!saved && saveOffline()"
      >
        <div
          v-if="saving || initSave"
          class="rounded-full w-8 h-8 fine-transition flex items-center justify-center"
        >
          <div class="spin"><LoadingIcon :size="16" /></div>
        </div>
        <div
          v-else-if="saved"
          class="rounded-full w-8 h-8 fine-transition flex items-center justify-center bg-green-200 text-green-900"
        >
          <CheckBoldIcon :size="16" />
        </div>
        <div
          v-else
          class="rounded-full w-8 h-8 fine-transition bg-gray-300 text-gray-700 flex items-center justify-center hover:bg-gray-400"
        >
          <DownloadIcon :size="16" />
        </div>
      </button>
    </div>
  </div>
</template>

<script>
import { getChapter } from '@/apis/user'
import DownloadIcon from 'vue-material-design-icons/Download.vue'
import LoadingIcon from 'vue-material-design-icons/Loading.vue'
import CheckBoldIcon from 'vue-material-design-icons/CheckBold.vue'
import AlertIcon from 'vue-material-design-icons/Alert.vue'
import { mapState, mapActions } from 'vuex'

export default {
  components: {
    DownloadIcon,
    LoadingIcon,
    CheckBoldIcon,
    AlertIcon
  },

  props: {
    manga: {
      type: Object
    },

    index: {
      type: Number
    },

    chapter: {
      type: Object
    },

    histories: {
      type: Array
    }
  },

  data () {
    return {
      initSave: false
    }
  },

  computed: {
    ...mapState({
      downloadingChapters: state => state.downloader.downloadingChapters,
      downloadedChapters: state => state.downloader.downloadedChapters
    }),

    isIndexedDB () {
      return this.$store.getters.isIndexedDB
    },

    saving () {
      return this.downloadingChapters.filter(c => c.status === 'downloading').find(c => c.id === this.chapter.id)
    },

    saved () {
      return this.downloadedChapters.find(c => c.id === this.chapter.id)
    },

    history () {
      return this.histories.find(h => h.chapter_id === this.chapter.id)
    }
  },

  methods: {
    ...mapActions(['downloadChapter']),

    async saveOffline () {
      this.initSave = true
      const response = await getChapter(this.chapter.id)
      const detailedChapter = response.data
      await this.downloadChapter({ manga: this.manga, chapter: detailedChapter })
      this.$notify({
        type: 'success',
        text: 'Đã thêm tác vụ tải chương này vào hàng đợi!'
      })
      this.initSave = false
      this.$gtag.event('save_offline_chapter')
    }
  }
}
</script>
