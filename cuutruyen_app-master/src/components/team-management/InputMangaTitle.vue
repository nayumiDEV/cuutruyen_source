<template>
  <div v-if="!isDestroy">
    <div class="h-10 w-full rounded-lg overflow-hidden fine-transition bg-white flex gap-2 items-center px-4 py-2" :class="{ 'ring': isFocus }">
      <input :value="value" class="w-full h-full grow outline-none" type="text" placeholder="Tên truyện" @focus="isFocus = true" @focusout="isFocus = false" @input="onInput">
      <div v-show="primary" class="rounded-full text-sm bg-green-200 font-bold text-green-800 px-2 py-0.5 whitespace-nowrap">Tên mặc định</div>
      <button
        type="button"
        v-show="!primary"
        class="rounded-full text-sm transition bg-gray-100 hover:bg-gray-200 font-bold text-gray-500 px-2 py-0.5 whitespace-nowrap"
        @click.prevent="$emit('setTitlePrimary')"
      >
        Chọn làm tên mặc định
      </button>

      <button
        type="button"
        v-show="!primary"
        class="rounded-full text-sm transition bg-red-100 hover:bg-red-200 font-bold text-red-500 px-2 py-0.5 whitespace-nowrap"
        @click.prevent="$emit('deleteTitle')"
      >
        Xóa
      </button>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    value: String,
    primary: Boolean,
    isDestroy: String
  },
  data () {
    return {
      isFocus: false
    }
  },

  methods: {
    onInput (event) {
      this.$emit('input', event.target.value)
    }
  }
}
</script>
