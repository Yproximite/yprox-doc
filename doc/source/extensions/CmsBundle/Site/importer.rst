Site Importer
*************

**Base Sites** are distributed as **Bundles**.

All **templates**, **fields**, **stylesheets** and **themes** are contained within. Also
any assets which are used, such as **images and javascript**.

The base sites are currently located in the `yProxSite` namespace under `src`.

Importing a site
================

Importing a site is very easy and consists of 2 steps, taking the *veterinaire* site as an example::

1. `./frontcon yprox:site:import FooBundle` - will import the given site bundle into the system.
2. `./frontcon assets:install` will install assets from (all) bundles.


.. note::

    Importing a site will *update* or *create* records depending on if they exist or not. Any changes
    made to the site in the web interface will be lost, but any child sites will not be affected.

Building a site bundle
----------------------

Templates are located in the `Resources` subdirectory of the bundle under the folder `imports`.

For anything to be loaded into the database, the import must be mapped with an XML file as follows::

    <?xml version="1.0"?>
    <site title="Foosite" ref="test" host="test.localhost" siteConfigLayout="YllyBackOfficeBundle::layout.html.twig">
        <parameters>
            <parameter name="parameter_1" value="foo"/>
        </parameters>

        <!-- Pages in the site !-->
        <pages>
            <page ref="test.page1" title="Page 1 Title" route="/test1" locale="en">
                <templateRef ref="test.page1"/>
                <stylesheetRef ref="test.stylesheet1"/>
            </page>
            <page ref="test.page2" title="Page 2 Title" route="/test2">
                <templateRef ref="test.page2"/>
                <stylesheetRef ref="test.stylesheet1"/>
            </page>
        </pages>

        <!-- Extensions we want to be enabled by default !-->
        <extension name="test_extension1"/>
        <extension name="test_extension2"/>

        <!-- Site templates !-->
        <templates>
            <template ref="test.page1" import="TestBundle:Test:view1.html.twig" category="page"/>
            <template ref="test.page2" import="TestBundle:Test:view1.html.twig" category="page"/>
            <template ref="test.theme1" import="TestBundle::theme1.html.twig" category="layout"/>
            <template ref="test.stylesheet1" import="TestBundle::stylesheet1.html.twig" category="stylesheet"/>
        </templates>

        <!-- Contents !-->
        <contents>
            <content ref="test.content1" templateContainerRef="test.page1" blockName="block1" position="10">
                <extension key="testKey" alias="test_extension1" featureName="list"/>
            </content>
        </contents>

        <!-- Themes !-->
        <themes>
            <theme ref="test.theme1" title="Theme 1">
                <templateRef ref="test.theme1"/>
                <stylesheetRef ref="test.stylesheet1"/>
            </theme>

            <theme ref="test.theme2" title="Theme 2" selected="true">
                <templateRef ref="test.theme1"/>
                <stylesheetRef ref="test.stylesheet1"/>
            </theme>
        </themes>

        <!-- Stylesheets !-->
        <stylesheets>
            <stylesheet ref="test.stylesheet1" title="Stylesheet 1">
                <templateRef ref="test.stylesheet1"/>
            </stylesheet>
        </stylesheets>

        <!-- and fields !-->
        <fields>
            <field ref="test.field1" token="testfield" value="Foobar" description="Description"/>
        </fields>
    </site>

Import References
-----------------

The import system uses static references to locate records which are to be updated or created.

Site Config Layout
------------------

Each site can specify a custom layout for the site configuration section of the admin interface
using the ``siteConfigLayout`` attribute in the ``site`` tag.

Extending the site importer
===========================

If you add a new extension you will likely want to be able to extend the site importer to create
or update records for the extension. For example, we want to load site content to be handled by
the `i18n_content` extension.

This involves 2 steps, first the creation of the class which will process the new data in the 
site importer XML file, then, we need to register the class in the *DIC*.

The Extension Class
-------------------

The extension class must extend `SiteImporterExtension` and implement one method, *extend*, which
is passed an `Event` from the main `SiteImporter` class.

The event contains the following parameters:

+--------------+-----------------------+
| name         | description           |
+==============+=======================+
| em           | the entity manager    |
+--------------+-----------------------+
| site         | the site entity       |
+--------------+-----------------------+
| xpath        | the XPath object      |
+--------------+-----------------------+

