# uscribe

A prose/book doc generator for Unicon.


## Layout

| File            | Role |
|-----------------|------|
| `node.icn`       | Doctree: `Document, Section, Paragraph, BulletList, EnumList, ListItem, CodeBlock, Admonition, TableNode, ImageNode, RawDirective` (block) + `Text, Emphasis, Strong, Literal, Reference, PendingXref` (inline), plus a `nodeType()` discriminator on every concrete class and safe `mk*()` factory procs. |
| `scan.icn`       | Balanced-delimiter helpers (`sbalClause`, `scanBalancedDirectives`, `parseRolePayload`) used by inline roles such as `:ref:`Title <label>``. |
| `inline.icn`     | `parseInline(s)`: `*emph*`, `**strong**`, `` `literal` ``, `` `text <url>`_ ``, `` :ref:` `` / `` :doc:` `` / `` :sub:` `` / `` :sup:` `` → inline nodes. |
| `outputter.icn`  | Abstract `Outputter` + concrete `HtmlOutputter`. |
| `latexout.icn`   | `LatexOutputter`: book `--name`.tex / PDF (default `book`), or one article `.tex` per report. |
| `manifest.icn`   | `Manifest`: ordered chapter list (the toctree equivalent), loaded from a flat manifest file. |
| `config.icn`     | `BookConfig`: `book.conf` book settings (title, logo, name, theme); CLI overrides. |
| `labeltable.icn` | `LabelTable`: two-pass cross-ref resolution — explicit `.. _label:`, title slugs, figures/tables, and `:doc:` stems. |
| `directive.icn`  | `DirectiveRegistry`: `code-block`, admonitions (nested bodies), `image`/`figure`, `include`/`literalinclude`, `list-table`, `raw`; sketched `.. api::` UniDoc bridge. |
| `UTR-FEATURE-GAPS.md` | Status tracker for UTR migration features (report mode, cite, footnotes, …). |
| `parser.icn`     | Line-oriented parser: headings, paragraphs, lists, simple/grid tables, deflists, `.. _label:`, directives. |
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

- `.. api::` UniDoc bridge (blocked on the refactors below)

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
