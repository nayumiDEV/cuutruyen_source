<template>
  <div class="px-6 md:px-12 py-16 md:py-32 text-gray-600 flex flex-col justify-center items-center">
    <div class="mb-4 text-gray-700 text-3xl">
      <img src="@/assets/img/empty.svg" alt="Empty" class="w-48">
    </div>

    <div class="mb-4">
      {{ message }}
    </div>

    <div>
      <slot />
    </div>
  </div>
</template>

<script>
export default {
  props: {
    message: {
      type: String,
      default: 'Chưa có dữ liệu gì ở đây cả.'
    }
  }
}
</script>
