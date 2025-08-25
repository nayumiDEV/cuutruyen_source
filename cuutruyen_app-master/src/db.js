import Dexie from 'dexie'

const db = new Dexie('manga4u')
db.version(4)
  .stores({
    mangas: 'id',
    chapters: 'id, manga.id',
    downloadingChapters: 'id, status, fetchId',
    pages: 'id, manga.id, chapter.id',
    auth: 'user.id, authToken'
  })
  .upgrade(async trans => {
    await trans.chapters.clear()
    await trans.downloadingChapters.clear()
    await trans.mangas.clear()
    await trans.pages.clear()

    try {
      await trans.images.clear()
    } catch (error) {
      console.error('Cannot clear images from db')
    }
  })

export default db
