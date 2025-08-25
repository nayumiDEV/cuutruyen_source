/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ['./public/**/*.html', './src/**/*.{vue,js,ts,jsx,tsx}'],
  theme: {
    extend: {
      fontFamily: {
        sans: '-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,Oxygen-Sans,"DejaVu Sans",Ubuntu,Cantarell,"Helvetica Neue",sans-serif',
        serif: ['Georgia', 'Cambria'],
        mono: 'SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", "Courier New", monospace',
        display: '-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,Oxygen-Sans,"DejaVu Sans",Ubuntu,Cantarell,"Helvetica Neue",sans-serif',
        body: '-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,Oxygen-Sans,"DejaVu Sans",Ubuntu,Cantarell,"Helvetica Neue",sans-serif',
        head: '-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,Oxygen-Sans,"DejaVu Sans",Ubuntu,Cantarell,"Helvetica Neue",sans-serif',
        subhead: '-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,Oxygen-Sans,"DejaVu Sans",Ubuntu,Cantarell,"Helvetica Neue",sans-serif',
        brand: '-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,Oxygen-Sans,"DejaVu Sans",Ubuntu,Cantarell,"Helvetica Neue",sans-serif'
      },

      fontSize: {
        xxs: '.55rem'
      }
    }
  },

  variants: {
    filter: ['group-hover', 'hover', 'focus'],
    backgroundColor: ['group-hover', 'even', 'odd', 'hover', 'focus'],
    borderStyle: ['responsive', 'last', 'hover', 'focus'],
    borderColor: ['even', 'odd'],
    extend: {
      textColor: ['disabled']
    }
  },

  plugins: [
    require('@tailwindcss/line-clamp'),
    require('@tailwindcss/typography')
  ]
}
