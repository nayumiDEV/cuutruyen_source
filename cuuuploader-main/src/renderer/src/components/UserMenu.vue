<template>
  <button
    type="button"
    class="flex gap-2 items-center text-xs font-bold uppercase text-gray-300 p-1 bg-gray-800 rounded"
    @click="isOpen = !isOpen"
  >
    <div>{{ currentUser?.username }}</div>
    <Menu class="w-4 h-4 text-lg" />
  </button>

  <Transition name="fade">
    <div
      v-if="isOpen"
      class="absolute top-0 left-0 w-full h-full bg-black/50 flex justify-center items-center"
      @click="isOpen = false"
    >
      <div class="bg-gray-800 rounded-md overflow-hidden w-64 flex flex-col items-stretch">
        <button
          type="button"
          class="flex items-center gap-2 p-2 hover:bg-gray-700 cursor-pointer transition duration-300 text-left text-sm font-bold uppercase text-gray-300"
          @click="logout"
        >
          <div class="grow">Đăng xuất</div>
        </button>
      </div>
    </div>
  </Transition>
</template>

<script setup>
import { Menu } from 'mdue'
import { ref } from 'vue'
import { useStore } from '../composables/store'
import { useRouter } from 'vue-router'

const router = useRouter()
const { currentUser, setAuthToken, setCurrentUser, setCurrentTeam } = useStore()
const isOpen = ref(false)

const logout = async () => {
  isOpen.value = false
  await window.electronAPI.logout()
  await setAuthToken(null)
  await setCurrentUser(null)
  await setCurrentTeam(null)
  router.push('/login')
}
</script>
