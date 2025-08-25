import got from 'got'
import { getConfigKey } from './config'

export default got.extend({
  // prefixUrl: 'https://cuutruyenpip7z.site/api/v2/',
  prefixUrl: 'https://cuutruyen.net/api/v2/',
  hooks: {
    beforeRequest: [
      async (request) => {
        request.headers['User-Agent'] = 'CuuUploader/1.0'

        const authToken = await getConfigKey('authToken')
        const currentUser = await getConfigKey('currentUser')

        if (authToken && currentUser) {
          request.headers['M4U_UID'] = currentUser.id
          request.headers['M4U_TOKEN'] = authToken
        }
      }
    ],
    afterResponse: [
      (response) => {
        if (response.statusCode >= 400) {
          const error = new Error()
          const body = JSON.parse(response.body)

          // Convert body to string with full depth
          const formattedBody = JSON.stringify(body, null, 2)

          error.name = 'APIError'
          error.message = `${body.message || `API request failed with status ${response.statusCode}`}\n\nFull response:\n${formattedBody}`
          error.statusCode = response.statusCode
          error.body = body

          throw error
        }
        return response
      }
    ],
    beforeError: [
      (error) => {
        const { response } = error
        if (response && response.body) {
          try {
            const body = JSON.parse(response.body)
            error.name = 'APIError'
            error.message = body.message || error.message
            error.body = body
          } catch (e) {
            // If response body is not JSON, create a formatted error
            error.name = 'APIError'
            error.message = `API request failed with status ${response.statusCode}\n\nResponse body:\n${response.body}`
            error.body = response.body
          }
        }
        return error
      }
    ]
  }
})
