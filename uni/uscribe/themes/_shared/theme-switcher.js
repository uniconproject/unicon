/* Runtime theme switcher: basic | classic | dark (localStorage) */

(function () {
  var KEY = "uscribe-theme";
  var THEMES = ["basic", "classic", "dark"];

  function themeHref(name) {
    return "_static/theme-" + name + ".css";
  }

  function applyTheme(name) {
    if (THEMES.indexOf(name) === -1) name = "basic";
    var link = document.getElementById("theme-css");
    if (link) link.href = themeHref(name);
    try { localStorage.setItem(KEY, name); } catch (e) {}
    var sel = document.getElementById("theme-select");
    if (sel && sel.value !== name) sel.value = name;
    document.documentElement.setAttribute("data-theme", name);
  }

  function currentTheme(fallback) {
    try {
      var t = localStorage.getItem(KEY);
      if (t && THEMES.indexOf(t) !== -1) return t;
    } catch (e) {}
    return fallback || "basic";
  }

  // Apply as early as this deferred script runs; head boot script
  // already set the link when possible.
  function ready(fn) {
    if (document.readyState !== "loading") fn();
    else document.addEventListener("DOMContentLoaded", fn);
  }

  ready(function () {
    var boot = document.documentElement.getAttribute("data-theme") || "basic";
    var theme = currentTheme(boot);
    applyTheme(theme);

    var sel = document.getElementById("theme-select");
    if (sel) {
      sel.value = theme;
      sel.addEventListener("change", function () {
        applyTheme(sel.value);
      });
    }
  });

  window.uscribeSetTheme = applyTheme;
})();
