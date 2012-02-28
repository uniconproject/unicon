ICONT=icont -u
UNICON=unicon
RM=rm -f

USRC= /home/ko/build/uni/unicon

U= unicon.u unigram.u unilex.u tree.u preproce.u idol.u unix.u \
   tokens.u yyerror.u main.u cip.u

default: unicon

unicon: $(U)
	$(ICONT) $(U)

preproce.u: preproce.icn
	$(ICONT) -c $<

%.u: $(USRC)/%.icn
	$(ICONT) -c $<

idol.u: $(USRC)/idol.icn
	$(UNICON) -c $<

unilex.u: $(USRC)/unilex.icn $(USRC)/ytab_h.icn
	$(ICONT) -c $<

tokens.u: $(USRC)/tokens.icn $(USRC)/ytab_h.icn
	$(ICONT) -c $<

#################  added by K.O. ################

include Makefile.noweb

# See the "U= " line above
cip.icn: cip.nw
	$(NOTANGLE) $< | $(ASSERT) | $(CPIF) $@
cip.u:	cip.icn
	$(ICONT) -c $<

clean:
	$(RM) unicon uniclass.dir uniclass.pag

