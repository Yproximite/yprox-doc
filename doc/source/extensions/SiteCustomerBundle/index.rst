Site Customer Bundle
********************

The site customer bundle provides a user system for the *site* application
which independent from the user system used for the *back office*.

Service Manager
===============

It is possible to register *service* at runtime. A *service* might be *Pense-bête*,
*Newsletter* or anything else which might be related a users account.

At the moment we simply register a *label* and a *route*, optoinally also a *priority*.

.. code-block:: php
    <?php
    class SiteCustomerBundle extends Bundle
    {
        public function boot()
        {
            $this->container->get('yprox.site.customer.service_manager')->addServiceItem(
                'Modifier mon profile',
                'customer_profile_edit',
                0
            );
        }
    }
