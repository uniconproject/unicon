BASE=../..
include $(BASE)/Makedefs.uni

.PHONY: all clean deps

UFILES=attlist.u attributedef.u canonicalxmlformatter.u cdata.u \
	comment.u contentspec.u defaulterrorhandler.u defaultresolver.u \
	doctype.u document.u element.u elementdecl.u entitydef.u \
	errorhandler.u externalid.u formatter.u globalname.u htmldocument.u \
	htmlelement.u htmlformatter.u htmlparser.u node.u notationdecl.u \
	parser.u processinginstruction.u resolver.u xmldecl.u xmldocument.u \
	xmlelement.u xmlformatter.u xmlparser.u webscraper.u

PROGS=testhtml$(EXE) testxml$(EXE) testpatterns$(EXE) testvalid$(EXE) \
	testnotwf$(EXE) testinvalid$(EXE) globaldemo$(EXE) createdemo$(EXE)

all: $(UFILES) $(PROGS)

clean:
	$(RM) $(PROGS) *.u uniclass.dir uniclass.pag uniclass.db

deps:
	$(UNIDEP) *.icn -f deps.out -nb

deps.out: ;

include deps.out
