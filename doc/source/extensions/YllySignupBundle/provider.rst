Signup Providers
****************

Each bundle can register a *provider* class which permits complete customization
of the signup process. This is accomplished by providing the ability to override:

- Form
- Process
- Registration Request

and 

- Registration and success templates.


The `YllySignupBundle` provides basic deault classes as follow:

- `Ylly\YllySignupBundle\Provider\BasicProvider` (provides the basic classes below)
- `Ylly\YllySignupBundle\Form\BasicRegistrationForm` (form object) 
- `Ylly\YllySignupBundle\Form\BasicRegistrationRequest` (request object)
- `Ylly\YllySignupBundle\CommandProcessor\SignupProcess` (signup process)

In general when extending the signup process for a specific platform (e.g. BienEtre) you
will want to extend the above classes rather than creating new ones.

The Provider Class
==================

To customize the signup process you need first to create a custom provider class
for the platform.

A basic provider class might look as follows:

.. code-block:: php

    <?php

    namespace Ylly\<MyPlatform>Bundle\Provider;
    use Ylly\YllySignupBundle\Provider\BasicProvider;

    class Provider extends BasicProvider
    {
        // This should return a key which corresponds to the 
        // import-ref of the base site of the platform (e.g. bienetre)
        public function getKey()
        {
            return '<your-platform-here>';
        }

        // return the sf2 form object
        public function getForm()
        {
            $form = parent::getForm();
            return $form;
        }

        // return the signup process (the signup
        // process is the thing that creates the
        // new account)
        public function getProcess($data)
        {
            $process = parent::getProcess($data);
            return $process;
        }

        // return a new registration request, this
        // is the data object used to store the
        // signup data.
        public function getRegistrationRequest()
        {
            $request = parent::getRegistrationRequest();
            return $request;
        }

        // return the template resource used when
        // displaying the registration form to the user.
        public function getRegistrationTemplateResource()
        {
            return 'YllySignupBundle:Site:index.html.twig';
        }

        // return the remplate resource used when the
        // registration is a success.
        public function getRegistrationSuccessTemplateResource()
        {
            return 'YllySignupBundle:Site:ok.html.twig';
        }
    }


Registring the provider
=======================

The *provider* class can be registered in a number of ways using Symfony2, but the most simple way
to register is by using the `boot` method of the **platform** bundle as follows:

.. code-block:: php

    <?php
    class PlombierSiteBundle extends Bundle
    {
        public function boot()
        {
            $this->registerSignupProvider();
        }

        protected function registerSignupProvider()
        {
            $this->container->get('yprox.signup.provider_manager')->add(new Provider($this->container));
        }
    }

Note that the `Provider` class must be passed an instance of the project *container*.
