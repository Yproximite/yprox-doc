The Twig Extension
******************

The CMS Bundle provides two Twig extensions, one for the *admin* application and 
another for the *site* application which enables templates to be configured
with tags which provide content from the CMS.

Admin Extension
===============

The admin *Twig* extension provides access to the ``AdminSiteManager`` through
the ``site_manager`` tag:

.. code-block:: html+jinja

    {% set layout = site_manager.getSite().getParameter('site-config-layout') %}

    {% if not layout %}
        {% set layout = "YllyBackOfficeBundle::layout.html.twig" %}
    {% endif %}

    {% extends layout %}

Site Extension
==============

content_render(blockName)
-------------------------

The contentBlock function instructs all content matching the given
block name on the current page to be rendered in place, example:

.. code-block:: html+jinja

    <div class="foobar">
        {% content_render("main") %}
    </div>

This will cause all content on the current page that is assigned
to the *main* block name to be rendered inbetween the `<div>`'s.

.. note::
    You can display use the `?_showContent=1` on the frontoffice to display
    the boundary and details of each content.

content_count(blockName)
------------------------

Returns the number of content entities referencing the given block name:

.. code-block:: html+jinja

    {% content_count("main") %}

custom_field
------------

You can add custom fields as defined in the *admin interface* as follows:

.. code-block:: html+jinja

    <h1>{{ custom_field('your_field_token') }}</h1>
