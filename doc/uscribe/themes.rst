Themes
======

HTML chrome (sidebar, search, prev/next on book chapters) is fixed in the generator.
A *theme* is a CSS skin plus shared JavaScript.

Built-in themes
---------------

- **basic** — light sidebar (default)
- **classic** — serif / warm-gray documentation look
- **dark** — dark background

All three are installed into ``out/_static/`` as ``theme-NAME.css``.
Readers pick a theme from the **Theme** dropdown in the sidebar; the
choice is stored in the browser (``localStorage`` key
``uscribe-theme``).

Build-time default
------------------

.. code-block:: sh

   uscribe ... --theme=classic --themePath=../themes

``theme`` and ``themePath`` may also be set in ``book.conf``
(see :doc:`config`).

Or with the sample Makefiles:

.. code-block:: sh

   make          # THEME=basic
   make classic
   make dark

``--theme`` only sets the *initial* stylesheet until the reader
selects another in the UI.

Theme layout on disk
--------------------

.. code-block:: text

   themes/
     basic/static/book.css
     classic/static/book.css
     dark/static/book.css
     _shared/search.js
     _shared/highlight.css
     _shared/highlight-unicon.js
     _shared/theme-switcher.js

To add a custom theme, create ``themes/mytheme/static/book.css`` and
pass ``--theme=mytheme``. Keep the same HTML class names
(``.sidebar``, ``.main``, ``.tok-keyword``, …) so shared scripts keep
working.

See ``themes/README.md`` in the source tree for layout details.
