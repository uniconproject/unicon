#  Top Level Makefile for Unicon, pre-configuration
#
#  The pre-configuration top-level makefile supports only configuration.
#  Keep it simple since many different incompatible "make" programs use it.
#  Configuration replaces this makefile with a platform- and compiler-
#  specific makefile that contains build rules.

help:
	@echo
	@echo Unicon Build Instructions:
	@echo
	@echo Start by adding the Unicon bin directory to your path.
	@echo
	@echo Platform
	@echo "  UNIX:" 
	@echo "      Run \"make Configure name=system\""
	@echo "       or \"make X-Configure name=system\""
	@echo "       or \"make build name=system\""
	@echo "      where system is one of those in config/unix."
	@echo
	@echo "  Windows:"
	@echo "      MSVC: Run \"nmake NT-Configure\" or \"nmake W-Configure\"."
	@echo "      GCC : Run \"make NT-Configure-GCC\" or \"make W-Configure-GCC\"."
	@echo "            For a fully-automated build Run \"make WUnicon\" ."
	@echo
	@echo "All: after configuration, run \"make (or nmake) Unicon\"."
	@echo


.PHONY: Configure

# Configure the code for a specific system.

Configure:	config/unix/$(name)/status
		$(MAKE) Pure >/dev/null
		cd config/unix; $(MAKE) Setup-NoGraphics name=$(name)
		sh ./configure
		@echo Now remember to add unicon/bin to your path

Thin-Configure:	config/unix/$(name)/status
		$(MAKE) Pure >/dev/null
		cd config/unix;$(MAKE) Setup-NoGraphics Setup-Thin name=$(name)
		@echo 'using ./thin for Thin configuration'
		sh ./thin

X-Configure:	config/unix/$(name)/status
		$(MAKE) Pure >/dev/null
		cd config/unix; $(MAKE) Setup-Graphics name=$(name)
		sh ./configure
		@if grep -q "HAVE_LIBX11 1" src/h/auto.h; then \
			echo "Think we found X11, you are good to go."; \
		else \
			make Configure name=$(name); \
			echo "X11 libraries or headers missing; graphics" ; \
			echo "not enabled. " ; \
		fi
		@echo Now remember to add unicon/bin to your path

Thin-X-Configure:	config/unix/$(name)/status
		$(MAKE) Pure >/dev/null
		cd config/unix; $(MAKE) Setup-Graphics Setup-Thin name=$(name)
		@echo 'using ./thin for Thin configuration'
		sh ./thin

VX-Configure:	config/unix/$(name)/status
		$(MAKE) Pure >/dev/null
		-cd src/lib/voice; $(MAKE)
		cd config/unix; $(MAKE) Setup-Graphics name=$(name)
		sh ./configure
		@echo Now remember to add unicon/bin to your path

XUnicon:
	Make X-Configure name=x86_64_linux
	Make Unicon

WUnicon:
	@echo Reloading the Makefile from config/win32/gcc/makefile.top
	cp config/win32/gcc/makefile.top Makefile
	@echo Done.
	@echo
	@echo Ready to build Windows Unicon
	@echo Make sure the Unicon bin directory is in your path before continuing, then run:
	@echo
	@echo "   - " \"make WUnicon32\" for a 32-bit build, or
	@echo "   - " \"make WUnicon64\" for a 64-bit build - requires MinGW64.
	@echo

NT-Configure:
		cmd /C "cd config\win32\msvc && config"
		@echo Now remember to add unicon/bin to your path

W-Configure:
		cmd /C "cd config\win32\msvc && w-config"
		@echo Now remember to add unicon/bin to your path

W-Configure-GCC:
		cd config/win32/gcc && sh w-config.sh
		@echo Now remember to add unicon/bin to your path
		@echo Then run "make Unicon" to build

NT-Configure-GCC:
		cd config/win32/gcc && sh config.sh
		@echo Now remember to add unicon/bin to your path
		@echo Then run "make Unicon" to build

Fresh-Makefile:
	@echo
	@echo Reloading the Makefile from makefile.top
	cp makefile.top Makefile
	@echo Done.
	@echo

build:
	if [ $(TERM) == dumb ] ; then \
		echo "No building on dumb terminals, use make Configure"; \
	elif [ -f /usr/include/curses.h ] ; then \
		gcc src/common/build.c -lncurses -o build; \
		./build $(name) ; \
		rm build; \
	else \
		echo "No /usr/include/curses.h found, use make Configure";\
	fi

Pure:
		touch Makedefs
		rm -rf icon.* bin/[a-z]* lib/[a-z]*.u
		cd ipl;			$(MAKE) Pure
		cd src;			$(MAKE) Pure
		cd tests;		$(MAKE) Pure
		if [ -f uni/Makefile ] ; then \
			cd uni;			$(MAKE) Clean ;\
		fi
		cd config/unix; 	$(MAKE) Pure
