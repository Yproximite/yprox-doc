Extend Disciminator Event
=========================

The Problem
-----------

There is a problem in the Doctrine architecture when we want to extend an Entity
such as `Content`, using *Single* or *Class table* inheritance, from a decoupled 
package, for example, `TeamBundle`, which provides specialized `TeamContent` which 
extends from `Content`.

The problem is that for the *class inheritance* to work the *DiscriminatorMap* field
must explicitly set which child classes extend it, and infact, we do not know what
these are. Because the only way for this to work conventionally is to manually edit
this code everytime we add an extension to **yProximitie**.

The Ugly Solution
-----------------

We can utilize the *loadMetadata* event provided by **Doctrine** to dynamically set
the *DiscriminatorMap* at runtime, to do this we need to regsiter the event listener
in the `CmsBundle` and then we need to register the discriminator maps in the extending
bundles using the `ExtendDiscriminatorManager`. 

.. note::

    The ExtendDiscriminatorManager does not sit easily in a Symfony 2 project as it
    is a static class and blindly couples the Bundle to the Model. But at time of writing
    this is the only way I can see to provide this feature.

Implementing Dynamic Inheritance
--------------------------------

To extend a base class dynamically it is necessary to register your intentions in your
*Bundle*'s `::boot` method::

    // .. My Bundle
    public function boot()
    {
        ExtendDiscriminatorMapManager::register(
            'Ylly\CmsBundle\Tests\Doctrine\EDParentTestEntity',    // The class we want to extend
            'test_entity1',                                         // The discriminator key (e.g. "team", "article")
            'Ylly\CmsBundle\Tests\Doctrine\EDTestEntity');         // The child class
    }
