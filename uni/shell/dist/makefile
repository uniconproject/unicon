# make           builds the core programs
# make test      compares output of test programs against expected output
# make install   copies Stream.icn Stream.u to ../../lib
#                   and shell.exe           to ../../../bin
#                (using cygwin make, these copies are read only)
# make uninstall removes copies that make install made

# first, some synonyms
STRM=../../lib/Stream.u
BN=../../../bin
SHL=$(BN)/shell.icn
USH=$(BN)/ush.icn

# first target is default - build core programs
default : install test

# create/remove core executables and libraries

uninstall :
	rm -f ../../../bin/shell.exe ../../../bin/ush.exe
	rm -f ../../../bin/shell     ../../../bin/ush
	rm -f ../../../bin/shell.icn ../../../bin/ush.icn
	rm -f ../../lib/Stream.icn   ../../lib/Stream.u

install  : $(STRM) $(SHL) $(USH)

# Stream is a synonym for target ../../lib/Stream.u
Stream : $(STRM)

$(STRM) : Stream.icn
	:
	: begin make $(STRM)
	:
	make install_Stream_cmd || make install_Stream_sh
	:
	: made $(STRM)
	:

$(SHL) : $(STRM) shell.icn
	:
	: begin make $(SHL)
	:
	make Stream
	make ../../../bin/shell.exe  || make ../../../bin/shell
	:
	: made $(SHL)
	:

$(USH) : $(STRM) ush.icn
	:
	: begin make $(USH)
	:
	make Stream
	make ../../../bin/ush.exe  || make ../../../bin/ush
	:
	: made $(USH)
	:

install_Stream_cmd : Stream.icn
	cmd /c 'echo installing Stream.u on Windows'
	cmd /c 'del ..\..\lib\Stream.u && del ..\..\Stream.icn'
	cmd /c 'copy Stream.icn ..\..\lib\ && pushd ..\..\lib && unicon -c Stream.icn' 

../../../bin/shell.exe : shell.icn Stream.icn 
	cmd /c 'echo installing shell.exe on Windows'
	make Stream
	cmd /c 'del shell.exe'
	cmd /c 'del ..\..\..\bin\shell.exe'
	cmd /c 'unicon shell.icn && if .%ERRORLEVEL%. == .0. move shell.exe ..\..\..\bin\ && if .%ERRORLEVEL%. == .0. copy shell.icn ..\..\..\bin\ '

../../../bin/ush.exe : ush.icn Stream.icn
	cmd /c 'echo installing ush.exe on Windows'
	make Stream
	cmd /c 'del ush.exe'
	cmd /c 'del ..\..\..\bin\ush.exe'
	cmd /c 'unicon ush.icn && if .%ERRORLEVEL%. == .0. move ush.exe ..\..\..\bin\ && if .%ERRORLEVEL%. == .0. copy ush.icn ..\..\..\bin\ '

install_Stream_sh : Stream.icn
	echo installing Stream.u on Unix/Linux
	rm -f ../../lib/Stream.icn ../../lib/Stream.u
	cp -f Stream.icn ../../lib/
	pushd ../../lib ; unicon -c Stream.icn 

../../../bin/shell : shell.icn Stream.icn
	echo installing shell on Unix/Linux
	make Stream
	rm -f shell ../../../bin/shell
	unicon shell.icn ; mv -f shell ../../../bin/  ; cp -f shell.icn ../../../bin/ 

../../../bin/ush : ush.icn Stream.icn
	echo installing ush on Unix/Linux
	make Stream
	rm -f ush ../../../bin/ush
	unicon ush.icn   ; mv -f ush   ../../../bin/  ; cp -f ush.icn   ../../../bin/

# perform all tests
test : install test_pipeline testsvc test_s_file test_queue test_super test_subst test_trace testsvc_trace test_ush
	:
	:
	: All tests passed!
	:
	:

test_pipeline : install test.shell s_file producer consumer
	:
	: begin test_pipeline
	:
	shell -i test.shell > test.output
	diff test.output test.comparison > test.diff
	:
	: PASSED test_pipeline
	:

