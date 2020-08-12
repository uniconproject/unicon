BASE=../..
include $(BASE)/Makedefs.uni

.PHONY: all clean deps

UFILES=gui.u file_dlg.u db.u \
 address.u base64handler.u basicclasscoding.u class.u classcoding.u \
 cltable.u comparator.u complex.u compoundedit.u contentdisposition.u contenttype.u \
 cvsuser.u cvsutil.u decode.u encode.u encodinghandler.u error.u format.u \
 fcn_util.u group.u httpclient.u json.u langprocs.u listener.u \
 mailbox.u mailmisc.u mapbytes.u message.u messagehandler.u method.u \
 money.u msg.u multipart.u multiparthandler.u netclient.u noophandler.u object.u \
 popclient.u predicat.u process.u property.u pushback.u qsort.u quotedprintablehandler.u \
 rfc822parser.u runnable.u args.u blockread.u exception.u notifier.u \
 selectiveclasscoding.u sem.u setfields.u shm.u smtpclient.u str_util.u \
 stringbuff.u misc_util.u heap.u scan_util.u str_replacer.u \
 texthandler.u time.u timezone.u typehandler.u \
 undoableedit.u undomanager.u url.u webup.u \
 notification.u md5.u httprequest.u httpresponse.u \
 thread.u matrix_util.u struct.u db_util.u database.u addressdb.u

# COPYINS are library files copied in from other directories for
# organizational purposes. Inspired by ipl/lib.  They have to be
# compiled in this directory in order for the class specification
# database to work.
COPYINS=selection3D.u

all: $(UFILES) $(COPYINS)

selection3D.u: ../3d/selection3D.icn
	cp ../3d/selection3D.icn .
	$(UNICON) $(UFLAGS) -c selection3D.icn
	rm selection3D.icn

deps:
	$(UNIDEP) *.icn -nb -f deps.out

deps.out: ;

clean:
	$(RM) *.u uniclass.dir uniclass.pag uniclass.db

tar:
	tar zcvf guifiles.tgz gui.icn makefile *.icn

include deps.out
