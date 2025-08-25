<template>
  <div class="w-full flex flex-none flex-col justify-between items-stretch rounded-lg snap-start"
  >
    <router-link
      :to="{ name: 'Manga', params: { id: manga.id } }"
      class="block flex-grow rounded-lg shadow hover:shadow-lg fine-transition overflow-hidden relative"
    >
      <img class="w-full h-auto object-cover" :src="getUrl(manga.cover_url)"
        :srcset="`${getUrl(manga.cover_mobile_url)} 128w, ${getUrl(manga.cover_url)} 224w`"
        sizes="(max-width: 640px) 128px, 224px"
        :alt="manga.name" loading="lazy" width="320" height="480">

      <button class="absolute z-10 top-2 right-2 button button-circle border-2 border-white bg-red-700 hover:bg-red-900 text-red-100 h-7 w-7 lg:h-8 lg:w-8 flex items-center justify-center"
        @click.prevent="$emit('unfollow')"
      >
        <DeleteIcon :size="14" />
      </button>
    </router-link>

    <div class="mt-2">
      <router-link :to="{ name: 'Manga', params: { id: manga.id } }">
        <h3 class="text-gray-800 font-bold text-sm mb-1 line-clamp-2">{{ manga.name }}</h3>
      </router-link>

      <h4 class="text-xs uppercase tracking-wide color text-gray-700 line-clamp-1">
        <router-link
          v-if="manga.newest_chapter_id && manga.newest_chapter_number"
          :to="{ name: 'Chapter',
            params: { mangaId: manga.id, id: manga.newest_chapter_id }
            }"
        >
          <span class="font-semibold">C. {{ manga.newest_chapter_number }}</span>
          -
          <span>{{ manga.newest_chapter_created_at | humanizeTime }}</span>
        </router-link>
        <span v-else class="font-semibold">Chưa có chương</span>
      </h4>
    </div>
  </div>
</template>

<script>
import { fullUrl } from '@/utils/get-url'

import DeleteIcon from 'vue-material-design-icons/Delete.vue'

export default {
  props: {
    manga: {
      type: Object
    }
  },

  components: {
    DeleteIcon
  },

  methods: {
    getUrl (path) {
      return fullUrl(path)
    }
  }
}
</script>
