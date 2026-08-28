Reports
=======

A **report** is one paper: one ``.rst`` source, one HTML page, one
PDF. The left sidebar is that paper's sections (Introduction,
Motivation, …). A **book** (this guide) is the other shape: many
chapters, sidebar = chapter list, one combined PDF.

If every file in the manifest is a report, uscribe also writes a
catalog ``index.html`` — a table of links. You can ignore it when
you only have one report.

Mark a file as a report
-----------------------

Start the ``.rst`` with a field list. ``:docclass: report`` (or a
``:trnumber:``) selects report layout: masthead, abstract, keywords,
article PDF, section sidebar.

.. literalinclude:: includes/ex-report.rst

   :language: rst
   :end-before: See the Unicon site

Headings in the body become the sidebar TOC. Explicit labels
(``.. _sec-intro:``) become ``#sec-intro`` jump targets.

One report
----------

Put the paper in its own directory. Author, title, and abstract stay
in the ``.rst`` field list (above). The manifest is one line. You do
not need a per-report ``.conf``.

::

   my-paper/
     book.manifest      # one line: paper.rst
     paper.rst
     book.conf          # optional: themePath (same file books use)

``book.manifest``::

   paper.rst

Build from that directory (defaults pick up ``book.manifest`` and, if
present, ``book.conf``):

.. code-block:: sh

   uscribe --targetDir=./out

Open **``paper.html``**. The sidebar is that paper's sections.
``index.html`` is a one-row catalog; you can ignore it.

Optional ``book.conf`` is only *build* settings (theme, logo,
``themePath``), not author or abstract. If you omit ``title`` there,
the sidebar uses the paper's ``:title:``.

This guide's live fixture lives next to the user-guide ``book.conf``,
so the Makefile passes ``--config=report-example.conf`` to avoid
picking up the guide settings. The paper is
`ex-report.html <ex-one-report/ex-report.html>`_
(after ``make -C doc/uscribe``).

Output::

   out/
     paper.html       ← the report (section nav)
     paper.pdf        ← if you passed --format=pdf
     index.html
     search.html
     _static/
     _sources/

Several reports and an index
----------------------------

Same layout, more files in the manifest. Each paper is still one
HTML page. ``book.conf`` ``title`` is the *series* name on the
catalog (and the link back from each paper's sidebar).

::

   my-reports/
     book.manifest
     book.conf          # title: My Technical Reports
     paper-a.rst
     paper-a.bib
     paper-b.rst

``book.manifest``::

   paper-a.rst
   paper-b.rst

.. code-block:: sh

   uscribe --targetDir=./out

Open **``index.html``** for the table (number, title, author, date,
pdf/txt). Open a row to read that paper; its sidebar is that
paper's sections. Each paper's ``:cite:`` numbers start at 1, and
``.. bibliography::`` lists only that paper's cited works from its
own ``.bib``.

The Unicon Technical Reports tree is this pattern:
``doc/utr/utr.manifest`` and ``doc/utr/book.conf``, via
``make -C doc/utr html``.

Live fixtures in this guide (again using a separate ``--config``
because they share a directory with the user guide):
`catalog index <ex-reports/index.html>`_,
`first report <ex-reports/ex-report.html>`_,
`second report <ex-reports/ex-report-b.html>`_.
The manifests are ``report-example.manifest`` (one file) and
``reports-example.manifest`` (two files).

Book vs report (summary)
------------------------

.. list-table::
   :header-rows: 1

   * - Piece
     - Book
     - Report
   * - Source
     - many chapters
     - one ``.rst`` per paper
   * - Sidebar
     - other chapters
     - sections of this paper
   * - ``index.html``
     - ordered chapter list
     - catalog table of papers
   * - PDF
     - one file for the whole book
     - one file per paper
   * - When
     - manuals, this user guide
     - UTR, a standalone paper

A mixed manifest (some reports, some book chapters) is unusual.
Each report page still gets a section sidebar; book chapters keep
the chapter list. Prefer an all-report manifest or an all-book
manifest.

See :doc:`markup` for the field-list keys and :doc:`cli` for
``--format`` / ``--manifest``.
