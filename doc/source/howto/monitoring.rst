Monitoring
**********

LogWatch
========

This script sends daily reports from the `logwatch` application which details various events as detailed by the systems logs.

Vistors
=======

This script sends a daily anaysis of the Apache web server logs.

SiteMon
=======

Every 30 minutes all of the sites are checked to ensure that they provide a `HTTP/200` response code.

The script takes the output

Maintainance
------------

The code for *SiteMon* is kept in a public git repository::

    git@github.com:ylly/SiteMon

The repository has a `README.rst` file which explains all the configuration.

The sites to check are sourced from a public XML document periodically issued by **yProx**. The
document does not include test sites.
