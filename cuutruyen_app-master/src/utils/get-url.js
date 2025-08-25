const dbLoader = () => import('@/db')

const arrayBufferToBlob = (buffer, type) => {
  return new Blob([buffer], { type: type })
}

const fullUrl = path => {
  return path
  // return `https://storage.cuutruyen.net${path}`
  // const storageUrl = 'https://storage.cuutruyen.net/cuutruyen'
  // const naturalPath = path.replace('/uploads', '')
  // return `${storageUrl}${naturalPath}`
}

const offlineUrl = async (path) => {
  const db = (await dbLoader()).default
  const imageData = await db.images.get({ path })
  const blob = arrayBufferToBlob(imageData.buffer, imageData.bufferType)
  return URL.createObjectURL(blob)
}

export { fullUrl, offlineUrl }
