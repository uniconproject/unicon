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
cp "$repo/tests/rtt/host_inbody.r" "$tmp/host_inbody.r"

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

#
# #host inside function bodies stays in place, in both the iconc (default)
# and the interpreter (-x) outputs.
#
(
   cd "$tmp"
   "$urtt" -r"$repo/bin/" host_inbody.r >/dev/null
   "$urtt" -x -r"$repo/bin/" host_inbody.r >/dev/null
)

# in_order file pattern... : each fixed string must appear after the
# previous one.
in_order() {
   f=$1; shift
   last=0
   for pattern in "$@"; do
      n=$(awk -v last="$last" -v pat="$pattern" \
             'NR > last && index($0, pat) { print NR; exit }' "$f")
      if [ -z "$n" ]; then
         echo "$f: missing or out of order after line $last: $pattern" >&2
         exit 1
         fi
      last=$n
   done
}

for out in "$tmp/host_inbody.c" "$tmp/xhost_inbody.c"; do
   in_order "$out" "#define HOST_TOP_LEVEL 1" "int host_switch(int t)" \
      "#if HOST_PROBE >= 3" "m = 3;" "#else" "m = 1;" "#endif" "m = 2;"
   in_order "$out" "int host_decls(int n)" "#if HOST_PROBE >= 3" \
      "int k3 = 3;" "#else" "long k1 = 1;" "#endif" "n += 1;"
done

#
# Those strings can still match a program the C compiler rejects: a
# directive glued onto the previous statement, or both case labels left
# unguarded.  Compile and run the switch with the probe below, on, and
# above the threshold.
#
cc=${CC:-cc}
if ! command -v "$cc" >/dev/null 2>&1; then
   echo "rtt test: C compiler '$cc' not found" >&2
   exit 1
fi
cat > "$tmp/host_main.c" << 'EOF'
extern int host_switch(int t);
int main(void)
{
   if (host_switch(1) != EXPECT1) return 1;
   if (host_switch(2) != 2) return 2;
   return 0;
}
EOF
extract_switch() {
   awk '
      /^int host_switch\(/ { grab = 1 }
      grab {
         print
         s = $0
         while (match(s, /[{}]/)) {
            c = substr(s, RSTART, 1)
            s = substr(s, RSTART + 1)
            if (c == "{") depth++
            else depth--
            }
         if (depth > 0) opened = 1
         if (opened && depth == 0) exit
         }
   ' "$1" > "$tmp/host_switch.c"
   if ! grep -F "int host_switch" "$tmp/host_switch.c" >/dev/null; then
      echo "$1: did not find host_switch to compile" >&2
      exit 1
   fi
}
compile_switch() {
   src=$1
   probe=$2
   expect1=$3
   extract_switch "$src"
   if ! "$cc" -DHOST_PROBE="$probe" -DEXPECT1="$expect1" \
         -o "$tmp/host_switch" "$tmp/host_switch.c" "$tmp/host_main.c"; then
      echo "$src: generated switch failed to compile with HOST_PROBE=$probe" >&2
      exit 1
   fi
   if ! "$tmp/host_switch"; then
      echo "$src: host_switch returned the wrong value with HOST_PROBE=$probe" >&2
      exit 1
   fi
}
for out in "$tmp/host_inbody.c" "$tmp/xhost_inbody.c"; do
   compile_switch "$out" 2 1
   compile_switch "$out" 3 3
   compile_switch "$out" 4 3
done
# RTL operations: a body clause becomes C (f_*.c for iconc, x*.c for the
# interpreter); an inline clause also goes to the iconc data base.
cat "$tmp"/f_*.c > "$tmp/f_all.c"
for out in "$tmp/f_all.c" "$tmp/xhost_inbody.c"; do
   in_order "$out" "#if HOST_PROBE >= 3" "v = 3;" "#else" "v = 1;" "#endif"
   in_order "$out" "#if HOST_PROBE >= 3" "w = 3;" "#else" "w = 1;" "#endif"
done
in_order "$tmp/rt.db" "#if HOST_PROBE >= 3" "w = 3;" "#else" "w = 1;" "#endif"

echo "rtt test: ok"
