#!/bin/sh
# Exit 1 if tests/test-report.txt from "make -C tests Report" shows failures.
# POSIX sh — Alpine, FreeBSD, etc. Usage: ci-check-test-report.sh <path-to-report>
set -eu
report="${1:?usage: ci-check-test-report.sh <path-to-test-report.txt>}"
if [ ! -f "$report" ]; then
  echo "::error::Test report not found: $report"
  exit 1
fi
# Strip CR so checks work if tee produced CRLF (some CI environments).
line=$(tr -d '\r' < "$report" | grep -E 'Result:.*\([0-9]+ passed,' 2>/dev/null | tail -1 || true)
failed=$(printf '%s\n' "$line" | sed -n 's/.*(\([0-9]*\) passed, \([0-9]*\) failed,.*/\2/p')
if [ -n "$failed" ] && [ "$failed" -gt 0 ] 2>/dev/null; then
  echo "::error::Tests failed on this platform ($failed failed). See log above and test-report artifact."
  exit 1
fi
if tr -d '\r' < "$report" | grep -qE '^Result:[[:space:]]+FAIL' 2>/dev/null; then
  echo "::error::Tests failed on this platform (Result: FAIL). See log above and test-report artifact."
  exit 1
fi
if ! tr -d '\r' < "$report" | grep -qE '^Result:' 2>/dev/null; then
  echo "::error::No 'Result:' line in test report; tests may not have run or the run crashed."
  exit 1
fi
