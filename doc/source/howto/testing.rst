Testing
*******

.. note:: 

    All automated tests are written for **PHPUnit** version **3.5+**.

PHPUnit and Selenium
====================

Install PHPUnit
---------------

Install PHPUnit by using PEAR::

    pear config-set auto_discover 1
    pear install pear.phpunit.de/PHPUnit

Install the Selenium extension::

    # if you havn't the php5-curl extension ...
    # apt-get install php5-curl

    pear install phpunit/PHPUnit_Selenium

Run the tests::

    phpunit -c config/

and you should see something like the following::

    PHPUnit 3.5.6 by Sebastian Bergmann.

    ............................................................ 60 / 74
    ..............

    Time: 4 seconds, Memory: 19.25Mb

    OK (74 tests, 236 assertions)

Selenium Tests
--------------

Selenium is an application which can launch a real browser, e.g. firefox, and automate
the use of the web application (**yProx**) and check that it behaves properly.

This is very good for *regression* testing. That is, testing that the application still
works the way it did before making changes to the code.

All **Selenium** tests are currently located in `src/Ylly/YllyBackOfficeBundle/Tests/Selenium`.

The **Selenium** test suite, as with the **unit tests** should be executed before each release.

See :doc:`deploying` for information on running the selenium tests.

Unit Tests
----------

The `phpunit.xml` file is used to bootstrap and configure the test framework.

To run all the unit tests for the project::

  phpunit -c config/phpunit.xml

To run a set of tests::

  phpunit -c config/phpunit.xml src/SomeBundle/Tests/*

To run a specific test::

  phpunit -c config/phpunit.xml src/SomeBundle/Tests/SomeTest.php

DoctrineTest class
------------------

If you need to test classes that work with the database your test class can extend
`yProx\CmsBundle\Test\DoctrineTest`. This class bootstraps an in-memory *sqlite* database
and creates the schema depending on which classes you instruct it to use.

To specify which classes you want in the schema, implement the `getClassNames` method in 
your test class as follows::

    public function getClassNames()
    {
        return array(
            'yProx\CmsBundle\Entity\Site',
            'yProx\CmsBundle\Tests\Entity\Parent\Repository\TestEntity',
        );
    }

You can then access the entity manager as follows::

    $this->em->persist($someObject);
    $this->em->getRepository('/foo/bar/Entity');
    // etc...

Siege Testing
=============

To test the server under stress, i.e. to simulate multiple web requests on multiple URLs
you can use the application `siege`.

`siege` will test how the web application behaves when used by many users at the same time.

Installation
------------

To install under debian / ubuntu::

    apt-get install siege

Configuration
-------------

`siege` does not need any configuration, as all options can be passed from the command line
however to test multiple URLs it is necessary to create a text file with the URLs you want
`siege` to hit as follows:

For localhost::

    http://yprox.localhost/?site_id=1
    http://yprox.localhost/?site_id=2
    http://yprox.localhost/?site_id=4
    http://yprox.localhost/admin.php
    http://yprox.localhost/?site_id=4&_locale=de
    http://yprox.localhost/?site_id=4&_locale=fr
    http://yprox.localhost/services

If you can enter any URLs here in this file.

Run siege (laying siege)
------------------------

Just simply execute siege as follows::

    siege -f urls.txt
    
To change the number of concurrent users::

    siege -f urls.txt -c30

Will simulate 30 concurrent users.

Stopping siege (lifting the siege)
----------------------------------

To stop `siege` just hit <ctl-c>::

    Lifting the server siege...      done.
    Transactions:               1033 hits
    Availability:             100.00 %
    Elapsed time:              76.10 secs
    Data transferred:           3.92 MB
    Response time:              3.07 secs
    Transaction rate:          13.57 trans/sec
    Throughput:             0.05 MB/sec
    Concurrency:               41.61
    Successful transactions:        1033
    Failed transactions:               0
    Longest transaction:            8.57
    Shortest transaction:           0.15

