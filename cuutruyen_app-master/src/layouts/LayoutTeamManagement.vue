<template>
  <div>
    <div class="bg-gray-300 min-h-screen flex flex-col">
      <div>
        <NavBar class="sticky top-0 w-full border-b border-gray-200" :glassy="true" theme="light" />
      </div>
      <div class="flex-grow flex flex-col">
        <TeamManagementBar class="sticky top-0 w-full fine-shadow" :team="team" :glassy="true" theme="light" />

        <div class="mx-2 my-12 flex-grow">
          <slot :team="team" v-if="team" />
        </div>
      </div>
    </div>
    <AppFooter />
  </div>
</template>

<script>
import NavBar from '@/components/layout/default/NavBar'
import TeamManagementBar from '@/components/layout/team-management/TeamManagementBar'
import AppFooter from '@/components/layout/AppFooter'
import { getTeam } from '@/apis/team'

export default {
  components: {
    NavBar,
    AppFooter,
    TeamManagementBar
  },

  data () {
    return {
      team: null
    }
  },

  mounted () {
    this.loadTeam(this.$route.params.teamId)
  },

  methods: {
    async loadTeam (teamId) {
      try {
        const response = await getTeam(this.$route.params.teamId)
        this.team = response.data
      } catch (error) {
        this.$handleError(error)
      }
    }
  },

  watch: {
    $route (to, from) {
      if (to.params.teamId !== from.params.teamId) {
        this.loadTeam(to.params.teamId)
      }
    }
  }
}
</script>
