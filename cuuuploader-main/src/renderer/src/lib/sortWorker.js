// Remove the import and use self.importScripts instead
// import { compare } from 'natural-orderby'

self.onmessage = (e) => {
  const { chapters, algorithm } = e.data

  // Simple string comparison for now
  const sorter = (a, b) => a.localeCompare(b)

  // Create function from algorithm string
  const handler = new Function('return ' + algorithm)()

  const result = chapters.sort(handler)
  self.postMessage(result)
}
