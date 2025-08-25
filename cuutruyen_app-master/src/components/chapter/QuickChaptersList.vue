<template>
  <vue-final-modal
    v-model="show"
    classes="flex w-screen-md h-full justify-center items-center m-2"
    content-class="w-full max-w-screen-sm max-h-[80%] flex flex-col rounded-lg shadow-lg bg-gray-800 overflow-hidden text-gray-200"
  >
    <div class="flex-none flex justify-between items-center overflow-hidden px-4 py-3">
      <div class="font-bold text-gray-200 flex-grow truncate text-sm md:text-base">Chuyển chương</div>

      <button class="text-gray-200" @click="cancel">
        <CloseIcon />
      </button>
    </div>

    <div class="flex-grow overflow-y-auto px-4 py-3">
      <div v-if="chaptersLoading" class="flex justify-center items-center h-32">
        <Loading />
      </div>
      <div v-else-if="error" class="flex justify-center items-center h-32 text-sm text-gray-400">
        Có lỗi xảy ra khi tải danh sách chương. Vui lòng thử lại sau.
      </div>
      <div v-else class="grid grid-cols-4 gap-1">
        <router-link
          v-for="chapter in chapters"
          ref="chapters"
          :key="chapter.id"
          :to="{ name: 'Chapter', params: { mangaId: $route.params.mangaId, id: chapter.id } }"
          class="rounded fine-transition text-center px-1 py-1 h-[3rem] flex flex-col items-center justify-center gap-1 leading-tight"
          :class="{
            'bg-blue-700': chapter.id === Number($route.params.id),
            'bg-gray-800 hover:bg-gray-700': chapter.id !== Number($route.params.id)
          }"
        >
          <div class="text-xs hidden md:block text-white/70">Chương</div>
          <div class="text-xs font-bold line-clamp-2">{{ chapter.number }}</div>
        </router-link>
      </div>
    </div>
  </vue-final-modal>
</template>

<script>
import { getChapters } from '@/apis/user'
import CloseIcon from 'vue-material-design-icons/Close.vue'
import Loading from '@/components/Loading'

export default {
  name: 'QuickChaptersList',

  components: {
    CloseIcon,
    Loading
  },

  props: {
    value: Boolean
  },

  data () {
    return {
      show: false,
      chapters: [],
      chaptersLoading: true,
      error: false
    }
  },
  methods: {
    open () {
      this.show = true
    },

    cancel () {
      this.$emit('input', false)
    },

    async loadChapters () {
      this.chaptersLoading = true
      try {
        const response = await getChapters(this.$route.params.mangaId)
        this.chapters = response.data
      } catch (error) {
        this.error = true
      } finally {
        this.chaptersLoading = false

        this.$nextTick(() => {
          // Scroll to the active chapter
          if (this.$refs.chapters) {
            const activeChapterIndex = this.$refs.chapters.findIndex(
              (ref, index) => this.chapters[index].id === Number(this.$route.params.id)
            )
            if (activeChapterIndex !== -1) {
              this.$refs.chapters[activeChapterIndex].$el.scrollIntoView({ block: 'center' })
            }
          }
        })
      }
    }
  },

  watch: {
    value (to) {
      if (to) {
        this.show = true
        if (this.chapters.length === 0) {
          this.loadChapters()
        }
      } else {
        this.show = false
      }
    },

    show (to, from) {
      if (!to) {
        this.cancel()
      }
    }
  }
}
</script>
