deb-changelog - parse `debian/changelog`

## Install

```
$ npm i --save deb-changelog
```

## Usage

```coffeescript
ChangeLog = require('deb-changelog')

properChange = """
openstack (0.99.18-0ubuntu1~14.04.1~bleed1) trusty; urgency=medium

  * Fix nclxd

 -- Adam Stokes <adam.stokes@ubuntu.com>  Thu, 25 Jun 2015 10:25:15 -0400

openstack (0.99.17-0ubuntu1~15.10.1~bleed1) wily; urgency=medium

  * Fix typo in deploy command
  * Upgrade juju compat

 -- Adam Stokes <adam.stokes@ubuntu.com>  Fri, 19 Jun 2015 17:01:14 -0400
 """

svl = new ChangeLog(properChange)
logs = svl.splitLogs()
for log in logs
  model = svl.parse(log)
  console.log model
```

## Result

```
[ pkgname: 'openstack',
  major: 0,
  minor: 99,
  patchLevel: 18,
  versionExtra: '0ubuntu1~14.04.1~bleed1',
  series: 'trusty',
  priority: 'medium',
  firstname: 'Adam',
  lastname: 'Stokes',
  email: '<adam.stokes@ubuntu.com>',
  timestamp: 'Thu, 25 Jun 2015 10:25:15 -0400',
  debVersion: '0.99.18',
  semVer: '0.99.18',
  body: [ 'Fix nclxd' ] ]
[ pkgname: 'openstack',
  major: 0,
  minor: 99,
  patchLevel: 17,
  versionExtra: '0ubuntu1~15.10.1~bleed1',
  series: 'wily',
  priority: 'medium',
  firstname: 'Adam',
  lastname: 'Stokes',
  email: '<adam.stokes@ubuntu.com>',
  timestamp: 'Fri, 19 Jun 2015 17:01:14 -0400',
  debVersion: '0.99.17',
  semVer: '0.99.17',
  body: [ 'Fix typo in deploy command', 'Upgrade juju compat' ] ]
```

## Copyright

2015 Adam Stokes <adam.stokes@ubuntu.com>

## License

MIT
