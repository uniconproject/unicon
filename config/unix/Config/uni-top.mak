all :
	if [ -f iyacc/Makefile ] ; then \
		make -C iyacc ; \
	fi
	if [ -f unicon/makefile ] ; then \
		make -C unicon ; \
	fi
	if [ -f lib/makefile ] ; then \
		make -C lib ; \
	fi
	if [ -f gui/ivib/makefile ] ; then \
		make -C ivib ; \
	fi
	if [ -f gui/makefile ] ; then \
		make -C gui ; \
	fi
	if [ -f gui/ivib/makefile ] ; then \
		make -C gui/ivib ; \
	fi
	if [ -f xml/makefile ] ; then \
		make -C xml ; \
	fi
	if [ -f parser/makefile ] ; then \
		make -C parser ; \
	fi
	if [ -f unidep/makefile ] ; then \
		make -C unidep ; \
	fi
	if [ -f util/makefile ] ; then \
		make -C util ; \
	fi
	if [ -f unidoc/makefile ] ; then \
		make -C unidoc ; \
	fi
	if [ -f ide/makefile ] ; then \
		make -C ide ; \
	fi

clean Clean:
	if [ -f iyacc/Makefile ] ; then \
		make -C iyacc Clean ; \
	fi
	if [ -f unicon/makefile ] ; then \
		make -C unicon Clean ; \
	fi
	if [ -f ivib/makefile ] ; then \
		make -C ivib Clean ; \
	fi
	if [ -f lib/makefile ] ; then \
		make -C lib Clean ; \
	fi
	if [ -f gui/makefile ] ; then \
		make -C gui clean ; \
	fi
	if [ -f gui/ivib/makefile ] ; then \
		make -C gui/ivib clean ; \
	fi
	if [ -f xml/makefile ] ; then \
		make -C xml clean ; \
	fi
	if [ -f parser/makefile ] ; then \
		make -C parser clean ; \
	fi
	if [ -f unidep/makefile ] ; then \
		make -C unidep clean ; \
	fi
	if [ -f util/makefile ] ; then \
		make -C util clean ; \
	fi
	if [ -f unidoc/makefile ] ; then \
		make -C unidoc clean ; \
	fi
	if [ -f ide/makefile ] ; then \
		make -C ide clean ; \
	fi
