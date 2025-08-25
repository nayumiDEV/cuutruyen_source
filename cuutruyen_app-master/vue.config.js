module.exports = {
  devServer: {
    allowedHosts: 'all',
    server: 'http',
    https: false,
    client: {
      webSocketURL: 'http://cuutruyen.localhost/ws'
    }
  },
  publicPath: '/',
  productionSourceMap: false,

  css: {
    extract: false
  },

  pwa: {
    name: 'Cứu Truyện',
    themeColor: '#4DBA87',
    msTileColor: '#000000',
    appleMobileWebAppCapable: 'yes',
    appleMobileWebAppStatusBarStyle: 'black',
    workboxPluginMode: 'InjectManifest',
    workboxOptions: {
      swSrc: './src/service-worker.js',
      swDest: 'service-worker.js',
      exclude: [
        /\.map$/,
        /manifest\.json$/,
        /ads\.txt$/
      ]
    },
    iconPaths: {
      favicon32: 'images/icons/favicon-32x32.png',
      favicon16: 'images/icons/favicon-16x16.png',
      appleTouchIcon: 'images/icons/apple-touch-icon.png',
      maskIcon: 'images/icons/safari-pinned-tab.svg',
      msTileImage: 'images/icons/mstile-150x150.png'
    }
  },

  transpileDependencies: ['ky'],

  configureWebpack: {
    experiments: {
      asyncWebAssembly: true
    }
  }
}
