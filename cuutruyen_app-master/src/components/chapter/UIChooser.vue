<template>
  <div class="flex gap-2 items-center">
    <div class="flex m-1">
      <button class="rounded-l-full button-bare text-white h-8 text-xs uppercase font-bold w-28 whitespace-nowrap"
        :class="{
          'bg-blue-800': ui === 'classic',
          'bg-gray-800 bg-opacity-50': ui !== 'classic'
          }"
        @click.prevent="changeUI('classic')">Classic UI</button>
      <button class="rounded-r-full button-bare text-white h-8 text-xs uppercase font-bold w-28 whitespace-nowrap"
        :class="{
          'bg-blue-800': ui === 'zen',
          'bg-gray-800 bg-opacity-50': ui !== 'zen'
          }"
        @click.prevent="changeUI('zen')">Zen UI</button>
    </div>

    <button class="rounded-full w-8 h-8 bg-yellow-800 text-white flex items-center justify-center" @click="$emit('showUIHelpModal')"><HelpIcon :size="16" /></button>
  </div>
</template>

<script>
import HelpIcon from 'vue-material-design-icons/Help.vue'
export default {
  props: {
    ui: String
  },

  components: {
    HelpIcon
  },

  methods: {
    changeUI (ui) {
      this.$emit('changeUI', ui)
    }
  }
}
</script>
