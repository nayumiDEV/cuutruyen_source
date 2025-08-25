import store from '@/store/index'
import { RegionNotSupported } from '@/utils/custom-errors'

export default {
  install (Vue, options) {
    Vue.prototype.$handleError = (error, code = null, message = null) => {
      if (error instanceof RegionNotSupported) {
        code = 'RNS'
        message = 'Truyện này không khả dụng tại quốc gia của bạn'
      } else if (!code && error.response) {
        const status = error.response.status
        const statusText = error.response.statusText
        code = status
        message = `Server phản hồi lại với mã lỗi ${status} (${statusText})`
      } else {
        message = `Lỗi chưa rõ nguyên nhân đã xảy ra (${error.name}: ${error.message})`
      }

      store.commit('showErrorPage', {
        code,
        message
      })

      console.error(error)
    }
  }
}
