Navigation
***********

Introduction
============

The navigation bundle provides a powerfull and extensible system which allows bundles to define
pages and routes in a hierarchy. This heirarchy can then be used to determine the relation of
the current page to the rest of the site, which is usefull when you want to generate **breadcrumb**
trails or **menus**.

Route definition is combined to ease maintainance.

ToDo
====

* Tree Caching
* "Proper" twig extension.
* Security

Working with Navigation Trees
=============================

The navigation tree is a nested set of `NavigationNode` instances. The navigation nodes *do not*
have setters / getters for common properties such as "setLabel", "getRoute", etc, instead it
allows the developer to set arbitary parameters using the `setAttribute` / `getAttribute` 
methods. Although there are expected conventions::

    // Ylly\NavigationBundle\NavigationNode
    protected $attributes = array(
        'label' => null,
        'route' => null,
        'display' => 'always',
        'help' => null,
        'icon_large' => null,
        '_type' => self::TYPE_PAGE,
    );

Creating the root node
----------------------

A root node can be created using the special factory method `NavigationNode::createRoot`::

    $tree = NavigationNode::createRoot();

XML Mapping
===========

Navigation structures are defined with XML.

Because of the "dual" nature of the navigation definition (routes and page heriarchy) the
file is actually used in two contexts. 

Firstly, the file is used to load routes into the Symfony **routing** service. We extend
the default `XmlFileLoader` class, so route definitions are the same as for standard XML routing.

Secondly, the file is parsed when we access the **navigation container**. The XML is then
transformed into an class tree which behaves like a standard Nested Set.

Loading the file
----------------

The XML file is to be included in the same way as standard routes, but with the exception of
setting the **type** parameter to `navigation`:

    #someApp/config/routing.yml
    crm:
        resource: CrmBundle/Resources/config/navigation.xml
        type: navigation

    cms:
        resource: CmsBundle/Resources/config/navigation.xml
        type: navigation


Example XML configuration
-------------------------

Note in the following example that:

 1. Routes can be defined anywhere, as they may not necessarily be associated with a page (e.g. delete actions).
 2. Routes under a page will automatically inherit the page `id`, so the `id` attribute can be ommitted if you want.
 3. The namespace attribute is required and enables you to utilize multiple hierachies.
 4. The long `_controller` format is not required.

As follows::

    <?xml version="1.0"?>
    <navigation namespace="admin">

      <!-- We can define routes anywhere !-->
      <route id="field_delete" pattern="/site{site_id}/field/{field_id/delete">
          <default key="_controller">CmsBundle:AdminFieldController:deleteAction</default>
      </route>

      <page label="Sites" help="Manage Sites" id="site_index" display="always">

          <route pattern="/sites">
              <default key="_controller">Ylly\CmsBundle\Controller\AdminSiteController::indexAction</default>
          </route>

          <page label="Site" help="View site" id="site_view" display="as-required">

              <route pattern="/site/{site_id}">
                  <default key="_controller">Ylly\CmsBundle\Controller\AdminSiteController::viewAction</default>
              </route>

              <page label="Theme" help="View Theme" id="theme_view" display="as-required">

                  <route pattern="/site/{site_id}/theme/{theme_id}">
                      <default key="_controller">Ylly\CmsBundle\Controller\AdminThemeController::viewAction</default>
                  </route>

                  <page label="Edit" help="Edit Theme" id="theme_edit" display="as-required">
                      <route pattern="/site/{site_id}/theme/{theme_id}/edit">
                          <default key="_controller">Ylly\CmsBundle\Controller\AdminThemeController::editAction</default>
                      </route>
                  </page>
              </page>
            </page>
      </page>
    </navigation>

Default Attributes
------------------

Attributes can be set arbitarily but the following are used by the renderer:

+---------------+--------------------------------+-------------------------------------+
| Attribute     | Type                           | Description                         |
+===============+================================+=====================================+
| label         | string                         | Label to show                       |
+---------------+--------------------------------+-------------------------------------+
| display       | enum(always|never|as-required) | Display policy. as required should  |
|               |                                | only display when current or        |
|               |                                | ancestor of current                 |
+---------------+--------------------------------+-------------------------------------+
| id            | string                         | Page ID also default route name     |
+---------------+--------------------------------+-------------------------------------+
| help          | string                         | Help text (e.g. show on hover)      |
+---------------+--------------------------------+-------------------------------------+

Extending previously defined nodes
----------------------------------

It is possible to extend previously defined nodes using the `pageExtend` tag::

    #someApp/Resources/config/navigation.xml
    <extendPage id="homePage">
        <page id="foobar" label="Homepage Extension">
            <!-- standard stuff here !-->
        </page>
    </extendPage>

This example will add the `foobar` page as a child of the `homePage` page
previously defined by another **Bundle**.

Rendering
=========

First of all, currently there is some legacy stuff which needs to be removed, specifically
the components and features associated with the `Renderer` namespace. It is currently used
by the old admin interface.

Rendering a navigation tree
---------------------------

Navigation trees can be rendered as follows::

    {% set tree = navigtaion_container.get('your_nav_tree') %}
    {{ navigation_render(tree, "NavigationBundle:Render:unorderedlist.html.twig") }}

So first of all we retrieve the navigation tree using the `navigation_container` global,
we then call the `navigation_render` function, which accepts:

 - The navigation tree.
 - A template resource to render the tree.

There is no default resource, but the one shown above is available and will render the
navigaiton tree as an unordered list.

Customizing the tree template
-----------------------------

You can specify any template resource when rendering the navigation tree. The specified
template then has access to one parameter `tree`.

The `tree` parameter contains the navigation tree that you passed into `navigation_render`.

The `navigation_render` function contextualizes the tree for the current request by flagging
the navigation node that matches the current page with the `current` attribute and also by
automatically injecting parameters specified in the route from the request if present::

    // your navigation template
    {% for node in tree.getChildren() %}
        <li><a href="{{ path(node.getAttribute('id'), node.getParameters()) }}">{{ node.getAttribute('label') }}</a></li>
    {% endfor %}

So if the corresponding route has the following pattern: `/site/{site_id}/foo`.

And the request has the `site_id` parameter and it is set to `5` then the all nodes that redeference
this route will automatically have the `site_id` paramter set to `5`.

Web Profiler Extension
======================

There is a web profiler extension which displays all the loaded navigation trees
with all nodes and attributes and parameters.

Undocumented Features
=====================

Tab nodes
---------

Nav nodes can be of the type `tab`. The idea here is that a page
that contains a tabbed interface can be configured in the XML file.
This enables other modules to extend the tabs shown on the page.

The tab definitions define how the content of the tab is aquired.

Havn't used this feature myself yet, so very unstable.
