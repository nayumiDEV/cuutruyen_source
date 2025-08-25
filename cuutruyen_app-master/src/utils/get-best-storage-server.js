import ky from 'ky'
import storageServers from '@/data/storage-servers'

const testServer = async (serverBaseUrl) => {
  await ky(`${serverBaseUrl}/cdn-cgi/trace`, { retry: 0, timeout: 1000 })
  return serverBaseUrl
}

export default async () => {
  try {
    const tests = []

    storageServers.forEach((serverBaseUrl) => {
      const test = testServer(serverBaseUrl)
      tests.push(test)
    })

    const result = await Promise.any(tests)

    console.log(`Choose fastest storage server: ${result}`)

    return result
  } catch (error) {
    console.error(`No storage server is available, default to the first storage server: ${storageServers[0]}`)
    return storageServers[0]
  }
}
