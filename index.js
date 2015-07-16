"use strict";

var xre = require("xregexp").XRegExp;
var debug = require("debug")("deb-changelog");

function ChangeLog(blob) {
    this.blob = blob;
}

ChangeLog.prototype.parseBody = function(stanza) {
    var bodyRe = xre("\\*\\s(?<body>[^\\*-]*)", "img");
    var matches = [];
    xre.forEach(stanza, bodyRe, function(match, i) {
        debug(i);
        return matches.push(match.body.trim());
    });
    return matches;
};

ChangeLog.prototype.splitLogs = function() {
    var bodyRe = xre("[-\+]\\d{4}", "mg");
    var matches = [];
    var currentIdx = 0;
    xre.forEach(this.blob, bodyRe, function(match, i) {
        debug(i);
        var endIdx = match.index + 4;
        matches.push(match.input.slice(currentIdx, +endIdx + 1 || 9e9).trim());
        currentIdx = endIdx + 1;
    });
    return matches;
};

ChangeLog.prototype.parse = function(stanza) {
    var entryRe = xre("^(?<pkgname>\\w+)" +
                  "\\s" +
                  "\\(" +
                  "(?<version>\\d+\\.\\d+\\.*\\d*-\\d+)" +
                  "(?<versionExtra>.*)\\)" +
                  "\\s" +
                  "(?<series>\\w+);\\surgency=(?<priority>\\w+)" +
                  "\\s[^]*" +
                  "--\\s(?<firstname>\\w+)" +
                  "\\s" +
                  "(?<lastname>\\w+)" +
                  "\\s" +
                  "(?<email><.*>)" +
                  "\\s+" +
                  "(?<timestamp>.*)", "img");
    var match = xre.exec(stanza, entryRe);
    var model = {
        pkgname: match.pkgname,
        version: match.version,
        versionExtra: match.versionExtra,
        series: match.series,
        priority: match.priority,
        firstname: match.firstname,
        lastname: match.lastname,
        email: match.email,
        timestamp: match.timestamp
    };
    model.body = this.parseBody(stanza);
    return model;
};

module.exports = ChangeLog;
