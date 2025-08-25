<template>
  <nav class="px-2 z-30"
    :class="{ 'bg-white': theme == 'light',
      'glassy-light': theme == 'light' && glassy == true,
      'glassy-dark': theme == 'dark' && glassy == true }">
    <div class="max-w-screen-md lg:max-w-screen-lg xl:max-w-screen-xl mx-auto h-14 flex flex-col justify-center w-full">
      <div class="flex justify-between items-center py-4">
        <div class="text-black text-opacity-80">
          Bảng điều khiển cho admin
        </div>

        <div class="flex gap-6">
          <router-link :to="{ name: 'AdminUserManagement' }" class="subnav-item" :class="{ 'subnav-item-active': $route.name === 'AdminUserManagement' }">Người dùng</router-link>
          <router-link :to="{ name: 'AdminTeamManagement' }" class="subnav-item" :class="{ 'subnav-item-active': $route.name === 'AdminTeamManagement' }">Nhóm dịch</router-link>
          <router-link :to="{ name: 'AdminMangaManagement' }" class="subnav-item" :class="{ 'subnav-item-active': $route.name === 'AdminMangaManagement' }">Truyện</router-link>
          <router-link :to="{ name: 'AdminDonationManagement' }" class="subnav-item" :class="{ 'subnav-item-active': $route.name === 'AdminDonationManagement' }">Quyên góp</router-link>
        </div>
      </div>
    </div>
  </nav>
</template>

<script>
export default {
  props: {
    theme: {
      type: String,
      default: 'dark'
    },

    glassy: {
      type: Boolean,
      default: false
    }
  }
}
</script>

<style scoped>
.subnav-item {
  @apply text-black text-opacity-60 py-2;
}

.subnav-item-active {
  @apply text-opacity-100 border-b-2 border-blue-700;
}

.subnav-item:hover {
  @apply text-opacity-70;
}
</style>
