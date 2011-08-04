Documentation
*************

Install Sphinx
==============

All the documentation is in the *Restructured Text* format and facilitated by python *Sphinx*.

Install the necessary tools as follows::

    apt-get install python-docutils

Adding a document to the table of contents
==========================================

For a new page to appear in the table of contents and to be built by *Sphinx* you need to modify `index.rst`.

First add a new page::

    vim doc/source/mynewpage.rst

With the following contents::

    Hello World
    ===========

Save the document and modify `index.rst.template` by adding your new file::

     .. yProx documentation master file, created by
    sphinx-quickstart on Sun Dec 26 13:34:06 2010.
    You can adapt this file completely to your liking, but it should at least
    contain the root `toctree` directive.

    Welcome to yProx's documentation!
    =================================

    Contents:

    .. toctree::
       :maxdepth: 2
       :numbered:

       introduction
       maintainance
       terms
       testing
       mynewpage
    %YLLY_INDEX%

    Indices and tables
    ==================

    * :ref:`genindex`
    * :ref:`modindex`
    * :ref:`search`

.. note::

    Do not modify the `index.rst` file directly, as we generate this file based on the template above. This
    is necessary to enable us to include the documentation for all the extensions.

Building the documentation
==========================

Link the extension documentation
--------------------------------

The documentation for extensions, extensions being for example, *ArticleBundle*, *CmsBundle*, etc, and located
in `Ylly\Extensions`, is kept in the *Extension* directory. For this documentation to be included you will need 
to run a script in the `doc` directory to link the documentation into the Table of Contents::

    cd doc
    sh buildindex.sh

Make the HTML, PDF or whatever
------------------------------

To build the *yProximite* documentation `cd` to the `doc` folder and execute the following command::

    make

This will list all the available options::

    Please use make <target>' where <target> is one of
      html       to make standalone HTML files
      dirhtml    to make HTML files named index.html in directories
      singlehtml to make a single large HTML file
      pickle     to make pickle files
      json       to make JSON files
      htmlhelp   to make HTML files and a HTML help project
      qthelp     to make HTML files and a qthelp project
      devhelp    to make HTML files and a Devhelp project
      epub       to make an epub
      latex      to make LaTeX files, you can set PAPER=a4 or PAPER=letter
      latexpdf   to make LaTeX files and run them through pdflatex
      text       to make text files
      man        to make manual pages
      changes    to make an overview of all changed/added/deprecated items
      linkcheck  to check all external links for integrity
      doctest    to run all doctests embedded in the documentation (if enabled)

So to build the html::

    make html

And to build a PDF::

    make latexpdf

The compiled documentation can then be found in the `build` folder.
