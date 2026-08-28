Quick Start
===========

A uscribe project is a directory of chapter ``.rst`` files, a
manifest that lists them in reading order, and usually a
``book.conf`` for book-wide title, logo, and PDF name.

1. Create a manifest
--------------------

``book.manifest`` (name is conventional; any path works):

.. code-block:: text

   # comments and blank lines are ignored
   preface.rst
   chapter1.rst
   chapter2.rst

2. Write chapters
-----------------

Underline-style headings, paragraphs, lists, and directives. Example
``chapter1.rst``:

.. code-block:: rst

   First Chapter
   =============

   Hello from uscribe. See :ref:`Second Chapter` later.

   Second Section
   --------------

   - alpha
   - beta

   .. note::

      Indented body of a note.

   .. code-block:: unicon

      procedure main()
         write("hi")
      end

**Underline rule:** the underline must be at least as long as the
title. Shorter underlines are not treated as headings.

Here is that Unicon listing as it appears when built (syntax
highlighted in HTML):

.. code-block:: unicon

   procedure main()
      write("hi")
   end

3. Book settings
----------------

``book.conf`` next to the manifest (optional; CLI overrides).
Full key list: :doc:`config`.

.. code-block:: text

   title: My Book
   copyright: 2026, Your Name
   logo: images/logo.png
   name: my-book
   theme: basic

4. Build HTML
-------------

.. code-block:: sh

   uscribe --targetDir=./out

Or from a project ``Makefile`` patterned on ``doc/uscribe/Makefile``.

Open ``out/index.html``. Use the sidebar for chapters (and the
current chapter's sections), search, and theme switching.

5. Build PDF (optional)
-----------------------

Install a TeX engine first — see the *TeX / PDF dependencies by
platform* section under :ref:`Installation`. Then:

.. code-block:: sh

   uscribe --format=pdf --targetDir=./out

Or ``make pdf``. Output is ``out/STEM.pdf`` from the ``name`` key
(default stem ``book``). This user guide uses ``name: uscribe-userguide``.
SVG figures are not embedded; convert them to PDF or PNG for TeX.

Where files go
--------------

- ``*.rst`` — chapter sources
- ``*.manifest`` — chapter order
- ``book.conf`` — book title, logo, copyright, PDF name, theme
- ``images/`` — figures (copied into ``out/images/``)
- ``out/`` — generated HTML and/or ``STEM.tex`` / ``STEM.pdf``
- ``themes/`` — built-in skins shared across projects (HTML)

A report (one paper) or a catalog of reports uses the same tools
with a different manifest. See :doc:`reports`.
