<template>
  <div class="h-full w-full flex flex-col">
    <Header class="flex-none" />

    <div class="p-4 grow overflow-y-auto">
      <div class="mx-auto max-w-screen-sm flex justify-between items-center gap-2">
        <div class="text-lg font-extrabold text-gray-300">Danh sách truyện</div>

        <div class="">
          <form @submit.prevent="getMangas">
            <input
              v-model="keyword"
              type="text"
              class="w-full p-2 rounded-md h-7 text-sm bg-gray-800 outline-none focus:ring focus:ring-gray-700 transition duration-300"
              placeholder="Tìm kiếm..."
            />
          </form>
        </div>
      </div>

      <div v-if="isLoading" class="h-full">
        <Loading />
      </div>

      <div v-else-if="mangas.length === 0" class="h-full">
        <div class="text-lg font-extrabold text-gray-300">Không tìm thấy truyện</div>
      </div>

      <div v-else class="mt-4 flex flex-col gap-1 mx-auto max-w-screen-sm">
        <router-link
          v-for="manga in mangas"
          :key="manga.id"
          class="first:rounded-t last:rounded-b bg-gray-800 hover:bg-gray-700 transition duration-300 flex gap-2 cursor-pointer"
          :to="`/manga/${manga.id}`"
        >
          <div class="w-16 p-2 flex-none">
            <img :src="manga.cover_url" alt="Cover" class="w-full rounded" />
          </div>
          <div class="p-2 grow">
            <div class="text-sm font-bold">{{ manga.name }}</div>
            <div class="text-xs text-gray-400">{{ manga.author.name }}</div>
            <div class="text-xs text-gray-400">{{ manga.chapters_count }} chương</div>
          </div>
        </router-link>
      </div>
    </div>
  </div>
</template>

<script setup>
import { useStore } from '../composables/store'
import { onMounted, ref, watch } from 'vue'
import { useRouter } from 'vue-router'
import Header from '../components/Header.vue'
import { useToast } from 'vue-toastification'

const toast = useToast()
const { authToken, currentUser, currentTeam } = useStore()
const router = useRouter()

const mangas = ref([])
const keyword = ref('')
const isLoading = ref(true)

const getMangas = async () => {
  isLoading.value = true
  try {
    const response = await window.electronAPI.getTeamMangas(
      currentTeam.value.id,
      keyword.value,
      1,
      20
    )
    mangas.value = response.data
  } catch (error) {
    if (error.message) {
      toast.error(error.message)
    } else {
      toast.error('Lấy danh sách truyện thất bại vi lỗi không rõ nguyên nhân')
    }
  } finally {
    isLoading.value = false
  }
}

onMounted(async () => {
  if (!authToken.value || !currentUser.value) {
    router.push('/login')
  } else {
    getMangas()
  }
})

watch(currentTeam, () => {
  getMangas()
})
</script>
