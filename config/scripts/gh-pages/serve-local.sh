#!/usr/bin/env bash
# Preview the static site the same way GitHub Pages serves it: under /unicon/
# Usage: from repo root, after building:
#   bash config/scripts/gh-pages/build-gh-pages-site.sh _site
#   bash config/scripts/gh-pages/serve-local.sh [_site] [port]
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
SITE="${1:-_site}"
PORT="${2:-8000}"
SITE_ABS="$(cd "$REPO_ROOT" && pwd)/$SITE"

if [[ ! -f "$SITE_ABS/index.html" ]]; then
  echo "No site at $SITE_ABS — run first:" >&2
  echo "  bash config/scripts/gh-pages/build-gh-pages-site.sh $SITE" >&2
  exit 1
fi

TMP=$(mktemp -d)
cleanup() { rm -rf "$TMP"; }
trap cleanup EXIT

mkdir -p "$TMP/unicon"
cp -a "$SITE_ABS"/. "$TMP/unicon/"
cd "$TMP"

echo "Open: http://127.0.0.1:${PORT}/unicon/"
echo "CSS and nav use /unicon/... paths (same as github.io). Ctrl+C to stop."
exec python3 -m http.server "$PORT"
