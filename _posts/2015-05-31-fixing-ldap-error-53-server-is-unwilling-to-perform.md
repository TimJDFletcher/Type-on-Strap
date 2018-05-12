---
id: 525
title: 'Fixing LDAP error 53 &#8220;Server is unwilling to perform&#8221;'
date: 2015-05-31T22:36:14+00:00
author: Tim Fletcher
layout: post
guid: https://blog.night-shade.org.uk/?p=525
permalink: /2015/05/fixing-ldap-error-53-server-is-unwilling-to-perform/
categories:
  - Linux
  - Ubuntu
---
Work has a pair of OpenLDAP servers which are in a standard master / slave synchronized setup. While preparing for some updates I checked that the LDAP servers where syncing correctly and discovered that the slave hadn&#8217;t updated in over 6 months!

On the slave server /var/log/syslog contained the following errors:

<pre>slapd[PID]: do_syncrep2: rid=XXX LDAP_RES_SEARCH_RESULT (53) Server is unwilling to perform
slapd[PID]: do_syncrep2: rid=XXX (53) Server is unwilling to perform</pre>

Working through the [Ubuntu server guide](https://help.ubuntu.com/14.04/serverguide/openldap-server.html) used to set up the pair of servers in the first place didn&#8217;t shed any light on the problem. A fresh Ubuntu 14.04 server in GCE showed the same problem, so at least I know the problem is on the master server.

I finally got a clue from [chapter 12](http://www.zytrax.com/books/ldap/ch12/) of &#8220;[LDAP for Rocket Scientists](http://www.zytrax.com/books/ldap/){.t-db}&#8220;, which suggested that the master server had &#8220;no global superior knowledge&#8221;. This was enough to make me test removing the accesslog databases, which track LDAP transactions and allow slave servers to sync changes from the master.

In the end it was a simple as removing the databases from /var/lib/ldap/accesslog and letting slapd rebuild them after a restart. Note depending on the config in slapd this might be in a different directory, check the setting for olcDbDirectory with this command:

<pre>sudo slapcat -b cn=config -a "(|(cn=config)(olcDatabase={2}hdb))"</pre>