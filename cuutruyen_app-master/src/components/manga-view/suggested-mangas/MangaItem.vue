<template>
  <div class="flex flex-none w-full">
    <router-link
      :to="{ name: 'Manga', params: { id: manga.id } }"
      class="flex-none rounded-lg overflow-hidden shadow hover:shadow-lg fine-transition w-[2.5rem] h-[3.75rem]"
    >
      <picture>
        <source :srcset="getUrl(manga.cover_mobile_url)" media="(max-width: 640px)">
        <img class="w-full h-auto object-cover"
          :src="getUrl(manga.cover_url)"
          :alt="manga.name" loading="lazy" width="320" height="480">
      </picture>
    </router-link>

    <div class="px-2 w-full flex flex-col items-start justify-start overflow-hidden">
      <router-link :to="{ name: 'Manga', params: { id: manga.id } }" class="overflow-hidden">
        <h3 class="text-gray-600 font-bold text-sm mb-1 line-clamp-2">{{ manga.name }}</h3>
      </router-link>

      <h4 class="text-xs uppercase tracking-wide color text-gray-500 line-clamp-1">
        <router-link
          v-if="manga.newest_chapter_id"
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

export default {
  props: {
    manga: {
      type: Object
    },
    index: {
      type: Number
    }
  },

  methods: {
    getUrl (path) {
      return fullUrl(path)
    }
  }
}
</script>
