import { getImage } from '@/utils/get-image'

const dbLoader = () => import('@/db')

export default {
  state: () => ({
    downloadingChapters: [],
    downloadedChapters: []
  }),

  getters: {
    getDownloadingChapters (state) {
      return state.downloadingChapters
    },

    cumulativeDownloadProgress (state) {
      const allProgresses = state.downloadingChapters.map(c => c.progress).filter(p => p < 1.0)
      if (allProgresses && allProgresses.length > 0) {
        const sumProgress = allProgresses.reduce((accu, n) => accu + n, 0)
        return sumProgress / allProgresses.length
      } else {
        return null
      }
    }
  },

  actions: {
    async saveMangaInfo (_, manga) {
      const db = (await dbLoader()).default

      await db.mangas.where({ id: manga.id }).delete()

      const cover = await getImage(manga.cover_url)

      await db.mangas.put({
        id: manga.id,
        name: manga.name,
        coverBuffer: cover.buffer,
        coverBufferType: cover.bufferType,
        marginless: manga.marginless,
        description: manga.description
      })
    },

    async saveDownloadingChapterInfo (context, { manga, chapter }) {
      const db = (await dbLoader()).default

      let downloadName
      if (chapter.name) {
        downloadName = `Chapter ${chapter.number} - ${chapter.name} - ${manga.name}`
      } else {
        downloadName = `Chapter ${chapter.number} - ${manga.name}`
      }

      const data = {
        id: chapter.id,
        fetchId: `fetch-chapter-${chapter.id}`,
        downloadName: downloadName,
        chapter: {
          id: chapter.id,
          manga: {
            id: chapter.manga.id
          },
          number: chapter.number,
          name: chapter.name,
          order: chapter.order,
          pages: chapter.pages.map(page => ({
            id: page.id,
            order: page.order,
            width: page.width,
            height: page.height,
            drm_data: page.drm_data,
            image_url: page.image_url
          }))
        },
        status: 'downloading',
        progress: 0.0
      }

      await db.downloadingChapters.put(data)

      context.state.downloadingChapters.push(data)

      return data
    },

    async downloadChapter ({ dispatch }, { manga, chapter }) {
      const saveMangaPromise = dispatch('saveMangaInfo', manga)
      const saveChapterPromise = dispatch('saveDownloadingChapterInfo', { manga, chapter })
      await Promise.all([saveMangaPromise, saveChapterPromise])
      if ('BackgroundFetchManager' in self) {
        dispatch('backgroundFetchChapter', { manga, chapter })
      } else {
        console.log('Browser has no background fetch support!')
        dispatch('fetchChapter', { chapter })
      }
    },

    async backgroundFetchChapter ({ dispatch }, { manga, chapter }) {
      let downloadName
      if (chapter.name) {
        downloadName = `Chapter ${chapter.number} - ${chapter.name} - ${manga.name}`
      } else {
        downloadName = `Chapter ${chapter.number} - ${manga.name}`
      }

      await navigator.serviceWorker.ready.then(async (swReg) => {
        const bgFetch = await swReg.backgroundFetch.fetch(
          `fetch-chapter-${chapter.id}`,
          chapter.pages.map(page => page.image_url),
          {
            title: downloadName,
            downloadTotal: chapter.pages.map(page => page.image_url_size).reduce((accu, n) => accu + n, 0)
          }
        )

        dispatch('updateDownloadingChapterProgress', { chapter, bgFetch })
      })
    },

    async fetchChapter (context, { chapter }) {
      const db = (await dbLoader()).default

      const images = []
      let imagesDownloaded = 0

      chapter.pages.forEach((page) => {
        images.push(page.image_url)
      })

      const downloadingChapter = context.state.downloadingChapters.find(c => c.id === chapter.id)

      const getImagePromises = images.map(async (image) => {
        const response = await getImage(image)
        imagesDownloaded++
        const progress = imagesDownloaded / images.length
        downloadingChapter.progress = progress
        db.downloadingChapters.put({ ...downloadingChapter, status: 'downloading', progress })
        return { imageUrl: image, response }
      })

      try {
        const result = await Promise.all(getImagePromises)

        const commitSavePromises = downloadingChapter.chapter.pages.map(async (page) => {
          const record = result.find(r => r.imageUrl === page.image_url)
          const response = record.response
          const buffer = response.buffer
          const bufferType = response.bufferType

          await db.pages.put({
            id: page.id,
            chapter: {
              id: downloadingChapter.chapter.id
            },
            manga: {
              id: downloadingChapter.chapter.manga.id
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
        commitSavePromises.push(db.chapters.put(downloadingChapter.chapter))

        await Promise.all(commitSavePromises)

        await db.downloadingChapters.where({ id: downloadingChapter.id }).delete()
        downloadingChapter.status = 'downloaded'
        downloadingChapter.progress = 1.0
        context.state.downloadedChapters = await db.chapters.toArray()
      } catch (error) {
        console.error(error)
      }
    },

    async refreshDownloadingChaptersData ({ dispatch, state }) {
      const db = (await dbLoader()).default
      state.downloadingChapters = await db.downloadingChapters.toArray()
      state.downloadedChapters = await db.chapters.toArray()

      if ('BackgroundFetchManager' in self) {
        // Have bgfetch
        // Now listen to custom download-chapter-success event,
        // because normal bgFetch progress event doesn't reliably return
        // progress when the download in completed
        navigator.serviceWorker.addEventListener('message', async (event) => {
          if (event.data.type === 'download-chapter-success') {
            const chapterId = event.data.chapterId
            const downloadingChapter = state.downloadingChapters.find(downloadingChapter => downloadingChapter.id === chapterId)
            if (downloadingChapter) {
              downloadingChapter.status = 'downloaded'
              downloadingChapter.progress = 1.0
              db.downloadingChapters.put({ ...downloadingChapter, status: 'downloaded', progress: 1.0 })
              state.downloadedChapters = await db.chapters.toArray()
            }
          }
        })
      } else {
        // No bgfetch
        const downloadingChapters = state.downloadingChapters

        for (let i = 0; i < downloadingChapters.length; i++) {
          dispatch('fetchChapter', { chapter: downloadingChapters[i].chapter })
        }
      }
    },

    async updateDownloadingChaptersProgress (context) {
      const db = (await dbLoader()).default

      if ('BackgroundFetchManager' in self) {
        await navigator.serviceWorker.ready.then(async (swReg) => {
          for (let i = 0; i < context.state.downloadingChapters.length; i++) {
            const bgFetch = await swReg.backgroundFetch.get(context.state.downloadingChapters[i].fetchId)
            if (bgFetch) {
              bgFetch.addEventListener('progress', () => {
                if (bgFetch.result === '') {
                  const progress = bgFetch.downloaded / bgFetch.downloadTotal
                  context.state.downloadingChapters[i].status = 'downloading'
                  context.state.downloadingChapters[i].progress = progress
                  db.downloadingChapters.put({ ...context.state.downloadingChapters[i], status: 'downloading', progress })
                } else if (bgFetch.result === 'success') {
                  context.state.downloadingChapters[i].status = 'downloaded'
                  context.state.downloadingChapters[i].progress = 1.0
                  db.downloadingChapters.put({ ...context.state.downloadingChapters[i], status: 'downloaded', progress: 1.0 })
                } else {
                  context.state.downloadingChapters[i].status = 'failed'
                  context.state.downloadingChapters[i].progress = 0.0
                  db.downloadingChapters.put({ ...context.state.downloadingChapters[i], status: 'failed', progress: 0.0 })
                }
              })
            }
          }
        })
      } else {
        // no bgfetch
      }
    },

    async updateDownloadingChapterProgress (context, { chapter, bgFetch }) {
      const db = (await dbLoader()).default

      bgFetch.addEventListener('progress', async () => {
        if (bgFetch.result === '') {
          const progress = bgFetch.downloaded / bgFetch.downloadTotal
          const downloadingChapter = context.state.downloadingChapters.find(downloadingChapter => downloadingChapter.id === chapter.id)
          if (downloadingChapter) {
            downloadingChapter.status = 'downloading'
            downloadingChapter.progress = progress
            db.downloadingChapters.put({ ...downloadingChapter, status: 'downloading', progress })
          }
        } else if (bgFetch.result === 'success') {
          const downloadingChapter = context.state.downloadingChapters.find(downloadingChapter => downloadingChapter.id === chapter.id)
          if (downloadingChapter) {
            downloadingChapter.status = 'downloaded'
            downloadingChapter.progress = 1.0
            db.downloadingChapters.put({ ...downloadingChapter, status: 'downloaded', progress: 1.0 })
            context.state.downloadedChapters = await db.chapters.toArray()
          }
        } else {
          const downloadingChapter = context.state.downloadingChapters.find(downloadingChapter => downloadingChapter.id === chapter.id)
          if (downloadingChapter) {
            downloadingChapter.status = 'failed'
            downloadingChapter.progress = 0.0
            db.downloadingChapters.put({ ...downloadingChapter, status: 'failed', progress: 0.0 })
          }
        }
      })
    }
  }
}
