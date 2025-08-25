<template>
  <div class="mx-2 my-12">
    <div class="common-container">
      <h1 class="title">Tải xuống</h1>
    </div>

    <div class="common-container">
      <div v-if="downloadingChapters.length > 0">
        <div v-if="downloadingDownloadingChapters.length > 0" class="mb-6">
          <div class="text-sm mb-2 font-bold text-gray-700">Đang tải xuống</div>
          <div class="flex flex-col gap-2">
            <DownloadingChapterItem class="" v-for="downloadingChapter in downloadingDownloadingChapters" :key="downloadingChapter.id" :downloadingChapter="downloadingChapter" />
          </div>
        </div>

        <div v-if="notDownloadingChapters.length > 0">
          <div class="text-sm mb-2 font-bold text-gray-700">Đã tải xuống</div>
          <div class="flex flex-col gap-2">
            <DownloadingChapterItem class="" v-for="downloadingChapter in notDownloadingChapters" :key="downloadingChapter.id" :downloadingChapter="downloadingChapter" />
          </div>
        </div>
      </div>

      <EmptyScreen v-else message="Bạn chưa tải xuống truyện nào."></EmptyScreen>
    </div>
  </div>
</template>

<script>
import { mapState } from 'vuex'
import DownloadingChapterItem from '@/components/download/DownloadingChapterItem'

export default {
  components: {
    DownloadingChapterItem
  },

  data () {
    return {
    }
  },

  computed: {
    ...mapState({
      downloadingChapters: state => state.downloader.downloadingChapters
    }),

    downloadingDownloadingChapters () {
      return this.downloadingChapters.filter(c => c.status === 'downloading')
    },

    notDownloadingChapters () {
      return this.downloadingChapters.filter(c => c.status !== 'downloading')
    }
  }
}
</script>