test_trace : install test_trace.shell s_file producer consumer
	:
	: begin test_trace
	:
	shell -t -i test_trace.shell > test_trace.output
	diff test_trace.output test_trace.comparison > test_trace.diff
	:
	: PASSED test_trace
	:

testsvc : install testsvc.shell s_file producer service client
	:
	: begin testsvc
	:
	shell -i testsvc.shell > testsvc.output
	diff testsvc.output testsvc.comparison > testsvc.diff
	:
	: PASSED testsvc
	:

testsvc_trace : install testsvc_trace.shell s_file producer service client
	:
	: begin testsvc_trace
	:
	shell -t -i testsvc_trace.shell > testsvc_trace.output
	diff testsvc_trace.output testsvc_trace.comparison > testsvc_trace.diff
	:
	: PASSED testsvc_trace
	:

test_s_file : install s_file s_file_consumer_test test_s_file.shell test_s_file.data
	:
	: begin test_s_file
	:
	rm -f test_s_file.out
	shell -i test_s_file.shell > test_s_file.output
	cat test_s_file.out >> test_s_file.output
	diff test_s_file.output test_s_file.comparison > test_s_file.diff
	:
	: PASSED test_s_file
	:

test_queue : install queue_put queue_get test_queue.shell
	:
	: begin test_queue
	:
	shell -i test_queue.shell > test_queue.output
	diff test_queue.output test_queue.comparison > test_queue.diff
	:
	: PASSED test_queue
	:

test_super : install super.shell test.shell testsvc.shell s_file producer consumer service client
	:
	: begin test_super
	:
	shell -i super.shell -s $(BN) > super.output
	diff super.output super.comparison > super.diff
	:
	: PASSED test_super
	:

test_subst : install super_subst.shell test_subst.shell queue_put queue_get t_cat
	:
	: begin test_subst
	:
	shell -i super_subst.shell -s $(BN) > super_subst.output
	diff super_subst.output super_subst.comparison > super_subst.diff
	:
	: PASSED test_subst
	:

test_ush : install test.shell s_file producer consumer test_queue.ush
	:
	: begin test_ush
	:
	{ echo . test.shell ; echo exit ; } | { shell -s $(BN) -p ush - > ush.output ; }
	shell -s $(BN) -p ush test_queue.ush >> ush.output
	diff ush.output ush.comparison > ush.diff
	:
	: PASSED test_ush
	:

# create executables needed for running test scripts

t_cat : t_cat.icn $(STRM)
	unicon -u  t_cat

s_file : s_file.icn $(STRM)
	unicon -u  s_file

consumer : consumer.icn $(STRM)
	unicon -u  consumer

producer : producer.icn $(STRM)
	unicon -u  producer

service : service.icn $(STRM)
	unicon -u  service

client : client.icn $(STRM)
	unicon -u  client

s_file_consumer_test : s_file_consumer_test.icn $(STRM)
	unicon -u s_file_consumer_test

queue_put : queue_put.icn $(STRM)
	unicon -u queue_put

queue_get : queue_get.icn $(STRM)
	unicon -u queue_get

# clean up files made above

clean :
	rm -f client        ipath         queue_get      s_file                    service      t_cat    
	rm -f client.exe    ipath.exe     queue_get.exe  s_file.exe                service.exe  t_cat.exe
	rm -f consumer      producer      queue_put      s_file_consumer_test      shell        ush    
	rm -f consumer.exe  producer.exe  queue_put.exe  s_file_consumer_test.exe  shell.exe    ush.exe
	rm -f Stream.u uniclass.*
	rm -f producer service client
	rm -f s_file_consumer_test
	rm -f super.output super.diff
	rm -f super_subst.output super_subst.diff
	rm -f test.diff test.output test_trace.diff test_trace.output
	rm -f testsvc.diff testsvc.output testsvc_trace.diff testsvc_trace.output
	rm -f test_s_file.output test_s_file.out test_s_file.diff
	rm -f test_queue.output test_queue.diff
	rm -f ush.output ush.diff

