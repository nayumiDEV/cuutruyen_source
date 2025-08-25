<template>
  <div>
    <div class="h-screen fixed top-0 left-0 bottom-0 right-0 w-full z-40 bg-black transition-all fine-transition" @click.stop="overlayClicked"
      :class="{
        'bg-opacity-0 invisible': !value,
        'bg-opacity-80': value
        }"
    ></div>
    <div class="fixed top-0 left-0 w-full bg-white p-4 z-50 transform transition-all flex flex-col items-center"
      :class="{
        'shadow': value,
        '-translate-y-full': !value
        }"
    >
      <div class="max-w-screen-md w-full">
        <input
          v-model="searchKeyword"
          @input="doSearchDebounced"
          ref="inputBox"
          class="px-4 py-2 bg-gray-200 focus:bg-gray-100 fine-transition rounded-lg w-full outline-none focus:ring"
          type="text" placeholder="Tìm kiếm truyện">

        <div v-if="!isLoading && hasResults" class="mt-3 bg-gray-200 rounded-lg overflow-hidden">
          <QuickSearchItem class="border-b-2 border-white last:border-b-0" v-for="manga in searchResults" :key="`qsr.${manga.id}`" :manga="manga" />

          <router-link v-if="hasResults" :to="{ name: 'Search', params: { keyword: searchKeyword } }" @click="$emit('input', false)" class="flex p-2 hover:bg-gray-300 fine-transition">
            Tìm tất cả kết quả cho từ khóa {{ searchKeyword }}
          </router-link>
        </div>

        <div v-else-if="isLoading" class="mt-3 bg-white rounded-lg p-2 italic text-gray-700">
          Đang tìm kiếm...
        </div>

        <div v-else-if="!hasResults && searchKeyword.length > 2" class="mt-3 bg-white rounded-lg p-2 italic text-gray-700">
          Không tìm thấy kết quả nào cho từ khóa <strong>{{ searchKeyword }}</strong>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import vClickOutside from 'v-click-outside'
import debounce from 'lodash.debounce'
import QuickSearchItem from '../QuickSearchItem'
import { quickSearch } from '@/apis/user'

export default {
  components: {
    QuickSearchItem
  },

  directives: {
    clickOutside: vClickOutside.directive
  },

  props: {
    value: {
      type: Boolean,
      default: false
    }
  },

  data () {
    return {
      doSearchDebounced: debounce(this.doSearch, 200, { leading: true }),
      searchResults: [],
      searchKeyword: '',
      isLoading: false
    }
  },

  computed: {
    hasResults () {
      if (!this.searchResults) {
        return false
      }

      if (this.searchResults.length > 0) {
        return true
      }

      return false
    }
  },

  methods: {
    overlayClicked () {
      this.$emit('input', false)
    },

    async doSearch () {
      if (this.searchKeyword.length >= 2) {
        try {
          const keyword = this.searchKeyword
          const mangas = (await quickSearch(keyword, 1, 5)).data

          if (this.searchKeyword === keyword) {
            this.searchResults = mangas
          }
        } catch (error) {
          this.searchResults = []
          throw error
        } finally {
          this.isLoading = false
        }
      } else {
        this.searchResults = []
      }
    }
  },

  watch: {
    value (newValue) {
      if (newValue) {
        this.$refs.inputBox.focus()
        this.lockBodyScroll()
      } else {
        this.searchKeyword = ''
        this.hasResults = true
        this.searchResults = []
        this.releaseBodyScroll()
      }
    }
  },

  beforeDestroy () {
    this.releaseBodyScroll()
  }
}
</script>
