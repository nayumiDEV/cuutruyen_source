<template>
  <div class="flex flex-col gap-1 rounded border border-gray-700 overflow-y-auto">
    <div
      v-for="file in files"
      :key="file.name"
      class="text-sm text-gray-400 hover:bg-gray-700 transition duration-300 px-2 py-1 flex items-center gap-2"
    >
      <Folder class="flex-none text-gray-400" />
      <span class="grow font-bold">{{ file.name }}</span>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, watch } from 'vue'
import natsort from 'natsort'
import { Folder } from 'mdue'

const sorter = natsort()

const props = defineProps({
  path: {
    type: String,
    required: true
  }
})

const files = ref([])

const readDirectory = async () => {
  if (!props.path) {
    return
  }

  const result = await window.electronAPI.readDirectory(props.path)
  console.log(result)
  files.value = result.sort((a, b) => {
    return sorter(b.name, a.name)
  })
}

onMounted(async () => {
  await readDirectory()
})

watch(
  () => props.path,
  async () => {
    await readDirectory()
  }
)
</script>
