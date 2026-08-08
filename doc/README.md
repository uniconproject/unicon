# Unicon documentation

This page indexes manuals, technical reports, and HTML shipped under `doc/` in the source tree. Paths are relative to `doc/`.

**On the web:** the [Unicon project site](https://unicon.sourceforge.io/) hosts a [Books](https://unicon.sourceforge.io/ubooks.html) page and a [Technical Reports](https://unicon.sourceforge.io/reports.html) index with downloads and mirrors for many of the same works.

## Contents

- [Programming with Unicon](#programming-with-unicon)
- [The Icon Programming Language Implementation](#the-icon-programming-language-implementation)
- [Unicon Technical Reports (UTRs)](#unicon-technical-reports-utrs)
  - [Unicode reference data (for UTF-8 / UTR work)](#unicode-reference-data-for-utf-8-utr-work)
- [Other documentation](#other-documentation)
  - [General Unicon pages](#general-unicon-pages)
  - [uscribe user guide](#uscribe-user-guide)
  - [Icon 9.3 legacy](#icon-93-legacy)
  - [UDB — Unicon debugger](#udb-unicon-debugger)
- [Building PDFs from LaTeX](#building-pdfs-from-latex)

---

## Programming with Unicon

LaTeX source for the book *Programming with Unicon*. See also the site’s [Books](https://unicon.sourceforge.io/ubooks.html) page for published editions and related titles.

- [README](book/README) — LaTeX build notes and TeX package dependencies
- [`*.tex` sources](book/) — book manuscript (no standalone `.html` / `.md` in-tree)

*Location in tree: `doc/book/`.*

---

## The Icon Programming Language Implementation

Implementation-oriented LaTeX (parts 1–3, appendices) for *The Icon Programming Language Implementation*.

- [`*.tex` sources](ib/) — full manuscript (no `.html` / `.md` / `.txt` in-tree)

*Location in tree: `doc/ib/`.*

---

## Unicon Technical Reports (UTRs)

Numbered project reports (UTR #1, UTR #2, …). Canonical sources for converted reports live under `doc/utr/` as RST (built HTML in `doc/utr/html/`). Older PDF/office exports may remain under `doc/unicon/` or `doc/udb/`. The [Technical Reports](https://unicon.sourceforge.io/reports.html) page on [unicon.sourceforge.io](https://unicon.sourceforge.io/) lists reports with links to PDFs/HTML on unicon.org and elsewhere.

Standard Markdown tables use equal column widths, so a narrow “#” column still wastes space. Each report below is one line: **UTR #N** — format links — *title*.

- **UTR #1** — [RST](utr/utr1.rst), [HTML](utr/html/utr1.html) — *An ODBC Interface for the Unicon Programming Language*
- **UTR #2** — [RST](utr/utr2.rst), [HTML](utr/html/utr2.html) — *iflex: A Lexical Analyzer Generator for Icon*
- **UTR #2b** — [RST](utr/utr2b.rst), [HTML](utr/html/utr2b.html) — *Uflex: A Lexical Analyzer Generator for Unicon*
- **UTR #3** — [RST](utr/utr3.rst), [HTML](utr/html/utr3.html) — *iyacc: A Parser Generator for Icon*
- **UTR #4** — [RST](utr/utr4.rst), [HTML](utr/html/utr4.html) — *Writing CGI and PHP Scripts in Icon and Unicon*
- **UTR #5** — [RST](utr/utr5.rst), [HTML](utr/html/utr5.html) — *The Implementation of Graphics in Unicon Version 10*
- **UTR #5b** — [RST](utr/utr5b.rst), [HTML](utr/html/utr5b.html) — *The Implementation of Graphics in Unicon Version 12*
- **UTR #6** — [RST](utr/utr6.rst), [HTML](utr/html/utr6.html) — *An IVIB Primer*
- **UTR #7** — [RST](utr/utr7.rst), [HTML](utr/html/utr7.html) — *Version 13.1 of Unicon for Microsoft Windows*
- **UTR #8** — [RST](utr/utr8.rst), [HTML](utr/html/utr8.html) — *Unicon Language Reference*
- **UTR #9** — [RST](utr/utr9.rst), [HTML](utr/html/utr9.html) — *Unicon 3D Graphics User's Guide and Reference Manual*
- **UTR #10** — [RST](utr/utr10.rst), [HTML](utr/html/utr10.html), [HTML (udb)](udb/utr10.html), [PDF](udb/utr10.pdf), [Word](udb/utr10.docx) — *Debugging With UDB*
- **UTR #11** — [RST](utr/utr11.rst), [HTML](utr/html/utr11.html) — *Unicon Manual Page*
- **UTR #12** — [RST](utr/utr12.rst), [HTML](utr/html/utr12.html) — *UI: a Unicon Development Environment*
- **UTR #13** — [RST](utr/utr13.rst), [HTML](utr/html/utr13.html) — *The Unicon Messaging Facilities*
- **UTR #14** — [RST](utr/utr14.rst), [HTML](utr/html/utr14.html) — *Unicon Threads User's Guide and Reference Manual*
- **UTR #15** — [RST](utr/utr15.rst), [HTML](utr/html/utr15.html) — *How to Write a Unicon Technical Report*
- **UTR #16** — [RST](utr/utr16.rst), [HTML](utr/html/utr16.html) — *A Unicon Benchmark Suite*
- **UTR #17** — [RST](utr/utr17.rst), [HTML](utr/html/utr17.html), [PDF](utr/utr17.pdf) — *A Transformational Interpreter for Goal-Directed Evaluation*
- **UTR #18**–**#20**, **#22**–**#23** — RST/HTML under `doc/utr/`
- **UTR #21** — [RST](utr/utr21.rst), [HTML](utr/html/utr21.html) — *Configuring and Building Version 13 of Unicon*

### UTF-8 application notes

Included in the UTR HTML collection (sidebar / index as **Notes**, not a
numbered UTR):

- [utf8.rst](utr/utf8.rst) / [HTML](utr/html/utf8.html) — *UTF-8 Support Notes* (Bruce Rennie)

Unicode Consortium reference tables live under `doc/utr/assets/utf8/`
(copied into `html/assets/utf8/` on ``make html``):

- [UnicodeData.txt](utr/assets/utf8/UnicodeData.txt) — Unicode character database  
- [CaseFolding.txt](utr/assets/utf8/CaseFolding.txt) — case-folding mappings  
- [SpecialCasing.txt](utr/assets/utf8/SpecialCasing.txt) — special-casing rules  

---

## Other documentation

### General Unicon pages

Pages that are not a single numbered UTR (guides, indexes, examples).

| File | Title / purpose |
|------|-----------------|
| [faq.rst](unicon/faq.rst) | *Unicon: Frequently Asked Questions* |
| [posix.rst](unicon/posix.rst) | *Unicon: A Posix Interface for the Icon Programming Language* |
| [reports.rst](unicon/reports.rst) | *Technical Reports* — in-tree index; see also the project site [Technical Reports](https://unicon.sourceforge.io/reports.html) |
| [svn.rst](unicon/svn.rst) | *Unicon Source Code SVN Repository* — **legacy** (SVN; development uses Git today) |
| [simple.rst](unicon/simple.rst) | *A Simple Example — Using the CGI Icon Library* |

*Location in tree: `doc/unicon/` (RST only; ``make -C doc/unicon html`` writes under `html/`).*

### uscribe user guide

HTML user guide for *uscribe* (Unicon’s book documentation generator).
On GitHub Pages the built guide is at
[doc/uscribe/out/](uscribe/out/index.html)
(e.g. `https://…/unicon/doc/uscribe/out/`). Sources are RST; build
locally with:

```sh
make -C doc/uscribe
# open doc/uscribe/out/index.html
```

- [Built HTML (Pages)](uscribe/out/index.html) — generated user guide
- [README](uscribe/README.md) — build notes
- [`*.rst` sources](uscribe/) — manual chapters

*Location in tree: `doc/uscribe/`. Tool sources: `uni/uscribe/`.*

### Icon 9.3 legacy

Inherited Icon Project documents (IPDs), FAQs, and manual pages.

**Index**

- [README](icon/README) — lists IPDs and manual pages  

**HTML**

| File | Title |
|------|--------|
| [faq.htm](icon/faq.htm) | *Frequently Asked Questions about the Icon programming language* |
| [ipd266.htm](icon/ipd266.htm) | *An Overview of the Icon Programming Language; Version 9* |
| [ipd281.htm](icon/ipd281.htm) | *Graphics Facilities for the Icon Programming Language; Version 9.3* |
| [ipd283.htm](icon/ipd283.htm) | *The Icon Program Library; Version 9.3.3* |

**PDF — manual pages**

- [icon.1.pdf](icon/icon.1.pdf) — *icon*(1) — Icon interpreter/compiler  
- [icon_vt.1.pdf](icon/icon_vt.1.pdf) — *icon_vt*(1) — variant translator  

**PDF — Icon Project Documents (IPD)**

- [ipd046.pdf](icon/ipd046.pdf) — *Trouble report form*
- [ipd112.pdf](icon/ipd112.pdf) — *Version 8.0 implementation differences*
- [ipd177.pdf](icon/ipd177.pdf) — *Supporting documentation for XPM*
- [ipd193.pdf](icon/ipd193.pdf) — *Support Procedures for Icon Program Monitors*
- [ipd237.pdf](icon/ipd237.pdf) — *Version 9 compiler*
- [ipd238.pdf](icon/ipd238.pdf) — *Configuring the Version 9 source code*
- [ipd239.pdf](icon/ipd239.pdf) — *Version 9 implementation differences*
- [ipd240.pdf](icon/ipd240.pdf) — *Calling C functions*
- [ipd241.pdf](icon/ipd241.pdf) — *Version 9 benchmark report*
- [ipd243.pdf](icon/ipd243.pdf) — *Installing Version 9 on UNIX platforms*
- [ipd244.pdf](icon/ipd244.pdf) — *Icon 9 UNIX Manual Page* (`icon`, `icont`, `iconc`)
- [ipd245.pdf](icon/ipd245.pdf) — *Variant translators*
- [ipd246.pdf](icon/ipd246.pdf) — *Icon 9 Variant Translator UNIX Manual Page* (`icon_vt`)
- [ipd256.pdf](icon/ipd256.pdf) — *Version 9 UNIX user's manual*
- [ipd261.pdf](icon/ipd261.pdf) — *RTL manual*
- [ipd263.pdf](icon/ipd263.pdf) — *Building source-code processors for Icon*
- [ipd265.pdf](icon/ipd265.pdf) — *Visual interface builder*
- [ipd266.pdf](icon/ipd266.pdf) — *An Overview of the Icon Programming Language; Version 9*
- [ipd271.pdf](icon/ipd271.pdf) — *Version 9 of Icon for Microsoft Windows*
- [ipd278.pdf](icon/ipd278.pdf) — *Version 9.3 language features*
- [ipd279.pdf](icon/ipd279.pdf) — *Version 9.3 Icon program library*
- [ipd280.pdf](icon/ipd280.pdf) — *Icon glossary*
- [ipd281.pdf](icon/ipd281.pdf) — *Graphics Facilities for the Icon Programming Language; Version 9.3*
- [ipd283.pdf](icon/ipd283.pdf) — *The Icon Program Library; Version 9.3.3*

*Location in tree: `doc/icon/`.*

### UDB — Unicon debugger

Overview of the source-level debugger. Full treatment of debugging is **UTR #10** in [Unicon Technical Reports (UTRs)](#unicon-technical-reports-utrs) above.

- [index.html](udb/index.html) — *UDB: The Unicon Source-Level Debugger* (overview)

*Location in tree: `doc/udb/`.*

---

## Building PDFs from LaTeX

The book, implementation book, and UTR LaTeX trees have `Makefile` targets. From the repository root:

```sh
make -C doc/book
make -C doc/ib
make -C doc/utr
```

See each directory’s `Makefile` for targets and prerequisites.
