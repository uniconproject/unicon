BASE=../../../..
include $(BASE)/Makedefs.uni

.PHONY: all html library.out

all: library.ps library.text html

library.out:
	$(UNIDOC) -a -o $@

library.ps: library.doc library.out
	groff -Tps -ms library.doc >library.ps

library.text: library.doc library.out
	groff -Tascii -ms library.doc >library.text

html:
	$(RMDIR) html
	$(MKDIR) html
	$(UNIDOC) -a -o html -html

clean:
	$(RM) library.out library.ps library.text
	$(RMDIR) html
