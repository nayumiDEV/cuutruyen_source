import {
  SpraypaintBase,
  MiddlewareStack,
  attr,
  belongsTo,
  hasMany
} from 'spraypaint'
import router from './router/index'
import store from './store/index'
const dbLoader = () => import('@/db')

export const ApplicationRecord = SpraypaintBase.extend({
  static: {
    baseUrl: '',
    apiNamespace: process.env.VUE_APP_API_NAMESPACE
  }
})

export const User = ApplicationRecord.extend({
  static: {
    jsonapiType: 'users'
  },
  attrs: {
    username: attr(),
    email: attr(),
    password: attr(),
    passwordConfirmation: attr(),
    level: attr(),
    authToken: attr(),
    teams: hasMany(),
    mangaFollows: hasMany(),
    createdAt: attr(),
    updatedAt: attr()
  }
})

export const Author = ApplicationRecord.extend({
  static: {
    jsonapiType: 'authors'
  },
  attrs: {
    name: attr(),
    description: attr(),
    mangas: hasMany(),
    createdAt: attr(),
    updatedAt: attr()
  }
})

export const Category = ApplicationRecord.extend({
  static: {
    jsonapiType: 'categories'
  },
  attrs: {
    name: attr(),
    description: attr(),
    mangas: hasMany(),
    createdAt: attr(),
    updatedAt: attr()
  }
})

export const Team = ApplicationRecord.extend({
  static: {
    jsonapiType: 'teams'
  },
  attrs: {
    name: attr(),
    description: attr(),
    facebookAddress: attr(),
    viewsCount: attr(),
    translationsCount: attr(),
    isAds: attr(),
    users: hasMany(),
    translations: hasMany(),
    mangas: hasMany(),
    createdAt: attr(),
    updatedAt: attr()
  }
})

export const Manga = ApplicationRecord.extend({
  static: {
    jsonapiType: 'mangas'
  },
  attrs: {
    name: attr(),
    description: attr(),
    officialUrl: attr(),
    cover: attr(),
    coverUrl: attr(),
    coverMobileUrl: attr(),
    coverOriginalUrl: attr(),
    panorama: attr(),
    panoramaUrl: attr(),
    panoramaMobileUrl: attr(),
    panoramaOriginalUrl: attr(),
    focusX: attr(),
    focusY: attr(),
    coverDominantColor: attr(),
    panoramaDominantColor: attr(),
    panoramaDominantColor2: attr(),
    isReady: attr(),
    isRegionLimited: attr(),
    isFollowing: attr(),
    newestChapterNumber: attr(),
    newestChapterId: attr(),
    newestChapterCreatedAt: attr(),
    marginless: attr(),
    direction: attr(),
    status: attr(),
    viewsCount: attr(),
    viewsCountWeek: attr(),
    viewsCountMonth: attr(),
    author: belongsTo(),
    translations: hasMany(),
    titles: hasMany(),
    categories: hasMany(),
    teams: hasMany(),
    createdAt: attr(),
    updatedAt: attr()
  }
})

export const Title = ApplicationRecord.extend({
  static: {
    jsonapiType: 'titles'
  },
  attrs: {
    name: attr(),
    primary: attr(),
    manga: belongsTo(),
    createdAt: attr(),
    updatedAt: attr()
  }
})

export const Search = ApplicationRecord.extend({
  static: {
    jsonapiType: 'searches'
  },
  attrs: {
    name: attr(),
    description: attr(),
    cover: attr(),
    coverUrl: attr(),
    coverOriginalUrl: attr(),
    panorama: attr(),
    panoramaUrl: attr(),
    panoramaOriginalUrl: attr(),
    focusX: attr(),
    focusY: attr(),
    dominantColor: attr(),
    isReady: attr(),
    author: belongsTo(),
    createdAt: attr(),
    updatedAt: attr()
  }
})

export const Translation = ApplicationRecord.extend({
  static: {
    jsonapiType: 'translations'
  },
  attrs: {
    language: attr(),
    chaptersCount: attr(),
    viewsCount: attr(),
    chapters: hasMany(),
    team: belongsTo(),
    manga: belongsTo(),
    createdAt: attr(),
    updatedAt: attr()
  }
})

