Introduction
============

*uscribe* is a prose/book documentation generator for Unicon. It reads
a small RST-like markup, builds a doctree, resolves cross-chapter
references, and writes themed HTML (and optionally LaTeX/PDF) for
Unicon documentation and books.

This manual is the user guide for uscribe itself. Sources live under
``doc/uscribe/`` in the unicon tree and are built *with* uscribe.

What uscribe is for
---------------------

- Multi-chapter books and manuals (ordered by a manifest file)
- HTML output with sidebar navigation, search, and selectable themes
- Unicon code samples with syntax highlighting
- Images and simple admonitions

It is **not** a full RST/docutils toolchain. The markup subset is
intentionally small; extend the parser as real documents need more.

A taste of Unicon highlighting
------------------------------

Mark listings with ``.. code-block:: unicon`` (also ``icon`` or
``icn``). In HTML they are highlighted client-side:

.. code-block:: unicon

   procedure greet(who)
      write("Hello, ", \who | "world", "!")
   end

   procedure main()
      greet("uscribe")
      greet()
   end

See :ref:`Markup Reference` for the full dialect and
:ref:`Quick Start` to generate a tiny book.

Relation to unidoc
------------------

`uni/unidoc/` extracts API docs from Unicon source comments.
*uscribe* is a separate tool for authored prose. They can coexist; a
future ``.. api::`` bridge may connect them.

How to read this guide
----------------------

- :doc:`install` — build and install the ``uscribe`` binary
- :doc:`quickstart` — generate HTML from a tiny book
- :doc:`config` — ``book.conf`` keys, defaults, and CLI overrides
- :doc:`markup` — headings, lists, inline markup, directives
- :doc:`themes` — basic, classic, dark, and the in-page switcher
- :doc:`cli` — CLI options
