import Vue from 'vue'
import VueRouter from 'vue-router'
import store from '@/store/index'

const Home = () => import('../views/Home.vue')
const Newest = () => import('../views/Newest.vue')
const Tag = () => import('../views/Tag.vue')
const Manga = () => import('../views/Manga.vue')
const Search = () => import('../views/Search.vue')
const Chapter = () => import('../views/Chapter.vue')
const SavedOffline = () => import('../views/SavedOffline.vue')
const Download = () => import('../views/Download.vue')
const OfflineChapter = () => import('../views/Offline/Chapter.vue')
const Banned = () => import('../views/Banned.vue')
const Login = () => import('../views/Login.vue')
const Register = () => import('../views/Register.vue')
const Following = () => import('../views/Following.vue')
const History = () => import('../views/History.vue')
const Configuration = () => import('../views/Configuration.vue')
const Notification = () => import('../views/Notification.vue')
const NotificationRedirect = () => import('../views/NotificationRedirect.vue')
const RequestResetPassword = () => import('../views/RequestResetPassword.vue')
const ResetPassword = () => import('../views/ResetPassword.vue')
const Donate = () => import('../views/Donate.vue')

const TeamProfile = () => import('../views/TeamProfile.vue')
const TeamProfilePosts = () => import('../views/TeamProfile/Posts.vue')
const TeamProfileMangasNew = () => import('../views/TeamProfile/MangasNew.vue')
const TeamProfileMangasTop = () => import('../views/TeamProfile/MangasTop.vue')

const TeamDashboard = () => import('../views/TeamManagement/Dashboard.vue')
const TeamMangaManagement = () => import('../views/TeamManagement/MangaManagement.vue')

const TeamChapterManagement = () => import('../views/TeamManagement/ChapterManagement.vue')
const TeamChapterEdit = () => import('../views/TeamManagement/ChapterEdit.vue')
const TeamChapterNew = () => import('../views/TeamManagement/ChapterNew.vue')
const TeamChapterSeparate = () => import('../views/TeamManagement/ChapterSeparate.vue')

const TeamMangaEdit = () => import('../views/TeamManagement/MangaEdit.vue')
const TeamMangaNew = () => import('../views/TeamManagement/MangaNew.vue')

const TeamPageManagement = () => import('../views/TeamManagement/TeamPageManagement.vue')
const TeamPreferences = () => import('../views/TeamManagement/TeamPreferences.vue')
const TeamNotification = () => import('../views/TeamManagement/Notification.vue')
const TeamNotificationRedirect = () => import('../views/TeamManagement/NotificationRedirect.vue')

const AdminTeamManagement = () => import('@/views/AdminDashboard/TeamManagement.vue')
const AdminUserManagement = () => import('@/views/AdminDashboard/UserManagement.vue')
const AdminMangaManagement = () => import('@/views/AdminDashboard/MangaManagement.vue')
const AdminTeamNew = () => import('@/views/AdminDashboard/TeamNew.vue')
const AdminMangaEdit = () => import('@/views/AdminDashboard/MangaEdit.vue')
const AdminDonationManagement = () => import('@/views/AdminDashboard/DonationManagement.vue')

const LayoutNormal = () => import('../layouts/LayoutNormal.vue')
const LayoutNull = () => import('../layouts/LayoutNull.vue')
const LayoutDefault = () => import('../layouts/LayoutDefault.vue')
const LayoutDark = () => import('../layouts/LayoutDark.vue')
const LayoutTeamManagement = () => import('../layouts/LayoutTeamManagement.vue')
const LayoutAdminDashboard = () => import('../layouts/LayoutAdminDashboard.vue')
const LayoutTeamProfile = () => import('../layouts/LayoutTeamProfile.vue')
// const LayoutNull = () => import('../layouts/LayoutNull.vue')

Vue.use(VueRouter)

