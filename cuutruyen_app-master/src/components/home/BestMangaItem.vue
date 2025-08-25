<template>
  <div class="relative w-72 lg:w-96 px-5 py-4 bg-blue-300 hover:bg-white hover:shadow fine-transition rounded-lg h-full">
    <div class="flex h-full gap-2">
      <div class="w-16 h-full flex-none">
      <picture>
        <source :srcset="getUrl(manga.cover_mobile_url)" media="(max-width: 640px)">
        <img
          class="rounded-lg h-full w-auto"
          :src="getUrl(manga.cover_url)"
          :alt="manga.name">
      </picture>
      </div>

      <div class="flex-grow truncate">
        <router-link :to="{ name: 'Manga', params: { id: manga.id } }" class="mb-2 block">
          <h3 class="text-black text-opacity-90 font-extrabold truncate">{{ manga.name }}</h3>
        </router-link>

        <router-link
          v-if="manga.newest_chapter_id"
          :to="{ name: 'Chapter',
            params: { mangaId: manga.id, id: manga.newest_chapter_id }
            }"
          class="mb-1"
        >
          <h4 class="text-sm uppercase tracking-wide text-black text-opacity-60 truncate">
            <span class="font-semibold">Chương {{ manga.newest_chapter_number }}</span>
            -
            <span>{{ manga.newest_chapter_created_at | humanizeTime }}</span>
          </h4>
        </router-link>

        <div v-if="viewsCountType === 'all'" class="text-sm uppercase tracking-wide text-black text-opacity-60">{{ manga.views_count | humanizeNumber }} lượt xem</div>
        <div v-if="viewsCountType === 'week'" class="text-sm uppercase tracking-wide text-black text-opacity-60">{{ manga.views_count_week | humanizeNumber }} lượt xem</div>
        <div v-if="viewsCountType === 'month'" class="text-sm uppercase tracking-wide text-black text-opacity-60">{{ manga.views_count_month | humanizeNumber }} lượt xem</div>
      </div>
    </div>

    <div class="z-20 absolute top-0 right-0 text-3xl lg:text-4xl text-gray-800 text-opacity-10 font-bold mr-1 mt-1 select-none">{{ index + 1 | formatIndex }}</div>
  </div>
</template>

<script>
import { fullUrl } from '@/utils/get-url'

export default {
  props: {
    manga: {
      type: Object
    },
    index: Number,
    viewsCountType: String
  },

  filters: {
    imageUrl (path) {
      return fullUrl(path)
    },

    formatIndex (number) {
      return String(number).padStart(2, '0')
    }
  },

  methods: {
    getUrl (path) {
      return fullUrl(path)
    }
  }
}
</script>
