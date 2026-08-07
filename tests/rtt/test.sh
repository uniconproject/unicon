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
cp "$repo/tests/rtt/c11_concurrency.r" "$tmp/c11_concurrency.r"

(
   cd "$tmp"
   "$urtt" -r"$repo/bin/" passthru_reduction.r >/dev/null
   "$urtt" -r"$repo/bin/" c11_concurrency.r >/dev/null
)

out="$tmp/passthru_reduction.c"
out_c11="$tmp/c11_concurrency.c"

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

check_c11() {
   pattern=$1
   if ! grep -F "$pattern" "$out_c11" >/dev/null; then
      echo "missing C11 probe fragment: $pattern" >&2
      exit 1
   fi
}

check_c11 "thread_local static int rtt_tls_slot;"
check_c11 "_Atomic(unsigned int) rtt_atomic_slot;"
check_c11 "atomic_int *rtt_ai = 0;"
