<template>
  <div>
    <div class="rounded-lg bg-gray-100 h-[20.75rem] flex items-center justify-center" v-if="loading">
      <LoadingIcon :size="64" class="spin text-gray-500" />
    </div>
    <div class="flex flex-col gap-2" v-else>
      <MangaItem v-for="(manga, index) in mangas" :key="index" :manga="manga" />
    </div>
  </div>
</template>

<script>
import MangaItem from './suggested-mangas/MangaItem'
import LoadingIcon from 'vue-material-design-icons/Loading.vue'

export default {
  components: {
    MangaItem,
    LoadingIcon
  },

  props: {
    mangas: Array,
    loading: Boolean
  }
}
</script>
