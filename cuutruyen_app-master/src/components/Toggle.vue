<template>
  <div class="flex gap-1 items-center cursor-pointer">
    <div class="relative rounded-full w-12 h-6 transition duration-200 ease-linear"
      :class="{
        'bg-green-400': value,
        'bg-gray-400': !value
        }"
    >
      <label :for="_uid"
        class="absolute left-0 bg-white border-2 mb-2 w-6 h-6 rounded-full transition transform duration-100 ease-linear cursor-pointer"
        :class="{
          'translate-x-full border-green-400': value,
          'translate-x-0 border-gray-400': !value
          }"
      ></label>
      <input type="checkbox" :id="_uid" name="toggle"
        class="appearance-none w-full h-full active:outline-none focus:outline-none"
        @click="changeState"/>
    </div>

    <label class="block" :for="_uid"><slot /></label>
  </div>
</template>

<script>
export default {
  props: {
    value: {
      type: Boolean,
      default: false
    },

    title: {
      type: String
    }
  },

  methods: {
    changeState () {
      this.value === false ? this.$emit('input', true) : this.$emit('input', false)
    }
  }
}
</script>
