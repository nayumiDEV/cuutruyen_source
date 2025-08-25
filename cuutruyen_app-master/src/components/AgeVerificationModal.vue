<template>
  <vue-final-modal
    v-model="show"
    classes="flex w-screen-md justify-center items-center m-1"
    content-class="max-w-screen-sm max-h-[80vh] w-full flex flex-col rounded-lg bg-gray-200 overflow-hidden"
    overlay-class="!bg-gray-400/100 transparent-none"
    :esc-to-close="false"
    :click-to-close="false"
  >
    <div class="flex justify-between items-center overflow-hidden px-4 py-3">
      <div class="font-bold flex-grow truncate text-sm md:text-base">
        Xác nhận tuổi
      </div>
    </div>

    <div class="flex-grow overflow-y-auto px-4 py-3">
      <div class="mb-6">
        <p class="mb-2">Nội dung này có thể không phù hợp với mọi lứa tuổi.</p>
        <p>Vui lòng xác thực tuổi bằng cách nhập năm sinh của bạn.</p>
      </div>

      <div class="year-picker rounded-lg overflow-hidden">
        <div class="p-2 bg-gray-800 text-gray-200 font-bold flex justify-between items-center">
          <button class="button hover:bg-gray-900 p-1" @click.prevent="decadeBack"><ChevronLeftIcon /></button>
          <div>{{ currentRange.start }} - {{ currentRange.end }}</div>
          <button class="button hover:bg-gray-900 p-1" @click.prevent="decadeForward" :disabled="currentYear <= currentRange.end"><ChevronRightIcon /></button>
        </div>
        <div class="grid grid-cols-5 bg-gray-300 gap-1 justify-center items-center p-2">
          <button
            class="p-2 rounded-lg text-center button hover:bg-gray-200"
            v-for="year in range(currentRange.start, currentRange.end)"
            :key="year"
            :class="{ 'bg-blue-700 text-white hover:bg-blue-700': year === chosenYear }"
            @click.prevent="chosenYear = year"
          >
            {{ year }}
          </button>
        </div>
      </div>
    </div>

    <div class="flex justify-end px-4 py-3 bg-gray-300">
      <button @click="confirm" type="button" class="button px-6 py-1 lg:py-2 text-sm bg-blue-800 hover:bg-blue-900 font-bold text-white">Xác nhận</button>
    </div>
  </vue-final-modal>
</template>

<script>
import ChevronLeftIcon from 'vue-material-design-icons/ChevronLeft.vue'
import ChevronRightIcon from 'vue-material-design-icons/ChevronRight.vue'
import _range from 'lodash/range'
import dayjs from 'dayjs'

export default {
  components: {
    ChevronLeftIcon,
    ChevronRightIcon
  },

  props: {
    value: Boolean,
    defaultUI: String
  },

  data () {
    return {
      show: this.value,
      chosenYear: dayjs().year(),
      currentYear: dayjs().year(),
      currentRange: {
        start: dayjs().year() - (dayjs().year() % 10),
        end: dayjs().year() - (dayjs().year() % 10) + 10
      },
      range: _range
    }
  },

  mounted () {
    const year = localStorage.getItem('previouslyChosenBirthYear')

    if (year && Number(year)) {
      this.chosenYear = Number(year)
      this.currentRange.start = year - (year % 10)
      this.currentRange.end = year - (year % 10) + 10
    }
  },

  methods: {
    decadeBack () {
      this.currentRange.start -= 10
      this.currentRange.end -= 10
    },

    decadeForward () {
      this.currentRange.start += 10
      this.currentRange.end += 10
    },

    confirm () {
      if (this.currentYear - this.chosenYear >= 18) {
        localStorage.setItem('previouslyChosenBirthYear', this.chosenYear)
        sessionStorage.setItem('isAgeVerified', 1)
        this.$emit('input', false)
      } else {
        localStorage.setItem('previouslyChosenBirthYear', this.chosenYear)
        sessionStorage.setItem('isAgeVerified', 0)
        this.$router.push({ name: 'Home' })
        this.$emit('input', false)
      }
    },

    cancel () {
      this.$emit('input', false)
    }
  },

  watch: {
    value (to) {
      if (to) {
        this.show = true
        this.ui = this.defaultUI
      } else {
        this.show = false
      }
    },

    show (to, from) {
      if (!to) {
        this.cancel()
      }
    }
  }
}
</script>
