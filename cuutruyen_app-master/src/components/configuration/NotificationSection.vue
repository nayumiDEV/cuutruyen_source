<template>
  <div class="text-gray-600 flex flex-col gap-4">
    <div class="p-6 bg-white bg-opacity-40 rounded-lg">
      <h2 class="text-gray-600 text-md uppercase font-bold mb-4">Thông báo đẩy</h2>
      <p class="text-gray-600 text-sm mb-4">
        Sử dụng công nghệ <strong>Web Push API</strong> để đẩy thông báo đến trình duyệt của bạn theo <strong>thời gian thực</strong>, kể cả khi bạn không truy cập Cứu Truyện.
      </p>

      <div v-if="isPushApiSupported">
        <div v-if="notificationPermissionStatus === 'default'" class="mb-4">
          <button @click.prevent="activateWebPush" class="button button-primary font-bold text-sm uppercase px-4 py-2">Cho phép thông báo đẩy</button>
        </div>

        <div v-else-if="notificationPermissionStatus === 'granted'">
          <div class="mb-4 flex flex-col lg:flex-row gap-2 justify-stretch lg:justify-left">
            <button class="button bg-green-100 font-bold text-green-400 px-4 py-2 text-sm uppercase cursor-default" disabled>Đã cấp quyền thành công</button>

            <button @click.prevent="triggerDemoNotification" class="button bg-gray-300 hover:bg-gray-400 text-gray-600 px-4 py-2 font-bold text-sm uppercase" v-if="webPushSubscription && isSubscriptionSaved">Nhận thử thông báo</button>
          </div>
        </div>

        <div v-else-if="notificationPermissionStatus === 'denied'" class="mb-4">
          <button class="button bg-red-100 font-bold text-red-400 text-sm uppercase px-4 py-2 cursor-default" disabled>Bạn đã từ chối quyền</button>
        </div>

        <div class="text-sm mb-4">
          <template>
            <div v-if="notificationPermissionStatus === 'granted'" class="text-green-600">Bạn đã cấp quyền nhận thông báo thành công</div>
            <div v-else-if="notificationPermissionStatus === 'default'" class="text-red-600">Bạn chưa cấp quyền nhận thông báo</div>
            <div v-else-if="notificationPermissionStatus === 'denied'" class="text-red-600">Bạn đã từ chối quyền nhận thông báo, nên bạn sẽ phải tự sửa lại quyền trên trình duyệt.</div>
          </template>

          <template>
            <div v-if="webPushSubscription" class="text-green-600">Trình duyệt đã tạo thành công điểm nhận đầu cuối</div>
            <div v-else class="text-red-600">Trình duyệt chưa tạo điểm nhận đầu cuối</div>
          </template>

          <template>
            <div v-if="isSubscriptionSaved" class="text-green-600">Cứu Truyện đã nhận được và lưu lại điểm nhận đầu cuối của thiết bị này</div>
            <div v-else class="text-red-600">Cứu Truyện chưa có điểm nhận đầu cuối của thiết bị này</div>
          </template>
        </div>

        <div class="text-sm">
          Ở <strong>Android</strong>, thông báo gửi đến sẽ được đặt mặc định chế độ <strong>im lặng</strong>.
          Nếu muốn thông báo khi gửi đến có rung và chuông, bạn hãy <strong>nhấn và giữ</strong> vào một thông báo bất kỳ gửi đến từ Cứu Truyện và sửa lại thiết lập.
        </div>
      </div>
      <div v-else>
        <div class="text-sm text-red-600">Rất tiếc, trình duyệt của bạn không hỗ trợ chức năng thông báo đẩy :(</div>
      </div>
    </div>

    <div class="p-6 bg-white bg-opacity-40 rounded-lg">
      <h2 class="text-gray-600 text-md uppercase font-bold mb-4">Bật và tắt nhận thông báo</h2>
      <p class="text-gray-600 text-sm mb-4">
        Thiết đặt <strong>nhận hoặc ngừng nhận</strong> các thông báo đẩy từ Cứu Truyện.
        Nếu bạn ngừng nhận thông báo đẩy, bạn vẫn có thể đọc thông báo ở mục thông báo của Cứu Truyện.
      </p>

      <div class="flex flex-col gap-2 text-sm text-gray-600">
        <!-- <Toggle v-model="accountNotification" @input="changeAccountNotification">Nhận thông báo trên tài khoản này</Toggle> -->
        <Toggle v-model="deviceNotification" @input="changeDeviceNotification">Nhận thông báo trên trình duyệt này</Toggle>
      </div>
    </div>
  </div>
</template>

<script>
import { mapGetters, mapActions } from 'vuex'
import * as WebPush from '@/lib/web-push'
import Toggle from '@/components/Toggle'

export default {
  data () {
    return {
      notificationPermissionStatus: null,
      webPushSubscription: null,
      backendEndpoints: null,
      isSubscriptionSaved: null,
      isPushApiSupported: null,
      accountNotification: true,
      deviceNotification: true
    }
  },

  components: {
    Toggle
  },

  computed: {
    ...mapGetters([
      'currentUser', 'config', 'authToken'
    ]),

    webPushStatus () {
      return this.notificationPermissionStatus && this.webPushSubscription && this.backendEndpoints
    }
  },

  async mounted () {
    this.isPushApiSupported = WebPush.isPushApiSupported()

    if (this.isPushApiSupported) {
      this.explain()
    }

    this.deviceNotification = this.config.deviceNotification
  },

  methods: {
    ...mapActions(['updateConfig', 'reloadCurrentUser']),

    async changeAccountNotification () {

    },

    async changeDeviceNotification () {
      try {
        await this.updateConfig({
          deviceNotification: this.deviceNotification
        })

        this.$notify({
          type: 'success',
          text: 'Đã thay đổi thành công!'
        })
      } catch (error) {
        this.$notify({
          type: 'error',
          text: 'Có lỗi xảy ra!'
        })
      } finally {
        this.deviceNotification = this.config.deviceNotification

        if (!this.deviceNotification) {
          await WebPush.unsubscribe()
          this.explain()
        } else {
          await WebPush.subscribe(this.currentUser.id)
          this.explain()
        }
      }
    },

    async activateWebPush () {
      try {
        await WebPush.requestNotificationPermission()
        const sub = await WebPush.subscribeWebPush()
        await WebPush.saveSubscription(sub, this.currentUser.id)

        this.$notify({
          type: 'success',
          text: 'Đã thiết lập thành công thông báo đẩy!'
        })

        this.$gtag.event('activate_web_push')
      } catch (error) {
        this.$notify({
          type: 'error',
          text: 'Có lỗi xảy ra khi thiết lập thông báo đẩy'
        })
        throw error
      } finally {
        this.explain()
      }
    },

    async explain () {
      this.notificationPermissionStatus = WebPush.getNotificationPermissionStatus()
      this.webPushSubscription = await WebPush.getWebPushSubscription()
      this.isSubscriptionSaved = await WebPush.isSubscriptionSaved(this.webPushSubscription, this.currentUser.id)
    },

    async triggerDemoNotification () {
      try {
        if (!this.webPushSubscription) {
          throw new Error('Web push subscription not found!')
        }
        const subJson = this.webPushSubscription.toJSON()
        await fetch(`${process.env.VUE_APP_API_NAMESPACE}/web_push_endpoints/trigger_demo`, {
          method: 'POST',
          headers: {
            Accept: 'application/json',
            'Content-Type': 'application/json',
            M4U_TOKEN: this.authToken,
            M4U_UID: this.currentUser.id
          },
          body: JSON.stringify({
            endpoint_url: subJson.endpoint,
            auth: subJson.keys.auth,
            p256dh: subJson.keys.p256dh
          })
        })

        this.$notify({
          type: 'success',
          text: 'Đã đặt lệnh gửi thông báo, vui lòng chờ vài giây!'
        })
      } catch (error) {
        this.$notify({
          type: 'error',
          text: 'Có lỗi xảy ra khi gửi thông báo!'
        })
        throw error
      }
    }
  }
}
</script>
