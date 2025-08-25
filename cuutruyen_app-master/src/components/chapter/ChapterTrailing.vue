<template>
  <div class="w-full h-[calc(100vh-2.5rem-60px)] max-w-screen-md mx-auto px-2 flex flex-col justify-between overflow-y-auto select-none">
    <div class="pt-12 mb-12">
      <router-link
        :to="{ name: 'Manga', params: { id: manga.id } }"
        class="text-sm text-gray-400 hover:text-gray-200 py-1 flex items-center gap-2">
        <ArrowLeftIcon class="inline-block mr-1" :size="16" /> {{ manga.name }}
      </router-link>
    </div>

    <div class="mb-12">
      <h1 class="text-xl text-gray-100 mb-6">
        <span>Kết thúc chương {{ chapter.number }}</span>
      </h1>

      <div class="flex items-stretch flex-col gap-2">
        <div>
          <router-link
            v-if="chapter.next_chapter_id"
            :to="{ name: 'Chapter', params: { mangaId: manga.id, id: chapter.next_chapter_id } }"
            class="flex justify-center items-center button bg-blue-900 hover:bg-blue-800 text-blue-100 px-3 py-2 text-sm uppercase font-bold"
          >
            Chương sau
          </router-link>

          <button
            v-else
            class="flex justify-center items-center button bg-gray-900 bg-opacity-20 text-gray-100 text-opacity-20 px-3 py-2 text-sm uppercase font-bold cursor-default w-full"
            disabled
          >
            Chương sau
          </button>
        </div>

        <div>
          <router-link
            v-if="chapter.previous_chapter_id"
            :to="{ name: 'Chapter', params: { mangaId: manga.id, id: chapter.previous_chapter_id } }"
            class="flex justify-center items-center button bg-gray-800 hover:bg-gray-700 text-gray-100 px-3 py-2 text-sm uppercase font-bold"
          >
            Chương trước
          </router-link>

          <button
            v-else
            class="flex justify-center items-center button bg-gray-900 bg-opacity-20 text-gray-100 text-opacity-20 px-3 py-2 text-sm uppercase font-bold cursor-default w-full"
            disabled
          >
            Chương trước
          </button>
        </div>

        <div class="text-sm flex flex-col items-center mt-3">
          <div class="max-w-md text-center">
            <a href="https://www.messenger.com/channel/CuuTruyenTranh" target="_blank" class="text-yellow-400 hover:text-yellow-200 transition font-bold flex gap-2 items-center">
              <span>Tham gia kênh thông báo của Cứu Truyện</span>
            </a>
          </div>
        </div>
      </div>
    </div>

    <div class="text-gray-600 text-sm flex flex-col items-center pb-12">
      <div class="max-w-md text-center">
        <div class="mb-2">
          Bạn đang xem và đọc truyện tranh manga (manhua, manhwa) <strong>{{ chapter.manga.name }}</strong> tại Cứu Truyện.
        </div>

        <div class="mb-2">
          Chương (chapter, chap) hiện tại mà bạn đang đọc là <strong>chapter {{ chapter.number }}</strong>
          <span v-if="chapter.name && chapter.name.length > 0"> ({{ chapter.name }})</span>.
        </div>

        <div v-if="chapter.next_chapter_id" class="mb-2">
          <span>Chương kế tiếp của truyện là <strong>chapter {{ chapter.next_chapter_number }}</strong></span>.
        </div>

        <div>{{ manga.description }}</div>
      </div>
    </div>
  </div>
</template>

<script>
import ArrowLeftIcon from 'vue-material-design-icons/ArrowLeft.vue'

export default {
  components: {
    ArrowLeftIcon
  },

  props: {
    manga: Object,
    chapter: Object,
    team: Object,
    activeZoom: Boolean
  }
}
</script>
