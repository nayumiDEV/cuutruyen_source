<template>
  <VueFinalModal
    class="flex justify-center items-center"
    content-class="flex flex-col w-full max-w-screen-sm h-[70vh] bg-gray-800 rounded-lg border border-gray-700 shadow-lg shadow-gray-900"
    overlay-transition="fade"
    content-transition="pop-fade"
  >
    <div class="p-4 flex-none">
      <div class="text-sm font-bold text-gray-200">Thuật toán nhận dạng số và tên chương</div>
    </div>

    <div class="p-4 grow">
      <Codemirror
        v-model="algorithm"
        :style="{ height: '100%' }"
        :extensions="extensions"
        :autofocus="true"
        :indent-with-tab="true"
        :tab-size="2"
      />
    </div>

    <div class="p-4 flex-none flex justify-end">
      <button class="button button-primary px-4 py-2" @click="confirm">Lưu lại</button>
    </div>
  </VueFinalModal>
</template>

<script setup>
import { VueFinalModal } from 'vue-final-modal'
import { Codemirror } from 'vue-codemirror'
import { javascript } from '@codemirror/lang-javascript'
import { oneDark } from '@codemirror/theme-one-dark'
import { ref, onMounted } from 'vue'

const props = defineProps({
  algorithm: {
    type: String,
    required: true
  }
})
const emit = defineEmits(['close', 'confirm'])

const extensions = [javascript(), oneDark]

const algorithm = ref(props.algorithm)

const confirm = () => {
  emit('confirm', algorithm.value)
}

onMounted(() => {
  algorithm.value = props.algorithm
})
</script>
