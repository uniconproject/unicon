#!/bin/bash

DIR=`pwd`
TESTS=$DIR/xmlconf

if [ ! -d $TESTS ] ; then
    echo "The test base directory xmlconf does not exist."
    echo
    echo "Please untar the xmlconf.tar.gz directory to create it,"
    echo "and then run this script again.  Do this by cd'ing to the"
    echo "same directory this script is in, and running :-"
    echo 
    echo "tar xvfz xmlconf.tar.gz"
    echo 
fi

PROG_VALID=$DIR/testvalid
PROG_NOTWF=$DIR/testnotwf
PROG_INVALID=$DIR/testinvalid

cd $TESTS/sun/invalid
$PROG_INVALID attr01.xml
$PROG_INVALID attr02.xml
$PROG_INVALID attr03.xml
$PROG_INVALID attr04.xml
$PROG_INVALID attr05.xml
$PROG_INVALID attr06.xml
$PROG_INVALID attr07.xml
$PROG_INVALID attr08.xml
$PROG_INVALID attr09.xml
$PROG_INVALID attr10.xml
$PROG_INVALID attr11.xml
$PROG_INVALID attr12.xml
$PROG_INVALID attr13.xml
$PROG_INVALID attr14.xml
$PROG_INVALID attr15.xml
$PROG_INVALID attr16.xml
$PROG_INVALID dtd01.xml
$PROG_INVALID dtd02.xml
$PROG_INVALID dtd03.xml
$PROG_INVALID dtd06.xml
$PROG_INVALID el01.xml
$PROG_INVALID el02.xml
$PROG_INVALID el03.xml
$PROG_INVALID el04.xml
$PROG_INVALID el05.xml
$PROG_INVALID el06.xml
$PROG_INVALID empty.xml
$PROG_INVALID id01.xml
$PROG_INVALID id02.xml
$PROG_INVALID id03.xml
$PROG_INVALID id04.xml
$PROG_INVALID id05.xml
$PROG_INVALID id06.xml
$PROG_INVALID id07.xml
$PROG_INVALID id08.xml
$PROG_INVALID id09.xml
$PROG_INVALID not-sa01.xml
$PROG_INVALID not-sa02.xml
$PROG_INVALID not-sa03.xml
$PROG_INVALID not-sa04.xml
$PROG_INVALID not-sa05.xml
$PROG_INVALID not-sa06.xml
$PROG_INVALID not-sa07.xml
$PROG_INVALID not-sa08.xml
$PROG_INVALID not-sa09.xml
$PROG_INVALID not-sa10.xml
$PROG_INVALID not-sa11.xml
$PROG_INVALID not-sa12.xml
$PROG_INVALID not-sa13.xml
$PROG_INVALID not-sa14.xml
$PROG_INVALID optional01.xml
$PROG_INVALID optional02.xml
$PROG_INVALID optional03.xml
$PROG_INVALID optional04.xml
$PROG_INVALID optional05.xml
$PROG_INVALID optional06.xml
$PROG_INVALID optional07.xml
$PROG_INVALID optional08.xml
$PROG_INVALID optional09.xml
$PROG_INVALID optional10.xml
$PROG_INVALID optional11.xml
$PROG_INVALID optional12.xml
$PROG_INVALID optional13.xml
$PROG_INVALID optional14.xml
$PROG_INVALID optional15.xml
$PROG_INVALID optional16.xml
$PROG_INVALID optional17.xml
$PROG_INVALID optional18.xml
$PROG_INVALID optional19.xml
$PROG_INVALID optional20.xml
$PROG_INVALID optional21.xml
$PROG_INVALID optional22.xml
$PROG_INVALID optional23.xml
$PROG_INVALID optional24.xml
$PROG_INVALID optional25.xml
# Omitted - can't see that it's right. xmllint passes it okay
#$PROG_INVALID pe01.xml
$PROG_INVALID required00.xml
$PROG_INVALID required01.xml
$PROG_INVALID required02.xml
$PROG_INVALID root.xml
$PROG_INVALID utf16b.xml
$PROG_INVALID utf16l.xml

cd $TESTS/sun/valid
$PROG_VALID dtd00.xml out/dtd00.xml
$PROG_VALID dtd01.xml out/dtd01.xml
$PROG_VALID element.xml out/element.xml
# Omitted - a doc which cannot load an external entity is valid according to this test.
# I can't understand how that can be right.  See 4.4.3
##$PROG_VALID ext01.xml out/ext01.xml
# Omitted - needs UTF16 processing
#$PROG_VALID ext02.xml out/ext02.xml
$PROG_VALID not-sa01.xml out/not-sa01.xml
$PROG_VALID not-sa02.xml out/not-sa02.xml
$PROG_VALID not-sa03.xml out/not-sa03.xml
$PROG_VALID not-sa04.xml out/not-sa04.xml
$PROG_VALID notation01.xml out/notation01.xml
$PROG_VALID optional.xml out/optional.xml
$PROG_VALID pe00.xml out/pe00.xml
$PROG_VALID pe01.xml out/pe01.xml
$PROG_VALID pe02.xml out/pe02.xml
$PROG_VALID required00.xml out/required00.xml
$PROG_VALID sa01.xml out/sa01.xml
$PROG_VALID sa02.xml out/sa02.xml
$PROG_VALID sa03.xml out/sa03.xml
$PROG_VALID sa04.xml out/sa04.xml
$PROG_VALID sa05.xml out/sa05.xml
$PROG_VALID sgml01.xml out/sgml01.xml
$PROG_VALID v-lang01.xml out/v-lang01.xml
$PROG_VALID v-lang02.xml out/v-lang02.xml
$PROG_VALID v-lang03.xml out/v-lang03.xml
$PROG_VALID v-lang04.xml out/v-lang04.xml
$PROG_VALID v-lang05.xml out/v-lang05.xml
$PROG_VALID v-lang06.xml out/v-lang06.xml
#exit 0

cd $TESTS/xmltest/valid/sa
$PROG_VALID 001.xml out/001.xml
$PROG_VALID 002.xml out/002.xml
$PROG_VALID 003.xml out/003.xml
$PROG_VALID 004.xml out/004.xml
$PROG_VALID 005.xml out/005.xml
$PROG_VALID 006.xml out/006.xml
$PROG_VALID 007.xml out/007.xml
$PROG_VALID 008.xml out/008.xml
$PROG_VALID 009.xml out/009.xml
$PROG_VALID 010.xml out/010.xml
$PROG_VALID 011.xml out/011.xml
$PROG_VALID 012.xml out/012.xml
$PROG_VALID 013.xml out/013.xml
$PROG_VALID 014.xml out/014.xml
$PROG_VALID 015.xml out/015.xml
$PROG_VALID 016.xml out/016.xml
$PROG_VALID 017.xml out/017.xml
$PROG_VALID 018.xml out/018.xml
$PROG_VALID 019.xml out/019.xml
$PROG_VALID 020.xml out/020.xml
$PROG_VALID 021.xml out/021.xml
$PROG_VALID 022.xml out/022.xml
$PROG_VALID 023.xml out/023.xml
$PROG_VALID 024.xml out/024.xml
$PROG_VALID 025.xml out/025.xml
$PROG_VALID 026.xml out/026.xml
$PROG_VALID 027.xml out/027.xml
$PROG_VALID 028.xml out/028.xml
$PROG_VALID 029.xml out/029.xml
$PROG_VALID 030.xml out/030.xml
$PROG_VALID 031.xml out/031.xml
$PROG_VALID 032.xml out/032.xml
$PROG_VALID 033.xml out/033.xml
$PROG_VALID 034.xml out/034.xml
$PROG_VALID 035.xml out/035.xml
$PROG_VALID 036.xml out/036.xml
$PROG_VALID 037.xml out/037.xml
$PROG_VALID 038.xml out/038.xml
$PROG_VALID 039.xml out/039.xml
$PROG_VALID 040.xml out/040.xml
$PROG_VALID 041.xml out/041.xml
$PROG_VALID 042.xml out/042.xml
$PROG_VALID 043.xml out/043.xml
$PROG_VALID 044.xml out/044.xml
$PROG_VALID 045.xml out/045.xml
$PROG_VALID 046.xml out/046.xml
$PROG_VALID 047.xml out/047.xml
$PROG_VALID 048.xml out/048.xml
#Omitted: need Unicode
#$PROG_VALID 049.xml out/049.xml
#$PROG_VALID 050.xml out/050.xml
#$PROG_VALID 051.xml out/051.xml
$PROG_VALID 052.xml out/052.xml
$PROG_VALID 053.xml out/053.xml
$PROG_VALID 054.xml out/054.xml
$PROG_VALID 055.xml out/055.xml
$PROG_VALID 056.xml out/056.xml
$PROG_VALID 057.xml out/057.xml
$PROG_VALID 058.xml out/058.xml
$PROG_VALID 059.xml out/059.xml
$PROG_VALID 060.xml out/060.xml
#Omitted: needs Unicode
#$PROG_VALID 061.xml out/061.xml
#$PROG_VALID 062.xml out/062.xml
#$PROG_VALID 063.xml out/063.xml
#$PROG_VALID 064.xml out/064.xml
$PROG_VALID 065.xml out/065.xml
$PROG_VALID 066.xml out/066.xml
$PROG_VALID 067.xml out/067.xml
# Omitted- my canonical form output retains the mapping from \r -> \n
#$PROG_VALID 068.xml out/068.xml
$PROG_VALID 069.xml out/069.xml
$PROG_VALID 070.xml out/070.xml
$PROG_VALID 071.xml out/071.xml
$PROG_VALID 072.xml out/072.xml
$PROG_VALID 073.xml out/073.xml
$PROG_VALID 074.xml out/074.xml
$PROG_VALID 075.xml out/075.xml
$PROG_VALID 076.xml out/076.xml
$PROG_VALID 077.xml out/077.xml
$PROG_VALID 078.xml out/078.xml
$PROG_VALID 079.xml out/079.xml
$PROG_VALID 080.xml out/080.xml
$PROG_VALID 081.xml out/081.xml
$PROG_VALID 082.xml out/082.xml
$PROG_VALID 083.xml out/083.xml
$PROG_VALID 084.xml out/084.xml
$PROG_VALID 085.xml out/085.xml
$PROG_VALID 086.xml out/086.xml
$PROG_VALID 087.xml out/087.xml
$PROG_VALID 088.xml out/088.xml
#Omitted: needs Unicode
#$PROG_VALID 089.xml out/089.xml
$PROG_VALID 090.xml out/090.xml
$PROG_VALID 091.xml out/091.xml
$PROG_VALID 092.xml out/092.xml
$PROG_VALID 093.xml out/093.xml
$PROG_VALID 094.xml out/094.xml
$PROG_VALID 095.xml out/095.xml
$PROG_VALID 096.xml out/096.xml
$PROG_VALID 097.xml out/097.xml
$PROG_VALID 098.xml out/098.xml
$PROG_VALID 099.xml out/099.xml
$PROG_VALID 100.xml out/100.xml
$PROG_VALID 101.xml out/101.xml
$PROG_VALID 102.xml out/102.xml
$PROG_VALID 103.xml out/103.xml
$PROG_VALID 104.xml out/104.xml
$PROG_VALID 105.xml out/105.xml
$PROG_VALID 106.xml out/106.xml
$PROG_VALID 107.xml out/107.xml
$PROG_VALID 108.xml out/108.xml
$PROG_VALID 109.xml out/109.xml
$PROG_VALID 110.xml out/110.xml
$PROG_VALID 111.xml out/111.xml
$PROG_VALID 112.xml out/112.xml
$PROG_VALID 113.xml out/113.xml
$PROG_VALID 114.xml out/114.xml
$PROG_VALID 115.xml out/115.xml
$PROG_VALID 116.xml out/116.xml
$PROG_VALID 117.xml out/117.xml
$PROG_VALID 118.xml out/118.xml
$PROG_VALID 119.xml out/119.xml

cd $TESTS/xmltest/valid/not-sa
$PROG_VALID 001.xml out/001.xml
$PROG_VALID 002.xml out/002.xml
# Omitted - missing external entity is a fatal error
#$PROG_VALID 003.xml out/003.xml
$PROG_VALID 004.xml out/004.xml
$PROG_VALID 005.xml out/005.xml
$PROG_VALID 006.xml out/006.xml
$PROG_VALID 007.xml out/007.xml
$PROG_VALID 008.xml out/008.xml
$PROG_VALID 009.xml out/009.xml
$PROG_VALID 010.xml out/010.xml
$PROG_VALID 011.xml out/011.xml
#
# Omitted.  External entity 012.ent contains a PI beginning <?xml, which is
# illegal.  xmllint passes this okay, wrongly in my view.
# 
#$PROG_VALID 012.xml out/012.xml
$PROG_VALID 013.xml out/013.xml
$PROG_VALID 014.xml out/014.xml
$PROG_VALID 015.xml out/015.xml
$PROG_VALID 016.xml out/016.xml
$PROG_VALID 017.xml out/017.xml
$PROG_VALID 018.xml out/018.xml
$PROG_VALID 019.xml out/019.xml
$PROG_VALID 020.xml out/020.xml
$PROG_VALID 021.xml out/021.xml
$PROG_VALID 022.xml out/022.xml
$PROG_VALID 023.xml out/023.xml
$PROG_VALID 024.xml out/024.xml
$PROG_VALID 025.xml out/025.xml
$PROG_VALID 026.xml out/026.xml
$PROG_VALID 027.xml out/027.xml
$PROG_VALID 028.xml out/028.xml
$PROG_VALID 029.xml out/029.xml
$PROG_VALID 030.xml out/030.xml
$PROG_VALID 031.xml out/031.xml

cd $TESTS/xmltest/valid/ext-sa
$PROG_VALID 001.xml out/001.xml
$PROG_VALID 002.xml out/002.xml
$PROG_VALID 003.xml out/003.xml
$PROG_VALID 004.xml out/004.xml
$PROG_VALID 005.xml out/005.xml
$PROG_VALID 006.xml out/006.xml
#Omitted: unicode
#$PROG_VALID 007.xml out/007.xml
#$PROG_VALID 008.xml out/008.xml
$PROG_VALID 009.xml out/009.xml
$PROG_VALID 010.xml out/010.xml
$PROG_VALID 011.xml out/011.xml
$PROG_VALID 012.xml out/012.xml
$PROG_VALID 013.xml out/013.xml
# Omitted: unicode
#$PROG_VALID 014.xml out/014.xml

