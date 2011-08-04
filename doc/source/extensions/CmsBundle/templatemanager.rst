Admin Template Manager
======================

The admin template manager provides a way for bundles to provide custom templates
when they want to.

For example the ``PlombierSiteBundle`` will provide a custom login template when
the host is ``admin.plombierweb.fr``.

Registration
------------

To register a template provider callback use the template manager service as follows::

    // example from PlombierSiteBundle
    $templateManager = $container->get('yprox.admin.template_manager');
    $templateManager->registerListener('login', function ($event) use ($container) {
        $request = $container->get('request');
        if ($request->getHttpHost() == 'admin.plombierweb.fr') {
            $event->setProcessed();
            return 'PlombierSiteBundle:Security:login.html.twig';
        }
    });

Note that the second argument of ``registerListener`` is a ``Closure`` but
can be any valid php callback.

Requesting a template
---------------------

To request a template in ``Twig``:

.. code-block:: html+jinja

    {% set template = template_manager.get('key', 'YourDefaultBundle:Default:foo.html.twig') %}

As you can see, the ``template_manager`` service is registered as a global. The first argument
of ``get`` is a unique key, the second is a default template to use if nobody accepts the request.
