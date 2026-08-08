# Unicon documentation

**Canonical homepage (RST):** [`index.rst`](index.rst)

On [GitHub Pages](https://uniconproject.github.io/unicon/doc/), that file is
built to HTML and is the documentation portal (UTRs, books, guides, legacy).

## Quick links (after `make html`)

| Area | Browse |
|------|--------|
| Docs homepage | [`index.rst`](index.rst) → Pages `/doc/` |
| Technical reports | [`utr/html/`](utr/html/index.html) (`make -C doc/utr html`) |
| FAQ / Posix / … | [`unicon/html/`](unicon/html/) (`make -C doc/unicon html`) |
| uscribe guide | [`uscribe/out/`](uscribe/out/index.html) |
| Icon 9.3 legacy | [`icon/`](icon/) |
| UDB overview | [`udb/`](udb/) |
| Book (LaTeX) | [`book/`](book/) |
| Implementation book | [`ib/`](ib/) |

## Building

```sh
make -C doc/utr html
make -C doc/unicon html
make -C doc/uscribe html
```

Local Pages preview (from repo root, after a Unicon build):

```sh
bash config/scripts/gh-pages/build-gh-pages-site.sh _site
bash config/scripts/gh-pages/serve-local.sh
# open http://127.0.0.1:8000/unicon/doc/
```
