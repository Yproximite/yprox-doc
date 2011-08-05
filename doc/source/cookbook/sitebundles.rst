Site bundles .. how to do everything
************************************

Create the new bundle on GITHub
===============================

Go to github and create the bundle for example `VotreInstitutSiteBundle`.

Exporting a site to a site bundle
=================================

To export a production site
---------------------------

.. note::
    
    If you creating a new bundle you will need to create the bundle first on the 
    staging server. See the "Creating a new bundle and adding it to GIT section"

.. note::
    
    If you have created the bundle already you will need to clone the bundle, see
    "Adding a site bundle manually"

Login the the staging server::

    ssh me@dev.yproximite.fr -p65022

`sudo` to the root user::

    sudo -i 

`su` to the `yproxbuild` user::

    su yproxbuild

`cd` to the the home directory::

    cd

Syncronize the production system to staging::

    ./syncstaging.sh

Now `cd` to the staging `yProx` directory::

    cd /var/www/p/YProx/current

Export the site
---------------

To export a site to a site bundle and so export all templates, images and database entries::

    php apps/admin/console yprox:site:export fleuriste FleuristeSiteBundle

Where *fleuriste* is the `_importRef` of the site and *FleuristeSiteBundle* is the name of the bundle
to export the data to.

Export the site and rename the templates
----------------------------------------

You have a problem. **There are no templates in the exported bundle**.

If you are exporting a site that was duplicated from another site. The template names will still reference
the original site. The exporter **will not overwrite templates belonging to another bundle**.

To export the duplicated templates it is necessary to use the `--rewrite-template-bundle` options as follows::

    php apps/admin/console yprox:site:export fleuriste FleuristeSiteBundle --rewrite-template-bundle=??

If you do not know what to write as the argument for `--rewrite-template-bundle` then run the command without this option
and pay attention to the output near the top which may read something like::

    Not writing template "BienEtreSiteBundle::layoutBienEtre2.html.twig" to foreign Bundle "BienEtreSiteBundle".

So in this case it is **BienEtreSiteBundle** which needs to be added but you can ignore any references to **CmsBundle**.

Creating a new bundle and adding a bundle to git
================================================

Both of these operations can be accomplished using the following command::

    $php apps/admin/console yprox:site:init MyNewBundle

    Build Targets
    -------------

    main
      create Create bundle and add initalize git repo
    other
      update 
      createBundle Create the site bundle
      initGit Initialize a git repository on dev.yproximite.fr
    misc
      listTargets List build targets

So, to create a bundle and iommediately create a new git repository and push it to the dev server::

    $php apps/admin/console yprox:site:init MyNewBundle create

Or to add an existing bundle to git::

    $php apps/admin/console yprox:site:init MyNewBundle initGit

Manually Adding a Site Bundle
=============================

`cd` to the site bundle directory::

    cd src/yProxSite

Clone the site bundle from GITHub::

    git clone git@github.com:ylly/MySiteBundle.git

Now enable the bundle in `config/site_bundles.ini`::

    [MySiteBundle]
        git=git@github.com:ylly/MySiteBundle
        version=master

Updating a bundle
=================

To *push all changes* in a bundle to git::

    $php apps/admin/console yprox:site:init MyNewBundle update

Importing a site
================

To import a site::

    php apps/admin/console yprox:site:import-new FleuristeSiteBundle

.. note:: 

    This is really only applicable in a development environment and will rarely, if ever, be
    used on production.