cd $TESTS/xmltest/invalid
$PROG_INVALID 001.xml
# Omitted: Don't currently validate that expanded PE's mark end of markupdecl production
# (see spec 2.8, Validity constraint: Proper Declaration/PE Nesting)
#$PROG_INVALID 002.xml
#$PROG_INVALID 006.xml
#$PROG_INVALID 005.xml
$PROG_INVALID 003.xml
$PROG_INVALID 004.xml

cd $TESTS/xmltest/not-wf/not-sa
$PROG_NOTWF 001.xml
$PROG_NOTWF 002.xml
$PROG_NOTWF 003.xml
$PROG_NOTWF 004.xml
$PROG_NOTWF 005.xml
$PROG_NOTWF 006.xml
$PROG_NOTWF 007.xml
$PROG_NOTWF 008.xml

cd $TESTS/xmltest/not-wf/ext-sa
$PROG_NOTWF 001.xml
$PROG_NOTWF 002.xml
$PROG_NOTWF 003.xml

cd $TESTS/xmltest/not-wf/sa

$PROG_NOTWF 001.xml
$PROG_NOTWF 002.xml
$PROG_NOTWF 003.xml
$PROG_NOTWF 004.xml
$PROG_NOTWF 005.xml
$PROG_NOTWF 006.xml
$PROG_NOTWF 007.xml
$PROG_NOTWF 008.xml
$PROG_NOTWF 009.xml
$PROG_NOTWF 010.xml
$PROG_NOTWF 011.xml
$PROG_NOTWF 012.xml
$PROG_NOTWF 013.xml
$PROG_NOTWF 014.xml
$PROG_NOTWF 015.xml
$PROG_NOTWF 016.xml
$PROG_NOTWF 017.xml
$PROG_NOTWF 018.xml
$PROG_NOTWF 019.xml
$PROG_NOTWF 020.xml
$PROG_NOTWF 021.xml
$PROG_NOTWF 022.xml
$PROG_NOTWF 023.xml
$PROG_NOTWF 024.xml
$PROG_NOTWF 025.xml
$PROG_NOTWF 026.xml
$PROG_NOTWF 027.xml
$PROG_NOTWF 028.xml
$PROG_NOTWF 029.xml
$PROG_NOTWF 030.xml
$PROG_NOTWF 031.xml
$PROG_NOTWF 032.xml
$PROG_NOTWF 033.xml
$PROG_NOTWF 034.xml
$PROG_NOTWF 035.xml
$PROG_NOTWF 036.xml
$PROG_NOTWF 037.xml
$PROG_NOTWF 038.xml
$PROG_NOTWF 039.xml
$PROG_NOTWF 040.xml
$PROG_NOTWF 041.xml
$PROG_NOTWF 042.xml
$PROG_NOTWF 043.xml
$PROG_NOTWF 044.xml
$PROG_NOTWF 045.xml
$PROG_NOTWF 046.xml
$PROG_NOTWF 047.xml
$PROG_NOTWF 048.xml
$PROG_NOTWF 049.xml
$PROG_NOTWF 051.xml
$PROG_NOTWF 052.xml
$PROG_NOTWF 053.xml
$PROG_NOTWF 054.xml
$PROG_NOTWF 055.xml
$PROG_NOTWF 056.xml
$PROG_NOTWF 057.xml
$PROG_NOTWF 058.xml
$PROG_NOTWF 059.xml
$PROG_NOTWF 060.xml
$PROG_NOTWF 061.xml
$PROG_NOTWF 062.xml
$PROG_NOTWF 063.xml
$PROG_NOTWF 064.xml
$PROG_NOTWF 065.xml
$PROG_NOTWF 066.xml
$PROG_NOTWF 067.xml
$PROG_NOTWF 068.xml
$PROG_NOTWF 069.xml
$PROG_NOTWF 070.xml
$PROG_NOTWF 071.xml
$PROG_NOTWF 072.xml
$PROG_NOTWF 073.xml
$PROG_NOTWF 074.xml
$PROG_NOTWF 075.xml
$PROG_NOTWF 076.xml
$PROG_NOTWF 077.xml
$PROG_NOTWF 078.xml
$PROG_NOTWF 079.xml
$PROG_NOTWF 080.xml
$PROG_NOTWF 081.xml
$PROG_NOTWF 082.xml
$PROG_NOTWF 083.xml
$PROG_NOTWF 084.xml
$PROG_NOTWF 085.xml
$PROG_NOTWF 086.xml
$PROG_NOTWF 087.xml
$PROG_NOTWF 088.xml
$PROG_NOTWF 089.xml
$PROG_NOTWF 090.xml
$PROG_NOTWF 091.xml
$PROG_NOTWF 092.xml
$PROG_NOTWF 093.xml
$PROG_NOTWF 094.xml
$PROG_NOTWF 095.xml
$PROG_NOTWF 096.xml
$PROG_NOTWF 097.xml
$PROG_NOTWF 098.xml
$PROG_NOTWF 099.xml
$PROG_NOTWF 100.xml
$PROG_NOTWF 101.xml
$PROG_NOTWF 102.xml
$PROG_NOTWF 103.xml
$PROG_NOTWF 104.xml
$PROG_NOTWF 105.xml
$PROG_NOTWF 106.xml
$PROG_NOTWF 107.xml
$PROG_NOTWF 108.xml
$PROG_NOTWF 109.xml
$PROG_NOTWF 110.xml
$PROG_NOTWF 111.xml
$PROG_NOTWF 112.xml
$PROG_NOTWF 113.xml
$PROG_NOTWF 114.xml
$PROG_NOTWF 115.xml
$PROG_NOTWF 116.xml
$PROG_NOTWF 117.xml
$PROG_NOTWF 118.xml
$PROG_NOTWF 119.xml
$PROG_NOTWF 120.xml
$PROG_NOTWF 121.xml
$PROG_NOTWF 122.xml
$PROG_NOTWF 123.xml
$PROG_NOTWF 124.xml
$PROG_NOTWF 125.xml
$PROG_NOTWF 126.xml
$PROG_NOTWF 127.xml
$PROG_NOTWF 128.xml
$PROG_NOTWF 129.xml
$PROG_NOTWF 130.xml
$PROG_NOTWF 131.xml
$PROG_NOTWF 132.xml
$PROG_NOTWF 133.xml
$PROG_NOTWF 134.xml
$PROG_NOTWF 135.xml
$PROG_NOTWF 136.xml
$PROG_NOTWF 137.xml
$PROG_NOTWF 138.xml
$PROG_NOTWF 139.xml
$PROG_NOTWF 140.xml
$PROG_NOTWF 141.xml
$PROG_NOTWF 142.xml
$PROG_NOTWF 143.xml
$PROG_NOTWF 144.xml
$PROG_NOTWF 145.xml
$PROG_NOTWF 146.xml
$PROG_NOTWF 147.xml
$PROG_NOTWF 148.xml
$PROG_NOTWF 149.xml
$PROG_NOTWF 150.xml
$PROG_NOTWF 151.xml
$PROG_NOTWF 152.xml
$PROG_NOTWF 153.xml
$PROG_NOTWF 154.xml
$PROG_NOTWF 155.xml
$PROG_NOTWF 156.xml
$PROG_NOTWF 157.xml
$PROG_NOTWF 158.xml
$PROG_NOTWF 159.xml
$PROG_NOTWF 160.xml
$PROG_NOTWF 161.xml
$PROG_NOTWF 162.xml
$PROG_NOTWF 163.xml
$PROG_NOTWF 164.xml
$PROG_NOTWF 165.xml
# Omitted - requires unicode?
#
#$PROG_NOTWF 166.xml
#$PROG_NOTWF 167.xml
#$PROG_NOTWF 168.xml
#$PROG_NOTWF 169.xml
#$PROG_NOTWF 170.xml
#$PROG_NOTWF 171.xml
#$PROG_NOTWF 172.xml
#$PROG_NOTWF 173.xml
#$PROG_NOTWF 174.xml
#$PROG_NOTWF 175.xml
$PROG_NOTWF 176.xml
#$PROG_NOTWF 177.xml
$PROG_NOTWF 178.xml
$PROG_NOTWF 179.xml
$PROG_NOTWF 180.xml
$PROG_NOTWF 181.xml
$PROG_NOTWF 182.xml
$PROG_NOTWF 183.xml
$PROG_NOTWF 184.xml
$PROG_NOTWF 185.xml
$PROG_NOTWF 186.xml


cd $TESTS/oasis

$PROG_NOTWF p01fail1.xml
$PROG_NOTWF p01fail2.xml
$PROG_NOTWF p01fail3.xml
$PROG_NOTWF p01fail4.xml
$PROG_NOTWF p02fail1.xml
$PROG_NOTWF p02fail10.xml
$PROG_NOTWF p02fail11.xml
$PROG_NOTWF p02fail12.xml
$PROG_NOTWF p02fail13.xml
$PROG_NOTWF p02fail14.xml
$PROG_NOTWF p02fail15.xml
$PROG_NOTWF p02fail16.xml
$PROG_NOTWF p02fail17.xml
$PROG_NOTWF p02fail18.xml
$PROG_NOTWF p02fail19.xml
$PROG_NOTWF p02fail2.xml
$PROG_NOTWF p02fail20.xml
$PROG_NOTWF p02fail21.xml
$PROG_NOTWF p02fail22.xml
$PROG_NOTWF p02fail23.xml
$PROG_NOTWF p02fail24.xml
$PROG_NOTWF p02fail25.xml
$PROG_NOTWF p02fail26.xml
$PROG_NOTWF p02fail27.xml
$PROG_NOTWF p02fail28.xml
$PROG_NOTWF p02fail29.xml
$PROG_NOTWF p02fail3.xml
$PROG_NOTWF p02fail30.xml
$PROG_NOTWF p02fail31.xml
$PROG_NOTWF p02fail4.xml
$PROG_NOTWF p02fail5.xml
$PROG_NOTWF p02fail6.xml
$PROG_NOTWF p02fail7.xml
$PROG_NOTWF p02fail8.xml
$PROG_NOTWF p02fail9.xml
$PROG_NOTWF p03fail1.xml
$PROG_NOTWF p03fail10.xml
$PROG_NOTWF p03fail11.xml
$PROG_NOTWF p03fail12.xml
$PROG_NOTWF p03fail13.xml
$PROG_NOTWF p03fail14.xml
$PROG_NOTWF p03fail15.xml
$PROG_NOTWF p03fail16.xml
$PROG_NOTWF p03fail17.xml
$PROG_NOTWF p03fail18.xml
$PROG_NOTWF p03fail19.xml
$PROG_NOTWF p03fail2.xml
$PROG_NOTWF p03fail20.xml
$PROG_NOTWF p03fail21.xml
$PROG_NOTWF p03fail22.xml
$PROG_NOTWF p03fail23.xml
$PROG_NOTWF p03fail24.xml
$PROG_NOTWF p03fail25.xml
$PROG_NOTWF p03fail26.xml
$PROG_NOTWF p03fail27.xml
$PROG_NOTWF p03fail28.xml
$PROG_NOTWF p03fail29.xml
$PROG_NOTWF p03fail3.xml
$PROG_NOTWF p03fail4.xml
$PROG_NOTWF p03fail5.xml
$PROG_NOTWF p03fail7.xml
$PROG_NOTWF p03fail8.xml
$PROG_NOTWF p03fail9.xml
$PROG_NOTWF p04fail1.xml
$PROG_NOTWF p04fail2.xml
$PROG_NOTWF p04fail3.xml
$PROG_NOTWF p05fail1.xml
$PROG_NOTWF p05fail2.xml
$PROG_NOTWF p05fail3.xml
$PROG_NOTWF p05fail4.xml
$PROG_NOTWF p05fail5.xml
$PROG_INVALID p06fail1.xml
$PROG_INVALID p08fail1.xml
$PROG_INVALID p08fail2.xml
$PROG_NOTWF p09fail1.xml
$PROG_NOTWF p09fail2.xml
$PROG_NOTWF p09fail3.xml
$PROG_NOTWF p09fail4.xml
$PROG_NOTWF p09fail5.xml
$PROG_NOTWF p10fail1.xml
$PROG_NOTWF p10fail2.xml
$PROG_NOTWF p10fail3.xml
$PROG_NOTWF p11fail1.xml
$PROG_NOTWF p11fail2.xml
$PROG_NOTWF p12fail1.xml
$PROG_NOTWF p12fail2.xml
$PROG_NOTWF p12fail3.xml
$PROG_NOTWF p12fail4.xml
$PROG_NOTWF p12fail5.xml
$PROG_NOTWF p12fail6.xml
$PROG_NOTWF p12fail7.xml
$PROG_NOTWF p14fail1.xml
$PROG_NOTWF p14fail2.xml
$PROG_NOTWF p14fail3.xml
$PROG_NOTWF p15fail1.xml
$PROG_NOTWF p15fail2.xml
$PROG_NOTWF p15fail3.xml
$PROG_NOTWF p16fail1.xml
$PROG_NOTWF p16fail2.xml
$PROG_INVALID p16fail3.xml
$PROG_NOTWF p18fail1.xml
$PROG_NOTWF p18fail2.xml
$PROG_NOTWF p18fail3.xml
$PROG_NOTWF p22fail1.xml
$PROG_NOTWF p22fail2.xml
$PROG_NOTWF p23fail1.xml
$PROG_NOTWF p23fail2.xml
$PROG_NOTWF p23fail3.xml
$PROG_NOTWF p23fail4.xml
$PROG_NOTWF p23fail5.xml
$PROG_NOTWF p24fail1.xml
$PROG_NOTWF p24fail2.xml
$PROG_NOTWF p25fail1.xml
$PROG_NOTWF p26fail1.xml
$PROG_NOTWF p26fail2.xml
$PROG_NOTWF p27fail1.xml
$PROG_NOTWF p28fail1.xml
$PROG_NOTWF p29fail1.xml
$PROG_NOTWF p30fail1.xml
$PROG_NOTWF p31fail1.xml
$PROG_NOTWF p32fail1.xml
$PROG_NOTWF p32fail2.xml
$PROG_NOTWF p32fail3.xml
$PROG_NOTWF p32fail4.xml
$PROG_NOTWF p32fail5.xml
$PROG_NOTWF p39fail1.xml
$PROG_NOTWF p39fail2.xml
$PROG_NOTWF p39fail4.xml
$PROG_NOTWF p39fail5.xml
$PROG_NOTWF p40fail1.xml
$PROG_NOTWF p40fail2.xml
$PROG_NOTWF p40fail3.xml
$PROG_NOTWF p40fail4.xml
$PROG_NOTWF p41fail1.xml
$PROG_NOTWF p41fail2.xml
$PROG_NOTWF p41fail3.xml
$PROG_NOTWF p42fail1.xml
$PROG_NOTWF p42fail2.xml
$PROG_NOTWF p42fail3.xml
$PROG_NOTWF p43fail1.xml
$PROG_NOTWF p43fail2.xml
$PROG_NOTWF p43fail3.xml
$PROG_NOTWF p44fail1.xml
$PROG_NOTWF p44fail2.xml
$PROG_NOTWF p44fail3.xml
$PROG_NOTWF p44fail4.xml
$PROG_NOTWF p44fail5.xml
$PROG_NOTWF p45fail1.xml
$PROG_NOTWF p45fail2.xml
$PROG_NOTWF p45fail3.xml
$PROG_NOTWF p45fail4.xml
$PROG_NOTWF p46fail1.xml
$PROG_NOTWF p46fail2.xml
$PROG_NOTWF p46fail3.xml
$PROG_NOTWF p46fail4.xml
$PROG_NOTWF p46fail5.xml
$PROG_NOTWF p46fail6.xml
$PROG_NOTWF p47fail1.xml
$PROG_NOTWF p47fail2.xml
$PROG_NOTWF p47fail3.xml
$PROG_NOTWF p47fail4.xml
$PROG_NOTWF p48fail1.xml
$PROG_NOTWF p48fail2.xml
$PROG_NOTWF p49fail1.xml
$PROG_NOTWF p50fail1.xml
$PROG_NOTWF p51fail1.xml
$PROG_NOTWF p51fail2.xml
$PROG_NOTWF p51fail3.xml
$PROG_NOTWF p51fail4.xml
$PROG_NOTWF p51fail5.xml
$PROG_NOTWF p51fail6.xml
$PROG_NOTWF p51fail7.xml
$PROG_NOTWF p52fail1.xml
$PROG_NOTWF p52fail2.xml
$PROG_NOTWF p53fail1.xml
$PROG_NOTWF p53fail2.xml
$PROG_NOTWF p53fail3.xml
$PROG_NOTWF p53fail4.xml
$PROG_NOTWF p53fail5.xml
$PROG_NOTWF p54fail1.xml
$PROG_NOTWF p55fail1.xml
$PROG_NOTWF p56fail1.xml
$PROG_NOTWF p56fail2.xml
$PROG_NOTWF p56fail3.xml
$PROG_NOTWF p56fail4.xml
$PROG_NOTWF p56fail5.xml
$PROG_NOTWF p57fail1.xml
$PROG_NOTWF p58fail1.xml
$PROG_NOTWF p58fail2.xml
$PROG_NOTWF p58fail3.xml
$PROG_NOTWF p58fail4.xml
$PROG_NOTWF p58fail5.xml
$PROG_NOTWF p58fail6.xml
$PROG_NOTWF p58fail7.xml
$PROG_NOTWF p58fail8.xml
$PROG_NOTWF p59fail1.xml
$PROG_NOTWF p59fail2.xml
$PROG_NOTWF p59fail3.xml
$PROG_NOTWF p60fail1.xml
$PROG_NOTWF p60fail2.xml
$PROG_NOTWF p60fail3.xml
$PROG_NOTWF p60fail4.xml
$PROG_NOTWF p60fail5.xml
$PROG_NOTWF p61fail1.xml
$PROG_NOTWF p62fail1.xml
$PROG_NOTWF p62fail2.xml
$PROG_NOTWF p63fail1.xml
$PROG_NOTWF p63fail2.xml
$PROG_NOTWF p64fail1.xml
$PROG_NOTWF p64fail2.xml
$PROG_NOTWF p66fail1.xml
$PROG_NOTWF p66fail2.xml
$PROG_NOTWF p66fail3.xml
$PROG_NOTWF p66fail4.xml
$PROG_NOTWF p66fail5.xml
$PROG_NOTWF p66fail6.xml
$PROG_NOTWF p68fail1.xml
$PROG_NOTWF p68fail2.xml
$PROG_NOTWF p68fail3.xml
$PROG_NOTWF p69fail1.xml
$PROG_NOTWF p69fail2.xml
$PROG_NOTWF p69fail3.xml
$PROG_NOTWF p70fail1.xml
$PROG_NOTWF p71fail1.xml
$PROG_NOTWF p71fail2.xml
$PROG_NOTWF p71fail3.xml
$PROG_NOTWF p71fail4.xml
$PROG_NOTWF p72fail1.xml
$PROG_NOTWF p72fail2.xml
$PROG_NOTWF p72fail3.xml
$PROG_NOTWF p72fail4.xml
$PROG_NOTWF p73fail1.xml
$PROG_NOTWF p73fail2.xml
$PROG_NOTWF p73fail3.xml
$PROG_NOTWF p73fail4.xml
$PROG_NOTWF p73fail5.xml
$PROG_NOTWF p74fail1.xml
$PROG_NOTWF p74fail2.xml
$PROG_NOTWF p74fail3.xml
$PROG_NOTWF p75fail1.xml
$PROG_NOTWF p75fail2.xml
$PROG_NOTWF p75fail3.xml
$PROG_NOTWF p75fail4.xml
$PROG_NOTWF p75fail5.xml
$PROG_NOTWF p75fail6.xml
$PROG_NOTWF p76fail1.xml
$PROG_NOTWF p76fail2.xml
$PROG_NOTWF p76fail3.xml
$PROG_NOTWF p76fail4.xml

