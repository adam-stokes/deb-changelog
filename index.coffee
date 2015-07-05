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
      '(?<series> \\w+);\\surgency=(?<priority>\\w+)', 'xg')
    @BodyRegex = xre('^\\s*\\*\\s(?<body>.*)', 'xg')
    @TimestampRegex = xre '^\\s*--\\s(?<ts> .*)', 'xg'

  parse: ->
    # Return version headers for each changelog block
    matches = []
    for line in @blob
      matchVer = xre.exec(line, @VersionRegex)
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
      if xre.exec(line, /^(\d+\.\d+\.\d+)/)
        model.semVer = true
      matchBody = xre.exec(line, @BodyRegex)
      if matchBody?
        model.body = matchBody.body
      matchTS = xre.exec(line, @TimestampRegex)
      if matchTS?
        model.timestamp = matchTS.ts
      matches.push model
    return Promise.all(matches)

module.exports = ChangeLog
