#  Makefile for vib, the Visual Interface Builder
EXE=.exe
SHELL=/bin/sh

ICONT = nticont
IFLAGS = -us -G
ITRAN = $(ICONT) $(IFLAGS)

OBJ = vib.u vibbttn.u vibedit.u vibfile.u vibglbl.u \
	viblabel.u vibline.u viblist.u vibmenu.u vibradio.u \
	vibrect.u vibsizer.u vibslidr.u vibtalk.u vibtext.u

.gif.ps:
	giftoppm $< | ppmtopgm | pnmtops -scale .75 >$@

vib:	$(OBJ)
	$(ITRAN) -o vib$(EXE) $(OBJ)

vib.u: vib.icn
	$(ITRAN) -c vib.icn

vibbttn.u: vibbttn.icn
	$(ITRAN) -c vibbttn.icn

vibedit.u: vibedit.icn
	$(ITRAN) -c vibedit.icn

vibfile.u: vibfile.icn
	$(ITRAN) -c vibfile.icn

vibglbl.u: vibglbl.icn
	$(ITRAN) -c vibglbl.icn

viblabel.u: viblabel.icn
	$(ITRAN) -c viblabel.icn

vibline.u: vibline.icn
	$(ITRAN) -c vibline.icn

viblist.u: viblist.icn
	$(ITRAN) -c viblist.icn

vibmenu.u: vibmenu.icn
	$(ITRAN) -c vibmenu.icn

vibradio.u: vibradio.icn
	$(ITRAN) -c vibradio.icn

vibrect.u: vibrect.icn
	$(ITRAN) -c vibrect.icn

vibsizer.u: vibsizer.icn
	$(ITRAN) -c vibsizer.icn

vibslidr.u: vibslidr.icn
	$(ITRAN) -c vibslidr.icn

vibtalk.u: vibtalk.icn
	$(ITRAN) -c vibtalk.icn

vibtext.u: vibtext.icn
	$(ITRAN) -c vibtext.icn

$(OBJ):	vibdefn.icn


ipd doc: ipd265.ps

ipd265.ps:	ipd265.bibl fig1.ps fig2.ps
	bib -t stdn -p /r/che/usr/ralph/docs/reg.index <ipd265.bibl | \
	    psfig | psroff -t >ipd265.ps

clean Clean:
	rm -f vib *.ps *.u[12] app vibpro* core busy dlog
