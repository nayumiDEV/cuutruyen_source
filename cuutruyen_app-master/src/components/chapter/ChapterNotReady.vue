<template>
  <div class="w-screen bg-gray-900 overflow-hidden">
    <NavBar class="w-full fine-shadow z-40 transition duration-400 fixed" :glassy="true" theme="dark" />

    <div class="min-h-screen max-w-screen-md mx-auto flex items-center px-2 bg-gray-900">
      <div class="w-full">
        <div class="flex justify-between mb-12">
          <router-link
            :to="{ name: 'Manga', params: { id: chapter.manga.id } }"
            class="text-sm text-gray-400 hover:text-gray-200 py-1 flex items-center gap-2">
            <ArrowLeftIcon class="inline-block mr-1" :size="16" /> {{ chapter.manga.name }}
          </router-link>
        </div>

        <!-- <h1 class="text-xl text-gray-100 mb-6">
             <span>Chương {{ chapter.number }}</span>
             <span v-if="chapter.name">: {{ chapter.name }}</span>
             </h1> -->

        <!-- <div class="flex items-stretch flex-col gap-2">
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
             class="flex justify-center items-center button bg-gray-800 bg-opacity-20 text-gray-100 text-opacity-20 px-3 py-2 text-sm uppercase font-bold cursor-default w-full"
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
             </div> -->

        <div class="my-12 bg-black bg-opacity-20 px-3 py-12 rounded-lg text-center">
          <div v-if="status === 'enqueued'" class="flex justify-center items-center text-blue-600 gap-1">
            <CircleIcon :size="12" /> Đang đợi xử lý hình ảnh
          </div>

          <div v-else-if="status === 'processing'" class="flex flex-col justify-center items-center gap-2 text-yellow-600 gap-2">
            <div class="flex justify-center items-center gap-1">
              <LoadingIcon :size="16" class="spin" /> Đang xử lý hình ảnh
            </div>

            <div class="w-full rounded-full h-[3px] bg-gray-800">
              <div class="h-full rounded-full bg-blue-500" :style="{ width: cssProgress }"></div>
            </div>
          </div>

          <div v-else-if="status === 'processed'" class="flex justify-center items-center text-green-600 gap-1">
            <CheckIcon :size="16" /> Đã xử lý xong tất cả hình ảnh! Chương truyện sẽ được tải lại trong giây lát.
          </div>

          <div v-else class="flex justify-center items-center text-red-600 gap-1">
            <AlertIcon :size="16" /> Xử lý hình ảnh thất bại :(( Vui lòng liên hệ với Cứu Truyện để báo lỗi.
          </div>

          <div class="text-gray-400 mt-12 text-xs">
            Các chương truyện vừa mới đăng được Cứu Truyện tối ưu hình ảnh để đảm bảo tốc độ và trải nghiệm tốt nhất.
            Quá trình này có thể mất một vài phút, tùy theo lượng chương truyện đang chờ xử lý ở thời điểm hiện tại.
          </div>
        </div>
      </div>

      <!-- <div class="text-gray-600 text-sm flex flex-col items-center mt-12">
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

           <div>{{ chapter.manga.description }}</div>
           </div>
           </div> -->
    </div>

    <AppFooter />
  </div>
</template>

<script>
import NavBar from '@/components/layout/default/NavBar'
import ArrowLeftIcon from 'vue-material-design-icons/ArrowLeft.vue'
import AppFooter from '@/components/layout/AppFooter'
import CircleIcon from 'vue-material-design-icons/Circle.vue'
import LoadingIcon from 'vue-material-design-icons/Loading.vue'
import CheckIcon from 'vue-material-design-icons/Check.vue'
import AlertIcon from 'vue-material-design-icons/Alert.vue'
import { createConsumer } from '@rails/actioncable'

export default {
  components: {
    NavBar,
    ArrowLeftIcon,
    AppFooter,
    CircleIcon,
    LoadingIcon,
    CheckIcon,
    AlertIcon
  },

  props: {
    chapter: Object
  },

  computed: {
    cssProgress () {
      return `${Math.round(this.progress * 100)}%`
    }
  },

  data () {
    return {
      consumer: null,
      channel: null,
      status: this.chapter.status,
      progress: this.chapter.progress
    }
  },

  mounted () {
    this.consumer = createConsumer()

    this.channel = this.consumer.subscriptions.create({ channel: 'ChapterProcessingStatusChannel', chapter_id: this.chapter.id }, {
      received: (data) => {
        this.status = data.status
        this.progress = data.progress
        if (this.status === 'failed' || this.status === 'processed') {
          this.channel.unsubscribe()
        }
        if (this.status === 'processed') {
          window.setTimeout(() => {
            this.$router.go()
          }, 1200)
        }
      }
    })
  },

  beforeDestroy () {
    if (this.channel) {
      this.channel.unsubscribe()
    }
    if (this.consumer) {
      this.consumer.disconnect()
    }
  }
}
</script>
