<template>
  <div class="flex items-center gap-2 rounded border border-gray-700 p-1">
    <Folder class="flex-none text-gray-400" />
    <div v-if="path" class="text-sm font-bold grow">
      {{ path }}
    </div>
    <div v-else class="text-xs text-gray-400 grow">Chưa chọn thư mục</div>
    <button class="flex-none button px-4 py-2" @click="openDirectory">Chọn thư mục</button>
  </div>
</template>

<script setup>
import { Folder } from 'mdue'

defineProps({
  path: {
    type: String,
    required: true
  }
})
const emit = defineEmits(['path-selected'])

const openDirectory = async () => {
  const result = await window.electronAPI.openDirectory()
  if (result) {
    emit('path-selected', result)
  }
}
</script>
