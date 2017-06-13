#  Makefile for configuring a Unix build.
#
#  (make Setup name=xxx_yyy)

name = undefined
TOP = ../..
SRC = $(TOP)/src

Setup-Common:
	cd Config; $(MAKE) Makefiles name=$(name)
	cp $(name)/rswitch.[cs] $(SRC)/common
	echo 'AC_JV_LDFLAGS= @JV_LDFLAGS@' > $(TOP)/Makedefs
	echo 'AC_GL_LDFLAGS= @GL_LDFLAGS@' >> $(TOP)/Makedefs
	echo 'AC_LIBS= @LIBS@' >> $(TOP)/Makedefs
	echo 'AC_GL_CFLAGS= @GL_CFLAGS@' >> $(TOP)/Makedefs
	echo 'AC_LDFLAGS= @LDFLAGS@' >> $(TOP)/Makedefs
	cat $(name)/Makedefs >> $(TOP)/Makedefs
	cp $(TOP)/Makedefs $(TOP)/Makedefs.in
	echo ''					>> $(TOP)/Makedefs
	if [ -f $(name)/custom.sh ]; then cd $(name); sh custom.sh; fi

Setup-NoGraphics: Setup-Common
	echo '# Graphics not enabled'		>> $(TOP)/Makedefs

Setup-Graphics:  Setup-Common
	echo '# Graphics enabled'		>> $(TOP)/Makedefs
	echo 'XL = -L../../bin -lXpm $$(XLIBS)'	>> $(TOP)/Makedefs
	echo 'XPM=xpm'				>> $(TOP)/Makedefs
	echo '# Graphics enabled'		>> $(TOP)/Makedefs.in
	echo 'XL = -L../../bin -lXpm $$(XLIBS)'	>> $(TOP)/Makedefs.in
	echo 'XPM=xpm'				>> $(TOP)/Makedefs.in
	echo 'DRAWSTRING=drawstring3d.o'	>> $(TOP)/Makedefs.in
	echo 'COMMONDRAWSTRING=../common/drawstring3d.o'	>> $(TOP)/Makedefs.in

Setup-Thin: Setup-Common
	cp $(name)/Makedefs $(TOP)/Makedefs
	echo '#define NoAuto 1'			>> $(SRC)/h/define.h

Clean:


Pure:
	rm -f $(TOP)/Makedefs
	rm -f $(SRC)/common/rswitch.[csS]
