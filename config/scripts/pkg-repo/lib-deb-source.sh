# Stage one shared upstream tarball for every Debian/Ubuntu suite.
#
# Each CI job runs "make dist" on its own runner, so the orig tarball bytes
# differ (timestamps) even when the tree is the same commit. reprepro stores
# one pool path per upstream version, for example
# pool/.../unicon_13.3~prerelease+git1.abc.orig.tar.gz. Publishing a second
# suite then fails with "Already existing files ... md5 expected ... got ...".
#
# The debian revision is per suite (1~deb13u1, 1~ubuntu24.04.1, ...), so each
# suite keeps its own .dsc and .debian.tar.xz. Only the orig is shared: take
# it from canonical_source_dist, copy it into every <suite>_source/ directory,
# and rewrite that file's checksum lines in each .dsc. "apt source unicon" on
# jammy still gets jammy's packaging, plus the shared orig from the pool.
#
# Same pattern as frr_debrepo.sh stage-source. Run this before debsign.
# Patching the .dsc invalidates any signature that was already there.

# shellcheck source=common.sh
source "$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && pwd)/common.sh"

shopt -s nullglob

dsc_files_from() {
   awk '/^Files:$/{found=1; next} found && /^[^[:space:]]/{exit} found {print $NF}' "$1"
}

dsc_orig_files_from() {
   dsc_files_from "$1" | grep -E '\.orig\.tar\.(gz|xz|bz2)$' || true
}

dsc_section_line_for_file() {
   local dsc="$1" section="$2" file="$3"
   awk -v sec="$section" -v fn="$file" '
      $0 ~ "^" sec ":$" {insec=1; next}
      insec && /^[^[:space:]]/ {exit}
      insec && $NF == fn {print; exit}
   ' "$dsc"
}

strip_clearsign() {
   local file="$1" tmp
   if ! grep -q 'BEGIN PGP SIGNATURE' "$file"; then
      return 0
   fi
   tmp=$(mktemp)
   awk '/^-----BEGIN PGP SIGNATURE-----/{exit} {print}' "$file" > "$tmp"
   mv -- "$tmp" "$file"
}

patch_manifest_orig_from_canonical() {
   local staged="$1" canonical="$2" orig section canon_line tmp

   strip_clearsign "$staged"

   while IFS= read -r orig; do
      [[ -z "$orig" ]] && continue
      for section in Checksums-Sha1 Checksums-Sha256 Checksums-Sha512 Files; do
         canon_line=$(dsc_section_line_for_file "$canonical" "$section" "$orig")
         [[ -z "$canon_line" ]] && continue
         tmp=$(mktemp)
         awk -v sec="$section" -v fn="$orig" -v repl="$canon_line" '
            $0 ~ "^" sec ":$" {insec=1; print; next}
            insec && /^[^[:space:]]/ {insec=0}
            insec && $NF == fn {print repl; next}
            {print}
         ' "$staged" > "$tmp"
         mv -- "$tmp" "$staged"
      done
   done < <(dsc_orig_files_from "$canonical")
}

files_section_lines() {
   awk '/^Files:$/{found=1; next} found && /^[^[:space:]]/{exit} found && NF {print}' "$1"
}

verify_files_section() {
   local dir="$1" manifest="$2" label="$3"
   local failed=0 line md5sum expected_size fname actual_size actual_md5

   while IFS= read -r line; do
      [[ -z "$line" ]] && continue
      md5sum=$(awk '{print $1}' <<< "$line")
      expected_size=$(awk '{print $2}' <<< "$line")
      fname=$(awk '{print $NF}' <<< "$line")

      if [[ ! -f "$dir/$fname" ]]; then
         echo "      VERIFY FAIL [$label]: missing $fname" >&2
         failed=1
         continue
      fi
      actual_size=$(stat -c%s "$dir/$fname")
      if [[ "$actual_size" != "$expected_size" ]]; then
         echo "      VERIFY FAIL [$label]: $fname size $actual_size != $expected_size" >&2
         failed=1
      fi
      actual_md5=$(md5sum "$dir/$fname" | awk '{print $1}')
      if [[ "$actual_md5" != "$md5sum" ]]; then
         echo "      VERIFY FAIL [$label]: $fname md5 $actual_md5 != $md5sum" >&2
         failed=1
      fi
   done < <(files_section_lines "$manifest")

   return "$failed"
}

copy_dsc_bundle() {
   local dsc="$1" destdir="$2"
   local srcdir f

   srcdir=$(dirname "$dsc")
   cp -- "$dsc" "$destdir/"
   while IFS= read -r f; do
      [[ -z "$f" ]] && continue
      if [[ ! -f "$srcdir/$f" ]]; then
         if [[ "$f" == *.orig.tar.* ]]; then
            echo "      $f filled from the canonical orig"
            continue
         fi
         echo "      missing $f (listed in $(basename "$dsc"))" >&2
         return 1
      fi
      cp -- "$srcdir/$f" "$destdir/"
   done < <(dsc_files_from "$dsc")
}

