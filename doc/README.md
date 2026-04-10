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

Numbered project reports (UTR #1, UTR #2, …). HTML, PDF, and office exports may live under `doc/utr/`, `doc/unicon/`, or `doc/udb/` depending on age and format. The [Technical Reports](https://unicon.sourceforge.io/reports.html) page on [unicon.sourceforge.io](https://unicon.sourceforge.io/) lists reports with links to PDFs/HTML on unicon.org and elsewhere.

Standard Markdown tables use equal column widths, so a narrow “#” column still wastes space. Each report below is one line: **UTR #N** — format links — *title*.

- **UTR #1** — [HTML](unicon/utr1/utr1.htm) — *An ODBC Interface for the Unicon Programming Language*
- **UTR #2** — [PDF](unicon/utr2.pdf) — *iflex: A Lexical Analyzer Generator for Icon*
- **UTR #3** — [PDF](unicon/utr3.pdf) — *iyacc: A Parser Generator for Icon*
- **UTR #4** — [HTML](unicon/utr4.html) — *Writing CGI and PHP Scripts in Icon and Unicon*
- **UTR #5** — [PDF](unicon/utr5.pdf), [OpenDocument](utr/utr5b.odt) — *The Implementation of Graphics in Unicon* (V10 PDF; V12 internals in ODT **UTR-5b**)
- **UTR #6** — [HTML](utr/utr6.html), [HTML (Word export)](unicon/utr6.html), [fragment](unicon/utr6/header.htm) — *An IVIB Primer* (`header.htm` is a small fragment; main body is `utr6.html`)
- **UTR #7** — [HTML](utr/utr7.html) — *Version 13.1 of Unicon for Microsoft Windows*
- **UTR #8** — [HTML](unicon/utr8.html), [PDF](unicon/utr8.pdf) — *Unicon Language Reference*
- **UTR #9** — [HTML](utr/utr9.html), [PDF](utr/utr9c.pdf) — *Unicon 3D Graphics User's Guide and Reference Manual*
- **UTR #10** — [HTML (utr)](utr/utr10.html), [HTML (udb)](udb/utr10.html), [PDF](udb/utr10.pdf), [Word](udb/utr10.docx) — *Debugging With UDB*
- **UTR #11** — [HTML](unicon/utr11.html) — *Unicon Manual Page*
- **UTR #12** — [HTML](utr/utr12.html) — *UI: a Unicon Development Environment*
- **UTR #13** — [OpenDocument](utr/utr13.odt) — *The Unicon Messaging Facilities*
- **UTR #14** — [Word](utr/utr14.docx) — *Unicon Threads User's Guide and Reference Manual*
- **UTR #21** — [HTML](utr/utr21.html) — *Configuring and Building Version 13 of Unicon*

### Unicode reference data (for UTF-8 / UTR work)

Machine-readable tables in `doc/utr/utf8/`:

- [UnicodeData.txt](utr/utf8/UnicodeData.txt) — Unicode character database  
- [CaseFolding.txt](utr/utf8/CaseFolding.txt) — case-folding mappings  
- [SpecialCasing.txt](utr/utf8/SpecialCasing.txt) — special-casing rules  
- [utf8info.txt](utr/utf8/utf8info.txt) — UTF-8 / Unicon notes  

---

## Other documentation

### General Unicon pages

Pages that are not a single numbered UTR (guides, indexes, examples).

| File | Title / purpose |
|------|-----------------|
| [faq.html](unicon/faq.html) | *Unicon: Frequently Asked Questions* |
| [posix.html](unicon/posix.html) | *Unicon: A Posix Interface for the Icon Programming Language* |
| [reports.html](unicon/reports.html) | *Technical Reports* — in-tree index; see also the project site [Technical Reports](https://unicon.sourceforge.io/reports.html) |
| [svn.html](unicon/svn.html) | *Unicon Source Code SVN Repository* — **legacy** (SVN; development uses Git today) |
| [simple.html](unicon/simple.html), [simp.html](unicon/simp.html) | *A Simple Example — Using the CGI Icon Library* |

*Location in tree: `doc/unicon/`.*

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
