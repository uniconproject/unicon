# Contributing to Unicon

## Discussion

Unicon is a community project: improvements to the language, runtime, libraries, tests, documentation, and tooling are all welcome. Before large changes, it helps to **open an issue** (or email) so maintainers can comment on direction, compatibility, and scope—especially for anything that affects the language definition, ABI, or build system.

**What to send as a pull request:** focused commits with a clear motivation; update **tests** or **docs** when behavior or interfaces change. Use the [Pre-submission checklist](#pre-submission-checklist) before you submit. For release-critical fixes, say how you verified the change (platform, `make Test`, sanitizer build, etc.).

## Reporting issues and getting help

- **Bugs and feature ideas:** use [GitHub Issues](https://github.com/uniconproject/unicon/issues) for reproducible bugs, concrete feature requests, and build failures on supported platforms.
- **Email:** [jeffery@unicon.org](mailto:jeffery@unicon.org) when an issue tracker thread is not a good fit (e.g. security-sensitive reports, or very open-ended design discussion).

## Pull requests

- Use a **clear branch name** and **commit messages** that state what changed and why.
- Ensure the tree **configures and builds** on at least one platform you can run.
- Run **`make Test`** when your change can affect the interpreter, compiler, or runtime (CI runs a broad matrix; local `make Test` catches many regressions early).
- Follow [Code formatting](#code-formatting); avoid unrelated refactors in the same PR.

## Pre-submission checklist

Before you open or update a pull request:

- [ ] **Format code** — follow project conventions; see [Code formatting](#code-formatting).
- [ ] **License** — confirm your contribution is licensed appropriately; see [License for contributions](#license-for-contributions).
- [ ] **Sign-off** — add a proper `Signed-off-by` line on commits; see [Signing off](#signing-off).

## Code formatting

Match the **style of the surrounding code** in each file: naming, indentation, brace and comment conventions, and line length habits already used there. **C and Unicon** sources should stay consistent with nearby examples—avoid wide reformatting unrelated to your change. When in doubt, follow existing patterns in the same directory or subsystem.

## License for contributions

By submitting a patch or pull request, you agree that your contribution can be distributed under the **same licensing terms as the rest of the Unicon tree**. The top-level **[`COPYING`](COPYING)** file explains how different parts of the distribution are licensed (for example, **GPL**-covered Unicon extensions, **public-domain** Icon-derived material where noted, the **Library GPL** terms for certain class library and VM uses, and **BSD** for `src/libtp` as described there). Do not contribute material you are not entitled to license in this way, and call out any **third-party** or **externally licensed** files clearly in the commit message or PR description.

## Signing off

A **`Signed-off-by`** trailer is a developer’s **certification** that they have the **right to submit** the patch for inclusion in the project. It records agreement to the **[Developer’s Certificate of Origin](https://developercertificate.org/)**. **Commits without a proper `Signed-off-by` line cannot and will not be merged.**

Add **`Signed-off-by: Your Name <email@example.com>`** to each commit message (typically the last line). With Git, use **`git commit -s`** (or **`git commit --signoff`**) so Git fills the line from your `user.name` and `user.email`.

Example:

```text
Signed-off-by: Ada Lovelace <ada@example.com>
```

## Source tree (overview)

- **`src/`** — C implementation of the **translator** (`icont`), **compiler** (`iconc`), **preprocessor**, and **runtime** (virtual machine, memory / GC, built-ins), plus headers in **`h/`** and related pieces such as **`rtt`**, **`asm`**, and **`lib/`** (bundled/native glue used by the build).
- **`uni/`** — the **Unicon compiler** (under **`unicon/`**, **`parser/`**, and related dirs), **`lib/`** (Unicon library sources), and Unicon-language **tools and subsystems** (for example **`ivib`**, **`ide`**, **`udb`**, **`uflex`**, **`ulsp`**, **`utf8`**, **`3d`**, **`gui`**, **`shell`**, **`xml`**, **`unidoc`**, **`monvis`**).
- **`ipl/`** — **Icon Program Library** packages shipped with the system; **`tests/`** — regression and feature tests.

---

## Configure options (overview)

The build is driven by **`./configure`** (GNU autoconf). The authoritative list of flags is:

```sh
./configure --help
```

Below is a contributor-oriented summary. Many features are **on by default** and are **auto-disabled** if dependencies are missing unless you **explicitly** `--enable-FEATURE`, in which case configure **fails** if that dependency is absent.

### Feature toggles (high level)

Typical `--disable-*` / `--enable-*` switches control subsystems such as **graphics**, **3D graphics**, **concurrency**, **SSL**, **audio**, **plugins**, **Iconc** (the Unicon compiler), **operator overloading** (`--enable-ovld`), **UDB tools**, and more. Use **`./configure --help`** for the full set and for platform-specific notes.

**`--enable-thin`** — minimalist build: turns off non-critical features to shrink the build and speed iteration when you only need a core interpreter/compiler.

**`--enable-verbosebuild`** — print full compiler command lines (useful when debugging flags or include paths).

**`--enable-doc`** / **`--enable-htmldoc`** — add Makefile rules to build documentation (see top-level `Makefile` / `doc/`).

### Developer mode, warnings, and debug symbols

| Option | Purpose |
|--------|---------|
| **`--enable-debug`** | Add **debug symbols** (`-g`) and, when no custom `CFLAGS` are set, a suitable **optimization level** for debugging (e.g. `-O0` for a normal debug build; sanitizer builds may use `-O1`). Use this whenever you need **GDB**, **lldb**, or readable **stack traces**. |
| **`--enable-devmode`** | **Developer mode:** enables **`--enable-debug`** and **compiler warnings** (`--enable-warnings`), and defines **`DEVELOPMODE`** in the build. Extra **developer-only hooks** in the runtime (see `DEVELOPMODE` in sources) are available for deeper inspection. |
| **`--enable-devmode=all`** | Same as **`yes`**, and also enables **heap debugging** and **heap verification** ([Heap debugging](#heap-debugging-and-verification))—heavier, use when tracking **memory / GC / pointer** bugs. |
| **`--enable-warnings`** | Turn on **most** compiler warnings (off by default in many configurations). |
| **`--enable-werror`** | Treat **warnings as errors**—use in CI or when cleaning up warning debt; can be noisy on new toolchains. |

**When to use what:** day-to-day hacking on C/R code: **`--enable-devmode`** (or at least **`--enable-debug`** + **`--enable-warnings`**). Shipping binaries or bisecting performance: default optimized builds without devmode.

### Heap debugging and verification

These options add **runtime checks** in the Unicon **heap / block** layer. They **slow execution** and are meant for **development and debugging**, not production installs.

| Option | What it does |
|--------|----------------|
| **`--enable-debugheap`** | Defines **`DebugHeap`**. Block access macros (e.g. `Blk`) gain **runtime type and pointer checks** so invalid block references are caught closer to the bug (see comments in `src/h/rmacros.h`). Use when **`gdb`** / **Valgrind** are not enough and you suspect **corrupted pointers** or **wrong block kinds**. |
| **`--enable-verifyheap`** | Defines **`VerifyHeap`**. Enables **structured heap/GC verification** and logging controlled at run time (see **`VRFY`** below). Use when debugging **GC invariants**, **region** issues, or subtle **memory** problems. |

**`--enable-devmode=all`** turns on **both** options together with the rest of developer mode (see [Developer mode, warnings, and debug symbols](#developer-mode-warnings-and-debug-symbols)).

**Relationship:** **`DebugHeap`** checks block access at use sites; **`VerifyHeap`** runs structured checks around **GC** and related structures. Use either or both.

### Runtime: `VRFY` and `VRFYOP` (when VerifyHeap is enabled)

With **`VerifyHeap`** compiled in, the runtime reads:

- **`VRFY`** — bit-significant verification flags. **`0`** disables extra checks. **`-1`** enables **all** verification checks. **`-2`** enables all checks but **suppresses some logging** (CI sometimes sets **`VRFY=-2`** during tests to reduce noise while still exercising checks). Other values select subsets of types to verify (see implementation and comments in `src/runtime/rmemmgt.r` and the Unicon implementation documentation).
- **`VRFYOP`** — controls **“is verified”** style messages (see `init.r` / `rmemmgt.r`).

Example for a noisy local debug session:

```sh
export VRFY=-1
./yourprog
```

For quieter output with checks still on:

```sh
export VRFY=-2
./yourprog
```

---

## Developer builds: compiler sanitizers

[AddressSanitizer](https://github.com/google/sanitizers/wiki/AddressSanitizer) helps find
out-of-bounds accesses, use-after-free, and related memory bugs in the Unicon runtime and
in native code. It is supported when building with GCC or Clang on typical Unix-like hosts.

**Configure and build** with ASan enabled. Adding `--enable-debug` gives debug symbols so
stack traces and debuggers are usable:

```sh
./configure --enable-asan --enable-debug
make -j
```

Other `configure` switches select additional LLVM/GCC sanitizers (flags are applied to compile
and link steps, including shared libraries):

| Option | Effect |
|--------|--------|
| `--enable-asan` | AddressSanitizer (`-fsanitize=address`) |
| `--enable-tsan` | ThreadSanitizer (`-fsanitize=thread`) |
| `--enable-ubsan` | UndefinedBehaviorSanitizer (`-fsanitize=undefined`) |
| `--enable-msan` | MemorySanitizer (`-fsanitize=memory`) |
| `--enable-hwasan` | HardwareAssisted AddressSanitizer (`-fsanitize=hwaddress`; common on AArch64) |

Use **at most one** of `--enable-asan`, `--enable-tsan`, `--enable-msan`, and `--enable-hwasan`.
**`--enable-ubsan`** may be combined with `--enable-asan` or `--enable-tsan`. MSan usually needs
a toolchain (and often libc) built for MemorySanitizer. After `./configure`, `unicon-config.log`
shows a single summary line such as `San: ASan UBSan`, or `San: no` when none of these are enabled.

**Optional runtime tuning** via `ASAN_OPTIONS`, for example:

```sh
export ASAN_OPTIONS=abort_on_error=1:verbosity=1
./prog
```

**LeakSanitizer** runs with ASan on typical Linux setups and treats any allocation
still live at exit as a leak, which can cause `make` to fail while building.
If remaining leak reports are only a distraction while you care about
**memory safety errors** (not leaks),
you can disable leak detection for the whole build:

```sh
export ASAN_OPTIONS=detect_leaks=0
make -j
```

**Debug under GDB** as usual; the process is already instrumented. To debug the **interpreter** (`iconx`) itself, use **`gdb --args`** so `iconx` and its argv are set in one shell line; then **`run`** / **`r`** at the `(gdb)` prompt starts with those arguments:

```sh
gdb --args ./bin/iconx prog
```

Replace `prog` with your icode file or executable name. If the Unicon **program** also needs its own command-line arguments, add them after `prog` (they are passed through to your code):

```sh
gdb --args ./bin/iconx prog arg1 arg2
```

Or start GDB on `iconx` without `--args`, then pass everything from the **`run`** command:

```text
(gdb) run prog arg1 arg2
```

Use the same `ASAN_OPTIONS` in the environment GDB passes to the program if you need
specific sanitizer behavior while stepping.

---

## Further reading

- Shipped documentation index: [documentation index](doc/)
- Continuous integration: [`.github/workflows/build.yml`](.github/workflows/build.yml)
- Heap / verification details in the implementation book: `doc/ib/` (e.g. discussion of `VRFY` in the appendices)
