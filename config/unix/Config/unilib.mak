BASE=../..
include ../makedefs

.PHONY: all clean deps

UFILES=gui.u file_dlg.u font_dlg.u db.u \
 address.u base64handler.u basicclasscoding.u class.u classcoding.u \
 cltable.u comparator.u compoundedit.u contentdisposition.u contenttype.u cvsuser.u \
 cvsutil.u decode.u encode.u encodinghandler.u error.u format.u \
 group.u httpclient.u httppage.u langprocs.u listener.u \
 mailbox.u netclient.u mailmisc.u message.u messagehandler.u method.u \
 money.u msg.u multipart.u multiparthandler.u noophandler.u object.u \
 popclient.u process.u qsort.u quotedprintablehandler.u rfc822parser.u runnable.u \
 selectiveclasscoding.u sem.u setfields.u shm.u smtpclient.u str_util.u stringbuff.u \
 texthandler.u time.u timezone.u typehandler.u undoableedit.u undomanager.u url.u \
 socket.u event.u

all: $(UFILES)

deps:
	$(UNIDEP) *.icn -nb -f deps.out

deps.out: ;

clean:
	$(RM) *.u uniclass.dir uniclass.pag

tar:
	tar zcvf guifiles.tgz gui.icn makefile *.icn

include deps.out
