#  Top Level Makefile for Unicon, pre-configuration
#
#  The pre-configuration top-level makefile supports only configuration.
#  Keep it simple since many different incompatible "make" programs use it.
#  Configuration replaces this makefile with a platform- and compiler-
#  specific makefile that contains build rules.

help:
	@echo UNIX: Run "make Configure name=system" or "make X-Configure name=system"
	@echo "   where system is one of those in config/unix."
	@echo Windows (MSVC): Run "nmake NT-Configure" or "nmake W-Configure".
	@echo Windows (GCC): Run "make NT-Configure-GCC" or "make W-Configure-GCC".
	@echo "All: Then add the Unicon bin directory to your path."
	@echo All: after configuration, run "make (or nmake) Unicon".

# Configure the code for a specific system.

Configure:	config/unix/$(name)/status
		$(MAKE) Pure >/dev/null
		cd config/unix; $(MAKE) Setup-NoGraphics name=$(name)
		sh ./configure
		@echo Now remember to add unicon/bin to your path

X-Configure:	config/unix/$(name)/status
		$(MAKE) Pure >/dev/null
		cd config/unix; $(MAKE) Setup-Graphics name=$(name)
		sh ./configure
		@echo Now remember to add unicon/bin to your path

NT-Configure:
		cd config\win32\msvc
		config
		@echo Now remember to add unicon/bin to your path

W-Configure:
		cd config\win32\msvc
		w-config
		@echo Now remember to add unicon/bin to your path

W-Configure-GCC:
		cd config/win32/gcc && sh w-config.sh
		@echo Now remember to add unicon/bin to your path
		@echo Then run "make Unicon" to build

NT-Configure-GCC:
		cd config/win32/gcc && sh config.sh
		@echo Now remember to add unicon/bin to your path
		@echo Then run "make Unicon" to build

Pure:
		touch Makedefs
		rm -rf icon.* bin/[a-z]* lib/[a-z]*
		cd ipl;			$(MAKE) Pure
		cd src;			$(MAKE) Pure
		cd tests;		$(MAKE) Pure
		if [ -f uni/Makefile ] ; then \
			cd uni;			$(MAKE) Clean ;\
		fi
		cd config/unix; 	$(MAKE) Pure
