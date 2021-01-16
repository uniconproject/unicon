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
 popclient.u predicat.u process.u pushback.u qsort.u quotedprintablehandler.u \
 rfc822parser.u runnable.u args.u blockread.u notifier.u \
 selectiveclasscoding.u sem.u setfields.u shm.u smtpclient.u scan_util.u \
 stringbuff.u misc_util.u heap.u str_util.u str_replacer.u \
 texthandler.u time.u timezone.u typehandler.u \
 undoableedit.u undomanager.u url.u webup.u \
 notification.u md5.u httprequest.u httpresponse.u exception.u \
 thread.u matrix_util.u struct.u db_util.u database.u addressdb.u \
 union.u pdb_util.u propertydb.u property.u

# COPYINS are library files copied in from other directories for
# organizational purposes. Inspired by ipl/lib.  They have to be
# compiled in this directory in order for the class specification
# database to work.
COPYINS=selection3D.u utf8.u

all: $(UFILES) $(COPYINS)

selection3D.u: ../3d/selection3D.icn
	cp ../3d/selection3D.icn .
	$(UNICON) $(UFLAGS) -c selection3D.icn
	rm selection3D.icn

utf8.u: ../utf8/utf8.icn classobject.u
	cp ../utf8/utf8.icn .
	$(UNICON) $(UFLAGS) -c utf8.icn
	rm utf8.icn

classobject.u: ../library/classobject.icn errorsystem.u
	cp ../library/classobject.icn .
	$(UNICON) $(UFLAGS) -c classobject.icn
	rm classobject.icn

errorsystem.u: ../library/errorsystem.icn runtimeerrors.u utilities.u
	cp ../library/errorsystem.icn .
	$(UNICON) $(UFLAGS) -c errorsystem.icn
	rm errorsystem.icn

runtimeerrors.u: ../library/runtimeerrors.icn
	cp ../library/runtimeerrors.icn .
	$(UNICON) $(UFLAGS) -c runtimeerrors.icn
	rm runtimeerrors.icn

utilities.u: ../library/utilities.icn
	cp ../library/utilities.icn .
	$(UNICON) $(UFLAGS) -c utilities.icn
	rm utilities.icn

deps:
	$(UNIDEP) *.icn -nb -f deps.out

deps.out: ;

clean:
	$(RM) *.u uniclass.dir uniclass.pag uniclass.db

tar:
	tar zcvf guifiles.tgz gui.icn makefile *.icn

include deps.out
