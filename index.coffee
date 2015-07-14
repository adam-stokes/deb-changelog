# mega regex
#     entryRe = xre(
#        '^(?<pkgname>\\w+)' +
#        '\\s' +
#        '\\(' +
#        '(?<major>\\d+)' +
#        '\\.' +
#        '(?<minor>\\d+)' +
#        '\\.?' +
#        '(?<patchLevel>\\d+)?-' +
#        '(?<versionExtra>\\d+.*)\\)' +
#        '\\s' +
#        '(?<series>\\w+);\\surgency=(?<priority>\\w+)' +
#        '\\*\\s(?<body>.*)\\s+?(?<body2>.*)\\s+?(?<body3>.*)' +
#        '\\s*--\\s(?<firstname>\\w+)' +
#        '\\s' +
#        '(?<lastname>\\w+)' +
#        '\\s' +
#        '(?<email><.*>)' +
#        '\\s+' +
#        '(?<timestamp>.*)$', 'img')

xre = require('xregexp').XRegExp

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

    model = xre.exec(stanza, entryRe)
    model.major = parseInt(model.major, 10)
    model.minor = parseInt(model.minor, 10)
    model.patchLevel = parseInt(model.patchLevel, 10) or undefined
    model.debVersion = "#{model.major}.#{model.minor}"
    if model.patchLevel?
      model.debVersion = "#{model.debVersion}.#{model.patchLevel}"
    model.semVer = false
    if model.major? and model.minor? and model.patchLevel?
      model.semVer = true
    model.body = @parseBody(stanza)
    return model

module.exports = ChangeLog
