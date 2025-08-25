<template>
  <div class="flex justify-between items-center p-2">
    <div class="flex-1">
      <slot></slot>
    </div>

    <TeamSelector class="flex-1" />

    <UserMenu class="flex-1" />
  </div>
</template>

<script setup>
import TeamSelector from './TeamSelector.vue'
import UserMenu from './UserMenu.vue'
</script>
