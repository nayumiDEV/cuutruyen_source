<template>
  <div class="p-3 my-2 bg-gray-200 fine-transition rounded-lg">
    <div class="flex">
      <img class="h-16 rounded-lg mr-2 w-auto" :src="coverUrl" width="320" height="480" :alt="manga.name">

      <div class="flex-grow truncate">
        <h3 class="text-gray-800 font-bold mb-1 truncate">{{ manga.name }}</h3>
      </div>

      <div>
        <button
          type="button"
          class="button-bare bg-red-800 hover:bg-red-900 text-white px-3 py-1 rounded-lg flex items-center text-sm whitespace-nowrap"
          @click="deleteManga"
        >
        <DeleteIcon :size="12" class="mr-1" /> Xóa truyện
      </button>
      </div>
    </div>
    <div class="ml-8">
      <ChapterItemList v-for="chapter in chapters" :key="'chapter-' + chapter.id" :chapter="chapter" @reload="reload" />
    </div>
  </div>
</template>

<script>
import db from '@/db'
import DeleteIcon from 'vue-material-design-icons/Delete.vue'
import ChapterItemList from '@/components/offline/ChapterItemList'

export default {
  props: {
    manga: {
      type: Object
    },

    isOffline: {
      type: Boolean
    }
  },

  components: {
    ChapterItemList,
    DeleteIcon
  },

  computed: {
    coverUrl () {
      return URL.createObjectURL(new Blob([this.manga.coverBuffer], { type: this.manga.coverBufferType }))
    }
  },

  data () {
    return {
      chapters: []
    }
  },

  methods: {
    async getChapters () {
      const chapters = await db.chapters.where({ 'manga.id': this.manga.id }).toArray()
      this.chapters = chapters.sort(function (a, b) {
        return b.order - a.order
      })
    },

    async deleteManga () {
      await db.transaction('rw', db.chapters, db.mangas, async () => {
        await db.chapters.where({ 'manga.id': this.manga.id }).delete()
        await db.mangas.where({ id: this.manga.id }).delete()
      })

      this.$emit('reload')
    },

    reload () {
      this.$emit('reload')
    }
  },

  created () {
    this.getChapters()
  }
}
</script>
