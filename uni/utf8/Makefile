.PHONY: all clean

UFILES=utf8.u

all: $(UFILES) utf8testbed

clean:
	rm utf8testbed *.u uniclass.dir uniclass.pag utilities.icn \
    runtimeerrors.icn errorsystem.icn classobject.icn utf8testbed.diff \
    utf8testbed.output utf8testbed.icn

utf8.u: utf8.icn classobject.u
	unicon -c utf8

classobject.u: ../library/classobject.icn
	cp ../library/utilities.icn .
	cp ../library/runtimeerrors.icn .
	cp ../library/errorsystem.icn .
	cp ../library/classobject.icn .
	unicon -c utilities
	unicon -c runtimeerrors
	unicon -c errorsystem
	unicon -c classobject

utf8testbed: tests/utf8testbed.icn utf8.u
	cp tests/utf8testbed.icn .
	unicon utf8testbed
	utf8testbed &>utf8testbed.output
	diff utf8testbed.output tests/utf8testbed.std &>utf8testbed.diff

