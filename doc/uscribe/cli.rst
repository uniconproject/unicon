Command Line
============

Synopsis
--------

.. code-block:: sh

   uscribe [options]

Options
-------

**--manifest=FILE**
  Plain-text chapter list: one source path per line. Lines starting
  with ``#`` and blank lines are ignored. Paths are relative to the
  process current working directory. Default: ``book.manifest`` in
  the current directory.

**--config=FILE**
  Book-level settings file. If omitted, uscribe loads
  ``book.conf`` next to the manifest when that file exists.
  See :doc:`config` for the key list, path rules, and defaults.
  Any command-line option overrides the file.

**--title=TITLE**
  Book title for ``<title>``, the sidebar heading, the index page,
  and the LaTeX ``\\title``. Default: from ``book.conf``, else
  ``Untitled Book``.

**--copyright=TEXT**
  Optional footer copyright (text after ©), e.g.
  ``2026, Jafar Al-Gharaibeh``. HTML only. Every HTML page always
  ends with ``Powered by uscribe``; chapter pages also link
  **pdf** (the book PDF from ``--name``, or a sibling PDF for
  reports) and **source** (``_sources/name.rst.txt``, viewable as
  plain text in the browser).

**--name=STEM**
  Basename for the book ``.tex`` / ``.pdf`` (default: ``book``).
  HTML footers and the index link to ``STEM.pdf``. A trailing
  ``.pdf`` or ``.tex`` is stripped. Letters, digits, ``_``, and
  ``-`` only. Ignored for report collections (one file per report,
  named like the HTML stem).

**--logo=FILE**
  Optional logo. HTML copies it into ``targetDir/_static/`` and
  shows it in the sidebar. LaTeX / PDF copies it into
  ``targetDir`` and places it on the title page (page 1), not as
  a chapter figure.

**--format=FMT**
  Output format: ``html`` (default), ``latex``, or ``pdf``.

  - ``html`` — one page per chapter plus index/search/themes.
    Report manifests get a catalog table on ``index.html``. Each
    report page's sidebar lists that report's sections.
    See :doc:`reports`.
  - ``latex`` — for books, a single ``STEM.tex`` (default
    ``book.tex``); for report manifests (every chapter is a
    report), one ``.tex`` per report
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

- ``index.html`` — contents landing page (chapter list, or a catalog
  table of reports with a **Formats** column of ``pdf`` / ``txt``)
- ``search.html`` + ``searchindex.js`` — full-text search
- ``_static/`` — theme CSS, search JS, highlighter, theme switcher
- ``_sources/`` — chapter sources as ``name.rst.txt`` (browser-viewable
  text; linked as **txt** / **source**)

**LaTeX / PDF**: book manifests write ``targetDir/STEM.tex`` (and
``STEM.pdf`` with ``--format=pdf``; default stem ``book``). Report manifests write one
``.tex`` / ``.pdf`` per report, named like the HTML stem
(``ex-report.tex`` beside ``ex-report.html``).
Local ``.. image::`` files are copied into ``targetDir`` automatically
(relative paths preserved). SVG is not embedded in LaTeX (a boxed
placeholder is emitted instead — convert to PDF/PNG for TeX).

Exit status
-----------

Usage errors and missing files call ``stop()`` (non-zero). A successful
build prints ``wrote …`` lines for each output file.
