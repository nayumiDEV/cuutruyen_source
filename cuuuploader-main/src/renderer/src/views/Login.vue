<template>
  <div class="flex flex-col items-center justify-center h-screen">
    <div class="text-sm font-bold text-gray-400 mb-10">Đăng nhập vào Cứu Truyện</div>

    <form @submit.prevent="handleLogin">
      <input
        v-model="username"
        class="w-full p-2 rounded-md bg-gray-800 text-white outline-none focus:ring focus:ring-gray-700 transition duration-300 mb-4"
        type="text"
        placeholder="Tên đăng nhập"
      />
      <input
        v-model="password"
        class="w-full p-2 rounded-md bg-gray-800 text-white outline-none focus:ring focus:ring-gray-700 transition duration-300 mb-4"
        stype="password"
        placeholder="Mật khẩu"
      />
      <button
        class="w-full p-2 rounded-md bg-blue-500 text-white outline-none focus:ring focus:ring-gray-700 transition duration-300 font-bold"
        type="submit"
      >
        Đăng nhập
      </button>
    </form>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useStore } from '../composables/store'
import { useRouter } from 'vue-router'
import { useToast } from 'vue-toastification'

const toast = useToast()
const { setAuthToken, setCurrentUser, setCurrentTeam, authToken, currentUser } = useStore()
const router = useRouter()

const username = ref('')
const password = ref('')

const handleLogin = async () => {
  try {
    const { currentUser, authToken } = await window.electronAPI.login(
      username.value,
      password.value
    )

    let currentTeam = null
    if (currentUser.teams && currentUser.teams.length) {
      currentTeam = currentUser.teams[0]
    }

    await setAuthToken(authToken)
    await setCurrentUser(currentUser)
    await setCurrentTeam(currentTeam)

    router.push('/')
  } catch (error) {
    if (error.message) {
      toast.error(error.message)
    } else {
      toast.error('Đăng nhập thất bại vi lỗi không rõ nguyên nhân')
    }
  }
}

onMounted(async () => {
  if (authToken.value && currentUser.value) {
    router.push('/')
  }
})
</script>
