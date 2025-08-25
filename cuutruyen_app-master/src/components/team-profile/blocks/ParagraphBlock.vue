<template>
  <div class="py-14 lg:py-20 px-2">
    <CuuHeading v-if="block.title">{{ block.title }}</CuuHeading>

    <div class="common-container">
      <div class="prose max-w-none" v-html="sanitizedContent"></div>
    </div>
  </div>
</template>

<script>
import sanitizeHtml from 'sanitize-html'

export default {
  name: 'ParagraphBlock',

  props: {
    block: {
      type: Object,
      required: true
    },
    team: {
      type: Object,
      required: true
    }
  },

  data () {
    return {
      sanitizedContent: ''
    }
  },

  mounted () {
    this.sanitizeContent()
    // Static content block - emit loaded immediately
    this.$emit('block-loaded')
  },

  watch: {
    'block.content': {
      handler () {
        this.sanitizeContent()
      },
      immediate: false
    }
  },

  methods: {
    sanitizeContent () {
      if (!this.block.content) {
        this.sanitizedContent = ''
        return
      }

      // Permissive sanitize-html configuration for paragraph content
      const sanitizeOptions = {
        allowedTags: [
          'h1', 'h2', 'h3', 'h4', 'h5', 'h6',
          'p', 'div', 'span', 'br', 'hr',
          'strong', 'b', 'em', 'i', 'u', 's', 'strike', 'del', 'ins',
          'ul', 'ol', 'li',
          'blockquote', 'pre', 'code',
          'a', 'img',
          'table', 'thead', 'tbody', 'tr', 'th', 'td',
          'small', 'sub', 'sup'
        ],
        allowedAttributes: {
          '*': ['class', 'id', 'style'],
          a: ['href', 'target', 'rel', 'title'],
          img: ['src', 'alt', 'width', 'height', 'title'],
          table: ['border', 'cellpadding', 'cellspacing'],
          th: ['colspan', 'rowspan', 'scope'],
          td: ['colspan', 'rowspan']
        },
        allowedSchemes: ['http', 'https', 'mailto', 'tel'],
        allowedSchemesByTag: {
          img: ['http', 'https', 'data']
        },
        allowedSchemesAppliedToAttributes: ['href', 'src'],
        allowProtocolRelative: true,
        enforceHtmlBoundary: false
      }

      this.sanitizedContent = sanitizeHtml(this.block.content, sanitizeOptions)
    }
  }
}
</script>
