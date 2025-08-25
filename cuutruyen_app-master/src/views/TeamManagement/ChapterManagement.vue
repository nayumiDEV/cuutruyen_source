<template>
  <div>
    <template v-if="loading">
      <LoadingScreen />
    </template>

    <template v-else-if="error">
      <ErrorScreen />
    </template>

    <template v-else>
      <CuuHeading>{{ manga.name }}</CuuHeading>

      <div v-if="chapters.length > 0">
        <div class="common-container flex justify-end mb-12">
          <router-link
            :to="{ name: 'TeamChapterNew', params: { translationId: manga.translation.id } }"
            class="button button-primary px-6 py-3">
            Thêm chương mới
          </router-link>
        </div>

        <div class="common-container overflow-y-auto shadow-lg rounded-lg">
          <table class="table overflow-hidden min-w-full bg-white">
            <tr class="text-center bg-gray-200 text-gray-600 uppercase text-sm font-semibold border-b-2 border-gray-300">
              <th class="text-right w-2"></th>
              <th class="text-right">Số</th>
              <th class="text-left whitespace-nowrap">Tên chương</th>
              <th class="text-right">Trang</th>
              <th>Trạng thái</th>
              <th class="whitespace-nowrap">Tạo lúc</th>
              <th class="whitespace-nowrap">Sửa lúc</th>
              <th class="text-right whitespace-nowrap">Hành động</th>
            </tr>

            <draggable tag="tbody" v-model="chapters" @start="startDrag" @end="endDrag"
              v-bind="{ animation: 200, ghostClass: 'ghost' }" handle=".handle"
            >
              <ChapterListItem v-for="chapter in chapters" :key="chapter.id" :manga="manga" :chapter="chapter" :consumer="consumer" @deleteChapter="deletingChapter = chapter" />
            </draggable>
          </table>
        </div>
      </div>

      <EmptyScreen v-else message="Bạn chưa thêm chương nào cho truyện này.">
        <router-link
          :to="{ name: 'TeamChapterNew', params: { translationId: manga.translation.id } }"
          class="block button bg-blue-600 hover:bg-blue-700 text-white px-8 py-4">
          Thêm chương mới
        </router-link>
      </EmptyScreen>
    </template>

    <ChapterDeleteModal :manga="manga" :chapter="deletingChapter" @cancel="deletingChapter = null" @confirm="removeChapter(deletingChapter)" />
  </div>
</template>

<script>
import { getTeamManga, getTeamMangaChapters, deleteTeamChapter, changeChaptersOrderTeamManga } from '@/apis/team'
import Draggable from 'vuedraggable'
import ChapterDeleteModal from '@/components/team-management/ChapterDeleteModal'
import ChapterListItem from '@/components/team-management/ChapterListItem'
import { createConsumer } from '@rails/actioncable'

export default {
  components: {
    Draggable,
    ChapterDeleteModal,
    ChapterListItem
  },

  props: {
    layoutProps: {
      type: Object,
      default: null
    }
  },

  computed: {
    team () {
      return this.layoutProps.team
    }
  },

  data () {
    return {
      manga: null,
      chapters: null,
      deletingChapter: null,
      drag: false,
      loading: true,
      error: false,
      consumer: null
    }
  },

  async mounted () {
    try {
      this.loading = true
      await Promise.all([
        this.loadManga(),
        this.loadMangaChapters()
      ])
      this.consumer = createConsumer()
    } catch (error) {
      this.$handleError(error)
    } finally {
      this.loading = false
    }
  },

  methods: {
    async loadManga () {
      const response = await getTeamManga(this.team.id, this.$route.params.mangaId)
      this.manga = response.data
    },

    async loadMangaChapters () {
      const response = await getTeamMangaChapters(this.team.id, this.$route.params.mangaId)
      this.chapters = response.data
    },

    startDrag () {
      this.drag = true
    },

    async endDrag () {
      this.drag = false

      try {
        let incOrder = 0
        for (let i = this.chapters.length - 1; i >= 0; i--) {
          this.chapters[i].order = incOrder
          incOrder++
        }

        const chaptersOrder = this.chapters.map((chapter) => ({ id: chapter.id, order: chapter.order }))

        await changeChaptersOrderTeamManga(this.team.id, this.manga.id, {
          chapters: chaptersOrder
        })

        this.$notify({
          type: 'success',
          text: 'Đã lưu lại vị trí mới thành công!'
        })
      } catch (error) {
        this.loadMangaChapters()

        this.$notify({
          type: 'error',
          text: 'Có lỗi xảy ra khi lưu lại vị trí!'
        })

        throw error
      }
    },

    async removeChapter (chapter) {
      try {
        await deleteTeamChapter(this.team.id, chapter.id)

        this.$notify({
          type: 'success',
          text: 'Xóa chương thành công!'
        })

        this.loadMangaChapters()
      } catch (error) {
        this.$notify({
          type: 'error',
          text: 'Có lỗi xảy ra khi xóa chương.'
        })

        throw error
      }
    }
  },

  beforeDestroy () {
    if (this.consumer) {
      this.consumer.disconnect()
    }
  }
}
</script>

<style scoped>
.ghost {
  opacity: 0.5;
  background: #c8ebfb;
}
</style>
