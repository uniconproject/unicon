# uscribe documentation under doc/

This directory holds the **uscribe User Guide**, built with uscribe
(Unicon’s prose/book documentation generator in `uni/uscribe/`).

```sh
# from the unicon tree
make -C uni/uscribe          # build the uscribe tool
make -C doc/uscribe          # build this guide → out/index.html
```

Themes: `make basic`, `make classic`, or `make dark` in this directory.
Also `make latex` / `make pdf` when a TeX engine is installed.