find_dsc_arch_for_dist() {
   local d="$1" a adr files
   for a in $source_arch_preference; do
      adr="${d}_${a}"
      files=("$adr"/*.dsc)
      if [[ -d "$adr" && ${#files[@]} -gt 0 ]]; then
         echo "$a"
         return 0
      fi
   done
   return 1
}

find_deb_arch_for_dist() {
   local d="$1" a adr files
   for a in $source_arch_preference; do
      adr="${d}_${a}"
      files=("$adr"/*.deb)
      if [[ -d "$adr" && ${#files[@]} -gt 0 ]]; then
         echo "$a"
         return 0
      fi
   done
   return 1
}

# Echo "suite|arch" for a .dsc whose orig tarball is actually present.
find_canonical_source_for_release() {
   local d a adr dsc orig files
   for d in $canonical_source_dist $dist; do
      a=$(find_dsc_arch_for_dist "$d") || continue
      adr="${d}_${a}"
      files=("$adr"/*.dsc)
      dsc=${files[0]}
      while IFS= read -r orig; do
         [[ -z "$orig" ]] && continue
         if [[ -f "$adr/$orig" ]]; then
            echo "${d}|${a}"
            return 0
         fi
      done < <(dsc_orig_files_from "$dsc")
   done
   return 1
}

source_dirs_present() {
   local d files
   for d in $dist; do
      files=("${d}_source"/*.dsc)
      if [[ -d "${d}_source" && ${#files[@]} -gt 0 ]]; then
         return 0
      fi
   done
   return 1
}

arch_dsc_present() {
   local d
   for d in $dist; do
      find_dsc_arch_for_dist "$d" >/dev/null && return 0
   done
   return 1
}

# Second arg "force" rebuilds *_source even when CI already staged it.
stage_source_deb() {
   local root="$1" force="${2:-}" ret=0
   [[ -d "$root" ]] || return 0
   pushd "$root" >/dev/null
   if [[ "$force" != force ]] && source_dirs_present; then
      echo "  source already staged in $root"
      popd >/dev/null
      return 0
   fi
   if ! arch_dsc_present; then
      echo "  no .dsc under $root (binaries only)"
      popd >/dev/null
      return 0
   fi
   _stage_source_deb || ret=$?
   popd >/dev/null
   return "$ret"
}

_stage_source_deb() {
   local canon_pair canon_d canon_a canon_adr canon_dsc
   local d srcdir adr a dsc orig files

   echo "  **  staging source packages (shared orig, per-suite .dsc) ..."
   canon_pair=$(find_canonical_source_for_release) || {
      echo "   no orig tarball next to a .dsc; cannot share one source file" >&2
      return 1
   }
   IFS='|' read -r canon_d canon_a <<< "$canon_pair"
   canon_adr="${canon_d}_${canon_a}"
   files=("$canon_adr"/*.dsc)
   canon_dsc=${files[0]}
   echo "   canonical orig from: ${canon_adr} ($(basename "$canon_dsc"))"

   for d in $dist; do
      srcdir="${d}_source"
      rm -rf "$srcdir"
      a=$(find_dsc_arch_for_dist "$d") || continue
      mkdir -p "$srcdir"
      adr="${d}_${a}"
      echo "   $d: staging from ${adr} (shared orig from ${canon_d})"
      for dsc in "$adr"/*.dsc; do
         echo "      $(basename "$dsc")"
         copy_dsc_bundle "$dsc" "$srcdir" || return 1
      done
      while IFS= read -r orig; do
         [[ -z "$orig" ]] && continue
         if [[ ! -f "${canon_adr}/${orig}" ]]; then
            echo "      canonical orig missing: $orig" >&2
            return 1
         fi
         cp -- "${canon_adr}/${orig}" "$srcdir/"
      done < <(dsc_orig_files_from "$canon_dsc")
      for dsc in "$srcdir"/*.dsc; do
         patch_manifest_orig_from_canonical "$dsc" "$canon_dsc"
      done
   done
}

verify_source_staging() {
   local root="$1" failed=0 d srcdir dsc
   [[ -d "$root" ]] || return 0
   pushd "$root" >/dev/null
   if ! source_dirs_present; then
      popd >/dev/null
      return 0
   fi
   echo "  **  verifying staged source packages ..."
   for d in $dist; do
      srcdir="${d}_source"
      [[ -d "$srcdir" ]] || continue
      echo "   $d: $srcdir"
      for dsc in "$srcdir"/*.dsc; do
         echo "      $(basename "$dsc")"
         if ! verify_files_section "$srcdir" "$dsc" "dsc"; then
            failed=1
         fi
      done
   done
   popd >/dev/null
   if [[ $failed -ne 0 ]]; then
      echo "  **  source verification failed" >&2
      return 1
   fi
   echo "  **  source verification ok"
}

sign_staged_dsc() {
   local root="$1" failed=0 d srcdir f
   [[ -d "$root" ]] || return 0
   echo "  **  signing staged .dsc files in $root ..."
   for d in $dist; do
      srcdir="$root/${d}_source"
      [[ -d "$srcdir" ]] || continue
      for f in "$srcdir"/*.dsc; do
         echo "     sign $(basename "$f")"
         if ! debsign -k "$SIGNKEY" --re-sign "$f"; then
            failed=1
         fi
      done
   done
   return "$failed"
}