export const Chapter = ApplicationRecord.extend({
  static: {
    jsonapiType: 'chapters'
  },
  attrs: {
    number: attr(),
    name: attr(),
    pagesCount: attr(),
    viewsCount: attr(),
    commentsCount: attr(),
    order: attr(),
    status: attr(),
    previousChapterId: attr(),
    previousChapterNumber: attr(),
    previousChapterName: attr(),
    nextChapterId: attr(),
    nextChapterNumber: attr(),
    nextChapterName: attr(),
    translation: belongsTo(),
    pages: hasMany(),
    comments: hasMany(),
    createdAt: attr(),
    updatedAt: attr(),
    editedAt: attr()
  }
})

export const Reading = ApplicationRecord.extend({
  static: {
    jsonapiType: 'readings'
  },
  attrs: {
    pages: attr()
  }
})

export const ChapterListing = ApplicationRecord.extend({
  static: {
    jsonapiType: 'chapter_listings'
  },
  attrs: {
    chapters: attr()
  }
})

export const Page = ApplicationRecord.extend({
  static: {
    jsonapiType: 'pages'
  },
  attrs: {
    order: attr(),
    image: attr(),
    imageUrl: attr(),
    imageOriginalUrl: attr(),
    imageNormalUrl: attr(),
    imageFilename: attr({ persist: false }),
    drmData: attr(),
    width: attr(),
    height: attr(),
    isReady: attr(),
    isDrm: attr(),
    marginless: attr(),
    status: attr(),
    chapter: belongsTo(),
    createdAt: attr(),
    updatedAt: attr()
  }
})

export const Comment = ApplicationRecord.extend({
  static: {
    jsonapiType: 'comments'
  },
  attrs: {
    content: attr(),
    processedContent: attr(),
    user: belongsTo(),
    page: belongsTo(),
    chapter: belongsTo(),
    translation: belongsTo(),
    replies: hasMany(),
    replieds: hasMany(),
    createdAt: attr(),
    updatedAt: attr()
  }
})

export const Notification = ApplicationRecord.extend({
  static: {
    jsonapiType: 'notifications'
  },
  attrs: {
    type: attr(),
    params: attr(),
    title: attr(),
    message: attr(),
    url: attr(),
    icon: attr(),
    recipient: belongsTo(),
    readAt: attr(),
    createdAt: attr()
  }
})

export const NotificationReadAll = ApplicationRecord.extend({
  static: {
    jsonapiType: 'notification_read_alls'
  },
  attrs: {
  }
})

export const UserFollowManga = ApplicationRecord.extend({
  static: {
    jsonapiType: 'users_follow_mangas'
  },
  attrs: {
    userId: attr(),
    mangaId: attr(),
    user: belongsTo(),
    manga: belongsTo(),
    createdAt: attr(),
    updatedAt: attr()
  }
})

export const WebPushEndpoint = ApplicationRecord.extend({
  static: {
    jsonapiType: 'web_push_endpoints'
  },
  attrs: {
    userId: attr(),
    endpointUrl: attr(),
    auth: attr(),
    p256dh: attr(),
    user: belongsTo(),
    createdAt: attr(),
    updatedAt: attr()
  }
})

const middleware = new MiddlewareStack()

middleware.afterFilters.push(async function (response, json) {
  if (response.status === 401) {
    await store.dispatch('cleanCurrentUser')
    router.push({ name: 'Login' })
    throw new Error('401 response received. Clear authentication info and redirect to login.')
  }
})

middleware.beforeFilters.push(async function (url, options) {
  const currentUser = store.getters.currentUser
  const authToken = store.getters.authToken
  if (currentUser && authToken) {
    options.headers.M4U_UID = currentUser.id
    options.headers.M4U_TOKEN = authToken
  } else {
    try {
      const db = (await dbLoader()).default
      const auth = await db.auth.toCollection().first()
      if (auth) {
        options.headers.M4U_UID = auth.user.id
        options.headers.M4U_TOKEN = auth.authToken
      }
    } catch (error) {
      console.error(error)
    }
  }
})

ApplicationRecord.middlewareStack = middleware
