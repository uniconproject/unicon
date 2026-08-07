Command Line
============

Synopsis
--------

.. code-block:: sh

   uscribe --manifest=FILE [options]

Options
-------

**--manifest=FILE**
  Required. Plain-text chapter list: one source path per line.
  Lines starting with ``#`` and blank lines are ignored. Paths are
  relative to the process current working directory.

**--title=TITLE**
  Book title for ``<title>``, the sidebar heading, the index page,
  and the LaTeX ``\\title``. Default: ``Untitled Book``.

**--copyright=TEXT**
  Optional footer copyright (text after ©), e.g.
  ``2026, Jafar Al-Gharaibeh``. HTML only. Every HTML page always
  ends with ``Powered by uscribe``; chapter pages also link
  **Page source** under ``_sources/``.

**--logo=FILE**
  Optional sidebar logo. The image is copied into ``targetDir/_static/``
  and shown above the book title in the nav. HTML only.

**--format=FMT**
  Output format: ``html`` (default), ``latex``, or ``pdf``.

  - ``html`` — one page per chapter plus index/search/themes
  - ``latex`` — a single ``book.tex`` for the whole manifest
  - ``pdf`` — write ``book.tex`` and run ``pdflatex``, ``xelatex``, or
    ``lualatex`` (whichever is first in ``PATH``) twice for TOC/xrefs

**--targetDir=DIR**
  Output directory. Default: ``./htmlBook`` for HTML, ``./latexBook``
  for latex/pdf. Created if missing.

**--theme=NAME**
  Initial HTML theme: ``basic``, ``classic``, or ``dark`` (or a custom
  name under ``--themePath``). Default: ``basic``. Ignored for
  latex/pdf.

**--themePath=DIR**
  Directory that contains theme subdirectories (``DIR/basic/static``,
  …). If omitted, uscribe searches ``./themes``, ``../themes``, and
  ``themes``. HTML only.

Outputs
-------

**HTML** (``--format=html``): for each chapter ``path/name.rst``,
writes ``targetDir/name.html``, plus:

- ``index.html`` — contents landing page
- ``search.html`` + ``searchindex.js`` — full-text search
- ``_static/`` — theme CSS, search JS, highlighter, theme switcher
- ``_sources/`` — copies of chapter ``.rst`` files (Page source links)

**LaTeX / PDF**: writes ``targetDir/book.tex``. With ``--format=pdf``,
also writes ``targetDir/book.pdf`` when a TeX engine is available.
Local ``.. image::`` files are copied into ``targetDir`` automatically
(relative paths preserved). SVG is not embedded in LaTeX (a boxed
placeholder is emitted instead — convert to PDF/PNG for TeX).

Exit status
-----------

Usage errors and missing files call ``stop()`` (non-zero). A successful
build prints ``wrote …`` lines for each output file.
