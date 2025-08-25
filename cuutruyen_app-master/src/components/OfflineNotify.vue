<template>
  <div class="w-full flex justify-center">
    <div class="px-4 py-2 bg-yellow-300 text-yellow-700 mb-4 rounded-lg">
      Bạn đang xem phiên bản đã tải xuống của trang này.
      <router-link
        class="font-bold"
        :to="toRoute"
      >Xem trực tuyến</router-link>.
    </div>
  </div>
</template>

<script>
export default {
  props: {
    toRoute: Object
  }
}
</script>
