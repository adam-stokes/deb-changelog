"use strict";

const xre = require("xregexp");
const debug = require("debug")("deb-changelog");

class ChangeLog {
    constructor(blob) {
        this.blob = blob;
    }
    parseBody(stanza) {
        let bodyRe = xre("\\*\\s(?<body>[^\\*-]*)", "img");
        let matches = [];
        xre.forEach(stanza, bodyRe, (match, i) => {
            debug(i);
            return matches.push(match.body.trim());
        });
        return Promise.all(matches);
    }
    chunk() {
        let bodyRe = xre("[-\+]\\d{4}", "mg");
        let matches = [];
        let currentIdx = 0;
        xre.forEach(this.blob, bodyRe, (match, i) => {
            debug("iter: %s", i);
            let endIdx = match.index + 6;
            matches.push(match.input.slice(currentIdx, endIdx).trim());
            currentIdx = endIdx + 1;
        });
        debug(matches);
        return Promise.all(matches);
    }
    parse(stanza) {
        let entryRe = xre("^(?<pkgname>\\w+)" +
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
        let match = xre.exec(stanza, entryRe);
        let model = {
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
            .then((res) => {
                model.body = res;
            });
        return Promise.resolve(model);
    }
}

module.exports = ChangeLog;



