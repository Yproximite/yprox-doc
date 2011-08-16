Releasing yProximite
********************

Merge all pull requests and then ...

Run the selenium tests
======================

If the **hudson** continuous integration server is broken then you can 
run all the CI tests locally.

So first, launch selenium server::

    java -jar /path/to/selenium/selenium-server.xxxx -singleWindow -browserSessionReuse &

(note that the options are not required but make running the tests slightly faster)

Now launch the **selenium** test suite::

    phpunit -c config --stderr src/Ylly/YllyBackOfficeBundle/Tests/Selenium

Or run::

    phpunit --stderr -c config/ src/Ylly/YllyBackOfficeBundle/Tests/Selenium/ImageSliderBundle/Admin_listTest.php 
    PHPUnit 3.5.6 by Sebastian Bergmann.

    ...

    Time: 01:00, Memory: 11.00Mb

    OK (3 tests, 98 assertions)

This example (and output) will run a specific test -- `Admin_listTest` for the `ImageSliderBundle`

All ok? Lets proceed..

Create the release email
========================

1. Find the GIT commit of the previous stable build, e.g. if you released last Wednesday, look at the GITHub commit log for last wednesday and take note of the last commit. Alternatively you can look at the latest "prod" tag on git hub.

2. List all the changes::

   git log <lAST_STABLE_COMMIT>..HEAD --no-merges

This will list all commits (not merges) from the last stable to the most recent (HEAD)

You can additionally copy the output to the clipboard, example::

   git log e23e84..HEAD --no-merges | xclip

The output should look something like this::

    commit 986d31db0e536d3b613a2a90db46964f30601dfc
    Author: ds <dan.t.leech@gmail.com>
    Date:   Wed Aug 3 16:19:11 2011 +0100

        Integration
        
        - Removed logo pollution (for next week)
        - Removed conflict
        - Fixed image slider suprimer js return value

    commit 40418c894eeb7553622a6adc72d177c565be6933
    Author: benoitMariaux <benoit.mariaux@gmail.com>
    Date:   Wed Aug 3 17:09:28 2011 +0200

        refactored and created new controller for Google Analytics

    commit 088245504fcdf683931d866c0a260d4e918f3c53
    Author: benoitMariaux <benoit.mariaux@gmail.com>
    Date:   Tue Aug 2 18:50:12 2011 +0200

        new trans

Now delete any commits that are *quick fixes* and that are not *issues*.

.. note::

    All commits should be descriptive, and all commits which solve Issues
    should be be formatted correctly, see :doc:`git` for information on 
    how to correctly format your commit messages.

Deploy
======

If everything works you can deploy to production.

Sync to staging and check the database for changes
--------------------------------------------------

Login to the dev server::

    ssh me@dev.yproximite.fr -p65022

Login as yproxbuild via `su` and `cd` to home directory::

    sudo -i
    su yproxbuild
    cd

Build staging::

    sh build.sh master
    sh deploy.sh master staging

Sync staging::

    ./syncstaging.sh

Wait.

`cd` to staging dir::

    cd /var/www/p/YProx/current

Check for database changes::

    php app/admin/console doctrine:schema:update --dump-sql

- If there is no output then there are no changes. You are good.
- Otherwise there will be lines of SQL
    - If the SQL is NON-DESTRUCTIVE (i.e. no DELETE no DROP no CHANGE) then
      you can update the production server with this SQL before deployment, i.e.
      load *PHPMyAdmin* and apply the SQL.
    - if the SQL is DESTRUCTIVE (i.e. DELETE, DROP, CHANGE) you must apply
      the sql immediately **after** deployment.

Now you can deploy to production, `cd` back to home and run the deploy script for production::

    cd
    sh deploy.sh master prod

Et, voila. If you need to run the destructive SQL, do it now.

Changing production configuration, adding new site bundles
==========================================================

If you need to change the prodiuction configuration the source files for the build are
located in::

    /home/yproxbuild/config

To modify what is normally `environment_config.yml` edit `production_config.yml` and to
modify the activated site bundles modify `site_bundles.ini`.

Check that the sites work
=========================

You can now run the monitoring script (which actually runs automatically everyy half hour) to check
that everything **is not broken**.

`exit` back to root (if you are logged in as *yproxbuild*) and sudo to `yproxmon` and `cd` to the home directory::

    exit
    su yproxmon
    cd

Now `cd` to the `SiteMon` directory and run the `sitemon.php` script::

    cd SiteMon
    php sitemon.php
