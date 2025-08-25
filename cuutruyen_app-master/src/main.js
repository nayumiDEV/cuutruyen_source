import Vue from 'vue'
import App from './App.vue'
import router from './router'
import store from './store'
import './registerServiceWorker'
import Notifications from 'vue-notification'
import VueMeta from 'vue-meta'
import ErrorHandler from './plugins/error-handler'
import VueFinalModal from 'vue-final-modal'
import VueVirtualScroller from 'vue-virtual-scroller'
import VueGtag from 'vue-gtag'
import '@/assets/css/main.css'
import 'vue-virtual-scroller/dist/vue-virtual-scroller.css'
import VuePortal from '@linusborg/vue-simple-portal'
import humanizeNumber from '@/utils/humanize-number'
import dayjs from 'dayjs'
import relativeTime from 'dayjs/plugin/relativeTime'
import localizedFormat from 'dayjs/plugin/localizedFormat'
import 'dayjs/locale/vi'
import CuuPaginate from '@/components/common/Paginate'
import CuuHeading from '@/components/common/CuuHeading'
dayjs.extend(localizedFormat)
dayjs.extend(relativeTime)
dayjs.locale('vi')

Vue.config.productionTip = false

Vue.use(VueGtag, {
  config: {
    id: 'G-XYX6B3RZGR',
    params: {
      send_page_view: false
    }
  },
  enabled: process.env.NODE_ENV === 'production'
})
Vue.use(VueVirtualScroller)
Vue.use(Notifications)
Vue.use(VueMeta, {
  refreshOnceOnNavigation: true
})
Vue.use(ErrorHandler)
Vue.use(VueFinalModal())
Vue.use(VuePortal, {
  name: 'portal'
})

// Register global components

Vue.component('LoadingScreen', () => import('@/components/LoadingScreen'))
Vue.component('ErrorScreen', () => import('@/components/ErrorScreen'))
Vue.component('EmptyScreen', () => import('@/components/EmptyScreen'))
Vue.component('NotImplementedScreen', () => import('@/components/NotImplementedScreen'))
Vue.component('CuuHeading', CuuHeading)
Vue.component('CuuPaginate', CuuPaginate)

Vue.filter('humanizeNumber', function (value) {
  return humanizeNumber(value)
})
Vue.filter('humanizeTime', function (value) {
  if (!value) {
    return 'Chưa bao giờ'
  }
  return dayjs(value).fromNow()
})
Vue.filter('humanizeTimeFull', function (value) {
  return dayjs(value).format('LLL')
})

Vue.mixin({
  methods: {
    lockBodyScroll () {
      const scrollY = document.documentElement.style.getPropertyValue('--scroll-y')
      const body = document.body
      body.style.position = 'fixed'
      body.style.top = `-${scrollY}`
    },

    releaseBodyScroll () {
      // reset body scroll lock
      const scrollY = document.body.style.top
      document.body.style.position = ''
      document.body.style.top = ''
      window.scrollTo(0, parseInt(scrollY || '0') * -1)
    }
  }
})

new Vue({
  router,
  store,
  render: function (h) { return h(App) }
}).$mount('#app')
