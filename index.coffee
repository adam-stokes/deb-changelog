Promise = require('bluebird')
xre = require('xregexp').XRegExp

class ChangeLog
  constructor: (@blob) ->

  parse: ->
    entryRe = xre(
      '^(?<pkgname>\\w+)' +
      '\\s' +
      '\\(' +
      '(?<major>\\d+)' +
      '\\.' +
      '(?<minor>\\d+)' +
      '\\.?' +
      '(?<patchLevel>\\d+)?-' +
      '(?<versionExtra>\\d+.*)\\)' +
      '\\s' +
      '(?<series>\\w+);\\surgency=(?<priority>\\w+)' +
      '\\s+\\*\\s(?<body>.*)' +
      '\\s*--\\s(?<ts>.*)', 'img')

    matches = []
    xre.forEach @blob, entryRe, (matchVer, i) ->
      model =
        pkgname: matchVer.pkgname
        major: parseInt(matchVer.major, 10)
        minor: parseInt(matchVer.minor, 10)
        patchLevel: parseInt(matchVer.patchLevel, 10) or undefined
        versionExtra: matchVer.versionExtra
        series: matchVer.series
        priority: matchVer.priority
      model.debVersion = "#{model.major}.#{model.minor}"
      if model.patchLevel?
        model.debVersion = "#{model.debVersion}.#{model.patchLevel}"
      model.semVer = false
      if xre.exec("#{model.major}.#{model.minor}.#{model.patchLevel}",
        /^(\d+\.\d+\.\d+)/)
        model.semVer = true
      model.body = matchVer.body
      model.timestamp = matchVer.ts
      matches.push model
    return Promise.all(matches)

module.exports = ChangeLog
