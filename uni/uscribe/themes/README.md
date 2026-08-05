# Themes for uscribe HTML output
#
# HTML structure is fixed in HtmlOutputter; a theme is a directory of
# static assets (mainly book.css) selected with --theme=NAME. Shared JS
# lives in _shared/.
#
# Layout of this directory:
#   themes/<name>/theme.conf     # name metadata
#   themes/<name>/static/book.css
#   themes/_shared/search.js     # copied into every build's _static/
#
# Resolution order for --theme=NAME (see main.icn):
#   1. <themePath>/NAME   (--themePath, default: themes next to uscribe)
#   2. ./themes/NAME      (cwd, so a book can ship overrides)
#
# Built-in themes:
#   basic   -- default light sidebar (current look)
#   classic -- serif headings, warm gray sidebar docs style
#   dark    -- dark background variant
