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
      '\\s*--\\s(?<firstname>\\w+)' +
      '\\s' +
      '(?<lastname>\\w+)' +
      '\\s' +
      '(?<email><.*>)' +
      '\\s+' +
      '(?<timestamp>.*)$', 'img')

    matches = []
    xre.forEach @blob, entryRe, (match, i) ->
      model =
        pkgname: match.pkgname
        major: parseInt(match.major, 10)
        minor: parseInt(match.minor, 10)
        patchLevel: parseInt(match.patchLevel, 10) or undefined
        versionExtra: match.versionExtra
        series: match.series
        priority: match.priority
      model.debVersion = "#{model.major}.#{model.minor}"
      if model.patchLevel?
        model.debVersion = "#{model.debVersion}.#{model.patchLevel}"
      model.semVer = false
      if model.major? and model.minor? and model.patchLevel?
        model.semVer = true
      model.body = match.body
      model.firstname = match.firstname
      model.lastname = match.lastname
      model.email = match.email
      model.timestamp = match.timestamp
      matches.push model
    return Promise.all(matches)

module.exports = ChangeLog
