udb : udb.icn filenames.u
	unicon udb filenames

filenames.u : filenames.icn
	unicon -c filenames.icn

tar : udb.icn filenames.icn Makefile
	tar czvf udb.tgz udb.icn filenames.icn Makefile

clean:
	rm udb filenames.u udb.u
