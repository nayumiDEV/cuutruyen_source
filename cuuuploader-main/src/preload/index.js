const { contextBridge, ipcRenderer } = require('electron/renderer')

// Custom APIs for renderer
const api = {
  getConfigKey: (key) => ipcRenderer.invoke('config:get', key),
  setConfigKey: (key, value) => ipcRenderer.invoke('config:set', key, value),
  login: (username, password) => ipcRenderer.invoke('login', username, password),
  logout: () => ipcRenderer.invoke('logout'),
  getUser: () => ipcRenderer.invoke('user:get'),
  getTeamMangas: (teamId, keyword, page, perPage) =>
    ipcRenderer.invoke('team:mangas:get', teamId, keyword, page, perPage),
  getTeamManga: (teamId, mangaId) => ipcRenderer.invoke('team:manga:get', teamId, mangaId),
  getTeamMangaChapters: (teamId, mangaId) =>
    ipcRenderer.invoke('team:manga:chapters:get', teamId, mangaId),
  openChapterEdit: (teamId, chapterId) =>
    ipcRenderer.invoke('team:chapter:edit:open', teamId, chapterId),
  openDirectory: () => ipcRenderer.invoke('directory:open'),
  readDirectory: (path) => ipcRenderer.invoke('directory:read', path),
  uploadImage: (path) => ipcRenderer.invoke('upload:image', path),
  createTeamChapter: (teamId, mangaId, chapter) =>
    ipcRenderer.invoke('team:chapter:create', teamId, mangaId, chapter),
  sortTeamChapters: (teamId, mangaId, chapters) =>
    ipcRenderer.invoke('team:chapter:sort', teamId, mangaId, chapters)
}

// Use `contextBridge` APIs to expose Electron APIs to
// renderer only if context isolation is enabled, otherwise
// just add to the DOM global.
contextBridge.exposeInMainWorld('electronAPI', api)
