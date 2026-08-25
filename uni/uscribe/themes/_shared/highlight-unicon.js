/* Client-side Unicon / Icon syntax highlighting for uscribe code blocks.
 * Applied to <pre><code class="language-unicon"> (also language-icon).
 */

(function () {
  var KEYWORDS = {
    procedure:1, end:1, local:1, global:1, static:1, record:1, class:1,
    method:1, initially:1, import:1, package:1, if:1, then:1, else:1,
    while:1, every:1, do:1, next:1, break:1, return:1, suspend:1, fail:1,
    case:1, of:1, default:1, create:1, critical:1, thread:1, to:1, by:1,
    not:1, invocable:1, abstract:1, link:1, until:1, repeat:1, initial:1
  };

  var BUILTINS = {
    write:1, writes:1, read:1, reads:1, open:1, close:1, stop:1, select:1,
    Attrib:1, getserv:1, gethost:1, send:1, receive:1, system:1, integer:1,
    string:1, type:1, image:1, member:1, put:1, pull:1, pop:1, get:1,
    sort:1, map:1, repl:1, reverse:1, trim:1, left:1, right:1, center:1,
    find:1, match:1, upto:1, many:1, any:1, tab:1, move:1, pos:1, bal:1,
    key:1, insert:1, delete:1, copy:1, list:1, table:1, set:1, numeric:1
  };

  function escapeHtml(s) {
    return String(s)
      .replace(/&/g, "&amp;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;");
  }

  function highlightUnicon(src) {
    var out = "";
    var i = 0;
    var n = src.length;

    function peek() { return src.charAt(i); }
    function startsWith(s) { return src.slice(i, i + s.length) === s; }

    while (i < n) {
      // Line comment
      if (peek() === "#") {
        var c0 = i;
        while (i < n && src.charAt(i) !== "\n") i++;
        out += '<span class="tok-comment">' + escapeHtml(src.slice(c0, i)) + "</span>";
        continue;
      }

      // String
      if (peek() === '"') {
        var s0 = i;
        i++;
        while (i < n) {
          if (src.charAt(i) === "\\") { i += 2; continue; }
          if (src.charAt(i) === '"') { i++; break; }
          i++;
        }
        out += '<span class="tok-string">' + escapeHtml(src.slice(s0, i)) + "</span>";
        continue;
      }

      // Cset '...'
      if (peek() === "'") {
        var k0 = i;
        i++;
        while (i < n) {
          if (src.charAt(i) === "\\") { i += 2; continue; }
          if (src.charAt(i) === "'") { i++; break; }
          i++;
        }
        out += '<span class="tok-cset">' + escapeHtml(src.slice(k0, i)) + "</span>";
        continue;
      }

      // Keyword &name
      if (peek() === "&") {
        var a0 = i;
        i++;
        while (i < n && /[A-Za-z0-9_]/.test(src.charAt(i))) i++;
        out += '<span class="tok-keyword">' + escapeHtml(src.slice(a0, i)) + "</span>";
        continue;
      }

      // Number
      if (/[0-9]/.test(peek()) || (peek() === "." && /[0-9]/.test(src.charAt(i + 1)))) {
        var n0 = i;
        while (i < n && /[0-9]/.test(src.charAt(i))) i++;
        if (src.charAt(i) === ".") {
          i++;
          while (i < n && /[0-9]/.test(src.charAt(i))) i++;
        }
        out += '<span class="tok-number">' + escapeHtml(src.slice(n0, i)) + "</span>";
        continue;
      }

      // Identifier / keyword / builtin
      if (/[A-Za-z_]/.test(peek())) {
        var i0 = i;
        while (i < n && /[A-Za-z0-9_]/.test(src.charAt(i))) i++;
        var word = src.slice(i0, i);
        if (KEYWORDS[word])
          out += '<span class="tok-keyword">' + escapeHtml(word) + "</span>";
        else if (BUILTINS[word])
          out += '<span class="tok-builtin">' + escapeHtml(word) + "</span>";
        else
          out += '<span class="tok-ident">' + escapeHtml(word) + "</span>";
        continue;
      }

      // Operators / punctuation (single or multi-char Unicon ops)
      if ("~<>=!|&?:^+-*/%@.\\".indexOf(peek()) !== -1) {
        var o0 = i;
        // greedy multi-char ops
        var ops = ["|||", "||", ":=", "<-", "<->", "<=", ">=", "~=", "==", "===",
                   "~==", "++", "--", "**", "->", "=>", "?:", "??"];
        var matched = false;
        for (var oi = 0; oi < ops.length; oi++) {
          if (startsWith(ops[oi])) {
            i += ops[oi].length;
            matched = true;
            break;
          }
        }
        if (!matched) i++;
        out += '<span class="tok-op">' + escapeHtml(src.slice(o0, i)) + "</span>";
        continue;
      }

      // Default: one character
      out += escapeHtml(src.charAt(i));
      i++;
    }
    return out;
  }

  function highlightJson(src) {
    var out = "";
    var i = 0;
    var n = src.length;

    function peek() { return src.charAt(i); }

    while (i < n) {
      // Line comment (JSONC / many config samples)
      if (peek() === "/" && src.charAt(i + 1) === "/") {
        var c0 = i;
        while (i < n && src.charAt(i) !== "\n") i++;
        out += '<span class="tok-comment">' + escapeHtml(src.slice(c0, i)) + "</span>";
        continue;
      }
      if (peek() === "/" && src.charAt(i + 1) === "*") {
        var b0 = i;
        i += 2;
        while (i < n && !(src.charAt(i) === "*" && src.charAt(i + 1) === "/")) i++;
        if (i < n) i += 2;
        out += '<span class="tok-comment">' + escapeHtml(src.slice(b0, i)) + "</span>";
        continue;
      }

      if (peek() === '"') {
        var s0 = i;
        i++;
        while (i < n) {
          if (src.charAt(i) === "\\") { i += 2; continue; }
          if (src.charAt(i) === '"') { i++; break; }
          i++;
        }
        out += '<span class="tok-string">' + escapeHtml(src.slice(s0, i)) + "</span>";
        continue;
      }

      if (/[0-9\-]/.test(peek()) && (peek() !== "-" || /[0-9]/.test(src.charAt(i + 1)))) {
        var n0 = i;
        if (peek() === "-") i++;
        while (i < n && /[0-9]/.test(src.charAt(i))) i++;
        if (src.charAt(i) === ".") {
          i++;
          while (i < n && /[0-9]/.test(src.charAt(i))) i++;
        }
        if (src.charAt(i) === "e" || src.charAt(i) === "E") {
          i++;
          if (src.charAt(i) === "+" || src.charAt(i) === "-") i++;
          while (i < n && /[0-9]/.test(src.charAt(i))) i++;
        }
        out += '<span class="tok-number">' + escapeHtml(src.slice(n0, i)) + "</span>";
        continue;
      }

      if (/[A-Za-z_]/.test(peek())) {
        var i0 = i;
        while (i < n && /[A-Za-z0-9_]/.test(src.charAt(i))) i++;
        var word = src.slice(i0, i);
        if (word === "true" || word === "false" || word === "null")
          out += '<span class="tok-keyword">' + escapeHtml(word) + "</span>";
        else
          out += escapeHtml(word);
        continue;
      }

      if ("{}[]:,".indexOf(peek()) !== -1) {
        out += '<span class="tok-op">' + escapeHtml(src.charAt(i)) + "</span>";
        i++;
        continue;
      }

      out += escapeHtml(src.charAt(i));
      i++;
    }
    return out;
  }

  function ready(fn) {
    if (document.readyState !== "loading") fn();
    else document.addEventListener("DOMContentLoaded", fn);
  }

  ready(function () {
    var blocks = document.querySelectorAll(
      "pre code.language-unicon, pre code.language-icon, pre code.language-icn"
    );
    for (var b = 0; b < blocks.length; b++) {
      var el = blocks[b];
      el.innerHTML = highlightUnicon(el.textContent);
      el.parentElement.classList.add("highlight");
    }
    var jsonBlocks = document.querySelectorAll("pre code.language-json");
    for (var j = 0; j < jsonBlocks.length; j++) {
      var jel = jsonBlocks[j];
      jel.innerHTML = highlightJson(jel.textContent);
      jel.parentElement.classList.add("highlight");
    }
  });
})();
