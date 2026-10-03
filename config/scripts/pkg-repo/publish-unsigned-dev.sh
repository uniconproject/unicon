#!/bin/bash
# Build the unsigned development repositories published on GitHub Pages.
#
#   publish-unsigned-dev.sh <repo-incoming> <arch-artifacts> <out> <base-url>
#
# Writes <out>/deb, <out>/rpm, <out>/arch, and <out>/cachyos. On the
# Pages site <out> is pkgs/, so the public trees are /unicon/pkgs/deb
# and so on.
#
# repo-incoming is the layout from assemble-repo-incoming.sh (deb/ and rpm/).
# It may be missing. arch-artifacts is a directory of repo-arch-* folders
# produced by repo-add in the Arch and CachyOS jobs. It may be missing.
#
# Only the dev component is published, and nothing is signed. apt is
# expected to use Trusted: yes, dnf gpgcheck=0, pacman SigLevel = Never.
# Signed rc/stable/13.3 repositories are a separate, later step.

set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && pwd)
# shellcheck source=lib-deb-source.sh
source "$SCRIPT_DIR/lib-deb-source.sh"

incoming=${1:-}
arch_artifacts=${2:-}
out=${3:-}
base=${4:-https://uniconproject.github.io/unicon}
base=${base%/}

if [[ -z "$out" ]]; then
   echo "usage: $0 <repo-incoming> <arch-artifacts> <out> [base-url]" >&2
   exit 1
fi

if [[ -n "$incoming" && -d "$incoming" ]]; then
   incoming=$(cd "$incoming" && pwd)
fi
if [[ -n "$arch_artifacts" && -d "$arch_artifacts" ]]; then
   arch_artifacts=$(cd "$arch_artifacts" && pwd)
fi
mkdir -p "$out"
out=$(cd "$out" && pwd)

write_client_files() {
   mkdir -p "$out/deb" "$out/rpm" "$out/arch" "$out/cachyos"
   cat > "$out/deb/unicon-dev.sources" <<EOF
# Unsigned development builds from master. Suites must be your distro
# codename: bookworm, trixie, jammy, noble, or resolute.
Types: deb
URIs: ${base}/pkgs/deb
Suites: trixie
Components: dev
Trusted: yes
EOF
   cat > "$out/rpm/unicon-fedora.repo" <<EOF
[unicon-dev]
name=Unicon dev (unsigned master snapshots)
baseurl=${base}/pkgs/rpm/fedora/\$releasever/\$basearch/
enabled=1
gpgcheck=0
repo_gpgcheck=0
EOF
   cat > "$out/rpm/unicon-rocky.repo" <<EOF
[unicon-dev]
name=Unicon dev (unsigned master snapshots)
baseurl=${base}/pkgs/rpm/rocky/\$releasever/\$basearch/
enabled=1
gpgcheck=0
repo_gpgcheck=0
EOF
   cat > "$out/arch/unicon-dev.conf" <<EOF
[unicon-dev]
Server = ${base}/pkgs/arch/\$arch
SigLevel = Never
EOF
   cat > "$out/cachyos/unicon-dev.conf" <<EOF
[unicon-dev]
Server = ${base}/pkgs/cachyos/\$arch
SigLevel = Never
EOF
}

publish_apt() {
   local root="$incoming/deb/unicon" repo="$out/deb" suite canon dir a f failed
   [[ -d "$root" ]] || return 0
   if ! command -v reprepro >/dev/null; then
      echo "reprepro is not installed" >&2
      return 1
   fi
   mkdir -p "$repo/conf"
   {
      for suite in $dist; do
         cat <<EOF
Origin: unicon
Label: unicon-dev
Codename: $suite
Architectures: source $deb_arches
Components: dev
Description: Unsigned Unicon development packages for $suite

EOF
      done
   } > "$repo/conf/distributions"
   # No SignWith. Release is unsigned; clients use Trusted: yes.
   # find_deb_arch_for_dist looks for <suite>_<arch> in the current directory.
   failed=0
   pushd "$root" >/dev/null
   for suite in $dist; do
      canon=$(find_deb_arch_for_dist "$suite" || true)
      for a in $deb_arches; do
         dir="${suite}_${a}"
         [[ -d "$dir" ]] || continue
         for f in "$dir"/*.deb; do
            [[ -f "$f" ]] || continue
            # Each arch job rebuilds Architecture: all. Keep one copy.
            if [[ "$a" != "$canon" && "$f" == *_all.deb ]]; then
               continue
            fi
            echo "apt $suite dev $(basename "$f")"
            reprepro -b "$repo" -C dev includedeb "$suite" "$f" || failed=1
         done
      done
      dir="${suite}_source"
      if [[ -d "$dir" ]]; then
         for f in "$dir"/*.dsc; do
            [[ -f "$f" ]] || continue
            echo "apt $suite dev $(basename "$f")"
            reprepro -b "$repo" -C dev includedsc "$suite" "$f" || failed=1
         done
      fi
   done
   popd >/dev/null
   reprepro -b "$repo" export || failed=1
   return "$failed"
}

# fedora-44_x86_64 -> fedora/44/x86_64
rpm_dest() {
   local token_arch=$1 token arch family ver
   arch=${token_arch##*_}
   token=${token_arch%_*}
   ver=${token##*-}
   family=${token%-*}
   printf '%s/%s/%s\n' "$family" "$ver" "$arch"
}

publish_rpm() {
   local root="$incoming/rpm/unicon" dir base dest leaf f
   [[ -d "$root" ]] || return 0
   if ! command -v createrepo_c >/dev/null; then
      echo "createrepo_c is not installed" >&2
      return 1
   fi
   for dir in "$root"/*; do
      [[ -d "$dir" ]] || continue
      base=$(basename "$dir")
      dest="$out/rpm/$(rpm_dest "$base")"
      mkdir -p "$dest"
      for f in "$dir"/*.rpm; do
         [[ -f "$f" ]] || continue
         if [[ "$f" == *.src.rpm ]]; then
            leaf=$(dirname "$dest")/SRPMS
            mkdir -p "$leaf"
            cp -a "$f" "$leaf/"
         else
            cp -a "$f" "$dest/"
         fi
      done
      if compgen -G "$dest/*.rpm" >/dev/null; then
         createrepo_c "$dest"
      fi
      leaf=$(dirname "$dest")/SRPMS
      if compgen -G "$leaf/*.rpm" >/dev/null; then
         createrepo_c "$leaf"
      fi
   done
}

publish_pacman() {
   local dir base family
   [[ -d "$arch_artifacts" ]] || return 0
   for dir in "$arch_artifacts"/repo-arch-*; do
      [[ -d "$dir" ]] || continue
      base=$(basename "$dir")
      case "$base" in
         repo-arch-Arch-*) family=arch ;;
         repo-arch-CachyOS-*) family=cachyos ;;
         *) echo "skip $base"; continue ;;
      esac
      mkdir -p "$out/$family/x86_64"
      cp -a "$dir"/. "$out/$family/x86_64/"
      echo "pacman $family <- $base"
   done
}

write_client_files

ch=dev
if [[ -f "$incoming/channel" ]]; then
   ch=$(cat "$incoming/channel")
fi
if [[ "$ch" != dev ]]; then
   echo "incoming channel is $ch; unsigned Pages repo publishes dev only" >&2
else
   publish_apt
   publish_rpm
fi
publish_pacman
echo "unsigned dev repos under $out"
