<template>
  <Header>
    <button
      class="flex items-center gap-1 text-xs font-bold uppercase text-gray-300 px-2 py-1 bg-gray-800 rounded"
      @click="router.push('/')"
    >
      <ArrowLeft />
      <span>Danh sách truyện</span>
    </button>
  </Header>

  <div class="p-4 grow overflow-y-auto">
    <div v-if="!isLoading && manga">
      <div class="mx-auto max-w-screen-sm flex flex-col gap-2">
        <div class="text-lg font-extrabold text-gray-300">{{ manga.name }}</div>

        <div class="flex items-center gap-1">
          <div class="text-xs text-gray-400">{{ chapters.length }} chương</div>
        </div>

        <div class="flex items-center gap-2">
          <button
            class="button button-primary px-4 py-2 min-w-32 flex justify-center"
            @click="router.push(`/upload/${id}`)"
          >
            <Plus />
            <span>Thêm chương</span>
          </button>

          <button
            class="button px-4 py-2 min-w-32 flex justify-center"
            :disabled="true"
            @click="sortChapters"
          >
            <OrderNumericDescending />
            <span>Sắp xếp</span>
          </button>
        </div>
      </div>

      <div class="mt-4 flex flex-col gap-1 mx-auto max-w-screen-sm">
        <div
          v-for="chapter in chapters"
          :key="chapter.id"
          class="first:rounded-t last:rounded-b bg-gray-800 hover:bg-gray-700 transition duration-300 flex gap-2 cursor-pointer"
          @click="openChapterEdit(chapter.id)"
        >
          <div v-if="false" class="p-2 flex-none flex items-center">
            <ReorderHorizontal />
          </div>
          <div class="p-2 grow">
            <div class="text-sm font-bold text-gray-400">Chương {{ chapter.number }}</div>
            <div v-if="chapter.name" class="text-sm font-bold">{{ chapter.name }}</div>
            <div v-else class="text-sm text-gray-400">Không có tiêu đề</div>
          </div>

          <div class="p-2 flex-none">
            <div class="text-xs text-gray-400">{{ chapter.pages_count }} trang</div>
          </div>
        </div>
      </div>
    </div>

    <div v-else-if="isLoading" class="h-full">
      <Loading />
    </div>

    <div v-else class="h-full">
      <div>Không tìm thấy truyện</div>
    </div>
  </div>
</template>

<script setup>
import { onMounted, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import Header from '@renderer/components/Header.vue'
import { ArrowLeft, ReorderHorizontal, Plus, OrderNumericDescending } from 'mdue'
import { useStore } from '@renderer/composables/store'
import { useToast } from 'vue-toastification'

const toast = useToast()
const router = useRouter()
const route = useRoute()
const { currentTeam } = useStore()
const id = route.params.id

const manga = ref(null)
const chapters = ref(null)
const isLoading = ref(true)

const getTeamManga = async () => {
  const { data } = await window.electronAPI.getTeamManga(currentTeam.value.id, id)
  manga.value = data
}

const getTeamMangaChapters = async () => {
  const { data } = await window.electronAPI.getTeamMangaChapters(currentTeam.value.id, id)
  chapters.value = data
}

const openChapterEdit = (id) => {
  window.electronAPI.openChapterEdit(currentTeam.value.id, id)
}

const sortChapters = async () => {
  await window.electronAPI.sortTeamChapters(currentTeam.value.id, id, chapters.value)
}

onMounted(async () => {
  try {
    isLoading.value = true
    await Promise.all([getTeamManga(), getTeamMangaChapters()])
  } catch (error) {
    if (error.message) {
      toast.error(error.message)
    } else {
      toast.error('Lấy dữ liệu truyện thất bại vi lỗi không rõ nguyên nhân')
    }
  } finally {
    isLoading.value = false
  }
})
</script>
