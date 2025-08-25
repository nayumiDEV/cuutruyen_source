<template>
  <div>
    <CuuHeading>Quản lý trang nhóm</CuuHeading>

    <template v-if="loading">
      <LoadingScreen />
    </template>

    <div class="common-container" v-else>
      <div>
        <div class="text-sm text-gray-700 mb-2">
          <span>Đường dẫn trang nhóm của bạn: </span>
          <router-link
            :to="{ name: 'TeamProfile', params: { teamSlug: team.slug || '+' + team.id } }"
            class="font-bold text-blue-600 hover:text-blue-800 transition"
          >
            https://cuutruyen.net/t/{{ team.slug || '+' + team.id }}
          </router-link>
        </div>

        <div v-if="!team.slug" class="text-sm text-gray-700 mb-2">
          <span>Cá nhân hóa địa chỉ trang nhóm của bạn bằng cách đặt slug ở </span>
          <router-link :to="{ name: 'TeamPreferences' }" class="font-bold text-blue-600 hover:text-blue-800 transition">thông tin nhóm</router-link>
        </div>
      </div>

      <BlockBuilder
        :initial-blocks="blocks"
        :show-json-preview="false"
        @save="handleSave"
      />
    </div>
  </div>
</template>

<script>
import { getTeam, updateTeam } from '@/apis/team'
import BlockBuilder from '@/components/team-management/block-builder/BlockBuilder.vue'

export default {
  name: 'TeamPageManagement',

  components: {
    BlockBuilder
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
    }
  },

  data () {
    return {
      blocks: [],
      loading: true
    }
  },

  mounted () {
    this.fetchData()
  },

  methods: {
    async fetchData () {
      try {
        const response = await getTeam(this.$route.params.teamId)
        this.blocks = JSON.parse(response.data.main_page_blocks) || []
      } catch (error) {
        this.$handleError(error)
      } finally {
        this.loading = false
      }
    },

    async handleSave (blocks) {
      try {
        await updateTeam(this.$route.params.teamId, {
          team: {
            main_page_blocks: JSON.stringify(blocks)
          }
        })

        this.$notify({
          type: 'success',
          text: 'Đã lưu cấu hình trang thành công!'
        })
      } catch (error) {
        this.$notify({
          type: 'error',
          text: 'Có lỗi xảy ra khi lưu cấu hình trang.'
        })

        throw error
      }
    }
  }
}
</script>
