/* global describe it */
"use strict";
const DC = require(".");
const co = require("co");
const _ = require("lodash");
require("should");

const testData = "macumba (0.6-0ubuntu1) trusty; urgency=medium\n\n" +
    "* Fix threaded execution\n" +
    "* More fixes\n" +
    "  Spans additional line\n" +
    "* Tartar sauce\n\n" +
    " -- Adam Stokes <adam.stokes@ubuntu.com>  Thu, 14 May 2015 08:43:11 -0400";

describe("deb-changelog", () => {
    let cl = new DC(testData);
    function* parse(){
        let chunks = yield cl.chunk();
        return yield cl.parse(_.first(chunks));
    }

    it("should parse version", (done) => {
        co(function*(){
            let res = yield parse();
            res.version.should.equal("0.6-0");
            done();
        }).catch((err) => {
            done(err);
        });
    });
    it("should parse package name", (done) => {
        co(function*(){
            let res = yield parse();
            res.pkgname.should.equal("macumba");
            done();
        }).catch((err) => {
            done(err);
        });
    });
    it("should parse version extra", (done) => {
        co(function*(){
            let res = yield parse();
            res.versionExtra.should.equal("ubuntu1");
            done();
        }).catch((err) => {
            done(err);
        });
    });
    it("should parse series name", (done) => {
        co(function*(){
            let res = yield parse();
            res.series.should.equal("trusty");
            done();
        }).catch((err) => {
            done(err);
        });
    });
    it("should parse priority name", (done) => {
        co(function*(){
            let res = yield parse();
            res.priority.should.equal("medium");
            done();
        }).catch((err) => {
            done(err);
        });
    });
    it("should parse timestamp", (done) => {
        co(function*(){
            let res = yield parse();
            res.timestamp.should.equal("Thu, 14 May 2015 08:43:11 -0400");
            done();
        }).catch((err) => {
            done(err);
        });
    });
    it("should contain a body array", (done) => {
        co(function*(){
            let res = yield parse();
            res.body.length.should.equal(3);
            done();
        }).catch((err) => {
            done(err);
        });
    });
});
