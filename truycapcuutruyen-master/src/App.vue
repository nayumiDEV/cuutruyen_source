<template>
  <header class="font-bold text-gray-100 text-lg uppercase text-center w-full px-2 py-12">
    Truy cập Cứu Truyện
  </header>
  <main class="max-w-screen-sm mx-auto px-2">
    <div class="mb-12">
      <div class="text-xs font-bold text-gray-300 uppercase mb-4">
        Trạng thái máy chủ
      </div>

      <div class="bg-gray-800 rounded text-center">
        <div v-if="healthcheckStatus === 'loading'" class="flex justify-center items-center h-32">
          <Loading class="animate-spin text-2xl" />
        </div>
        <div v-else-if="healthcheckStatus === 'up'" class="flex items-center justify-center flex-col gap-3 h-32">
          <div class="rounded border border-green-500 text-green-500 px-4 py-2">Đang trực tuyến</div>
          <div class="text-xs text-gray-400">Nếu bạn không thể truy cập Cứu Truyện, rất có thể nhà mạng của bạn đang chặn Cứu Truyện.</div>
        </div>
        <div v-else class="flex items-center justify-center flex-col gap-3 h-32">
          <div class="rounded border border-red-500 text-red-500 px-4 py-2">Ngoại tuyến</div>
          <div>Cứu Truyện có thể đang gặp vấn đề hoặc đang bảo trì.</div>
        </div>
      </div>
    </div>
    <div class="mb-12">
      <div class="text-xs font-bold text-gray-300 uppercase mb-4">
        Các tên miền của Cứu Truyện
      </div>

      <table class="table-auto border-collapse border border-gray-500 w-full">
        <tbody>
          <tr>
            <td class="border border-gray-500 p-2">Tên miền chính thức</td>
            <td class="border border-gray-500 p-2 flex flex-col gap-2 items-start">
              <a href="https://cuutruyen.net" class="rounded border border-green-500 text-green-500 px-1 py-0.5">cuutruyen.net</a>
            </td>
          </tr>
          <tr>
            <td class="border border-gray-500 p-2">Tên miền phụ</td>
            <td class="border border-gray-500 p-2 flex flex-col gap-2 items-start">
              <a href="https://nettrom.com" class="rounded border border-green-500 text-green-500 px-1 py-0.5">nettrom.com</a>
              <a href="https://hetcuutruyen.net" class="rounded border border-green-500 text-green-500 px-1 py-0.5">hetcuutruyen.net</a>
              <a href="https://cuutruyenpip7z.site" class="rounded border border-green-500 text-green-500 px-1 py-0.5">cuutruyenpip7z.site</a>
              <a href="https://cuutruyen5c844.site" class="rounded border border-green-500 text-green-500 px-1 py-0.5">cuutruyen5c844.site</a>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <div class="mb-12">
      <div class="text-xs font-bold text-gray-300 uppercase mb-4">
        Truy cập Cứu Truyện khi bị chặn
      </div>

      <div class="mb-4">Chọn hệ điều hành của bạn:</div>

      <div class="flex flex-wrap justify-between gap-4 mb-4">
        <button class="os-button" :class="{ 'os-button-active': os === 'windows' }" type="button" @click="changeOS('windows')">
          <MicrosoftWindows />
          <div class="text-xs">Windows</div>
        </button>
        <button class="os-button" :class="{ 'os-button-active': os === 'linux' }" type="button" @click="changeOS('linux')">
          <Ubuntu />
          <div class="text-xs">Linux</div>
        </button>
        <button class="os-button" :class="{ 'os-button-active': os === 'macos' }" type="button" @click="changeOS('macos')">
          <AppleFinder />
          <div class="text-xs">macOS</div>
        </button>
        <button class="os-button" :class="{ 'os-button-active': os === 'android' }" type="button" @click="changeOS('android')">
          <Android />
          <div class="text-xs">Android</div>
        </button>
        <button class="os-button" :class="{ 'os-button-active': os === 'ios' }" type="button" @click="changeOS('ios')">
          <Apple />
          <div class="text-xs">iOS</div>
        </button>
      </div>

      <div v-if="os" class="">
        <WindowsInstruction v-if="os === 'windows'" />
        <LinuxInstruction v-if="os === 'linux'" />
        <MacosInstruction v-if="os === 'macos'" />
        <AndroidInstruction v-if="os === 'android'" />
        <IosInstruction v-if="os === 'ios'" />
      </div>
    </div>
  </main>
</template>

<script setup>
import ky from 'ky'
import { MicrosoftWindows, Apple, AppleFinder, Android, Ubuntu, Loading } from 'mdue'
import WindowsInstruction from './components/WindowsInstruction.vue'
import LinuxInstruction from './components/LinuxInstruction.vue'
import MacosInstruction from './components/MacosInstruction.vue'
import AndroidInstruction from './components/AndroidInstruction.vue'
import IosInstruction from './components/IosInstruction.vue'
import { ref, onMounted } from 'vue'

const os = ref(null)
const healthcheckStatus = ref('loading')

const changeOS = (to) => {
  os.value = to
}

onMounted(async () => {
  const json = await ky.post('https://cuutruyen-healthcheck-worker.cuutruyen.workers.dev/', { retry: 0, timeout: 3000 }).json()
  if (json && json.up) {
    healthcheckStatus.value = 'up'
  } else {
    healthcheckStatus.value = 'down'
  }
})
</script>

<style>
.os-button {
  @apply bg-gray-800 border border-transparent p-4 text-3xl rounded flex flex-1 flex-col items-center;
}

.os-button-active {
  @apply text-green-500 border-green-800 border-green-500;
}
</style>
