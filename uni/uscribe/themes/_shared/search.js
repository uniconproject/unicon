/* Filter the sidebar TOC; full-text search uses search.html + searchindex.js */

(function () {
  function ready(fn) {
    if (document.readyState !== "loading") fn();
    else document.addEventListener("DOMContentLoaded", fn);
  }

  ready(function () {
    var input = document.getElementById("nav-search");
    var list = document.getElementById("nav-toc");
    if (!input || !list) return;

    input.addEventListener("input", function () {
      var q = (input.value || "").toLowerCase().trim();
      var items = list.querySelectorAll("li");
      for (var i = 0; i < items.length; i++) {
        var li = items[i];
        var text = (li.textContent || "").toLowerCase();
        if (!q || text.indexOf(q) !== -1) li.classList.remove("hidden");
        else li.classList.add("hidden");
      }
    });

    input.addEventListener("keydown", function (ev) {
      if (ev.key === "Enter") {
        ev.preventDefault();
        window.location.href = "search.html?q=" + encodeURIComponent(input.value || "");
      }
    });
  });
})();