$PROG_VALID p01pass1.xml
$PROG_VALID p01pass2.xml
$PROG_VALID p01pass3.xml
$PROG_VALID p03pass1.xml
#omitted - needs unicode
#$PROG_VALID p04pass1.xml
$PROG_VALID p05pass1.xml
$PROG_VALID p06pass1.xml
$PROG_VALID p07pass1.xml
$PROG_VALID p08pass1.xml
$PROG_VALID p09pass1.xml
$PROG_VALID p10pass1.xml
$PROG_VALID p11pass1.xml
$PROG_VALID p12pass1.xml
$PROG_VALID p14pass1.xml
$PROG_VALID p15pass1.xml
$PROG_VALID p16pass1.xml
$PROG_VALID p16pass2.xml
$PROG_VALID p16pass3.xml
$PROG_VALID p18pass1.xml
$PROG_VALID p22pass1.xml
$PROG_VALID p22pass2.xml
$PROG_VALID p22pass3.xml
$PROG_VALID p22pass4.xml
$PROG_VALID p22pass5.xml
$PROG_VALID p22pass6.xml
$PROG_VALID p23pass1.xml
$PROG_VALID p23pass2.xml
$PROG_VALID p23pass3.xml
$PROG_VALID p23pass4.xml
$PROG_VALID p24pass1.xml
$PROG_VALID p24pass2.xml
$PROG_VALID p24pass3.xml
$PROG_VALID p24pass4.xml
$PROG_VALID p25pass1.xml
$PROG_VALID p25pass2.xml
$PROG_VALID p26pass1.xml
$PROG_VALID p27pass1.xml
$PROG_VALID p27pass2.xml
$PROG_VALID p27pass3.xml
$PROG_VALID p27pass4.xml
$PROG_VALID p28pass1.xml
$PROG_VALID p28pass2.xml
$PROG_VALID p28pass3.xml
$PROG_VALID p28pass4.xml
$PROG_VALID p28pass5.xml
$PROG_VALID p29pass1.xml
$PROG_VALID p30pass1.xml
$PROG_VALID p30pass2.xml
$PROG_VALID p31pass1.xml
$PROG_VALID p31pass2.xml
$PROG_VALID p32pass1.xml
$PROG_VALID p32pass2.xml
$PROG_VALID p39pass1.xml
$PROG_VALID p39pass2.xml
$PROG_VALID p40pass1.xml
$PROG_VALID p40pass2.xml
$PROG_VALID p40pass3.xml
$PROG_VALID p40pass4.xml
$PROG_VALID p41pass1.xml
$PROG_VALID p41pass2.xml
$PROG_VALID p42pass1.xml
$PROG_VALID p42pass2.xml
$PROG_VALID p43pass1.xml
$PROG_VALID p44pass1.xml
$PROG_VALID p44pass2.xml
$PROG_VALID p44pass3.xml
$PROG_VALID p44pass4.xml
$PROG_VALID p44pass5.xml
$PROG_VALID p45pass1.xml
$PROG_VALID p46pass1.xml
$PROG_VALID p47pass1.xml
$PROG_VALID p48pass1.xml
$PROG_VALID p49pass1.xml
$PROG_VALID p50pass1.xml
$PROG_VALID p51pass1.xml
$PROG_VALID p52pass1.xml
$PROG_VALID p53pass1.xml
$PROG_VALID p54pass1.xml
$PROG_VALID p55pass1.xml
$PROG_VALID p56pass1.xml
$PROG_VALID p57pass1.xml
$PROG_VALID p58pass1.xml
$PROG_VALID p59pass1.xml
$PROG_VALID p60pass1.xml
$PROG_VALID p61pass1.xml
$PROG_VALID p62pass1.xml
$PROG_VALID p63pass1.xml
$PROG_VALID p64pass1.xml
$PROG_VALID p66pass1.xml
$PROG_VALID p68pass1.xml
$PROG_VALID p69pass1.xml
$PROG_VALID p70pass1.xml
$PROG_VALID p71pass1.xml
$PROG_VALID p72pass1.xml
$PROG_VALID p73pass1.xml
$PROG_VALID p74pass1.xml
$PROG_VALID p75pass1.xml
$PROG_VALID p76pass1.xml

cd $TESTS/ibm/invalid

cd $TESTS/ibm/invalid/P29
$PROG_INVALID ibm29i01.xml out/ibm29i01.xml

cd $TESTS/ibm/invalid/P32
$PROG_INVALID ibm32i01.xml out/ibm32i01.xml

cd $TESTS/ibm/invalid/P32
$PROG_INVALID ibm32i02.xml out/ibm32i02.xml

# Don't do some standalone=yes tests
#cd $TESTS/ibm/invalid/P32
#$PROG_INVALID ibm32i03.xml out/ibm32i03.xml
#
#cd $TESTS/ibm/invalid/P32
#$PROG_INVALID ibm32i04.xml out/ibm32i04.xml
#
cd $TESTS/ibm/invalid/P39
$PROG_INVALID ibm39i01.xml out/ibm39i01.xml

cd $TESTS/ibm/invalid/P39
$PROG_INVALID ibm39i02.xml out/ibm39i02.xml

cd $TESTS/ibm/invalid/P39
$PROG_INVALID ibm39i03.xml out/ibm39i03.xml

cd $TESTS/ibm/invalid/P39
$PROG_INVALID ibm39i04.xml out/ibm39i04.xml

cd $TESTS/ibm/invalid/P41
$PROG_INVALID ibm41i01.xml out/ibm41i01.xml

cd $TESTS/ibm/invalid/P41
$PROG_INVALID ibm41i02.xml out/ibm41i02.xml

cd $TESTS/ibm/invalid/P45
$PROG_INVALID ibm45i01.xml out/ibm45i01.xml

# Don't check for unbalanced parentheses etc (3.2.1) in pe expansions in contentspec
#cd $TESTS/ibm/invalid/P49
#$PROG_INVALID ibm49i01.xml out/ibm49i01.xml
#
cd $TESTS/ibm/invalid/P49
$PROG_INVALID ibm49i02.xml out/ibm49i02.xml

# Don't check for unbalanced parentheses etc (3.2.1) in pe expansions in contentspec
#cd $TESTS/ibm/invalid/P50
#$PROG_INVALID ibm50i01.xml out/ibm50i01.xml
#
#cd $TESTS/ibm/invalid/P51
#$PROG_INVALID ibm51i01.xml out/ibm51i01.xml
#
cd $TESTS/ibm/invalid/P51
$PROG_INVALID ibm51i03.xml out/ibm51i03.xml

cd $TESTS/ibm/invalid/P56
$PROG_INVALID ibm56i01.xml out/ibm56i01.xml

cd $TESTS/ibm/invalid/P56
$PROG_INVALID ibm56i02.xml out/ibm56i02.xml

cd $TESTS/ibm/invalid/P56
$PROG_INVALID ibm56i03.xml out/ibm56i03.xml

cd $TESTS/ibm/invalid/P56
$PROG_INVALID ibm56i05.xml out/ibm56i05.xml

cd $TESTS/ibm/invalid/P56
$PROG_INVALID ibm56i06.xml out/ibm56i06.xml

cd $TESTS/ibm/invalid/P56
$PROG_INVALID ibm56i07.xml out/ibm56i07.xml

cd $TESTS/ibm/invalid/P56
$PROG_INVALID ibm56i08.xml out/ibm56i08.xml

cd $TESTS/ibm/invalid/P56
$PROG_INVALID ibm56i09.xml out/ibm56i09.xml

cd $TESTS/ibm/invalid/P56
$PROG_INVALID ibm56i10.xml out/ibm56i10.xml

cd $TESTS/ibm/invalid/P56
$PROG_INVALID ibm56i11.xml out/ibm56i11.xml

cd $TESTS/ibm/invalid/P56
$PROG_INVALID ibm56i12.xml out/ibm56i12.xml

cd $TESTS/ibm/invalid/P56
$PROG_INVALID ibm56i13.xml out/ibm56i13.xml

cd $TESTS/ibm/invalid/P56
$PROG_INVALID ibm56i14.xml out/ibm56i14.xml

cd $TESTS/ibm/invalid/P56
$PROG_INVALID ibm56i15.xml out/ibm56i15.xml

cd $TESTS/ibm/invalid/P56
$PROG_INVALID ibm56i16.xml out/ibm56i16.xml

cd $TESTS/ibm/invalid/P56
$PROG_INVALID ibm56i17.xml out/ibm56i17.xml

cd $TESTS/ibm/invalid/P56
$PROG_INVALID ibm56i18.xml out/ibm56i18.xml

cd $TESTS/ibm/invalid/P58
$PROG_INVALID ibm58i01.xml out/ibm58i01.xml

cd $TESTS/ibm/invalid/P58
$PROG_INVALID ibm58i02.xml out/ibm58i02.xml

cd $TESTS/ibm/invalid/P59
$PROG_INVALID ibm59i01.xml out/ibm59i01.xml

cd $TESTS/ibm/invalid/P60
$PROG_INVALID ibm60i01.xml out/ibm60i01.xml

cd $TESTS/ibm/invalid/P60
$PROG_INVALID ibm60i02.xml out/ibm60i02.xml

cd $TESTS/ibm/invalid/P60
$PROG_INVALID ibm60i03.xml out/ibm60i03.xml

cd $TESTS/ibm/invalid/P60
$PROG_INVALID ibm60i04.xml out/ibm60i04.xml

cd $TESTS/ibm/invalid/P68
$PROG_INVALID ibm68i01.xml out/ibm68i01.xml

