Registration
************

Site registration is primarily accomplished using the web controller `@SignupBundle:Site` but
can alternatively be accomplished using the command line.

Web Registration
================

Command Line Registration
=========================

Command line registration is ideal for creating test sites::

    $./admincon help yprox:site:signup
    Usage:
     yprox:site:signup [--domain="..."] [--title="..."] [--opening-hours="..."] [--first-name="..."] [--last-name="..."] [--address="..."] [--postal-code="..."] [--town="..."] [--tel="..."] [--password="..."] [--email="..."] [--themeId="..."]

    Options:
     --domain Domain name
     --title Site title
     --opening-hours Opening hours
     --first-name Client first name
     --last-name Client last name
     --address Address
     --postal-code Postal code
     --town town
     --tel tel
     --password password
     --email email
     --themeId Theme ID


