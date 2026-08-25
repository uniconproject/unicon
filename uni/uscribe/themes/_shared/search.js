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
      var shown = [];
      var i, j;
      for (i = 0; i < items.length; i++) {
        var text = (items[i].textContent || "").toLowerCase();
        shown[i] = !q || text.indexOf(q) !== -1;
      }
      if (q) {
        for (i = 0; i < items.length; i++) {
          if (!shown[i]) continue;
          var p = items[i].parentElement;
          while (p && p.id !== "nav-toc") {
            if (p.tagName === "LI") {
              for (j = 0; j < items.length; j++) {
                if (items[j] === p) {
                  shown[j] = true;
                  break;
                }
              }
            }
            p = p.parentElement;
          }
        }
      }
      for (i = 0; i < items.length; i++) {
        if (shown[i]) items[i].classList.remove("hidden");
        else items[i].classList.add("hidden");
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
