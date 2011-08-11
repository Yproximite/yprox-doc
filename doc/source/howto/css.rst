Backoffice CSS
**************

Forms
=====

Forms are contained in `<table>` elements as follows.

.. code-block:: html

    <table class="form">
        <!-- form table rows !-->
    </table>

Using the **twig** helpers a form may look as follows.

.. code-block:: html+jinja

    <table class="form">
        {{ form_field(foobarForm) }}
    </table>

Lists
=====

Tables which list things should have the class "list" and should use the `<thead>` and `<tbody>` elements, and optionally `<tfoot>`.

`<th>`'s should be used for the headers.

.. code-block:: html

    <table class="list">
        <thead>
            <tr>
                <th>Column 1</th>
                <th>Column 2</th>
                <th colspan="2">Columns 3 and 4</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>Data for column 1</td>
                <td>Data for column 2</td>
                <td>Data for column 3</td>
                <td>Data for column 4</td>
            </tr>
        </tbody>
    </table>

Displaying Properties
=====================

A table of properties, e.g. read-only field and value pairs, should be placed within a `<table>` with the `properties` class.

.. code-block:: html

    <table class="properties">
        <tr>
            <th>Field</th>
            <td>Value</td>
        </tr>
    </table>

Optionally you can make the fields **larger** using the `large` class on the `<tr>` element.

.. code-block:: html

    <table class="properties">
        <tr class="large">
            <th>Field</th>
            <td>Value</td>
        </tr>
    </table>


Notes
=====

To show a note, or a "tip" use the `note` class.

.. code-block:: html

    <div class="note">
        You can do something if you want to.
    </div>

