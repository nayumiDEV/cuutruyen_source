<template>
  <div>
    <div class="common-container">
      <form @submit.prevent="formSubmit">
        <CuuHeading>Thêm nhóm mới</CuuHeading>

        <div class="mb-12">
          <label for="name" class="label">Tên nhóm <span class="text-red-800 font-bold">*</span></label>
          <input
            v-model="name"
            id="name"
            class="input mt-4"
            type="text" placeholder="Tên nhóm"
          >

          <div class="mt-4 validate" v-if="errors && errors.name">{{ errors.name[0] }}</div>
        </div>

        <div class="mb-12">
          <label for="description" class="label">Mô tả <span class="text-red-800 font-bold">*</span></label>
          <textarea
            v-model="description"
            id="description"
            class="textarea mt-4"
            type="text" placeholder="Mô tả"
          ></textarea>

          <div class="mt-4 validate" v-if="errors && errors.description">{{ errors.description[0] }}</div>
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
            <div v-for="(user, index) in teamMembers" class="flex border-b last:border-none border-gray-300 bg-gray-200 px-4 py-2" :key="index">
              <div class="flex-grow">
                <div>{{ user.username }}</div>
                <div class="text-xs text-gray-600">{{ user.email }}</div>
              </div>
              <div class="flex-0">
                <select v-model="user.role" class="input">
                  <option value="member">Thành viên</option>
                  <option value="editor">Biên tập viên</option>
                  <option value="owner">Người quản trị</option>
                </select>
              </div>
              <div class="flex-0">
                <button
                  @click="removeMember(index)"
                  type="button"
                  class="ml-2 button px-2 py-2 hover:bg-gray-400 text-gray-800 bg-white fine-transition"
                ><DeleteIcon /></button>
              </div>
            </div>
          </div>

          <div v-else class="mt-4 rounded-lg overflow-hidden text-sm bg-gray-200 text-gray-600 text-center px-4 py-12">
            Bạn chưa thêm thành viên nào cho nhóm này.
          </div>

          <div class="mt-4 validate" v-if="errors && errors.team_members">{{ errors.team_members[0] }}</div>
        </div>

        <button class="button px-8 py-3 text-xl"
          :class="{ 'button-primary': !disallowSave, 'button-disabled': disallowSave }"
          :disabled="disallowSave">
          Thêm nhóm
        </button>
      </form>
    </div>
  </div>
</template>

<script>
import { searchAdminUsers, createAdminTeam } from '@/apis/admin'
import AutoComplete from '@/components/AutoComplete'
import DeleteIcon from 'vue-material-design-icons/Delete.vue'

export default {
  components: {
    AutoComplete,
    DeleteIcon
  },

  data () {
    return {
      name: '',
      description: '',
      facebookAddress: '',
      teamMembers: [],
      disallowSave: false,
      usersFound: [],
      errors: null
    }
  },

  methods: {
    async formSubmit () {
      this.submitting = true

      try {
        await createAdminTeam({
          name: this.name,
          description: this.description,
          team_members_attributes: this.teamMembers.map(teamMember => ({
            user_id: teamMember.id,
            role: teamMember.role
          }))
        })

        this.$notify({
          type: 'success',
          text: 'Thêm nhóm thành công!'
        })

        this.$router.push({ name: 'AdminTeamManagement' })
      } catch (error) {
        if (error.response.status === 422) {
          this.$notify({
            type: 'warn',
            text: 'Vui lòng kiểm tra lại nội dung bạn nhập!'
          })
          const response = await error.response.json()
          this.errors = response.data
          console.error(error)
        }
        throw error
      }
    },

    async searchUsers (keyword) {
      const response = await searchAdminUsers(keyword, 1, 5)
      this.usersFound = response.data
    },

    async addUser (user) {
      if (this.teamMembers.length === 0) {
        user.role = 'owner'
        this.teamMembers.push(user)
      } else {
        user.role = 'member'
        this.teamMembers.push(user)
      }
      this.usersFound = []
    },

    removeMember (index) {
      this.teamMembers.splice(index)
    }
  }
}
</script>
