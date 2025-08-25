<template>
  <div
    v-if="pages && pages.length > 0 && currentPage"
    class="fixed z-50 flex items-center h-10 bg-gray-300 justify-between tooltip overflow-hidden shadow-lg"
    :class="{
      hidden: isShowSidebar
      }"
  >
    <button
      class="button-bare h-full px-6 bg-blue-600 hover:bg-blue-800 text-white text-sm fine-transition flex items-center justify-center w-16"
      @click.prevent="$emit('showSidebar')"
    >
      <div class="mr-1">{{ chapter.comments_count }}</div>
      <CommentIcon :size="14" />
    </button>
    <div class="flex items-center px-2 w-full justify-center max-w-[48rem]"
      :class="{
        'flex-row': direction === 'rtl',
        'flex-row-reverse': direction === 'ltr',
        }"
    >
      <router-link
        v-if="chapter.next_chapter_id"
        :to="{ name: 'Chapter', params: { mangaId: chapter.manga.id, id: chapter.next_chapter_id } }"
        class="text-blue-200 text-xs uppercase font-bold rounded h-7 px-2 bg-blue-700 hover:bg-blue-800 transition flex items-center justify-center mx-1 flex-none"
      >
        <template v-if="direction === 'rtl'">
          <ChevronLeftIcon :size="16" /><span class="hidden lg:block"> Tiếp</span>
        </template>

        <template v-else>
          <span class="hidden lg:block"> Tiếp</span><ChevronRightIcon :size="16" />
        </template>
      </router-link>
      <button
        v-else
        class="text-blue-200 text-xs uppercase font-bold text-opacity-70 rounded h-7 px-2 bg-blue-700 bg-opacity-40 flex items-center justify-center cursor-default mx-1 flex-none"
        disabled
      >
        <template v-if="direction === 'rtl'">
          <ChevronLeftIcon :size="16" /><span class="hidden lg:block"> Tiếp</span>
        </template>

        <template v-else>
          <span class="hidden lg:block">Tiếp </span><ChevronRightIcon :size="16" />
        </template>
      </button>
      <button
        @click.prevent="$emit('showQuickChaptersList')"
        class="h-7 px-1 bg-gray-400 text-sm w-full flex-grow fine-transition border-gray-400 uppercase relative truncate rounded mx-1 cursor-pointer"
      >
        <div class="absolute top-0 left-0 w-full h-full flex"
          :class="{
            'justify-end': direction === 'rtl',
            'justify-start': direction === 'ltr',
            }"
        >
          <div class="bg-gray-500 h-full" :style="{ width: ((currentPageIndex + 1) / totalPages) * 100 + '%' }"></div>
        </div>
        <div class="relative">Chương {{ chapter.number }}</div>
      </button>
      <router-link
        v-if="chapter.previous_chapter_id"
        :to="{ name: 'Chapter', params: { mangaId: chapter.manga.id, id: chapter.previous_chapter_id } }"
        class="text-gray-700 hover:text-gray-300 rounded h-7 px-2 bg-gray-400 hover:bg-gray-800 flex items-center justify-center mx-1 flex-none"
      >
        <template v-if="direction === 'rtl'">
          <ChevronRightIcon :size="16" />
        </template>

        <template v-else>
          <ChevronLeftIcon :size="16" />
        </template>
      </router-link>
      <button
        v-else
        class="text-gray-500 rounded h-7 px-2 flex items-center justify-center cursor-default mx-1 flex-none"
        disabled
      >
        <template v-if="direction === 'rtl'">
          <ChevronRightIcon :size="16" />
        </template>

        <template v-else>
          <ChevronLeftIcon :size="16" />
        </template>
      </button>
    </div>
    <button
      class="button-bare h-full px-6 bg-gray-400 hover:bg-gray-700 hover:text-gray-300 text-sm md:text-base fine-transition flex justify-center items-center w-16"
      @click.prevent="$emit('toTop')"
    >
      <ArrowUpIcon :size="14" />
    </button>
  </div>
</template>

<script>
import CommentIcon from 'vue-material-design-icons/Comment.vue'
import ArrowUpIcon from 'vue-material-design-icons/ArrowUp.vue'
import ChevronLeftIcon from 'vue-material-design-icons/ChevronLeft.vue'
import ChevronRightIcon from 'vue-material-design-icons/ChevronRight.vue'
import { mapGetters } from 'vuex'

export default {
  props: {
    chapter: Object,
    pages: Array,
    isShowSidebar: Boolean,
    currentPage: Object,
    totalPages: Number,
    direction: String
  },

  components: {
    CommentIcon,
    ArrowUpIcon,
    ChevronLeftIcon,
    ChevronRightIcon
  },

  computed: {
    ...mapGetters([
      'isShowToolbar'
    ]),

    currentPageIndex () {
      if (!this.currentPage) {
        return null
      }
      return this.pages.findIndex((p) => p.id === this.currentPage.id)
    }
  }
}
</script>

<style scoped>
.tooltip {
  @apply w-full bottom-0 left-0;
}

@screen md {
  .tooltip {
    width: auto;
    min-width: 28rem;
    @apply rounded bottom-5 left-10;
  }
}
</style>
