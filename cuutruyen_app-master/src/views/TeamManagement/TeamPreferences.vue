<template>
  <div>
    <CuuHeading>Thiết lập nhóm</CuuHeading>

    <template v-if="loading">
      <LoadingScreen />
    </template>

    <div class="common-container" v-else>
      <form @submit.prevent="updateTeam">
        <div class="mb-12">
          <label for="name" class="label">Tên nhóm</label>
          <input
            v-model="name"
            class="input mt-4"
            type="text" placeholder="Tên nhóm dịch"
          >
          <div class="mt-4 validate" v-if="errors && errors.name">{{ errors.name[0] }}</div>
        </div>

        <div class="mb-12">
          <label for="slug" class="label">Slug</label>
          <input
            v-model="slug"
            class="input mt-4"
            type="text" placeholder="Slug"
          >
          <div class="mt-4 validate" v-if="errors && errors.slug">{{ errors.slug[0] }}</div>
        </div>

        <div class="mb-12">
          <label for="avatar" class="label">Ảnh đại diện nhóm</label>
          <AvatarUploader
            class="mt-4"
            :hasAvatar="hasAvatar"
            :avatarPreparing="avatarPreparing"
            :avatarDenied="avatarDenied"
            :avatarPreview="avatarBlob || team.avatar_url"
            @removeAvatar="removeAvatar"
            @uploadAvatar="uploadAvatar"
          />
        </div>

        <div class="mb-12">
          <label for="description" class="label">Giới thiệu nhóm</label>
          <textarea
            v-model="description"
            class="textarea mt-4"
            type="text" placeholder="Giới thiệu ngắn về nhóm"
          ></textarea>
          <div class="mt-4 validate" v-if="errors && errors.description">{{ errors.description[0] }}</div>
        </div>

        <div class="mb-12">
          <label for="facebook_address" class="label">Địa chỉ Facebook</label>

          <div class="mt-4 flex items-center">
            <div class="text-gray-600 py-1 px-3 bg-gray-100 rounded-l-lg h-10 flex items-center whitespace-nowrap">https://fb.com/</div>
            <input
              v-model="facebookAddress"
              class="input-bare flex-grow rounded-r-lg h-10 outline-none focus:ring"
              type="text" placeholder=""
            />
          </div>

          <div class="mt-4 validate" v-if="errors && errors.facebook_address">{{ errors.facebook_address[0] }}</div>
        </div>

        <div class="mb-12">
          <label for="team-members" class="label">Thành viên <span class="text-red-800 font-bold">*</span></label>

          <AutoComplete inputId="team-members" :items="usersFound" @input="searchUsers" @selected="addUser" placeholder="Tìm theo tên người dùng">
            <template v-slot:item="slotProps">
              <div class="px-4 py-2 hover:bg-gray-200 transition">
                <div>{{ slotProps.item.username }}</div>
                <div class="text-xs text-gray-600">{{ slotProps.item.email }}</div>
              </div>
            </template>
          </AutoComplete>

          <div v-if="teamMembers.length > 0" class="mt-4 rounded-lg overflow-hidden">
            <div v-for="(member, index) in presentTeamMembers" class="flex border-b last:border-none border-gray-300 bg-gray-200 px-4 py-2" :key="index">
              <div class="flex-grow">
                <div>{{ member.username }}</div>
                <div class="text-xs text-gray-600">{{ member.email }}</div>
              </div>
              <div class="flex-0">
                <select v-model="member.role" class="input">
                  <option value="member">Thành viên</option>
                  <option value="editor">Biên tập viên</option>
                  <option value="owner">Người quản trị</option>
                </select>
              </div>
              <div class="flex-0">
                <button
                  @click="removeMember(member)"
                  type="button"
                  class="ml-2 button px-2 py-2 hover:bg-gray-400 text-gray-800 bg-white fine-transition"
                ><DeleteIcon /></button>
              </div>
            </div>
          </div>

          <div v-else class="mt-4 rounded-lg overflow-hidden text-sm bg-gray-200 text-gray-600 text-center px-4 py-12">
            Bạn chưa thêm thành viên nào cho nhóm này.
          </div>
        </div>

        <button class="button px-8 py-3 text-xl"
          :class="{ 'button-primary': !disallowSave, 'button-disabled': disallowSave }"
          :disabled="disallowSave">
          Lưu lại
        </button>
      </form>
    </div>
  </div>
</template>

