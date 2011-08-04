Site Selection and Routing
==========================

When a site is accessed we hijack the request and from it determine which
site we want to show. This can be achieved using different `SiteSelector`'s,
for example `HostSelector` which selects based on the incoming *vhost*, or
for development there is a `HostConfigSelector` which selects based on the
value configured in the site `config.yml`.

Cache Warming 
-------------

By default *Symfony 2* will pre-load the routing with the `kernel.cache_warmer`
feature either offline or on a fresh build of the *Dependency Injection Container*
when this event is called we do not know which site we want to create, and so
which routing we want to **warm up**, so for now we use a custom router warmer,
`Ylly\CmsBundle\Site\CacheWarmer\SiteRouterCacheWarmer` which does ... nothing.

.. note::
    
    In the future we could probably use the cache warmer to warm up ALL the
    routes offline. This would be a good optimization step to speed up
    first accesses, and probably would not be executeed in the PROD environemt
    and the overhead in DEV would be minimal, so maybe it should be implemented.