cd $TESTS/ibm/invalid/P68
$PROG_INVALID ibm68i02.xml out/ibm68i02.xml

cd $TESTS/ibm/invalid/P68
$PROG_INVALID ibm68i03.xml out/ibm68i03.xml

cd $TESTS/ibm/invalid/P68
$PROG_INVALID ibm68i04.xml out/ibm68i04.xml

cd $TESTS/ibm/invalid/P69
$PROG_INVALID ibm69i01.xml out/ibm69i01.xml

cd $TESTS/ibm/invalid/P69
$PROG_INVALID ibm69i02.xml out/ibm69i02.xml

cd $TESTS/ibm/invalid/P69
$PROG_INVALID ibm69i03.xml out/ibm69i03.xml

cd $TESTS/ibm/invalid/P69
$PROG_INVALID ibm69i04.xml out/ibm69i04.xml

cd $TESTS/ibm/invalid/P76
$PROG_INVALID ibm76i01.xml out/ibm76i01.xml

cd $TESTS/ibm/invalid/P28
$PROG_INVALID ibm28i01.xml out/ibm28i01.xml


cd $TESTS/ibm/not-wf/misc
# Omitted: don't check entity expansions for well-formedness until their use.
#$PROG_NOTWF 432gewf.xml
$PROG_NOTWF ltinentval.xml
$PROG_NOTWF simpleltinentval.xml

cd $TESTS/ibm/not-wf/P04
$PROG_NOTWF ibm04n01.xml

cd $TESTS/ibm/not-wf/P04
$PROG_NOTWF ibm04n02.xml

cd $TESTS/ibm/not-wf/P04
$PROG_NOTWF ibm04n03.xml

cd $TESTS/ibm/not-wf/P04
$PROG_NOTWF ibm04n04.xml

cd $TESTS/ibm/not-wf/P04
$PROG_NOTWF ibm04n05.xml

cd $TESTS/ibm/not-wf/P04
$PROG_NOTWF ibm04n06.xml

cd $TESTS/ibm/not-wf/P04
$PROG_NOTWF ibm04n07.xml

cd $TESTS/ibm/not-wf/P04
$PROG_NOTWF ibm04n08.xml

cd $TESTS/ibm/not-wf/P04
$PROG_NOTWF ibm04n09.xml

cd $TESTS/ibm/not-wf/P04
$PROG_NOTWF ibm04n10.xml

cd $TESTS/ibm/not-wf/P04
$PROG_NOTWF ibm04n11.xml

cd $TESTS/ibm/not-wf/P04
$PROG_NOTWF ibm04n12.xml

cd $TESTS/ibm/not-wf/P04
$PROG_NOTWF ibm04n13.xml

cd $TESTS/ibm/not-wf/P04
$PROG_NOTWF ibm04n14.xml

cd $TESTS/ibm/not-wf/P04
$PROG_NOTWF ibm04n15.xml

cd $TESTS/ibm/not-wf/P04
$PROG_NOTWF ibm04n16.xml

cd $TESTS/ibm/not-wf/P04
$PROG_NOTWF ibm04n17.xml

cd $TESTS/ibm/not-wf/P04
$PROG_NOTWF ibm04n18.xml

cd $TESTS/ibm/not-wf/P05
$PROG_NOTWF ibm05n01.xml

cd $TESTS/ibm/not-wf/P05
$PROG_NOTWF ibm05n02.xml

cd $TESTS/ibm/not-wf/P05
$PROG_NOTWF ibm05n03.xml

cd $TESTS/ibm/not-wf/P05
$PROG_NOTWF ibm05n04.xml

cd $TESTS/ibm/not-wf/P05
$PROG_NOTWF ibm05n05.xml

cd $TESTS/ibm/not-wf/P09
$PROG_NOTWF ibm09n01.xml

cd $TESTS/ibm/not-wf/P09
$PROG_NOTWF ibm09n02.xml

cd $TESTS/ibm/not-wf/P09
$PROG_NOTWF ibm09n03.xml

cd $TESTS/ibm/not-wf/P09
$PROG_NOTWF ibm09n04.xml

cd $TESTS/ibm/not-wf/P10
$PROG_NOTWF ibm10n01.xml

cd $TESTS/ibm/not-wf/P10
$PROG_NOTWF ibm10n02.xml

cd $TESTS/ibm/not-wf/P10
$PROG_NOTWF ibm10n03.xml

cd $TESTS/ibm/not-wf/P10
$PROG_NOTWF ibm10n04.xml

cd $TESTS/ibm/not-wf/P10
$PROG_NOTWF ibm10n05.xml

cd $TESTS/ibm/not-wf/P10
$PROG_NOTWF ibm10n06.xml

cd $TESTS/ibm/not-wf/P10
$PROG_NOTWF ibm10n07.xml

cd $TESTS/ibm/not-wf/P10
$PROG_NOTWF ibm10n08.xml

cd $TESTS/ibm/not-wf/P11
$PROG_NOTWF ibm11n01.xml

cd $TESTS/ibm/not-wf/P11
$PROG_NOTWF ibm11n02.xml

cd $TESTS/ibm/not-wf/P11
$PROG_NOTWF ibm11n03.xml

cd $TESTS/ibm/not-wf/P11
$PROG_NOTWF ibm11n04.xml

cd $TESTS/ibm/not-wf/P12
$PROG_NOTWF ibm12n01.xml

cd $TESTS/ibm/not-wf/P12
$PROG_NOTWF ibm12n02.xml

cd $TESTS/ibm/not-wf/P12
$PROG_NOTWF ibm12n03.xml

cd $TESTS/ibm/not-wf/P13
$PROG_NOTWF ibm13n01.xml

cd $TESTS/ibm/not-wf/P13
$PROG_NOTWF ibm13n02.xml

cd $TESTS/ibm/not-wf/P13
$PROG_NOTWF ibm13n03.xml

cd $TESTS/ibm/not-wf/P14
$PROG_NOTWF ibm14n01.xml

cd $TESTS/ibm/not-wf/P14
$PROG_NOTWF ibm14n02.xml

cd $TESTS/ibm/not-wf/P14
$PROG_NOTWF ibm14n03.xml

cd $TESTS/ibm/not-wf/P15
$PROG_NOTWF ibm15n01.xml

cd $TESTS/ibm/not-wf/P15
$PROG_NOTWF ibm15n02.xml

cd $TESTS/ibm/not-wf/P15
$PROG_NOTWF ibm15n03.xml

cd $TESTS/ibm/not-wf/P15
$PROG_NOTWF ibm15n04.xml

cd $TESTS/ibm/not-wf/P16
$PROG_NOTWF ibm16n01.xml

cd $TESTS/ibm/not-wf/P16
$PROG_NOTWF ibm16n02.xml

cd $TESTS/ibm/not-wf/P16
$PROG_NOTWF ibm16n03.xml

cd $TESTS/ibm/not-wf/P16
$PROG_NOTWF ibm16n04.xml

cd $TESTS/ibm/not-wf/P17
$PROG_NOTWF ibm17n01.xml

cd $TESTS/ibm/not-wf/P17
$PROG_NOTWF ibm17n02.xml

cd $TESTS/ibm/not-wf/P17
$PROG_NOTWF ibm17n03.xml

cd $TESTS/ibm/not-wf/P17
$PROG_NOTWF ibm17n04.xml

cd $TESTS/ibm/not-wf/P18
$PROG_NOTWF ibm18n01.xml

cd $TESTS/ibm/not-wf/P18
$PROG_NOTWF ibm18n02.xml

cd $TESTS/ibm/not-wf/P19
$PROG_NOTWF ibm19n01.xml

cd $TESTS/ibm/not-wf/P19
$PROG_NOTWF ibm19n02.xml

cd $TESTS/ibm/not-wf/P19
$PROG_NOTWF ibm19n03.xml

cd $TESTS/ibm/not-wf/P20
$PROG_NOTWF ibm20n01.xml

cd $TESTS/ibm/not-wf/P21
$PROG_NOTWF ibm21n01.xml

cd $TESTS/ibm/not-wf/P21
$PROG_NOTWF ibm21n02.xml

cd $TESTS/ibm/not-wf/P21
$PROG_NOTWF ibm21n03.xml

cd $TESTS/ibm/not-wf/P22
$PROG_NOTWF ibm22n01.xml

cd $TESTS/ibm/not-wf/P22
$PROG_NOTWF ibm22n02.xml

cd $TESTS/ibm/not-wf/P22
$PROG_NOTWF ibm22n03.xml

cd $TESTS/ibm/not-wf/P23
$PROG_NOTWF ibm23n01.xml

cd $TESTS/ibm/not-wf/P23
$PROG_NOTWF ibm23n02.xml

cd $TESTS/ibm/not-wf/P23
$PROG_NOTWF ibm23n03.xml

cd $TESTS/ibm/not-wf/P23
$PROG_NOTWF ibm23n04.xml

cd $TESTS/ibm/not-wf/P23
$PROG_NOTWF ibm23n05.xml

cd $TESTS/ibm/not-wf/P23
$PROG_NOTWF ibm23n06.xml

cd $TESTS/ibm/not-wf/P24
$PROG_NOTWF ibm24n01.xml

cd $TESTS/ibm/not-wf/P24
$PROG_NOTWF ibm24n02.xml

cd $TESTS/ibm/not-wf/P24
$PROG_NOTWF ibm24n03.xml

cd $TESTS/ibm/not-wf/P24
$PROG_NOTWF ibm24n04.xml

cd $TESTS/ibm/not-wf/P24
$PROG_NOTWF ibm24n05.xml

cd $TESTS/ibm/not-wf/P24
$PROG_NOTWF ibm24n06.xml

cd $TESTS/ibm/not-wf/P24
$PROG_NOTWF ibm24n07.xml

cd $TESTS/ibm/not-wf/P24
$PROG_NOTWF ibm24n08.xml

cd $TESTS/ibm/not-wf/P24
$PROG_NOTWF ibm24n09.xml

cd $TESTS/ibm/not-wf/P25
$PROG_NOTWF ibm25n01.xml

cd $TESTS/ibm/not-wf/P25
$PROG_NOTWF ibm25n02.xml

cd $TESTS/ibm/not-wf/P26
$PROG_NOTWF ibm26n01.xml

cd $TESTS/ibm/not-wf/P27
$PROG_NOTWF ibm27n01.xml

cd $TESTS/ibm/not-wf/P28
$PROG_NOTWF ibm28n01.xml

cd $TESTS/ibm/not-wf/P28
$PROG_NOTWF ibm28n02.xml

cd $TESTS/ibm/not-wf/P28
$PROG_NOTWF ibm28n03.xml

cd $TESTS/ibm/not-wf/P28
$PROG_NOTWF ibm28n04.xml

cd $TESTS/ibm/not-wf/P28
$PROG_NOTWF ibm28n05.xml

cd $TESTS/ibm/not-wf/P28
$PROG_NOTWF ibm28n06.xml

cd $TESTS/ibm/not-wf/P28
$PROG_NOTWF ibm28n07.xml

cd $TESTS/ibm/not-wf/P28
$PROG_NOTWF ibm28n08.xml

cd $TESTS/ibm/not-wf/P29
$PROG_NOTWF ibm29n01.xml

cd $TESTS/ibm/not-wf/P29
$PROG_NOTWF ibm29n02.xml

cd $TESTS/ibm/not-wf/P29
$PROG_NOTWF ibm29n03.xml

cd $TESTS/ibm/not-wf/P29
$PROG_NOTWF ibm29n04.xml

cd $TESTS/ibm/not-wf/P29
$PROG_NOTWF ibm29n05.xml

cd $TESTS/ibm/not-wf/P29
$PROG_NOTWF ibm29n06.xml

cd $TESTS/ibm/not-wf/P29
$PROG_NOTWF ibm29n07.xml

cd $TESTS/ibm/not-wf/P30
$PROG_NOTWF ibm30n01.xml

cd $TESTS/ibm/not-wf/P31
$PROG_NOTWF ibm31n01.xml

cd $TESTS/ibm/not-wf/P32
$PROG_NOTWF ibm32n01.xml

cd $TESTS/ibm/not-wf/P32
$PROG_NOTWF ibm32n02.xml

cd $TESTS/ibm/not-wf/P32
$PROG_NOTWF ibm32n03.xml

cd $TESTS/ibm/not-wf/P32
$PROG_NOTWF ibm32n04.xml

cd $TESTS/ibm/not-wf/P32
$PROG_NOTWF ibm32n05.xml

cd $TESTS/ibm/not-wf/P32
$PROG_NOTWF ibm32n06.xml

cd $TESTS/ibm/not-wf/P32
$PROG_NOTWF ibm32n07.xml

cd $TESTS/ibm/not-wf/P32
$PROG_NOTWF ibm32n08.xml

cd $TESTS/ibm/not-wf/P39
$PROG_NOTWF ibm39n01.xml

cd $TESTS/ibm/not-wf/P39
$PROG_NOTWF ibm39n02.xml

cd $TESTS/ibm/not-wf/P39
$PROG_NOTWF ibm39n03.xml

cd $TESTS/ibm/not-wf/P39
$PROG_NOTWF ibm39n04.xml

cd $TESTS/ibm/not-wf/P39
$PROG_NOTWF ibm39n05.xml

cd $TESTS/ibm/not-wf/P39
$PROG_NOTWF ibm39n06.xml

cd $TESTS/ibm/not-wf/P40
$PROG_NOTWF ibm40n01.xml

cd $TESTS/ibm/not-wf/P40
$PROG_NOTWF ibm40n02.xml

cd $TESTS/ibm/not-wf/P40
$PROG_NOTWF ibm40n03.xml

cd $TESTS/ibm/not-wf/P40
$PROG_NOTWF ibm40n04.xml

cd $TESTS/ibm/not-wf/P40
$PROG_NOTWF ibm40n05.xml

cd $TESTS/ibm/not-wf/P41
$PROG_NOTWF ibm41n01.xml

cd $TESTS/ibm/not-wf/P41
$PROG_NOTWF ibm41n02.xml

cd $TESTS/ibm/not-wf/P41
$PROG_NOTWF ibm41n03.xml

cd $TESTS/ibm/not-wf/P41
$PROG_NOTWF ibm41n04.xml

cd $TESTS/ibm/not-wf/P41
$PROG_NOTWF ibm41n05.xml

cd $TESTS/ibm/not-wf/P41
$PROG_NOTWF ibm41n06.xml

cd $TESTS/ibm/not-wf/P41
$PROG_NOTWF ibm41n07.xml

cd $TESTS/ibm/not-wf/P41
$PROG_NOTWF ibm41n08.xml