<script>
import AutoComplete from '@/components/AutoComplete'
import DeleteIcon from 'vue-material-design-icons/Delete.vue'
import AvatarUploader from '@/components/team-management/AvatarUploader.vue'
import { getTeam, updateTeam, searchTeamUsers } from '@/apis/team'

export default {
  components: {
    AutoComplete,
    DeleteIcon,
    AvatarUploader
  },

  data () {
    return {
      name: '',
      slug: '',
      description: '',
      facebookAddress: '',
      errors: null,
      submitting: false,
      usersFound: [],
      memberSearch: '',
      teamMembers: [],
      loading: true,
      team: null,
      avatar: null,
      hasAvatar: false,
      avatarPreparing: false,
      avatarDenied: false,
      avatarBlob: null,
      avatarChanged: false
    }
  },

  computed: {
    disallowSave () {
      return this.submitting
    },
    presentTeamMembers () {
      return this.teamMembers.filter(member => !member._destroy)
    }
  },

  created () {
    this.loadTeam()
  },

  methods: {
    async loadTeam () {
      this.loading = true
      try {
        const response = await getTeam(this.$route.params.teamId)
        const team = response.data
        console.log(team)
        this.team = team
        this.name = team.name
        this.slug = team.slug
        this.description = team.description
        this.facebookAddress = team.facebook_address
        // Initialize teamMembers for editing
        this.teamMembers = team.team_members.map(teamMember => (
          {
            id: teamMember.id,
            user_id: teamMember.user_id,
            username: teamMember.username,
            email: teamMember.email,
            role: teamMember.role
          }
        ))

        // Initialize avatar data
        if (team.avatar_url) {
          this.hasAvatar = true
        }

        console.log(this.teamMembers)
      } catch (error) {
        this.$handleError(error)
      } finally {
        this.loading = false
      }
    },

    async searchUsers (keyword) {
      const response = await searchTeamUsers(this.$route.params.teamId, keyword, 1, 5)
      this.usersFound = response.data
    },

    async addUser (user) {
      if (this.teamMembers.length === 0) {
        this.teamMembers.push({ user_id: user.id, username: user.username, email: user.email, role: 'owner' })
      } else {
        this.teamMembers.push({ user_id: user.id, username: user.username, email: user.email, role: 'member' })
      }
      this.usersFound = []
    },

    removeMember (member) {
      const index = this.teamMembers.indexOf(member)
      if (member.id) {
        this.$set(this.teamMembers[index], '_destroy', true)
      } else {
        this.teamMembers.splice(index, 1)
      }
    },

    removeAvatar () {
      this.avatar = null
      this.avatarBlob = null
      this.hasAvatar = false
      this.avatarChanged = true
    },

    async uploadAvatar (file) {
      this.hasAvatar = true
      this.avatarChanged = true
      this.avatarPreparing = true
      this.avatarDenied = false

      try {
        this.avatarBlob = URL.createObjectURL(file)

        const formData = new FormData()
        formData.append('file', file)

        const response = await fetch(`${process.env.VUE_APP_API_NAMESPACEV2}/upload/avatar`, {
          method: 'POST',
          body: formData
        })

        if (!response.ok) {
          throw new Error('Có lỗi xảy ra khi tải lên ảnh đại diện.')
        }
        const data = await response.json()
        this.avatar = JSON.stringify(data)
      } catch (error) {
        this.avatarDenied = true
        this.$notify({
          type: 'error',
          text: error.message
        })

        throw error
      } finally {
        this.avatarPreparing = false
      }
    },

    async updateTeam () {
      this.submitting = true
      try {
        const teamData = {
          team: {
            name: this.name,
            slug: this.slug,
            description: this.description,
            facebook_address: this.facebookAddress,
            team_members_attributes: this.teamMembers.map(member => ({
              id: member.id,
              user_id: member.user_id,
              username: member.username,
              email: member.email,
              role: member.role,
              _destroy: member._destroy || false
            }))
          }
        }

        // Only include avatar if it was changed
        if (this.avatarChanged) {
          teamData.team.avatar = this.avatar
        }

        await updateTeam(this.$route.params.teamId, teamData)

        this.$notify({
          type: 'success',
          text: 'Cập nhật thông tin nhóm thành công!'
        })

        this.$emit('reloadTeam')
        this.loadTeam()
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
            text: 'Có lỗi xảy ra khi cập nhật thông tin nhóm.'
          })

          throw error
        }
      } finally {
        this.submitting = false
      }
    }
  }
}
</script>
