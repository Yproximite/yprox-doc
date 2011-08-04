Maintainance
************

Install Packages for Debian / Ubuntu
====================================

.. code-block:: bash

    apt-get install apache2 php5 php5-cli php5-gd php5-imagick mysql-server backup-manager ia32-libs postfix php-pear php5-gd php5-imagick git-core php5-intl phpmyadmin php5-sqlite


Checking out from github
========================

The project is hosted on *guthub*::

    git clone git@github.com:ylly/yProx.git
    cd yProx
    git submodule init
    git submodule update

Building and configuration
==========================

Local configuration
-------------------

The project uses a non-versioned file, *environment_config.yml* to store
configuration that changes from machine-to-machine, e.g. the *database connection settings*.

A default file is provided which you can copy::

    cd config
    cp environment_config.example.yml environment_config.yml

Your **local**, **development** database server should allow access to root with no password
for the default configuration to work without modification.

You also need to copy the example `site_bundles.ini.example` file to `site_bundles.ini`::

    cd config
    cp site_bundles.ini.example site_bundles.ini

This file tells yProximite which site bundles to manage.

Building the application (the build command)
--------------------------------------------

YProximitie features a command to build itself::

    php apps/admin/console yprox:build

Running this command alone will provide you with a list of build **targets** as follows::

    $./admincon yprox:build

    Build Targets
    -------------

    misc
      listBundles List installed site bundles
      listTargets List build targets
    main
      dev Build development environment
      devGit Perform global git update and build development environment
      devTest Build development environment and run unit and selenium tests
      prod build for production (no test data, no git) ATTENTION: Destroys database. Do NOT EXECUTE ON PROD.
    other
      clearCache Destroys cache directories
      buildApplication Builds application from scratch: Drops database, creates user, etc.
      importSiteBundles Import site bundles in yProxSite
      gitUpdate Updates core and all site bundles
      devSignups Excecutes dev signups
      unitTests  Runs phpunit unit tests
      seleniumTests  Runs selenium tests
      publishAssets  Publishes assets

You can run any of the targets -- the main targets are in the main group. To build a development version
execute::

    php apps/admin/console yprox:build dev

To build the dev version and also perform git updates::

    php apps/admin/console yprox:build devGit


Install PHPUnit
===============

Install PHPUnit by using PEAR::

    pear channel-update pear.php.net
    pear upgrade-all

    pear channel-discover pear.phpunit.de
    pear channel-discover components.ez.no
    pear channel-discover pear.symfony-project.com

    pear install phpunit/PHPUnit

Run the tests::

    phpunit -c config/

and you should see something like the following::

    PHPUnit 3.5.6 by Sebastian Bergmann.

    ............................................................ 60 / 74
    ..............

    Time: 4 seconds, Memory: 19.25Mb

    OK (74 tests, 236 assertions)
