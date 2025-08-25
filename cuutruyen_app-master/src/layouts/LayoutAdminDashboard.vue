<template>
  <div>
    <div class="bg-gray-300 min-h-screen flex flex-col">
      <div>
        <NavBar class="sticky top-0 w-full border-b border-gray-200" :glassy="true" theme="light" />
      </div>
      <div class="flex-grow flex flex-col">
        <AdminBar class="sticky top-0 w-full fine-shadow" :glassy="true" theme="light" />

        <div class="mx-2 my-12 flex-grow">
          <slot />
        </div>
      </div>
    </div>
    <AppFooter />
  </div>
</template>

<script>
import NavBar from '@/components/layout/default/NavBar'
import AdminBar from '@/components/layout/admin-dashboard/AdminBar'
import AppFooter from '@/components/layout/AppFooter'

export default {
  components: {
    NavBar,
    AppFooter,
    AdminBar
  }
}
</script>
