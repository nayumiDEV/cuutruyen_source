<template>
  <tr class="text-center border-b border-gray-200 text-gray-800">
    <td class="text-center"><ReorderHorizontalIcon class="text-gray-600 hover:text-gray-800 handle cursor-move" /></td>
    <td class="text-right">{{ chapter.number }}</td>
    <td class="text-left flex">
      <div>
        <router-link v-if="chapter.name" :to="{ name: 'TeamChapterEdit', params: { chapterId: chapter.id } }" class="font-semibold mb-0.5 text-gray-800">
          {{ chapter.name }}
        </router-link>
        <router-link v-else :to="{ name: 'TeamChapterEdit', params: { chapterId: chapter.id } }" class="mb-0.5 text-gray-500 italic">
          Không có tiêu đề
        </router-link>
        <div class="text-xs">
          <router-link
            class="text-blue-600 hover:text-blue-700 fine-transition flex items-center gap-0.5"
            :to="{ name: 'Chapter', params: { mangaId: manga.id, id: chapter.id } }"
            target="_blank"
          >
            {{ `${baseUrl}/mangas/${manga.id}/chapters/${chapter.id}` }}
            <OpenInNewIcon class="inline" :size="14" />
          </router-link>
        </div>
      </div>
    </td>
    <td class="text-right">{{ chapter.pages_count }}</td>
    <td class="text-center">
      <span v-if="status === 'enqueued'" class="flex justify-center items-center text-blue-600">
        <CircleIcon :size="12" class="mr-1" /> Đã lên lịch
      </span>
      <div v-else-if="status === 'processing'" class="flex flex-col justify-center items-center gap-2 text-yellow-600">
        <div class="flex justify-center items-center">
          <LoadingIcon :size="16" class="mr-0.5 spin" /> Đang xử lý
        </div>

        <div class="w-[80px] rounded-full h-[3px] bg-white border border-gray-200">
          <div class="h-full rounded-full bg-blue-500" :style="{ width: cssProgress }"></div>
        </div>
      </div>
      <span v-else-if="status === 'processed'" class="flex justify-center items-center text-green-600">
        <CheckIcon :size="16" class="mr-0.5" /> Đã xử lý
      </span>
      <span v-else class="flex justify-center items-center text-red-600">
        <AlertIcon :size="16" class="mr-0.5" /> Thất bại
      </span>
    </td>
    <td class="whitespace-nowrap">{{ chapter.created_at | humanizeTime }}</td>
    <td class="whitespace-nowrap">{{ chapter.edited_at | humanizeTime }}</td>
    <td class="flex justify-end gap-1">
      <router-link :to="{ name: 'TeamChapterEdit', params: { chapterId: chapter.id } }" class="button button-mini button-normal px-2.5 py-1.5">Sửa</router-link>
      <a href="#" @click.prevent="$emit('deleteChapter', chapter)" class="button button-mini button-danger px-2.5 py-1.5">Gỡ bỏ</a>
    </td>
  </tr>
</template>

<script>
import ReorderHorizontalIcon from 'vue-material-design-icons/ReorderHorizontal.vue'
import CircleIcon from 'vue-material-design-icons/Circle.vue'
import LoadingIcon from 'vue-material-design-icons/Loading.vue'
import CheckIcon from 'vue-material-design-icons/Check.vue'
import AlertIcon from 'vue-material-design-icons/Alert.vue'
import OpenInNewIcon from 'vue-material-design-icons/OpenInNew.vue'

export default {
  components: {
    ReorderHorizontalIcon,
    CircleIcon,
    LoadingIcon,
    CheckIcon,
    AlertIcon,
    OpenInNewIcon
  },

  props: {
    manga: Object,
    chapter: Object,
    consumer: Object
  },

  data () {
    return {
      channel: null,
      status: this.chapter.status,
      progress: this.chapter.progress,
      baseUrl: process.env.VUE_APP_API_BASE_URL
    }
  },

  computed: {
    cssProgress () {
      return `${Math.round(this.progress * 100)}%`
    }
  },

  mounted () {
    if (this.status !== 'failed' && this.status !== 'processed') {
      this.channel = this.consumer.subscriptions.create({ channel: 'ChapterProcessingStatusChannel', chapter_id: this.chapter.id }, {
        received: (data) => {
          this.status = data.status
          this.progress = data.progress
          if (this.status === 'failed' || this.status === 'processed') {
            this.channel.unsubscribe()
          }
        }
      })
    }
  },

  beforeDestroy () {
    if (this.channel) {
      this.channel.unsubscribe()
    }
  }
}
</script>
