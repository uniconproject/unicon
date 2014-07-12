#
# Makefile for unicon TR's
#
# Original motivation: build (simplified) HTM's from PDF for use by
# Unicon online help.
#

utr9c.html: utr9c.pdf htmlean
	pdftohtml -noframes utr9c.pdf
	./htmlean utr9c.html

htmlean: htmlean.icn
	unicon htmlean

