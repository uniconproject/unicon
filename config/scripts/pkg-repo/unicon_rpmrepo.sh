#!/bin/bash
# Publish Unicon rpms into the local createrepo trees.
#
# Layout (graphics; nographics is the same under unicon-nographics/):
#   rpm.unicon.org/unicon/<dev|rc|stable|13.3>/<fedora|rocky>/<version>/<arch>/
#   rpm.unicon.org/unicon/<channel>/<family>/<version>/SRPMS/
#
# rpm --addsign signs the packages. createrepo_c rebuilds the index, then
# the repomd.xml is detached-signed. dnf checks the package signatures
# (gpgcheck=1). The .repo files leave repo_gpgcheck off so a missing
# repomd signature does not block installs.

set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && pwd)
# shellcheck source=common.sh
source "$SCRIPT_DIR/common.sh"

variants="unicon unicon-nographics"

need_tools() {
   local missing=0
   if ! command -v createrepo_c >/dev/null; then
      echo "createrepo_c is not installed (apt install createrepo-c)" >&2
      missing=1
   fi
   if ! command -v rpm >/dev/null; then
      echo "rpm is not installed (apt install rpm)" >&2
      missing=1
   fi
   return "$missing"
}

# fedora-44_x86_64 -> fedora/44/x86_64
rpm_leaf() {
   local token_arch="$1" token arch family ver
   arch=${token_arch##*_}
   token=${token_arch%_*}
   ver=${token##*-}
   family=${token%-*}
   printf '%s/%s/%s\n' "$family" "$ver" "$arch"
}

sign_rpms_in() {
   local dir="$1" f failed=0
   shopt -s nullglob
   for f in "$dir"/*.rpm; do
      echo "     sign $(basename "$f")"
      if ! rpm --addsign --define "_gpg_name ${SIGNKEY}" "$f"; then
         failed=1
      fi
   done
   return "$failed"
}

index_dir() {
   local dir="$1"
   mkdir -p "$dir"
   createrepo_c --update "$dir"
   gpg --local-user "$SIGNKEY" --detach-sign --armor --yes \
      --output "$dir/repodata/repomd.xml.asc" \
      "$dir/repodata/repomd.xml"
}

publish_tree() {
   local src="$1" dest_arch="$2"
   local dest_src f
   dest_src=$(dirname "$dest_arch")/SRPMS
   mkdir -p "$dest_arch" "$dest_src"
   shopt -s nullglob
   for f in "$src"/*.rpm; do
      if [[ "$f" == *.src.rpm ]]; then
         cp -a -- "$f" "$dest_src/"
      else
         cp -a -- "$f" "$dest_arch/"
      fi
   done
   index_dir "$dest_arch"
   if compgen -G "$dest_src/*.rpm" >/dev/null; then
      index_dir "$dest_src"
   fi
}

cmd_sign() {
   local run_dir="$1" variant dir failed=0
   need_tools
   shopt -s nullglob
   for variant in $variants; do
      [[ -d "$run_dir/rpm/$variant" ]] || continue
      echo "=== sign $variant ==="
      for dir in "$run_dir/rpm/$variant"/*/; do
         [[ -d "$dir" ]] || continue
         sign_rpms_in "$dir" || failed=1
      done
   done
   return "$failed"
}

cmd_publish() {
   local channel="$1" run_dir="$2" variant dir leaf dest comp comps failed=0
   need_tools
   channel_ok "$channel"
   comps=$(components_for "$channel")
   shopt -s nullglob
   for variant in $variants; do
      [[ -d "$run_dir/rpm/$variant" ]] || continue
      echo "=== $variant components: $comps ==="
      for dir in "$run_dir/rpm/$variant"/*/; do
         [[ -d "$dir" ]] || continue
         leaf=$(rpm_leaf "$(basename "$dir")")
         for comp in $comps; do
            dest="$RPM_BASE/$variant/$comp/$leaf"
            echo "    $(basename "$dir") -> $dest"
            publish_tree "$dir" "$dest" || failed=1
         done
      done
   done
   return "$failed"
}

cmd_push() {
   local mode="${1:-dryrun}" dry=()
   if [[ -z "${RPM_REMOTE:-}" ]]; then
      echo "Set RPM_REMOTE in $UNIC_ROOT/repo.conf" >&2
      echo "example: RPM_REMOTE=uniconrpm:/data/web/rpm/" >&2
      return 1
   fi
   case "$RPM_REMOTE" in
      *:*) ;;
      *) echo "RPM_REMOTE must look like host:/path/" >&2; return 1 ;;
   esac
   if [[ "$mode" != sync ]]; then
      dry=(--dry-run)
      echo "  **  dry-run (pass 'sync' to upload) ..."
   fi
   rsync -axv --delete "${dry[@]}" "$RPM_BASE/" "$RPM_REMOTE"
}

cmd_pull() {
   local mode="${1:-dryrun}" dry=()
   if [[ -z "${RPM_REMOTE:-}" ]]; then
      echo "Set RPM_REMOTE in $UNIC_ROOT/repo.conf" >&2
      return 1
   fi
   if [[ "$mode" != sync ]]; then
      dry=(--dry-run)
   fi
   rsync -axv --delete "${dry[@]}" "$RPM_REMOTE" "$RPM_BASE/"
}

help() {
   cat <<EOF
usage: $0 <command> [args]

commands:
   rsp <channel> [run]   sign rpms, copy into the local repo, createrepo
   publish <channel> [run]
   sign [run]
   push [sync]           rsync rpm.unicon.org to RPM_REMOTE (default: dry-run)
   pull [sync]

channel is dev, rc, stable, 13.3, or release.
"release" publishes into the series and stable. See unicon_debrepo.sh.

examples:
   $0 rsp dev
   $0 publish release
   $0 push
   $0 push sync

EOF
}

parse_channel_run() {
   local a="${1:-}" b="${2:-}"
   channel_arg=""
   run_arg=""
   if is_channel "$a"; then
      channel_arg=$a
      run_arg=$b
   else
      run_arg=$a
   fi
}

case "${1:-}" in
   rsp)
      parse_channel_run "${2:-}" "${3:-}"
      run_dir=$(resolve_run_dir "$run_arg")
      channel=$(resolve_channel "$channel_arg" "$run_dir")
      echo "publishing $run_dir to component $channel"
      cmd_sign "$run_dir"
      cmd_publish "$channel" "$run_dir"
      ;;
   publish)
      parse_channel_run "${2:-}" "${3:-}"
      run_dir=$(resolve_run_dir "$run_arg")
      channel=$(resolve_channel "$channel_arg" "$run_dir")
      echo "publishing $run_dir to component $channel"
      cmd_publish "$channel" "$run_dir"
      ;;
   sign)
      parse_channel_run "${2:-}" "${3:-}"
      run_dir=$(resolve_run_dir "$run_arg")
      cmd_sign "$run_dir"
      ;;
   push)
      cmd_push "${2:-dryrun}"
      ;;
   pull)
      cmd_pull "${2:-dryrun}"
      ;;
   *)
      help
      ;;
esac
