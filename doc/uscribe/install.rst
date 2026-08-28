Installation
============

Requirements
------------

**Required**

- A built Unicon tree (``./configure && make`` from the unicon sources)

**Optional (PDF only)**

- A TeX engine on your ``PATH``: ``pdflatex``, ``xelatex``, or
  ``lualatex``. uscribe picks the first one it finds.
  HTML and ``--format=latex`` (``.tex`` only) do not need TeX.

There is no Homebrew or apt package literally named ``pdflatex``; that
name is a program shipped inside a TeX distribution. Install one of
the packages below, then confirm:

.. code-block:: sh

   which pdflatex || which xelatex || which lualatex

TeX / PDF dependencies by platform
----------------------------------

macOS (Homebrew)
~~~~~~~~~~~~~~~~

Compact (recommended for uscribe):

.. code-block:: sh

   brew install --cask basictex

Full MacTeX (much larger):

.. code-block:: sh

   brew install --cask mactex
   # or: brew install --cask mactex-no-gui

After BasicTeX or MacTeX, restart the terminal (or run
``eval "$(/usr/libexec/path_helper)"``) so the new binaries are on
``PATH``.

Debian / Ubuntu
~~~~~~~~~~~~~~~

Minimal (often enough):

.. code-block:: sh

   sudo apt update
   sudo apt install texlive-latex-base

Recommended if ``pdflatex`` complains about missing packages
(hyperref, fancyvrb, graphicx fonts, and similar):

.. code-block:: sh

   sudo apt install texlive-latex-recommended texlive-fonts-recommended

Larger kitchen-sink options:

.. code-block:: sh

   sudo apt install texlive-latex-extra
   # or everything: sudo apt install texlive-full

Fedora / RHEL-family
~~~~~~~~~~~~~~~~~~~~

.. code-block:: sh

   sudo dnf install texlive-latex
   # fuller: sudo dnf install texlive-scheme-medium
   # everything: sudo dnf install texlive-scheme-full

Arch Linux
~~~~~~~~~~

.. code-block:: sh

   sudo pacman -S texlive-basic texlive-latex
   # or a broader set: sudo pacman -S texlive-meta

Windows
~~~~~~~

Install either MiKTeX (https://miktex.org/download) — packages on
demand — or TeX Live for Windows (https://tug.org/texlive/).

Ensure the installer puts ``pdflatex`` on your ``PATH``, then open a
new Command Prompt or PowerShell window.

What uscribe LaTeX output needs
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Generated ``STEM.tex`` uses a small set of packages
(``graphicx``, ``hyperref``, ``xcolor``, ``fancyvrb``, ``booktabs``,
``longtable``, ``array``). ``multirow`` is loaded when the ``.sty`` is
installed (needed for grid-table row spans). ``caption`` is loaded when
present so Word-style ``Figure N`` / ``Table N`` captions can use
``\\caption*``; without it uscribe falls back to a centered paragraph.
``framed`` is loaded when present so code samples get a shaded box;
without it the listing is still full-width ``Verbatim``.
A latex recommended install is usually enough; GitHub Pages installs
``texlive-latex-extra`` so the user-guide PDF build has the full set.
If ``pdflatex`` stops with ``File …sty not found``, install the matching
TeX Live or MiKTeX package (or a larger scheme) and retry.

SVG figures are not embedded in PDF; convert them to PDF or PNG, or
accept the boxed placeholder uscribe emits for ``.svg`` paths.

Build uscribe
---------------

From the unicon tree:

.. code-block:: sh

   cd uni/uscribe
   make

That compiles the ``uscribe`` package, links ``./uscribe``, and
installs a copy to ``../../bin/uscribe``. ``make install`` in this
directory does the same. A top-level ``make install`` also installs
``uscribe`` into ``$(bindir)`` alongside ``unicon``, ``udb``, and the
other addon tools, and copies themes to
``$(libdir)/unicon/uni/uscribe/themes``.

Regenerate Make dependencies after adding ``.icn`` files:

.. code-block:: sh

   make deps

Verify
------

.. code-block:: sh

   uscribe
   # no book.manifest in this directory: prints usage and exits

Build this manual
-----------------

HTML:

.. code-block:: sh

   cd doc/uscribe
   make
   # open out/index.html

PDF (after installing a TeX engine as above):

.. code-block:: sh

   cd doc/uscribe
   make pdf
   # open out/uscribe-userguide.pdf

``make latex`` writes ``out/uscribe-userguide.tex`` without running a TeX engine.
``make pdf`` writes the ``.tex`` and runs the engine twice (TOC and
cross-references).
