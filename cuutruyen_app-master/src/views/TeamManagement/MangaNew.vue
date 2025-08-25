<template>
  <div class="common-container p-2">
    <form @submit.prevent="formSubmit">
      <CuuHeading>Thêm truyện mới</CuuHeading>

      <div class="form-section">
        <div class="form-section-description">
          <div class="font-bold text-gray-600 mb-4">Thông tin cơ bản</div>
          <div class="text-gray-500 text-sm">
            <p class="mb-2">Nhập các thông tin cơ bản của truyện.</p>
            <p class="mb-2">Bạn có thể thêm nhiều tên truyện của nhiều ngôn ngữ khác nhau (theo tiếng Nhật, Anh, Hàn, Việt,...). Tên bạn đặt làm mặc định sẽ được chọn làm tên hiển thị trên Cứu Truyện. Các tên khác bạn thêm tuy không được hiển thị, nhưng vẫn có thể giúp người dùng dễ dàng tìm thấy truyện của bạn qua mục tìm kiếm.</p>
          </div>
        </div>

        <div class="form-section-input">
          <div class="mb-12">
            <label for="name" class="label">Tên truyện <span class="text-red-800 font-bold">*</span></label>
            <InputMangaTitle v-for="(title, index) in manga.titles_attributes" :key="title.id" v-model="manga.titles_attributes[index].name" :primary="title.primary" class="mt-4" @setTitlePrimary="setTitlePrimary(title)" @deleteTitle="deleteTitleByIndex(index)" />

            <div class="mt-4">
              <button @click="addNewTitle()" type="button" class="px-2 py-1 rounded transition bg-gray-200 hover:bg-gray-800 hover:text-gray-100 focus:ring ring-gray-500 text-gray-600 text-sm font-bold flex items-center">
                <PlusIcon :size="16" class="mr-2" />
                Thêm tên khác
              </button>
            </div>
          </div>

          <div class="mb-12">
            <label for="name" class="label">Tên tác giả <span class="text-red-800 font-bold">*</span></label>
            <input
              v-model="manga.author_attributes.name"
              id="authorName"
              class="input mt-4"
              type="text" placeholder="Tên tác giả"
            >
            <div class="mt-4 validate" v-if="errors && errors['author.name']">{{ errors['author.name'][0] }}</div>
          </div>

          <div class="mb-12">
            <label for="description" class="label">Mô tả (dưới 10000 ký tự) <span class="text-red-800 font-bold">*</span></label>
            <DescriptionEditor v-model="manga.full_description" class="mt-4" />
            <div class="mt-4 validate" v-if="errors && errors.full_description">{{ errors.full_description[0] }}</div>
          </div>

          <div class="mb-12">
            <div v-if="isShortDescription">
              <label for="description" class="label">Mô tả ngắn (dưới 170 ký tự)</label>
              <textarea
                v-model="manga.description"
                id="description"
                class="textarea mt-4"
                type="text" placeholder="Mô tả ngắn"
              ></textarea>
              <div class="mt-4 validate" v-if="errors && errors.description">{{ errors.description[0] }}</div>
            </div>

            <div v-else>
              <button @click="isShortDescription = true" type="button" class="px-2 py-1 rounded transition bg-gray-200 hover:bg-gray-800 hover:text-gray-100 focus:ring ring-gray-500 text-gray-600 text-sm font-bold flex items-center">
                <PlusIcon :size="16" class="mr-2" />
                Thêm mô tả ngắn
              </button>
            </div>
          </div>
        </div>
      </div>

      <hr class="form-divider">

      <div class="form-section">
        <div class="form-section-description">
          <div class="font-bold text-gray-600 mb-4">Thêm thẻ cho truyện</div>
          <div class="text-gray-500 text-sm">
            <p class="mb-2">Kết thúc nhập một thẻ bằng cách nhấn enter. Nhấn phím TAB hoặc phím mũi tên lên/xuống để chuyển qua lại giữa các thẻ được gợi ý.</p>
            <p class="mb-2">Xóa một thẻ đã thêm bằng cách nhấn backspace hoặc nhấn vào icon xóa bên cạnh tag.</p>
            <p class="mb-2">Tên thẻ có thể là ký tự tiếng việt, không viết hoa, <strong>không chứa các ký tự đặc biệt</strong> trừ dấu cách.</p>
            <p class="mb-2">Đôi khi, <strong>giữ nguyên tên thẻ bằng tiếng Anh</strong> hoặc thuật ngữ gốc (fantasy, shounen,...) sẽ tốt hơn là cố dịch tên thẻ đó sang tiếng Việt.</p>
          </div>
        </div>
        <div class="form-section-input">
          <div class="mb-12">
            <label for="tags-input" class="label">Thẻ</label>
            <TagsInput class="mt-4" v-model="manga.tags_list" />
          </div>
        </div>
      </div>

      <hr class="form-divider">

      <div class="form-section">
        <div class="form-section-description">
          <div class="font-bold text-gray-600 mb-4">Hình ảnh</div>
          <div class="text-gray-500 mb-4 text-sm">
            <p class="mb-2">Tải lên các hình đại diện cho truyện của bạn.</p>
            <p class="mb-2">Ảnh bìa của truyện có dạng <strong>khổ dọc</strong>, với kích thước tỷ lệ 2:3 (tối ưu là 1000×1500 pixel trở lên).</p>
            <p class="mb-2">Ảnh toàn cảnh là một ảnh <strong>khổ ngang</strong>, với kích thước tỷ lệ 16:9 (tối ưu là 1920×1080 pixel trở lên), được Cứu Truyện hiện ở Spotlight và phần thông tin truyện. Bạn có thể chọn ảnh toàn cảnh từ một trang đôi nổi bật của truyện, từ fanart hoặc từ Anime của truyện.</p>
            <p>Chọn ảnh toàn cảnh đẹp và độ phân giải cao để <strong>tăng cơ hội</strong> cho truyện của bạn được hiện trên mục Spotlight của Cứu Truyện.</p>
          </div>
        </div>

        <div class="form-section-input">
          <div class="mb-12">
            <label for="cover" class="label">Bìa truyện <span class="text-red-800 font-bold">*</span></label>
            <CoverUploader class="mt-4" :hasCover="hasCover" :coverPreparing="coverPreparing" :coverDenied="coverDenied" :coverPreview="coverPreview"
              @removeCover="removeCover" @uploadCover="uploadCover" />
          </div>

          <div class="mb-12">
            <label for="panorama" class="label">Ảnh toàn cảnh <span class="text-red-800 font-bold">*</span></label>
            <PanoramaUploader class="mt-4" :hasPanorama="hasPanorama" :panoramaPreparing="panoramaPreparing" :panoramaDenied="panoramaDenied"
              :panoramaPreview="panoramaPreview" @removePanorama="removePanorama" @uploadPanorama="uploadPanorama"
              :focusX="manga.focusX" :focusY="manga.focusY" @focusXChanged="manga.focusX = parseInt($event)" @focusYChanged="manga.focusY = parseInt($event)" />
          </div>
        </div>
      </div>

      <hr class="form-divider">

      <div class="form-section">
        <div class="form-section-description">
          <div class="font-bold text-gray-600 mb-2">Thông tin bổ sung</div>
          <div class="text-gray-500 mb-4 text-sm">
            <p class="mb-2">Chọn đúng <strong>dạng truyện</strong> tương ứng với truyện hiện tại của bạn để Cứu Truyện tối ưu hóa hình ảnh và hiển thị chính xác.</p>
            <p class="mb-2" v-if="!manga.marginless">Chọn đúng <strong>chiều đọc truyện</strong> để chế độ đọc ngang của Cứu Truyện hiển thị theo chiều tương ứng. Với đa số manga Nhật Bản, chiều đọc truyện là từ <strong>phải qua trái</strong>. Với các truyện Việt Nam hoặc comic Âu Mỹ, chiều đọc truyện thường là từ <strong>trái qua phải</strong>.</p>
            <p>
              Điền liên kết đến trang đọc/mua của nhà xuất bản tại phần <strong>Trang chính thức của nhà xuất bản</strong>.
              Bạn có thể tìm liên kết này trong phần Read or Buy của từng truyện trên trang mangadex.org.
              <strong>Không đặt</strong> liên kết đến facebook cá nhân/trang web cá nhân của bạn hoặc nhóm bạn vào mục này!
            </p>
          </div>
        </div>

        <div class="form-section-input">
          <div class="mb-12">
            <label class="label">Dạng truyện <span class="text-red-800 font-bold">*</span></label>

            <div class="mt-4 flex">
              <input class="mr-1" type="radio" id="margin" name="marginless" :value="false" v-model="manga.marginless">
              <label class="text-gray-800" for="margin">Các trang <strong>riêng biệt</strong> (manga, comic,...)</label>
            </div>

            <div class="mt-2 flex">
              <input class="mr-1" type="radio" id="marginless" name="marginless" :value="true" v-model="manga.marginless">
              <label class="text-gray-800" for="marginless">Các trang <strong>liền nhau</strong> (webtoon, manhwa,...)</label>
            </div>
          </div>

          <div class="mb-12" v-if="!manga.marginless">
            <label class="label">Chiều đọc truyện <span class="text-red-800 font-bold">*</span></label>

            <div class="mt-4 flex">
              <input class="mr-1" type="radio" id="rtl" name="direction" value="rtl" v-model="manga.direction">
              <label class="text-gray-800" for="rtl"> Từ phải sang trái</label>
            </div>

            <div class="mt-2 flex">
              <input class="mr-1" type="radio" id="ltr" name="direction" value="ltr" v-model="manga.direction">
              <label class="text-gray-800" for="ltr">Từ trái sang phải</label>
            </div>
          </div>

          <div class="mb-12">
            <label for="name" class="label">Trang chính thức của nhà xuất bản</label>
            <input
              v-model="manga.official_url"
              class="input mt-4"
              type="text" placeholder="https://"
            >
          </div>
        </div>
      </div>

      <hr class="form-divider">

      <div class="form-section">
        <div></div>
        <div>
          <button class="button px-8 py-3"
            :class="{ 'button-primary': !disallowSave, 'button-disabled': disallowSave }"
            :disabled="disallowSave">
            Thêm truyện
          </button>
        </div>
      </div>
    </form>
  </div>