const routes = [
  {
    path: '/mangas/:mangaId/chapters/:id',
    name: 'Chapter',
    component: Chapter,
    meta: {
      layout: LayoutNull
    }
  },
  {
    path: '/mangas/:id',
    name: 'Manga',
    component: Manga,
    meta: {
      layout: LayoutNormal
    }
  },
  {
    path: '/search/:keyword',
    name: 'Search',
    component: Search,
    meta: {
      layout: LayoutNormal
    }
  },
  {
    path: '/downloads',
    name: 'Download',
    component: Download,
    meta: {
      layout: LayoutNormal
    }
  },
  {
    path: '/saved-offline',
    name: 'SavedOffline',
    component: SavedOffline,
    meta: {
      layout: LayoutNormal
    }
  },
  {
    path: '/following',
    name: 'Following',
    component: Following,
    meta: {
      layout: LayoutNormal,
      requiresAuth: true
    }
  },
  {
    path: '/history',
    name: 'History',
    component: History,
    meta: {
      layout: LayoutNormal,
      requiresAuth: true
    }
  },
  {
    path: '/configuration',
    name: 'Configuration',
    component: Configuration,
    meta: {
      layout: LayoutNormal,
      requiresAuth: true
    }
  },
  {
    path: '/notifications',
    name: 'Notification',
    component: Notification,
    meta: {
      layout: LayoutNormal,
      requiresAuth: true
    }
  },
  {
    path: '/notifications/:notificationId',
    name: 'NotificationRedirect',
    component: NotificationRedirect,
    meta: {
      requiresAuth: true
    }
  },
  {
    path: '/offline/mangas/:mangaId/chapters/:id',
    name: 'OfflineChapter',
    component: OfflineChapter,
    meta: {
      layout: LayoutDark
    }
  },
  {
    path: '/login',
    name: 'Login',
    component: Login,
    meta: {
      layout: LayoutNormal
    }
  },
  {
    path: '/banned',
    name: 'Banned',
    component: Banned,
    meta: {
      layout: LayoutNull
    }
  },
  {
    path: '/register',
    name: 'Register',
    component: Register,
    meta: {
      layout: LayoutNormal
    }
  },
  {
    path: '/request-reset-password',
    name: 'RequestResetPassword',
    component: RequestResetPassword,
    meta: {
      layout: LayoutNormal
    }
  },
  {
    path: '/reset-password',
    name: 'ResetPassword',
    component: ResetPassword,
    meta: {
      layout: LayoutNormal
    }
  },
  {
    path: '/donate',
    name: 'Donate',
    component: Donate,
    meta: {
      layout: LayoutNormal
    }
  },
  {
    path: '/t/:teamSlug',
    name: 'TeamProfile',
    meta: {
      layout: LayoutTeamProfile
    },
    component: TeamProfile
  },
  {
    path: '/t/:teamSlug/posts',
    name: 'TeamProfilePosts',
    meta: {
      layout: LayoutTeamProfile
    },
    component: TeamProfilePosts
  },
  {
    path: '/t/:teamSlug/new-mangas',
    name: 'TeamProfileMangasNew',
    meta: {
      layout: LayoutTeamProfile
    },
    component: TeamProfileMangasNew
  },
  {
    path: '/t/:teamSlug/top-mangas',
    name: 'TeamProfileMangasTop',
    meta: {
      layout: LayoutTeamProfile
    },
    component: TeamProfileMangasTop
  },
  {
    path: '/team-management/:teamId/',
    name: 'TeamDashboard',
    meta: {
      layout: LayoutTeamManagement,
      requiresAuth: true,
      requiresTeamAuth: true
    },
    component: TeamDashboard
  },
  {
    path: '/team-management/:teamId/mangas',
    name: 'TeamMangaManagement',
    meta: {
      layout: LayoutTeamManagement,
      requiresAuth: true,
      requiresTeamAuth: true
    },
    component: TeamMangaManagement
  },
  {
    path: '/team-management/:teamId/mangas/new',
    name: 'TeamMangaNew',
    meta: {
      layout: LayoutTeamManagement,
      requiresAuth: true,
      requiresTeamAuth: true
    },
    component: TeamMangaNew
  },
  {
    path: '/team-management/:teamId/mangas/:mangaId/edit',
    name: 'TeamMangaEdit',
    meta: {
      layout: LayoutTeamManagement,
      requiresAuth: true,
      requiresTeamAuth: true
    },
    component: TeamMangaEdit
  },
  {
    path: '/team-management/:teamId/mangas/:mangaId/chapters',
    name: 'TeamChapterManagement',
    meta: {
      layout: LayoutTeamManagement,
      requiresAuth: true,
      requiresTeamAuth: true
    },
    component: TeamChapterManagement
  },
  {
    path: '/team-management/:teamId/translations/:translationId/chapters/new',
    name: 'TeamChapterNew',
    meta: {
      layout: LayoutTeamManagement,
      requiresAuth: true,
      requiresTeamAuth: true
    },
    component: TeamChapterNew
  },
  {
    path: '/team-management/:teamId/chapters/:chapterId/edit',
    name: 'TeamChapterEdit',
    meta: {
      layout: LayoutTeamManagement,
      requiresAuth: true,
      requiresTeamAuth: true
    },
    component: TeamChapterEdit
  },
  {
    path: '/team-management/:teamId/chapters/:chapterId/separate',
    name: 'TeamChapterSeparate',
    meta: {
      layout: LayoutTeamManagement,
      requiresAuth: true,
      requiresTeamAuth: true
    },
    component: TeamChapterSeparate
  },
  {
    path: '/team-management/:teamId/page-management',
    name: 'TeamPageManagement',
    meta: {
      layout: LayoutTeamManagement,
      requiresAuth: true,
      requiresTeamAuth: true
    },
    component: TeamPageManagement
  },
  {
    path: '/team-management/:teamId/team-preferences',
    name: 'TeamPreferences',
    meta: {
      layout: LayoutTeamManagement,
      requiresAuth: true,
      requiresTeamAuth: true
    },
    component: TeamPreferences
  },
  {
    path: '/team-management/:teamId/notification',
    name: 'TeamNotification',
    meta: {
      layout: LayoutTeamManagement,
      requiresAuth: true,
      requiresTeamAuth: true
    },
    component: TeamNotification
  },
  {
    path: '/team-management/:teamId/notifications/:notificationId',
    name: 'TeamNotificationRedirect',
    component: TeamNotificationRedirect,
    meta: {
      requiresAuth: true,
      requiresTeamAuth: true
    }
  },
  {
    path: '/admin/users',
    name: 'AdminUserManagement',
    meta: {
      layout: LayoutAdminDashboard,
      requiresAuth: true,
      requiresAdminAuth: true
    },
    component: AdminUserManagement
  },
  {
    path: '/admin/teams',
    name: 'AdminTeamManagement',
    meta: {
      layout: LayoutAdminDashboard,
      requiresAuth: true,
      requiresAdminAuth: true
    },
    component: AdminTeamManagement
  },
  {
    path: '/admin/mangas',
    name: 'AdminMangaManagement',
    meta: {
      layout: LayoutAdminDashboard,
      requiresAuth: true,
      requiresAdminAuth: true
    },
    component: AdminMangaManagement
  },
  {
    path: '/admin/donations',
    name: 'AdminDonationManagement',
    meta: {
      layout: LayoutAdminDashboard,
      requiresAuth: true,
      requiresAdminAuth: true
    },
    component: AdminDonationManagement
  },
  {
    path: '/admin/mangas/:id/edit',
    name: 'AdminMangaEdit',
    meta: {
      layout: LayoutAdminDashboard,
      requiresAuth: true,
      requiresAdminAuth: true
    },
    component: AdminMangaEdit
  },
  {
    path: '/admin/teams/new',
    name: 'AdminTeamNew',
    meta: {
      layout: LayoutAdminDashboard,
      requiresAuth: true,
      requiresAdminAuth: true
    },
    component: AdminTeamNew
  },
  {
    path: '/newest',
    name: 'Newest',
    component: Newest,
    meta: {
      layout: LayoutNormal
    }
  },
  {
    path: '/tag/:slug',
    name: 'Tag',
    component: Tag,
    meta: {
      layout: LayoutNormal
    }
  },
  {
    path: '',
    component: LayoutDefault,
    children: [
      {
        path: '/',
        name: 'Home',
        component: Home
      }
    ]
  }
]

