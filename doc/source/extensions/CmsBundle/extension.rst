Extensions
**********

Ylly extensions provide additional functionality for the Ylly platform. They
are based on standard Symfony 2 Bundles and as such there are no limits as to
what they can do.

Extensions can create *features*. Features enable the extension to plugin to
the CMS framework and provide a gateway to the extensions features, e.g. an
`ArticleBundle` might have 2 features, `list` and `view`. The `view` feature
will show a single article whereas the `list` feature will show a paginated
list of all articles.

Creating an extension
=====================

Ylly extensions live in the `Ylly\Extension` namespace. Where they take the form
of a Symfony 2 Bundle, a minimal file structure would look as follows::

    Ylly/
        Extension/
            FooBundle/
                Controller/
                    AdminXxxController.php   << To provide xxx admin interface for backend
                    SiteXxxController.php    << To provide Xxx feature to frontend
                DependencyInjection/
                    FooExtension.php         << To register this extension with yProximitie
                Entity/
                    FooContent.php           << Sub class base yProx content
                Form/
                    FooContentEditForm.php   << Sub class base yProx content form
                Resources/
                    config/
                        navigation.xml       << Extend admin navigation
                    doc/
                        index.rst            << Documentation for this extension
                Tests/                       << Tests for this extension
                FooBundle.php                << Symfony Bundle class
                FooExtension.php             << yProx extension class (@todo merge with Bundle)

The Extension Class
----------------------

The extension class provides some metadata on the extension, it extends the abstract
`Ylly\CmsBundle\Extension\Extension` class which contains the logic for registering
the extension with the `extension_manager` service.

It looks as follows:

.. code-block:: php

    <?php
    namespace Ylly\Extension\ContentBundle;

    use Ylly\CmsBundle\Extension\Extension;

    class FooExtension extends Extension
    {
        // THE NAME IS THE INTERNAL REFERENCE FOR THE EXTENSION [A-Za-z_]
        public function getName()
        {
            return 'foo';
        }

        // USER FRIENDLY VERSION OF THE NAME
        public function getTitle()
        {
            return 'Foo Extension';
        }

        public function getShortDescription()
        {
            return 'A short description of Foo';
        }

        public function configure()
        {
            // Create as many as required
            $this->createFeature('single-article')
                ->setTitle('Single Article')
                ->setDescription('Render a single Foo article')
                ->setContentFormClass('Ylly\Extension\FooBundle\Form\FooContentForm')
                ->setContentEntityClass('Ylly\Extension\FooBundle\Entity\Foo');
                ->setControllerName('FooBundle:Foo:bar');
        }
    }

Note that in the `createFeature` configuration we set the *form class* and *entity class*. This
is to enable the feature to be administred in the backend.

Content Form and Entity Classes
-------------------------------

If an extension want to provide content to the user and be administred in the admin interface
it must extend the base content classes from `CmsBundle`.

When a new content is created based on your provided *feature* the **content** entity created will be
that defined by your feature, and the form used to edit the content will also be that which was
defined by your feature.

This enables you to add custom fields to the content, for example, an *article id* or a *photo field*,
or anything else you can put into the database.

Content Form:

.. code-block:: php

    <?php
    use Ylly\CmsBundle\Form\ContentEditForm;

    class FooContentForm extends ContentEditForm
    {
        public function configure()
        {  
            parent::configure();               // configure the base form
            $this->add(new TextField('foo'));  // add a new field

            $this->wrapFields(array('foo'));   // wrap the field in an inheritance field
        }
    }

Content Entity:

.. code-block:: php

    <?php
    use Ylly\CmsBundle\Entity\Content;

    class FooContent extends Content
    {
        /**
         * @orm:Column(type="string")
         * @validation:NotBlank()
         */
        protected $foo;

        public function setFoo($foo)
        {
            $this->foo = $foo;
        }

        public function getFoo()
        {
            return $this->foo;
        }
    }

And also, we need to connect to do some plumbing to make `FooContent` properly extend
the base class using *Class Table Inheritance*.

In the `boot` method of `FooBundle`:

.. code-block:: php

    <?php 
    use Ylly\CmsBundle\Doctrine\ExtendDiscriminatorMapManager;

    class FooBundle extends Bundle
    {
        public function boot()
        {
            ExtendDiscriminatorMapManager::register(
                'Ylly\CmsBundle\Entity\Content', 
                'article', 
                'Ylly\Extension\ArticleBundle\Entity\ArticleContent');
        }
    }

This feature is fully explained in its own chapter.

Dependency Injection
--------------------

For the extension to work it must be registered in the **DIC** (**D**ependency **I**njection **Container**):

