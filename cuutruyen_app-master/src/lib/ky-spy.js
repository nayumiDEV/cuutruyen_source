import ky from 'ky'

export default ky.extend({
  prefixUrl: `${process.env.VUE_APP_SPY_ENDPOINT}`
})
