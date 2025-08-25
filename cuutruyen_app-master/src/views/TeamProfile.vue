<template>
  <div class="flex flex-col min-h-screen">
    <!-- Loading state for all blocks -->
    <LoadingScreen v-if="isLoadingBlocks" />

    <!-- Content blocks - always rendered but hidden during loading -->
    <div v-show="!isLoadingBlocks">
      <div v-for="(block, index) in sortedBlocks" :key="block.id">
        <component
          :is="getComponentName(block.type)"
          :block="block"
          :team="team"
          :class="{ 'bg-gray-200/50': index % 2 === 1 }"
          @block-loaded="onBlockLoaded(block.id)"
          @block-error="onBlockError(block.id)"
        />
      </div>
    </div>
  </div>
</template>

<script>
const defaultMainPageBlocks = JSON.parse(`[
  {
    "id": "f57e7c30-4e8e-4c51-914b-5b9ce0604aca",
    "type": "new-mangas",
    "order": 1,
    "title": "Truyện mới"
  },
  {
    "id": "48eaf60e-b2cb-4565-9de5-e19189e102fa",
    "type": "top-mangas",
    "order": 2,
    "title": "Truyện nổi bật"
  },
  {
    "id": "2e68ae61-5dbb-4f15-b88e-6c792ac2268f",
    "type": "new-posts",
    "order": 3,
    "title": "Bài viết mới"
  }
]`)

export default {
  name: 'TeamProfile',

  metaInfo () {
    return {
      title: `Trang chính - ${this.team.name}`
    }
  },

  props: {
    layoutProps: {
      type: Object,
      required: true
    }
  },

  data () {
    return {
      activeTab: 0,
      tabs: [
        'trang chính',
        'bài viết',
        'truyện mới',
        'truyện nổi bật'
      ],
      mainPageBlocks: null,
      loadedBlocks: new Set(),
      errorBlocks: new Set(),
      isLoadingBlocks: true
    }
  },

  methods: {
    getComponentName (type) {
      const componentMap = {
        'new-mangas': 'NewMangasBlock',
        'top-mangas': 'TopMangasBlock',
        'new-posts': 'NewPostsBlock',
        'spotlight-manga': 'SpotlightBlock',
        image: 'ImageBlock',
        youtube: 'YoutubeBlock',
        soundcloud: 'SoundcloudBlock',
        paragraph: 'ParagraphBlock',
        html: 'HtmlBlock'
      }

      return componentMap[type] || 'DefaultBlock'
    },

    onBlockLoaded (blockId) {
      this.loadedBlocks.add(blockId)
      this.checkAllBlocksLoaded()
    },

    onBlockError (blockId) {
      this.errorBlocks.add(blockId)
      this.checkAllBlocksLoaded()
    },

    checkAllBlocksLoaded () {
      const totalBlocks = this.sortedBlocks.length
      const completedBlocks = this.loadedBlocks.size + this.errorBlocks.size

      if (completedBlocks >= totalBlocks) {
        this.isLoadingBlocks = false
        this.releaseBodyScroll()
      }
    },

    initializeBlockLoading () {
      console.log('initializeBlockLoading')
      // Reset loading state
      // If there are no blocks, show content immediately
      if (this.sortedBlocks.length === 0) {
        this.isLoadingBlocks = false
      }
    }
  },

  computed: {
    team () {
      return this.layoutProps.team
    },

    sortedBlocks () {
      if (!this.mainPageBlocks) return []
      return [...this.mainPageBlocks].sort((a, b) => a.order - b.order)
    }
  },

  components: {
    NewMangasBlock: () => import('@/components/team-profile/blocks/NewMangasBlock.vue'),
    TopMangasBlock: () => import('@/components/team-profile/blocks/TopMangasBlock.vue'),
    NewPostsBlock: () => import('@/components/team-profile/blocks/NewPostsBlock.vue'),
    ImageBlock: () => import('@/components/team-profile/blocks/ImageBlock.vue'),
    ParagraphBlock: () => import('@/components/team-profile/blocks/ParagraphBlock.vue'),
    HtmlBlock: () => import('@/components/team-profile/blocks/HtmlBlock.vue'),
    SpotlightBlock: () => import('@/components/team-profile/blocks/SpotlightBlock.vue'),
    DefaultBlock: () => import('@/components/team-profile/blocks/DefaultBlock.vue'),
    YoutubeBlock: () => import('@/components/team-profile/blocks/YoutubeBlock.vue'),
    SoundcloudBlock: () => import('@/components/team-profile/blocks/SoundcloudBlock.vue')
  },

  mounted () {
    this.lockBodyScroll()

    this.mainPageBlocks = JSON.parse(this.team.main_page_blocks)
    if (!this.mainPageBlocks || this.mainPageBlocks.length === 0) {
      this.mainPageBlocks = defaultMainPageBlocks
    }

    // Initialize loading state after blocks are set
    this.$nextTick(() => {
      this.initializeBlockLoading()
    })
  }
}
</script>
