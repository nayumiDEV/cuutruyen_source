<template>
  <div class="py-14 lg:py-20 px-2">
    <CuuHeading v-if="block.title">{{ block.title }}</CuuHeading>

    <div class="common-container">
      <div class="bg-gray-100 p-4 rounded-lg border border-dashed border-gray-300">
        <div class="text-center text-gray-500">
          <svg xmlns="http://www.w3.org/2000/svg" class="h-12 w-12 mx-auto mb-2" fill="none" viewBox="0 0 24 24"
            stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
              d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
          </svg>
          <p class="text-lg font-medium">Không hỗ trợ khối loại "{{ block.type }}"</p>
          <p class="mt-2">Không tìm thấy component tương ứng cho loại khối này.</p>
        </div>
        <div class="mt-4 bg-white p-3 rounded border border-gray-200">
          <pre class="text-xs overflow-auto">{{ JSON.stringify(block, null, 2) }}</pre>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'DefaultBlock',

  props: {
    block: {
      type: Object,
      required: true
    },
    team: {
      type: Object,
      required: true
    }
  },

  mounted () {
    // Static content block - emit loaded immediately
    this.$emit('block-loaded')
  }
}
</script>

<style scoped>
.block-container {
  @apply bg-white rounded-lg p-4 shadow-sm;
}
</style>