cd $TESTS/ibm/not-wf/P41
$PROG_NOTWF ibm41n09.xml

cd $TESTS/ibm/not-wf/P41
$PROG_NOTWF ibm41n10.xml

cd $TESTS/ibm/not-wf/P41
$PROG_NOTWF ibm41n11.xml

cd $TESTS/ibm/not-wf/P41
$PROG_NOTWF ibm41n12.xml

cd $TESTS/ibm/not-wf/P41
$PROG_NOTWF ibm41n13.xml

cd $TESTS/ibm/not-wf/P41
$PROG_NOTWF ibm41n14.xml

cd $TESTS/ibm/not-wf/P42
$PROG_NOTWF ibm42n01.xml

cd $TESTS/ibm/not-wf/P42
$PROG_NOTWF ibm42n02.xml

cd $TESTS/ibm/not-wf/P42
$PROG_NOTWF ibm42n03.xml

cd $TESTS/ibm/not-wf/P42
$PROG_NOTWF ibm42n04.xml

cd $TESTS/ibm/not-wf/P42
$PROG_NOTWF ibm42n05.xml

cd $TESTS/ibm/not-wf/P43
$PROG_NOTWF ibm43n01.xml

cd $TESTS/ibm/not-wf/P43
$PROG_NOTWF ibm43n02.xml

cd $TESTS/ibm/not-wf/P43
$PROG_NOTWF ibm43n04.xml

cd $TESTS/ibm/not-wf/P43
$PROG_NOTWF ibm43n05.xml

cd $TESTS/ibm/not-wf/P44
$PROG_NOTWF ibm44n01.xml

cd $TESTS/ibm/not-wf/P44
$PROG_NOTWF ibm44n02.xml

cd $TESTS/ibm/not-wf/P44
$PROG_NOTWF ibm44n03.xml

cd $TESTS/ibm/not-wf/P44
$PROG_NOTWF ibm44n04.xml

cd $TESTS/ibm/not-wf/P45
$PROG_NOTWF ibm45n01.xml

cd $TESTS/ibm/not-wf/P45
$PROG_NOTWF ibm45n02.xml

cd $TESTS/ibm/not-wf/P45
$PROG_NOTWF ibm45n03.xml

cd $TESTS/ibm/not-wf/P45
$PROG_NOTWF ibm45n04.xml

cd $TESTS/ibm/not-wf/P45
$PROG_NOTWF ibm45n05.xml

cd $TESTS/ibm/not-wf/P45
$PROG_NOTWF ibm45n06.xml

cd $TESTS/ibm/not-wf/P45
$PROG_NOTWF ibm45n07.xml

cd $TESTS/ibm/not-wf/P45
$PROG_NOTWF ibm45n08.xml

cd $TESTS/ibm/not-wf/P45
$PROG_NOTWF ibm45n09.xml

cd $TESTS/ibm/not-wf/P46
$PROG_NOTWF ibm46n01.xml

cd $TESTS/ibm/not-wf/P46
$PROG_NOTWF ibm46n02.xml

cd $TESTS/ibm/not-wf/P46
$PROG_NOTWF ibm46n03.xml

cd $TESTS/ibm/not-wf/P46
$PROG_NOTWF ibm46n04.xml

cd $TESTS/ibm/not-wf/P46
$PROG_NOTWF ibm46n05.xml

cd $TESTS/ibm/not-wf/P47
$PROG_NOTWF ibm47n01.xml

cd $TESTS/ibm/not-wf/P47
$PROG_NOTWF ibm47n02.xml

cd $TESTS/ibm/not-wf/P47
$PROG_NOTWF ibm47n03.xml

cd $TESTS/ibm/not-wf/P47
$PROG_NOTWF ibm47n04.xml

cd $TESTS/ibm/not-wf/P47
$PROG_NOTWF ibm47n05.xml

cd $TESTS/ibm/not-wf/P47
$PROG_NOTWF ibm47n06.xml

cd $TESTS/ibm/not-wf/P48
$PROG_NOTWF ibm48n01.xml

cd $TESTS/ibm/not-wf/P48
$PROG_NOTWF ibm48n02.xml

cd $TESTS/ibm/not-wf/P48
$PROG_NOTWF ibm48n03.xml

cd $TESTS/ibm/not-wf/P48
$PROG_NOTWF ibm48n04.xml

cd $TESTS/ibm/not-wf/P48
$PROG_NOTWF ibm48n05.xml

cd $TESTS/ibm/not-wf/P48
$PROG_NOTWF ibm48n06.xml

cd $TESTS/ibm/not-wf/P48
$PROG_NOTWF ibm48n07.xml

cd $TESTS/ibm/not-wf/P49
$PROG_NOTWF ibm49n01.xml

cd $TESTS/ibm/not-wf/P49
$PROG_NOTWF ibm49n02.xml

cd $TESTS/ibm/not-wf/P49
$PROG_NOTWF ibm49n03.xml

cd $TESTS/ibm/not-wf/P49
$PROG_NOTWF ibm49n04.xml

cd $TESTS/ibm/not-wf/P49
$PROG_NOTWF ibm49n05.xml

cd $TESTS/ibm/not-wf/P49
$PROG_NOTWF ibm49n06.xml

cd $TESTS/ibm/not-wf/P50
$PROG_NOTWF ibm50n01.xml

cd $TESTS/ibm/not-wf/P50
$PROG_NOTWF ibm50n02.xml

cd $TESTS/ibm/not-wf/P50
$PROG_NOTWF ibm50n03.xml

cd $TESTS/ibm/not-wf/P50
$PROG_NOTWF ibm50n04.xml

cd $TESTS/ibm/not-wf/P50
$PROG_NOTWF ibm50n05.xml

cd $TESTS/ibm/not-wf/P50
$PROG_NOTWF ibm50n06.xml

cd $TESTS/ibm/not-wf/P50
$PROG_NOTWF ibm50n07.xml

cd $TESTS/ibm/not-wf/P51
$PROG_NOTWF ibm51n01.xml

cd $TESTS/ibm/not-wf/P51
$PROG_NOTWF ibm51n02.xml

cd $TESTS/ibm/not-wf/P51
$PROG_NOTWF ibm51n03.xml

cd $TESTS/ibm/not-wf/P51
$PROG_NOTWF ibm51n04.xml

cd $TESTS/ibm/not-wf/P51
$PROG_NOTWF ibm51n05.xml

cd $TESTS/ibm/not-wf/P51
$PROG_NOTWF ibm51n06.xml

cd $TESTS/ibm/not-wf/P51
$PROG_NOTWF ibm51n07.xml

cd $TESTS/ibm/not-wf/P52
$PROG_NOTWF ibm52n01.xml

cd $TESTS/ibm/not-wf/P52
$PROG_NOTWF ibm52n02.xml

cd $TESTS/ibm/not-wf/P52
$PROG_NOTWF ibm52n03.xml

cd $TESTS/ibm/not-wf/P52
$PROG_NOTWF ibm52n04.xml

cd $TESTS/ibm/not-wf/P52
$PROG_NOTWF ibm52n05.xml

cd $TESTS/ibm/not-wf/P52
$PROG_NOTWF ibm52n06.xml

cd $TESTS/ibm/not-wf/P53
$PROG_NOTWF ibm53n01.xml

cd $TESTS/ibm/not-wf/P53
$PROG_NOTWF ibm53n02.xml

cd $TESTS/ibm/not-wf/P53
$PROG_NOTWF ibm53n03.xml

cd $TESTS/ibm/not-wf/P53
$PROG_NOTWF ibm53n04.xml

cd $TESTS/ibm/not-wf/P53
$PROG_NOTWF ibm53n05.xml

cd $TESTS/ibm/not-wf/P53
$PROG_NOTWF ibm53n06.xml

cd $TESTS/ibm/not-wf/P53
$PROG_NOTWF ibm53n07.xml

cd $TESTS/ibm/not-wf/P53
$PROG_NOTWF ibm53n08.xml

cd $TESTS/ibm/not-wf/P54
$PROG_NOTWF ibm54n01.xml

cd $TESTS/ibm/not-wf/P54
$PROG_NOTWF ibm54n02.xml

cd $TESTS/ibm/not-wf/P55
$PROG_NOTWF ibm55n01.xml

cd $TESTS/ibm/not-wf/P55
$PROG_NOTWF ibm55n02.xml

cd $TESTS/ibm/not-wf/P55
$PROG_NOTWF ibm55n03.xml

cd $TESTS/ibm/not-wf/P56
$PROG_NOTWF ibm56n01.xml

cd $TESTS/ibm/not-wf/P56
$PROG_NOTWF ibm56n02.xml

cd $TESTS/ibm/not-wf/P56
$PROG_NOTWF ibm56n03.xml

cd $TESTS/ibm/not-wf/P56
$PROG_NOTWF ibm56n04.xml

cd $TESTS/ibm/not-wf/P56
$PROG_NOTWF ibm56n05.xml

cd $TESTS/ibm/not-wf/P56
$PROG_NOTWF ibm56n06.xml

cd $TESTS/ibm/not-wf/P56
$PROG_NOTWF ibm56n07.xml

cd $TESTS/ibm/not-wf/P57
$PROG_NOTWF ibm57n01.xml

cd $TESTS/ibm/not-wf/P58
$PROG_NOTWF ibm58n01.xml

cd $TESTS/ibm/not-wf/P58
$PROG_NOTWF ibm58n02.xml

cd $TESTS/ibm/not-wf/P58
$PROG_NOTWF ibm58n03.xml

cd $TESTS/ibm/not-wf/P58
$PROG_NOTWF ibm58n04.xml

cd $TESTS/ibm/not-wf/P58
$PROG_NOTWF ibm58n05.xml

cd $TESTS/ibm/not-wf/P58
$PROG_NOTWF ibm58n06.xml

cd $TESTS/ibm/not-wf/P58
$PROG_NOTWF ibm58n07.xml

cd $TESTS/ibm/not-wf/P58
$PROG_NOTWF ibm58n08.xml

cd $TESTS/ibm/not-wf/P59
$PROG_NOTWF ibm59n01.xml

cd $TESTS/ibm/not-wf/P59
$PROG_NOTWF ibm59n02.xml

cd $TESTS/ibm/not-wf/P59
$PROG_NOTWF ibm59n03.xml

cd $TESTS/ibm/not-wf/P59
$PROG_NOTWF ibm59n04.xml

cd $TESTS/ibm/not-wf/P59
$PROG_NOTWF ibm59n05.xml

cd $TESTS/ibm/not-wf/P59
$PROG_NOTWF ibm59n06.xml

cd $TESTS/ibm/not-wf/P60
$PROG_NOTWF ibm60n01.xml

cd $TESTS/ibm/not-wf/P60
$PROG_NOTWF ibm60n02.xml

cd $TESTS/ibm/not-wf/P60
$PROG_NOTWF ibm60n03.xml

cd $TESTS/ibm/not-wf/P60
$PROG_NOTWF ibm60n04.xml

cd $TESTS/ibm/not-wf/P60
$PROG_NOTWF ibm60n05.xml

cd $TESTS/ibm/not-wf/P60
$PROG_NOTWF ibm60n06.xml

cd $TESTS/ibm/not-wf/P60
$PROG_NOTWF ibm60n07.xml

cd $TESTS/ibm/not-wf/P60
$PROG_NOTWF ibm60n08.xml

cd $TESTS/ibm/not-wf/P61
$PROG_NOTWF ibm61n01.xml

cd $TESTS/ibm/not-wf/P62
$PROG_NOTWF ibm62n01.xml

cd $TESTS/ibm/not-wf/P62
$PROG_NOTWF ibm62n02.xml

cd $TESTS/ibm/not-wf/P62
$PROG_NOTWF ibm62n03.xml

cd $TESTS/ibm/not-wf/P62
$PROG_NOTWF ibm62n04.xml

cd $TESTS/ibm/not-wf/P62
$PROG_NOTWF ibm62n05.xml

cd $TESTS/ibm/not-wf/P62
$PROG_NOTWF ibm62n06.xml

cd $TESTS/ibm/not-wf/P62
$PROG_NOTWF ibm62n07.xml

cd $TESTS/ibm/not-wf/P62
$PROG_NOTWF ibm62n08.xml

cd $TESTS/ibm/not-wf/P63
$PROG_NOTWF ibm63n01.xml

cd $TESTS/ibm/not-wf/P63
$PROG_NOTWF ibm63n02.xml

cd $TESTS/ibm/not-wf/P63
$PROG_NOTWF ibm63n03.xml

cd $TESTS/ibm/not-wf/P63
$PROG_NOTWF ibm63n04.xml

cd $TESTS/ibm/not-wf/P63
$PROG_NOTWF ibm63n05.xml

cd $TESTS/ibm/not-wf/P63
$PROG_NOTWF ibm63n06.xml

cd $TESTS/ibm/not-wf/P63
$PROG_NOTWF ibm63n07.xml

cd $TESTS/ibm/not-wf/P64
$PROG_NOTWF ibm64n01.xml

cd $TESTS/ibm/not-wf/P64
$PROG_NOTWF ibm64n02.xml

cd $TESTS/ibm/not-wf/P64
$PROG_NOTWF ibm64n03.xml

cd $TESTS/ibm/not-wf/P65
$PROG_NOTWF ibm65n01.xml

cd $TESTS/ibm/not-wf/P65
$PROG_NOTWF ibm65n02.xml

cd $TESTS/ibm/not-wf/P66
$PROG_NOTWF ibm66n01.xml

cd $TESTS/ibm/not-wf/P66
$PROG_NOTWF ibm66n02.xml

cd $TESTS/ibm/not-wf/P66
$PROG_NOTWF ibm66n03.xml

cd $TESTS/ibm/not-wf/P66
$PROG_NOTWF ibm66n04.xml

cd $TESTS/ibm/not-wf/P66
$PROG_NOTWF ibm66n05.xml

cd $TESTS/ibm/not-wf/P66
$PROG_NOTWF ibm66n06.xml

cd $TESTS/ibm/not-wf/P66
$PROG_NOTWF ibm66n07.xml

cd $TESTS/ibm/not-wf/P66
$PROG_NOTWF ibm66n08.xml

cd $TESTS/ibm/not-wf/P66
$PROG_NOTWF ibm66n09.xml

cd $TESTS/ibm/not-wf/P66
$PROG_NOTWF ibm66n10.xml

cd $TESTS/ibm/not-wf/P66
$PROG_NOTWF ibm66n11.xml

cd $TESTS/ibm/not-wf/P66
$PROG_NOTWF ibm66n12.xml

cd $TESTS/ibm/not-wf/P66
$PROG_NOTWF ibm66n13.xml