</template>

<script>
import { createTeamManga } from '@/apis/team'
import CoverUploader from '@/components/team-management/CoverUploader'
import PanoramaUploader from '@/components/team-management/PanoramaUploader'
import InputMangaTitle from '@/components/team-management/InputMangaTitle'
import TagsInput from '@/components/team-management/TagsInput'
import PlusIcon from 'vue-material-design-icons/Plus.vue'
import DescriptionEditor from '@/components/team-management/DescriptionEditor'

export default {
  components: {
    CoverUploader,
    PanoramaUploader,
    InputMangaTitle,
    TagsInput,
    DescriptionEditor,
    PlusIcon
  },

  data () {
    return {
      manga: {
        titles_attributes: [
          {
            name: '',
            primary: true
          }
        ],
        description: '',
        full_description: '',
        author_attributes: {
          name: ''
        },
        cover: '',
        panorama: '',
        marginless: false,
        direction: 'rtl',
        official_url: '',
        tags_list: []
      },
      coverPreview: null,
      panoramaPreview: null,
      submitting: false,
      coverPreparing: false,
      panoramaPreparing: false,
      coverDenied: false,
      panoramaDenied: false,
      hasCover: false,
      hasPanorama: false,
      isShortDescription: false,
      errors: null
    }
  },

  props: {
    layoutProps: {
      type: Object,
      default: null
    }
  },

  computed: {
    team () {
      return this.layoutProps.team
    },

    disallowSave () {
      return this.coverPreparing || this.panoramaPreparing || !this.hasCover || !this.hasPanorama ||
             this.coverDenied || this.panoramaDenied || this.submitting
    }
  },

  methods: {
    async formSubmit () {
      this.submitting = true
      try {
        await createTeamManga(this.team.id, { manga: this.manga })

        this.$notify({
          type: 'success',
          text: 'Thêm truyện thành công!'
        })

        this.$router.push({ name: 'TeamMangaManagement' })
      } catch (error) {
        if (error.response.status === 422) {
          this.$notify({
            type: 'warn',
            text: 'Vui lòng kiểm tra lại nội dung bạn nhập!'
          })
          const response = await error.response.json()
          this.errors = response.data
          console.error(error)
        } else {
          this.$notify({
            type: 'error',
            text: 'Có lỗi xảy ra khi thêm truyện.'
          })

          throw error
        }
      } finally {
        this.submitting = false
      }
    },

    removeCover () {
      this.manga.cover = null
      this.hasCover = false
      this.coverChanged = true
    },

    removePanorama () {
      this.manga.panorama = null
      this.hasPanorama = false
      this.panoramaChanged = true
    },

    async uploadCover (file) {
      this.hasCover = true
      this.coverPreparing = true
      this.coverDenied = false

      try {
        this.coverPreview = URL.createObjectURL(file)

        const formData = new FormData()
        formData.append('file', file)

        const response = await fetch(`${process.env.VUE_APP_API_NAMESPACE}/upload/cover`, {
          method: 'POST',
          body: formData
        })

        if (!response.ok) {
          throw new Error('Có lỗi xảy ra khi tải lên bìa truyện.')
        }
        const data = await response.json()
        this.manga.cover = JSON.stringify(data)
      } catch (error) {
        this.coverDenied = true
        this.$notify({
          type: 'error',
          text: error.message
        })

        throw error
      } finally {
        this.coverPreparing = false
      }
    },

    async uploadPanorama (file) {
      this.hasPanorama = true
      this.panoramaPreparing = true
      this.panoramaDenied = false

      try {
        this.panoramaPreview = URL.createObjectURL(file)

        const formData = new FormData()
        formData.append('file', file)

        const response = await fetch(`${process.env.VUE_APP_API_NAMESPACE}/upload/panorama`, {
          method: 'POST',
          body: formData
        })

        if (!response.ok) {
          throw new Error('Có lỗi xảy ra khi tải lên ảnh nền truyện.')
        }
        const data = await response.json()
        this.manga.panorama = JSON.stringify(data)
      } catch (error) {
        this.panoramaDenied = true
        this.$notify({
          type: 'error',
          text: error.message
        })

        throw error
      } finally {
        this.panoramaPreparing = false
      }
    },

    setTitlePrimary (title) {
      this.manga.titles_attributes.forEach(title => {
        title.primary = false
      })

      title.primary = true
    },

    addNewTitle () {
      this.manga.titles_attributes.push({
        name: '',
        primary: false
      })
    },

    deleteTitleByIndex (index) {
      this.manga.titles_attributes.splice(index, 1)
    }
  }
}
</script>

<style scoped>
</style>
