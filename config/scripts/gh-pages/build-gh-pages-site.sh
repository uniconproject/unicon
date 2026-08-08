#!/usr/bin/env bash
# Build static tree for GitHub Pages under SITE/ (default _site).
# Lives under config/scripts/gh-pages/; run from repository root — requires pandoc and cp.
# Local preview (paths use /unicon/... like github.io): bash config/scripts/gh-pages/serve-local.sh
#
# Documentation homepage is doc/index.rst (preferred) with fallback to doc/README.md.
# UTR and unicon HTML are built into the tree when uniphinx / pandoc are available.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# config/scripts/gh-pages -> repo root is three levels up
REPO_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
cd "$REPO_ROOT"

SITE="${1:-_site}"

# Path prefix for internal links and static assets (no trailing slash). Default /unicon for GitHub Pages.
# On Read the Docs, unset UNICON_SITE_PREFIX and set READTHEDOCS_CANONICAL_URL (done by RTD) so the
# pathname matches /en/latest/, etc.
if [[ -n "${UNICON_SITE_PREFIX:-}" ]]; then
  UNICON_SITE_PREFIX="${UNICON_SITE_PREFIX%/}"
elif [[ -n "${READTHEDOCS_CANONICAL_URL:-}" ]]; then
  UNICON_SITE_PREFIX=$(python3 -c "from urllib.parse import urlparse; import os; p=urlparse(os.environ['READTHEDOCS_CANONICAL_URL']).path.rstrip('/'); print(p if p else '/unicon')")
else
  UNICON_SITE_PREFIX=/unicon
fi

INCLUDE_TMP=$(mktemp -d)
cleanup_includes() { rm -rf "$INCLUDE_TMP"; }
trap cleanup_includes EXIT
for inc in header.html before-body.html after-body.html; do
  sed "s|/unicon|${UNICON_SITE_PREFIX}|g" "$SCRIPT_DIR/includes/$inc" > "$INCLUDE_TMP/$inc"
done
HDR=(--include-in-header="$INCLUDE_TMP/header.html")
BEFORE=(--include-before-body="$INCLUDE_TMP/before-body.html")
AFTER=(--include-after-body="$INCLUDE_TMP/after-body.html")
# COPYING and many README files have no extension — set reader to avoid pandoc warnings.
FROM_MD=(--from=markdown)
FROM_RST=(--from=rst)

# --- Build HTML documentation trees (optional locally; expected in CI) ---
build_doc_html() {
  if [[ -x uni/uniphinx/uniphinx ]] || [[ -x bin/uniphinx ]]; then
    echo "Building UTR HTML (uniphinx)..."
    make -C doc/utr html
  else
    echo "warning: uniphinx not built; skipping doc/utr HTML" >&2
  fi
  if command -v pandoc >/dev/null 2>&1; then
    echo "Building doc/unicon HTML..."
    make -C doc/unicon html
  fi
}
build_doc_html

rm -rf "$SITE"
mkdir -p "$SITE/doc" "$SITE/assets"
cp "$SCRIPT_DIR/assets/site.css" "$SITE/assets/site.css"

pandoc README.md -o "$SITE/index.html" \
  "${HDR[@]}" "${BEFORE[@]}" "${AFTER[@]}" \
  --standalone \
  --metadata title="Unicon" \
  -t html5

cp -a doc/. "$SITE/doc/"

# Documentation homepage: prefer RST portal
if [[ -f doc/index.rst ]]; then
  pandoc "${FROM_RST[@]}" doc/index.rst -o "$SITE/doc/index.html" \
    "${HDR[@]}" "${BEFORE[@]}" "${AFTER[@]}" \
    --standalone \
    --shift-heading-level-by=1 \
    --metadata title="Unicon documentation" \
    -t html5
elif [[ -f doc/README.md ]]; then
  pandoc doc/README.md -o "$SITE/doc/index.html" \
    "${HDR[@]}" "${BEFORE[@]}" "${AFTER[@]}" \
    --standalone \
    --metadata title="Unicon documentation" \
    -t html5
fi

