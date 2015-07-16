"use strict";

var _ = require("lodash");
var ChangeLog = require(".");

var properChange = "openstack (0.99.18-0ubuntu1~14.04.1~bleed1) trusty; urgency=medium\n\n" +
    "  * Fix nclxd\n\n" +
    " -- Adam Stokes <adam.stokes@ubuntu.com>  Thu, 25 Jun 2015 10:25:15 -0400\n\n" +
    "openstack (0.99.17-0ubuntu1~15.10.1~bleed1) wily; urgency=medium\n\n" +
    "  * Fix typo in deploy command\n" +
    "  * Upgrade juju compat\n\n" +
    " -- Adam Stokes <adam.stokes@ubuntu.com>  Fri, 19 Jun 2015 17:01:14 -0400";

// var nonSemVerChange = "macumba (0.6-0ubuntu1) trusty; urgency=medium\n\n  * Fix threaded execution\n  * More fixes\n  * Tartar sauce\n\n -- Adam Stokes <adam.stokes@ubuntu.com>  Thu, 14 May 2015 08:43:11 -0400\n\nmacumba (0.5-0ubuntu1) utopic; urgency=medium\n\n  * Fix annotations\n\n -- Adam Stokes <adam.stokes@ubuntu.com>  Mon, 06 Oct 2014 11:52:49 -0400\n\nmacumba (0.3-0ubuntu1) utopic; urgency=medium\n\n  * Add macumba-shell for interactively working with API\n\n -- Adam Stokes <adam.stokes@ubuntu.com>  Wed, 20 Aug 2014 12:41:16 -0400\n\nmacumba (0.2-0ubuntu1) utopic; urgency=medium\n\n  * better exception handling\n\n -- Adam Stokes <adam.stokes@ubuntu.com>  Thu, 07 Aug 2014 01:25:49 +0200\n\nmacumba (0.1-0ubuntu1) utopic; urgency=low\n\n  * Initial Release\n\n -- Adam Stokes <adam.stokes@ubuntu.com>  Tue, 08 Jul 2014 13:26:37 -0500\n";

// var logMultipleBody = "macumba (0.6-0ubuntu1) trusty; urgency=medium\n\n  * Fix threaded execution\n  * More fixes\n    Spans additional line\n  * Tartar sauce\n\n -- Adam Stokes <adam.stokes@ubuntu.com>  Thu, 14 May 2015 08:43:11 -0400";

var svl = new ChangeLog(properChange);
var logs = svl.splitLogs();
var log = _.first(logs);
console.log("\n\nInput:");
console.log(log);
console.log("Result:");
var model = svl.parse(log);
console.log(model);
