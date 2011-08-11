Sending Emails
**************

In *yProx* emails are sent using the `yprox.mailer` service.

This service dispatches emails and stores each email in the `email_message` table. An interface to this data exists in the site backoffice.

Send with one line of code
==========================

The `yprox.mailer` implements a fluid interface:

.. code-block:: php

    <?php

    $this->get('yprox.mailer')
        ->createMessage() // createMessage returns an instance of EmailMessage
            ->setSubject('My Subject')
            ->setTo('daniel@example.com')
            ->setBody('This is the content of the email')
            ->setFrom(array("noreply@example.com" => "No Reply at Example dot com"))
            ->done() // EmailMessage::done() returns the manager again.
        ->dispatch();

Resend a previously sent email
==============================

.. code-block:: php

    <?php
    $email = $this->getEmail(); // return an instance of Ylly\CmsBundle\Entity\EmailMessage from the database.
    $this->get('yprox.mailer')->addMessage($email)->dispatch();
