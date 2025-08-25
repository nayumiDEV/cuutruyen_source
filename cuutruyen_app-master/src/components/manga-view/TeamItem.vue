<template>
  <div class="flex flex-col">
    <div class="flex items-center">
      <div class="avatar rounded-full w-10 h-10 flex flex-0 justify-center items-center text-lg bg-blue-700 text-blue-200 mr-3">
        {{ team.name[0] }}
      </div>

      <div class="">
        <a class="cursor-pointer font-bold text-gray-700 block">{{ team.name }}</a>
        <div class="text-sm text-gray-600 uppercase tracking-wide">{{ team.translations_count }} truyện đã đăng</div>
      </div>
    </div>

    <div v-if="team.facebook_address" class="flex items-center mt-2">
      <FacebookIcon class="text-blue-500 mr-2" :size="16" />
      <a
        class="text-gray-500 hover:text-blue-600 block transition rounded-lg text-sm"
        :href="`https://fb.com/${team.facebook_address}`"
        target="_blank"
        rel="noopener noreferrer"
      >
        fb.com/{{ team.facebook_address }}
      </a>
    </div>

    <div v-if="team.facebook_address" class="flex items-center mt-1">
      <FacebookMessengerIcon class="text-blue-500 mr-2" :size="16" />
      <a
        class="text-gray-500 hover:text-blue-600 block transition rounded-lg text-sm"
        :href="`https://m.me/${team.facebook_address}`"
        target="_blank"
        rel="noopener noreferrer"
      >
        m.me/{{ team.facebook_address }}
      </a>
    </div>
  </div>
</template>

<script>
import FacebookIcon from 'vue-material-design-icons/Facebook.vue'
import FacebookMessengerIcon from 'vue-material-design-icons/FacebookMessenger.vue'

export default {
  props: {
    team: Object
  },

  components: {
    FacebookIcon,
    FacebookMessengerIcon
  }
}
</script>