.. code-block:: php
    
    <?php
    namespace Ylly\Extension\FooBundle\DependencyInjection;

    use Symfony\Component\HttpKernel\DependencyInjection\Extension;
    use Symfony\Component\DependencyInjection\ContainerBuilder;

    class FooExtension extends Extension
    {
        public function configLoad($config, ContainerBuilder $container)
        {
            $container->register('yprox.site.extension.foo', 'Ylly\Extension\FooBundle\FooExtension')
                ->addTag('yprox.extension'); // IMPORTANT!!
        }

        public function getXsdValidationBasePath()
        {
            return null;
        }

        public function getNamespace()
        {
            return null;
        }

        public function getAlias()
        {
            return 'foo';
        }
    }

As can be seen we register the previously created `FooExtension` as a service in the **DIC** and we
add the `yprox.extension` tag. This is important as without that the extension will not be registered
with the Ylly platform.

.. note::

    This **DIC** extension will not be loaded until the relevant line is added to the applications
    `config.yml` file. More on this later.

Navigation
----------

You will probably want to extend the **admin navigation** to include the pages required for the
extensions admin interface. This is easily achieved using the `NavigationBundle`:

.. code-block:: xml

    // ../FooBundle/Resources/config/navigation.xml
    <?xml version="1.0"?>
    <navigation namespace="admin">
        <extendPage id="site_view">
            <!-- The page ID must be the same as the extension name !-->
            <!-- Set display = never as we will enable manually if the extension is enabled !-->
            <page id="foo" label="Foo" display="never">
                <route pattern="/site/{site_id}/foo">
                    <default key="_controller">FooBundle:Admin:index</default>
                </route>
            </page>
        </extendPage>
    </navigation>

Three essential settings:

- The namespace must be set to **admin** (assuming you are extending the admin nav tree)
- The root page ID must match the name of the extension if you want the tree to be shown only when the extension is enabled.
- We set the root page display policy to **never** as we will automatically set to **always** when the extension is enabled.

More on the navigation system can be found in the corresponding chapter.

Enabling the extension
----------------------

To enable the extension we need to

1. Instantiate the bundle in the `AppKernel::registerBundles` method:

.. code-block:: php

    <?php
    // apps/site/SiteKernel.php
    class siteKernel extends Kernel
    {
        // ...

        public function registerBundles()
        {
            $bundles = array(
                // ...
                new Ylly\Extension\FooBundle\FooBundle(),
            );
        }
    }

2. Register the **DIC** configuration in config.yml:

.. code-block:: yaml

   // config/config.yml for global or apps/site/config/config.yml for specific application
   foo: ~

3. Import the navigation routes and instantiate the Navigation heirarchy:

.. code-block:: yaml
    
   // apps/site/config/routing.yml
    foo_extension:
        resource: @FooBundle/Resources/config/navigation.xml
        type: navigation

4. Add the bundle name to the list of Bundles that the `DoctrineBundle` will scan, otherwise
   any *Entities* you add will not be registered:

.. code-block:: yaml

    // config/config.yml
    doctrine:
        orm:
            mappings:
                CmsBundle: ~
                CrmBundle: ~
                // ...
                FooBundle: ~

Documentation
=============

The documentation for your extension should be kept in `Resources/doc` and should be in
the `ReStructured Text` format.

Tests
=====

Registration
------------

For your unit tests to be run automatically you will need to register the bundle
int the `phpunit.xml` configuration:

.. code-block:: xml

  // config/phpunit.xml
  // ...
  <testsuite name="Project Test Suite">
       <directory>../src/Ylly/Extension/FooBundle/Tests</directory>
       // ...
  </testsuite>
  // ...

SiteImporterTest Base Class
---------------------------

To make testing the extensions SiteImporter class easier you can extend the `SiteImporterTest` base class:

.. code-block:: php

    <?php
    namespace Ylly\CmsBundle\Tests\Site\Importer;
    use Ylly\CmsBundle\Test\SiteImporterTest;

    class SiteNavigationImporterExtensionTest extends SiteImporterTest
    {
        public function getClassNames()
        {
            $classnames = parent::getClassNames();
            $classnames[] = 'Ylly\Extension\SiteNavigation\Entity\SiteNavigationTree';
            return $classnames;
        }

        public function test()
        {
            $filename = __DIR__.'/Resources/config/testsite.xml';

            // REGISTER YOUR SITE IMPORTER EXTENSION CLASS
            $this->connectSiteImporterExtension(new SiteNavigationImporterExtension);

            // IMPORT THE (minimal) SITE DEFINITION YOU HAVE DEFINED
            $this->importSite($filename);

            // run tests on the DB to ensure that your extension imported stuff properly.
        }
    }
    
Extension Generation
====================

Ylly can generate a skeleton Extension for you via the following command::

    ./admincon yprox:init:bundle YourBundleName your_bundle_name

The first argument is the *camelcased* name of your extension, the second is the 
*underscored* name of the extension. Or the first is used for class names and the
second is used for internal references.

The base skeleton structure can be found in `CmsBundle/Resources/skeleton/extension`.

Note that you will still need to enable the extension manually.
