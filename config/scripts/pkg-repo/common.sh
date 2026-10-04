# Resolve paths and load repo.conf. Source this; do not execute it.

_common_dir=$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && pwd)
# shellcheck source=distros.sh
source "$_common_dir/distros.sh"

UNIC_ROOT="${UNIC_ROOT:-$HOME/unicon-pkgs}"
if [[ -f "$UNIC_ROOT/repo.conf" ]]; then
   # shellcheck source=/dev/null
   source "$UNIC_ROOT/repo.conf"
fi

# repo.conf may override the key ids from distros.sh.
SIGNKEY="${SIGNKEY:-$signkey}"
SIGNWITH="${SIGNWITH:-$signwith}"

DEB_BASE="$UNIC_ROOT/deb.unicon.org"
RPM_BASE="$UNIC_ROOT/rpm.unicon.org"
DEB_REPO="$DEB_BASE/unicon"
DEB_REPO_NOGRAPHICS="$DEB_BASE/unicon-nographics"
PKGS_DIR="$UNIC_ROOT/pkgs"
GH_REPO="${GH_REPO:-uniconproject/unicon}"

# dev, rc, stable, a minor series such as 13.3, or "release".
# "release" expands to $release_components; it is not a repo component.
is_channel() {
   case "$1" in
      dev|rc|stable|release) return 0 ;;
   esac
   [[ "$1" =~ ^[0-9]+\.[0-9]+$ ]]
}

channel_ok() {
   if is_channel "${1:-}"; then
      return 0
   fi
   echo "channel must be dev, rc, stable, release, or a minor series like 13.3 (got ${1:-empty})" >&2
   return 1
}

# Names reprepro -C / the rpm directory should receive this publish.
components_for() {
   if [[ "$1" == release ]]; then
      echo "$release_components"
   else
      echo "$1"
   fi
}

# Newest pkgs/<run> directory, or the run id / path passed in.
resolve_run_dir() {
   local arg="${1:-}" latest
   if [[ -n "$arg" && "$arg" != latest ]]; then
      if [[ -d "$arg" ]]; then
         cd "$arg" && pwd
         return 0
      fi
      if [[ -d "$PKGS_DIR/$arg" ]]; then
         cd "$PKGS_DIR/$arg" && pwd
         return 0
      fi
      echo "package directory not found: $arg" >&2
      return 1
   fi
   if [[ ! -d "$PKGS_DIR" ]]; then
      echo "no downloads under $PKGS_DIR (run download_pkgs.sh first)" >&2
      return 1
   fi
   latest=$(find "$PKGS_DIR" -mindepth 1 -maxdepth 1 -type d -printf '%T@ %p\n' | sort -n | tail -1 | cut -d' ' -f2-)
   if [[ -z "$latest" ]]; then
      echo "no downloads under $PKGS_DIR" >&2
      return 1
   fi
   cd "$latest" && pwd
}

# channel argument, else the channel file written by CI, else dev.
resolve_channel() {
   local requested="${1:-}" run_dir="${2:-}" hinted
   if [[ -n "$requested" ]]; then
      channel_ok "$requested" || return 1
      echo "$requested"
      return 0
   fi
   if [[ -n "$run_dir" && -f "$run_dir/channel" ]]; then
      hinted=$(tr -d '[:space:]' < "$run_dir/channel")
      channel_ok "$hinted" || return 1
      echo "$hinted"
      return 0
   fi
   echo dev
}
