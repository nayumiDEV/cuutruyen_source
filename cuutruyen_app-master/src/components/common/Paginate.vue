<template>
  <div class="common-container flex justify-center my-12 gap-4">
    <router-link
      v-if="hasPrevPage"
      :to="{ name: this.routeName, params: routeParams, query: { page: currentPage - 1, ...routeQuery } }"
      class="button button-primary flex justify-center items-center px-6 py-2"
    >
      <ChevronLeftIcon class="mr-1" /><div>Trang trước</div>
    </router-link>

    <a v-else class="button button-primary button-disabled flex justify-center items-center px-6 py-2">
      <ChevronLeftIcon class="mr-1" /><div>Trang trước</div>
    </a>

    <router-link
      v-if="hasNextPage"
      :to="{ name: this.routeName, params: routeParams, query: { page: currentPage + 1, ...routeQuery } }"
      class="button button-primary flex justify-center items-center px-6 py-2">
      <div>Trang sau</div><ChevronRightIcon class="ml-1" />
    </router-link>

    <a v-else class="button button-primary button-disabled flex justify-center items-center px-6 py-2">
      <div>Trang sau</div><ChevronRightIcon class="ml-1" />
    </a>
  </div>
</template>

<script>
import ChevronLeftIcon from 'vue-material-design-icons/ChevronLeft.vue'
import ChevronRightIcon from 'vue-material-design-icons/ChevronRight.vue'

export default {
  props: {
    currentPage: Number,
    totalPages: Number,
    routeName: String,
    routeParams: {
      type: Object,
      default: () => ({})
    },
    routeQuery: {
      type: Object,
      default: () => ({})
    }
  },

  components: {
    ChevronLeftIcon,
    ChevronRightIcon
  },

  computed: {
    hasPrevPage () {
      return this.currentPage > 1
    },

    hasNextPage () {
      return this.currentPage < this.totalPages
    }
  }
}
</script>
