<template>
  <div class="rounded px-4 py-4 bg-gray-200 text-gray-800">
    <div class="font-bold mb-1">{{ downloadingChapter.downloadName }}</div>
    <template v-if="downloadingChapter.status === 'downloading'">
      <div class="text-xs mb-3">
        Đang tải xuống
      </div>

      <div class="w-full h-1 bg-gray-200 rounded-full"
        :class="{
          'bg-gray-200 bg-opacity-20': downloadingChapter.status === 'downloading',
          'hidden': downloadingChapter.status !== 'downloading',
          }"
      >
        <div class="h-full rounded-full bg-gray-600" :style="{ width: `${downloadingChapter.progress * 100}%` }"></div>
      </div>
    </template>

    <template v-else-if="downloadingChapter.status === 'downloaded'">
      <div class="text-green-800 text-xs mb-3">Tải xuống thành công</div>

      <div>
        <router-link class="button button-primary px-4 py-2" :to="{ name: 'SavedOffline' }">Xem truyện</router-link>
      </div>
    </template>

    <div v-else class="text-red-800 text-xs">Tải xuống thất bại</div>
  </div>
</template>

<script>
export default {
  props: {
    downloadingChapter: Object
  }
}
</script>
