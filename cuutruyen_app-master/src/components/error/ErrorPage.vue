<template>
  <LayoutNormal>
    <div class="min-h-screen h-full w-full px-6 md:px-12 py-32 md:py-64 text-gray-600 flex flex-col justify-center items-center">
      <div class="mb-4 text-3xl font-bold text-gray-500">
        <span v-if="errorCode">{{ errorCode }}</span>
        <span v-else>(╯°□°）╯︵ ┻━┻</span>
      </div>

      <div class="mb-8">
        <span v-if="errorMessage">
          {{ errorMessage }}
        </span>
        <span v-else>Có lỗi chưa xác định đã xảy ra.</span>
      </div>

      <div class="mb-8 text-yellow-700 text-sm text-center" v-if="isOldWindows">
        <p class="mb-2">
          Bạn đang sử dụng hệ điều hành Windows cũ (8/7/XP)! Windows phiên bản cũ hoặc không bật tự cập nhật <strong>không có đủ chứng chỉ mới nhất</strong> để truy cập Cứu Truyện.
        </p>

        <p>
          Bổ sung chứng chỉ mới nhất theo <a href="https://www.facebook.com/CuuTruyenTranh/posts/406892060929423" target="_blank" class="text-blue-700 hover:text-blue-900"><strong>hướng dẫn tại đây</strong></a>,
          hoặc sử dụng Windows 10 trở lên để tránh gặp vấn đề khi truy cập Cứu Truyện và đảm bảo an toàn cho máy tính và dữ liệu của bạn.
        </p>
      </div>

      <router-link
        :to="{ name: 'SavedOffline' }"
        class="px-4 py-2 fine-transition text-blue-700 hover:text-blue-800 focus:bg-blue-300 uppercase text-lg rounded-lg">
        Đọc Truyện ngoại tuyến
      </router-link>

      <router-link
        v-if="$route.name !== 'Home'"
        :to="{ name: 'Home' }"
        class="px-4 py-2 fine-transition text-blue-700 hover:text-blue-800 focus:bg-blue-300 uppercase text-lg rounded-lg">
        Về trang chủ
      </router-link>
    </div>
  </LayoutNormal>
</template>

<script>
import { mapGetters, mapMutations } from 'vuex'
import LayoutNormal from '@/layouts/LayoutNormal'

export default {
  components: {
    LayoutNormal
  },

  metaInfo () {
    return {
      title: 'Lỗi'
    }
  },

  data () {
    return {
      isOldWindows: false
    }
  },

  computed: {
    ...mapGetters(['errorCode', 'errorMessage', 'isOnline'])
  },

  methods: {
    ...mapMutations(['leaveErrorPage'])
  },

  mounted () {
    if (navigator.appVersion.indexOf('Windows NT 6') !== -1 || navigator.appVersion.indexOf('Windows NT 5') !== -1) {
      this.isOldWindows = true
    } else {
      this.isOldWindows = false
    }
  }
}
</script>
