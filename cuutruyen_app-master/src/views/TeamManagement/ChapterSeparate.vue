<template>
  <div>
    <template v-if="loading">
      <LoadingScreen />
    </template>

    <template v-else-if="error">
      <ErrorScreen />
    </template>

    <template v-else-if="chapter">
      <div class="common-container">
        <h2 class="text-lg font-head font-semibold text-gray-700 mt-12 mb-4 hover:text-blue-700">
          <router-link :to="{ name: 'TeamChapterManagement', params: { translationId: chapter.translation.id } }">
            {{ chapter.translation.manga.name }}
          </router-link>
        </h2>

        <h1 class="text-3xl font-head font-bold text-gray-800 mb-12">Ch. {{ chapter.number }} - {{ chapter.name || 'Không có tiêu đề' }}</h1>
      </div>

      <div class="common-container">
        <form @submit.prevent="formSubmit">
          <div class="mb-8">
            <template v-if="chapter.pages.length > 0">
              <div class="mb-8 grid grid-custom gap-4">
                <div v-for="(page, index) in chapter.pages" :key="page.index" v-show="!page.isMarkedForDestruction" class="relative">
                  <a
                    @click="chooseSeparate(index)"
                    class="block overflow-hidden w-32 h-32 rounded-lg cursor-pointer border-4"
                    :class="{ 'opacity-40': page.isMarkedForDestruction, 'border-blue-700': page.selected }">
                    <img v-if="page.imageNormalUrl" :src="page.imageNormalUrl" class="w-full h-full object-cover" alt="">
                    <img v-else :src="page.imageOriginalUrl" class="w-full h-full object-cover" alt="">
                  </a>
                  <div class="truncate mt-1 text-sm text-gray-700 font-bold" :title="page.imageFilename">{{ page.imageFilename }}</div>
                </div>
              </div>
            </template>
          </div>

          <div v-if="newChapter" class="mb-8">
            <h3 class="text-lg text-gray-800 mb-8">Tách ra chương mới</h3>

            <label for="chapterNumber" class="block mb-4 text-xs uppercase tracking-wide text-gray-700 font-semibold">Số chương</label>
            <div class="mb-8">
              <input
                v-model="newChapter.number"
                id="chapterNumber"
                class="input"
                type="text" placeholder="Số chương"
              >
            </div>
            <label for="chapterName" class="block mb-4 text-xs uppercase tracking-wide text-gray-700 font-semibold">Tên chương</label>
            <div class="mb-8">
            <input
              v-model="newChapter.name"
              id="chapterName"
              class="input mb-8"
              type="text" placeholder="Tên chương"
            >
            </div>
          </div>

          <div>
            <button class="button px-8 py-3 text-xl"
              :class="{ 'button-primary': !disallowSave, 'button-disabled': disallowSave }"
              :disabled="disallowSave">
              Tách chương
            </button>
          </div>
        </form>
      </div>
    </template>

    <Tinybox
      v-model="zoomIndex"
      :images="images"
    />
  </div>
</template>

<script>
import { Translation, Chapter } from '@/models'
import Tinybox from 'vue-tinybox'

export default {
  components: {
    Tinybox
  },

  data () {
    return {
      chapter: null,
      newChapter: null,
      drag: false,
      adding: false,
      loading: false,
      error: false,
      zoomIndex: null,
      startIndex: null,
      endIndex: null
    }
  },

  computed: {
    disallowSave () {
      return this.isPreparing || this.adding || this.hasDenied
    },

    isPreparing () {
      return this.chapter.pages.some(p => p.preparing)
    },

    hasDenied () {
      return this.chapter.pages.some(p => p.denied)
    },

    images () {
      if (!this.chapter) {
        return []
      }

      return this.chapter.pages.map(p => {
        if (p.imageNormalUrl) {
          return { src: p.imageNormalUrl, caption: p.imageFilename }
        } else if (p.imageOriginalUrl) {
          return { src: p.imageOriginalUrl, caption: p.imageFilename }
        } else {
          return { src: p.blobUrl, caption: p.imageFilename }
        }
      })
    }
  },

  async mounted () {
    this.loading = true
    try {
      this.chapter = (await Chapter.includes(['pages', { translation: 'manga' }]).order({ 'pages.order': 'asc' }).find(this.$route.params.chapterId)).data
      this.translation = this.chapter.translation
      this.newChapter = new Chapter({
        translation: this.translation,
        pages: [],
        order: this.chapter.order + 1
      })
    } catch (error) {
      this.error = true
      throw error
    } finally {
      this.loading = false
    }
  },

  methods: {
    async formSubmit () {
      this.adding = true

      try {
        const translation = (await Translation.includes(['chapters']).order({ 'chapter.order': 'asc' }).find(this.translation.id)).data
        translation.chapters.forEach(chapter => {
          if (chapter.order >= this.newChapter.order) {
            chapter.order = chapter.order + 1
          }
        })
        await translation.save({ with: 'chapters' })
        await this.newChapter.save({ with: ['pages', 'translation'] })

        this.$notify({
          type: 'success',
          text: 'Cập nhật chương thành công!'
        })

        this.chapter = (await Chapter.includes(['pages', { translation: 'manga' }]).order({ 'pages.order': 'asc' }).find(this.$route.params.chapterId)).data
        this.translation = this.chapter.translation
        const lastNumber = this.newChapter.number
        let nextNumber = null
        if (!isNaN(lastNumber) && lastNumber !== 0) {
          nextNumber = lastNumber - 1
        }
        this.newChapter = new Chapter({
          translation: this.translation,
          pages: [],
          order: this.chapter.order + 1,
          name: this.newChapter.name,
          number: nextNumber || ''
        })
        this.startIndex = null
        this.endIndex = null
      } catch (error) {
        this.$notify({
          type: 'error',
          text: 'Có lỗi xảy ra khi cập nhật chương này.'
        })

        throw error
      } finally {
        this.adding = false
      }
    },

    filesUpdateOrder () {
      let incOrder = 0
      for (let i = 0; i < this.chapter.pages.length; i++) {
        this.chapter.pages[i].order = incOrder
        incOrder++
      }
    },

    chooseSeparate (index) {
      if (this.startIndex === null) {
        this.startIndex = index
        this.$set(this.chapter.pages[index], 'selected', true)
        this.newChapter.pages = [this.chapter.pages[index]]
      } else if (this.endIndex === null && index > this.startIndex) {
        this.endIndex = index
        const selectedPages = this.chapter.pages.filter((page, index) => {
          return index >= this.startIndex && index <= this.endIndex
        })
        selectedPages.forEach(page => {
          this.$set(page, 'selected', true)
        })
        this.newChapter.pages = selectedPages
      } else {
        this.startIndex = null
        this.endIndex = null
        this.newChapter.pages.forEach(page => {
          this.$set(page, 'selected', false)
        })
        this.newChapter.pages = []

        this.startIndex = index
        this.$set(this.chapter.pages[index], 'selected', true)
        this.newChapter.pages = [this.chapter.pages[index]]
      }
    }
  }
}
</script>

<style scoped>
.grid-form {
  grid-template-columns: 2fr 5fr;
}

.grid-custom {
  grid-template-columns: repeat( auto-fit, 8rem );
}

.ghost img {
  /* @apply opacity-50; */
}
</style>
