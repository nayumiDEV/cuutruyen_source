<template>
  <div class="w-full rounded-lg fine-transition bg-white flex flex-wrap relative" :class="{ 'ring': isFocus }">
    <div class="flex flex-wrap gap-1 grow flex-none w-full h-full px-4 py-2 items-center">
      <div v-for="(tag, index) in value" :key="index" class="flex border-2 rounded-full border-gray-200 h-8 items-center bg-gray-100">
        <div class="rounded-l-full px-3 bg-gray-100 text-gray-600 text-sm font-bold cursor-default h-full flex items-center">{{ tag }}</div>
        <button type="button" class="rounded-full bg-red-100 text-red-700 hover:bg-red-200 active:bg-red-300 transition aspect-square flex items-center justify-center h-full" @click="removeTag(index)"><CloseIcon :size="16" /></button>
      </div>
      <input :value="currentInput" class="min-w-[120px] w-48 h-7 grow outline-none" type="text" placeholder="Nhập thẻ bạn muốn thêm..." ref="inputEl" @focus="isFocus = true" @focusout="isFocus = false" @input="onInput" @keydown="checkKeyPress">
    </div>

    <div class="absolute top-full left-0 w-full mt-2 h-auto max-h-[15rem] border border-gray-200 rounded-lg bg-white overflow-auto z-30 p-4" v-show="shouldShowDropdown">
      <div v-if="currentInput !== ''" class="flex flex-wrap gap-1">
        <a
          v-if="!tagsFound.length || currentInput !== tagsFound[0].name"
          class="tag-item"
          :class="{ 'tag-item-active': currentPointer === -1 }"
        >
          <TagPlusIcon :size="16" />
          <span>Thêm <strong>{{ currentInput }}</strong></span>
        </a>
        <template v-if="tagsFound && tagsFound.length">
          <a
            v-for="(tag, index) in tagsFound"
            class="tag-item"
            :class="{ 'tag-item-active': currentPointer === index }"
            :key="index"
            @click.prevent="addTag(tag.name)"
          >
            <TagIcon :size="16" />
            <span>{{ tag.name }}</span>
            <div class="rounded-full text-[9px] lg:text-[10px] bg-gray-300 text-gray-700 h-5 w-5 flex justify-center items-center">{{ tag.tagging_count }}</div>
          </a>
        </template>
      </div>

      <div v-else>
        <div class="mb-4">
          <div class="text-xs font-bold text-gray-500 uppercase mb-1">Chính</div>
          <div class="flex flex-wrap gap-1">
            <a
              v-for="(tag, index) in commonTags"
              class="tag-item"
              :key="index"
              @click.prevent="addTag(tag.name)"
            >
              <TagIcon :size="16" />
              <span>{{ tag.name }}</span>
              <div class="rounded-full text-[9px] lg:text-[10px] bg-gray-300 text-gray-700 h-5 w-5 flex justify-center items-center">{{ tag.tagging_count }}</div>
            </a>
          </div>
        </div>

        <div class="mb-4">
          <div class="text-xs font-bold text-gray-500 uppercase mb-1">Lưu ý</div>
          <div class="flex flex-wrap gap-1">
            <a
              v-for="(tag, index) in warningTags"
              class="tag-item"
              :key="index"
              @click.prevent="addTag(tag.name)"
            >
              <TagIcon :size="16" />
              <span>{{ tag.name }}</span>
              <div class="rounded-full text-[9px] lg:text-[10px] bg-gray-300 text-gray-700 h-5 w-5 flex justify-center items-center">{{ tag.tagging_count }}</div>
            </a>
          </div>
        </div>

        <div class="mb-4">
          <div class="text-xs font-bold text-gray-500 uppercase mb-1">Phổ biến</div>
          <div class="flex flex-wrap gap-1">
            <a
              v-for="(tag, index) in normalTags"
              class="tag-item"
              :key="index"
              @click.prevent="addTag(tag.name)"
            >
              <TagIcon :size="16" />
              <span>{{ tag.name }}</span>
              <div class="rounded-full text-[9px] lg:text-[10px] bg-gray-300 text-gray-700 h-5 w-5 flex justify-center items-center">{{ tag.tagging_count }}</div>
            </a>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import CloseIcon from 'vue-material-design-icons/Close.vue'
import TagIcon from 'vue-material-design-icons/Tag.vue'
import TagPlusIcon from 'vue-material-design-icons/TagPlus.vue'
import { getPopularTags, searchTags } from '@/apis/user'
import debounce from 'lodash.debounce'

