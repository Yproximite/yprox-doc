Testing
*******

All automated tests are written for **PHPUnit** version **3.5+**.

Selenium Tests
==============

See :doc:`/deploying` for information on running the selenium tests.

Unit Tests
==========

The `phpunit.xml` file is used to bootstrap and configure the test framework.

To run all the unit tests for the project::

  phpunit -c config/phpunit.xml

To run a set of tests::

  phpunit -c config/phpunit.xml src/SomeBundle/Tests/*

To run a specific test::

  phpunit -c config/phpunit.xml src/SomeBundle/Tests/SomeTest.php

DoctrineTest class
==================

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
