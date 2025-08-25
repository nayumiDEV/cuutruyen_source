<template>
  <div class="flex items-center px-6 py-3 mb-2 last:mb-0 bg-white bg-opacity-70 hover:bg-opacity-100 hover:shadow-lg rounded-lg fine-transition relative">
    <div class="avatar rounded-full w-12 h-12 flex justify-center items-center text-lg bg-blue-700 text-blue-200 mr-3">
        {{ team.name[0] }}
    </div>

    <div class="">
      <a class="cursor-pointer font-extrabold text-gray-700 mb-2 block">{{ team.name }}</a>
      <div class="text-sm text-gray-600 uppercase tracking-wide">{{ team.translations_count | humanizeNumber }} truyện đã đăng</div>
      <div v-if="viewsCountType === 'all'" class="text-sm text-gray-600 uppercase tracking-wide">{{ team.views_count | humanizeNumber }} lượt xem</div>
      <div v-if="viewsCountType === 'week'" class="text-sm text-gray-600 uppercase tracking-wide">{{ team.views_count_week | humanizeNumber }} lượt xem</div>
      <div v-if="viewsCountType === 'month'" class="text-sm text-gray-600 uppercase tracking-wide">{{ team.views_count_month | humanizeNumber }} lượt xem</div>
    </div>

    <div class="z-20 absolute top-0 right-0 text-3xl lg:text-4xl text-gray-800 text-opacity-10 font-bold mr-1 mt-1">{{ index + 1 | formatIndex }}</div>
  </div>
</template>

<script>
export default {
  props: {
    team: Object,
    index: Number,
    viewsCountType: String
  },

  filters: {
    formatIndex (number) {
      return String(number).padStart(2, '0')
    }
  }
}
</script>
