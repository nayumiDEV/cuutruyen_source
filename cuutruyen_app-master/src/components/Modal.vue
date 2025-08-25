<template>
  <vue-final-modal
    v-slot="{ params, close }"
    v-bind="$attrs"
    classes="flex w-screen-md justify-center items-center m-2"
    content-class="w-full max-w-screen-sm flex flex-col rounded-lg shadow-lg bg-white overflow-hidden"
    v-on="$listeners"
  >
    <div class="flex justify-between items-center px-8 py-4">
      <div class="font-head font-bold text-xl text-gray-700 flex-grow truncate">
        <slot name="header"></slot>
      </div>

      <button class="" @click="close">
        <CloseIcon />
      </button>
    </div>

    <div class="flex-grow overflow-y-auto px-8 py-6">
      <slot v-bind:params="params"></slot>
    </div>

    <div class="flex justify-end px-8 py-6 bg-gray-200">
      <slot name="footer"></slot>
    </div>
  </vue-final-modal>
</template>

<script>
import CloseIcon from 'vue-material-design-icons/Close'

export default {
  name: 'Modal',
  inheritAttrs: false,
  components: {
    CloseIcon
  }
}
</script>