test -f CONTRIBUTING.md && test -f COPYING
cp CONTRIBUTING.md COPYING "$SITE/"
pandoc CONTRIBUTING.md -o "$SITE/CONTRIBUTING.html" \
  "${HDR[@]}" "${BEFORE[@]}" "${AFTER[@]}" \
  --standalone \
  --metadata title="Contributing to Unicon" \
  -t html5

pandoc "${FROM_MD[@]}" COPYING -o "$SITE/COPYING.html" \
  "${HDR[@]}" "${BEFORE[@]}" "${AFTER[@]}" \
  --standalone \
  --metadata title="License (COPYING)" \
  -t html5

# Editor configs
mkdir -p "$SITE/config/editor"
cp -a config/editor/. "$SITE/config/editor/"
if [[ -f config/editor/README ]]; then
  pandoc "${FROM_MD[@]}" config/editor/README -o "$SITE/config/editor/index.html" \
    "${HDR[@]}" "${BEFORE[@]}" "${AFTER[@]}" \
    --standalone \
    --metadata title="Editor configuration (Unicon)" \
    -t html5
fi

# doc/book — LaTeX book sources
mkdir -p "$SITE/doc/book"
if [[ -f doc/book/README ]]; then
  pandoc "${FROM_MD[@]}" doc/book/README -o "$SITE/doc/book/index.html" \
    "${HDR[@]}" "${BEFORE[@]}" "${AFTER[@]}" \
    --standalone \
    --metadata title="Programming with Unicon — book sources" \
    -t html5
fi

# doc/icon — Icon 9.3 legacy index
if [[ -f doc/icon/README ]]; then
  pandoc "${FROM_MD[@]}" doc/icon/README -o "$SITE/doc/icon/index.html" \
    "${HDR[@]}" "${BEFORE[@]}" "${AFTER[@]}" \
    --standalone \
    --metadata title="Icon 9.3 legacy documentation" \
    -t html5
fi

# doc/ib — implementation book (LaTeX only); stub so /doc/ib/ is not 404
mkdir -p "$SITE/doc/ib"
pandoc "$SCRIPT_DIR/stubs/doc-ib-index.md" -o "$SITE/doc/ib/index.html" \
  "${HDR[@]}" "${BEFORE[@]}" "${AFTER[@]}" \
  --standalone \
  --metadata title="Icon implementation book (LaTeX)" \
  -t html5

# Add a class on the documentation homepage for portal styling
if [[ -f "$SITE/doc/index.html" ]]; then
  sed -i 's/<body>/<body class="unicon-doc-home">/' "$SITE/doc/index.html"
fi

touch "$SITE/.nojekyll"

# Normalize internal links for static hosting (same path prefix as nav/includes).
rewrite_site_links() {
  local f=$1
  local p="${UNICON_SITE_PREFIX}"
  sed -i \
    -e "s|href=\"CONTRIBUTING\\.md\"|href=\"${p}/CONTRIBUTING.html\"|g" \
    -e "s|href=\"\\.\\./CONTRIBUTING\\.md\"|href=\"${p}/CONTRIBUTING.html\"|g" \
    -e "s|href=\"\\.\\./\\.\\./CONTRIBUTING\\.md\"|href=\"${p}/CONTRIBUTING.html\"|g" \
    -e "s|href=\"doc/README\\.md\"|href=\"${p}/doc/\"|g" \
    -e "s|href=\"doc/index\\.rst\"|href=\"${p}/doc/\"|g" \
    -e "s|href=\"\\.\\./doc/README\\.md\"|href=\"${p}/doc/\"|g" \
    -e "s|href=\"COPYING\"|href=\"${p}/COPYING.html\"|g" \
    -e "s|href=\"book/README\"|href=\"${p}/doc/book/\"|g" \
    -e "s|href=\"icon/README\"|href=\"${p}/doc/icon/\"|g" \
    -e "s|href=\"config/editor/\"|href=\"${p}/config/editor/\"|g" \
    -e "s|href=\"config/editor/README\"|href=\"${p}/config/editor/\"|g" \
    "$f"
}

while IFS= read -r -d '' f; do
  rewrite_site_links "$f"
done < <(find "$SITE" -name '*.html' -print0)
