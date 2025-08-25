<template>
  <div class="absolute top-0 w-[10%] h-full z-30 whitespace-nowrap select-none from-gray-800" ref="nextPageButton"
    :class="{
      'left-0 bg-gradient-to-r': (direction === 'rtl' && action === 'next') || (direction === 'ltr' && action === 'prev'),
      'right-0 bg-gradient-to-l': (direction === 'ltr' && action === 'next') || (direction === 'rtl' && action === 'prev'),
      'opacity-0 lg:hover:opacity-50': !isVisible,
      'opacity-100 lg:hover:opacity-100 animate-pulse': isVisible,
      'from-blue-800': isVisible && action === 'next',
      'from-gray-800': isVisible && action === 'prev',
      }"
    @click.prevent="$emit('click')"
  >
    <div class="w-full h-full flex items-center justify-center transition">
      <div
        class="uppercase text-sm lg:text-xl text-gray-300 text-opacity-80"
        :class="{
          '-rotate-90': (direction === 'rtl' && action === 'next') || (direction === 'ltr' && action === 'prev'),
          'rotate-90': (direction === 'ltr' && action === 'next') || (direction === 'rtl' && action === 'prev'),
          }"
      >
        <span v-if="action === 'next'">
          Trang tiếp
        </span>
        <span v-if="action === 'prev'">
          Trang trước
        </span>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    isVisible: Boolean,
    direction: String,
    action: String
  }
}
</script>
