"use strict";
var DC = require("..");

describe("deb-changelog", function(){
    var cl = new DC("blah");

    describe("sync", function(){
        it("may be invoked synchronously", function(){
            cl.should.be.true;
        });
    });
});