cd $TESTS/ibm/not-wf/P66
$PROG_NOTWF ibm66n14.xml

cd $TESTS/ibm/not-wf/P66
$PROG_NOTWF ibm66n15.xml

cd $TESTS/ibm/not-wf/P68
$PROG_NOTWF ibm68n01.xml

cd $TESTS/ibm/not-wf/P68
$PROG_NOTWF ibm68n02.xml

cd $TESTS/ibm/not-wf/P68
$PROG_NOTWF ibm68n03.xml

cd $TESTS/ibm/not-wf/P68
$PROG_NOTWF ibm68n04.xml

cd $TESTS/ibm/not-wf/P68
$PROG_NOTWF ibm68n05.xml

cd $TESTS/ibm/not-wf/P68
$PROG_NOTWF ibm68n06.xml

cd $TESTS/ibm/not-wf/P68
$PROG_NOTWF ibm68n07.xml

cd $TESTS/ibm/not-wf/P68
$PROG_NOTWF ibm68n08.xml

cd $TESTS/ibm/not-wf/P68
$PROG_NOTWF ibm68n09.xml

cd $TESTS/ibm/not-wf/P68
$PROG_NOTWF ibm68n10.xml

cd $TESTS/ibm/not-wf/P69
$PROG_NOTWF ibm69n01.xml

cd $TESTS/ibm/not-wf/P69
$PROG_NOTWF ibm69n02.xml

cd $TESTS/ibm/not-wf/P69
$PROG_NOTWF ibm69n03.xml

cd $TESTS/ibm/not-wf/P69
$PROG_NOTWF ibm69n04.xml

cd $TESTS/ibm/not-wf/P69
$PROG_NOTWF ibm69n05.xml

cd $TESTS/ibm/not-wf/P69
$PROG_NOTWF ibm69n06.xml

cd $TESTS/ibm/not-wf/P69
$PROG_NOTWF ibm69n07.xml

cd $TESTS/ibm/not-wf/P71
$PROG_NOTWF ibm70n01.xml

cd $TESTS/ibm/not-wf/P71
$PROG_NOTWF ibm71n01.xml

cd $TESTS/ibm/not-wf/P71
$PROG_NOTWF ibm71n02.xml

cd $TESTS/ibm/not-wf/P71
$PROG_NOTWF ibm71n03.xml

cd $TESTS/ibm/not-wf/P71
$PROG_NOTWF ibm71n04.xml

cd $TESTS/ibm/not-wf/P71
$PROG_NOTWF ibm71n05.xml

cd $TESTS/ibm/not-wf/P71
$PROG_NOTWF ibm71n06.xml

cd $TESTS/ibm/not-wf/P71
$PROG_NOTWF ibm71n07.xml

cd $TESTS/ibm/not-wf/P71
$PROG_NOTWF ibm71n08.xml

cd $TESTS/ibm/not-wf/P72
$PROG_NOTWF ibm72n01.xml

cd $TESTS/ibm/not-wf/P72
$PROG_NOTWF ibm72n02.xml

cd $TESTS/ibm/not-wf/P72
$PROG_NOTWF ibm72n03.xml

cd $TESTS/ibm/not-wf/P72
$PROG_NOTWF ibm72n04.xml

cd $TESTS/ibm/not-wf/P72
$PROG_NOTWF ibm72n05.xml

cd $TESTS/ibm/not-wf/P72
$PROG_NOTWF ibm72n06.xml

cd $TESTS/ibm/not-wf/P72
$PROG_NOTWF ibm72n07.xml

cd $TESTS/ibm/not-wf/P72
$PROG_NOTWF ibm72n08.xml

cd $TESTS/ibm/not-wf/P72
$PROG_NOTWF ibm72n09.xml

cd $TESTS/ibm/not-wf/P73
$PROG_NOTWF ibm73n01.xml

cd $TESTS/ibm/not-wf/P73
$PROG_NOTWF ibm73n03.xml

cd $TESTS/ibm/not-wf/P74
$PROG_NOTWF ibm74n01.xml

cd $TESTS/ibm/not-wf/P75
$PROG_NOTWF ibm75n01.xml

cd $TESTS/ibm/not-wf/P75
$PROG_NOTWF ibm75n02.xml

cd $TESTS/ibm/not-wf/P75
$PROG_NOTWF ibm75n03.xml

cd $TESTS/ibm/not-wf/P75
$PROG_NOTWF ibm75n04.xml

cd $TESTS/ibm/not-wf/P75
$PROG_NOTWF ibm75n05.xml

cd $TESTS/ibm/not-wf/P75
$PROG_NOTWF ibm75n06.xml

cd $TESTS/ibm/not-wf/P75
$PROG_NOTWF ibm75n07.xml

cd $TESTS/ibm/not-wf/P75
$PROG_NOTWF ibm75n08.xml

cd $TESTS/ibm/not-wf/P75
$PROG_NOTWF ibm75n09.xml

cd $TESTS/ibm/not-wf/P75
$PROG_NOTWF ibm75n10.xml

cd $TESTS/ibm/not-wf/P75
$PROG_NOTWF ibm75n11.xml

cd $TESTS/ibm/not-wf/P75
$PROG_NOTWF ibm75n12.xml

cd $TESTS/ibm/not-wf/P75
$PROG_NOTWF ibm75n13.xml

cd $TESTS/ibm/not-wf/P76
$PROG_NOTWF ibm76n01.xml

cd $TESTS/ibm/not-wf/P76
$PROG_NOTWF ibm76n02.xml

cd $TESTS/ibm/not-wf/P76
$PROG_NOTWF ibm76n03.xml

cd $TESTS/ibm/not-wf/P76
$PROG_NOTWF ibm76n04.xml

cd $TESTS/ibm/not-wf/P76
$PROG_NOTWF ibm76n05.xml

cd $TESTS/ibm/not-wf/P76
$PROG_NOTWF ibm76n06.xml

cd $TESTS/ibm/not-wf/P76
$PROG_NOTWF ibm76n07.xml

cd $TESTS/ibm/not-wf/P77
$PROG_NOTWF ibm77n01.xml

cd $TESTS/ibm/not-wf/P77
$PROG_NOTWF ibm77n02.xml

cd $TESTS/ibm/not-wf/P77
$PROG_NOTWF ibm77n03.xml

cd $TESTS/ibm/not-wf/P77
$PROG_NOTWF ibm77n04.xml

cd $TESTS/ibm/not-wf/P78
$PROG_NOTWF ibm78n01.xml

cd $TESTS/ibm/not-wf/P78
$PROG_NOTWF ibm78n02.xml

cd $TESTS/ibm/not-wf/P79
$PROG_NOTWF ibm79n01.xml

cd $TESTS/ibm/not-wf/P79
$PROG_NOTWF ibm79n02.xml

cd $TESTS/ibm/not-wf/P80
$PROG_NOTWF ibm80n01.xml

cd $TESTS/ibm/not-wf/P80
$PROG_NOTWF ibm80n02.xml

cd $TESTS/ibm/not-wf/P80
$PROG_NOTWF ibm80n03.xml

cd $TESTS/ibm/not-wf/P80
$PROG_NOTWF ibm80n04.xml

cd $TESTS/ibm/not-wf/P80
$PROG_NOTWF ibm80n05.xml

cd $TESTS/ibm/not-wf/P80
$PROG_NOTWF ibm80n06.xml

cd $TESTS/ibm/not-wf/P81
$PROG_NOTWF ibm81n01.xml

cd $TESTS/ibm/not-wf/P81
$PROG_NOTWF ibm81n02.xml

cd $TESTS/ibm/not-wf/P81
$PROG_NOTWF ibm81n03.xml

cd $TESTS/ibm/not-wf/P81
$PROG_NOTWF ibm81n04.xml

cd $TESTS/ibm/not-wf/P81
$PROG_NOTWF ibm81n05.xml

cd $TESTS/ibm/not-wf/P81
$PROG_NOTWF ibm81n06.xml

cd $TESTS/ibm/not-wf/P81
$PROG_NOTWF ibm81n07.xml

cd $TESTS/ibm/not-wf/P81
$PROG_NOTWF ibm81n08.xml

cd $TESTS/ibm/not-wf/P81
$PROG_NOTWF ibm81n09.xml

cd $TESTS/ibm/not-wf/P82
$PROG_NOTWF ibm82n01.xml

cd $TESTS/ibm/not-wf/P82
$PROG_NOTWF ibm82n02.xml

cd $TESTS/ibm/not-wf/P82
$PROG_NOTWF ibm82n03.xml

cd $TESTS/ibm/not-wf/P82
$PROG_NOTWF ibm82n04.xml

cd $TESTS/ibm/not-wf/P82
$PROG_NOTWF ibm82n05.xml

cd $TESTS/ibm/not-wf/P82
$PROG_NOTWF ibm82n06.xml

cd $TESTS/ibm/not-wf/P82
$PROG_NOTWF ibm82n07.xml

cd $TESTS/ibm/not-wf/P82
$PROG_NOTWF ibm82n08.xml

cd $TESTS/ibm/not-wf/P83
$PROG_NOTWF ibm83n01.xml

cd $TESTS/ibm/not-wf/P83
$PROG_NOTWF ibm83n02.xml

cd $TESTS/ibm/not-wf/P83
$PROG_NOTWF ibm83n03.xml

cd $TESTS/ibm/not-wf/P83
$PROG_NOTWF ibm83n04.xml

cd $TESTS/ibm/not-wf/P83
$PROG_NOTWF ibm83n05.xml

cd $TESTS/ibm/not-wf/P83
$PROG_NOTWF ibm83n06.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n01.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n02.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n03.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n04.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n05.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n06.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n07.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n08.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n09.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n10.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n100.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n101.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n102.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n103.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n104.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n105.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n106.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n107.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n108.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n109.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n11.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n110.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n111.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n112.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n113.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n114.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n115.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n116.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n117.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n118.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n119.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n12.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n120.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n121.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n122.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n123.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n124.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n125.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n126.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n127.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n128.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n129.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n13.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n130.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n131.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n132.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n133.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n134.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n135.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n136.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n137.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n138.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n139.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n14.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n140.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n141.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n142.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n143.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n144.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n145.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n146.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n147.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n148.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n149.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n15.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n150.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n151.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n152.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n153.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n154.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n155.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n156.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n157.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n158.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n159.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n16.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n160.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n161.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n162.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n163.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n164.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n165.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n166.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n167.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n168.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n169.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n17.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n170.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n171.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n172.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n173.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n174.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n175.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n176.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n177.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n178.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n179.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n18.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n180.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n181.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n182.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n183.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n184.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n185.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n186.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n187.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n188.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n189.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n19.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n190.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n191.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n192.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n193.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n194.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n195.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n196.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n197.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n198.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n20.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n21.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n22.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n23.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n24.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n25.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n26.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n27.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n28.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n29.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n30.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n31.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n32.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n33.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n34.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n35.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n36.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n37.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n38.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n39.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n40.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n41.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n42.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n43.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n44.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n45.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n46.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n47.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n48.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n49.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n50.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n51.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n52.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n53.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n54.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n55.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n56.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n57.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n58.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n59.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n60.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n61.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n62.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n63.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n64.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n65.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n66.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n67.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n68.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n69.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n70.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n71.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n72.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n73.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n74.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n75.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n76.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n77.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n78.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n79.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n80.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n81.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n82.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n83.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n84.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n85.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n86.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n87.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n88.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n89.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n90.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n91.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n92.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n93.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n94.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n95.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n96.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n97.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n98.xml

cd $TESTS/ibm/not-wf/P85
$PROG_NOTWF ibm85n99.xml

cd $TESTS/ibm/not-wf/P86
$PROG_NOTWF ibm86n01.xml

cd $TESTS/ibm/not-wf/P86
$PROG_NOTWF ibm86n02.xml

cd $TESTS/ibm/not-wf/P86
$PROG_NOTWF ibm86n03.xml

cd $TESTS/ibm/not-wf/P86
$PROG_NOTWF ibm86n04.xml

cd $TESTS/ibm/not-wf/P87
$PROG_NOTWF ibm87n01.xml

cd $TESTS/ibm/not-wf/P87
$PROG_NOTWF ibm87n02.xml

cd $TESTS/ibm/not-wf/P87
$PROG_NOTWF ibm87n03.xml

cd $TESTS/ibm/not-wf/P87
$PROG_NOTWF ibm87n04.xml

cd $TESTS/ibm/not-wf/P87
$PROG_NOTWF ibm87n05.xml

cd $TESTS/ibm/not-wf/P87
$PROG_NOTWF ibm87n06.xml

cd $TESTS/ibm/not-wf/P87
$PROG_NOTWF ibm87n07.xml

cd $TESTS/ibm/not-wf/P87
$PROG_NOTWF ibm87n08.xml

cd $TESTS/ibm/not-wf/P87
$PROG_NOTWF ibm87n09.xml

cd $TESTS/ibm/not-wf/P87
$PROG_NOTWF ibm87n10.xml

cd $TESTS/ibm/not-wf/P87
$PROG_NOTWF ibm87n11.xml

cd $TESTS/ibm/not-wf/P87
$PROG_NOTWF ibm87n12.xml

cd $TESTS/ibm/not-wf/P87
$PROG_NOTWF ibm87n13.xml

cd $TESTS/ibm/not-wf/P87
$PROG_NOTWF ibm87n14.xml

cd $TESTS/ibm/not-wf/P87
$PROG_NOTWF ibm87n15.xml

cd $TESTS/ibm/not-wf/P87
$PROG_NOTWF ibm87n16.xml

cd $TESTS/ibm/not-wf/P87
$PROG_NOTWF ibm87n17.xml

cd $TESTS/ibm/not-wf/P87
$PROG_NOTWF ibm87n18.xml

cd $TESTS/ibm/not-wf/P87
$PROG_NOTWF ibm87n19.xml

cd $TESTS/ibm/not-wf/P87
$PROG_NOTWF ibm87n20.xml

cd $TESTS/ibm/not-wf/P87
$PROG_NOTWF ibm87n21.xml

cd $TESTS/ibm/not-wf/P87
$PROG_NOTWF ibm87n22.xml

cd $TESTS/ibm/not-wf/P87
$PROG_NOTWF ibm87n23.xml

cd $TESTS/ibm/not-wf/P87
$PROG_NOTWF ibm87n24.xml

cd $TESTS/ibm/not-wf/P87
$PROG_NOTWF ibm87n25.xml

cd $TESTS/ibm/not-wf/P87
$PROG_NOTWF ibm87n26.xml

cd $TESTS/ibm/not-wf/P87
$PROG_NOTWF ibm87n27.xml