const router = new VueRouter({
  mode: 'history',
  base: process.env.BASE_URL,
  routes,
  scrollBehavior (to, from, savedPosition) {
    if (savedPosition) {
      return savedPosition
    } else {
      return { x: 0, y: 0 }
    }
  }
})

router.beforeEach(async (to, from, next) => {
  if (!store.state.init) {
    await store.dispatch('restoreCurrentUser')
    store.dispatch('reloadCurrentUser')
    store.dispatch('reloadNotificationUnreadCount')
  }

  if (store.getters.currentUser?.user_ban?.ban_type === 'ban' && to.name !== 'Banned') {
    next({ name: 'Banned' })
  }

  if (to.meta.requiresAuth) {
    if (!store.getters.currentUser) {
      next({ name: 'Login' })
    }
  }

  if (to.meta.requiresTeamAuth) {
    const userTeamIds = store.getters.currentUser.teams.map(t => Number(t.id))

    if (!userTeamIds.includes(Number(to.params.teamId)) && store.getters.currentUser.level !== 'admin') {
      next({ name: 'Home' })
    }
  }

  if (to.meta.requiresAdminAuth) {
    if (store.getters.currentUser.level !== 'admin') {
      next({ name: 'Home' })
    }
  }

  next()
})

router.afterEach((to, from) => {
  store.commit('leaveErrorPage')
})

export default router
