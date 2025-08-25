<template>
  <div class="px-6 md:px-12 py-32 md:py-64 text-gray-600 flex flex-col justify-center items-center">
    <div class="mb-4 text-gray-700 text-3xl">(╯°□°）╯︵ ┻━┻</div>

    <div class="mb-4">
      Có lỗi đã xảy ra khi lấy dữ liệu.
    </div>

    <div>
      <router-link
        v-if="$route.query.offline !== 'true' && $route.name !== 'SavedOffline'"
        :to="{ name: 'SavedOffline' }"
        class="px-4 py-2 bg-blue-500 hover:bg-blue-600 focus:bg-blue-600 fine-transition focus:ring text-white text-lg rounded-lg">
        Xem truyện đã tải xuống
      </router-link>
    </div>
  </div>
</template>

<script>
</script>
