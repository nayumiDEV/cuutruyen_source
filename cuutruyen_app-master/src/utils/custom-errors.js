export class RegionNotSupported extends Error {
  constructor (geo, isSpider, ...params) {
    super(...params)

    if (Error.captureStackTrace) {
      Error.captureStackTrace(this, RegionNotSupported)
    }

    this.name = 'RegionNotSupported'

    this.geo = geo
    this.isSpider = isSpider
    this.date = new Date()
  }
}
