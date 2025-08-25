<template>
  <div class="py-14 lg:py-20 px-2">
    <CuuHeading v-if="block.title">{{ block.title }}</CuuHeading>

    <div class="common-container overflow-hidden">
      <div class="html-content" v-html="sanitizedContent" ref="htmlContent"></div>
    </div>
  </div>
</template>

<script>
import { createGenerator } from '@unocss/core'
import presetWind3 from '@unocss/preset-wind3'
import sanitizeHtml from 'sanitize-html'

export default {
  name: 'HtmlBlock',

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
      unoGenerator: null,
      generatedStyleId: null,
      sanitizedContent: ''
    }
  },

  async mounted () {
    try {
      await this.initializeUnoCSS()
      this.sanitizeContent()
      await this.processHtmlContent()
      this.$emit('block-loaded')
    } catch (error) {
      console.error('Error loading HTML block:', error)
      this.$emit('block-error')
    }
  },

  watch: {
    'block.content': {
      async handler () {
        this.sanitizeContent()
        await this.processHtmlContent()
      },
      immediate: false
    }
  },

  beforeDestroy () {
    this.removeGeneratedStyles()
  },

  methods: {
    sanitizeContent () {
      if (!this.block.content) {
        this.sanitizedContent = ''
        return
      }

      // Permissive sanitize-html configuration focused on XSS prevention
      const sanitizeOptions = {
        allowedTags: [
          'h1', 'h2', 'h3', 'h4', 'h5', 'h6',
          'p', 'div', 'span', 'br', 'hr',
          'strong', 'b', 'em', 'i', 'u', 's', 'strike', 'del', 'ins',
          'ul', 'ol', 'li',
          'blockquote', 'pre', 'code',
          'a', 'img', 'iframe',
          'table', 'thead', 'tbody', 'tr', 'th', 'td',
          'section', 'article', 'header', 'footer', 'nav', 'aside',
          'figure', 'figcaption',
          'small', 'sub', 'sup',
          'details', 'summary'
        ],
        allowedAttributes: {
          '*': ['class', 'id'],
          a: ['href', 'target', 'rel', 'title'],
          img: ['src', 'alt', 'width', 'height', 'title'],
          iframe: [
            'src', 'width', 'height', 'frameborder', 'allowfullscreen',
            'allow', 'title', 'loading', 'referrerpolicy', 'sandbox'
          ],
          table: ['border', 'cellpadding', 'cellspacing'],
          th: ['colspan', 'rowspan', 'scope'],
          td: ['colspan', 'rowspan']
        },
        allowedSchemes: ['http', 'https', 'mailto', 'tel'],
        allowedSchemesByTag: {
          img: ['http', 'https', 'data'],
          iframe: ['http', 'https']
        },
        allowedSchemesAppliedToAttributes: ['href', 'src'],
        allowProtocolRelative: true,
        enforceHtmlBoundary: false,
        transformTags: {
          iframe: (tagName, attribs) => {
            return {
              tagName: 'iframe',
              attribs: {
                ...attribs,
                sandbox: 'allow-scripts allow-same-origin allow-presentation allow-forms'
              }
            }
          }
        }
      }

      this.sanitizedContent = sanitizeHtml(this.block.content, sanitizeOptions)
    },

    async initializeUnoCSS () {
      this.unoGenerator = await createGenerator({
        presets: [
          presetWind3({
            variablePrefix: 'tw-'
          })
        ],
        theme: {
          breakpoints: {
            sm: '640px',
            md: '768px',
            lg: '1024px',
            xl: '1280px',
            '2xl': '1536px'
          }
        }
      })
    },

    async processHtmlContent () {
      if (!this.unoGenerator || !this.sanitizedContent) {
        return
      }

      try {
        // Extract all class names from the sanitized HTML content
        const classNames = this.extractClassNames(this.sanitizedContent)

        if (classNames.length === 0) {
          return
        }

        // Generate CSS for the extracted classes
        const result = await this.unoGenerator.generate(classNames.join(' '))

        if (result.css) {
          this.injectGeneratedCSS(result.css)
          console.log(result.css)
        }
      } catch (error) {
        console.error('Error processing UnoCSS:', error)
      }
    },

    extractClassNames (html) {
      const classRegex = /class=["']([^"']*)["']/g
      const classNames = new Set()
      let match

      while ((match = classRegex.exec(html)) !== null) {
        const classes = match[1].split(/\s+/).filter(cls => cls.trim())
        classes.forEach(cls => classNames.add(cls))
      }

      return Array.from(classNames)
    },

    injectGeneratedCSS (css) {
      // Remove previous generated styles
      this.removeGeneratedStyles()

      // Create new style element
      const styleElement = document.createElement('style')
      styleElement.type = 'text/css'
      styleElement.textContent = css

      // Add unique identifier for cleanup
      const styleId = `unocss-html-block-${this._uid}-${Date.now()}`
      styleElement.setAttribute('data-unocss-html-block', styleId)
      this.generatedStyleId = styleId

      // Inject into document head
      document.head.appendChild(styleElement)
    },

    removeGeneratedStyles () {
      if (this.generatedStyleId) {
        const existingStyle = document.querySelector(`[data-unocss-html-block="${this.generatedStyleId}"]`)
        if (existingStyle) {
          existingStyle.remove()
        }
        this.generatedStyleId = null
      }
    }
  }
}
</script>
