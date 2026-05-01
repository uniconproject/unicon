#!/bin/sh
# Requires a built RTT driver: make -C src/rtt (or full tree build).
set -eu

repo=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)
urtt=$repo/src/rtt/urtt
if [ ! -x "$urtt" ]; then
   echo "rtt test: $urtt is missing or not executable; build RTT first (e.g. make -C src/rtt)." >&2
   exit 1
fi
tmp=${TMPDIR:-/tmp}/unicon-rtt-test.$$
mkdir "$tmp"
trap 'rm -rf "$tmp"' EXIT HUP INT TERM

cp "$repo/tests/rtt/passthru_reduction.r" "$tmp/passthru_reduction.r"

(
   cd "$tmp"
   "$urtt" -r"$repo/bin/" passthru_reduction.r >/dev/null
)

out="$tmp/passthru_reduction.c"

check() {
   pattern=$1
   if ! grep -F "$pattern" "$out" >/dev/null; then
      echo "missing generated C fragment: $pattern" >&2
      exit 1
   fi
}

check "#define RTT_HOST_TEST 1"
check "#if defined(__GNUC__)"
check "#define RTT_HOST_DIRECTIVE_PROBE 42"
check "int rtt_raw_helper(void) { return RTT_HOST_TEST; }"
check "int b = a + 1;"
