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
#   1. <themePath>/NAME   (--themePath or book.conf themepath)
#   2. ./themes, ../themes, themes  (cwd, so a book can ship overrides)
#   3. Unicon tree: $(Binaries at)/../uni/uscribe/themes
#      or $(Libraries at)/uni/uscribe/themes
#
# A book-local themepath may contain only the skins it overrides.
# Missing _shared/ and basic/classic/dark are filled from Unicon.
#
# Built-in themes:
#   basic   -- default light sidebar (current look)
#   classic -- serif headings, warm gray sidebar docs style
#   dark    -- dark background variant
