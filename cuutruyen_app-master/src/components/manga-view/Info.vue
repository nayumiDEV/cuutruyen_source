<template>
  <div>
    <div class="mb-8">
      <div class="uppercase text-sm text-gray-600 font-bold font-head mb-2">Nhóm dịch</div>
      <div class="min-h-12">
        <TeamItem v-if="team" :team="team" />
      </div>
    </div>

    <div class="mb-8">
      <div class="uppercase text-sm text-gray-600 font-bold font-head mb-2">Trang chính thức</div>

      <div v-if="manga && manga.official_url" class="flex items-center">
        <WebIcon class="text-gray-500 mr-2" :size="16" />
        <a
          class="text-gray-700 block px-4 py-1 bg-gray-200 hover:bg-gray-300 transition rounded-lg"
          :href="manga.official_url"
          target="_blank"
          rel="noopener noreferrer"
        >
          {{ manga.official_url | onlyHostname }}
        </a>
      </div>

      <div v-else class="text-gray-700 font-italic flex items-center">
        <WebIcon class="text-gray-500 mr-2" :size="16" />
        <span class="py-1">Trang chính thức chưa được thêm</span>
      </div>
    </div>

    <div class="mb-8">
      <div class="uppercase text-sm text-gray-600 font-bold font-head mb-2">Thông tin thêm</div>

      <div class="text-gray-700 mb-1 flex items-center">
        <ListIcon class="text-gray-500 mr-2" :size="16" />
        <div><strong>{{ manga.chapters_count }}</strong> chương đã đăng</div>
      </div>

      <div class="text-gray-700 flex items-center">
        <EyeIcon class="text-gray-500 mr-2" :size="16" />
        <div><strong>{{ manga.views_count | humanizeNumber }}</strong> lượt xem</div>
      </div>
    </div>
  </div>
</template>

<script>
import ListIcon from 'vue-material-design-icons/FormatListBulletedSquare.vue'
import EyeIcon from 'vue-material-design-icons/Eye.vue'
import WebIcon from 'vue-material-design-icons/Web.vue'
import TeamItem from '@/components/manga-view/TeamItem'

export default {
  props: {
    translation: {
      type: Object
    },
    manga: {
      type: Object
    },
    team: {
      type: Object
    }
  },

  components: {
    ListIcon,
    EyeIcon,
    WebIcon,
    TeamItem
  },

  filters: {
    onlyHostname (url) {
      return (new URL(url)).hostname
    }
  }
}
</script>

<style scoped>
.min-h-12 {
  min-height: 3rem;
}
</style>
