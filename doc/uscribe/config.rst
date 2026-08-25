Book Configuration
==================

Book-wide settings live in ``book.conf``. Chapter order lives in
``book.manifest``. Per-chapter author, date, and copyright live in
the RST field list (see :doc:`markup`). Build invocation
(``--format``, ``--targetDir``) stays on the command line.

How the file is found
---------------------

1. ``--config=FILE`` if you pass it (the file must exist).
2. Otherwise ``book.conf`` in the same directory as the manifest.
3. If that file is missing, uscribe continues with CLI values and
   built-in defaults.

With the usual defaults (``book.manifest`` in the current
directory), a book directory only needs:

.. code-block:: sh

   uscribe --targetDir=./out

File format
-----------

One ``key: value`` per line. Keys are case-insensitive. Blank lines
and ``#`` comments are ignored. A leading colon on the key is
allowed (``:title:``), so the file can look like an RST field list
if you prefer.

Unknown keys print a warning on standard error and are ignored.
Values do not wrap to the next line.

``logo`` and ``themePath`` are paths. Relative paths are resolved
against the directory that contains ``book.conf``, not against the
process current working directory. Absolute paths are left as-is.

Command-line options override the file. The Makefile for this guide
passes ``--theme`` so ``make classic`` can change the initial skin
without editing ``book.conf``.

title
-----

Book title: HTML ``<title>``, sidebar heading, index heading, and
the LaTeX ``\\title`` / title page. Default if unset: ``Untitled
Book``. CLI: ``--title``.

copyright
---------

Book-wide footer text after © on HTML pages (for example
``2026, Jafar Al-Gharaibeh``). This is not a chapter byline; a
chapter ``:copyright:`` field is separate (see :doc:`markup`).
CLI: ``--copyright``.

logo
----

Image file. HTML copies it to ``targetDir/_static/`` and shows it
in the sidebar. LaTeX / PDF copies it next to the ``.tex`` and
places it on the title page (page 1), not as a numbered figure.
CLI: ``--logo``.

name
----

Basename for the book ``.tex`` / ``.pdf`` (and the HTML footer
**pdf** link). A trailing ``.pdf`` or ``.tex`` is stripped.
Letters, digits, ``_``, and ``-`` only. Default: ``book``.
Ignored for report collections (one PDF per report, named like
the HTML stem). CLI: ``--name``.

theme
-----

Initial HTML theme: ``basic``, ``classic``, or ``dark`` (or a
custom name under ``themePath``). Default: ``basic``. Readers can
still switch skins in the sidebar. Ignored for LaTeX / PDF.
CLI: ``--theme``.

themePath
---------

Directory that contains theme subdirectories
(``DIR/basic/static``, …). Also accepted as ``themepath`` or
``theme_path``. If omitted, uscribe searches ``./themes``,
``../themes``, and ``themes``. CLI: ``--themePath``.

docclass
--------

``book`` (default) or ``report``. Report mode is usually selected
per chapter with ``:docclass: report`` or ``:trnumber:``; this
key forces the class for every chapter. Also accepted as
``doc_class`` or ``doc-class``. CLI: ``--docclass``.

A report is one HTML page and one PDF. The sidebar on that page is
the report's sections. ``index.html`` is a catalog of links.
Workflow and live examples: :doc:`reports`.

frontmatter
-----------

How many leading chapters are unnumbered front matter (a preface
before chapter 1). Default ``0``. When set, the HTML sidebar numbers
sections as ``1.1``, ``2.3.1``, … matching the Word outline, and the
PDF uses ``\\frontmatter`` for those chapters, then the table of
contents, then ``\\mainmatter``.

toctree
-------

Sidebar tree lines (vertical spine and ticks) on the current
chapter's section list. Default off: numbers and indentation
only. Set ``toctree: true`` (also ``yes`` / ``on`` / ``1``;
aliases ``toc-tree``, ``toc_tree``) to draw the lines.

Not in book.conf
----------------

These stay on the command line because they describe one *build*,
not the book:

- ``--format`` — ``html``, ``latex``, or ``pdf``
- ``--targetDir`` — output directory (default ``./htmlBook`` or
  ``./latexBook``)
- ``--manifest`` — chapter list (default ``book.manifest``)

This guide
----------

The file that builds this manual:

.. literalinclude:: book.conf

   :language: text

Chapter order is ``book.manifest`` in the same directory.
