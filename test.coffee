Promise = require('bluebird')
_ = require('lodash')
ChangeLog = Promise.promisifyAll(require('.'))

properChange = """
openstack (0.99.18-0ubuntu1~14.04.1~bleed1) trusty; urgency=medium

  * Fix nclxd

 -- Adam Stokes <adam.stokes@ubuntu.com>  Thu, 25 Jun 2015 10:25:15 -0400

openstack (0.99.17-0ubuntu1~15.10.1~bleed1) wily; urgency=medium

  * Fix typo in deploy command
  * Upgrade juju compat

 -- Adam Stokes <adam.stokes@ubuntu.com>  Fri, 19 Jun 2015 17:01:14 -0400
 """

nonSemVerChange = """
macumba (0.6-0ubuntu1) trusty; urgency=medium

  * Fix threaded execution
  * More fixes
  * Tartar sauce

 -- Adam Stokes <adam.stokes@ubuntu.com>  Thu, 14 May 2015 08:43:11 -0400

macumba (0.5-0ubuntu1) utopic; urgency=medium

  * Fix annotations

 -- Adam Stokes <adam.stokes@ubuntu.com>  Mon, 06 Oct 2014 11:52:49 -0400

macumba (0.3-0ubuntu1) utopic; urgency=medium

  * Add macumba-shell for interactively working with API

 -- Adam Stokes <adam.stokes@ubuntu.com>  Wed, 20 Aug 2014 12:41:16 -0400

macumba (0.2-0ubuntu1) utopic; urgency=medium

  * better exception handling

 -- Adam Stokes <adam.stokes@ubuntu.com>  Thu, 07 Aug 2014 01:25:49 +0200

macumba (0.1-0ubuntu1) utopic; urgency=low

  * Initial Release

 -- Adam Stokes <adam.stokes@ubuntu.com>  Tue, 08 Jul 2014 13:26:37 -0500

"""

logMultipleBody = """
macumba (0.6-0ubuntu1) trusty; urgency=medium

  * Fix threaded execution
  * More fixes
    Spans additional line
  * Tartar sauce

 -- Adam Stokes <adam.stokes@ubuntu.com>  Thu, 14 May 2015 08:43:11 -0400
"""

svl = new ChangeLog(properChange)
logs = svl.splitLogs()
for log in logs
  model = svl.parse(log)
  console.log model.pkgname

svl = new ChangeLog(nonSemVerChange)
logs = svl.splitLogs()
for log in logs
  model = svl.parse(log)
  console.log model.pkgname
