<template>
  <div class="html-block-builder">
    <div class="space-y-4">
      <!-- Title Input -->
      <div>
        <label class="block text-sm font-medium text-gray-700 mb-2">
          Tiêu đề khối (tùy chọn)
        </label>
        <input
          v-model="localBlock.title"
          type="text"
          class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
          placeholder="Để trống nếu không cần tiêu đề..."
          @input="updateBlock"
        />
      </div>

      <!-- HTML Editor -->
      <div>
        <label class="block text-sm font-medium text-gray-700 mb-2">
          Nội dung HTML
        </label>
        <div class="border border-gray-300 bg-white rounded-lg overflow-hidden">
          <div ref="editorContainer"></div>
        </div>
        <p class="text-xs text-gray-500 mt-1">
          Hỗ trợ HTML thuần và các class TailwindCSS
        </p>
      </div>

      <!-- Info -->
      <div class="p-3 bg-blue-50 rounded-lg">
        <div class="text-sm text-blue-800">
          <strong>Khối HTML:</strong> Cho phép chèn HTML tùy chỉnh với hỗ trợ class của TailwindCSS.
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { EditorState } from '@codemirror/state'
import { basicSetup } from 'codemirror'
import { EditorView } from '@codemirror/view'
import { html } from '@codemirror/lang-html'

export default {
  name: 'HtmlBlockBuilder',

  props: {
    block: {
      type: Object,
      required: true
    }
  },

  data () {
    return {
      localBlock: {
        ...this.block,
        options: { ...this.block.options }
      },
      editor: null
    }
  },

  mounted () {
    this.initEditor()
  },

  beforeDestroy () {
    if (this.editor) {
      this.editor.destroy()
    }
  },

  methods: {
    initEditor () {
      const startState = EditorState.create({
        doc: this.localBlock.content || '',
        extensions: [
          basicSetup,
          html(),
          EditorView.updateListener.of((update) => {
            if (update.docChanged) {
              this.localBlock.content = update.state.doc.toString()
              this.updateBlock()
            }
          }),
          EditorView.theme({
            '&': {
              fontSize: '14px'
            },
            '.cm-content': {
              padding: '12px',
              minHeight: '300px'
            },
            '.cm-focused': {
              outline: 'none'
            },
            '.cm-editor': {
              borderRadius: '0'
            }
          })
        ]
      })

      this.editor = new EditorView({
        state: startState,
        parent: this.$refs.editorContainer
      })
    },

    updateBlock () {
      this.$emit('update', { ...this.localBlock })
    },

    updateEditorContent () {
      if (this.editor && this.localBlock.content !== this.editor.state.doc.toString()) {
        this.editor.dispatch({
          changes: {
            from: 0,
            to: this.editor.state.doc.length,
            insert: this.localBlock.content || ''
          }
        })
      }
    }
  },

  watch: {
    block: {
      handler (newBlock) {
        this.localBlock = {
          ...newBlock,
          options: { ...newBlock.options }
        }
        this.updateEditorContent()
      },
      deep: true
    }
  }
}
</script>
