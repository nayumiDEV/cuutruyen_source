<template>
  <div class="px-4 py-2 hover:bg-gray-100 fine-transition rounded-lg my-1 flex justify-between">
    <router-link
      :to="{ name: 'OfflineChapter', params: { mangaId: chapter.manga.id, id: chapter.id } }"
      class="flex-grow truncate">
      <span class="font-bold text-gray-900 mr-2">Chương {{ chapter.number }}. </span>
      <span v-if="chapter.name" class="text-gray-700">{{ chapter.name }}</span>
      <span v-else class="italic text-gray-700">Không có tiêu đề</span>
    </router-link>
    <div>
      <button
        type="button"
        class="button-bare bg-red-300 hover:bg-red-400 text-red-800 p-2 rounded-full"
        @click="deleteChapter"
      >
        <DeleteIcon :size="12" />
      </button>
    </div>
  </div>
</template>

<script>
import db from '@/db'
import DeleteIcon from 'vue-material-design-icons/Delete.vue'

export default {
  props: {
    chapter: Object
  },

  components: {
    DeleteIcon
  },

  methods: {
    async deleteChapter () {
      await db.transaction('rw', db.chapters, db.mangas, async () => {
        await db.chapters.where({ id: this.chapter.id }).delete()
        const count = await db.chapters.where({ 'manga.id': this.chapter.manga.id }).count()
        if (count === 0) {
          await db.mangas.where({ id: this.chapter.manga.id }).delete()
        }
      })

      this.$emit('reload')
    }
  }
}
</script>
