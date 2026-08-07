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

Source:

.. literalinclude:: includes/ex-lists.rst

   :language: rst

Rendered:

.. include:: includes/ex-lists.rst

Definition lists
----------------

A term on its own line followed by an indented body.

Source:

.. literalinclude:: includes/ex-deflist.rst

   :language: rst

Rendered:

.. include:: includes/ex-deflist.rst

Tables
------

Simple RST tables use ``=`` column separators. The first row is the
header.

Source:

.. literalinclude:: includes/ex-table.rst

   :language: rst

Rendered:

.. include:: includes/ex-table.rst

Inline markup
-------------

- single asterisks for *emphasis*
- double asterisks for **strong**
- backticks for ``inline literals``
- a ref role pointing at a section title (same text as the heading)
- a doc role naming a chapter stem (``:doc:`install``` → ``install.rst``)

For cross-chapter links, write a ref role whose label matches the
target heading exactly, or a doc role with the chapter file stem (see
the guide TOC in :doc:`intro`). Full chapter sources are also linked
from each HTML page footer as **Page source** (under ``_sources/``).

Directives
----------

Recognized forms. Admonitions — source then rendered:

.. literalinclude:: includes/ex-admonitions.rst

   :language: rst

.. include:: includes/ex-admonitions.rst

Also: ``tip``, ``important``, ``caution``, ``attention``,
``danger``, ``error``, ``hint``. Other authoring forms:

.. code-block:: rst

   .. code-block:: unicon

      # source lines, indented
      procedure main()
         write("ok")
      end

   .. image:: images/diagram.svg

      Optional alt text on an indented line

   .. figure:: images/diagram.svg

      Same as image (alias).

   .. include:: path/to/fragment.rst

   .. literalinclude:: path/to/file.icn

      :language: unicon
      :lines: 1-10
      :start-after: marker
      :end-before: marker
      :dedent: 3

Paths are resolved next to the including chapter, then under the
process cwd. Nested ``include`` is allowed; circular includes warn and
are skipped.

Include / literalinclude
------------------------

``literalinclude`` shows a file as a listing; ``include`` parses it as
markup. The tip below is the same fragment both ways.

Source (``includes/shared-tip.rst``):

.. literalinclude:: includes/shared-tip.rst

   :language: rst

Rendered:

.. include:: includes/shared-tip.rst

Pull a real ``.icn`` file as a listing. Language defaults from the
extension (``.icn`` → ``unicon``); override with ``:language:``:

.. literalinclude:: includes/hello.icn

   :language: unicon

The same file, only the body between markers:

.. literalinclude:: includes/hello.icn

   :start-after: procedure main()
   :end-before: end

Unicon listings
---------------

``code-block`` languages ``unicon``, ``icon``, and ``icn`` get Unicon
syntax highlighting in HTML (via ``highlight-unicon.js``). Other
languages are emitted as plain
``<pre><code class="language-…">`` without Unicon highlighting —
use ``sh`` for shell, ``rst`` or ``text`` for markup samples.
``literalinclude`` of ``.icn`` files uses the same highlighting.

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
