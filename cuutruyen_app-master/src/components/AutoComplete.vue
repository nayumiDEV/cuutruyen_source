<template>
  <div class="relative">
    <input
      v-model="userInput"
      :id="inputId"
      class="input mt-4"
      type="text"
      :placeholder="placeholder"
      @focus="shouldShowDropdown"
      @input="typing"
      @blur="hideDropdown"
    >
    <div class="absolute top-full left-0 w-full mt-2 h-40 shadow border border-gray-200 rounded-lg bg-white overflow-auto" v-show="isDropdownShow">
      <div v-for="(item, index) in items" :key="index">
        <a href="#" @click.prevent="selectItem(item)">
          <slot name="item" v-bind:item="item"></slot>
        </a>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  data () {
    return {
      isDropdownShow: false,
      userInput: ''
    }
  },

  props: {
    placeholder: String,
    items: Array,
    inputId: String
  },

  methods: {
    shouldShowDropdown () {
      if (this.userInput.length > 0) {
        this.isDropdownShow = true
      } else {
        this.hideDropdown()
      }
    },

    async typing () {
      this.$emit('input', this.userInput)
      this.shouldShowDropdown()
    },

    hideDropdown () {
      setTimeout(() => {
        this.isDropdownShow = false
      }, 200)
    },

    selectItem (item) {
      console.log(item)
      this.$emit('selected', item)
      this.userInput = ''
      this.isDropdownShow = false
    }
  }
}
</script>
