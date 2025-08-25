<template>
  <div class="flex flex-col grow w-full h-full">
    <Header class="flex-none border-b border-gray-700">
      <button
        class="flex items-center gap-1 text-xs font-bold uppercase text-gray-300 px-2 py-1 bg-gray-800 rounded"
        @click="router.push(`/upload/${id}`)"
      >
        <ArrowLeft />
        <span>Bước 1</span>
      </button>
    </Header>

    <div class="p-4 grow h-full overflow-hidden">
      <div v-if="!isLoading && manga" class="mx-auto max-w-screen-sm flex flex-col gap-2 h-full">
        <div class="text-sm font-extrabold text-gray-300 flex-none">{{ manga.name }}</div>

        <div class="grow flex flex-col gap-1">
          <div class="font-bold text-xs flex items-center gap-1">
            <span class="text-gray-400">Thư mục đã chọn:</span>
            <span class="line-clamp-1 text-gray-300">{{ mangaPath }}</span>
          </div>
        </div>

        <ChaptersUploadListing
          v-model="chapters"
          class="grow overflow-y-auto h-full"
          :path="mangaPath"
          :existing-chapters="existingChapters"
        />
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
        <div class="flex flex-col gap-1">
          <button class="block link text-left" @click="openNameParserAlgorithmModal">
            Thuật toán nhận dạng số và tên chương...
          </button>
          <button class="block link text-left" @click="openChaptersSorterAlgorithmModal">
            Thuật toán sắp xếp chương...
          </button>
        </div>

        <button
          class="button button-primary px-4 py-2"
          :disabled="!canContinue"
          @click="router.push(`/upload/${id}/step-three`)"
        >
          <ArrowRight />
          <span>Xác nhận & Tải lên</span>
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
import ChaptersUploadListing from '@renderer/components/ChaptersUploadListing.vue'
import NameParserAlgorithmModal from '@renderer/components/NameParserAlgorithmModal.vue'
import ChaptersSorterAlgorithmModal from '@renderer/components/ChaptersSorterAlgorithmModal.vue'
import { useModal } from 'vue-final-modal'
import { parseDirectoriesName, sortChapters } from '@renderer/lib/eval'
import { useUpload } from '@renderer/composables/upload'

const router = useRouter()
const route = useRoute()
const { currentTeam } = useStore()
const {
  mangaPath,
  manga,
  chapters,
  chapterDirectories,
  nameParserAlgorithm,
  chaptersSorterAlgorithm,
  setChapters,
  setChapterDirectories,
  setNameParserAlgorithm,
  setChaptersSorterAlgorithm
} = useUpload()

const id = route.params.id
const existingChapters = ref([])
const isLoading = ref(true)
const errors = ref([])

const { open: openNameParserAlgorithmModal, close: closeNameParserAlgorithmModal } = useModal({
  component: NameParserAlgorithmModal,
  attrs: {
    onClose: () => {
      closeNameParserAlgorithmModal()
    },
    onConfirm: (value) => {
      setNameParserAlgorithm(value)
      finalizeChaptersList()
      closeNameParserAlgorithmModal()
    },
    algorithm: computed(() => nameParserAlgorithm.value)
  }
})

const { open: openChaptersSorterAlgorithmModal, close: closeChaptersSorterAlgorithmModal } =
  useModal({
    component: ChaptersSorterAlgorithmModal,
    attrs: {
      onClose: () => {
        closeChaptersSorterAlgorithmModal()
      },
      onConfirm: (value) => {
        setChaptersSorterAlgorithm(value)
        finalizeChaptersList()
        closeChaptersSorterAlgorithmModal()
      },
      algorithm: computed(() => chaptersSorterAlgorithm.value)
    }
  })

const getTeamMangaChapters = async () => {
  const { data } = await window.electronAPI.getTeamMangaChapters(currentTeam.value.id, id)
  existingChapters.value = data
}

const readDirectory = async () => {
  if (!mangaPath.value) {
    return
  }

  const result = await window.electronAPI.readDirectory(mangaPath.value)

  setChapterDirectories(result)
}

const mergeChapters = (parsedChapterDirectories) => {
  let chapters = []

  const structuredExistingChapters = existingChapters.value.map((chapter) => {
    return {
      id: chapter.id,
      chapterNumber: chapter.number,
      chapterName: chapter.name,
      order: chapter.order,
      type: 'existing',
      selected: false
    }
  })
  chapters = [...structuredExistingChapters]

  const newChapters = parsedChapterDirectories
    .map((parsedChapterDirectory) => {
      return {
        chapterNumber: parsedChapterDirectory.chapterNumber,
        chapterName: parsedChapterDirectory.chapterName,
        type: 'new',
        selected: false,
        status: 'pending',
        error: null,
        totalImagesCount: 0,
        uploadedImagesCount: 0,
        order: 0,
        directoryName: parsedChapterDirectory.directoryName
      }
    })
    .filter((chapter) => {
      return !chapters.some(
        (existingChapter) => existingChapter.chapterNumber === chapter.chapterNumber
      )
    })

  chapters = [...chapters, ...newChapters]

  setChapters(chapters)
}

const finalizeChaptersList = async () => {
  const parsedChapterDirectories = await parseDirectoriesName(
    chapterDirectories.value,
    nameParserAlgorithm.value
  )

  mergeChapters(parsedChapterDirectories)

  const sortedChapters = await sortChapters(chapters.value, chaptersSorterAlgorithm.value)

  setChapters(sortedChapters)
}

const canContinue = computed(() => {
  return (
    errors.value.length === 0 &&
    chapters.value.length > 0 &&
    chapters.value.some((chapter) => chapter.selected)
  )
})

onMounted(async () => {
  try {
    isLoading.value = true
    await Promise.all([getTeamMangaChapters(), readDirectory()])
    await finalizeChaptersList()
  } catch (error) {
    console.error('Error fetching manga data:', error)
  } finally {
    isLoading.value = false
  }
})
</script>
