udb : udb.icn filenames.u auto.u
	unicon udb filenames auto

filenames.u : filenames.icn
	unicon -c filenames.icn

auto.u : auto.icn
	unicon -c auto.icn

auto.icn : auto.y
	/usr/local/src/unicon/uni/iyacc/iyacc -i auto.y

tar : udb.icn filenames.icn auto.y Makefile
	tar czvf udb.tgz udb.icn filenames.icn auto.y Makefile

.PHONY=clean
clean:
	rm auto.icn udb
