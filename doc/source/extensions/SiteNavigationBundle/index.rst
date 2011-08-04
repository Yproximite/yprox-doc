Site Navigation
***************

The site navigation takes the *NavigationBundle* and integrates it
into the CMS. It provides inheritable navigation trees (all or nothing)
and allows multiple trees to be defined per site.

The Process
===========

This module uses the standard `NavigationNode` tree
system from the *NavigationBundle*.

The Trees are defined in the admin panel -- using the *JSTree* *JQuery* plugin,
the server then converts the JSTree (JSON) tree to a navigation class structure
(`NavigationNode`) and then the navigation node is serialized into the database,
using the native PHP `serialize` function.

The Navigation Tree is then available to be unserialized and utilized when required,
additional page metadata will then be **graphed** on to the `NavigationNode` (for example
route_ids).

Why this method is good
-----------------------

- Its quick
- It reuses the existing **NavigationBundle** system.

Why it might be bad
-------------------

- Impossible to query serialized object from MySQL.
- Navigation nodes couple themselves to pages based on PageId, i.e. we have no referential integrity.

Other alternatives
------------------

We could create a nested set structure to define the Navigation heirarchy, this has the benefit
of being fully open to MySQL queries, and also opening the possibility of fine grained data inheritance,
but at the cost of an increased database load in both cases.

The Dumper Classes
==================

To facilitate the transformation to and from the *JSTree* data format we use the
`JTreeJsonDumper` and `JTreeJsonUndumper` classes.

The first accepts a `NavigationNode` tree, the second a raw JSON string.
