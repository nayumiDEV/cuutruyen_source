import { getQuickJS } from 'quickjs-emscripten'
import { Arena } from 'quickjs-emscripten-sync'
import { compare } from 'natural-orderby'

const init = async () => {
  const ctx = (await getQuickJS()).newContext()
  return new Arena(ctx, { isMarshalable: true })
}

const parseDirectoriesName = async (directories, algorithm) => {
  const arena = await init()

  arena.expose({
    console: {
      log: console.log
    },
    directories
  })

  arena.evalCode(algorithm)
  const result = arena.evalCode(
    'directories.map(directory => ({directoryName: directory.name, ...handler(directory.name)}))'
  )

  return result
}

const sortChapters = async (chapters, algorithm) => {
  const arena = await init()

  arena.expose({
    console: {
      log: console.log
    },
    chapters: chapters,
    sorter: (a, b) => {
      return compare()(a, b)
    },
    compare: compare
  })

  arena.evalCode(algorithm)
  arena.evalCode('chapters = JSON.parse(JSON.stringify(chapters))')
  const result = arena.evalCode('chapters.sort(handler)')
  result.forEach((chapter, index) => {
    chapter.order = result.length - index
  })

  console.log(result)

  return result
}

export { parseDirectoriesName, sortChapters }
