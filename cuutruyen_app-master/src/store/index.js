import Vue from 'vue'
import Vuex from 'vuex'
import * as WebPush from '@/lib/web-push'
import { getUser, getUnreadNotificationsCount } from '@/apis/user'
import getBestStorageServer from '@/utils/get-best-storage-server'
import downloader from './downloader'

const dbLoader = () => import('@/db')

Vue.use(Vuex)

export default new Vuex.Store({
  modules: {
    downloader
  },
  state: {
    init: false,
    currentUser: null,
    authToken: null,
    notificationUnreadCount: 0,
    config: {},
    isOnline: true,
    indexedDB: true,
    errorPage: {
      isShow: false,
      code: null,
      message: null
    },
    isMessengerVisible: true,
    isShowToolbar: true,
    geo: 'VN',
    isSpider: false,
    isCocked: false,
    bestStorageServer: null
  },

  getters: {
    currentUser (state) {
      return state.currentUser
    },

    bestStorageServer (state) {
      return state.bestStorageServer
    },

    authToken (state) {
      return state.authToken
    },

    config (state) {
      const config = state.config || {}

      if ('deviceNotification' in config === false) {
        config.deviceNotification = true
      }

      return config
    },

    notificationUnreadCount (state) {
      return state.notificationUnreadCount
    },

    isOnline (state) {
      return state.isOnline
    },

    isIndexedDB (state) {
      return state.indexedDB
    },

    isShowErrorPage (state) {
      return state.errorPage.isShow
    },

    isMessengerVisible (state) {
      return state.isMessengerVisible
    },

    isShowToolbar (state) {
      return state.isShowToolbar
    },

    isCocked (state) {
      return state.isCocked
    },

    errorCode (state) {
      return state.errorPage.code
    },

    errorMessage (state) {
      if (state.errorPage.message) {
        return state.errorPage.message
      }

      switch (state.errorPage.code) {
        case 404:
          return 'Trang bạn đang tìm không tồn tại'
        case 500:
          return 'Lỗi từ phía server, mong bạn thông cảm'
        case 502:
          return 'Server đang bảo trì, bạn hãy thử tải lại trang trong chốc lát'
      }
      return null
    },

    geo (state) {
      return state.geo
    },

    isSpider (state) {
      return state.isSpider
    },

    isClientRegionLimited (state) {
      if (state.geo === 'VN' || state.isSpider) {
        return false
      } else if (state.currentUser) {
        return false
      }
      return true
    },

    isStormRegion (state) {
      if (state.currentUser) {
        return false
      }

      if (state.geo === 'JP' || state.geo === 'KR' || state.geo === 'KP') {
        return true
      }

      return false
    },

    downloadingChapters (state) {
      return state.downloadingChapters
    }
  },

  mutations: {
    setCurrentUser (state, currentUser) {
      state.currentUser = currentUser
    },

    setGeo (state, payload) {
      state.geo = payload
    },

    setIsSpider (state, payload) {
      state.isSpider = payload
    },

    setNotificationUnreadCount (state, unreadCount) {
      state.notificationUnreadCount = unreadCount
    },

    setAuthToken (state, authToken) {
      state.authToken = authToken
    },

    setConfig (state, config) {
      state.config = config
    },

    setOnlineStatus (state, isOnline) {
      state.isOnline = isOnline
    },

    setIndexedDB (state, status) {
      state.indexedDB = status
    },

    showErrorPage (state, payload) {
      state.errorPage.isShow = true
      if (payload.code) {
        state.errorPage.code = payload.code
      }
      if (payload.message) {
        state.errorPage.message = payload.message
      }
    },

    leaveErrorPage (state) {
      state.errorPage.isShow = false
      state.errorPage.code = null
      state.errorPage.message = null
    },

    setMessengerVisible (state, payload) {
      state.isMessengerVisible = payload
    },

    showToolbar (state) {
      state.isShowToolbar = true
    },

    hideToolbar (state) {
      state.isShowToolbar = false
    },

    setCocked (state, payload) {
      state.isCocked = payload
    },

    setBestStorageServer (state, payload) {
      state.bestStorageServer = payload
    }
  },

  actions: {
    async findBestStorageServer (context, payload) {
      // magic session
      sessionStorage.setItem('_9421424163', '1284069429')
      sessionStorage.setItem('_3236353668', '6321050717')
      sessionStorage.setItem('_8864459579', '​4283056037')
      sessionStorage.setItem('_2038728281', '8111913161')
      sessionStorage.setItem('_3843324144', '4499219618')

      const storageServer = await getBestStorageServer()
      context.commit('setBestStorageServer', storageServer)
    },

    async restoreAndReloadCurrentUser (context, payload) {
      await context.dispatch('restoreCurrentUser')
      context.dispatch('reloadCurrentUser')
      context.dispatch('reloadNotificationUnreadCount')
    },

    async restoreCurrentUser (context) {
      try {
        const db = (await dbLoader()).default
        const auth = await db.auth.toCollection().first()
        if (auth) {
          context.commit('setCurrentUser', auth.user)
          context.commit('setAuthToken', auth.authToken)
          if (auth.config) {
            context.commit('setConfig', auth.config)
          }

          if (context.getters.config.deviceNotification) {
            WebPush.subscribe(context.getters.currentUser.id)
          } else {
            WebPush.unsubscribe()
          }

          context.state.init = true
        }
      } catch (error) {
        if (error.name === 'OpenFailedError') {
          context.commit('setIndexedDB', false)
        }
      }
    },

    async reloadCurrentUser (context) {
      try {
        if (!context.state.currentUser) {
          return
        }

        const db = (await dbLoader()).default
        const currentUser = context.state.currentUser
        const newCurrentUser = (await getUser()).data

        const updated = await db.auth.update(currentUser.id, { user: newCurrentUser })

        if (updated) {
          context.commit('setCurrentUser', newCurrentUser)
        }
      } catch (error) {
        if (error.name === 'OpenFailedError') {
          context.commit('setIndexedDB', false)
        }
      }
    },

    async reloadNotificationUnreadCount (context) {
      if (!context.state.currentUser) {
        return
      }

      const response = await getUnreadNotificationsCount()
      const unreadCount = response.data
      context.commit('setNotificationUnreadCount', unreadCount)
    },

    async updateConfig (context, payload) {
      try {
        const currentConfig = context.getters.config
        const newCurrentConfig = { ...currentConfig, ...payload }
        const currentUser = context.state.currentUser
        const db = (await dbLoader()).default
        const updated = await db.auth.update(currentUser.id, { config: newCurrentConfig })
        if (updated) {
          context.commit('setConfig', newCurrentConfig)
        } else {
          throw new Error('Update config failed.')
        }
      } catch (error) {
        if (error.name === 'OpenFailedError') {
          context.commit('setIndexedDB', false)
        }
      }
    },

    async createCurrentUser (context, payload) {
      const currentUser = payload.currentUser
      const authToken = payload.authToken

      context.commit('setCurrentUser', currentUser)
      context.commit('setAuthToken', authToken)
      if (context.getters.isIndexedDB) {
        try {
          const db = (await dbLoader()).default
          await db.auth.put({ user: currentUser, authToken: authToken })
        } catch (error) {
          if (error.name === 'OpenFailedError') {
            context.commit('setIndexedDB', false)
          }
        }
      }
    },

    async cleanCurrentUser (context, payload) {
      context.commit('setCurrentUser', null)
      context.commit('setAuthToken', null)

      try {
        const db = (await dbLoader()).default
        await db.auth.clear()
        WebPush.unsubscribe()
      } catch (error) {
        if (error.name === 'OpenFailedError') {
          context.commit('setIndexedDB', false)
        }
      }
    }
  }
})
