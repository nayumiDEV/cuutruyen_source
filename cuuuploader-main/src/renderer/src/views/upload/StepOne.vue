<template>
  <div class="flex flex-col grow w-full h-full">
    <Header class="flex-none border-b border-gray-700">
      <button
        class="flex items-center gap-1 text-xs font-bold uppercase text-gray-300 px-2 py-1 bg-gray-800 rounded"
        @click="router.push(`/manga/${id}`)"
      >
        <ArrowLeft />
        <span>Danh sách chương</span>
      </button>
    </Header>

    <div class="p-4 grow h-full overflow-hidden">
      <div v-if="!isLoading && manga" class="mx-auto max-w-screen-sm flex flex-col gap-2 h-full">
        <div class="text-sm font-extrabold text-gray-300">{{ manga.name }}</div>
        <DirectorySelector :path="mangaPath" @path-selected="setMangaPath" />
        <DirectoryListing class="grow overflow-y-auto h-full" :path="mangaPath" />
      </div>

      <div v-else-if="isLoading" class="h-full">
        <Loading />
      </div>

      <div v-else class="h-full">
        <div>Không tìm thấy truyện</div>
      </div>
    </div>

    <div class="flex-none w-full h-16 border-t border-gray-700">
      <div class="h-full mx-auto max-w-screen-sm flex justify-end items-center">
        <button
          class="button button-primary px-4 py-2"
          :disabled="!canContinue"
          @click="router.push(`/upload/${id}/step-two`)"
        >
          <ArrowRight />
          <span>Tiếp tục</span>
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { onMounted, ref, computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import Header from '@renderer/components/Header.vue'
import { ArrowLeft, ArrowRight } from 'mdue'
import { useStore } from '@renderer/composables/store'
import DirectorySelector from '@renderer/components/DirectorySelector.vue'
import DirectoryListing from '@renderer/components/DirectoryListing.vue'
import { useUpload } from '@renderer/composables/upload'

const router = useRouter()
const route = useRoute()
const { currentTeam } = useStore()
const { mangaPath, manga, setMangaPath, setTeam, setManga, initialize } = useUpload()

const id = route.params.id

const isLoading = ref(true)

const canContinue = computed(() => {
  return mangaPath.value !== ''
})

const getTeamManga = async () => {
  const { data } = await window.electronAPI.getTeamManga(currentTeam.value.id, id)
  setTeam(currentTeam.value)
  setManga(data)
}

onMounted(async () => {
  try {
    isLoading.value = true
    initialize()
    await getTeamManga()
  } catch (error) {
    console.error('Error fetching manga data:', error)
  } finally {
    isLoading.value = false
  }
})
</script>