The *site* is the populated site object and the *xpath* is an `DOMXPath` object for the import XML file. 
The core `SiteImporter` object can be accessed through the *getSubject* method, this is usefull in particular
for writing messages to the console whilst the import is happening.

The class might look as follows::

    // src/Ylly/Extension/ContentBundle/Site/Importer/ContentImporterExtension.php
    namespace Ylly\Extension\ContentBundle\Site\Importer;
    use Ylly\CmsBundle\Site\Importer\SiteImporter;
    use Ylly\CmsBundle\Site\Importer\SiteImporterExtension;

    class ContentImporterExtension extends SiteImporterExtension
    {
        public function extend($event)
        {
            // NOTE THAT WE CAN WRITE TO THE OUTPUT VIA THE SITE IMPORTER
            $event->getSubject()->getOutput()->writeln('Processing content');

            $em = $event->getSiteImporter()->getEntityManager();
            $site = $event->getSite();
            $xpath = $event->getSiteImporter()->getXPath();

            foreach ($xpath->query('//mytag') as $mytag) {
                $myentity = new MyEntity;
                $myentity->setFoo($myTag->getAttribute('foo'));

                $em->persist($myentity);

                // optionally store a reference to the object for other classes to utilize
                $this->setReferencedEntity('my_entity', 'ref', $myentity);
            }
        }
    }

.. note::

    There is no need to **flush** the entity manager as this happens after the *extend* method has
    been called, in addition if you were to **flush** the entity manager it would break the transactional
    integrity of the import.

Entity References
-----------------

It is often the case that extensions require access to the entities genereated by other extensions or
by the core. This is facilitated by `SiteImporter::[set|get]ReferencedEntity`.

    // your extension
    $fooentity->setSomeRelationship(
        $event->getSubject()->getReferencedEntity('template_container', 'ref_string')
    );

Testing the importer extension
------------------------------

To ensure that the extension works it is necessary to fully unit test. This is fairly easy, a typical
test case might look as follows::

    // SiteNavigationImporterExtensionTest.php
    namespace Ylly\CmsBundle\Tests\Site\Importer;

    use Ylly\CmsBundle\Test\SiteImporterTest;
    use Ylly\Extension\SiteNavigationBundle\Site\Importer\SiteNavigationImporterExtension;

    class SiteNavigationImporterExtensionTest extends SiteImporterTest
    {
        // register extra entities that we need with the test stack (extends DoctrineTest)
        public function getClassNames()
        {
            $classnames = parent::getClassNames();
            $classnames[] = 'Ylly\Extension\SiteNavigationBundle\Entity\SiteNavigation';

            return $classnames;
        }

        public function test()
        {
            // you need to define a test site import XML file
            $filename = __DIR__.'/testSiteImport.xml';

            // connect the site importer extension (the manager is instantated in setUp of parent class)
            $this->connectSiteImporterExtension(new SiteNavigationImporterExtension);

            // import the site, if your extension relies on imported files you can
            // pass the bundles they depend on (i.e. the bundle you work on) here.
            $this->importSite($filename, array(new \Ylly\Extension\FooBundle\FooBundle));

            // test that everything has been imported correctly!!

            // $site = $this->getSite();
            // $tree = $this->em->getRepository('Ylly\Extension\SiteNavigationBundle\Entity\SiteNavigation')
            //     ->findOneBy(array('site' => $site->getId(), 'namespace' => 'main'));
            // $this->assertInstanceOf('Ylly\Extension\SiteNavigationBundle\Entity\SiteNavigation', $tree);
        }
    }

Adding the extension to the DIC
===============================

The extension should be registered in the DIC as follows, specifying `yprox.site.importer.extension` as the tag name::

    // src/Ylly/Extension/ContentBundle/DependencyInjection/ContentExtension.php
    // ...
    $container->register('yprox.site.importer.content', 
        'Ylly\Extension\ContentBundle\Site\Importer\ContentImporterExtension')
        ->addTag('yprox.site.importer.extension');
    // ...

Prioritizing your extension
---------------------------

You can make your extension run before or after other extensions by adding the `priority` parameter
to the tag in the *DIC*

    ->addTag('yprox.site.importer.extension', array('priority' => 100));

The priority paramter is passed directly to the Symfony2 `EventDispatcher` so follows the same logic,
the higher the priority, the sooner it will be executed.
