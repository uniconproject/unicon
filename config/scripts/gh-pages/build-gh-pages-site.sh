#!/usr/bin/env bash
# Build static tree for GitHub Pages under SITE/ (default _site).
# Lives under config/scripts/gh-pages/; run from repository root — requires pandoc and cp.
# Local preview (paths use /unicon/... like github.io): bash config/scripts/gh-pages/serve-local.sh
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# config/scripts/gh-pages -> repo root is three levels up
REPO_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
cd "$REPO_ROOT"

SITE="${1:-_site}"

HDR=(--include-in-header="$SCRIPT_DIR/includes/header.html")
BEFORE=(--include-before-body="$SCRIPT_DIR/includes/before-body.html")
AFTER=(--include-after-body="$SCRIPT_DIR/includes/after-body.html")
# COPYING and many README files have no extension — set reader to avoid pandoc warnings.
FROM_MD=(--from=markdown)

rm -rf "$SITE"
mkdir -p "$SITE/doc" "$SITE/assets"
cp "$SCRIPT_DIR/assets/site.css" "$SITE/assets/site.css"

pandoc README.md -o "$SITE/index.html" \
  "${HDR[@]}" "${BEFORE[@]}" "${AFTER[@]}" \
  --standalone \
  --metadata title="Unicon" \
  -t html5

cp -a doc/. "$SITE/doc/"

pandoc doc/README.md -o "$SITE/doc/index.html" \
  "${HDR[@]}" "${BEFORE[@]}" "${AFTER[@]}" \
  --standalone \
  --metadata title="Unicon documentation" \
  -t html5

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

touch "$SITE/.nojekyll"

# Normalize internal links for static hosting (absolute /unicon/… for site chrome + common mistakes).
rewrite_site_links() {
  local f=$1
  sed -i \
    -e 's|href="CONTRIBUTING\.md"|href="/unicon/CONTRIBUTING.html"|g' \
    -e 's|href="\.\./CONTRIBUTING\.md"|href="/unicon/CONTRIBUTING.html"|g' \
    -e 's|href="\.\./\.\./CONTRIBUTING\.md"|href="/unicon/CONTRIBUTING.html"|g' \
    -e 's|href="doc/README\.md"|href="/unicon/doc/"|g' \
    -e 's|href="\.\./doc/README\.md"|href="/unicon/doc/"|g' \
    -e 's|href="COPYING"|href="/unicon/COPYING.html"|g' \
    -e 's|href="book/README"|href="/unicon/doc/book/"|g' \
    -e 's|href="icon/README"|href="/unicon/doc/icon/"|g' \
    -e 's|href="config/editor/"|href="/unicon/config/editor/"|g' \
    -e 's|href="config/editor/README"|href="/unicon/config/editor/"|g' \
    "$f"
}

while IFS= read -r -d '' f; do
  rewrite_site_links "$f"
done < <(find "$SITE" -name '*.html' -print0)
