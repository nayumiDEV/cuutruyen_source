import { app } from 'electron'
import path from 'node:path'
import { writeFile, readFile } from 'node:fs/promises'
import _get from 'lodash/get.js'

function getConfigPath() {
  return path.join(app.getPath('userData'), 'config.json')
}

async function createConfig() {
  const configPath = getConfigPath()
  const config = {
    version: '1.0.0',
    currentUser: null,
    authToken: null
  }
  await writeFile(configPath, JSON.stringify(config, null, 2))
}

export async function getConfig() {
  const configPath = getConfigPath()
  try {
    await readFile(configPath, 'utf8')
  } catch (error) {
    await createConfig()
  }
  const config = await readFile(configPath, 'utf8')
  return JSON.parse(config)
}

export async function setConfig(config) {
  const configPath = getConfigPath()
  await writeFile(configPath, JSON.stringify(config, null, 2))
}

export async function setConfigKey(key, value) {
  const config = await getConfig()
  config[key] = value
  await setConfig(config)
}


export async function getConfigKey(key) {
  const config = await getConfig()
  return _get(config, key, null)
}
