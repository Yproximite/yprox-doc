Configuration Reference
***********************

Example:

.. code-block:: yaml

    cms:
        site: 
            # which site selectors to use
            selectors: [ host, host_config, session ]

            # default host to use when host_config selector is used
            default_site_host: plombier.localhost 
