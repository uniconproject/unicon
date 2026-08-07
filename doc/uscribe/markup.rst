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
a following space. Indented continuation lines belong to the current
item.

Inline markup
-------------

- single asterisks for emphasis
- double asterisks for strong
- backticks for inline literals
- a ref role pointing at a section title (same text as the heading)
- a doc role is parsed; full resolution is still limited

For cross-chapter links, write a ref role whose label matches the
target heading exactly (see the links in :ref:`Introduction`).

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

   .. code-block:: unicon

      # source lines, indented
      procedure main()
         write("ok")
      end

   .. image:: images/diagram.svg

      Optional alt text on an indented line

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

See also :ref:`Quick Start` and :ref:`Command Line`.
