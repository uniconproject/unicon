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
  **pdf** and **source** (``_sources/name.rst.txt``, viewable as
  plain text in the browser).

**--logo=FILE**
  Optional sidebar logo. The image is copied into ``targetDir/_static/``
  and shown above the book title in the nav. HTML only.

**--format=FMT**
  Output format: ``html`` (default), ``latex``, or ``pdf``.

  - ``html`` — one page per chapter plus index/search/themes.
    Report manifests get a UTR index table on ``index.html``.
  - ``latex`` — for books, a single ``book.tex``; for report
    manifests (every chapter is a report), one ``.tex`` per report
  - ``pdf`` — like ``latex``, then run ``pdflatex``, ``xelatex``, or
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

- ``index.html`` — contents landing page (chapter list, or a UTR
  table with a **Formats** column of ``pdf`` / ``txt`` for report
  collections)
- ``search.html`` + ``searchindex.js`` — full-text search
- ``_static/`` — theme CSS, search JS, highlighter, theme switcher
- ``_sources/`` — chapter sources as ``name.rst.txt`` (browser-viewable
  text; linked as **txt** / **source**)

**LaTeX / PDF**: book manifests write ``targetDir/book.tex`` (and
``book.pdf`` with ``--format=pdf``). Report manifests write one
``.tex`` / ``.pdf`` per report, named like the HTML stem
(``ex-report.tex`` beside ``ex-report.html``).
Local ``.. image::`` files are copied into ``targetDir`` automatically
(relative paths preserved). SVG is not embedded in LaTeX (a boxed
placeholder is emitted instead — convert to PDF/PNG for TeX).

Exit status
-----------

Usage errors and missing files call ``stop()`` (non-zero). A successful
build prints ``wrote …`` lines for each output file.
