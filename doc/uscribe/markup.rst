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

Characters ``= - ~ ^ "`` are recognized as underline styles
(chapter through heading 5). Heading level follows the underline
character. The underline length must be greater than or equal to
the title length.

Document fields
---------------

A chapter may start with an RST field list (Docutils bibliographic
fields). Repeat ``:author:`` for several names. Book chapters show
these as a byline under the first heading; omit the fields and
nothing is added. Reports also use ``:title:``, ``:trnumber:``,
``:abstract:``, ``:keywords:``, and ``:docclass:`` for the cover — see :doc:`reports`
for the one-paper and catalog workflows.

.. code-block:: rst

   :author: Jane Doe
   :author: Pat Lee
   :date: 2026-08-15
   :copyright: 2026, Jane Doe

   Chapter Title
   =============

Book-wide title, logo, theme, and PDF name belong in
``book.conf`` (see :doc:`config`). They are not chapter fields.

Paragraphs and lists
--------------------

Blank lines separate paragraphs. Bullet lists use ``-`` or ``*`` with
a following space. Numbered lists use ``1. `` / ``1) `` or auto-number
``#. ``. Indented continuation lines belong to the current item.
Nested lists, ``.. note::``, and ``.. code-block::`` indented under an
item are parsed as that item's body (a blank line between items is
allowed).

Source:

.. literalinclude:: includes/ex-lists.rst

   :language: rst

Rendered:

.. include:: includes/ex-lists.rst

A list item can also hold a nested listing:

.. literalinclude:: includes/ex-nested-list.rst

   :language: rst

.. include:: includes/ex-nested-list.rst

Definition lists
----------------

A term on its own line followed by an indented body. Blank lines inside
the body start a new paragraph.

Source:

.. literalinclude:: includes/ex-deflist-multi.rst

   :language: rst

Rendered:

.. include:: includes/ex-deflist-multi.rst

Tables
------

**Simple** tables use ``=`` column separators. The first row is the
header. PDF output uses ``longtable`` with wrapping paragraph
columns so long identifiers and prose stay within the page.

Source:

.. literalinclude:: includes/ex-table.rst

   :language: rst

Rendered:

.. include:: includes/ex-table.rst

**Grid** tables use ``+---+`` borders; a border with ``=`` marks the
header. Omit an internal ``|`` to span columns:

Source:

.. literalinclude:: includes/ex-grid-span.rst

   :language: rst

Rendered:

.. include:: includes/ex-grid-span.rst

A plain grid without spans:

Source:

.. literalinclude:: includes/ex-grid-table.rst

   :language: rst

Rendered:

.. include:: includes/ex-grid-table.rst

**List tables** use the ``list-table`` directive. The optional
argument is the table caption (shown under the table in HTML, and
as a LaTeX caption). Word-style labels such as ``Figure 6: …`` are
kept as written:

Source:

.. literalinclude:: includes/ex-list-table.rst

   :language: rst

Rendered:

.. include:: includes/ex-list-table.rst

Labels and cross-references
---------------------------

Place ``.. _name:`` immediately before a heading, figure, or table.
Pass 1 collects explicit labels and title slugs; pass 2 turns ref
roles into ``chapter.html#anchor`` links.

Source:

.. literalinclude:: includes/ex-labels.rst

   :language: rst

Rendered:

.. include:: includes/ex-labels.rst

Live refs (explicit label and display-text form):

- plain: :ref:`stable-labels`
- with display text: :ref:`Jump here <stable-labels>`
- chapter: :doc:`install`

Title-only refs (matching a heading exactly) still work. Full chapter
sources are linked from each HTML footer as **source** (and **txt**
in the report index Formats column).

Inline markup
-------------

- single asterisks for *emphasis*
- double asterisks for **strong**
- backticks for ``inline literals``

Directives
----------

Admonition bodies are re-parsed as nested blocks (lists, code, nested
directives). Source then rendered:

.. literalinclude:: includes/ex-nested-note.rst

   :language: rst

.. include:: includes/ex-nested-note.rst

Also: ``warning``, ``tip``, ``important``, ``caution``, ``attention``,
``danger``, ``error``, ``hint``.

Figures take a caption. If the caption already starts with
``Figure N`` or ``Table N``, HTML and LaTeX keep that label instead
of adding another number. Uncaptioned ``.. image::`` is not numbered.

.. code-block:: rst

   .. _logo-figure:

   .. figure:: images/uscribe-logo.png

      :alt: uscribe logo

      The uscribe mark.

.. _logo-figure:

.. figure:: images/uscribe-logo.png

   :alt: uscribe logo

   The uscribe mark.

See :ref:`logo-figure`.

Other authoring forms (shown literally):

.. code-block:: rst

   .. code-block:: unicon

      procedure main()
         write("ok")
      end

   .. image:: images/diagram.svg

      Optional alt text

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
syntax highlighting in HTML (via ``highlight-unicon.js``).
``json`` is highlighted the same way (strings, numbers,
``true`` / ``false`` / ``null``, and ``//`` comments in JSONC
samples). Other languages are emitted as plain
``<pre><code class="language-…">`` without extra highlighting —
use ``sh`` for shell, ``rst`` or ``text`` for markup samples.
``literalinclude`` of ``.icn`` files uses the same Unicon highlighting.

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

See also :doc:`quickstart` and :doc:`cli`.