cd $TESTS/ibm/not-wf/P87
$PROG_NOTWF ibm87n28.xml

cd $TESTS/ibm/not-wf/P87
$PROG_NOTWF ibm87n29.xml

cd $TESTS/ibm/not-wf/P87
$PROG_NOTWF ibm87n30.xml

cd $TESTS/ibm/not-wf/P87
$PROG_NOTWF ibm87n31.xml

cd $TESTS/ibm/not-wf/P87
$PROG_NOTWF ibm87n32.xml

cd $TESTS/ibm/not-wf/P87
$PROG_NOTWF ibm87n33.xml

cd $TESTS/ibm/not-wf/P87
$PROG_NOTWF ibm87n34.xml

cd $TESTS/ibm/not-wf/P87
$PROG_NOTWF ibm87n35.xml

cd $TESTS/ibm/not-wf/P87
$PROG_NOTWF ibm87n36.xml

cd $TESTS/ibm/not-wf/P87
$PROG_NOTWF ibm87n37.xml

cd $TESTS/ibm/not-wf/P87
$PROG_NOTWF ibm87n38.xml

cd $TESTS/ibm/not-wf/P87
$PROG_NOTWF ibm87n39.xml

cd $TESTS/ibm/not-wf/P87
$PROG_NOTWF ibm87n40.xml

cd $TESTS/ibm/not-wf/P87
$PROG_NOTWF ibm87n41.xml

cd $TESTS/ibm/not-wf/P87
$PROG_NOTWF ibm87n42.xml

cd $TESTS/ibm/not-wf/P87
$PROG_NOTWF ibm87n43.xml

cd $TESTS/ibm/not-wf/P87
$PROG_NOTWF ibm87n44.xml

cd $TESTS/ibm/not-wf/P87
$PROG_NOTWF ibm87n45.xml

cd $TESTS/ibm/not-wf/P87
$PROG_NOTWF ibm87n46.xml

cd $TESTS/ibm/not-wf/P87
$PROG_NOTWF ibm87n47.xml

cd $TESTS/ibm/not-wf/P87
$PROG_NOTWF ibm87n48.xml

cd $TESTS/ibm/not-wf/P87
$PROG_NOTWF ibm87n49.xml

cd $TESTS/ibm/not-wf/P87
$PROG_NOTWF ibm87n50.xml

cd $TESTS/ibm/not-wf/P87
$PROG_NOTWF ibm87n51.xml

cd $TESTS/ibm/not-wf/P87
$PROG_NOTWF ibm87n52.xml

cd $TESTS/ibm/not-wf/P87
$PROG_NOTWF ibm87n53.xml

cd $TESTS/ibm/not-wf/P87
$PROG_NOTWF ibm87n54.xml

cd $TESTS/ibm/not-wf/P87
$PROG_NOTWF ibm87n55.xml

cd $TESTS/ibm/not-wf/P87
$PROG_NOTWF ibm87n56.xml

cd $TESTS/ibm/not-wf/P87
$PROG_NOTWF ibm87n57.xml

cd $TESTS/ibm/not-wf/P87
$PROG_NOTWF ibm87n58.xml

cd $TESTS/ibm/not-wf/P87
$PROG_NOTWF ibm87n59.xml

cd $TESTS/ibm/not-wf/P87
$PROG_NOTWF ibm87n60.xml

cd $TESTS/ibm/not-wf/P87
$PROG_NOTWF ibm87n61.xml

cd $TESTS/ibm/not-wf/P87
$PROG_NOTWF ibm87n62.xml

cd $TESTS/ibm/not-wf/P87
$PROG_NOTWF ibm87n63.xml

cd $TESTS/ibm/not-wf/P87
$PROG_NOTWF ibm87n64.xml

cd $TESTS/ibm/not-wf/P87
$PROG_NOTWF ibm87n66.xml

cd $TESTS/ibm/not-wf/P87
$PROG_NOTWF ibm87n67.xml

cd $TESTS/ibm/not-wf/P87
$PROG_NOTWF ibm87n68.xml

cd $TESTS/ibm/not-wf/P87
$PROG_NOTWF ibm87n69.xml

cd $TESTS/ibm/not-wf/P87
$PROG_NOTWF ibm87n70.xml

cd $TESTS/ibm/not-wf/P87
$PROG_NOTWF ibm87n71.xml

cd $TESTS/ibm/not-wf/P87
$PROG_NOTWF ibm87n72.xml

cd $TESTS/ibm/not-wf/P87
$PROG_NOTWF ibm87n73.xml

cd $TESTS/ibm/not-wf/P87
$PROG_NOTWF ibm87n74.xml

cd $TESTS/ibm/not-wf/P87
$PROG_NOTWF ibm87n75.xml

cd $TESTS/ibm/not-wf/P87
$PROG_NOTWF ibm87n76.xml

cd $TESTS/ibm/not-wf/P87
$PROG_NOTWF ibm87n77.xml

cd $TESTS/ibm/not-wf/P87
$PROG_NOTWF ibm87n78.xml

cd $TESTS/ibm/not-wf/P87
$PROG_NOTWF ibm87n79.xml

cd $TESTS/ibm/not-wf/P87
$PROG_NOTWF ibm87n80.xml

cd $TESTS/ibm/not-wf/P87
$PROG_NOTWF ibm87n81.xml

cd $TESTS/ibm/not-wf/P87
$PROG_NOTWF ibm87n82.xml

cd $TESTS/ibm/not-wf/P87
$PROG_NOTWF ibm87n83.xml

cd $TESTS/ibm/not-wf/P87
$PROG_NOTWF ibm87n84.xml

cd $TESTS/ibm/not-wf/P87
$PROG_NOTWF ibm87n85.xml

cd $TESTS/ibm/not-wf/P88
$PROG_NOTWF ibm88n01.xml

cd $TESTS/ibm/not-wf/P88
$PROG_NOTWF ibm88n02.xml

cd $TESTS/ibm/not-wf/P88
$PROG_NOTWF ibm88n03.xml

cd $TESTS/ibm/not-wf/P88
$PROG_NOTWF ibm88n04.xml

cd $TESTS/ibm/not-wf/P88
$PROG_NOTWF ibm88n05.xml

cd $TESTS/ibm/not-wf/P88
$PROG_NOTWF ibm88n06.xml

cd $TESTS/ibm/not-wf/P88
$PROG_NOTWF ibm88n08.xml

cd $TESTS/ibm/not-wf/P88
$PROG_NOTWF ibm88n09.xml

cd $TESTS/ibm/not-wf/P88
$PROG_NOTWF ibm88n10.xml

cd $TESTS/ibm/not-wf/P88
$PROG_NOTWF ibm88n11.xml

cd $TESTS/ibm/not-wf/P88
$PROG_NOTWF ibm88n12.xml

cd $TESTS/ibm/not-wf/P88
$PROG_NOTWF ibm88n13.xml

cd $TESTS/ibm/not-wf/P88
$PROG_NOTWF ibm88n14.xml

cd $TESTS/ibm/not-wf/P88
$PROG_NOTWF ibm88n15.xml

cd $TESTS/ibm/not-wf/P88
$PROG_NOTWF ibm88n16.xml

cd $TESTS/ibm/not-wf/P89
$PROG_NOTWF ibm89n01.xml

cd $TESTS/ibm/not-wf/P89
$PROG_NOTWF ibm89n02.xml

cd $TESTS/ibm/not-wf/P89
$PROG_NOTWF ibm89n03.xml

cd $TESTS/ibm/not-wf/P89
$PROG_NOTWF ibm89n04.xml

cd $TESTS/ibm/not-wf/P89
$PROG_NOTWF ibm89n05.xml

cd $TESTS/ibm/not-wf/P89
$PROG_NOTWF ibm89n06.xml

cd $TESTS/ibm/not-wf/P89
$PROG_NOTWF ibm89n07.xml

cd $TESTS/ibm/not-wf/P89
$PROG_NOTWF ibm89n08.xml

cd $TESTS/ibm/not-wf/P89
$PROG_NOTWF ibm89n09.xml

cd $TESTS/ibm/not-wf/P89
$PROG_NOTWF ibm89n10.xml

cd $TESTS/ibm/not-wf/P89
$PROG_NOTWF ibm89n11.xml

cd $TESTS/ibm/not-wf/P89
$PROG_NOTWF ibm89n12.xml

cd $TESTS/ibm/not-wf/P01
$PROG_NOTWF ibm01n01.xml

cd $TESTS/ibm/not-wf/P01
$PROG_NOTWF ibm01n02.xml

cd $TESTS/ibm/not-wf/P01
$PROG_NOTWF ibm01n03.xml

cd $TESTS/ibm/not-wf/P02
$PROG_NOTWF ibm02n01.xml

cd $TESTS/ibm/not-wf/P02
$PROG_NOTWF ibm02n02.xml

cd $TESTS/ibm/not-wf/P02
$PROG_NOTWF ibm02n03.xml

cd $TESTS/ibm/not-wf/P02
$PROG_NOTWF ibm02n04.xml

cd $TESTS/ibm/not-wf/P02
$PROG_NOTWF ibm02n05.xml

cd $TESTS/ibm/not-wf/P02
$PROG_NOTWF ibm02n06.xml

cd $TESTS/ibm/not-wf/P02
$PROG_NOTWF ibm02n07.xml

cd $TESTS/ibm/not-wf/P02
$PROG_NOTWF ibm02n08.xml

cd $TESTS/ibm/not-wf/P02
$PROG_NOTWF ibm02n09.xml

cd $TESTS/ibm/not-wf/P02
$PROG_NOTWF ibm02n10.xml

cd $TESTS/ibm/not-wf/P02
$PROG_NOTWF ibm02n11.xml

cd $TESTS/ibm/not-wf/P02
$PROG_NOTWF ibm02n12.xml

cd $TESTS/ibm/not-wf/P02
$PROG_NOTWF ibm02n13.xml

cd $TESTS/ibm/not-wf/P02
$PROG_NOTWF ibm02n14.xml

cd $TESTS/ibm/not-wf/P02
$PROG_NOTWF ibm02n15.xml

cd $TESTS/ibm/not-wf/P02
$PROG_NOTWF ibm02n16.xml

cd $TESTS/ibm/not-wf/P02
$PROG_NOTWF ibm02n17.xml

cd $TESTS/ibm/not-wf/P02
$PROG_NOTWF ibm02n18.xml

cd $TESTS/ibm/not-wf/P02
$PROG_NOTWF ibm02n19.xml

cd $TESTS/ibm/not-wf/P02
$PROG_NOTWF ibm02n20.xml

cd $TESTS/ibm/not-wf/P02
$PROG_NOTWF ibm02n21.xml

cd $TESTS/ibm/not-wf/P02
$PROG_NOTWF ibm02n22.xml

cd $TESTS/ibm/not-wf/P02
$PROG_NOTWF ibm02n23.xml

cd $TESTS/ibm/not-wf/P02
$PROG_NOTWF ibm02n24.xml

cd $TESTS/ibm/not-wf/P02
$PROG_NOTWF ibm02n25.xml

cd $TESTS/ibm/not-wf/P02
$PROG_NOTWF ibm02n26.xml

cd $TESTS/ibm/not-wf/P02
$PROG_NOTWF ibm02n27.xml

cd $TESTS/ibm/not-wf/P02
$PROG_NOTWF ibm02n28.xml

cd $TESTS/ibm/not-wf/P02
$PROG_NOTWF ibm02n29.xml

# Omitted, need unicode
#cd $TESTS/ibm/not-wf/P02
#$PROG_NOTWF ibm02n30.xml
#
#cd $TESTS/ibm/not-wf/P02
#$PROG_NOTWF ibm02n31.xml
#
#cd $TESTS/ibm/not-wf/P02
#$PROG_NOTWF ibm02n32.xml
##
#cd $TESTS/ibm/not-wf/P02
#$PROG_NOTWF ibm02n33.xml
#
cd $TESTS/ibm/not-wf/P03
$PROG_NOTWF ibm03n01.xml

cd $TESTS/ibm/valid/P01
$PROG_VALID ibm01v01.xml out/ibm01v01.xml

# Omitted - needs unicode
#cd $TESTS/ibm/valid/P02
#$PROG_VALID ibm02v01.xml out/ibm02v01.xml
#
cd $TESTS/ibm/valid/P03
$PROG_VALID ibm03v01.xml out/ibm03v01.xml

cd $TESTS/ibm/valid/P09
$PROG_VALID ibm09v01.xml out/ibm09v01.xml

cd $TESTS/ibm/valid/P09
$PROG_VALID ibm09v02.xml out/ibm09v02.xml

cd $TESTS/ibm/valid/P09
$PROG_VALID ibm09v03.xml out/ibm09v03.xml

cd $TESTS/ibm/valid/P09
$PROG_VALID ibm09v04.xml out/ibm09v04.xml

cd $TESTS/ibm/valid/P09
$PROG_VALID ibm09v05.xml out/ibm09v05.xml

cd $TESTS/ibm/valid/P10
$PROG_VALID ibm10v01.xml out/ibm10v01.xml

cd $TESTS/ibm/valid/P10
$PROG_VALID ibm10v02.xml out/ibm10v02.xml

cd $TESTS/ibm/valid/P10
$PROG_VALID ibm10v03.xml out/ibm10v03.xml

cd $TESTS/ibm/valid/P10
$PROG_VALID ibm10v04.xml out/ibm10v04.xml

cd $TESTS/ibm/valid/P10
$PROG_VALID ibm10v05.xml out/ibm10v05.xml

cd $TESTS/ibm/valid/P10
$PROG_VALID ibm10v06.xml out/ibm10v06.xml

cd $TESTS/ibm/valid/P10
$PROG_VALID ibm10v07.xml out/ibm10v07.xml

cd $TESTS/ibm/valid/P10
$PROG_VALID ibm10v08.xml out/ibm10v08.xml

cd $TESTS/ibm/valid/P11
$PROG_VALID ibm11v01.xml out/ibm11v01.xml

cd $TESTS/ibm/valid/P11
$PROG_VALID ibm11v02.xml out/ibm11v02.xml

cd $TESTS/ibm/valid/P11
$PROG_VALID ibm11v03.xml out/ibm11v03.xml

cd $TESTS/ibm/valid/P11
$PROG_VALID ibm11v04.xml out/ibm11v04.xml

cd $TESTS/ibm/valid/P12
$PROG_VALID ibm12v01.xml out/ibm12v01.xml

cd $TESTS/ibm/valid/P12
$PROG_VALID ibm12v02.xml out/ibm12v02.xml

cd $TESTS/ibm/valid/P12
$PROG_VALID ibm12v03.xml out/ibm12v03.xml

