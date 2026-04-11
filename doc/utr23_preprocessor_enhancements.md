**Unicon Technical Report #23**

# Preprocessor enhancements

*Triple-quoted multiline strings, function-like macros, and built-in assertions*

April 2026 · Unicon Project · [https://unicon.org](https://unicon.org)

---

## Abstract

The Unicon compiler applies a source preprocessor (`uni/unicon/preproce.icn`) before lexical analysis and parsing. Recent work adds three related facilities: **triple-quoted string literals** that can span multiple physical lines and hold arbitrary verbatim text; **function-like `$define` macros** with parameter substitution and nested expansion; and **built-in `assert` / `assert_not` macros** that compile away unless debugging or test modes are enabled. This report describes the user-visible behavior, design rationale, and implementation touchpoints. It complements the language reference ([UTR #8](unicon/utr8.html)) by documenting features that are implemented in the preprocessor rather than in the core string grammar.

**Keywords:** Unicon, preprocessor, multiline strings, macros, assertions, technical report.

---

## 1. Introduction

Unicon inherits Icon’s expression-oriented execution model and extends it with classes, packages, and other features. Compilation typically runs the **preprocessor** first: it handles `$define`, `$include`, conditional compilation, and now string rewriting and function-like macros. The preprocessor was contributed by Bob Alexander (from the Jcon distribution) and remains centered on line-oriented scanning and text replacement.

Three enhancements tighten the loop between **readability**, **conditional compilation**, and **testability**:

1. **Multiline strings** — Authors can embed blocks of text (templates, messages, small embedded DSLs) without line-continuation underscores or string concatenation.
2. **Function-like macros** — Parameterized textual substitution supports lightweight inlining and abstraction without runtime cost, analogous in spirit to the C preprocessor’s function-like macros but with Unicon-specific rules.
3. **Assertion macros** — Debug and test builds can insert checks that respect Unicon **success** and **failure**; release builds can strip them entirely.

The following sections treat each facility in turn, with **discussion** of trade-offs and **references** to merge commits and regression tests. Section 5 summarizes implementation structure; Section 6 lists related documents.

---

## 2. Multiline string support

**Merge:** [`1f12c13563446f2d88011497976a711899b871e5`](https://github.com/uniconproject/unicon/commit/1f12c13563446f2d88011497976a711899b871e5) — [PR #556](https://github.com/uniconproject/unicon/pull/556) (multi-line / “triple” strings).

### 2.1 Behavior

Triple-quoted delimiters **`"""`** … **`"""`** denote a string literal whose body may span multiple source lines. The preprocessor rewrites each region into an ordinary Unicon string literal by collecting the raw body and passing it through `preproc_quote_string()` in `preproce.icn`, which escapes bytes so the result is safe for the compiler’s scanner (`preproc_rewrite_triple_strings()`).

- A triple-quoted block may start on the same line as the opening `"""` or on following lines; it ends at the closing `"""`.
- If the scanner reaches end-of-line before the closing delimiter, it **reads additional lines** from the source file: those lines are **literal content**, not new preprocessor directives.
- Inside normal **`"..."`** or **`'...'`** literals, a **`"""`** sequence does **not** start a triple-quoted string—it remains ordinary text (for example: `x := "contains \"\"\" literally"`).
- To embed the three double-quote characters inside a triple-quoted string, use **`\"\"\"`** (backslash before each quote). The implementation intentionally does **not** support an ambiguous shorter escape so that strings ending in a single backslash remain representable.

### 2.2 Discussion

**Relation to the language reference.** [UTR #8](unicon/utr8.html) (*Unicon Language Reference*) describes classic Icon/Unicon string literals and the older **line continuation** convention: a trailing underscore on a line continues a string onto the next line, discarding the newline and leading whitespace on the continuation. Triple-quoted strings serve a different need: they preserve **newlines and indentation** inside the string and do not require each continuation line to end with `_`. They are well suited to multiline messages, snippets of data, or text where the physical layout in the source file should match the string value.

**Preprocessor vs. core lexer.** Implementing triple quotes in the **preprocessor** keeps the existing compiler string lexer unchanged and centralizes rewriting in one place. The body is first accumulated as raw text (including lines that *look* like comments or directives); only after the closing delimiter is the content turned into escapes for a normal quoted literal. That choice makes the semantics explicit: **continuation lines inside a triple-quoted string are never interpreted as preprocessor directives**—a `$ifdef` or `#` line inside the block is literal text, which is essential for embedding examples or generated fragments without accidental macro expansion.

**Portability.** `preproc_quote_string()` maps control and special characters to Icon-style escapes so the rewritten line remains portable across platforms and scanner configurations.

**Regression tests.** See `tests/unicon/triple_strings.icn` and `tests/unicon/stand/triple_strings.std` for inline and block layout, mixed indentation, interaction with ordinary strings, embedded quotes, trailing backslash, and round-trip behavior.

### 2.3 Examples

**Inline and block.** A triple-quoted literal can sit on one line or span several; newlines in the source become newlines in the string value.

```text
procedure main()
   local x
   x := """ This is a multi-line string in Unicon"""
   write(x)

   x :=
"""
This is a
multi-line
string in Unicon
"""
   write(x)
end
```

**Example output** (each `write` prints one logical line; blank lines in the string appear as empty lines between groups):

```text
 This is a multi-line string in Unicon

This is a
multi-line
string in Unicon
```

**Lines that look like preprocessor directives or comments are still string content.** Nothing inside the delimiters is expanded or stripped; the text is copied verbatim into the string.

```text
   x :=
"""
$ifdef __debug__
inside triple
$endif
"""
   write(x)

   x :=
"""
# this looks like a comment, but is string content
"""
   write(x)
```

**Example output:**

```text
$ifdef __debug__
inside triple
$endif


# this looks like a comment, but is string content
```

**Ordinary quotes vs. triple quotes.** A `"""` sequence inside `"..."` does not open a triple-quoted region—the quotes are escaped as usual:

```text
   write("contains \"\"\" literally")
```

**Example output:**

```text
contains """ literally
```

(Full coverage—including mixed indentation, embedded `"""` via `\"\"\"`, trailing backslash, and DEL-byte round-trip—is in `tests/unicon/triple_strings.icn` and `tests/unicon/stand/triple_strings.std`.)

---

## 3. Macros support

**Merge:** [`a47bdfc802d5dcf5cd2c372acb6c35e88857e0cf`](https://github.com/uniconproject/unicon/commit/a47bdfc802d5dcf5cd2c372acb6c35e88857e0cf) — [PR #554](https://github.com/uniconproject/unicon/pull/554) (function-like `$define` macros).

### 3.1 Behavior

Function-like macros extend object-like `$define` names with a **parameter list** and **replacement body**:

```text
$define NAME(p1, p2, ...)  replacement text through end of line / scanning rules
```

A call **`NAME(arg1, arg2, ...)`** expands by substituting each formal parameter with the corresponding argument text in the body. Substitution applies to **whole identifiers** only (`preproc_subst_fmacro()`), not to arbitrary substrings inside longer names. After substitution, the expansion is **rescanned** so nested macro calls can expand in one pass (`preproc_expand_fmacro_call()`).

Argument lists are parsed with **parenthesis depth** and **string awareness**: text inside `"..."` or `'...'` is opaque, so commas and parentheses inside strings do not split arguments (`preproc_scan_macro_args()`). Empty arguments (two commas with nothing between) are errors; arity must match the definition; duplicate parameter names in a `$define` are rejected.

Zero-argument macros use **`$define NAME() body`** and **`NAME()`** at the call site (whitespace before `(` is allowed in forms exercised by `tests/unicon/macros.icn`).

### 3.2 Discussion

**C preprocessor analogy.** Users familiar with **function-like macros** in C will recognize the pattern: textual substitution before semantic analysis, with token pasting replaced here by identifier-level substitution in the macro body. Unlike a hygienic Lisp macro system, there is **no awareness of Unicon scope or types**—arguments are snippets of source text. That power implies the usual cautions: multiply evaluated arguments if the parameter appears more than once, and surprising interactions if a name in the body is both a parameter and meant to refer to a global.

**Interaction with `$ifdef`.** Macros are ordinary preprocessor symbols. A name used only as a function-like macro can still be tested with `$ifdef` after definition, and `$undef` removes the macro so `$ifdef` can distinguish defined vs. undefined names (see examples in `tests/unicon/macros.icn`).

**Built-in assertion macros** (`assert`, `assert_not`) use the same function-macro machinery and can be **overridden** with `$undef` / `$define` like user macros.

**Regression tests.** `tests/unicon/macros.icn` and `tests/unicon/stand/macros.std`; negative cases in `tests/unicon/data/macros_bad_*.icn`.

### 3.3 Examples

**Definitions and calls.** Parameters substitute as whole identifiers; nested macros expand in one pass; `ID` passes string arguments through without splitting on commas inside the quotes.

```text
$define SUM(a,b) ((a) + (b))
$define MUL(a,b) ((a) * (b))
$define TWICE(x) SUM(x,x)
$define ZERO() 0
$define PICK2(a,b) b
$define CALL_WITH_SPACE(x,y) SUM (x,y)
$define ID(x) x
$define WRAP3(a,b,c) ((a) || "|" || (b) || "|" || (c))
$define A(x) B(x)
$define B(x) C(x)
$define C(x) D(x)
$define D(x) E(x)
$define E(x) ((x) + 1)

procedure main()
   write(SUM(2, 3))
   write(MUL(3, 4))
   write(TWICE(5))
   write(ZERO())
   write(PICK2(SUM(1,2), MUL(2,3)))
   write(CALL_WITH_SPACE(10, 20))
   write(ID("a,b"))
   write(ID("x,(y),z"))
   write(WRAP3("a,b", "c(d)", "e"))
   write(SUM(MUL(2, 3), 6))
   write(A(5))
   write(ZERO( ))
end
```

**Example output:**

```text
5
12
10
0
6
30
a,b
x,(y),z
a,b|c(d)|e
12
6
```

**`$ifdef` on a macro name; `$undef`.** After `$define SUM(...)`, `$ifdef SUM` succeeds (the name is defined). `$undef TEMP` removes the macro so `$ifdef TEMP` fails—useful for optional code paths.

```text
$define SUM(a,b) ((a) + (b))
$define TEMP(x) x

$ifdef SUM
$define HAS_SUM 1
$else
$define HAS_SUM 0
$endif

$undef TEMP
$ifdef TEMP
$define TEMP_IS_DEFINED 1
$else
$define TEMP_IS_DEFINED 0
$endif

procedure main()
   write(HAS_SUM)
   write(TEMP_IS_DEFINED)
end
```

**Example output:**

```text
1
0
```

**Overriding built-in `assert` / `assert_not`.** User macros can replace the builtins the same way as any other function-like macro:

```text
$undef assert
$define assert(cond,label) write("override-assert:" || (label))
$undef assert_not
$define assert_not(cond,label) write("override-assert-not:" || (label))

procedure main()
   assert(1, "a")
   assert_not(0, "c")
end
```

**Example output:**

```text
override-assert:a
override-assert-not:c
```

The full `tests/unicon/macros.icn` driver also runs compile-time negative cases (wrong arity, empty argument, duplicate parameter names) via `compile_fails(...)` and ends with sentinel lines **`arity-checks-ok`**, **`assert-override-ok`**, **`asserts-ok`**; see `tests/unicon/stand/macros.std` for the complete expected transcript.

---

## 4. Asserts

The preprocessor provides two **built-in function-like macros**:

- **`assert(condition, label)`**
- **`assert_not(condition, label)`**

The **label** may be omitted: **`assert(condition)`** and **`assert_not(condition)`** use an empty label in diagnostics.

### 4.1 Two modes: debugging and testing

Checks run only when a preprocessor symbol requests them:

| Mode | How you enable it | On assertion failure |
|------|-------------------|----------------------|
| **Debugging** | **`$define __debug__`** (or **`-D__debug__`**) | **`write(&errout, …)`** a line of the form **`[file:line] AssertionFailed (expr) label`**, then **`runerr(219, …)`** / **`runerr(220, …)`** (see **`src/runtime/data.r`**). The **`runerr`** value is the expression string, optionally followed by **`char(30)`** and the label so the traceback can show **`assert(expr, "label")`** when the label is non-empty. The last traceback line is **`assert`/`assert_not`** syntax (not **`runerr`**); see **`ttrace()`** in **`src/runtime/rdebug.r`**. An alternate expansion (manual traceback) is **commented** in **`preproce.icn`**. |
| **Testing** | **`$define __test__`** (or **`-D__test__`**) | Same **`write`** style, then **`fail`** — Unicon **failure**, not **`stop`**, so surrounding code can catch failure and continue (e.g. accumulate multiple test failures). Defining **`__test__`** also enables **`__debug__`** for the preprocessor so conditions are still compiled. |

If **neither** **`__debug__`** nor **`__test__`** is defined, **`assert(...)`** / **`assert_not(...)`** expand to **nothing**: no tokens, no run-time cost. Therefore use them only as **standalone statements**, not as subexpressions (e.g. **`y := assert(x)`** becomes invalid after stripping).

| Preprocessor symbols | Expansion |
|----------------------|-----------|
| neither | *(empty — call removed)* |
| `__debug__` only | check; on failure **`write(&errout, …)`** then **`runerr(219, expr)`** (**`assert`**) or **`runerr(220, expr)`** (**`assert_not`**) + traceback |
| `__test__` | check; on failure **`write(...)`** then **`fail`** |

If both **`__test__`** and **`__debug__`** are defined, the **testing** path (**`write`** + **`fail`**) wins.

### 4.2 Meaning in Unicon (success / failure)

Assertions follow **success** and **failure**, not Boolean truth:

- **`assert(expr)`** — succeeds when **`expr`** succeeds; if **`expr`** fails, the assertion fails.
- **`assert_not(expr)`** — succeeds when **`expr`** fails; if **`expr`** succeeds, the assertion fails.

Example: with **`x := 1`**, **`x = 2`** fails, so **`assert_not(x = 2)`** passes. Use **`===`** / ordinary comparisons for equality checks; there are no separate `assert_eq` builtins.

### 4.3 Discussion

**Zero cost in release builds.** Stripping assertions entirely matches the common C idiom of `NDEBUG` and avoids both branch overhead and accidental side effects from unevaluated expressions when assertions are disabled—here, the expression is not even present in the preprocessed source.

**Debugging vs. testing.** **`__debug__`** is appropriate when failure should **stop** with a full runtime error and traceback. **`__test__`** suits **unit tests** and batch suites where **`fail`** propagates as failure without terminating the whole process, allowing frameworks to record multiple failures.

**Overriding and name collisions.** The builtin is only triggered for the **call form** **`assert(`** … **`)`**. Other uses of the identifier `assert` are unchanged unless they take that form. **`method assert(...)`** is parsed as the macro call and should be avoided; the **`unittest`** package uses **`assertSuccess`** for block assertions.

**Label expression failure.** On the failure path, the label is assigned using **`((label_expr) | "")`** so that if **`label_expr`** fails, the assertion diagnostic and **`runerr`** / **`fail`** still run instead of losing the failure silently.

### 4.4 Examples

**Debugging:**

```text
$define __debug__

procedure main()
   local x
   x := 1
   assert(x = 1)
   assert(x === 1, "x should be one")
   assert_not(x = 2)
end
```

**Testing:**

```text
$define __test__

procedure main()
   assert(count > 0, "positive count")
end
```

**Stripped:**

```text
procedure main()
   assert(0 = 1)   # preprocessed away
end
```

**Sample failure output (`__debug__`)** — from `tests/unicon/assert_debugging.icn` / `stand/assert_debugging.std`:

```text
[assert_debugging.icn:7] AssertionFailed: (x +:= 1) = 2, x must be two after an increment
Traceback:
   main()
   deep1() from line 69 in assert_debugging.icn
   ...
   assert((x +:= 1) = 2, "x must be two after an increment") from line 7 in assert_debugging.icn
```

**Override example:**

```text
$undef assert
$define assert(c,l) write("custom:", c)
```

A bare **`$define assert`** without a parameter list defines an **object-like** macro, not the function-like builtin. There is no directive that restores the builtin after **`$undef assert`**; scope overrides per file as needed.

### 4.5 Implementation sketch

With **`__debug__`** or **`__test__`**, expansions use uniquified names such as **`__preproc_assert_1_lbl`**. **`assert`** uses alternation **`(expr) | { …failure… }`** so a succeeding expression is evaluated once. **`assert_not`** uses **`if (expr) then { …failure… }`**. The label expression is evaluated **only** on the failure path, via **`_lbl := ((label_expr) | "")`** in the generated code. In **`__debug__`** mode, failure calls **`runerr(219, …)`** or **`runerr(220, …)`** (runtime errors **219** / **220**) with no preceding **`write`**; **`err_msg()`** prints **`[file:line] AssertionFailed: …`**. In **`__test__`** mode, failure **`write`**s a line with **`AssertionFailed`** and **`fail`**s instead of **`runerr`**. The second argument is the assertion expression as a string, optionally followed by **`char(30)`** (ASCII record separator) and the label string so **`ttrace()`** can print **`assert(expr, "label")`** in the traceback (**`rdebug.r`**); **`err_msg()`** sets **`&errortext`** to **`AssertionFailed: <expr>[, <label>]`** (ASCII **30** between expr and label is shown as **`, `**) and does not emit a separate **`offending value`** line for **219**/**220** (**`errmsg.r`**). See **`preproc_expand_fmacro_call()`** in **`preproce.icn`**, **`errtab`** in **`src/runtime/data.r`**, **`err_msg()`** in **`src/runtime/errmsg.r`** (no **`Run-time error N`** line for **219**/**220**), **`runerr()`** in **`src/runtime/fmisc.r`**, and **`ttrace()`** in **`src/runtime/rdebug.r`**.

---

## 5. Implementation overview

| Concern | Primary routines / types ( `uni/unicon/preproce.icn` ) |
|---------|--------------------------------------------------------|
| Triple-quoted strings | `preproc_rewrite_triple_strings()`, `preproc_quote_string()`, `preproc_octal_escape()` |
| Function-like macros | `record preproc_fmacro(params, body)`, `preproc_scan_macro_args()`, `preproc_subst_fmacro()`, expansion rescan in `preproc_expand_fmacro_call()` |
| Assertions | Special cases for `"assert"` and `"assert_not"` in `preproc_expand_fmacro_call()` |

The preprocessor runs **before** the main compiler front end; output is a stream of preprocessed lines with `#line` synchronization as elsewhere in the implementation.

---

## 6. References

| Document or artifact | Role |
|----------------------|------|
| [UTR #8 — *Unicon Language Reference*](unicon/utr8.html) | Core string literal rules and underscore continuation; contrast with Section 2 of this report |
| `uni/unicon/preproce.icn` | Preprocessor implementation |
| `src/runtime/rdebug.r` | Traceback: **`assert(expr)`** / **`assert(expr, "label")`** / **`assert_not(…)`** for **`runerr(219/220, …)`** (label via **`char(30)`** suffix in the value string) |
| `tests/unicon/triple_strings.icn`, `tests/unicon/stand/triple_strings.std` | Multiline string regression |
| `tests/unicon/macros.icn`, `tests/unicon/stand/macros.std`, `tests/unicon/data/macros_bad_*.icn` | Macro regression and errors |
| `tests/unicon/assert_debugging.icn`, `tests/unicon/assert_testing.icn`, `tests/unicon/assert_strip.icn`, `tests/unicon/assert_failing_label.icn`, `tests/unicon/assert_not_failing.icn`, related `stand/*.std` | Assertion behavior |

---

## Document history

| Version | Date | Notes |
|---------|------|--------|
| 1.0 | April 2026 | Initial UTR #23; consolidates documentation for merges **1f12c135** (triple strings), **a47bdfc** (macros), and existing assert design. |
| 1.1 | April 2026 | Assert label guard (failure path: alternation with `""` if label expr fails); **`tests/unicon/assert_failing_label.icn`**. |
| 1.2 | April 2026 | Runtime errors **219**/**220**; traceback last line uses **`assert`/`assert_not`** syntax (**`rdebug.r`** **`ttrace()`**). |
| 1.3 | April 2026 | **`err_msg()`** (**`errmsg.r`**) omits the generic **`Run-time error N`** banner for **219**/**220**. |
| 1.4 | April 2026 | **`err_msg()`** (**`errmsg.r`**) prints one combined line for **219**/**220** (no separate **`offending value`** line). |
| 1.5 | April 2026 | **`errtab`** / **`&errortext`** use **`AssertionFailed`**; combined text is **`AssertionFailed: <expr>[, <label>]`** with **30** → **`, `**. |
