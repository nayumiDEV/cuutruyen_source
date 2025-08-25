<template>
  <vue-final-modal
    v-model="show"
    classes="flex w-screen-md justify-center items-center m-1"
    content-class="max-w-screen-sm max-h-[80vh] w-full flex flex-col rounded-lg shadow-lg bg-gray-800 overflow-hidden"
  >
    <div class="flex justify-between items-center overflow-hidden px-4 py-3">
      <div class="font-bold text-gray-200 flex-grow truncate text-sm md:text-base">
        Chọn giao diện đọc
      </div>

      <button class="text-gray-200" @click="cancel">
        <CloseIcon />
      </button>
    </div>

    <div class="flex-grow overflow-y-auto px-4 py-3 text-gray-200">
      <div class="flex flex-col sm:flex-row w-full justify-between gap-2 mb-4">
        <a class="block border-4 rounded-lg p-2 flex-1 bg-gray-900 bg-opacity-50 hover:cursor-pointer transition" :class="{ 'border-4 border-blue-800 bg-opacity-80': ui === 'classic', 'border-transparent': ui !== 'classic' }" @click="ui = 'classic'">
          <div class="text-xs sm:text-sm font-bold text-gray-200 mb-4">
            Classic UI
          </div>

          <div class="text-gray-400 text-xs text-left">
            <p class="mb-2">Chế độ <strong>đọc dọc</strong> truyền thống.</p>
            <p class="mb-2">Cuộn hoặc vuốt từ trên xuống dưới để đọc.</p>
            <p>Quen thuộc và tương tự như các trang đọc truyện phổ biến hiện nay.</p>
          </div>
        </a>

        <a class="block border-4 rounded-lg p-2 flex-1 bg-gray-900 bg-opacity-50 hover:cursor-pointer transition" :class="{ 'border-4 border-blue-800 bg-opacity-80': ui === 'zen', 'border-transparent': ui !== 'zen' }" @click="ui = 'zen'">
          <div class="text-xs sm:text-sm font-bold text-gray-200 mb-4">
            Zen UI
            <span class="py-0.5 px-2 text-xs rounded-full bg-blue-800">beta</span>
          </div>

          <div class="text-gray-400 text-xs text-left">
            <p class="mb-2">Chế độ <strong>đọc ngang</strong> mới.</p>
            <p class="mb-2 lg:hidden">Chạm vào cạnh trái/phải của màn hình hoặc vuốt qua trái/phải để di chuyển trang.</p>
            <p class="mb-2 hidden lg:block">Nhấp chuột vào cạnh trái/phải của màn hình để di chuyển trang.</p>
            <p class="mb-2 hidden lg:block">Trên máy tính, bạn cũng có thể nhấn phím mũi tên trái/phải trên bàn phím để di chuyển trang, hay ấn PageUp/PageDown trên bàn phím để chuyển chương.</p>
          </div>
        </a>
      </div>

      <div class="text-xs text-gray-400 mb-2">Bạn vẫn có thể dễ dàng chuyển đổi giữa 2 chế độ đọc sau khi đóng hộp thoại này.</div>
      <div class="text-xs text-gray-400">Nếu bạn có góp ý cho Cứu Truyện về cải thiện trải nghiệm đọc truyện, hãy <a class="text-blue-400 hover:text-blue-200" href="https://m.me/CuuTruyenTranh" rel="noopener noreferrer" target="_blank">gửi tin nhắn đến Fanpage của Cứu Truyện</a>.</div>
    </div>

    <div class="flex justify-end px-4 py-3 bg-gray-900">
      <button @click="confirm" type="button" class="button px-6 py-1 lg:py-2 text-sm bg-blue-800 hover:bg-blue-900 font-bold text-white">Xác nhận</button>
    </div>
  </vue-final-modal>
</template>

<script>
import CloseIcon from 'vue-material-design-icons/Close'

export default {
  props: {
    value: Boolean,
    defaultUI: String
  },

  components: {
    CloseIcon
  },

  data () {
    return {
      show: this.value,
      ui: this.defaultUI
    }
  },

  methods: {
    confirm () {
      this.$emit('confirm', this.ui)
      this.$emit('input', false)
    },

    cancel () {
      this.$emit('input', false)
    }
  },

  watch: {
    value (to) {
      if (to) {
        this.show = true
        this.ui = this.defaultUI
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
