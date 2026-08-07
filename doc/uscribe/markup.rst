Markup Reference
================

uscribe accepts a **restricted RST-like** dialect. Unknown constructs
are either ignored, treated as plain text, or left as raw directives.

Headings
--------

.. code-block:: rst

   Chapter Title
   =============

   Section
   -------

   Subsection
   ~~~~~~~~~~

Characters ``= - ~ ^`` are recognized as underline styles. Heading
level follows the underline character. The underline length must be
greater than or equal to the title length.

Paragraphs and lists
--------------------

Blank lines separate paragraphs. Bullet lists use ``-`` or ``*`` with
a following space. Numbered lists use ``1. `` / ``1) `` or auto-number
``#. ``. Indented continuation lines belong to the current item.

1. Install the ``uscribe`` binary (:doc:`install`)
2. Write a tiny book (:doc:`quickstart`)
#. Pick a theme (:doc:`themes`)

Definition lists
----------------

A term on its own line followed by an indented body:

option
   A command-line flag or value (see :doc:`cli`).

theme
   An HTML skin selected with ``--theme`` (see :doc:`themes`).

Tables
------

Simple RST tables use ``=`` column separators. The first row is the
header:

=====  ==========
Flag   Meaning
=====  ==========
html   HTML book
latex  ``book.tex``
pdf    run a TeX engine
=====  ==========

Inline markup
-------------

- single asterisks for emphasis
- double asterisks for strong
- backticks for inline literals
- a ref role pointing at a section title (same text as the heading)
- a doc role naming a chapter stem (``:doc:`install``` → ``install.rst``)

For cross-chapter links, write a ref role whose label matches the
target heading exactly, or a doc role with the chapter file stem (see
the guide TOC in :doc:`intro`).

Directives
----------

Recognized forms (authoring markup):

.. code-block:: rst

   .. note::

      Body lines, indented.

   .. warning::

      Careful.

   .. tip::

      Hint.

   .. important::

      Also: caution, attention, danger, error, hint.

   .. code-block:: unicon

      # source lines, indented
      procedure main()
         write("ok")
      end

   .. image:: images/diagram.svg

      Optional alt text on an indented line

   .. figure:: images/diagram.svg

      Same as image (alias).

Unicon listings
---------------

``code-block`` languages ``unicon``, ``icon``, and ``icn`` get Unicon
syntax highlighting in HTML (via ``highlight-unicon.js``). Other
languages are emitted as plain
``<pre><code class="language-…">`` without Unicon highlighting —
use ``sh`` for shell, ``rst`` or ``text`` for markup samples.

Example Unicon program as it appears in the built book:

.. code-block:: unicon

   # Hello from a uscribe listing
   procedure main()
      every i := 1 to 3 do
         write("tick ", i)
      write(&version)
   end

A line ending in ``::`` (RST literal-block introducer) followed by an
indented block is also treated as a code listing. ``Unicon::`` becomes
the label ``Unicon:`` plus the indented tree; a lone ``::`` introduces
a block with no label.

Unknown ``.. name::`` directives become HTML comments so content is
not silently dropped.

Cross-references
----------------

Pass 1 collects every section title (slugified) across all chapters.
Pass 2 turns pending ref roles into links of the form
``chapter.html#anchor``. Prefer unique section titles.

See also :doc:`quickstart` and :doc:`cli`.
