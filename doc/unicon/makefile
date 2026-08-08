# Legacy man-page HTML was previously generated as utr11.html here.
# The Unicon man page now lives as doc/utr/utr11.rst (built under doc/utr/html/).
# General pages: rebuild HTML from RST with pandoc, e.g.
#   pandoc -s -f rst -t html5 faq.rst -o faq.html

.PHONY: html
html:
	pandoc -s -f rst -t html5 faq.rst -o faq.html
	pandoc -s -f rst -t html5 posix.rst -o posix.html
	pandoc -s -f rst -t html5 svn.rst -o svn.html
	pandoc -s -f rst -t html5 simple.rst -o simple.html
	pandoc -s -f rst -t html5 reports.rst -o reports.html