cd $TESTS/ibm/valid/P12
$PROG_VALID ibm12v04.xml out/ibm12v04.xml

cd $TESTS/ibm/valid/P13
$PROG_VALID ibm13v01.xml out/ibm13v01.xml

cd $TESTS/ibm/valid/P14
$PROG_VALID ibm14v01.xml out/ibm14v01.xml

cd $TESTS/ibm/valid/P14
$PROG_VALID ibm14v02.xml out/ibm14v02.xml

cd $TESTS/ibm/valid/P14
$PROG_VALID ibm14v03.xml out/ibm14v03.xml

cd $TESTS/ibm/valid/P15
$PROG_VALID ibm15v01.xml out/ibm15v01.xml

cd $TESTS/ibm/valid/P15
$PROG_VALID ibm15v02.xml out/ibm15v02.xml

cd $TESTS/ibm/valid/P15
$PROG_VALID ibm15v03.xml out/ibm15v03.xml

cd $TESTS/ibm/valid/P15
$PROG_VALID ibm15v04.xml out/ibm15v04.xml

cd $TESTS/ibm/valid/P16
$PROG_VALID ibm16v01.xml out/ibm16v01.xml

cd $TESTS/ibm/valid/P16
$PROG_VALID ibm16v02.xml out/ibm16v02.xml

cd $TESTS/ibm/valid/P16
$PROG_VALID ibm16v03.xml out/ibm16v03.xml

cd $TESTS/ibm/valid/P17
$PROG_VALID ibm17v01.xml out/ibm17v01.xml

cd $TESTS/ibm/valid/P18
$PROG_VALID ibm18v01.xml out/ibm18v01.xml

cd $TESTS/ibm/valid/P19
$PROG_VALID ibm19v01.xml out/ibm19v01.xml

cd $TESTS/ibm/valid/P20
$PROG_VALID ibm20v01.xml out/ibm20v01.xml

cd $TESTS/ibm/valid/P20
$PROG_VALID ibm20v02.xml out/ibm20v02.xml

cd $TESTS/ibm/valid/P21
$PROG_VALID ibm21v01.xml out/ibm21v01.xml

cd $TESTS/ibm/valid/P22
$PROG_VALID ibm22v01.xml out/ibm22v01.xml

cd $TESTS/ibm/valid/P22
$PROG_VALID ibm22v02.xml out/ibm22v02.xml

cd $TESTS/ibm/valid/P22
$PROG_VALID ibm22v03.xml out/ibm22v03.xml

cd $TESTS/ibm/valid/P22
$PROG_VALID ibm22v04.xml out/ibm22v04.xml

cd $TESTS/ibm/valid/P22
$PROG_VALID ibm22v05.xml out/ibm22v05.xml

cd $TESTS/ibm/valid/P22
$PROG_VALID ibm22v06.xml out/ibm22v06.xml

cd $TESTS/ibm/valid/P22
$PROG_VALID ibm22v07.xml out/ibm22v07.xml

cd $TESTS/ibm/valid/P23
$PROG_VALID ibm23v01.xml out/ibm23v01.xml

cd $TESTS/ibm/valid/P23
$PROG_VALID ibm23v02.xml out/ibm23v02.xml

cd $TESTS/ibm/valid/P23
$PROG_VALID ibm23v03.xml out/ibm23v03.xml

cd $TESTS/ibm/valid/P23
$PROG_VALID ibm23v04.xml out/ibm23v04.xml

cd $TESTS/ibm/valid/P23
$PROG_VALID ibm23v05.xml out/ibm23v05.xml

cd $TESTS/ibm/valid/P23
$PROG_VALID ibm23v06.xml out/ibm23v06.xml

cd $TESTS/ibm/valid/P24
$PROG_VALID ibm24v01.xml out/ibm24v01.xml

cd $TESTS/ibm/valid/P24
$PROG_VALID ibm24v02.xml out/ibm24v02.xml

cd $TESTS/ibm/valid/P25
$PROG_VALID ibm25v01.xml out/ibm25v01.xml

cd $TESTS/ibm/valid/P25
$PROG_VALID ibm25v02.xml out/ibm25v02.xml

cd $TESTS/ibm/valid/P25
$PROG_VALID ibm25v03.xml out/ibm25v03.xml

cd $TESTS/ibm/valid/P25
$PROG_VALID ibm25v04.xml out/ibm25v04.xml

cd $TESTS/ibm/valid/P26
$PROG_VALID ibm26v01.xml out/ibm26v01.xml

cd $TESTS/ibm/valid/P27
$PROG_VALID ibm27v01.xml out/ibm27v01.xml

cd $TESTS/ibm/valid/P27
$PROG_VALID ibm27v02.xml out/ibm27v02.xml

cd $TESTS/ibm/valid/P27
$PROG_VALID ibm27v03.xml out/ibm27v03.xml

cd $TESTS/ibm/valid/P28
$PROG_VALID ibm28v01.xml out/ibm28v01.xml

cd $TESTS/ibm/valid/P28
$PROG_VALID ibm28v02.xml out/ibm28v02.xml

cd $TESTS/ibm/valid/P29
$PROG_VALID ibm29v01.xml out/ibm29v01.xml

cd $TESTS/ibm/valid/P29
$PROG_VALID ibm29v02.xml out/ibm29v02.xml

cd $TESTS/ibm/valid/P30
$PROG_VALID ibm30v01.xml out/ibm30v01.xml

cd $TESTS/ibm/valid/P30
$PROG_VALID ibm30v02.xml out/ibm30v02.xml

cd $TESTS/ibm/valid/P31
$PROG_VALID ibm31v01.xml out/ibm31v01.xml

cd $TESTS/ibm/valid/P32
$PROG_VALID ibm32v01.xml out/ibm32v01.xml

cd $TESTS/ibm/valid/P32
$PROG_VALID ibm32v02.xml out/ibm32v02.xml

cd $TESTS/ibm/valid/P32
$PROG_VALID ibm32v03.xml out/ibm32v03.xml

cd $TESTS/ibm/valid/P32
$PROG_VALID ibm32v04.xml out/ibm32v04.xml

cd $TESTS/ibm/valid/P33
$PROG_VALID ibm33v01.xml out/ibm33v01.xml

cd $TESTS/ibm/valid/P34
$PROG_VALID ibm34v01.xml out/ibm34v01.xml

cd $TESTS/ibm/valid/P35
$PROG_VALID ibm35v01.xml out/ibm35v01.xml

cd $TESTS/ibm/valid/P36
$PROG_VALID ibm36v01.xml out/ibm36v01.xml

cd $TESTS/ibm/valid/P37
$PROG_VALID ibm37v01.xml out/ibm37v01.xml

cd $TESTS/ibm/valid/P38
$PROG_VALID ibm38v01.xml out/ibm38v01.xml

cd $TESTS/ibm/valid/P39
$PROG_VALID ibm39v01.xml out/ibm39v01.xml

cd $TESTS/ibm/valid/P40
$PROG_VALID ibm40v01.xml out/ibm40v01.xml

cd $TESTS/ibm/valid/P41
$PROG_VALID ibm41v01.xml out/ibm41v01.xml

cd $TESTS/ibm/valid/P42
$PROG_VALID ibm42v01.xml out/ibm42v01.xml

cd $TESTS/ibm/valid/P43
$PROG_VALID ibm43v01.xml out/ibm43v01.xml

cd $TESTS/ibm/valid/P44
$PROG_VALID ibm44v01.xml out/ibm44v01.xml

cd $TESTS/ibm/valid/P45
$PROG_VALID ibm45v01.xml out/ibm45v01.xml

cd $TESTS/ibm/valid/P47
$PROG_VALID ibm47v01.xml out/ibm47v01.xml

cd $TESTS/ibm/valid/P49
$PROG_VALID ibm49v01.xml out/ibm49v01.xml

cd $TESTS/ibm/valid/P50
$PROG_VALID ibm50v01.xml out/ibm50v01.xml

cd $TESTS/ibm/valid/P51
$PROG_VALID ibm51v01.xml out/ibm51v01.xml

cd $TESTS/ibm/valid/P51
$PROG_VALID ibm51v02.xml out/ibm51v02.xml

cd $TESTS/ibm/valid/P52
$PROG_VALID ibm52v01.xml out/ibm52v01.xml

cd $TESTS/ibm/valid/P54
$PROG_VALID ibm54v01.xml out/ibm54v01.xml

cd $TESTS/ibm/valid/P54
$PROG_VALID ibm54v02.xml out/ibm54v02.xml

cd $TESTS/ibm/valid/P54
$PROG_VALID ibm54v03.xml out/ibm54v03.xml

cd $TESTS/ibm/valid/P55
$PROG_VALID ibm55v01.xml out/ibm55v01.xml

cd $TESTS/ibm/valid/P56
$PROG_VALID ibm56v01.xml out/ibm56v01.xml

cd $TESTS/ibm/valid/P56
$PROG_VALID ibm56v02.xml out/ibm56v02.xml

cd $TESTS/ibm/valid/P56
$PROG_VALID ibm56v03.xml out/ibm56v03.xml

cd $TESTS/ibm/valid/P56
$PROG_VALID ibm56v04.xml out/ibm56v04.xml

cd $TESTS/ibm/valid/P56
$PROG_VALID ibm56v05.xml out/ibm56v05.xml

cd $TESTS/ibm/valid/P56
$PROG_VALID ibm56v06.xml out/ibm56v06.xml

cd $TESTS/ibm/valid/P56
$PROG_VALID ibm56v07.xml out/ibm56v07.xml

cd $TESTS/ibm/valid/P56
$PROG_VALID ibm56v08.xml out/ibm56v08.xml

cd $TESTS/ibm/valid/P56
$PROG_VALID ibm56v09.xml out/ibm56v09.xml

cd $TESTS/ibm/valid/P56
$PROG_VALID ibm56v10.xml out/ibm56v10.xml

cd $TESTS/ibm/valid/P57
$PROG_VALID ibm57v01.xml out/ibm57v01.xml

cd $TESTS/ibm/valid/P58
$PROG_VALID ibm58v01.xml out/ibm58v01.xml

cd $TESTS/ibm/valid/P58
$PROG_VALID ibm58v02.xml out/ibm58v02.xml

cd $TESTS/ibm/valid/P59
$PROG_VALID ibm59v01.xml out/ibm59v01.xml

cd $TESTS/ibm/valid/P59
$PROG_VALID ibm59v02.xml out/ibm59v02.xml

cd $TESTS/ibm/valid/P60
$PROG_VALID ibm60v01.xml out/ibm60v01.xml

cd $TESTS/ibm/valid/P60
$PROG_VALID ibm60v02.xml out/ibm60v02.xml

cd $TESTS/ibm/valid/P60
$PROG_VALID ibm60v03.xml out/ibm60v03.xml

cd $TESTS/ibm/valid/P60
$PROG_VALID ibm60v04.xml out/ibm60v04.xml

cd $TESTS/ibm/valid/P61
$PROG_VALID ibm61v01.xml out/ibm61v01.xml

cd $TESTS/ibm/valid/P61
$PROG_VALID ibm61v02.xml out/ibm61v02.xml

cd $TESTS/ibm/valid/P62
$PROG_VALID ibm62v01.xml out/ibm62v01.xml

cd $TESTS/ibm/valid/P62
$PROG_VALID ibm62v02.xml out/ibm62v02.xml

cd $TESTS/ibm/valid/P62
$PROG_VALID ibm62v03.xml out/ibm62v03.xml

cd $TESTS/ibm/valid/P62
$PROG_VALID ibm62v04.xml out/ibm62v04.xml

cd $TESTS/ibm/valid/P62
$PROG_VALID ibm62v05.xml out/ibm62v05.xml

cd $TESTS/ibm/valid/P63
$PROG_VALID ibm63v01.xml out/ibm63v01.xml

cd $TESTS/ibm/valid/P63
$PROG_VALID ibm63v02.xml out/ibm63v02.xml

cd $TESTS/ibm/valid/P63
$PROG_VALID ibm63v03.xml out/ibm63v03.xml

cd $TESTS/ibm/valid/P63
$PROG_VALID ibm63v04.xml out/ibm63v04.xml

cd $TESTS/ibm/valid/P63
$PROG_VALID ibm63v05.xml out/ibm63v05.xml

cd $TESTS/ibm/valid/P64
$PROG_VALID ibm64v01.xml out/ibm64v01.xml

cd $TESTS/ibm/valid/P64
$PROG_VALID ibm64v02.xml out/ibm64v02.xml

cd $TESTS/ibm/valid/P64
$PROG_VALID ibm64v03.xml out/ibm64v03.xml

cd $TESTS/ibm/valid/P65
$PROG_VALID ibm65v01.xml out/ibm65v01.xml

cd $TESTS/ibm/valid/P65
$PROG_VALID ibm65v02.xml out/ibm65v02.xml

# Omitted - needs unicode
#cd $TESTS/ibm/valid/P66
#$PROG_VALID ibm66v01.xml out/ibm66v01.xml
#
cd $TESTS/ibm/valid/P67
$PROG_VALID ibm67v01.xml out/ibm67v01.xml

cd $TESTS/ibm/valid/P68
$PROG_VALID ibm68v01.xml out/ibm68v01.xml

cd $TESTS/ibm/valid/P68
$PROG_VALID ibm68v02.xml out/ibm68v02.xml

cd $TESTS/ibm/valid/P69
$PROG_VALID ibm69v01.xml out/ibm69v01.xml

cd $TESTS/ibm/valid/P69
$PROG_VALID ibm69v02.xml out/ibm69v02.xml

cd $TESTS/ibm/valid/P70
$PROG_VALID ibm70v01.xml out/ibm70v01.xml

cd $TESTS/ibm/valid/P78
$PROG_VALID ibm78v01.xml out/ibm78v01.xml

cd $TESTS/ibm/valid/P79
$PROG_VALID ibm79v01.xml out/ibm79v01.xml

cd $TESTS/ibm/valid/P82
$PROG_VALID ibm82v01.xml out/ibm82v01.xml

# Omitted as they require unicode.
#cd $TESTS/ibm/valid/P85
#$PROG_VALID ibm85v01.xml out/ibm85v01.xml
#
#cd $TESTS/ibm/valid/P86
#$PROG_VALID ibm86v01.xml out/ibm86v01.xml
#
#cd $TESTS/ibm/valid/P87
#$PROG_VALID ibm87v01.xml out/ibm87v01.xml
#
#cd $TESTS/ibm/valid/P88
#$PROG_VALID ibm88v01.xml out/ibm88v01.xml
#
#cd $TESTS/ibm/valid/P89
#$PROG_VALID ibm89v01.xml out/ibm89v01.xml
#
