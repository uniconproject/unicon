SHELL=/bin/sh
MAKE=make

Test-ipl-icont:
		sh ./Test

Clean:
		rm -f local/*

# Entries beyond this point are for use at Arizona only.
#   *** Do not delete the line above; it is used in trimming Makefiles
#   for distribution ***

Dist-clean:
		rm -f *.K* .emacs*
		rm -f local/*
		touch local/.placeholder
		rm -rf `gcomp Makefile Test local stand *.icn`
