import { login } from './cuuapi'
import { getConfigKey, setConfigKey } from './config'
import {
  getTeamMangas,
  getTeamManga,
  getTeamMangaChapters,
  getUser,
  uploadImage,
  createTeamChapter,
  sortTeamChapters
} from './cuuapi'
import { shell, dialog } from 'electron'
import { readdir, readFile } from 'node:fs/promises'
import path from 'node:path'
import mime from 'mime'

export const loginHandler = async (event, username, password) => {
  const { data: currentUser, auth_token: authToken } = await login(username, password)
  await setConfigKey('authToken', authToken)
  await setConfigKey('currentUser', currentUser)

  return { authToken, currentUser }
}

export const logoutHandler = async () => {
  await setConfigKey('authToken', null)
  await setConfigKey('currentUser', null)
}

export const getUserHandler = async () => {
  return await getUser()
}

export const getConfigKeyHandler = async (event, key) => {
  return await getConfigKey(key)
}

export const setConfigKeyHandler = async (event, key, value) => {
  return await setConfigKey(key, value)
}

export const getTeamMangasHandler = async (event, teamId, keyword, page, perPage) => {
  return await getTeamMangas(teamId, keyword, page, perPage)
}

export const getTeamMangaHandler = async (event, teamId, mangaId) => {
  return await getTeamManga(teamId, mangaId)
}

export const getTeamMangaChaptersHandler = async (event, teamId, mangaId) => {
  return await getTeamMangaChapters(teamId, mangaId)
}

export const openChapterEditHandler = async (event, teamId, chapterId) => {
  shell.openExternal(`https://cuutruyen.net/team-management/${teamId}/chapters/${chapterId}/edit`)
}

export const openDirectoryHandler = async () => {
  const { canceled, filePaths } = await dialog.showOpenDialog({
    properties: ['openDirectory']
  })
  if (!canceled) {
    return filePaths[0]
  } else {
    return null
  }
}

export const readDirectoryHandler = async (event, readPath) => {
  const dirents = await readdir(readPath, { withFileTypes: true })
  return dirents.map((dirent) => ({
    name: dirent.name,
    parentPath: readPath,
    path: path.join(readPath, dirent.name),
    isDirectory: dirent.isDirectory(),
    isFile: dirent.isFile(),
    extension: dirent.isFile() ? dirent.name.split('.').pop().toLowerCase() : null
  }))
}

export const uploadImageHandler = async (event, uploadPath) => {
  const file = await readFile(uploadPath)
  return await uploadImage(file, mime.getType(uploadPath), path.basename(uploadPath))
}

export const createTeamChapterHandler = async (event, teamId, mangaId, chapter) => {
  return await createTeamChapter(teamId, mangaId, chapter)
}

export const sortTeamChaptersHandler = async (event, teamId, mangaId, chapters) => {
  return await sortTeamChapters(teamId, mangaId, chapters)
}
