_ = require('lodash')
Promise = require('bluebird')
xre = require('xregexp').XRegExp

class ChangeLog
  constructor: (@blob) ->
    @VersionRegex = xre(
      '^(?<pkgname> ^\\w+)' +
      '\\s' +
      '\\(' +
      '(?<major> \\d+)' +
      '\\.' +
      '(?<minor> \\d+)' +
      '\\.?' +
      '(?<patchLevel> \\d+)?-' +
      '(?<versionExtra> \\d+.*)\\)' +
      '\\s' +
      '(?<series> \\w+);\\surgency=(?<priority>\\w+)' +
      '\\s*\\*\\s(?<body>.*)' +
      '\\s*--\\s(?<ts> .*)', 'xg')

  parse: ->
    # Return version headers for each changelog block
    matchVer = xre.exec(@blob, @VersionRegex)
    if matchVer?
      model =
        pkgname: matchVer.pkgname
        major: parseInt(matchVer.major, 10)
        minor: parseInt(matchVer.minor, 10)
        patchLevel: parseInt(matchVer.patchLevel, 10) or 0
        versionExtra: matchVer.versionExtra
        series: matchVer.series
        priority: matchVer.priority
    model.semVer = false
    if xre.exec("#{model.major}.#{model.minor}.#{model.patchLevel}",
      /^(\d+\.\d+\.\d+)/)
      model.semVer = true
    model.body = matchVer.body
    model.timestamp = matchVer.ts
    return Promise.resolve(model)

module.exports = ChangeLog