export default {
  components: {
    CloseIcon,
    TagIcon,
    TagPlusIcon
  },

  props: {
    value: Array
  },

  data () {
    return {
      currentInput: '',
      isFocus: false,
      tagsFound: [],
      commonTags: [],
      warningTags: [],
      normalTags: [],
      shouldShowDropdown: false,
      doSearchDebounced: debounce(this.doSearch, 200, { leading: true }),
      currentPointer: -1
    }
  },

  mounted () {
    this.doGetPopular()
  },

  methods: {
    onInput (event) {
      this.currentInput = event.target.value
    },

    addTag (tag) {
      const newTag = tag.toLowerCase().replace(/,/g, '').trim()
      const pattern = /^[aAàÀảẢãÃáÁạẠăĂằẰẳẲẵẴắẮặẶâÂầẦẩẨẫẪấẤậẬbBcCdDđĐeEèÈẻẺẽẼéÉẹẸêÊềỀểỂễỄếẾệỆfFgGhHiIìÌỉỈĩĨíÍịỊjJkKlLmMnNoOòÒỏỎõÕóÓọỌôÔồỒổỔỗỖốỐộỘơƠờỜởỞỡỠớỚợỢpPqQrRsStTuUùÙủỦũŨúÚụỤưƯừỪửỬữỮứỨựỰvVwWxXyYỳỲỷỶỹỸýÝỵỴzZ0123456789 ]+$/

      if (newTag === '') {
        return
      }

      if (!pattern.test(newTag)) {
        this.$notify({
          type: 'warn',
          text: 'Thẻ bạn định thêm có chứa ký tự không hợp lệ'
        })
        return
      }

      if (this.value.includes(newTag)) {
        this.$notify({
          type: 'warn',
          text: 'Bạn đã thêm thẻ này rồi'
        })
        return
      }

      this.$emit('input', [...this.value, newTag])
      this.currentInput = ''
    },

    removeTag (index) {
      const tags = [...this.value]
      tags.splice(index, 1)

      this.$emit('input', [...tags])
    },

    checkKeyPress (event) {
      if (event.key === 'Enter'/* || event.key === ',' */) {
        event.preventDefault()
        if (this.currentInput === '') {
          return
        }

        if (this.currentPointer === -1) {
          this.addTag(this.currentInput)
        } else {
          this.addTag(this.tagsFound[this.currentPointer].name)
        }
      }

      if (event.key === 'Backspace' && this.currentInput === '') {
        event.preventDefault()

        this.removeTag(this.value.length - 1)
      }

      if (event.key === 'ArrowUp') {
        event.preventDefault()

        if (this.currentPointer > -1) {
          this.currentPointer = this.currentPointer - 1
        } else {
          this.currentPointer = this.tagsFound.length - 1
        }
      }

      if (event.key === 'ArrowDown' || event.key === 'Tab') {
        event.preventDefault()

        if (this.currentPointer < this.tagsFound.length - 1) {
          this.currentPointer = this.currentPointer + 1
        } else {
          this.goToFirst()
        }
      }
    },

    goToFirst () {
      if (this.currentInput === '') {
        this.currentPointer = 0
        return
      }

      if (!this.tagsFound.length) {
        this.currentPointer = -1
        return
      }

      if (this.currentInput !== this.tagsFound[0].name) {
        this.currentPointer = -1
      } else {
        this.currentPointer = 0
      }
    },

    async doSearch () {
      const response = await searchTags(this.currentInput)
      this.tagsFound = response.data

      if (this.tagsFound) {
        this.shouldShowDropdown = true
      }

      this.goToFirst()
    },

    async doGetPopular () {
      const response = await getPopularTags()

      this.commonTags = response.data.common_tags
      this.warningTags = response.data.warning_tags
      this.normalTags = response.data.normal_tags
    }
  },

  watch: {
    async currentInput (to, from) {
      if (to !== '') {
        this.doSearchDebounced()
      } else {
        this.tagsFound = []
        this.goToFirst()
      }
    },

    isFocus (to, from) {
      if (to) {
        this.shouldShowDropdown = true
      } else {
        setTimeout(() => {
          this.shouldShowDropdown = false
        }, 200)
      }
    }
  }
}
</script>

<style scoped>
.tag-item {
  @apply px-3 py-1 hover:bg-gray-100 font-bold text-gray-600 text-sm transition block cursor-pointer rounded-full flex items-center border-2 border-gray-100 h-8 gap-1;
}

.tag-item-active {
  @apply bg-blue-700 hover:bg-blue-800 text-blue-100;
}
</style>
