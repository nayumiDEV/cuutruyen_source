import Base64js from 'base64-js'

const modelsLoader = () => import('@/models')

export const isPushApiSupported = () => {
  return 'PushManager' in window
}

export const getNotificationPermissionStatus = () => {
  return Notification.permission
}

export const getWebPushSubscription = async () => {
  const reg = await navigator.serviceWorker.ready
  return reg.pushManager.getSubscription()
}

export const getBackendEndpoints = async (userId) => {
  const { WebPushEndpoint } = await modelsLoader()

  return (await WebPushEndpoint.where({ user_id: userId }).all()).data
}

export const isSubscriptionSaved = async (sub, userId) => {
  if (!sub) {
    return false
  }

  if (!userId) {
    return false
  }

  const backendEndpoints = await getBackendEndpoints(userId)
  const subJson = sub.toJSON()
  const finder = backendEndpoints.findIndex(endpoint => endpoint.endpointUrl === subJson.endpoint)
  if (finder > -1) {
    return true
  }
  return false
}

export const requestNotificationPermission = async () => {
  const permission = await Notification.requestPermission()

  if (permission !== 'granted') {
    throw new Error('Cannot get notification permission')
  }
}

export const subscribeWebPush = async () => {
  const preSub = await getWebPushSubscription()
  if (preSub) {
    return preSub
  }

  const reg = await navigator.serviceWorker.ready
  const sub = await reg
    .pushManager
    .subscribe({
      userVisibleOnly: true,
      applicationServerKey: Base64js.toByteArray(process.env.VUE_APP_VAPID_PUBLIC_KEY)
    })
  return sub
}

export const saveSubscription = async (sub, userId) => {
  if (await isSubscriptionSaved(sub, userId)) {
    return
  }

  const { WebPushEndpoint } = await modelsLoader()

  const subJson = sub.toJSON()
  const endpoint = new WebPushEndpoint({
    userId: userId,
    endpointUrl: subJson.endpoint,
    auth: subJson.keys.auth,
    p256dh: subJson.keys.p256dh
  })

  await endpoint.save()
}

export const subscribe = async (userId) => {
  if (!isPushApiSupported()) {
    return
  }
  if (getNotificationPermissionStatus() === 'granted' && userId) {
    const sub = await subscribeWebPush()
    await saveSubscription(sub, userId)
  }
}

export const unsubscribe = async () => {
  if (!isPushApiSupported()) {
    return
  }
  if (getNotificationPermissionStatus() === 'granted') {
    const sub = await getWebPushSubscription()
    await sub.unsubscribe()
  }
}
