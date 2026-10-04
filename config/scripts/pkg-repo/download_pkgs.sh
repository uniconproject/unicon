#!/bin/bash
# Download a Binary Packages run into ~/unicon-pkgs/pkgs/<run-id>/.
#
# Prefers the repo-incoming artifact (already laid out, shared orig).
# If that artifact is not on the run, downloads the per-distro artifacts
# and runs assemble-repo-incoming.sh locally.

set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && pwd)
# shellcheck source=common.sh
source "$SCRIPT_DIR/common.sh"

run=${1:-latest}
if [[ "$run" == latest ]]; then
   run=$(gh run list --repo "$GH_REPO" --workflow packages.yml --branch master \
      --status success --limit 1 --json databaseId --jq '.[0].databaseId // empty')
   if [[ -z "$run" ]]; then
      echo "no successful Binary Packages run on master in $GH_REPO" >&2
      exit 1
   fi
fi

dest="$PKGS_DIR/$run"
stage=$(mktemp -d)
trap 'rm -rf "$stage"' EXIT

echo "downloading run $run from $GH_REPO"
if gh run download "$run" --repo "$GH_REPO" --name repo-incoming --dir "$stage" \
   && [[ -d "$stage/deb" || -d "$stage/rpm" ]]; then
   rm -rf "$dest"
   mkdir -p "$dest"
   cp -a "$stage"/. "$dest/"
   echo "repo-incoming -> $dest"
   echo "channel: $(cat "$dest/channel" 2>/dev/null || echo dev)"
   exit 0
fi

raw=$(mktemp -d)
trap 'rm -rf "$stage" "$raw"' EXIT
echo "no repo-incoming artifact; downloading per-job artifacts"
if ! gh run download "$run" --repo "$GH_REPO" \
   --pattern 'repo-deb-*' --pattern 'repo-rpm-*' \
   --pattern 'deb-*' --pattern 'rpm-*' --dir "$raw"; then
   echo "gh run download failed for $run" >&2
   exit 1
fi
rm -rf "$dest"
bash "$SCRIPT_DIR/assemble-repo-incoming.sh" "$raw" "$dest"
echo "assembled -> $dest"
echo "channel: $(cat "$dest/channel" 2>/dev/null || echo dev)"
