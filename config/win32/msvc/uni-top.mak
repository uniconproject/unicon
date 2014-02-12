all :
	cd iyacc
	nmake
	cd ..\unicon
	nmake
	cd ..\lib
	nmake
	cd ..\gui 
	nmake
	cd ..\gui\ivib 
	nmake
	cd ..\..\xml 
	nmake
	cd ..\parser 
	nmake
	cd ..\util 
	nmake
	cd ..\unidoc 
	nmake
	cd ..\ide 
	nmake

clean:
	cd iyacc
	nmake Clean 
	cd ..\unicon
	nmake Clean 
	cd ..\ivib
	nmake Clean
	cd ..\lib
	nmake Clean 
	cd ..\gui
	nmake clean 
	cd ..\gui\ivib
	nmake clean 
	cd ..\..\xml
	nmake clean 
	cd ..\parser
	nmake clean 
	cd ..\unidep
	nmake clean 
	cd ..\util
	nmake clean 
	cd ..\unidoc
	nmake clean 
	cd ..\ide
	nmake clean 
