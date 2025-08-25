<template>
  <div class="rounded border border-gray-700 flex flex-col">
    <div class="flex flex-none justify-between border-b border-gray-700 p-1">
      <button v-if="isAllSelected" class="button px-2 py-1" @click="unselectAll">
        Bỏ chọn tất cả
      </button>
      <button v-else class="button px-2 py-1" @click="selectAll">Chọn tất cả</button>
    </div>

    <div class="grow overflow-y-auto">
      <div
        v-for="chapter in chapters"
        :key="chapter.chapterNumber"
        class="h-12 text-sm text-gray-400 hover:bg-gray-700 transition duration-300 m-1 rounded px-1 py-1 flex items-center gap-1"
      >
        <div class="flex-none w-6 h-6">
          <template v-if="chapter.type === 'new'">
            <button class="w-full h-full" @click="chapter.selected = !chapter.selected">
              <CheckboxMarked
                v-if="chapter.selected"
                class="text-gray-400 w-6 h-6 hover:text-gray-200 transition duration-300"
              />
              <CheckboxBlank
                v-else
                class="text-gray-400 w-6 h-6 hover:text-gray-200 transition duration-300"
              />
            </button>
          </template>
        </div>

        <div class="w-full flex justify-between">
          <div class="h-full">
            <div class="text-sm flex items-center gap-1">
              <div class="font-bold flex items-center gap-1">
                <span class="text-gray-400">Chương </span>
                <span class="grow text-gray-200">{{ chapter.chapterNumber }}</span>
              </div>

              <div class="text-gray-400">-</div>

              <div class="flex items-center gap-1">
                <span v-if="chapter.chapterName" class="text-gray-200">{{ chapter.chapterName }}</span>
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
            <span v-if="chapter.type === 'new'" class="text-xs text-green-400">Chương mới</span>
            <span v-else class="text-xs text-gray-400">Chương tồn tại</span>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue'
import { CheckboxBlank, CheckboxMarked } from 'mdue'

const chapters = defineModel({
  type: Array
})

const isAllSelected = computed(() => {
  return chapters.value
    .filter((chapter) => chapter.type === 'new')
    .every((chapter) => chapter.selected)
})

const selectAll = () => {
  chapters.value
    .filter((chapter) => chapter.type === 'new')
    .forEach((chapter) => {
      chapter.selected = true
    })
}

const unselectAll = () => {
  chapters.value
    .filter((chapter) => chapter.type === 'new')
    .forEach((chapter) => {
      chapter.selected = false
    })
}
</script>
