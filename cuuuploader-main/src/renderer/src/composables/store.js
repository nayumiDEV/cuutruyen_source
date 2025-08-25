import { ref, computed } from 'vue'

const authToken = ref(null)
const currentUser = ref(null)
const teams = computed(() => currentUser.value?.teams || null)
const isInitialized = ref(false)
const currentTeam = ref(null)

const initialize = async () => {
  if (isInitialized.value) return
  authToken.value = await window.electronAPI.getConfigKey('authToken')
  currentUser.value = await window.electronAPI.getConfigKey('currentUser')
  currentTeam.value = await window.electronAPI.getConfigKey('currentTeam')
  isInitialized.value = true
}

export function useStore() {
  const setAuthToken = async (token) => {
    authToken.value = token
    await window.electronAPI.setConfigKey('authToken', token)
  }

  const setCurrentUser = async (user) => {
    currentUser.value = user
    await window.electronAPI.setConfigKey('currentUser', user)
  }

  const setCurrentTeam = async (team) => {
    currentTeam.value = team
    await window.electronAPI.setConfigKey('currentTeam', team)
  }

  return {
    authToken,
    currentUser,
    isInitialized,
    teams,
    currentTeam,
    setAuthToken,
    setCurrentUser,
    setCurrentTeam,
    initialize
  }
}
