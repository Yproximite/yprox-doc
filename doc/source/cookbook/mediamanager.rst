Design Recipies
***************

Add a site logo to a template
=============================

The media manager features a usefull feature which enables you to dynamically resize, crop,
rotate or otherwise transform any image specified by `Media` image in realtime.

This is usefull for (and infact was created for) displaying site *logos* in themes where the
space allocated for the logo may change.

So to add a scaled logo to a template..

1. Login to the CMS and access the *Theme integration* editor for the theme you need to add
   the logo to.

2. Add the following code in the place where you want the logo to appear::

.. code-block:: jinja

    <img src="{{ image_transform_url(site_manager.getSite.getLogo, 'Sh75') }}"/>

As you can see we add a standard `img` tag and we use the `image_transform_url` helper to
generate the URL which will generate the transformed image. This example will **scale** the
site logo (as gotten by the `site_manager` helper) to a **height** of **75 pixels**

.. function:: image_transform_url(Media $media, $transformCommand)

    Provides a URL which can transform the image based on the given *transform command*.

Transform Command
-----------------

The transform command enables you to apply any number of seqential transformations on the given
image.

Crop
~~~~

Command: `C`

=========== ================================
Parameters  Description
=========== ================================
x           Horizontal point to crop from
y           Vertical point to crop from
w           Width of crop from start
h           Height of crop
=========== ================================

Example::

    Cx0_y0_w100_h100

This will crop an image from the top left hand corner to a size of 100px x 100px.

Scale
~~~~~

Command: `S`

=========== ================================
Parameters  Description
=========== ================================
w           Target width 
h           Target height
=========== ================================

Example::
    
    Sw140_h200

This will resize the image exactly to 140px x 200px.

If you leave out either *height* or *width* the image will be scaled to the given
dimension and the aspect ratio will be maintained.

Example::

    Sw100

This will change the width to 100 and the height will be changed relative to the width.

Rotate
~~~~~~

Command: `R`

+-----------+--------------------------------+
|Parameters | Description                    |
+===========+================================+
| a         | Angle to rotate                |
+-----------+--------------------------------+

Example::

    Ra90

This will rotate the image by 90 degrees.

Chaining commands
-----------------

You can apply multiple transformations by separating the comands with a hypen `-`.

Example::

    Sh200-Cw50_h200-Ra45

This will **Scale** the image to a height of 200px then **Crop** the image to a width of 50px and
finally **Rotate** the image by 45 degrees.
