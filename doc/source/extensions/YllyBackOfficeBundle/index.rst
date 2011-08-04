Back Office Templating 
**********************

The role of the `BackOfficeBundle` is to provide a cohesive interface
for the various **Admin** interfaces provided by the *yProx core* and
*extensions* to the *yProx platform*.

All business functionality (e.g. listing sites) is delegated to
the *Bundle* which provides the feature. So, the `YllyBackOfficeBundle`
should *never* do anything which is not relate to providing the admin
interface. Example, it may have a controller for rendering the navigation,
but it cannot have a controller for listing **sites**.

The *back office* has two contexts:

- *Context 1* - The global context, a.k.a. *BackOffice*.
- *Context 2* - The site configuration context, a.k.a. *SiteConfig*.

The *SiteConfig* context dedicates itself to the managment of a specific site, 
whilst the *BackOffice* enables management of **all** sites and clients.

The *SiteConfig* context will be the only interface available for most commercial
users.

This document aims to explain *how to template your extension* for *yProximité*.

Translation
===========

There should be no plain text language strings in the HTML. Instead there should be
a descriptive key which references a translation:

.. code-block:: html+jinja

    <h2>{% trans "HELLO_WORLD_TITLE" from "admin" %}</h2>

We wrap the key in the `trans` *Twig* tag, which will automatically substitute the key
for the translation for the current user locale, or failing that the default locale (and
failing that just displaying the key).

The translations are PHP files kept in the `Resoutces/translations` directory and are named as follows:

    admin.fr.php

Where `admin` is the message domain, (others might be **notifications**, etc) and `fr` is the locale.

Message domains
---------------

For *core* translations, i.e. translations that source from ``CmsBundle`` or ``CrmBundle`` the
*message domain* should be *admin* and *should be kept in the respective bundles translations
directory!*. Otherwise if the translation sources from an *extension* then the domain should
be named *after the extension* and kept in the extensions ``translations`` directory.

Example:

.. code-block:: html+jinja

    {# for CMS sourced text #}
    {% trans "foo_bar" from "admin" %}

    {# for extension sourced text (ArticleBundle) #}
    {% trans "foo_bar" from "articles" %}

Key Naming Convention
---------------------

Please follow the following convention when naming keys to minimize conflicts::

    %SUBJECT%_%ACTION%_%COMPONENT%

Example:
    
.. code-block:: html+jinja

    {% trans "ARTICLE_LIST_TITLE" from "admin" %}


Page Templates
==============

Both contexts have a dedicated *layout* one of which should be the parent for all
pages in the Back Office.

backOfficePage
--------------

``YllyBackOfficeBundle:Template:backOfficePage.html.twig``

The back office page should be extended by all pages which do depend on being
related to a *site*. For example, all *CRM* (Cusomer Relationship Managment) pages.

A typical template looks as follows:

.. code-block:: html+jinja

    // Ylly\CrmBundle\Resources\views\AdminCompany\index.twig.html
    {% extends "YllyBackOfficeBundle:Template:backOfficePage.html.twig" %}

    {% block actions %}
        {{ button.create(path('company_create'), 'COMPANY_CREATE') }}
    {% endblock %}

    {% block title_left %}{% trans 'COMPANY_LIST_TITLE' from 'admin' %}{% endblock %}
    {% block title_info %}{% trans 'COMPANY_LIST_TITLE_INFO' from 'admin' %}{% endblock %}
    {% block title_right %}{% trans 'COMPANY_LIST_FILTER_BY' from 'admin' %}: <a href="#">{% trans 'COMPANY_LIST_FILTER_CLIENT_HAS_PAYED' from 'admin' %}</a> | <a href="#">{% trans 'COMPANY_LIST_FILTER_PLATFORM' from 'admin' %}</a>{% endblock %}

    {%block page_content %}
        <table class="list">
            <!--  list stuff !-->
        </table>
    {% endblock %}

siteConfigPage
--------------

``YllyBackOfficeBundle:Template:siteConfigPage.html.twig``

This template is exactly the same as ``backOffice`` but with the addition of the **user navigation bar**.

The **user navigation bar** provides access to all the functionality available to the user.

Stylesheets
===========

Most stylesheet decisions are taken by the layout, for example you provide the text for the 
page title in the ``title_left`` block and the layout provides the stylesheets attributes.

For page content it is still necessary to manually add some stylesheet classes.t 

Lists
-----

All list tables (tables showing a list of enities) should be defined as follows::

    <table class="list">
        ..
    </table>

Sorting lists
-------------

You can add list sorting with javascript by calling the following in the *BackOffice*::

    {{ tableUtil.sort('.list', {}) }}

The second parameter are options to be passed to the tablesorter script, for example,
to specify the first column to be sorted by default (ascending)::

    {{ tableUtil.sort('.list', {'sortList': [[0,0]]}) }}

For a full list of options view the `table sorter API`_

.. _table sorter API: http://tablesorter.com/docs/#Configuration

Forms
-----

All forms should be wrapped in a div as follows::

    <div class="form">
        <form>
            ..
        </form>
    </div>

Macros
======

button macro
------------

The button macro is automatically included in the master layout and provides two functions:

.. note::
    
    All *path* parameters should be provided by the SF2 ``path`` function, e.g. 
    ``button.create(path('my_route', {'param1': 'value1'}), 'My Label')``.

button.create(path, label)
~~~~~~~~~~~~~~~~~~~~~~~~~~

Creates a graphical *anchor link* button with a create icon and the given label::

button.submit_save(label)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Creates a graphical *form submit* button with an image with the text "Savguarder". The
text will probably be changed to be dynamic so always supply a label even if it doesnt get used
at the moment.

formLink macro
--------------

The ``formLink`` macro is intended for use with *edit* and *create* forms and provides
a common way to render the links common to all forms. And should be defined in the 
*title_right* block of the parent template:

.. code-block:: jinja
    
    {% block title_right %}
        {{ formLink.return(path("foo")) }} |
        {{ formLink.delete(path("foo")) }}
    {% endblock %}

formLink.return(path)
~~~~~~~~~~~~~~~~~~~~~

Renders a return link, i.e. return to previous page. *path* is the previous page.

formLink.delete(path)
~~~~~~~~~~~~~~~~~~~~~

Renders a delete link, when the link is clicked the user is asked for confirmation, if
confirmed the browser will request the specified *path*.
