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
      '(?<version>\\d+\\.\\d+\\.*\\d*-\\d+)' +
      '(?<versionExtra>.*)\\)' +
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
      version: match.version
      versionExtra: match.versionExtra
      series: match.series
      priority: match.priority
      firstname: match.firstname
      lastname: match.lastname
      email: match.email
      timestamp: match.timestamp
    model.body = @parseBody(stanza)
    return model

module.exports = ChangeLog
