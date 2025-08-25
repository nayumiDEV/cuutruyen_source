<template>
  <div>
    <router-link v-if="linkTo && imageUrl" :to="linkTo" class="avatar" :class="sizeClass">
      <img :src="imageUrl" :alt="name">
    </router-link>

    <div v-else-if="imageUrl" class="avatar" :class="sizeClass">
      <img :src="imageUrl" :alt="name">
    </div>

    <div v-else class="avatar" :class="sizeClass">
      {{ initial }}
    </div>
  </div>
</template>

<script>
export default {
  name: 'Avatar',
  props: {
    imageUrl: {
      type: String,
      default: null
    },
    name: {
      type: String,
      required: true
    },
    size: {
      type: String,
      default: 'default',
      validator: value => ['default', 'large'].includes(value)
    },
    linkTo: {
      type: [Object, String],
      default: null
    }
  },
  computed: {
    initial () {
      return this.name && this.name.length > 0 ? this.name[0] : ''
    },
    sizeClass () {
      return this.size === 'large' ? 'avatar-lg' : 'avatar-base'
    }
  }
}
</script>
