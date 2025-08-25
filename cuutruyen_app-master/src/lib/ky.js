import ky from 'ky'
import store from '@/store/index'

const dbLoader = () => import('@/db')

export default ky.extend({
  prefixUrl: `${process.env.VUE_APP_API_NAMESPACEV2}`,
  hooks: {
    beforeRequest: [
      async (request) => {
        // Add Cuutruyen-Client header to every request
        request.headers.set('Cuutruyen-Client', 'OfficialWebApp-20250805')

        const currentUser = store.getters.currentUser
        const authToken = store.getters.authToken

        if (currentUser && authToken) {
          request.headers.set('M4U_UID', currentUser.id)
          request.headers.set('M4U_TOKEN', authToken)
        } else {
          try {
            const db = (await dbLoader()).default
            const auth = await db.auth.toCollection().first()
            if (auth) {
              request.headers.set('M4U_UID', auth.user.id)
              request.headers.set('M4U_TOKEN', auth.authToken)
            }
          } catch (error) {
            console.error(error)
          }
        }
      }
    ]
  }
})
