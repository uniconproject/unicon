SHELL=/bin/sh
MAKE=make

TARGETS=$(patsubst %.icn,%,$(wildcard *.icn))

what:
		@echo "what do you want to make?"

Clean:
		rm -f $(TARGETS) *.c *.h

clean:
		@rm -f $(TARGETS) *.c *.h

# Entries beyond this point are for use at Arizona only.
#   *** Do not delete the line above; it is used in trimming Makefiles
#   for distribution ***

Dist-clean:
		rm -f .*K* .emacs*
