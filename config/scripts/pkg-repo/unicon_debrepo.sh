#!/bin/bash
# Publish Unicon .deb packages into the local reprepro repositories.
#
# Graphics and the --disable-graphics build are separate repositories so apt
# does not treat the nographics package as a newer unicon. Components follow
# Components: dev, rc, stable, and 13.3. Older minors are not built.
# "release" publishes into release_components (13.3 and stable).
#
#   dev      master snapshots (Binary Packages on master)
#   rc       release-candidate tags
#   release  release tags
#
# Source packages are staged so every suite shares one orig tarball.
# See lib-deb-source.sh. Signing the .dsc is local; reprepro signs Release
# with SignWith from conf/distributions.

set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && pwd)
# shellcheck source=lib-deb-source.sh
source "$SCRIPT_DIR/lib-deb-source.sh"

variants="unicon unicon-nographics"

repo_for_variant() {
   case "$1" in
      unicon) echo "$DEB_REPO" ;;
      unicon-nographics) echo "$DEB_REPO_NOGRAPHICS" ;;
      *) echo "unknown variant $1" >&2; return 1 ;;
   esac
}

require_repos() {
   local repo
   for repo in "$DEB_REPO" "$DEB_REPO_NOGRAPHICS"; do
      if [[ ! -f "$repo/conf/distributions" ]]; then
         echo "missing $repo/conf/distributions" >&2
         echo "run $SCRIPT_DIR/init-local-repos.sh" >&2
         return 1
      fi
   done
}

