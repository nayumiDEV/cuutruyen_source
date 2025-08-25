import ky from '@/lib/ky'

export const getAdminTeams = async (q = '', page = 1, perPage = 20) => await ky.get('admin_manage/teams', { searchParams: { page, per_page: perPage, q } }).json()
export const getAdminUsers = async (q = '', page = 1, perPage = 20) => await ky.get('admin_manage/users', { searchParams: { page, per_page: perPage, q } }).json()
export const getAdminMangas = async (q = '', page = 1, perPage = 20) => await ky.get('admin_manage/mangas', { searchParams: { page, per_page: perPage, q } }).json()
export const getAdminDonations = async (year, month) => await ky.get('admin_manage/donations', { searchParams: { year, month } }).json()
export const updateAdminDonation = async (id, json) => await ky.put(`admin_manage/donations/${id}`, { json })
export const deleteAdminDonation = async (id) => await ky.delete(`admin_manage/donations/${id}`)
export const getAdminManga = async (id) => await ky.get(`admin_manage/mangas/${id}`).json()
export const updateAdminManga = async (id, json) => await ky.put(`admin_manage/mangas/${id}`, { json })
export const banUser = async (userId, json) => await ky.post(`admin_manage/users/${userId}/ban`, { json })
export const unbanUser = async (userId, json) => await ky.post(`admin_manage/users/${userId}/unban`, { json })
export const createAdminTeam = async (json) => await ky.post('admin_manage/teams', { json }).json()
export const searchAdminUsers = async (keyword, page = 1, perPage = 20) => await ky.get('admin_manage/users/search', { searchParams: { q: keyword, page, per_page: perPage } }).json()
