import ky from '@/lib/ky-spy'

export const listHistoriesByUser = async (userId, cursor = null, limit = 40) => await ky.get('histories', { searchParams: { user_id: userId, cursor, limit } }).json()
export const listHistoriesByManga = async (userId, mangaId) => await ky.get('histories', { searchParams: { user_id: userId, manga_id: mangaId } }).json()
export const listHistoriesByChapter = async (userId, mangaId, chapterId) => await ky.get('histories', { searchParams: { user_id: userId, manga_id: mangaId, chapter_id: chapterId } }).json()
export const addHistory = async (json) => await ky.post('histories', { json })
export const incrementView = async (chapterId) => await ky.post(`views/${chapterId}`)
