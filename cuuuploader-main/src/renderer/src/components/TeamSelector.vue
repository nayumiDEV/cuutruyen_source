<template>
  <div class="flex items-center gap-2">
    <div class="text-xs font-bold uppercase text-gray-500">Nhóm hiện tại</div>
    <button
      type="button"
      class="flex gap-1 items-center text-xs font-bold uppercase text-gray-300 p-1 bg-gray-800 rounded"
      @click="isOpen = !isOpen"
    >
      <div>{{ currentTeam?.name }}</div>
      <ChevronDown class="w-4 h-4" />
    </button>

    <Transition name="fade">
      <div
        v-if="isOpen"
        class="absolute top-0 left-0 w-full h-full bg-black/50 flex justify-center items-center"
        @click="isOpen = false"
      >
        <div class="bg-gray-800 rounded-md overflow-hidden w-64 flex flex-col items-stretch">
          <button
            v-for="team in teams"
            :key="team.id"
            class="flex items-center gap-2 p-2 hover:bg-gray-700 cursor-pointer transition duration-300 text-left text-sm font-bold uppercase text-gray-300"
            @click="teamSelected(team)"
          >
            <div class="grow">{{ team.name }}</div>
            <div class="flex-none">
              <Check v-if="team.id === currentTeam?.id" class="w-4 h-4" />
            </div>
          </button>
        </div>
      </div>
    </Transition>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useStore } from '../composables/store'
import { ChevronDown, Check } from 'mdue'
import { useRouter } from 'vue-router'

const router = useRouter()
const { teams, currentTeam } = useStore()

const isOpen = ref(false)

const teamSelected = (team) => {
  isOpen.value = false
  currentTeam.value = team
  router.push('/')
}
</script>
