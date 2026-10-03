#!/bin/bash
# Create ~/unicon-pkgs deb (reprepro) and rpm (createrepo) trees.
# Safe to re-run. Does not delete package pools. Rewrites conf/distributions
# from distros.sh. Writes repo.conf only when it is missing.

set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && pwd)
# shellcheck source=common.sh
source "$SCRIPT_DIR/common.sh"

suite_description() {
   local suite="$1" graphics="$2" text
   case "$suite" in
      bookworm) text="Unicon packages for Debian 12 (bookworm)" ;;
      trixie)   text="Unicon packages for Debian 13 (trixie)" ;;
      jammy)    text="Unicon packages for Ubuntu 22.04 (jammy)" ;;
      noble)    text="Unicon packages for Ubuntu 24.04 (noble)" ;;
      resolute) text="Unicon packages for Ubuntu 26.04 (resolute)" ;;
      *)        text="Unicon packages for $suite" ;;
   esac
   if [[ "$graphics" == nographics ]]; then
      text="$text, built without graphics"
   fi
   printf '%s\n' "$text"
}

write_distributions() {
   local repo="$1" graphics="$2" suite
   mkdir -p "$repo/conf"
   {
      for suite in $dist; do
         cat <<EOF
Origin: unicon
Label: unicon
Codename: $suite
Architectures: source $deb_arches
Components: $channels
Description: $(suite_description "$suite" "$graphics")
SignWith: $SIGNWITH

EOF
      done
   } > "$repo/conf/distributions"
   echo "wrote $repo/conf/distributions"
}

export_repo() {
   local repo="$1"
   # Signing Release needs the key passphrase. Only try that on a terminal.
   if [[ ! -t 0 ]]; then
      echo "skipping signed export of $repo (re-run in a terminal, or publish, to sign Release)"
      return 0
   fi
   reprepro --ask-passphrase -b "$repo" export || echo "reprepro export failed for $repo" >&2
}

write_distributions "$DEB_REPO" graphics
write_distributions "$DEB_REPO_NOGRAPHICS" nographics

install -d "$DEB_BASE" "$RPM_BASE" "$PKGS_DIR"
install -m 0644 "$SCRIPT_DIR/deb-index.html" "$DEB_BASE/index.html"
install -m 0644 "$SCRIPT_DIR/unicon-fedora.repo" "$RPM_BASE/unicon-fedora.repo"
install -m 0644 "$SCRIPT_DIR/unicon-rocky.repo" "$RPM_BASE/unicon-rocky.repo"

gpg --export "$SIGNWITH" > "$DEB_REPO/keys.gpg"
cp -a "$DEB_REPO/keys.gpg" "$DEB_REPO_NOGRAPHICS/keys.gpg"
gpg --armor --export "$SIGNWITH" > "$RPM_BASE/RPM-GPG-KEY-unicon"
echo "exported archive key $SIGNWITH"

if [[ ! -f "$UNIC_ROOT/repo.conf" ]]; then
   cat > "$UNIC_ROOT/repo.conf" <<EOF
# Sourced by the Unicon package-repo scripts.
# Key ids are public. Leave the rsync targets empty until the hosts exist.

SIGNKEY=$SIGNKEY
SIGNWITH=$SIGNWITH

# Example: DEB_REMOTE=unicondeb:/data/web/deb/
DEB_REMOTE=
# Example: RPM_REMOTE=uniconrpm:/data/web/rpm/
RPM_REMOTE=

GH_REPO=$GH_REPO
EOF
   echo "wrote $UNIC_ROOT/repo.conf"
fi

for script in download_pkgs.sh unicon_debrepo.sh unicon_rpmrepo.sh assemble-repo-incoming.sh; do
   ln -sfn "$SCRIPT_DIR/$script" "$PKGS_DIR/$script"
done
echo "symlinked scripts into $PKGS_DIR"

export_repo "$DEB_REPO"
export_repo "$DEB_REPO_NOGRAPHICS"

if command -v createrepo_c >/dev/null; then
   for variant in unicon unicon-nographics; do
      for channel in $channels; do
         for family in fedora/44 rocky/9; do
            for leaf in x86_64 SRPMS; do
               dir="$RPM_BASE/$variant/$channel/$family/$leaf"
               mkdir -p "$dir"
               createrepo_c "$dir" >/dev/null
            done
         done
      done
   done
   echo "createrepo trees under $RPM_BASE"
else
   echo "createrepo_c not installed; rpm directories were not indexed" >&2
fi

echo "local repos are under $UNIC_ROOT"
