<template>
  <div class="flex flex-col grow w-full h-full">
    <Header class="flex-none border-b border-gray-700"></Header>

    <div class="p-4 grow h-full overflow-hidden">
      <div v-if="!isLoading && manga" class="mx-auto max-w-screen-sm flex flex-col gap-2 h-full">
        <div class="text-sm font-extrabold text-gray-300 flex-none">{{ manga.name }}</div>

        <div class="grow flex flex-col gap-1 mb-2">
          <div class="font-bold text-xs flex items-center gap-1">
            <span class="text-gray-400">Tải lên chương</span>
          </div>
          <div class="flex gap-1 items-center">
            <div class="rounded h-1 w-full bg-gray-700 relative">
              <div
                class="absolute top-0 left-0 h-full bg-green-700 rounded"
                :style="{ width: `${uploadProgress}%` }"
              ></div>
            </div>
            <span class="text-xs text-gray-400">{{ Math.round(uploadProgress) }}%</span>
          </div>
        </div>

        <ChaptersUploadProgress :chapters="toUploadChapters" class="grow overflow-y-auto h-full" />
      </div>

      <div v-else-if="isLoading" class="h-full">
        <Loading />
      </div>

      <div v-else class="h-full">
        <div>Không tìm thấy truyện</div>
      </div>
    </div>

    <div class="flex-none w-full h-16 border-t border-gray-700">
      <div class="h-full mx-auto max-w-screen-sm flex justify-between items-center">
        <div class="flex flex-col gap-1"></div>

        <!-- <button
          v-if="uploadStatus === 'uploading'"
          class="button button-primary px-4 py-2"
          @click="pauseUpload"
        >
          <Pause />
          <span>Tạm dừng</span>
        </button>

        <button
          v-if="uploadStatus === 'paused'"
          class="button button-primary px-4 py-2"
          @click="startUpload"
        >
          <Play />
          <span>Tiếp tục</span>
        </button> -->

        <button
          class="button button-primary px-4 py-2"
          :disabled="uploadStatus !== 'uploaded'"
          @click="router.push(`/manga/${manga.id}`)"
        >
          <Check />
          <span>Hoàn thành</span>
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { onMounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import Header from '@renderer/components/Header.vue'
import Loading from '@renderer/components/Loading.vue'
import { Check } from 'mdue'
import { useUpload } from '@renderer/composables/upload'
import ChaptersUploadProgress from '@renderer/components/StepThree/ChaptersUploadProgress.vue'

const router = useRouter()
const { manga, toUploadChapters, uploadProgress, uploadStatus, startUpload } = useUpload()

const isLoading = ref(false)

onMounted(async () => {
  await startUpload()
})
</script>
