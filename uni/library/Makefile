
.PHONY: all clean

UFILES=classobject.u errorsystem.u runtimeerrors.u utilities.u

all: $(UFILES)

clean:
	rm *.u uniclass.dir uniclass.pag

classobject.u: classobject.icn errorsystem.u
	unicon -c classobject

errorsystem.u: errorsystem.icn runtimeerrors.u utilities.u
	unicon -c errorsystem

runtimeerrors.u: runtimeerrors.icn
	unicon -c runtimeerrors

utilities.u : utilities.icn
	unicon -c utilities

