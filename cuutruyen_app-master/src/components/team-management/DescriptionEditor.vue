<template>
  <div v-if="editor" class="editor-normal rounded-lg overflow-hidden w-full bg-white transition outline-none flex flex-col" :class="{ 'ring': isFocus }">
    <div class="editor-buttons flex gap-1 px-4 h-12 items-center border-b border-gray-200">
      <button type="button" :class="{ 'editor-button-active': editor.isActive('bold') }" class="editor-button" @click="editor.chain().focus().toggleBold().run()">
        <FormatBoldIcon />
      </button>

      <button type="button" :class="{ 'editor-button-active': editor.isActive('italic') }" class="editor-button" @click="editor.chain().focus().toggleItalic().run()">
        <FormatItalicIcon />
      </button>

      <button type="button" :class="{ 'editor-button-active': editor.isActive('strike') }" class="editor-button" @click="editor.chain().focus().toggleStrike().run()">
        <FormatStrikethroughIcon />
      </button>

      <button type="button" :class="{ 'editor-button-active': editor.isActive('heading', { level: 3 }) }" class="editor-button" @click="editor.chain().focus().toggleHeading({ level: 3 }).run()">
        <span class="text-xs">H</span>
      </button>

      <button type="button" :class="{ 'editor-button-active': editor.isActive('paragraph') }" class="editor-button" @click="editor.chain().focus().setParagraph().run()">
        <span class="text-xs">P</span>
      </button>

      <button type="button" :class="{ 'editor-button-active': editor.isActive('blockquote') }" class="editor-button" @click="editor.chain().focus().toggleBlockquote().run()">
        <FormatQuoteOpenIcon />
      </button>

      <button type="button" :class="{ 'editor-button-active': editor.isActive('bulletList') }" class="editor-button" @click="editor.chain().focus().toggleBulletList().run()">
        <FormatListBulletedIcon />
      </button>

      <button type="button" :class="{ 'editor-button-active': editor.isActive('orderedList') }" class="editor-button" @click="editor.chain().focus().toggleOrderedList().run()">
        <FormatListNumberedIcon />
      </button>

      <button type="button" :class="{ 'editor-button-active': editor.isActive('link'), 'editor-button-disabled': !editor.isActive('link') && editor.view.state.selection.empty }" class="editor-button" @click="setLink" :disabled="!editor.isActive('link') && editor.view.state.selection.empty">
        <LinkIcon />
      </button>

      <button type="button" :class="{ 'editor-button-active': editor.isActive('image') }" class="editor-button" @click="setImage">
        <ImageIcon />
      </button>

      <button type="button" class="editor-button" @click="editor.chain().focus().unsetAllMarks().clearNodes().run()">
        <FormatClearIcon />
      </button>
    </div>
    <EditorContent :editor="editor" class="px-4 py-2 overflow-auto flex-grow h-full prose prose-a:text-blue-500 max-w-none" />

    <portal>
      <SetLinkModal v-model="isShowSetLinkModal" @confirm="confirmSetLink" />
      <SetImageModal v-model="isShowSetImageModal" @confirm="confirmSetImage" />
    </portal>
  </div>
</template>

<script>
import { Editor, EditorContent } from '@tiptap/vue-2'
import FormatBoldIcon from 'vue-material-design-icons/FormatBold.vue'
import FormatItalicIcon from 'vue-material-design-icons/FormatItalic.vue'
import FormatStrikethroughIcon from 'vue-material-design-icons/FormatStrikethrough.vue'
import FormatQuoteOpenIcon from 'vue-material-design-icons/FormatQuoteOpen.vue'
import FormatListBulletedIcon from 'vue-material-design-icons/FormatListBulleted.vue'
import FormatListNumberedIcon from 'vue-material-design-icons/FormatListNumbered.vue'
import LinkIcon from 'vue-material-design-icons/Link.vue'
import ImageIcon from 'vue-material-design-icons/Image.vue'
import FormatClearIcon from 'vue-material-design-icons/FormatClear.vue'
import StarterKit from '@tiptap/starter-kit'
import Link from '@tiptap/extension-link'
import Image from '@tiptap/extension-image'
import SetLinkModal from './description-editor/SetLinkModal.vue'
import SetImageModal from './description-editor/SetImageModal.vue'

export default {
  components: {
    EditorContent,
    FormatBoldIcon,
    FormatItalicIcon,
    FormatStrikethroughIcon,
    FormatQuoteOpenIcon,
    FormatListBulletedIcon,
    FormatListNumberedIcon,
    FormatClearIcon,
    LinkIcon,
    ImageIcon,
    SetLinkModal,
    SetImageModal
  },

  props: {
    value: String
  },

  data () {
    return {
      editor: null,
      isFocus: false,
      isShowSetLinkModal: false,
      isShowSetImageModal: false
    }
  },

  mounted () {
    this.editor = new Editor({
      content: this.value,
      extensions: [
        StarterKit,
        Link.configure({
          openOnClick: false
        }),
        Image
      ],
      onFocus: () => {
        this.isFocus = true
      },
      onBlur: () => {
        this.isFocus = false
        console.log(this.editor.getHTML())
        this.$emit('blur')
      },
      onUpdate: ({ editor }) => {
        this.$emit('input', editor.getHTML())
      }
    })
  },

  methods: {
    focus () {
      if (this.editor) {
        this.editor.commands.focus()
      }
    },

    setLink () {
      if (this.editor.isActive('link')) {
        this.editor.commands.unsetLink()
      } else {
        this.isShowSetLinkModal = true
      }
    },

    setImage () {
      if (this.editor.isActive('image')) {
        this.editor.commands.deleteSelection()
      } else {
        this.isShowSetImageModal = true
      }
    },

    confirmSetLink (href) {
      this.editor.commands.setLink({ href })
    },

    confirmSetImage (imageData) {
      this.editor.chain().focus().setImage(imageData).run()
    }
  },

  beforeDestroy () {
    this.editor.destroy()
  }
}
</script>

<style>
.editor-normal .ProseMirror {
    @apply outline-none min-h-[300px];
}

.editor-button {
  @apply uppercase font-bold rounded flex justify-center items-center text-gray-700 bg-gray-100 hover:bg-gray-300 transition w-8 h-8;
}

.editor-button-active {
  @apply bg-gray-700 text-gray-200 hover:bg-gray-700;
}

.editor-button-disabled {
  @apply text-gray-300 cursor-default hover:bg-gray-100;
}
</style>
