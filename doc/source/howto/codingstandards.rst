Coding Standards
****************

Coding standards should not be underestimated and when followed will greatly enhance the productivity
of the team as it demands **less effort** from the developers to comprehend the code.

By maintaining coding standards you also maintain the professionalism of the code, by letting standards
slip it becomes easier for everyone to produce sub-standard work.

Same as Symfony 2
=================

The coding standards for **yProx** are exactly the same as the `coding standards for Symfony2`_.

.. _coding standards for Symfony2: http://symfony.com/doc/2.0/contributing/code/standards.html

Some extra things to remember
=============================

- **NO TABS!!** and always **4 SPACES**
- Do not add extra spaces
- Never leave commented code in the code -- use GIT to revert to previous changes
- Keep everything tidy
- Comments should be **meaningfull**.
- When rendering a long line with array elements, break the array onto separate lines as follows:

.. code-block:: php

    <?php
    return $this->render($this->generateUrl('my_route', array(
        'site_id' => $site->getId(),
        'form' => $form,
        'foobar1' => $foobar1,
        'foobar2' => $foobar2,
        'foobar3' => $foobar3,
    )));

and not:

.. code-block:: php
    
    <?php
    return $this->render($this->generateUrl('my_route',array('site_id'=>$site->getId(),'form'=>$form,'foobar1'=> $foobar1,'foobar2'=>$foobar2,'foobar3'=>$foobar3)));
