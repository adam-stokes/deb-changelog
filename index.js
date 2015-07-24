"use strict";

var Promise = require("native-or-bluebird");
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
    return Promise.all(matches);
};

ChangeLog.prototype.chunk = function() {
    var bodyRe = xre("[-\+]\\d{4}", "mg");
    var matches = [];
    var currentIdx = 0;
    xre.forEach(this.blob, bodyRe, function(match, i) {
        debug("iter: %s", i);
        var endIdx = match.index + 6;
        matches.push(match.input.slice(currentIdx, endIdx).trim());
        currentIdx = endIdx + 1;
    });
    debug(matches);
    return Promise.all(matches);
};

ChangeLog.prototype.parse = function(stanza) {
    var entryRe = xre("^(?<pkgname>\\w+)" +
                      "\\s" +
                      "\\(" +
                      "(?<version>[0-9\\-\\.\\+]+)" +
                      "(?<versionExtra>[\\w\\d\\~\\-\\.\\+]+)" +
                      "\\)" +
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
    this.parseBody(stanza)
        .then(function(res){
            model.body = res;
        });
    return Promise.resolve(model);
};

module.exports = ChangeLog;
