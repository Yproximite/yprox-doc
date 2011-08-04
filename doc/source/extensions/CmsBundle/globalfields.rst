Global Fields
*************

The platorm provides an easy way to register fields which are made globally
available within the application for use, for example, in templates, emails and articles.

Global Field Manager
====================

The ``GlobalFieldManager`` service is available both in the ``site`` and ``admin`` applications.

It provides access to registered fields and on the first access issues an event which calls
listeners to register fields. So for example the ``LocationBundle`` listens to this event
and when recieved it registers various location fields such as *address* and *opening hours*.

The event is registered in ``boot()`` method of the ``LocationBundle`` (although it is probably
better registered in a compiler pass):

.. code-block:: php

    <?php
    class LocationBundle extends Bundle 
    {
        public function boot()
        {
            $this->container->get('event_dispatcher')->connect('yprox.register_global_fields', array($this, 'registerCustomFields'));
        }	
    }

and registers its custom fields by using the specified callback, using the following api:

.. code-block:: php

    <?php
    // 1. event is the event object passed to the listening method...
    $fc = $event->getSubject(); // $fc is an instance of the service

    // 2. third parameter is optional and contains value
    $field1 = $fc->createField('site-title', 'Titre du site', 'Some value');

    // 3. createField adds the field to the container and returns an instance
    $field2 = $fc->createField('telephone', 'Votre numero de telephone');

    if ($location = $em->getRepository('Ylly\Extension\LocationBundle\Entity\Location')->findOneBy(array())) {
        // 4. which enables us to set a value later on ..

        $field1->setValue($location->deepGet('title')->getValue());
        $field2->setValue($location->deepGet('tel')->getValue());
    }

Accessing fields
================

Fields can be accessed directly from the service:

.. code-block:: php

    <?php
    $foobar = $container->get('yprox.global_field_manager')->getField('foobar');
    $fields = $container->get('yprox.global_field_manager')->getFields();

or from within *twig* templates (only on the frontend site):

.. code-block:: html+jinja

    {# individual field ... #}
    {{ custom_field('foobar') }}

    {# direct access to GlobalFieldManager #}
    {% global_field_manager.getFields() %}
