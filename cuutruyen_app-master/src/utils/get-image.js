import { fullUrl } from '@/utils/get-url'

export const getImage = async (imagePath) => {
  const res = await fetch(fullUrl(imagePath), {
    cache: 'no-store',
    headers: {
      Origin: process.env.VUE_APP_API_BASE_URL,
      'Cache-Control': 'no-cache',
      Pragma: 'no-cache'
    }
  })
  const buffer = await res.arrayBuffer()
  const bufferType = res.headers.get('content-type')
  return {
    buffer, bufferType
  }
}
