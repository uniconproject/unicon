Unicon documentation
====================

In-tree manuals and reports for Unicon. Pick a path below; most HTML is
generated from RST (or LaTeX for the books).

Start here
----------

================ ===========================================================
I want to…       Go to
================ ===========================================================
**Learn Unicon** `FAQ <unicon/html/faq.html>`__ ·
                 published `Books <https://unicon.sourceforge.io/ubooks.html>`__
**Read reports** `Technical report collection <utr/html/index.html>`__
                 (UTR 1–23, plus UTF-8 notes)
**Debug**        `UTR 10 — UDB <utr/html/utr10.html>`__ ·
                 short `overview <udb/index.html>`__
================ ===========================================================

Language reference
------------------

- `UTR 8 — Language reference <utr/html/utr8.html>`__
- `UTR 11 — unicon(1) man page <utr/html/utr11.html>`__
- `POSIX interface notes <unicon/html/posix.html>`__
- `UTF-8 support notes <utr/html/utf8.html>`__

Books (LaTeX sources)
---------------------

Manuscripts in the tree; printed/PDF editions are on the project site.

- `Programming with Unicon <book/>`__ — ``doc/book/``
- `Icon implementation book <ib/>`__ — ``doc/ib/``
- Site: `Books page <https://unicon.sourceforge.io/ubooks.html>`__

Tools and how-tos
-----------------

- `uscribe user guide <uscribe/out/index.html>`__ — RST → HTML/PDF doc tool
- `UTR 15 — writing a UTR <utr/html/utr15.html>`__
- `CGI library example <unicon/html/simple.html>`__

Archives
--------

Older or superseded material kept for reference.

- `Icon 9.3 documents <icon/>`__ — IPDs, Icon FAQs, man pages
- `SVN checkout notes <unicon/html/svn.html>`__ — legacy; development uses Git
- `Alternate reports listing <unicon/html/reports.html>`__

Build the HTML (contributors)
-----------------------------

From a configured Unicon tree::

   make -C doc/utr html        # technical reports
   make -C doc/unicon html     # FAQ, Posix, …
   make -C doc/uscribe html   # uscribe guide

Preview this site locally::

   bash config/scripts/gh-pages/build-gh-pages-site.sh _site
   bash config/scripts/gh-pages/serve-local.sh
