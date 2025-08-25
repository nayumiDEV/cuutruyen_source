import ky from '../lib/ky'

export const login = async (username, password) =>
  await ky.post('login', { json: { username, password } }).json()
