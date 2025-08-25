<template>
  <div class="common-container mb-8 lg:mb-12">
    <div class="uppercase font-bold text-xl text-gray-700" :class="headingClass">
      <slot></slot>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    headingClass: String
  }
}
</script>
