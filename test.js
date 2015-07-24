/* global describe it */
"use strict";
var DC = require(".");
var co = require("co");
var _ = require("lodash");
require("should");

var testData = "macumba (0.6-0ubuntu1) trusty; urgency=medium\n\n" +
    "* Fix threaded execution\n" +
    "* More fixes\n" +
    "  Spans additional line\n" +
    "* Tartar sauce\n\n" +
    " -- Adam Stokes <adam.stokes@ubuntu.com>  Thu, 14 May 2015 08:43:11 -0400";

describe("deb-changelog", function(){
    var cl = new DC(testData);
    function* parse(){
        var chunks = yield cl.chunk();
        return yield cl.parse(_.first(chunks));
    }

    it("should parse version", function(done){
        co(function*(){
            var res = yield parse();
            res.version.should.equal("0.6-0");
            done();
        }).catch(function(err){
            done(err);
        });
    });
    it("should parse package name", function(done){
        co(function*(){
            var res = yield parse();
            res.pkgname.should.equal("macumba");
            done();
        }).catch(function(err){
            done(err);
        });
    });
    it("should parse version extra", function(done){
        co(function*(){
            var res = yield parse();
            res.versionExtra.should.equal("ubuntu1");
            done();
        }).catch(function(err){
            done(err);
        });
    });
    it("should parse series name", function(done){
        co(function*(){
            var res = yield parse();
            res.series.should.equal("trusty");
            done();
        }).catch(function(err){
            done(err);
        });
    });
    it("should parse priority name", function(done){
        co(function*(){
            var res = yield parse();
            res.priority.should.equal("medium");
            done();
        }).catch(function(err){
            done(err);
        });
    });
    it("should parse timestamp", function(done){
        co(function*(){
            var res = yield parse();
            res.timestamp.should.equal("Thu, 14 May 2015 08:43:11 -0400");
            done();
        }).catch(function(err){
            done(err);
        });
    });
    it("should contain a body array", function(done){
        co(function*(){
            var res = yield parse();
            res.body.length.should.equal(3);
            done();
        }).catch(function(err){
            done(err);
        });
    });
});
