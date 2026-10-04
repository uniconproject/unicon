#!/bin/bash
# Turn GitHub Actions artifact directories into the layout the local
# publish scripts consume, and share one orig tarball across suites.
#
#   assemble-repo-incoming.sh <raw-artifact-dir> <out-dir>
#
# Accepts artifact names from this workflow:
#   repo-deb-Ubuntu-24.04_amd64[-nographics]
#   repo-rpm-Fedora-44_amd64[-nographics]
#   repo-rpm-OpenSUSE-Leap-16.0_amd64[-nographics]
#   repo-rpm-OpenSUSE-Tumbleweed_amd64[-nographics]
# and the older downloads-page names (deb-*, rpm-*) which are binaries only.
#
# Output:
#   deb/unicon/<suite>_<arch>/
#   deb/unicon/<suite>_source/          # after staging
#   rpm/unicon/fedora-44_x86_64/
#   rpm/unicon/opensuse-16.0_x86_64/
#   rpm/unicon/opensuse-tumbleweed_x86_64/
#   channel                             # dev, rc, or release
#
# A nographics artifact is only unicon-runtime-nographics. Its .deb/.rpm
# join the graphics directory. Source files stay with the graphics build.

set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && pwd)
# shellcheck source=lib-deb-source.sh
source "$SCRIPT_DIR/lib-deb-source.sh"

raw=${1:-}
out=${2:-}
if [[ -z "$raw" || -z "$out" || ! -d "$raw" ]]; then
   echo "usage: $0 <raw-artifact-dir> <out-dir>" >&2
   exit 1
fi

mkdir -p "$out"

# Map an artifact directory name to "kind nographics codename arch".
map_artifact() {
   local name="$1" nographics=0 kind="" token arch
   name=${name#repo-}
   case "$name" in
      *-nographics)
         nographics=1
         name=${name%-nographics}
         ;;
   esac
   case "$name" in
      deb-Ubuntu-22.04_*) kind=deb; token=jammy; arch=${name#deb-Ubuntu-22.04_} ;;
      deb-Ubuntu-24.04_*) kind=deb; token=noble; arch=${name#deb-Ubuntu-24.04_} ;;
      deb-Ubuntu-26.04_*) kind=deb; token=resolute; arch=${name#deb-Ubuntu-26.04_} ;;
      deb-Debian-12_*)    kind=deb; token=bookworm; arch=${name#deb-Debian-12_} ;;
      deb-Debian-13_*)    kind=deb; token=trixie; arch=${name#deb-Debian-13_} ;;
      rpm-Fedora-44_*)    kind=rpm; token=fedora-44; arch=x86_64 ;;
      rpm-RockyLinux-9_*) kind=rpm; token=rocky-9; arch=x86_64 ;;
      rpm-OpenSUSE-Leap-16.0_*) kind=rpm; token=opensuse-16.0; arch=x86_64 ;;
      rpm-OpenSUSE-Tumbleweed_*) kind=rpm; token=opensuse-tumbleweed; arch=x86_64 ;;
      *) return 1 ;;
   esac
   printf '%s %s %s %s\n' "$kind" "$nographics" "$token" "$arch"
}

shopt -s nullglob
mapped=0
for dir in "$raw"/*/; do
   [[ -d "$dir" ]] || continue
   base=$(basename "$dir")
   if ! read -r kind nographics token arch < <(map_artifact "$base"); then
      echo "skip unrecognized artifact: $base"
      continue
   fi
   dest="$out/$kind/unicon/${token}_${arch}"
   mkdir -p "$dest"
   if [[ "$nographics" == 1 ]]; then
      shopt -s nullglob
      for f in "$dir"/*.deb "$dir"/*.ddeb "$dir"/*.rpm; do
         cp -a "$f" "$dest/"
      done
      echo "mapped $base -> $kind/unicon/${token}_${arch} (runtime only)"
   else
      cp -a "$dir"/. "$dest/"
      echo "mapped $base -> $kind/unicon/${token}_${arch}"
   fi
   mapped=1
done

if [[ "$mapped" -eq 0 ]]; then
   echo "no deb or rpm artifacts found in $raw" >&2
   exit 1
fi

stage_failed=0
vdir="$out/deb/unicon"
if [[ -d "$vdir" ]]; then
   # Force: this is the step that creates the shared orig. A previous
   # partial *_source directory should not make us skip it.
   if ! stage_source_deb "$vdir" force; then
      stage_failed=1
   fi
   if ! verify_source_staging "$vdir"; then
      stage_failed=1
   fi
fi

if [[ "$stage_failed" -ne 0 ]]; then
   echo "source staging failed" >&2
   exit 1
fi

ref="${GITHUB_REF:-}"
ch=dev
case "$ref" in
   refs/tags/*)
      case "${ref#refs/tags/}" in
         *[Rr][Cc]*) ch=rc ;;
         *) ch=release ;;
      esac
      ;;
esac
printf '%s\n' "$ch" > "$out/channel"
{
   echo "channel=$ch"
   echo "github_ref=${GITHUB_REF:-}"
   echo "github_sha=${GITHUB_SHA:-}"
   echo "run_id=${GITHUB_RUN_ID:-}"
   echo "run_number=${GITHUB_RUN_NUMBER:-}"
} > "$out/manifest.txt"

echo "channel hint: $ch"
echo "wrote $out"