rename_ddeb() {
   local root="$1" d a dir f
   for d in $dist; do
      for a in $deb_arches; do
         dir="$root/${d}_${a}"
         [[ -d "$dir" ]] || continue
         for f in "$dir"/*.ddeb; do
            echo "     $(basename "$f") -> $(basename "${f%.ddeb}.deb")"
            mv -- "$f" "${f%.ddeb}.deb"
         done
      done
   done
}

prepare_variant() {
   local incoming="$1" force="${2:-}"
   [[ -d "$incoming" ]] || return 0
   rename_ddeb "$incoming"
   stage_source_deb "$incoming" "$force"
   verify_source_staging "$incoming"
}

publish_variant() {
   local variant="$1" channel="$2" run_dir="$3"
   local incoming repo d a dir f canon comp comps failed=0
   incoming="$run_dir/deb/$variant"
   if [[ ! -d "$incoming" ]]; then
      echo "no $variant packages in $run_dir"
      return 0
   fi
   repo=$(repo_for_variant "$variant")
   comps=$(components_for "$channel")
   echo ""
   echo "=== $variant -> $repo  components: $comps ==="
   prepare_variant "$incoming" || return 1

   pushd "$incoming" >/dev/null
   for d in $dist; do
      echo ""
      echo "Distro: $d"
      canon=$(find_deb_arch_for_dist "$d" || true)
      for a in $deb_arches; do
         dir="${d}_${a}"
         [[ -d "$dir" ]] || continue
         echo "    Arch: $a"
         for f in "$dir"/*.deb; do
            if [[ "$a" != "$canon" && "$f" == *_all.deb ]]; then
               continue
            fi
            for comp in $comps; do
               echo "    --  $f -> $comp"
               reprepro --ask-passphrase -b "$repo" -C "$comp" includedeb "$d" "$f" || failed=1
            done
         done
      done
      dir="${d}_source"
      if [[ -d "$dir" ]]; then
         echo "    Source: $dir"
         for f in "$dir"/*.dsc; do
            for comp in $comps; do
               echo "    --  $f -> $comp"
               reprepro --ask-passphrase -b "$repo" -C "$comp" includedsc "$d" "$f" || failed=1
            done
         done
      fi
   done
   popd >/dev/null
   return "$failed"
}

each_variant_incoming() {
   local run_dir="$1" variant
   for variant in $variants; do
      if [[ -d "$run_dir/deb/$variant" ]]; then
         echo "$variant"
      fi
   done
}

cmd_publish() {
   local channel="$1" run_dir="$2" variant
   require_repos
   if [[ -z "$(each_variant_incoming "$run_dir")" ]]; then
      echo "no deb trees under $run_dir/deb" >&2
      return 1
   fi
   for variant in $variants; do
      publish_variant "$variant" "$channel" "$run_dir" || return 1
   done
}

cmd_sign() {
   local run_dir="$1" variant incoming failed=0
   for variant in $variants; do
      incoming="$run_dir/deb/$variant"
      [[ -d "$incoming" ]] || continue
      prepare_variant "$incoming" || return 1
      sign_staged_dsc "$incoming" || failed=1
   done
   return "$failed"
}

cmd_stage() {
   local run_dir="$1" variant incoming
   for variant in $variants; do
      incoming="$run_dir/deb/$variant"
      [[ -d "$incoming" ]] || continue
      echo "=== stage $variant ==="
      stage_source_deb "$incoming" force
      verify_source_staging "$incoming"
   done
}

cmd_list() {
   local codename="${1:-}" channel="${2:-}" repo
   require_repos
   if [[ -z "$codename" ]]; then
      echo "usage: $0 list <codename> [component]" >&2
      return 1
   fi
   for repo in "$DEB_REPO" "$DEB_REPO_NOGRAPHICS"; do
      echo ""
      echo "=== $repo ==="
      if [[ -n "$channel" ]]; then
         channel_ok "$channel"
         reprepro -b "$repo" -C "$channel" list "$codename" || true
      else
         reprepro -b "$repo" list "$codename" || true
      fi
   done
}

cmd_remove() {
   local channel="${1:-}" ver="${2:-}" action="${3:-list}" repo d filter
   require_repos
   channel_ok "$channel" || return 1
   if [[ -z "$ver" ]]; then
      echo "usage: $0 remove <component> <version-prefix> [do]" >&2
      return 1
   fi
   filter='$Version (% '"${ver}"'*)'
   echo "  **  ${action} ${channel} versions ${ver}* ..."
   for repo in "$DEB_REPO" "$DEB_REPO_NOGRAPHICS"; do
      echo "=== $repo ==="
      for comp in $(components_for "$channel"); do
         echo "    component $comp"
         for d in $dist; do
            if [[ "$action" == do ]]; then
               reprepro --ask-passphrase -b "$repo" -C "$comp" removefilter "$d" "$filter"
            else
               reprepro -b "$repo" -C "$comp" listfilter "$d" "$filter" || true
            fi
         done
      done
   done
}

cmd_check() {
   local repo d failed=0
   require_repos
   for repo in "$DEB_REPO" "$DEB_REPO_NOGRAPHICS"; do
      echo "=== $repo ==="
      reprepro -b "$repo" checkpool || failed=1
      for d in $dist; do
         reprepro -b "$repo" check "$d" || failed=1
      done
   done
   return "$failed"
}

cmd_push() {
   local mode="${1:-dryrun}" dry=()
   if [[ -z "${DEB_REMOTE:-}" ]]; then
      echo "Set DEB_REMOTE in $UNIC_ROOT/repo.conf" >&2
      echo "example: DEB_REMOTE=unicondeb:/data/web/deb/" >&2
      return 1
   fi
   case "$DEB_REMOTE" in
      *:*) ;;
      *) echo "DEB_REMOTE must look like host:/path/" >&2; return 1 ;;
   esac
   if [[ "$mode" != sync ]]; then
      dry=(--dry-run)
      echo "  **  dry-run (pass 'sync' to upload) ..."
   fi
   rsync -axv --delete "${dry[@]}" "$DEB_BASE/" "$DEB_REMOTE"
}

cmd_pull() {
   local mode="${1:-dryrun}" dry=()
   if [[ -z "${DEB_REMOTE:-}" ]]; then
      echo "Set DEB_REMOTE in $UNIC_ROOT/repo.conf" >&2
      return 1
   fi
   if [[ "$mode" != sync ]]; then
      dry=(--dry-run)
      echo "  **  dry-run (pass 'sync' to download) ..."
   fi
   rsync -axv --delete "${dry[@]}" "$DEB_REMOTE" "$DEB_BASE/"
}

help() {
   cat <<EOF
usage: $0 <command> [args]

commands:
   rsp <channel> [run]   stage if needed, sign .dsc, publish (usual local step)
   publish <channel> [run]
   sign [run]            debsign staged .dsc files (does not sign the archive)
   stage-source [run]    rebuild per-suite source with one shared orig tarball
   list <codename> [channel]
   remove <channel> <version-prefix> [do]
   check                 reprepro checkpool + check
   push [sync]           rsync deb.unicon.org to DEB_REMOTE (default: dry-run)
   pull [sync]           rsync DEB_REMOTE down (default: dry-run)

channel is dev, rc, stable, 13.3, or release.
"release" publishes into: ${release_components}
Omit it on rsp/publish/sign to use the channel file from CI
(master -> dev, tags containing rc -> rc, other tags -> release).

[run] is a GitHub run id under $PKGS_DIR, or a path. Default: newest download.

Graphics land in $DEB_REPO.
The --disable-graphics build lands in $DEB_REPO_NOGRAPHICS.
Both use the same component names. A nographics version sorts newer than
the graphics build of the same commit, so they must not share a component.

examples:
   $0 rsp dev
   $0 rsp release
   $0 publish 13.3
   $0 list bookworm 13.3
   $0 remove dev 13.3~prerelease+git12
   $0 remove dev 13.3~prerelease+git12 do
   $0 push
   $0 push sync
   $0 check

EOF
}

# rsp/publish: optional channel then optional run.
# sign/stage: optional run, or channel ignored.
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
      echo "publishing $run_dir to: $(components_for "$channel")"
      cmd_sign "$run_dir"
      cmd_publish "$channel" "$run_dir"
      ;;
   publish)
      parse_channel_run "${2:-}" "${3:-}"
      run_dir=$(resolve_run_dir "$run_arg")
      channel=$(resolve_channel "$channel_arg" "$run_dir")
      echo "publishing $run_dir to: $(components_for "$channel")"
      cmd_publish "$channel" "$run_dir"
      ;;
   sign)
      parse_channel_run "${2:-}" "${3:-}"
      run_dir=$(resolve_run_dir "$run_arg")
      cmd_sign "$run_dir"
      ;;
   stage-source)
      parse_channel_run "${2:-}" "${3:-}"
      run_dir=$(resolve_run_dir "$run_arg")
      cmd_stage "$run_dir"
      ;;
   list)
      cmd_list "${2:-}" "${3:-}"
      ;;
   remove)
      cmd_remove "${2:-}" "${3:-}" "${4:-list}"
      ;;
   check|check-repo)
      cmd_check
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
