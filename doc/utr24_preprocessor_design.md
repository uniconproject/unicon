**Unicon Technical Report #24**

# The Unicon Preprocessor

*Architecture, data structures, control flow, and extensions*

**Author:** Jafar Al-Gharaibeh

April 2026 · Unicon Project · [https://unicon.org](https://unicon.org)

---

## Abstract

The Unicon compiler runs a **line-oriented source preprocessor** before lexical analysis. The implementation lives in `uni/unicon/preproce.icn`. It was contributed by Bob Alexander (from the Jcon distribution) and has been extended for Unicon-specific predefined symbols, triple-quoted strings, function-like macros, and built-in assertion helpers. This report describes the **internal design** (§§2–6), **user-visible extensions** to the preprocessor (§7), **control flow** (§8, including Unicon’s **`/`** null vs **`\`** nonnull tests on conditional state), and a **checklist for extending** the preprocessor (§9). For how Unicon Technical Reports are produced and formatted, see [UTR #15](unicon/utr15.html) (*How to Write a Unicon Technical Report*).

**Keywords:** Unicon, preprocessor, implementation, triple-quoted strings, function-like macros, assertions, technical report.

---

## 1. Introduction

The preprocessor’s job is to turn a source file (plus includes) into a sequence of output lines the compiler proper can scan. It is **not** a full parser: it recognizes directives and identifiers, respects string and comment boundaries where relevant, and performs textual substitution. Design goals implicit in the code are:

- **Line-oriented I/O** — Primary input is one physical line at a time (`read`), with explicit hooks to append lines when strings or macro arguments span boundaries.
- **Separation of concerns** — Directives (`preproc_scan_directive`) vs. ordinary text (`preproc_scan_text`) are handled in different procedures; expansions are re-scanned for nested macros.
- **Cooperation with the debugger** — `#line` directives (`preproc_sync_lines`) keep filename and line number aligned with the original source when lines are inserted or elided.

Section 2 summarizes entry points and global state. Section 3 walks the main driver loop. Sections 4–6 cover directives, text scanning, and auxiliary facilities (errors, `#line`, string unescaping). **Section 7** documents **triple-quoted multiline strings**, **function-like macros**, and **built-in assertions**. Section 8 is a **deeper control-flow** treatment. Section 9 is a **practical guide** for implementing new features. Section 10 relates this document to other references.

---

## 2. Entry points and global state

### 2.1 Public procedures

| Procedure | Role |
|-----------|------|
| `preprocessor(fname, predefined_syms)` | Main entry: initialize state, loop over input, emit output lines (via `suspend`). `fname` may be a file name, `"_stdin.icn"` (maps to `&input`), or a **list of strings** treated as a fake file (useful for tests). |
| `preproc(dummy, args)` | Thin wrapper: `suspend preprocessor(args[1], predefs())` — used when the preprocessor is invoked like other Unicon tools with a conventional argument list. |
| `predefs()` | Builds the table of **predefined symbols** (`_UNIX`, `__DATE__`, feature flags from `&features`, `COMPILER` / `UNICONC` when applicable, etc.). See the body of `predefs()` for the authoritative mapping. |

Initialization is `preproc_new()`; cleanup is `preproc_done()`, which clears large structures to avoid retention of tables across compilations.

### 2.2 Record type

- **`preproc_fmacro(params, body)`** — Holds a function-like macro: parameter names in order (`params`) and replacement text (`body`). Object-like `$define` symbols use only `preproc_sym_table` (string values).

### 2.3 Global variables (the preprocessor “object”)

State is held in globals declared at the top of `preproce.icn`, including:

| Global | Purpose |
|--------|---------|
| `preproc_sym_table` | Object-like macros: symbol → replacement string. |
| `preproc_fun_table` | Function-like macros: symbol → `preproc_fmacro`. |
| `preproc_builtin_fun_table` | Subset of names (`assert`, `assert_not`) expanded specially in `preproc_expand_fmacro_call()`. |
| `preproc_if_stack`, `preproc_if_state` | Conditional compilation (`$ifdef` / `$ifndef` / `$else` / `$endif`). |
| `preproc_file_stack`, `preproc_file`, `preproc_filename`, `preproc_line` | Include stack and current input position. |
| `preproc_include_set`, `preproc_include_name` | Track included paths to detect **circular includes**. |
| `preproc_print_line`, `preproc_print_filename` | Track what has been emitted for `#line` generation. |
| `preproc_nest_level` | Nesting depth of `$if` at the point an include starts; used to pair stacks when EOF unwinds includes. |
| `preproc_word_chars` | Characters allowed in macro identifiers (`letters`, `digits`, `_`). |
| `preproc_command` | Name of the current directive (for error messages). |
| `preproc_err_count` | Number of errors reported. |
| `preproc_dollar_or_pound` | Whether the current directive was introduced with `#` or `$` (affects some diagnostics, e.g. `$line`). |
| `preproc_fmacro_parse_error` | Prevents bogus object-like `$define` when function-like parsing fails with a hard error. |
| `preproc_assert_uid` | Suffix generator for unique temporaries in `assert` expansions. |

Built-ins are registered in `preproc_install_builtin_macros()` during `preproc_new()`.

---

## 3. Main driver: `preprocessor()`

Rough structure:

1. **`preproc_new(fname, predefined_syms)`** — Open file or bind list/`&input`, copy or create symbol tables, reset stacks, call `preproc_install_builtin_macros()`. If the symbol `__test__` is enabled, `__debug__` may be defaulted (see `preproc_new`).

2. **Per line** — `preproc_read()` returns the next line or fails at end of all inputs.

3. **Line classification** — The loop runs under **`line ? { … }`**, so **`&subject`** is the current physical line. After leading **`preproc_space()`**:
   - If the line begins with **`#`** and the next token is **`line`** (with optional spaces, GCC style), **`preproc_scan_directive()`** handles the **`"line"`** case in the directive `case`.
   - Else if the line begins with **`$`** and the next character is in **`nonpunctuation`** (letters, digits, space, tab, form feed, carriage return — i.e. `$` is not immediately followed by something like `_` that would continue an identifier), **`preproc_scan_directive()`** runs for normal **`$define`**, **`$include`**, etc.
   - **Otherwise** **`&pos := 1`** and the whole line goes to **`preproc_scan_text()`**.

   **Important:** Unicon directives are **`$`-prefixed**. A line starting with **`#`** that is **not** the special **`#line`** form is **not** treated as a directive in the driver; it is passed to **`preproc_scan_text()`**. There, if object- or function-like macros are enabled, **`#`** outside strings starts an **Icon-style comment to end-of-line**; with no macros loaded, the line may pass through unchanged (so do not rely on C-style **`#define`** at column 0).

4. After the line loop, increment line counter, **`suspend preproc_sync_lines()`** (emit `#line` or blank lines as needed), close file if not a list, **`preproc_done()`**.

Output is produced by **`suspend`**: callers receive a stream of strings (logical output lines). The compiler concatenates them with newlines (`every yyin ||:= preprocessor(...) do yyin ||:= "\n"` in `uni/unicon/unicon.icn`).

---

## 4. Directives: `preproc_scan_directive()`

The directive name is read with `preproc_word()` after optional space. A special case maps a bare **`if`** (when already inside skipped conditional text) to **`$if`** so nested conditionals in excluded regions do not confuse the scanner.

Supported commands (when not in a “false” branch, except where noted):

| Command | Behavior |
|---------|----------|
| **`define`** | Parses either **function-like** `name(params...) body` via `preproc_scan_define_fmacro()` or **object-like** value via `preproc_scan_define_value()`. Redefinition checks compare against the same kind (`preproc_same_fmacro` for functions). Defining a function-like macro clears the object entry and vice versa. `__test__` can imply `__debug__`. |
| **`undef`** | Removes the name from both symbol and function tables (and built-in override if present). |
| **`ifdef` / `ifndef`** | Pushes `preproc_if_state` on `preproc_if_stack`, sets state from `preproc_defined(sym)` (with `ifndef` inverted). In already-false regions, state becomes `"off"`. |
| **`$if`** | Pushes state and sets `"off"` — placeholder for `if` tokens inside excluded code. |
| **`else` / `endif`** | Pops stack, toggles or closes branches; errors on mismatch. |
| **`include`** | Resolves quoted or bare filename with `preproc_qword()`, checks `preproc_include_set`, pushes current file context on `preproc_file_stack`, opens new file, resets line counter and nest marker. |
| **`line`** | Updates `preproc_filename` / `preproc_line` from numeric line and optional quoted file (used with `#` form). |
| **`error`** | Emits a user error with optional message (to end of line / `#`). |
| **`ITRACE`** | Sets `&trace` from an integer (debugging aid). |
| **`C`** | Reads lines until `$Cend`, passes accumulated text to `CIncludesParser()` (external C stub integration). |

Unknown directives in active regions call `preproc_error("unknown preprocessor directive")`.

---

## 5. Text scanning and expansion: `preproc_scan_text()`

When `preproc_if_state` is null (i.e. code is **active**):

1. **`preproc_rewrite_triple_strings()`** — Rewrites `"""` … `"""` regions into ordinary quoted literals using `preproc_quote_string()`. This runs **before** macro expansion so triple-quoted bodies are not interpreted as directives. Continuation pulls more lines via `preproc_read()`; content inside triple quotes is literal. Normal `"` / `'` strings are copied without starting triple-quote mode.

2. If there are any object-like or function-like macros, scan the line for:
   - **`#`** outside strings → treat as start of comment: position to end (`tab(0)`), stopping macro scan (Icon-style `#` comment).
   - **String literals** — Scan `'...'` and `"..."` with awareness of escapes and line continuation (`_` at end of line pulls another line via `preproc_read()`, adjusting `preproc_print_line` for `#line` sync).
   - **Identifiers** — If a **function-like** macro name is seen, `preproc_expand_fmacro_call()` may run; on success the expansion is pasted and scanning continues. Built-in `assert` / `assert_not` expand to Unicon code or empty string per `__test__` / `__debug__`. Otherwise **object-like** substitution uses `preproc_scan_text()` **recursively** on the replacement text with a **`done_set`** to block infinite recursion (same macro expanded again on the same chain).

3. If no macros apply, still **`preproc_sync_lines()`** and pass the line through.

The parameter **`done_set`** may be `&null`, a string (single macro name), or a **set** of macro names currently expanding.

**`preproc_read()`** — At EOF, unwinds includes: verifies `preproc_if_stack` depth vs `preproc_nest_level`, closes files, pops `preproc_file_stack`, removes current include from `preproc_include_set`, resumes reading from the parent file.

---

## 6. Supporting mechanisms

### 6.1 Function-like macros

- **`preproc_scan_define_fmacro()`** — Parses `(` parameter list `)` and body; sets `preproc_fmacro_parse_error` on unrecoverable parse failures so the caller does not fall back to object-like `define`.
- **`preproc_expand_fmacro_call()`** — Requires `(` after the name; **`preproc_scan_macro_args()`** splits arguments with paren depth and respects strings; **`preproc_macro_arg_next_line()`** appends physical lines when arguments span lines.
- **`preproc_subst_fmacro()`** — Substitutes whole identifiers in the body using a map from parameter names to argument text (no scan inside strings except skipping).

### 6.2 Quoting and literals

- **`preproc_quote_string(s)`** — Escapes arbitrary text for insertion as a Unicon string literal (controls → octal via `preproc_octal_escape()` where needed).
- **`preproc_istring()` / `preproc_istring_radix()`** — Decode Icon-style escapes in quoted filenames and similar.

### 6.3 `#line` generation: `preproc_sync_lines()`

Aligns emitted lines with logical source positions: emits `#line N "file"` when the filename changes or when the gap is large; for small gaps may emit blank lines. Interacts with `preproc_print_line` / `preproc_print_filename` and with macro/string continuation that adjusts `preproc_print_line`.

### 6.4 Errors: `preproc_error()`

Builds a message with file, line, and optional `$directive:` prefix; increments `preproc_err_count` and pushes a `ParseError` onto `parsingErrors` (integration with the compiler driver).

---

## 7. New Features

The base preprocessor (directives, object-like **`$define`**, **`$include`**, **`$ifdef`**) is extended with **triple-quoted multiline strings**, **function-like `$define`** (including **`$define`** line continuation with **`\`**), and **built-in `assert` / `assert_not`**. These are implemented entirely in **`preproce.icn`**; they are not part of the core quoted-string grammar described in the language reference ([UTR #8](unicon/utr8.html)), so this section records how they behave and which routines implement them (see also §§2–6 and §8).

Under each heading, the **Implementation** subsection traces control flow and key procedures—concrete examples of how extensions hook into **`preproc_scan_text()`** and **`preproc_scan_directive()`** without changing the main lexer.

### 7.1 Triple-quoted multiline strings

**Behavior.** Delimiters **`"""`** … **`"""`** denote a string whose body may span multiple physical lines. The preprocessor collects raw text (including lines that look like comments or **`$`** directives) and rewrites the region to an ordinary quoted literal using **`preproc_rewrite_triple_strings()`**, **`preproc_quote_string()`**, and **`preproc_octal_escape()`** so the compiler’s lexer sees a normal string. Inside **`"..."`** or **`'...'`**, a **`"""`** sequence does **not** start triple-quoted mode. To embed three double quotes in the body, use **`\"\"\"`** (backslash before each quote).

**Tests:** `tests/unicon/triple_strings.icn`, `tests/unicon/stand/triple_strings.std`.

```icon
procedure main()
   local x
   x := """line one
line two"""
   write(x)
end
```

#### Implementation (triple-quoted strings)

- **When it runs.** In **`preproc_scan_text()`**, after **`/preproc_if_state`** succeeds and **before** macro expansion, **`preproc_rewrite_triple_strings()`** is called. It only rewrites **`&subject`** for the current line; multiline bodies pull more text by calling **`preproc_read()`** (so line counters and include stack stay consistent with the rest of the preprocessor).
- **Scanning model.** The procedure walks the line from left to right. If there is no **`"""`** substring, it returns immediately. Otherwise it copies characters into an output string, **skipping normal `"..."` and `'...'` regions** so a **`"""`** inside a classic string is copied literally and does not start triple mode.
- **Closing delimiter.** After an opening **`"""`**, the scanner accumulates a **`body`** until a closing **`"""`**. If the cursor passes the end of **`&subject`** before the close, it appends a newline to **`body`**, **`preproc_read()`**s the next line, resets the scan to the new **`&subject`**, and continues—those lines are **never** interpreted as directives.
- **Embedded quotes in the body.** The sequence **`\"\"\"`** (backslash before each quote) inserts three literal double-quote characters into **`body`**; shorter escapes are intentionally unsupported so pathological endings (e.g. a lone trailing **`\\`**) stay representable.
- **After the body.** The raw **`body`** is turned into one ordinary string literal with **`preproc_quote_string()`**, which escapes controls and specials (including via **`preproc_octal_escape()`**). The rewritten **`&subject`** is what the lexer eventually sees; no change to **`uni/parser`** string grammar was required.

### 7.2 Function-like macros

**Behavior.** Function-like macros extend object-like **`$define`** with a parameter list and replacement body:

```icon
$define NAME(p1, p2, ...)  replacement to end of line
```

**`$define` body continuation.** The replacement may continue on following lines if each continued line ends with **`\`** as the last non-space character (C-style splice). The scanner uses **`preproc_define_value_next_line()`** together with **`preproc_scan_define_value()`**; leading space is trimmed only before the first line of the body. The same rule applies to **object-like** **`$define`** values.

**Calls.** An invocation **`NAME(arg1, …)`** may span physical lines without **`\`**: **`preproc_scan_macro_args()`** pulls more lines via **`preproc_macro_arg_next_line()`** until the closing **`)`**. That mechanism is separate from **`\`** continuation on **`$define`**.

**Expansion.** Arguments split with paren depth and **opaque** strings (`preproc_scan_macro_args()`). **`preproc_subst_fmacro()`** replaces **whole identifiers** in the body; the result is **rescanned** for nested calls (`preproc_expand_fmacro_call()`). Empty arguments and duplicate parameter names are rejected; arity must match.

**`&line` / `#line`.** Continuation adjusts **`preproc_print_line`** so emitted **`#line`** output stays consistent; **`&line`** inside expanded code generally reflects the **invocation** site, not each physical line of a multiline **`$define`** body. Regression tests such as **`macros_define_multiline_line.icn`** document the observable behavior.

**Tests:** `tests/unicon/macros.icn`, `tests/unicon/stand/macros.std`; multiline and **`&line`**: `macros_multiline_line.icn`, `macros_define_multiline_line.icn`, `macros_define_continuation.icn`, `macros_call_backslash_literal.icn`; negatives under `tests/unicon/data/macros_bad_*.icn` and `macros_bad_define_eof*.icn`.

```icon
$define SUM(a,b) ((a) + (b))
procedure main()
   write(SUM(2, 3))
end
```

**`$ifdef` / `$undef`.** A function-like name is still a defined symbol for **`$ifdef`**; **`$undef`** removes it like any other macro (see §9 and **`tests/unicon/macros.icn`**).

#### Implementation (function-like macros)

- **Data.** **`record preproc_fmacro(params, body)`** holds parameter names in order and the replacement text. **`preproc_fun_table[name]`** stores function-like macros; **`preproc_sym_table`** holds object-like text. A name is either function-like or object-like, not both; **`$define`** updates one table and clears the other (**`preproc_scan_directive()`**, **`"define"`** branch).
- **Parsing a definition.** After **`$define`** and the macro name, **`preproc_scan_define_fmacro()`** looks for **`(`**. If absent, parsing falls back to **`preproc_scan_define_value()`** for object-like macros. If **`(`** is present but the parameter list is malformed, **`preproc_fmacro_parse_error`** is set so the caller does **not** silently treat the line as a bad object-like **`$define`**.
- **`$define` body.** **`preproc_scan_define_value()`** collects text to end-of-line rules; a trailing **`\`** (last non-space on the line) splices the next physical line via **`preproc_define_value_next_line()`**, which appends to **`&subject`** and fixes **`preproc_print_line`** for **`#line`** (same idea as macro-argument continuation).
- **Recognizing a call.** In **`preproc_scan_text()`**, after skipping strings and **`#`** comments, an identifier that appears in **`preproc_fun_table`** is only treated as a call if **`preproc_expand_fmacro_call()`** sees **`(`** after optional space; otherwise **`&pos`** is restored and the identifier can match an object-like macro or stay plain text.
- **Arguments.** **`preproc_scan_macro_args()`** splits at top-level commas, respects paren depth, and keeps **`"..."` / `'...'`** opaque; **`preproc_macro_arg_next_line()`** appends lines when **`)`** has not been seen—separate from **`\`** line continuation on **`$define`** values.
- **Expansion.** User-defined function-like macros use **`preproc_subst_fmacro()`** to replace whole formal identifiers in **`body`**. The result string is fed back through **`preproc_scan_text(done_set)`** so nested and recursive expansions resolve in one pipeline; **`done_set`** blocks infinite recursion.

### 7.3 Built-in `assert` and `assert_not`

The preprocessor registers **`assert`** and **`assert_not`** as function-like builtins (`preproc_install_builtin_macros()`, **`preproc_builtin_fun_table`**) with special expansion in **`preproc_expand_fmacro_call()`**.

| Mode | Enable | On failure |
|------|--------|------------|
| **Debugging** | **`$define __debug__`** or **`-D__debug__`** | Diagnostic output, then **`runerr(219, …)`** (**`assert`**) or **`runerr(220, …)`** (**`assert_not`**) — see **`src/runtime/data.r`**, **`errmsg.r`**, **`rdebug.r`**. |
| **Testing** | **`$define __test__`** or **`-D__test__`** | Same **`write`**-style line, then **`fail`** (Unicon failure). Defining **`__test__`** also enables **`__debug__`** in the preprocessor table so conditions compile. |
| **Release** | neither | Expands to **nothing** (no tokens, no cost). |

If both **`__test__`** and **`__debug__`** are defined, the **testing** path (**`fail`**) wins.

**Semantics** follow Unicon **success** / **failure**, not Boolean truth: **`assert(expr)`** expects **`expr`** to succeed; **`assert_not(expr)`** expects **`expr`** to fail.

**Statement-only.** These macros are intended as **standalone statements**. When disabled, expansion is empty—**expression** positions (e.g. **`if assert(…)`**) are **not** supported and can leave invalid syntax. That is deliberate: empty expansion is only well-defined on its own line (see **§7.3**).

**Override.** **`$undef assert`** then **`$define assert(...)`** replaces the builtin like any user function-like macro.

**Tests:** `assert_debugging.icn`, `assert_testing.icn`, `assert_strip.icn`, `assert_failing_label.icn`, `assert_not_failing.icn`, matching **`stand/*.std`**.

```icon
$define __debug__
procedure main()
   local x
   x := 1
   assert(x = 1)
   assert_not(x = 2)
end
```

#### Implementation (assert / assert_not)

- **Registration.** **`preproc_install_builtin_macros()`** (from **`preproc_new()`**) inserts **`assert`** and **`assert_not`** into **`preproc_fun_table`** as **`preproc_fmacro`** records with placeholder bodies, and sets **`preproc_builtin_fun_table[name]`** so expansion is special-cased.
- **Dispatch.** **`preproc_expand_fmacro_call()`** checks **`member(preproc_builtin_fun_table, name)`** before generic substitution. For **`assert`** / **`assert_not`**, it parses one or two argument strings (defaulting the label to **`""`**), then builds a large **Unicon source string** **`expanded`** instead of using **`preproc_subst_fmacro()`**.
- **Modes.** If **`__test__`** is enabled (**`preproc_sym_enabled`**, including the implicit interaction with **`__debug__`** from **`preproc_new`** when **`__test__`** is defined), the expansion uses **`write`** + **`fail`**. If only **`__debug__`**, it uses **`runerr(219, …)`** or **`runerr(220, …)`**. If neither symbol is set, **`expanded`** is **`""`**—the call disappears entirely (**no tokens**).
- **Uniqueness.** **`preproc_assert_uid`** increments each time so generated temporaries (e.g. **`__preproc_assert_N_lbl`**) do not collide when several assertions appear in one scope.
- **Rescan.** The generated fragment is run through **`expanded ? preproc_scan_text(done_set)`** so any nested macros in the inserted code expand consistently.
- **Overrides.** **`$undef assert`** removes the builtin entry from both **`preproc_fun_table`** and **`preproc_builtin_fun_table`**; a later user **`$define assert …`** is then ordinary function-like macro handling.

### 7.4 Implementation map (new features)

| Concern | Primary routines / types (`uni/unicon/preproce.icn`) |
|---------|------------------------------------------------------|
| Triple-quoted strings | `preproc_rewrite_triple_strings()`, `preproc_quote_string()`, `preproc_octal_escape()` |
| Function-like macros | `record preproc_fmacro(params, body)`, `preproc_scan_define_fmacro()`, `preproc_scan_macro_args()`, `preproc_macro_arg_next_line()`, `preproc_subst_fmacro()`, `preproc_expand_fmacro_call()` |
| `$define` value / **`\`** splice | `preproc_scan_define_value()`, `preproc_define_value_next_line()` |
| Assertions | Special cases for **`"assert"`** / **`"assert_not"`** in `preproc_expand_fmacro_call()` |

---

## 8. Control flow (technical detail)

### 8.1 Generator interface and compiler hook

`preprocessor()` is a **generator**: each output line is **`suspend`**ed. The compiler drains it into **`yyin`** and checks **`preproc_err_count`** and **`parsingErrors`** before calling **`yyparse()`** (`iconc_yyparse()` in `uni/unicon/unicon.icn`). Failed preprocessing aborts compilation after printing accumulated errors.

### 8.2 String scanning and `&subject`

Most work uses Icon/Unicon **pattern matching** on the current line: **`line ? { … }`** sets **`&subject`** to `line` and **`&pos`** to the cursor. Directives read tokens with **`preproc_word()`**, **`preproc_qword()`**, etc. Text expansion walks the same string, mutating **`&subject`** when triple-quoted regions are rewritten in place (`preproc_rewrite_triple_strings()`).

### 8.3 Main loop decision tree

For each line from **`preproc_read()`**:

1. **`preproc_space()`** — Consumes leading horizontal/vertical whitespace.
2. **`#` + `line`** — Only this **`#`** form is handled as a directive in the driver; **`preproc_dollar_or_pound`** records **`#`** for the **`"line"`** directive’s error paths.
3. **`$` + `nonpunctuation`** — Any **`$`** that is followed by a character in **`nonpunctuation`** triggers **`preproc_scan_directive()`**. A **`$`** that begins an identifier attached to prior text (e.g. after a letter) is not recognized here; the line falls through to **`preproc_scan_text()`**, which is how **`x$y`** is not treated as a directive.
4. **Else** — **`&pos := 1`** and **`preproc_scan_text()`** processes the full line (comments, strings, macros, triple quotes).

There is **no** second pass over the same line for a different mode: each input line is classified once.

### 8.4 Conditional compilation and `/` vs `\`

Directive bodies that **mutate** symbol tables (`$define`, `$undef`, `$include`, …) or that should **only run in “active” source** are guarded with **`if /preproc_if_state then`** in **`preproc_scan_directive()`**.

In Unicon, **`/x`** is the **null** test (succeeds when `x` is the null value) and **`\x`** is the **nonnull** test — see the language reference (`/ x` and `\ x` in `doc/book/langref.tex`). After **`$ifdef`**, when the **true** branch is taken, **`preproc_if_state`** is set to **null** (emit code); when the **false** branch is taken, it is **`"false"`** or **`"off"`** (skip). So **`/preproc_if_state`** means “we are in an **active** branch (or top level).”

**`preproc_scan_text()`** also starts with **`if /preproc_if_state then`**: in skipped regions, no triple-string rewrite and no macro expansion occur (the procedure returns without emitting).

### 8.5 Order of work inside active text

When **`/preproc_if_state`** succeeds:

1. **`preproc_rewrite_triple_strings()`** — Runs before identifier scans so triple-quoted text never looks like directives or macros.
2. If either symbol table is non-empty, scan for **`#`**, strings, and identifiers; otherwise emit the line with only **`preproc_sync_lines()`** (no macro expansion path).
3. **Function-like** lookup before **object-like** on each identifier; failed **`()`** parse rewinds **`&pos`** so the name can still match an object-like macro.
4. Recursive **`preproc_scan_text()`** on replacements passes **`done_set`** to detect **recursive macro expansion** cycles.

### 8.6 Input and `preproc_read()`

**`preproc_read()`** increments **`preproc_line`**, returns a line from **`read()`** or from a **list** “file,” and on EOF pop **`preproc_file_stack`**, close files, and remove **`preproc_include_name`** from **`preproc_include_set`**. Nested **`$ifdef`** depth is checked against **`preproc_nest_level`** when unwinding. Any code that **appends** lines (string continuation, macro arguments) calls **`preproc_read()`** again and adjusts **`preproc_print_line`** so **`#line`** output stays aligned (see **§7.2**, multiline macro calls).

### 8.7 Suspend points and `#line`

**`preproc_scan_text()`** may **`suspend`** multiple times per logical line (e.g. string pieces, sync). **`preproc_sync_lines()`** emits **`#line`** directives or blank lines so the **next** emitted source line matches **`preproc_filename`** / **`preproc_line`**. Debugger and error messages depend on this staying consistent when adding new features that insert or remove lines.

---

## 9. Adding a new feature (maintainer checklist)

Use this as a guide when extending **`preproce.icn`**; not every item applies to every change.

### 9.1 Decide what kind of feature it is

| Kind | Typical touchpoints |
|------|---------------------|
| **New or changed `$` directive** | **`preproc_scan_directive()`**: add a **`case`** label; set **`preproc_command`** before errors; guard with **`if /preproc_if_state then`** when the directive must not run inside false **`$ifdef`** branches. |
| **Object-like macro behavior** | **`preproc_sym_table`**, **`preproc_scan_text()`** substitution path, **`preproc_defined()`**. |
| **Function-like macro behavior** | **`preproc_fun_table`**, **`preproc_scan_define_fmacro()`**, **`preproc_expand_fmacro_call()`**, **`preproc_subst_fmacro()`**, **`preproc_scan_macro_args()`**. |
| **Built-in “special” function macro** (like **`assert`**) | **`preproc_install_builtin_macros()`**, **`preproc_builtin_fun_table`**, and a branch in **`preproc_expand_fmacro_call()`**; document interaction with **`$undef`**. |
| **New source syntax rewritten to plain Unicon** | Often a phase in **`preproc_scan_text()`** (before or after existing phases) or a dedicated scan; must respect strings, comments, and **`#`** comment rules. |
| **New predefined symbol** | **`predefs()`** and/or **`uni/unicon/unicon.icn`** where **`-D`** merges into **`uni_predefs`**. |

User-visible behavior for the newer facilities is summarized in **§7**. Illustrative maintainer snippets for several checklist rows appear in **§9.8**; not every kind needs a full code example (e.g. extending function-like substitution touches several cooperating procedures—follow existing **`assert`** / **`preproc_subst_fmacro()`** patterns in **`preproce.icn`**).

### 9.2 Conditional compilation and side effects

- Directives that **define**, **undef**, or **include** should follow the same **`if /preproc_if_state`** pattern as existing directives so they do not run when code is stripped out.
- Directives that only **adjust parser state** in skipped regions may need the opposite pattern (see **`ifdef`** / **`$if`** handling).

**Example (conceptual).** A fictional **`$tag "info"`** directive that only runs in **active** source. **Implementation** (new branch in **`preproc_scan_directive()`**):

```text
"tag": {
   if /preproc_if_state then {
      if s := preproc_qword() & preproc_at_end() then {
         # ... store s somewhere, or call preproc_error("bad $tag")
      } else preproc_error()
   }
}
```

**Unicon source** that this preprocessor would parse (hypothetical directive; not in stock **`preproce.icn`**):

```icon
# Tag metadata on an ordinary line (implementation would record "info" somewhere).
$tag "info"

# Inside a false $ifdef region, the $tag branch body does not run (/preproc_if_state fails).
$ifdef NEVER_DEFINED_SYMBOL
$tag "not_executed"
$endif

$define NEVER_DEFINED_SYMBOL 1
$ifdef NEVER_DEFINED_SYMBOL
$tag "executed"
$endif
```

A directive that must **parse** nested **`$if`** structure inside a false branch (like **`$ifdef`** itself) uses different guards—copy the **`ifdef` / `$if` / `else` / `endif`** structure rather than inventing a new pattern from scratch.

### 9.3 Line numbers and debugging

- If the feature **reads extra lines** or **changes output length**, verify **`preproc_line`**, **`preproc_print_line`**, and **`preproc_sync_lines()`** behavior; run tests with **`-E`** (preprocess only) and check **`#line`** output.
- If you **suspend** multiple outputs per input line, ensure each path is consistent with **`preproc_print_line`** updates at the end of **`preproc_scan_text()`**.

**Example.** From the build directory or with **`unicon`** on your **`PATH`**:

```bash
unicon -E mytest.icn
```

**Sample `mytest.icn`** (so **`-E`** output is non-trivial: macros, **`#line`**, and ordinary code):

```icon
$define GREETING "hi"
procedure main()
   write(GREETING)
end
```

Inspect the emitted Unicon source on standard output (or redirect to a file). Compare **`#line`** directives against the original **`mytest.icn`** when your feature inserts, deletes, or merges lines.

### 9.4 Errors

- Use **`preproc_error(msg)`**; set **`preproc_command`** where applicable so messages include **`$directive:`**.
- Compiler exit depends on **`preproc_err_count`** and **`parsingErrors`** in **`unicon.icn`**.

**Example.** After **`preproc_command := preproc_word()`** has set the directive name, a failed parse might call **`preproc_error("expected one argument")`**. The user may see something like:

```text
File foo.icn; Line 1 # $mydirective: expected one argument
```

**Unicon source** that could trigger it (fictional **`$mydirective`** requiring one quoted argument):

```icon
$mydirective
```

Here the directive name is recognized but the rest of the line fails validation (no argument), so **`preproc_error("expected one argument")`** (or similar) runs after **`preproc_command`** is set to **`mydirective`**.

### 9.5 Tests and documentation

- Add or extend tests under **`tests/unicon/`** (and **`stand/`** expected output); small focused cases beat large integration dumps.
- Update **§7** when user-visible semantics of these extensions change.
- Keep this design report (**§§7–10**) in sync when architecture changes (new globals, new phases).

**Example.** Pair a driver **`tests/unicon/feature_foo.icn`** with expected preprocessor or runtime output **`tests/unicon/stand/feature_foo.std`**, following naming used by **`macros.icn`** / **`macros.std`**. For error cases, **`tests/unicon/data/`** sometimes holds small fragments included or compiled only for failure paths.

**Minimal driver** (illustrative):

```icon
$define TEST 1
procedure main()
   write(TEST)
end
```

**Minimal `stand/feature_foo.std`** might be the expected **`write`** output (one line), or the expected preprocessed text if the test runs **`-E`** and compares output.

### 9.6 `uni/parser/` copy

The canonical source is **`uni/unicon/preproce.icn`**. If the standalone parser build still ships a duplicate under **`uni/parser/`**, any merge policy must be coordinated (see §10.4); avoid divergent behavior between copies.

### 9.7 Exploration tips

- Trace with **`-E`** and a tiny **`.icn`** file to see exact preprocessed output.
- Read **`preproc_scan_directive()`** and **`preproc_scan_text()`** in full; most bugs are **cursor position** (`&pos`) or **conditional** guards.
- For **recursive expansion**, follow **`done_set`** through **`preproc_scan_text()`** and **`preproc_expand_fmacro_call()`**.

### 9.8 More examples (by feature kind)

The following are **illustrative** only; names and APIs are abbreviated for readability.

**New `$` directive (new `case` label).** After **`preproc_command := preproc_word()`**, the **`case preproc_command of {`** dispatches. Add a string label matching the word users will write after **`$`**:

```text
"mydir": {
   if /preproc_if_state then {
      # parse remainder of line; on failure:
      preproc_error("optional detail")
   }
}
```

**Unicon source** the line-oriented driver would then feed into **`preproc_scan_directive()`** (first token after **`$`** is **`mydir`**):

```icon
$mydir optional tokens on the rest of this line
```

Place the **`case`** branch alongside others in **`preproc_scan_directive()`**; unknown directives still fall through to **`default`** and **`preproc_error("unknown preprocessor directive")`** when active.

**New predefined symbol in `predefs()`.** Append to the table **`t`** before **`return t`**:

```text
t["MY_FEATURE"] := "1"
```

**Unicon source** that **uses** that symbol (after recompiling the translator with the updated **`predefs()`**):

```icon
$ifdef MY_FEATURE
procedure use_new_stuff()
   # compiled only when MY_FEATURE is defined
end
$endif
```

You can also test with **`$ifdef MY_FEATURE`** after defining it via **`$define MY_FEATURE 1`** in the same file; **`predefs()`** is for symbols that should exist **before** any user **`$define`**.

**`-D` symbol from the compiler driver.** Merging into **`uni_predefs`** is handled in **`uni/unicon/unicon.icn`** (search for **`uni_predefs`** and **`-D`**). You usually do **not** patch that for a simple **`predefs()`** addition; you **do** when the symbol must reflect **runtime** flags or options not known inside **`predefs()`** alone.

**Unicon source** using a **command-line** definition:

```icon
$ifdef FOO
procedure only_when_dash_D()
end
$endif
```

Compile with:

```bash
unicon -DFOO prog.icn
```

**Object-like macro (user source).** No change to **`preproce.icn`** is required for ordinary use:

```icon
$define GREETING "hello"
procedure main()
   write(GREETING)
end
```

Implementation-wise, **`GREETING`** lives in **`preproc_sym_table`** and is expanded in **`preproc_scan_text()`**.

**Function-like macro (user source).** Users write **`$define`** with a parameter list; the implementation uses **`preproc_fun_table`** + substitution. Example:

```icon
$define SUM(a,b) ((a) + (b))
procedure main()
   write(SUM(3, 4))
end
```

More cases (nesting, multiline calls) are in **§7.2** and **`tests/unicon/macros.icn`**.

**Built-in special macro.** There is no short implementation template; see **`preproc_install_builtin_macros()`**, **`preproc_builtin_fun_table`**, and **`preproc_expand_fmacro_call()`** for **`assert`** / **`assert_not`**. **Unicon source** using the built-ins:

```icon
$define __debug__
procedure main()
   assert(1 = 1, "label")
end
```

With **`__debug__`** or **`__test__`**, the call expands to runtime checks; with neither defined, the call is removed at preprocess time (see **§7.3**).

**Rewrite pass in `preproc_scan_text()`.** Triple-quoted regions are handled by **`preproc_rewrite_triple_strings()`** before macro expansion. **Unicon source**:

```icon
procedure main()
   local s
   s := """
line1
line2
"""
   write(s)
end
```

New logic that edits the line usually runs **after** that rewrite (if it must see normal quotes) or **before** macro expansion (if it must see raw **`$`** text—rare). Compare the call order in **§8.5**.

---

## 10. Related documents and sources

### 10.1 Technical reports and language reference

| Document | Content |
|----------|---------|
| [UTR #15](unicon/utr15.html) | How to write and submit a Unicon Technical Report. |
| [UTR #8](unicon/utr8.html) — *Unicon Language Reference* | Core syntax; Appendix-style **Preprocessor** section in the book sources (`doc/book/langref.tex`, § “Preprocessor”) lists `$define`, `$include`, `$ifdef`, `$error`, `$line` / `#line`, `$undef`, EBCDIC transliterations. **Staleness:** that section still states that `$define` does not take arguments; see **§7** for function-like macros and newer behavior. |
| Other UTRs | Occasional `$include` / `$define` in examples (e.g. UTR #22 OpenGL guide); not design documentation for `preproce.icn`. |

### 10.2 *Programming with Unicon* book (`doc/book/`)

`doc/book/langref.tex` contains the authoritative LaTeX for the language reference preprocessor section (same material as UTR #8 in published form). Other chapters use `$include` and `$define` in examples (`gui.tex`, `internet.tex`, `cgi.tex`, etc.) without describing implementation.

### 10.3 Implementation book (`doc/ib/`)

`doc/ib/p3-unicon.tex` includes a section **“The Unicon Preprocessor”** (Part 3, compiler front end). It covers Jcon/Bob Alexander provenance, `uni/unicon/preproce.icn`, the generator interface `preprocessor(fName, uni_predefs)`, integration with **`yyin`** (line-by-line accumulation vs. the lexer’s “big inhale”), stacks for `$ifdef` and `$include`, `preproc_include_set`, `preproc_scan_directive` / `preproc_scan_text`, quoted-string skipping, and underscore continuation. It notes a **design tension**: line-oriented preprocessor output vs. lexical analysis style, and suggests a possible “big inhale” for `preproc_read()`.

**Staleness:** that section describes **object-like** macros only (“macros do not have parameters”, “600+ line file”). The current `preproce.icn` is larger and includes function-like macros, built-in assertions, and triple-quoted strings; treat **§7** of this report as the up-to-date description of those features.

Other `doc/ib/` hits are about **different** preprocessors (Icon translator “Idol”, Ratfor, **rtt**’s C preprocessor in `app-rtl.tex`, PPDirectives in `appH.tex`), not Unicon’s `preproce.icn`.

### 10.4 Compiler wiring (`uni/unicon/`, `uni/parser/`)

The translator accumulates preprocessed source in **`yyin`**: `every yyin ||:= preprocessor(fname, uni_predefs) do yyin ||:= "\n"` in `uni/unicon/unicon.icn`, with `uni_predefs` built from `predefs()` and augmented from `-D` style options. That file is the right place to see how the preprocessor connects to parsing.

`uni/parser/` builds a standalone parser toolkit; its `Makefile` lists `preproce.u`, and **`uni/parser/preproce.icn` is a separate, shorter copy** that **does not** match `uni/unicon/preproce.icn` (canonical implementation is under **`uni/unicon/`**).

---

## References

1. Bob Alexander. Preprocessor for Jcon (basis for Unicon’s `preproce.icn`).
2. Clinton Jeffery. *How to Write a Unicon Technical Report.* UTR #15, `doc/utr/utr15.tex`.
3. Clinton Jeffery. *The Unicon Compiler* (course notes), `doc/ib/p3-unicon.tex`, § “The Unicon Preprocessor”.
