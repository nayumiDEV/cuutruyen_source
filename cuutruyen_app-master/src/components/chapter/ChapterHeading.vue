<template>
  <div class="w-full h-[calc(100vh-2.5rem-60px)] max-w-screen-md mx-auto px-2 flex flex-col overflow-y-auto select-none">
    <div class="flex justify-center items-center mb-4 pt-12 mb-4">
      <UIChooser :ui="'zen'" @changeUI="changeUI" @showUIHelpModal="$emit('showUIHelpModal')" />
    </div>

    <div class="mb-12">
    <router-link
      :to="{ name: 'Manga', params: { id: manga.id } }"
      class="text-sm text-gray-400 hover:text-gray-200 py-1 flex items-center gap-2">
      <ArrowLeftIcon class="inline-block mr-1" :size="16" /> {{ manga.name }}
    </router-link>
    </div>

    <div class="mb-12 flex-grow">
      <h1 class="text-xl text-gray-100 mb-6">
        <span>Chương {{ chapter.number }}</span>
        <span v-if="chapter.name">: {{ chapter.name }}</span>
      </h1>

      <div class="flex items-stretch flex-col gap-2">
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
            class="flex justify-center items-center button bg-gray-900 bg-opacity-20 text-gray-100 text-opacity-20 px-3 py-2 text-sm uppercase font-bold cursor-default w-full"
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
      </div>

      <div class="text-sm flex flex-col items-center mt-3">
        <div class="max-w-md text-center">
          <a href="https://www.messenger.com/channel/CuuTruyenTranh" target="_blank" class="text-yellow-400 hover:text-yellow-200 transition font-bold flex gap-2 items-center">
            <span>Tham gia kênh thông báo của Cứu Truyện</span>
          </a>
        </div>
      </div>
    </div>

    <!-- <div class="mb-12 flex flex-col justify-center gap-2">
         <button type="button" @click.prevent="$emit('toNextPage')" v-if="direction === 'rtl'" class="text-xs flex items-center justify-center gap-3 rounded-lg p-1 bg-blue-400 bg-opacity-20 text-blue-300 hover:cursor-pointer">
         <div class="rounded-full w-4 h-4 bg-blue-700 text-white flex-none"><ChevronLeftIcon :size="16" /></div>
         <div>Mẹo: cuộn từ trái sang phải hoặc nhấn vào cạnh trái của màn hình để bắt đầu đọc</div>
         </button>
         <button type="button" @click.prevent="$emit('toNextPage')" v-else class="text-xs flex items-center justify-center gap-3 rounded-lg p-1 bg-blue-600 bg-opacity-10 text-blue-300">
         <div>Mẹo: cuộn từ phải sang trái hoặc nhấn vào cạnh phải của màn hình để bắt đầu đọc</div>
         <div class="rounded-full w-4 h-4 bg-blue-700 text-white flex-none"><ChevronRightIcon :size="16" /></div>
         </button>

         <button @click="$emit('changeUI', 'classic')" class="text-xs flex items-center justify-center gap-3 rounded-lg p-1 bg-yellow-400 bg-opacity-20 text-yellow-300 hover:cursor-pointer">
         <div class="rounded-full w-4 h-4 bg-yellow-700 text-white flex items-center justify-center flex-none"><HelpIcon :size="9" /></div>
         <div>Không thích chế độ đọc ngang? Bạn có thể quay về sử dụng chế độ đọc cổ điển</div>
         </button>
         </div> -->

    <div class="text-sm text-gray-600 flex flex-col justify-center items-center pb-12">
      <div class="mb-4 flex-col gap-1 justify-center hidden lg:grid grid-cols-2 gap-4 items-center">
        <div v-if="direction === 'rtl'" class="flex items-center">
          <span class="flex flex-none justify-center items-center h-6 w-6 rounded border border-gray-700 mr-2 block">←</span> Chuyển trang tiếp theo
        </div>

        <div v-else class="flex items-center">
          <span class="flex flex-none justify-center items-center h-6 w-6 rounded border border-gray-700 mr-2 block">→</span> Chuyển trang tiếp theo
        </div>

        <div v-if="direction === 'rtl'" class="flex items-center">
          <span class="flex flex-none justify-center items-center h-6 w-6 rounded border border-gray-700 mr-2 block">→</span> Chuyển trang trước đó
        </div>

        <div v-else class="flex items-center">
          <span class="flex flex-none justify-center items-center h-6 w-6 rounded border border-gray-700 mr-2 block">←</span> Chuyển trang trước đó
        </div>

        <div class="flex items-center">
          <span class="flex flex-none justify-center items-center text-center h-6 w-6 rounded border border-gray-700 mr-2 block text-[0.6rem] leading-[0.6rem]">PG UP</span> Tới chương tiếp theo
        </div>

        <div class="flex items-center">
          <span class="flex flex-none justify-center items-center text-center h-6 w-6 rounded border border-gray-700 mr-2 block text-[0.6rem] leading-[0.6rem]">PG DN</span> Tới chương trước đó
        </div>

        <div class="flex items-center flex col-span-2 justify-center">
          <span class="flex flex-none justify-center items-center h-6 w-6 rounded border border-gray-700 mr-2 block"><MouseIcon :size="15" /></span>
          <span>Nhấp đúp để phóng to và thu nhỏ</span>
        </div>
      </div>

      <!-- <div v-if="direction === 'rtl'" class="text-yellow-500 text-xs">Truyện này được đọc từ phải qua trái</div>
           <div v-else class="text-yellow-500 text-xs">Truyện này được đọc từ trái qua phải</div> -->
    </div>
  </div>
</template>

<script>
import UIChooser from '@/components/chapter/UIChooser'
import ArrowLeftIcon from 'vue-material-design-icons/ArrowLeft.vue'
// import ArrowRightBoldCircleIcon from 'vue-material-design-icons/ArrowRightBoldCircle.vue'
import MouseIcon from 'vue-material-design-icons/Mouse.vue'
// import HelpIcon from 'vue-material-design-icons/Help.vue'
// import ChevronLeftIcon from 'vue-material-design-icons/ChevronLeft.vue'
// import ChevronRightIcon from 'vue-material-design-icons/ChevronRight.vue'

export default {
  components: {
    UIChooser,
    ArrowLeftIcon,
    // ArrowRightBoldCircleIcon
    MouseIcon
    // HelpIcon,
    // ChevronLeftIcon,
    // ChevronRightIcon
  },

  props: {
    manga: Object,
    chapter: Object,
    team: Object,
    direction: String,
    activeZoom: Boolean
  },

  methods: {
    changeUI (ui) {
      this.$emit('changeUI', ui)
    }
  }
}
</script>
