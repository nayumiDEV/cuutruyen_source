<template>
  <div>
    <template v-if="loading">
      <LoadingScreen />
    </template>

    <template v-else-if="error">
      <ErrorScreen />
    </template>

    <template v-else-if="chapter">
      <div class="common-container">
        <h2 class="text-lg font-head font-semibold text-gray-700 mt-12 mb-4 hover:text-blue-700">
          <router-link :to="{ name: 'TeamChapterManagement', params: { translationId: chapter.translation.id } }">
            {{ chapter.translation.manga.name }}
          </router-link>
        </h2>

        <h1 class="text-3xl font-head font-bold text-gray-800 mb-12">Ch. {{ chapter.number }} - {{ chapter.name }}</h1>
      </div>

      <div class="common-container">
        <form @submit.prevent="formSubmit" class="grid grid-form gap-8">
          <div class="mb-8">
            <div class="block pb-4 uppercase tracking-wide text-gray-700 font-semibold border-b border-gray-400">Thông tin cơ bản</div>
            <div class="text-gray-700 my-4">
              Số chương nên được nhập là một số (ví dụ: <strong>1</strong>, <strong>2</strong>, <strong>3</strong>,...). Tuy nhiên, bạn vẫn có thể vào nhập chuỗi bất kỳ mà bạn mong muốn (ví dụ: <strong>005</strong>, <strong>2.5</strong>, <strong>3 (Fixed)</strong>,...).
            </div>

            <div class="text-gray-700 my-4">
              Nên tránh nhập số chương ở phần tên chương. Tên chương được phép để trống nếu bạn không cần đặt.
            </div>
          </div>
          <div class="mb-8">
            <label for="chapterNumber" class="block mb-4 text-xs uppercase tracking-wide text-gray-700 font-semibold">Số chương</label>
            <input
              v-model="chapter.number"
              id="chapterNumber"
              class="input mb-8"
              type="text" placeholder="Số chương"
            >
            <label for="chapterName" class="block mb-4 text-xs uppercase tracking-wide text-gray-700 font-semibold">Tên chương</label>
            <input
              v-model="chapter.name"
              id="chapterName"
              class="input mb-8"
              type="text" placeholder="Tên chương"
            >
          </div>

          <div class="mb-8">
            <div class="block pb-4 uppercase tracking-wide text-gray-700 font-semibold border-b border-gray-400">Tải lên trang truyện</div>
            <div class="text-gray-700 my-4">
              Định dạng hỗ trợ: jpg, png.
            </div>

            <div class="text-gray-700 my-4">
              Nhấn vào nút <strong>Sắp xếp theo tên file</strong> để thực hiện tự động sắp xếp theo tên, hữu dụng nếu bạn để tên file là <strong>001.jpg</strong>, <strong>002.jpg</strong>,...
            </div>

            <div class="text-gray-700 my-4">
              Bạn luôn có thể xem trước, xóa, hay di chuyển thứ tự của các trang truyện (bằng cách kéo thả).
            </div>

            <div class="text-yellow-700 my-4">
              Các thay đổi (bao gồm thêm và xóa các trang) đều là tạm thời và chỉ được lưu lại khi bạn nhấn vào nút <i>Sửa chương này</i> bên dưới.
            </div>
          </div>
          <div class="mb-8">
            <label for="fileInput" class="block mb-4 text-xs uppercase tracking-wide text-gray-700 font-semibold">Chọn ảnh</label>
            <div class="mb-8">
              <label for="fileInput" class="inline-block button bg-gray-400 hover:bg-gray-500 hover:border-gray-600
                px-32 py-4 cursor-pointer flex flex-col items-center border-2 border-gray-500 border-dashed">
                <PlusIcon class="mb-2 block" /><div>Chọn ảnh</div>
              </label>

              <input type="file" id="fileInput" ref="fileInput" @change="handleFileInput" class="hidden" accept="image/png, image/jpeg" multiple>
            </div>

            <template v-if="chapter.pages.length > 0">
              <label class="block mb-4 text-xs uppercase tracking-wide text-gray-700 font-semibold">Các trang đã chọn</label>

              <div class="flex mb-4">
                <button v-show="chapter.pages.length > 0" @click.prevent="filesSort" type="button" class="button bg-white hover:bg-blue-800 hover:text-white px-4 py-2 mr-2 shadow">Sắp xếp theo tên file</button>
                <button
                  v-show="chapter.pages.length > 0"
                  @click.prevent="markDeleteAllPages"
                  type="button"
                  class="button bg-red-300 text-red-800 hover:bg-red-400 px-4 py-2 shadow"
                >Xóa tất cả trang</button>
              </div>

              <draggable tag="div" v-model="chapter.pages" @start="startDrag" @end="endDrag"
                v-bind="{ animation: 200, ghostClass: 'ghost', scrollSensitivity: 150 }"
                class="mb-8 grid grid-custom gap-4">
                <div v-for="(page, index) in chapter.pages" :key="page.index" v-show="!page.isMarkedForDestruction" class="relative rounded-lg overflow-hidden">
                  <a @click="zoomIndex = index" class="block overflow-hidden w-32 h-32 rounded-lg cursor-pointer" :class="{ 'opacity-40': page.isMarkedForDestruction }">
                    <img v-if="page.imageNormalUrl" :src="page.imageNormalUrl" class="w-full h-full object-cover" alt="">
                    <img v-else-if="page.imageOriginalUrl" :src="page.imageOriginalUrl" class="w-full h-full object-cover" alt="">
                    <img v-else :src="page.blobUrl" class="w-full h-full object-cover" alt="">
                  </a>
                  <div class="truncate mt-1 text-sm text-gray-700 font-bold" :title="page.imageFilename">{{ page.imageFilename }}</div>

                  <div v-if="!page.isPersisted" class="absolute top-0 left-0 text-yellow-600 m-1"><NewBoxIcon /></div>

                  <button v-if="!page.preparing" @click="removeFile(page, index)" type="button"
                    class="absolute top-0 right-0 bg-gray-300 hover:bg-red-300 hover:text-red-800 p-1 m-1 rounded-full shadow focus:outline-none z-10"
                    :class="{ 'bg-red-800 text-white': page.isMarkedForDestruction }"
                  >
                    <CloseIcon :size="16" />
                  </button>

                  <div class="text-white bg-black bg-opacity-70 absolute top-0 right-0 w-full h-full flex items-center justify-center" v-show="page.preparing">
                    <LoadingIcon class="spin rounded-full p-2" />
                  </div>

                  <div class="text-white bg-black bg-opacity-70 absolute top-0 right-0 w-full h-full flex flex-col items-center justify-center" v-show="page.denied || page.errors.image">
                    <AlertCircleIcon class="rounded-full p-2" />
                    <p v-if="page.errors.image" class="w-full text-xs text-gray-300 text-center line-clamp-3 px-1" :title="page.errors.image.message">{{ page.errors.image.message }}</p>
                  </div>
                </div>
              </draggable>

              <Tinybox
                v-model="zoomIndex"
                :images="images"
              />
            </template>
          </div>

          <div><!-- filler for grid  --></div>
          <div>
            <button class="button px-8 py-3 text-xl"
              :class="{ 'button-primary': !disallowSave, 'button-disabled': disallowSave }"
              :disabled="disallowSave">
              Sửa chương này
            </button>
          </div>
        </form>
      </div>
    </template>
  </div>
