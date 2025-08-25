<template>
  <div class="mx-2 my-12">
    <template v-if="loading">
      <LoadingScreen />
    </template>

    <template v-else-if="error">
      <ErrorScreen />
    </template>

    <template v-else-if="mangas">
      <div class="common-container">
        <h1 class="title">Đã tải xuống</h1>
      </div>

      <div class="common-container mb-12">
        <div class="mb-4" v-if="usedSize && quotaSize">Bạn đã dùng <b>{{ usedSize | friendlySize }}</b> trên tổng số <b>{{ quotaSize | friendlySize }}</b> dung lượng ước tính được phép sử dụng.</div>
        <div class="mb-4">
          <div class="relative max-w-screen-sm h-4 rounded-full overflow-hidden bg-white">
            <div class="absolute top-0 left-0 h-full bg-blue-700" :style="{ width: `${usedPercent}%` }"></div>
          </div>
        </div>
        <div><button type="button" class="button bg-red-800 hover:bg-red-900 text-white px-8 py-2" href="#" @click="deleteAll">Xóa tất cả</button></div>
      </div>

      <div class="common-container">
        <div v-if="mangas.length > 0" class="">
          <div v-for="manga in mangas" :key="manga.id">
            <MangaItemList :manga="manga" @reload="loadMangas" />
          </div>
        </div>

        <EmptyScreen v-else message="Bạn chưa tải xuống truyện nào."></EmptyScreen>
      </div>
    </template>
  </div>
</template>

<script>
import db from '@/db'
import MangaItemList from '@/components/offline/MangaItemList'

const humanFileSize = (bytes, si = false, dp = 1) => {
  const thresh = si ? 1000 : 1024

  if (Math.abs(bytes) < thresh) {
    return bytes + ' B'
  }

  const units = si
    ? ['kB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB']
    : ['KiB', 'MiB', 'GiB', 'TiB', 'PiB', 'EiB', 'ZiB', 'YiB']
  let u = -1
  const r = 10 ** dp

  do {
    bytes /= thresh
    ++u
  } while (Math.round(Math.abs(bytes) * r) / r >= thresh && u < units.length - 1)

  return bytes.toFixed(dp) + ' ' + units[u]
}

export default {
  name: 'SavedOffline',

  components: {
    MangaItemList
  },

  filters: {
    friendlySize (size) {
      return humanFileSize(size, false)
    }
  },

  data () {
    return {
      mangas: [],
      loading: false,
      error: false,
      usedSize: null,
      quotaSize: null
    }
  },

  computed: {
    usedPercent () {
      if (this.usedSize && this.quotaSize) {
        return Math.round((this.usedSize / this.quotaSize) * 100)
      } else {
        return 0
      }
    }
  },

  async mounted () {
    this.loadMangas()
  },

  methods: {
    async loadMangas () {
      this.getEstimateQuota()
      this.loading = true
      try {
        const mangas = await db.mangas.toArray()
        this.mangas = mangas
      } catch (error) {
        this.deleteAll()
      } finally {
        this.loading = false
      }
    },

    async getEstimateQuota () {
      if (navigator.storage && navigator.storage.estimate) {
        const estimation = await navigator.storage.estimate()
        this.usedSize = estimation.usage
        this.quotaSize = estimation.quota
      } else {
        console.error('StorageManager not found')
      }
    },

    async deleteAll () {
      await db.transaction('rw', db.images, db.chapters, db.mangas, async () => {
        await db.chapters.clear()
        await db.images.clear()
        await db.mangas.clear()
      })

      this.loadMangas()
    }
  }
}
</script>

<style scoped>
.bg-dominant-fade {
  background-repeat: no-repeat;
  background-position: bottom;
  background-size:auto 50%;
}

.cover-img:hover {
  filter: brightness(0.3);
}
</style>
