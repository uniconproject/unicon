Quick Start
===========

A uscribe project is a directory of chapter ``.rst`` files plus a
manifest that lists them in reading order.

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

3. Build HTML
-------------

.. code-block:: sh

   uscribe --manifest=book.manifest \
            --title="My Book" \
            --targetDir=./out \
            --theme=basic \
            --themePath=/path/to/uni/uscribe/themes

Or from a project ``Makefile`` patterned on ``doc/uscribe/Makefile``.

Open ``out/index.html``. Use the sidebar for chapters, search, and
theme switching.

4. Build PDF (optional)
-----------------------

Install a TeX engine first — see the *TeX / PDF dependencies by
platform* section under :ref:`Installation`. Then:

.. code-block:: sh

   uscribe --format=pdf --manifest=book.manifest \
            --title="My Book" --targetDir=./out

Or ``make pdf``. Output is ``out/book.pdf`` (and ``out/book.tex``).
SVG figures are not embedded; convert them to PDF or PNG for TeX.

Where files go
--------------

- ``*.rst`` — chapter sources
- ``*.manifest`` — manifest (chapter order)
- ``images/`` — figures (copied into ``out/images/``)
- ``out/`` — generated HTML and/or ``book.tex`` / ``book.pdf``
- ``themes/`` — built-in skins shared across projects (HTML)
