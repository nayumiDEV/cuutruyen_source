<template>
  <div class="rounded border border-gray-700 flex flex-col">
    <div class="grow overflow-y-auto">
      <div
        v-for="chapter in chapters"
        :key="chapter.chapterNumber"
        class="h-12 text-sm text-gray-400 bg-gray-800/30 transition duration-300 m-1 rounded px-1 py-1 flex items-center gap-1 relative"
      >
        <div
          class="absolute top-0 left-0 h-full bg-green-800/20 rounded"
          :style="{ width: `${(chapter.uploadedImagesCount / chapter.totalImagesCount) * 100}%` }"
        ></div>
        <div class="flex-none w-6 h-6"></div>

        <div class="w-full flex justify-between">
          <div class="h-full">
            <div class="text-sm flex items-center gap-1">
              <div class="font-bold flex items-center gap-1">
                <span class="text-gray-400">Chương </span>
                <span class="grow text-gray-200">{{ chapter.chapterNumber }}</span>
              </div>

              <div class="text-gray-400">-</div>

              <div class="flex items-center gap-1">
                <span v-if="chapter.chapterName" class="text-gray-200">{{
                  chapter.chapterName
                }}</span>
                <span v-else class="italic text-gray-500">Không có tiêu đề</span>
              </div>
            </div>

            <div
              v-if="chapter.directoryName"
              class="flex justify-end items-center gap-1 text-[0.7rem]"
            >
              <span>Tên thư mục: </span>
              <span class="grow line-clamp-1">{{ chapter.directoryName }}</span>
            </div>
          </div>

          <div class="flex-none flex items-center justify-center">
            <span v-if="chapter.status === 'pending'" class="text-xs text-gray-400">Đang chờ</span>
            <span v-else-if="chapter.status === 'uploading'" class="text-xs text-blue-400"
              >Đang tải lên</span
            >
            <span v-else-if="chapter.status === 'uploaded'" class="text-xs text-green-400"
              >Đã tải lên</span
            >
            <span v-else class="text-xs text-red-400">Thất bại</span>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
defineProps({
  chapters: {
    type: Array,
    required: true
  }
})
</script>
