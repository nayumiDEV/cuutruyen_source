<template>
  <router-link :to="{ name: 'Manga', params: { id: manga.id } }" class="flex p-2 hover:bg-gray-300 fine-transition">
    <img class="h-16 rounded-lg mr-2 w-auto" :src="manga.cover_url | imageUrl" width="320" height="480" :alt="manga.name">

    <div class="">
      <h3 class="text-gray-800 font-bold truncate">{{ manga.name }}</h3>

      <div class="font-semibold text-gray-600 text-sm">{{ manga.author_name }}</div>
    </div>
  </router-link>
</template>

<script>
import { fullUrl } from '@/utils/get-url'

export default {
  props: {
    manga: {
      type: Object
    }
  },

  filters: {
    imageUrl (path) {
      return fullUrl(path)
    }
  }
}
</script>
