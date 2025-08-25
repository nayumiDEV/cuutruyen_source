import got from './got.mjs'
import { FormData } from 'formdata-node'

export const login = async (username, password) =>
  await got.post('login', { json: { username, password } }).json()

export const getUser = async () => await got.get('user').json()

export const getTeamMangas = async (teamId, keyword, page = 1, perPage = 20) =>
  await got
    .get(`team_manage/${teamId}/mangas`, {
      searchParams: { q: keyword, page, per_page: perPage }
    })
    .json()

export const getTeamManga = async (teamId, mangaId) =>
  await got.get(`team_manage/${teamId}/mangas/${mangaId}`).json()

export const getTeamMangaChapters = async (teamId, mangaId) =>
  await got.get(`team_manage/${teamId}/mangas/${mangaId}/chapters`).json()

export const uploadImage = async (file, type, filename) => {
  const formData = new FormData()
  const blob = new Blob([file], { type })
  formData.set('file', blob, filename)
  return await got.post('upload/image', { body: formData }).json()
}

export const createTeamChapter = async (teamId, mangaId, chapter) =>
  await got.post(`team_manage/${teamId}/mangas/${mangaId}/chapters`, { json: chapter }).json()

export const sortTeamChapters = async (teamId, mangaId, chapters) =>
  await got.post(`team_manage/${teamId}/mangas/${mangaId}/chapters/sort`, { json: chapters }).json()
