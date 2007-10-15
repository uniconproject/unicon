# make, test, and install Unicon Shell files
#
# see head of dist/makefile for alternatives

doc : shell.icn.1.html ush.icn.1.html Stream.icn.3.html

shell.icn.1.html : man/man1/shell.icn.1
	groff -m man -T html man/man1/shell.icn.1 > shell.icn.1.html

ush.icn.1.html : man/man1/ush.icn.1
	groff -m man -T html man/man1/ush.icn.1 > ush.icn.1.html

Stream.icn.3.html : man/man3/Stream.icn.3
	groff -m man -T html man/man3/Stream.icn.3 > Stream.icn.3.html
