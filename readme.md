# deb-changelog [![NPM version][npm-image]][npm-url] [![Downloads][downloads-image]][npm-url] [![Build Status][travis-image]][travis-url]

> Promises based library for parsing a `debian/changelog` file.

## Install

```
$ npm i --save deb-changelog
```

## Usage

Use it like normal with thenables routine or a step further via `co`.

```js
"use strict";

var _ = require("lodash");
var ChangeLog = require("..");
var co = require("co");

var properChange = "openstack (0.99.18-0ubuntu1~14.04.1~bleed1) trusty; urgency=medium\n\n" +
    "  * Fix nclxd\n\n" +
    " -- Adam Stokes <adam.stokes@ubuntu.com>  Thu, 25 Jun 2015 10:25:15 -0400\n\n" +
    "openstack (0.99.17-0ubuntu1~15.10.1~bleed1) wily; urgency=medium\n\n" +
    "  * Fix typo in deploy command\n" +
    "  * Upgrade juju compat\n\n" +
    " -- Adam Stokes <adam.stokes@ubuntu.com>  Fri, 19 Jun 2015 17:01:14 -0400";

co(function*(){
    var svl = new ChangeLog(properChange);
    var chunks = yield svl.chunk();
    var parsed = yield svl.parse(_.first(chunks));
    console.log(parsed);
}).catch(function(err){
    throw Error(err);
});
```

## Result

```
{ pkgname: 'openstack',
  version: '0.99.18-0',
  versionExtra: 'ubuntu1~14.04.1~bleed1',
  series: 'trusty',
  priority: 'medium',
  firstname: 'Adam',
  lastname: 'Stokes',
  email: '<adam.stokes@ubuntu.com>',
  timestamp: 'Thu, 25 Jun 2015 10:25:15 -0400',
  body: [ 'Fix nclxd' ] }
```

## Copyright

2015 Adam Stokes <adam.stokes@ubuntu.com>

## License

[MIT License](http://en.wikipedia.org/wiki/MIT_License)

[downloads-image]: http://img.shields.io/npm/dm/deb-changelog.svg
[npm-url]: https://www.npmjs.com/package/deb-changelog
[npm-image]: http://img.shields.io/npm/v/deb-changelog.svg
[travis-image]: https://travis-ci.org/battlemidget/deb-changelog.svg?branch=master
[travis-url]: https://travis-ci.org/battlemidget/deb-changelog
