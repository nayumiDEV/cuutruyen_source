import { precacheAndRoute, createHandlerBoundToURL } from 'workbox-precaching'
import { registerRoute, NavigationRoute } from 'workbox-routing'
import { clientsClaim } from 'workbox-core'
import db from '@/db'

clientsClaim()
precacheAndRoute(self.__WB_MANIFEST)
registerRoute(
  new NavigationRoute(
    createHandlerBoundToURL('/index.html'),
    {
      denylist: [/\/(api|uploads|abitrary_photos|service-worker.js|manifest.json|ads.txt)\/?(.*)/]
    }
  )
)

self.addEventListener('install', () => {
  self.skipWaiting()
})

self.addEventListener('message', (event) => {
  if (event.data && event.data.type === 'SKIP_WAITING') {
    self.skipWaiting()
  }
})

self.addEventListener('activate', () => {
  self.clients.matchAll({
    type: 'window'
  })
    .then(windowClients => {
      windowClients.forEach((windowClient) => {
        windowClient.navigate(windowClient.url)
      })
    })
})

self.addEventListener('push', (event) => {
  const json = event.data.json()

  event.waitUntil(
    self.registration.showNotification(json.title, {
      body: json.body || null,
      icon: json.icon || null,
      vibrate: [100, 50, 100],
      image: json.image || null,
      badge: json.badge || null,
      data: {
        url: json.url || null
      }
    })
  )
})

self.addEventListener('notificationclick', (event) => {
  const notification = event.notification
  const url = notification.data.url
  notification.close()
  if (url) {
    event.waitUntil(self.clients.openWindow(url))
  }
})

self.addEventListener('backgroundfetchsuccess', (event) => {
  const bgFetch = event.registration

  event.waitUntil(async function () {
    const downloadedChapter = await db.downloadingChapters.get({ fetchId: bgFetch.id })

    const promises = downloadedChapter.chapter.pages.map(async (page) => {
      const record = await bgFetch.match(page.image_url)
      const response = await record.responseReady
      const buffer = await response.arrayBuffer()
      const bufferType = response.headers.get('content-type')

      await db.pages.put({
        id: page.id,
        chapter: {
          id: downloadedChapter.chapter.id
        },
        manga: {
          id: downloadedChapter.chapter.manga.id
        },
        drm_data: page.drm_data,
        width: page.width,
        height: page.height,
        order: page.order,
        image_url: page.image_url,
        imageBuffer: buffer,
        imageBufferType: bufferType
      })
    })

    promises.push(db.chapters.put(downloadedChapter.chapter))
    promises.push(db.downloadingChapters.put({ ...downloadedChapter, status: 'downloaded', progress: 1.0 }))

    await Promise.all(promises)
    self.clients.matchAll().then(clients => {
      clients.forEach(client => {
        client.postMessage({ type: 'download-chapter-success', chapterId: downloadedChapter.id })
      })
    })
    console.log('send evnet!!!')

    event.updateUI({ title: 'Đã tải xuống truyện thành công' })
  }())
})

self.addEventListener('backgroundfetchclick', (event) => {
  const bgFetch = event.registration

  if (bgFetch.result === 'success') {
    self.clients.openWindow('/saved-offline')
  } else {
    self.clients.openWindow('/downloads')
  }
})
