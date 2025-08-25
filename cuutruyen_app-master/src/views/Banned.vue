<template>
  <div v-if="currentUser.user_ban && currentUser.user_ban.ban_type === 'ban'" class="min-h-screen w-full flex justify-center items-center bg-gray-300">
    <div class="max-w-screen-sm m-4">
      <h1 class="font-extrabold text-gray-800 text-xl mb-8">Bạn đang bị giới hạn truy cập Cứu Truyện</h1>

      <p class="mb-4">Bạn có thể bị giới hạn quyền truy cập và sử dụng Cứu Truyện vì những nguyên nhân như vi phạm điều khoản sử dụng, vô ý hoặc cố ý spam, lạm dụng hệ thống hay sử dụng sai mục đích,...</p>

      <p v-if="currentUser.user_ban.banned_until" class="mb-4">Giới hạn truy cập của bạn sẽ kết thúc vào <strong>{{ currentUser.user_ban.banned_until | humanizeTime }}</strong>.</p>

      <p class="mb-4">Nếu bạn cho rằng có gì đó nhầm lẫn hoặc sai sót, vui lòng liên hệ với quản trị viên của Cứu Truyện bằng cách <a class="link" href="https://m.me/cuutruyentranh" target="_blank">nhắn tin cho fanpage</a> hoặc qua email <a class="link" href="mailto:ad.cuutruyen@gmail.com" target="_blank">ad.cuutruyen@gmail.com</a>.</p>
    </div>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'

export default {
  computed: {
    ...mapGetters([
      'currentUser'
    ])
  },

  mounted () {
    if (!this.currentUser.user_ban || this.currentUser.user_ban.ban_type !== 'ban') {
      this.$router.push({ name: 'Home' })
    }
  }
}
</script>
