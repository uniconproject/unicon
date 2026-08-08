uscribe and Sphinx
====================

If you already know Sphinx, this chapter maps familiar ideas onto
uscribe. It is not a claim of compatibility.

Conceptual map
--------------

- **Sphinx ``toctree``** → uscribe **manifest** (``.manifest`` file
  listing chapter paths in order)
- **Sphinx ``conf.py`` / ``html_theme``** → ``--theme`` / ``--themePath``
  plus the in-page theme dropdown
- **Sphinx builders (html, latex, …)** → ``--format=html|latex|pdf``
  (``HtmlOutputter`` / ``LatexOutputter``); PDF runs a TeX engine on
  the generated ``book.tex``
- **Sphinx / Pygments highlighting** → client-side
  ``highlight-unicon.js`` for Unicon listings
- **Sphinx search** → ``searchindex.js`` + ``search.html`` (simple
  substring search, not Sphinx's stemmer index)
- **Sphinx domains / autodoc** → not present; use ``unidoc`` for API
  extraction from Unicon sources

Markup
------

uscribe understands a **subset** of RST: underline headings, bullets,
simple/grid/list tables, definition lists, ``include`` /
``literalinclude``, ``figure`` captions, explicit ``.. _label:``
targets, nested admonition bodies, and light inline markup (including
``:ref:`Text <label>```). It does not run docutils. Sphinx-only roles,
domains, and extensions will not work unchanged.

Project layout
--------------

Sphinx::

   docs/
     conf.py
     index.rst
     ...

uscribe::

   mybook/
     book.manifest
     intro.rst
     ...
     images/
     Makefile   # optional; see doc/uscribe/

This user guide is itself a uscribe project: the tool documents and
drives itself.
