# General Unicon pages: RST is canonical; HTML is a build artifact.
#   make -C doc/unicon html

.PHONY: html clean

html:
	mkdir -p html
	pandoc -s -f rst -t html5 --metadata title="Unicon FAQ" faq.rst -o html/faq.html
	pandoc -s -f rst -t html5 --metadata title="Posix Interface" posix.rst -o html/posix.html
	pandoc -s -f rst -t html5 --metadata title="SVN Repository" svn.rst -o html/svn.html
	pandoc -s -f rst -t html5 --metadata title="CGI Example" simple.rst -o html/simple.html
	pandoc -s -f rst -t html5 --metadata title="Technical Reports" reports.rst -o html/reports.html

clean:
	rm -rf html
