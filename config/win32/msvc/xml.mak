BASE=..\..
include ..\makedefs

UFILES=attlist.u attributedef.u canonicalxmlformatter.u cdata.u \
	comment.u contentspec.u defaulterrorhandler.u defaultresolver.u \
	doctype.u document.u element.u elementdecl.u entitydef.u \
	errorhandler.u externalid.u formatter.u globalname.u htmldocument.u \
	htmlelement.u htmlformatter.u htmlparser.u node.u notationdecl.u \
	parser.u processinginstruction.u resolver.u xmldecl.u xmldocument.u \
	xmlelement.u xmlformatter.u xmlparser.u

PROGS=testhtml.exe testxml.exe testpatterns.exe testvalid.exe \
	testnotwf.exe testinvalid.exe globaldemo.exe createdemo.exe

all: $(UFILES) $(PROGS)

clean:
	$(RM) *.u 
	$(RM) uniclass.dir 
	$(RM) uniclass.pag

include deps.out
