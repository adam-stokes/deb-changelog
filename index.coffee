xre = require('xregexp').XRegExp
semver = require('semver')

class ChangeLog
  constructor: (@blob) ->

  parseBody: (stanza) ->
    bodyRe = xre(
      '\\*\\s(?<body>[^\\*-]*)', 'img')
    matches = []
    xre.forEach stanza, bodyRe, (match, i) ->
      matches.push match.body.trim()
    return matches

  splitLogs: ->
    bodyRe = xre(
      '[-\+]\\d{4}', 'mg')
    matches = []
    currentIdx = 0
    xre.forEach @blob, bodyRe, (match, i) ->
      endIdx = match.index + 4
      matches.push match.input[currentIdx..endIdx].trim()
      currentIdx = endIdx + 1
    return matches

  parse: (stanza) ->
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
      '\\s[^]*' +
      '--\\s(?<firstname>\\w+)' +
      '\\s' +
      '(?<lastname>\\w+)' +
      '\\s' +
      '(?<email><.*>)' +
      '\\s+' +
      '(?<timestamp>.*)', 'img')

    match = xre.exec(stanza, entryRe)
    model =
      pkgname: match.pkgname
      major: parseInt(match.major, 10)
      minor: parseInt(match.minor, 10)
      patchLevel: parseInt(match.patchLevel, 10) or undefined
      versionExtra: match.versionExtra
      series: match.series
      priority: match.priority
      firstname: match.firstname
      lastname: match.lastname
      email: match.email
      timestamp: match.timestamp
      debVersion: "#{match.major}.#{match.minor}"
    if match.patchLevel?
      model.debVersion = "#{model.debVersion}.#{match.patchLevel}"
    model.semVer = semver.valid(model.debVersion)
    model.body = @parseBody(stanza)
    return model

module.exports = ChangeLog
