#!/bin/sh
#
# OpenGL graphics regression tests.
#
#   run.sh [OUTDIR]          build+run every t*.icn with the unicon on PATH
#   run.sh -c DIR_A DIR_B    pixel-compare the PNGs of two runs (needs ImageMagick)
#
# If DISPLAY is unset and Xvfb is available, a private Xvfb server is started.
# Each test must exit 0; its stdout is kept in OUTDIR/<test>.out for comparison.
#
if [ "$1" = "-c" ]; then
   A=$2; B=$3; rc=0
   for f in "$A"/*.png; do
      b=$(basename "$f")
      if [ ! -f "$B/$b" ]; then echo "MISSING  $b"; rc=1; continue; fi
      d=$(compare -metric AE "$f" "$B/$b" null: 2>&1)
      if [ "$d" = "0" ]; then echo "same     $b"; else echo "DIFF     $b ($d px)"; rc=1; fi
   done
   for f in "$A"/*.out; do
      b=$(basename "$f")
      cmp -s "$f" "$B/$b" || { echo "DIFF     $b"; rc=1; }
   done
   exit $rc
fi

HERE=$(cd "$(dirname "$0")" && pwd)
OUT=${1:-$HERE/out}
mkdir -p "$OUT"
cp "$HERE"/*.icn "$HERE"/unicon.gif "$OUT"/
cd "$OUT" || exit 1

XPID=
if [ -z "$DISPLAY" ]; then
   command -v Xvfb >/dev/null || { echo "DISPLAY is unset and Xvfb is not installed"; exit 1; }
   d=97
   while [ -e /tmp/.X$d-lock ]; do d=$((d+1)); done
   Xvfb :$d -screen 0 1280x1024x24 +extension GLX >/dev/null 2>&1 &
   XPID=$!
   trap 'kill $XPID 2>/dev/null' EXIT
   DISPLAY=:$d; export DISPLAY
   n=0
   until [ -S /tmp/.X11-unix/X$d ]; do
      kill -0 $XPID 2>/dev/null && [ $n -lt 300 ] || { echo "Xvfb :$d did not start"; exit 1; }
      sleep 0.1; n=$((n+1))
   done
fi

unicon -s -c glsnap.icn >/dev/null 2>&1 || { echo "cannot compile glsnap.icn"; exit 1; }
pass=0; fail=0
run() { # name, suffix, env...
   t=$1; SUF=$2; shift 2
   if env "$@" timeout 30 ./$t >"$t$SUF.out" 2>"$t$SUF.err"; then
      pass=$((pass+1)); echo "pass  $t$SUF"
   else
      fail=$((fail+1)); echo "FAIL  $t$SUF: $(head -c 300 "$t$SUF.err" | tr '\n' ' ')"
   fi
}
for f in t*.icn; do
   t=${f%.icn}
   unicon -s "$f" -o "$t" >"$t.cerr" 2>&1 || { fail=$((fail+1)); echo "FAIL  $t (compile)"; continue; }
   run "$t" ""
done
run t10_2d _gl UNICONGL2D=1

echo "Result: $pass passed, $fail failed"
[ $fail -eq 0 ]
