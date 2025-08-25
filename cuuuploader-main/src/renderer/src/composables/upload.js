import { ref, computed } from 'vue'
import path from 'path'
import { compare } from 'natural-orderby'

const team = ref(null)
const manga = ref(null)
const mangaPath = ref('')
const nameParserAlgorithm = ref('')
const chaptersSorterAlgorithm = ref('')
const chapters = ref([])
const chapterDirectories = ref([])
const chaptersQueue = ref([])
const uploadStatus = ref('idle')

export function useUpload() {
  const initialize = () => {
    team.value = null
    manga.value = null
    mangaPath.value = ''

    nameParserAlgorithm.value = `const handler = (directoryName) => {
  // Thuật toán ví dụ để nhận dạng số và tên chương từ tên thư mục cha.
  // Tùy biến nó nếu bạn muốn.
  // Số chương cũng có thể bao gồm số thập phân hay chữ tùy ý
  // Tên thư mục cha được đặt theo dạng \`Chapter <số chương> - <tên chương>\`
  // Ví dụ:
  // Chapter 0.5 - Khởi đầu mới
  // Chapter 10 (Fixed) - Tình thế cấp bách
  // Chapter 20
  // Chapter 31 - Kết thúc
  console.log(directoryName)
  const match = directoryName.match(/Chapter ([^-]+)(?: *- *(.+))?/)
  console.log(match)
  const chapterNumber = match ? match[1].trim() : null
  const chapterName = match && match[2] ? match[2].trim() : null
  return { chapterNumber, chapterName }
}
`

    chaptersSorterAlgorithm.value = `const handler = (chapterA, chapterB) => {
  // Thuật toán ví dụ để sắp xếp số chương.
  // Tùy biến nó nếu bạn muốn.
  // \`sorter\` là hàm sắp xếp natsort đã được cho trước,
  // tương tự như cách Windows sắp xếp tên thư mục
  return sorter(chapterB.chapterNumber, chapterA.chapterNumber)
}
`

    chapters.value = []
    chapterDirectories.value = []
  }

  const setMangaPath = (p) => {
    mangaPath.value = p
  }

  const setTeam = (t) => {
    team.value = t
  }

  const setManga = (m) => {
    manga.value = m
  }

  const setChapters = (c) => {
    chapters.value = c
  }

  const setChapterDirectories = (c) => {
    chapterDirectories.value = c
  }

  const setNameParserAlgorithm = (a) => {
    nameParserAlgorithm.value = a
  }

  const setChaptersSorterAlgorithm = (a) => {
    chaptersSorterAlgorithm.value = a
  }

  const existingChapters = computed(() => {
    return chapters.value.filter((chapter) => chapter.id)
  })

  const toUploadChapters = computed(() => {
    return chapters.value.filter((chapter) => chapter.selected)
  })

  const uploadedChapters = computed(() => {
    return toUploadChapters.value.filter((chapter) => chapter.status === 'uploaded')
  })

  const uploadProgress = computed(() => {
    if (toUploadChapters.value.length === 0) return 0
    if (uploadedChapters.value.length === 0) return 0

    return (uploadedChapters.value.length / toUploadChapters.value.length) * 100
  })

  const startUpload = async () => {
    toUploadChapters.value.forEach((chapter) => {
      chapter.status = 'pending'
    })
    chaptersQueue.value = [...toUploadChapters.value]
    uploadStatus.value = 'uploading'
    await sortTeamChapters(existingChapters.value)
    processNextChapter()
  }

  const pauseUpload = () => {
    uploadStatus.value = 'paused'
  }

  const processNextChapter = async () => {
    if (chaptersQueue.value.length === 0) {
      uploadStatus.value = 'idle'
      return
    }

    if (uploadStatus.value === 'paused') {
      return
    }

    while (chaptersQueue.value.length > 0) {
      const chapter = chaptersQueue.value.shift()
      await uploadChapter(chapter)
    }
    await sortTeamChapters(toUploadChapters.value)
    uploadStatus.value = 'uploaded'
  }

  const uploadChapter = async (chapter) => {
    try {
      chapter.status = 'uploading'
      const imagePaths = await findImagePaths(chapter)
      chapter.totalImagesCount = imagePaths.length
      chapter.uploadedImagesCount = 0
      const uploadedImages = await uploadImages(chapter, imagePaths)
      await createTeamChapter(chapter, uploadedImages)
      chapter.status = 'uploaded'
    } catch (error) {
      chapter.status = 'failed'
      chapter.error = error
      console.error(error)
    }
  }

  const findImagePaths = async (chapter) => {
    const parentDirectory = path.join(mangaPath.value, chapter.directoryName)
    const files = await window.electronAPI.readDirectory(parentDirectory)
    return files
      .filter(
        (file) =>
          (file.isFile && file.name.endsWith('.jpg')) ||
          file.name.endsWith('.png') ||
          file.name.endsWith('.webp')
      )
      .map((file) => path.join(parentDirectory, file.name))
  }

  const uploadImages = async (chapter, imagePaths) => {
    const uploadPromises = imagePaths.map(async (imagePath) => {
      const uploadedImage = await uploadImage(imagePath)
      chapter.uploadedImagesCount++
      return uploadedImage
    })
    const result = await Promise.all(uploadPromises)
    chapter.uploadedImagesCount = imagePaths.length
    return result
  }

  const uploadImage = async (imagePath) => {
    return await window.electronAPI.uploadImage(imagePath)
  }

  const createTeamChapter = async (chapter, uploadedImages) => {
    return await window.electronAPI.createTeamChapter(team.value.id, manga.value.id, {
      number: chapter.chapterNumber,
      name: chapter.chapterName,
      order: chapter.order,
      pages_attributes: uploadedImages
        .sort((a, b) => compare()(a.name, b.name))
        .map((image, index) => ({
          image: JSON.stringify(image),
          order: index + 1
        }))
    })
  }

  const sortTeamChapters = async (chapters) => {
    const chaptersObject = chapters.reduce((acc, chapter) => {
      acc[chapter.id] = chapter.order
      return acc
    }, {})

    console.log(chaptersObject)

    return await window.electronAPI.sortTeamChapters(team.value.id, manga.value.id, {
      chapters: chaptersObject
    })
  }

  return {
    mangaPath,
    team,
    manga,
    nameParserAlgorithm,
    chaptersSorterAlgorithm,
    chapters,
    chapterDirectories,
    uploadStatus,
    uploadProgress,
    toUploadChapters,
    uploadedChapters,
    initialize,
    setMangaPath,
    setTeam,
    setManga,
    setChapters,
    setChapterDirectories,
    setNameParserAlgorithm,
    setChaptersSorterAlgorithm,
    startUpload,
    pauseUpload,
    uploadImage,
    createTeamChapter
  }
}
