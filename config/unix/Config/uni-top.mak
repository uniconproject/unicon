all :
	make -C iyacc
	make -C unicon
	make -C lib
	make -C ivib
	make -C gui
	make -C gui/ivib
	make -C xml
	make -C parser
	make -C unidep
	make -C util
	make -C unidoc
	make -C ide

clean Clean:
	make -C iyacc Clean
	make -C unicon Clean
	make -C ivib Clean
	make -C lib Clean
	make -C gui clean
	make -C gui/ivib clean
	make -C xml clean
	make -C parser clean
	make -C unidep clean
	make -C util clean
	make -C unidoc clean
	make -C ide clean