</template>

<script>
import Draggable from 'vuedraggable'
import { Chapter, Page } from '@/models'
import CloseIcon from 'vue-material-design-icons/Close.vue'
import PlusIcon from 'vue-material-design-icons/Plus.vue'
import NewBoxIcon from 'vue-material-design-icons/NewBox.vue'
import LoadingIcon from 'vue-material-design-icons/Loading.vue'
import AlertCircleIcon from 'vue-material-design-icons/AlertCircle.vue'
import Tinybox from 'vue-tinybox'
import natsort from 'natsort'

const sorter = natsort()

export default {
  components: {
    Draggable,
    CloseIcon,
    PlusIcon,
    NewBoxIcon,
    LoadingIcon,
    AlertCircleIcon,
    Tinybox
  },

  data () {
    return {
      chapter: null,
      drag: false,
      adding: false,
      loading: false,
      error: false,
      zoomIndex: null
    }
  },

  computed: {
    disallowSave () {
      return this.isPreparing || this.adding || this.hasDenied
    },

    isPreparing () {
      return this.chapter.pages.some(p => p.preparing)
    },

    hasDenied () {
      return this.chapter.pages.some(p => p.denied)
    },

    images () {
      return this.chapter.pages.map(p => {
        if (p.imageNormalUrl) {
          return { src: p.imageNormalUrl, caption: p.imageFilename }
        } else if (p.imageOriginalUrl) {
          return { src: p.imageOriginalUrl, caption: p.imageFilename }
        } else {
          return { src: p.blobUrl, caption: p.imageFilename }
        }
      })
    }
  },

  async mounted () {
    this.loading = true
    try {
      this.chapter = (await Chapter.includes(['pages', { translation: 'manga' }]).order({ 'pages.order': 'asc' }).find(this.$route.params.chapterId)).data
    } catch (error) {
      this.error = true
      throw error
    } finally {
      this.loading = false
    }
  },

  methods: {
    async formSubmit () {
      this.adding = true

      try {
        const save = await this.chapter.save({ with: 'pages' })

        if (save) {
          this.$notify({
            type: 'success',
            text: 'Cập nhật chương thành công!'
          })

          this.$router.push({ name: 'TeamChapterManagement', params: { mangaId: this.chapter.translation.manga.id } })
        } else {
          this.$notify({
            type: 'warn',
            text: 'Vui lòng kiểm tra lại nội dung bạn nhập!'
          })
        }
      } catch (error) {
        this.$notify({
          type: 'error',
          text: 'Có lỗi xảy ra khi cập nhật chương này.'
        })

        throw error
      } finally {
        this.adding = false
      }
    },

    async doDirectUpload (file, page) {
      const formData = new FormData()
      formData.append('file', file)

      try {
        const response = await fetch(`${process.env.VUE_APP_API_NAMESPACE}/upload/image`, {
          method: 'POST',
          body: formData
        })
        const data = await response.json()

        this.$set(page, 'image', JSON.stringify(data))
      } catch (error) {
        this.$set(page, 'denied', true)
        this.$notify({
          type: 'error',
          text: `Trang có tên ${file.name} bị lỗi khi tải lên.`
        })
        throw error
      } finally {
        this.$set(page, 'preparing', false)
      }
    },

    async handleFileInput () {
      const files = this.$refs.fileInput.files

      let orderIterator = 0

      if (this.chapter.pages.length > 0) {
        orderIterator = this.chapter.pages[this.chapter.pages.length - 1].order + 1
      }

      for (let i = 0; i < files.length; i++) {
        const page = new Page({
          order: orderIterator
        })

        page.preparing = true
        page.blobUrl = URL.createObjectURL(files[i])
        page.imageFilename = files[i].name

        this.chapter.pages.push(page)
        this.doDirectUpload(files[i], page)

        orderIterator++
      }
    },

    filesSort () {
      this.chapter.pages.sort((a, b) => {
        return sorter(a.imageFilename, b.imageFilename)
      })

      this.filesUpdateOrder()
    },

    filesUpdateOrder () {
      let incOrder = 0
      for (let i = 0; i < this.chapter.pages.length; i++) {
        this.chapter.pages[i].order = incOrder
        incOrder++
      }
    },

    removeFile (page, index) {
      if (!page.isPersisted) {
        this.chapter.pages.splice(index, 1)
        this.filesUpdateOrder()
      } else if (page.isMarkedForDestruction) {
        page.isMarkedForDestruction = false
      } else {
        page.isMarkedForDestruction = true
      }
    },

    markDeleteAllPages () {
      this.chapter.pages.forEach((page, index) => {
        if (!page.isPersisted) {
          this.chapter.pages.splice(index, 1)
        } else {
          page.isMarkedForDestruction = true
        }
      })
    },

    startDrag () {
      this.drag = true
    },

    endDrag () {
      this.drag = false

      this.filesUpdateOrder()
    }
  }
}
</script>

<style scoped>
.grid-form {
  grid-template-columns: 2fr 5fr;
}

.grid-custom {
  grid-template-columns: repeat( auto-fit, 8rem );
}

.ghost img {
  @apply opacity-50;
}
</style>
