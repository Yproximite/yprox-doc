Translation Integration
***********************

This document covers the I18N (internationalization / translation) integration
for *yProximite*.

* *Back Office Translation* - Translation of the admin interface
* *Frontend Translation* - e.g. static fields such as EMAIL, FAX or CLICK_HERE)
* *Content Translation* - Translation of dynamic content

Back Office and Frontend Static Translation
===========================================

All of the translation for the back office is handled statically by Symfony
using the translation helpers.

Translation Files
-----------------

All of the translation files are located in::

    src/YllyTranslationBundle/Resources/translations

and are named as follows::

    admin.fr.php

Where *admin* is the translation **domain** and **fr** is the *locale*.

Translating fields
------------------

To make a translation in the twig template use a translation key e.g.::

    {% trans("TRANSLATE_THIS" from "admin" %}

If the translation *locale* is set to "fr" then symfony will look for a translation in::

    admin.fr.php

The contents of the translation file looks as follows::

.. code-block:: php

    <?php
    return array(
        'TRANSLATE_THIS' => 'Tranduit ceci',
    );

Back office translation
-----------------------

Use the *admin* domain when translating the backoffice

Frontend translation
--------------------

Use the *site* domain when translation the frontend.



Entity field translation
========================

How to
------

1. Implement TranslatableInterface

.. code-block:: php

    <?php

    // DO NOT COPY AND PASTE!
    namespace Example/Foo;
    use Ylly\YllyTranslationBundle\Entity\TranslatableInterface

    class Foo implements TranslatableInterface
    {
        protected $field1;
        protected $field2;
    }

2. Add translatable annotations on fields to translate

.. code-block:: php

    <?php

    /**
     * @gedmo:Translatable
     */
    protected $field1;

    /**
     * @gedmo:Translatable
     */
    protected $field2;

3. Add locale field and getters setters.

.. code-block:: php

    <?php

    /**
     * @gedmo:Locale
     */  
    protected $translationLocale;

    public function setTranslationLocale($translationLocale)
    {
        $this->translationLocale = $translationLocale;
    }

    public function getTranslationLocale()
    {
        return $this->translationLocale;
    }
/*

.. note::

    The locale field is not a mapped field. You do not need to persist it in the database.
    But you DO need to define it and add the *annotation*.

CMS Integration
===============

Language Selector Content
-------------------------

The extension `YllyTranslationExtBundle` provides a new content type "Language Selector"
which can be placed on a site and used to change the current locale.

Placing the locale in the route
-------------------------------

To change the locale you add the parameter `_locale` to the url::

    http://yprox.localhost/accueil?_locale=de

To make this parameter part of the url you can place the `_locale` parameter
in the route as defined in the *page* entity, the route can then be as follows::

    /{_locale}/accueil

The `{_locale}` parameter will automatically be replaced with the current locale.
