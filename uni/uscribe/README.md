# uscribe

A prose/book doc generator for Unicon.


## Layout

| File            | Role |
|-----------------|------|
| `node.icn`       | Doctree: `Document, Section, Paragraph, BulletList, EnumList, ListItem, CodeBlock, Admonition, TableNode, ImageNode, RawDirective` (block) + `Text, Emphasis, Strong, Literal, Reference, PendingXref` (inline), plus a `nodeType()` discriminator on every concrete class and safe `mk*()` factory procs. |
| `scan.icn`       | Generalized version of `UniHTML.icn`'s `checkSpecial()`/`parseClause()` balanced-tag scan, decoupled from HTML output and from UniDoc's specific field names. Not yet wired into `parser.icn` (see Open work). |
| `inline.icn`     | `parseInline(s)`: `*emph*`, `**strong**`, `` `literal` ``, `` :ref:`label` ``, `` :doc:`file` `` → list of inline nodes. |
| `outputter.icn`  | Abstract `Outputter` + concrete `HtmlOutputter`. |
| `latexout.icn`   | `LatexOutputter`: whole-book `book.tex` (and PDF via a TeX engine). |
| `manifest.icn`   | `Manifest`: ordered chapter list (the toctree equivalent), loaded from a flat manifest file. |
| `labeltable.icn` | `LabelTable`: two-pass cross-ref resolution — `collect()` over every chapter, then `resolve()` swaps each `PendingXref` for a `Reference`, keyed off each `Section`'s `nodeType()`/slugified title. |
| `directive.icn`  | `DirectiveRegistry`: name → handler. Ships `code-block`/`note`/`warning`/`tip`/`image`; commented-out sketch of an `.. api::` handler that would bridge to UniDoc. |
| `parser.icn`     | Line-oriented parser: underline headings, blank-line paragraphs, `-`/`*` bullet lists, `.. name:: arg` directives with indented bodies. |
| `main.icn`       | Driver: parse every chapter (pass 1) → collect labels → resolve + render (pass 2). |
| `Makefile`       | Build via `unidep` (same pattern as `uni/unidoc/Makefile`). |
| `themes/`        | HTML themes (basic, classic, dark) + shared JS/CSS. |


## Try it

Requires a built Unicon toolchain (`./configure && make` from the
unicon tree).

```sh
cd uni/uscribe
make

# User guide (HTML; PDF needs a TeX engine — see doc/uscribe)
make -C ../../doc/uscribe
# open ../../doc/uscribe/out/index.html
# make -C ../../doc/uscribe pdf
```

## Open work

- Wire `scan.icn` into `parser.icn` for nested/balanced directives
- Tables and definition lists (doctree has `TableNode`; parser does not)
- Measure directive body indent from the first body line instead of a
  fixed 4 spaces

## Refactors this depends on, back in classic UniDoc

Not done here (would touch `uni/unidoc/` itself, which this tool
deliberately avoids modifying) but needed before the `.. api::` bridge
in `directive.icn` can be un-commented:

1. Expose `UniAll.processFile()` + `UniHTML.buildPages()` as an
   in-process callable returning a page manifest, instead of the only
   entry point being the compiled `unidoc` binary's CLI.
2. Extract `UniHTML.icn`'s page-shell code (`pageTop`, `pageBottom`,
   `navFrameRef`, `openStdHtmlFile`, `makeDirPath`) into a standalone
   module with no dependency on `UniAll`'s entity tree, so `uscribe`'s
   `HtmlOutputter` can share the same frame/nav chrome instead of
   growing its own.
