# Microsoft Developer Studio Generated NMAKE File, Based on gdbm.dsp
!IF "$(CFG)" == ""
CFG=gdbm - Win32 Debug
!MESSAGE No configuration specified. Defaulting to gdbm - Win32 Debug.
!ENDIF 

!IF "$(CFG)" != "gdbm - Win32 Release" && "$(CFG)" != "gdbm - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "gdbm.mak" CFG="gdbm - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "gdbm - Win32 Release" (based on "Win32 (x86) Static Library")
!MESSAGE "gdbm - Win32 Debug" (based on "Win32 (x86) Static Library")
!MESSAGE 
!ERROR An invalid configuration is specified.
!ENDIF 

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE 
NULL=nul
!ENDIF 

CPP=cl.exe

!IF  "$(CFG)" == "gdbm - Win32 Release"

OUTDIR=.\Release
INTDIR=.\Release

!IF "$(RECURSE)" == "0" 

ALL : "..\lib\gdbm.lib"

!ELSE 

ALL : "..\lib\gdbm.lib"

!ENDIF 

CLEAN :
	-@erase "$(INTDIR)\alloca.obj"
	-@erase "$(INTDIR)\bucket.obj"
	-@erase "$(INTDIR)\close.obj"
	-@erase "$(INTDIR)\dbmclose.obj"
	-@erase "$(INTDIR)\dbmdelete.obj"
	-@erase "$(INTDIR)\dbmdirfno.obj"
	-@erase "$(INTDIR)\dbmfetch.obj"
	-@erase "$(INTDIR)\dbminit.obj"
	-@erase "$(INTDIR)\dbmopen.obj"
	-@erase "$(INTDIR)\dbmpagfno.obj"
	-@erase "$(INTDIR)\dbmrdonly.obj"
	-@erase "$(INTDIR)\dbmseq.obj"
	-@erase "$(INTDIR)\dbmstore.obj"
	-@erase "$(INTDIR)\delete.obj"
	-@erase "$(INTDIR)\falloc.obj"
	-@erase "$(INTDIR)\fetch.obj"
	-@erase "$(INTDIR)\findkey.obj"
	-@erase "$(INTDIR)\gdbmclose.obj"
	-@erase "$(INTDIR)\gdbmdelete.obj"
	-@erase "$(INTDIR)\gdbmerrno.obj"
	-@erase "$(INTDIR)\gdbmexists.obj"
	-@erase "$(INTDIR)\gdbmfetch.obj"
	-@erase "$(INTDIR)\gdbmopen.obj"
	-@erase "$(INTDIR)\gdbmreorg.obj"
	-@erase "$(INTDIR)\gdbmseq.obj"
	-@erase "$(INTDIR)\gdbmsetopt.obj"
	-@erase "$(INTDIR)\gdbmstore.obj"
	-@erase "$(INTDIR)\gdbmsync.obj"
	-@erase "$(INTDIR)\getopt.obj"
	-@erase "$(INTDIR)\global.obj"
	-@erase "$(INTDIR)\hash.obj"
	-@erase "$(INTDIR)\seq.obj"
	-@erase "$(INTDIR)\store.obj"
	-@erase "$(INTDIR)\update.obj"
	-@erase "$(INTDIR)\vc50.idb"
	-@erase "$(INTDIR)\version.obj"
	-@erase "..\lib\gdbm.lib"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP_PROJ=/nologo /G4 /ML /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_WINDOWS"\
 /Fp"$(INTDIR)\gdbm.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 
CPP_OBJS=.\Release/
CPP_SBRS=.
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\gdbm.bsc" 
BSC32_SBRS= \
	
LIB32=link.exe -lib
LIB32_FLAGS=/nologo /out:"s:\lib\gdbm.lib" 
LIB32_OBJS= \
	"$(INTDIR)\alloca.obj" \
	"$(INTDIR)\bucket.obj" \
	"$(INTDIR)\close.obj" \
	"$(INTDIR)\dbmclose.obj" \
	"$(INTDIR)\dbmdelete.obj" \
	"$(INTDIR)\dbmdirfno.obj" \
	"$(INTDIR)\dbmfetch.obj" \
	"$(INTDIR)\dbminit.obj" \
	"$(INTDIR)\dbmopen.obj" \
	"$(INTDIR)\dbmpagfno.obj" \
	"$(INTDIR)\dbmrdonly.obj" \
	"$(INTDIR)\dbmseq.obj" \
	"$(INTDIR)\dbmstore.obj" \
	"$(INTDIR)\delete.obj" \
	"$(INTDIR)\falloc.obj" \
	"$(INTDIR)\fetch.obj" \
	"$(INTDIR)\findkey.obj" \
	"$(INTDIR)\gdbmclose.obj" \
	"$(INTDIR)\gdbmdelete.obj" \
	"$(INTDIR)\gdbmerrno.obj" \
	"$(INTDIR)\gdbmexists.obj" \
	"$(INTDIR)\gdbmfetch.obj" \
	"$(INTDIR)\gdbmopen.obj" \
	"$(INTDIR)\gdbmreorg.obj" \
	"$(INTDIR)\gdbmseq.obj" \
	"$(INTDIR)\gdbmsetopt.obj" \
	"$(INTDIR)\gdbmstore.obj" \
	"$(INTDIR)\gdbmsync.obj" \
	"$(INTDIR)\getopt.obj" \
	"$(INTDIR)\global.obj" \
	"$(INTDIR)\hash.obj" \
	"$(INTDIR)\seq.obj" \
	"$(INTDIR)\store.obj" \
	"$(INTDIR)\update.obj" \
	"$(INTDIR)\version.obj"

"..\lib\gdbm.lib" : "$(OUTDIR)" $(DEF_FILE) $(LIB32_OBJS)
    $(LIB32) @<<
  $(LIB32_FLAGS) $(DEF_FLAGS) $(LIB32_OBJS)
<<

!ELSEIF  "$(CFG)" == "gdbm - Win32 Debug"

OUTDIR=.\Debug
INTDIR=.\Debug

!IF "$(RECURSE)" == "0" 

ALL : "..\lib\debug\gdbm.lib" ".\gdbm.bsc"

!ELSE 

ALL : "..\lib\debug\gdbm.lib" ".\gdbm.bsc"

!ENDIF 

CLEAN :
	-@erase "$(INTDIR)\alloca.obj"
	-@erase "$(INTDIR)\alloca.sbr"
	-@erase "$(INTDIR)\bucket.obj"
	-@erase "$(INTDIR)\bucket.sbr"
	-@erase "$(INTDIR)\close.obj"
	-@erase "$(INTDIR)\close.sbr"
	-@erase "$(INTDIR)\dbmclose.obj"
	-@erase "$(INTDIR)\dbmclose.sbr"
	-@erase "$(INTDIR)\dbmdelete.obj"
	-@erase "$(INTDIR)\dbmdelete.sbr"
	-@erase "$(INTDIR)\dbmdirfno.obj"
	-@erase "$(INTDIR)\dbmdirfno.sbr"
	-@erase "$(INTDIR)\dbmfetch.obj"
	-@erase "$(INTDIR)\dbmfetch.sbr"
	-@erase "$(INTDIR)\dbminit.obj"
	-@erase "$(INTDIR)\dbminit.sbr"
	-@erase "$(INTDIR)\dbmopen.obj"
	-@erase "$(INTDIR)\dbmopen.sbr"
	-@erase "$(INTDIR)\dbmpagfno.obj"
	-@erase "$(INTDIR)\dbmpagfno.sbr"
	-@erase "$(INTDIR)\dbmrdonly.obj"
	-@erase "$(INTDIR)\dbmrdonly.sbr"
	-@erase "$(INTDIR)\dbmseq.obj"
	-@erase "$(INTDIR)\dbmseq.sbr"
	-@erase "$(INTDIR)\dbmstore.obj"
	-@erase "$(INTDIR)\dbmstore.sbr"
	-@erase "$(INTDIR)\delete.obj"
	-@erase "$(INTDIR)\delete.sbr"
	-@erase "$(INTDIR)\falloc.obj"
	-@erase "$(INTDIR)\falloc.sbr"
	-@erase "$(INTDIR)\fetch.obj"
	-@erase "$(INTDIR)\fetch.sbr"
	-@erase "$(INTDIR)\findkey.obj"
	-@erase "$(INTDIR)\findkey.sbr"
	-@erase "$(INTDIR)\gdbmclose.obj"
	-@erase "$(INTDIR)\gdbmclose.sbr"
	-@erase "$(INTDIR)\gdbmdelete.obj"
	-@erase "$(INTDIR)\gdbmdelete.sbr"
	-@erase "$(INTDIR)\gdbmerrno.obj"
	-@erase "$(INTDIR)\gdbmerrno.sbr"
	-@erase "$(INTDIR)\gdbmexists.obj"
	-@erase "$(INTDIR)\gdbmexists.sbr"
	-@erase "$(INTDIR)\gdbmfetch.obj"
	-@erase "$(INTDIR)\gdbmfetch.sbr"
	-@erase "$(INTDIR)\gdbmopen.obj"
	-@erase "$(INTDIR)\gdbmopen.sbr"
	-@erase "$(INTDIR)\gdbmreorg.obj"
	-@erase "$(INTDIR)\gdbmreorg.sbr"
	-@erase "$(INTDIR)\gdbmseq.obj"
	-@erase "$(INTDIR)\gdbmseq.sbr"
	-@erase "$(INTDIR)\gdbmsetopt.obj"
	-@erase "$(INTDIR)\gdbmsetopt.sbr"
	-@erase "$(INTDIR)\gdbmstore.obj"
	-@erase "$(INTDIR)\gdbmstore.sbr"
	-@erase "$(INTDIR)\gdbmsync.obj"
	-@erase "$(INTDIR)\gdbmsync.sbr"
	-@erase "$(INTDIR)\getopt.obj"
	-@erase "$(INTDIR)\getopt.sbr"
	-@erase "$(INTDIR)\global.obj"
	-@erase "$(INTDIR)\global.sbr"
	-@erase "$(INTDIR)\hash.obj"
	-@erase "$(INTDIR)\hash.sbr"
	-@erase "$(INTDIR)\seq.obj"
	-@erase "$(INTDIR)\seq.sbr"
	-@erase "$(INTDIR)\store.obj"
	-@erase "$(INTDIR)\store.sbr"
	-@erase "$(INTDIR)\update.obj"
	-@erase "$(INTDIR)\update.sbr"
	-@erase "$(INTDIR)\vc50.idb"
	-@erase "$(INTDIR)\version.obj"
	-@erase "$(INTDIR)\version.sbr"
	-@erase "..\lib\debug\gdbm.lib"
	-@erase ".\gdbm.bsc"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP_PROJ=/nologo /G4 /ML /W3 /GX /Z7 /Od /I "s:\gdbm" /D "WIN32" /D "_DEBUG" /D\
 "_WINDOWS" /FR"$(INTDIR)\\" /Fp"$(INTDIR)\gdbm.pch" /YX /Fo"$(INTDIR)\\"\
 /Fd"$(INTDIR)\\" /FD /c 
CPP_OBJS=.\Debug/
CPP_SBRS=.\Debug/
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"gdbm.bsc" 
BSC32_SBRS= \
	"$(INTDIR)\alloca.sbr" \
	"$(INTDIR)\bucket.sbr" \
	"$(INTDIR)\close.sbr" \
	"$(INTDIR)\dbmclose.sbr" \
	"$(INTDIR)\dbmdelete.sbr" \
	"$(INTDIR)\dbmdirfno.sbr" \
	"$(INTDIR)\dbmfetch.sbr" \
	"$(INTDIR)\dbminit.sbr" \
	"$(INTDIR)\dbmopen.sbr" \
	"$(INTDIR)\dbmpagfno.sbr" \
	"$(INTDIR)\dbmrdonly.sbr" \
	"$(INTDIR)\dbmseq.sbr" \
	"$(INTDIR)\dbmstore.sbr" \
	"$(INTDIR)\delete.sbr" \
	"$(INTDIR)\falloc.sbr" \
	"$(INTDIR)\fetch.sbr" \
	"$(INTDIR)\findkey.sbr" \
	"$(INTDIR)\gdbmclose.sbr" \
	"$(INTDIR)\gdbmdelete.sbr" \
	"$(INTDIR)\gdbmerrno.sbr" \
	"$(INTDIR)\gdbmexists.sbr" \
	"$(INTDIR)\gdbmfetch.sbr" \
	"$(INTDIR)\gdbmopen.sbr" \
	"$(INTDIR)\gdbmreorg.sbr" \
	"$(INTDIR)\gdbmseq.sbr" \
	"$(INTDIR)\gdbmsetopt.sbr" \
	"$(INTDIR)\gdbmstore.sbr" \
	"$(INTDIR)\gdbmsync.sbr" \
	"$(INTDIR)\getopt.sbr" \
	"$(INTDIR)\global.sbr" \
	"$(INTDIR)\hash.sbr" \
	"$(INTDIR)\seq.sbr" \
	"$(INTDIR)\store.sbr" \
	"$(INTDIR)\update.sbr" \
	"$(INTDIR)\version.sbr"

".\gdbm.bsc" : "$(OUTDIR)" $(BSC32_SBRS)
    $(BSC32) @<<
  $(BSC32_FLAGS) $(BSC32_SBRS)
<<

LIB32=link.exe -lib
LIB32_FLAGS=/nologo /out:"s:\lib\debug\gdbm.lib" 
LIB32_OBJS= \
	"$(INTDIR)\alloca.obj" \
	"$(INTDIR)\bucket.obj" \
	"$(INTDIR)\close.obj" \
	"$(INTDIR)\dbmclose.obj" \
	"$(INTDIR)\dbmdelete.obj" \
	"$(INTDIR)\dbmdirfno.obj" \
	"$(INTDIR)\dbmfetch.obj" \
	"$(INTDIR)\dbminit.obj" \
	"$(INTDIR)\dbmopen.obj" \
	"$(INTDIR)\dbmpagfno.obj" \
	"$(INTDIR)\dbmrdonly.obj" \
	"$(INTDIR)\dbmseq.obj" \
	"$(INTDIR)\dbmstore.obj" \
	"$(INTDIR)\delete.obj" \
	"$(INTDIR)\falloc.obj" \
	"$(INTDIR)\fetch.obj" \
	"$(INTDIR)\findkey.obj" \
	"$(INTDIR)\gdbmclose.obj" \
	"$(INTDIR)\gdbmdelete.obj" \
	"$(INTDIR)\gdbmerrno.obj" \
	"$(INTDIR)\gdbmexists.obj" \
	"$(INTDIR)\gdbmfetch.obj" \
	"$(INTDIR)\gdbmopen.obj" \
	"$(INTDIR)\gdbmreorg.obj" \
	"$(INTDIR)\gdbmseq.obj" \
	"$(INTDIR)\gdbmsetopt.obj" \
	"$(INTDIR)\gdbmstore.obj" \
	"$(INTDIR)\gdbmsync.obj" \
	"$(INTDIR)\getopt.obj" \
	"$(INTDIR)\global.obj" \
	"$(INTDIR)\hash.obj" \
	"$(INTDIR)\seq.obj" \
	"$(INTDIR)\store.obj" \
	"$(INTDIR)\update.obj" \
	"$(INTDIR)\version.obj"

"..\lib\debug\gdbm.lib" : "$(OUTDIR)" $(DEF_FILE) $(LIB32_OBJS)
    $(LIB32) @<<
  $(LIB32_FLAGS) $(DEF_FLAGS) $(LIB32_OBJS)
<<

!ENDIF 

.c{$(CPP_OBJS)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cpp{$(CPP_OBJS)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cxx{$(CPP_OBJS)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.c{$(CPP_SBRS)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cpp{$(CPP_SBRS)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cxx{$(CPP_SBRS)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<


!IF "$(CFG)" == "gdbm - Win32 Release" || "$(CFG)" == "gdbm - Win32 Debug"
SOURCE=.\alloca.c
DEP_CPP_ALLOC=\
	".\autoconf.h"\
	

!IF  "$(CFG)" == "gdbm - Win32 Release"


"$(INTDIR)\alloca.obj" : $(SOURCE) $(DEP_CPP_ALLOC) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "gdbm - Win32 Debug"


"$(INTDIR)\alloca.obj"	"$(INTDIR)\alloca.sbr" : $(SOURCE) $(DEP_CPP_ALLOC)\
 "$(INTDIR)"


!ENDIF 

SOURCE=.\bucket.c
DEP_CPP_BUCKE=\
	".\autoconf.h"\
	".\gdbmconst.h"\
	".\gdbmdefs.h"\
	".\proto.h"\
	".\systems.h"\
	

!IF  "$(CFG)" == "gdbm - Win32 Release"


"$(INTDIR)\bucket.obj" : $(SOURCE) $(DEP_CPP_BUCKE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "gdbm - Win32 Debug"


"$(INTDIR)\bucket.obj"	"$(INTDIR)\bucket.sbr" : $(SOURCE) $(DEP_CPP_BUCKE)\
 "$(INTDIR)"


!ENDIF 

SOURCE=.\close.c
DEP_CPP_CLOSE=\
	".\autoconf.h"\
	".\extern.h"\
	".\gdbmconst.h"\
	".\gdbmdefs.h"\
	".\proto.h"\
	".\systems.h"\
	

!IF  "$(CFG)" == "gdbm - Win32 Release"


"$(INTDIR)\close.obj" : $(SOURCE) $(DEP_CPP_CLOSE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "gdbm - Win32 Debug"


"$(INTDIR)\close.obj"	"$(INTDIR)\close.sbr" : $(SOURCE) $(DEP_CPP_CLOSE)\
 "$(INTDIR)"


!ENDIF 

SOURCE=.\dbmclose.c
DEP_CPP_DBMCL=\
	".\autoconf.h"\
	".\gdbmconst.h"\
	".\gdbmdefs.h"\
	".\proto.h"\
	".\systems.h"\
	

!IF  "$(CFG)" == "gdbm - Win32 Release"


"$(INTDIR)\dbmclose.obj" : $(SOURCE) $(DEP_CPP_DBMCL) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "gdbm - Win32 Debug"


"$(INTDIR)\dbmclose.obj"	"$(INTDIR)\dbmclose.sbr" : $(SOURCE) $(DEP_CPP_DBMCL)\
 "$(INTDIR)"


!ENDIF 

SOURCE=.\dbmdelete.c
DEP_CPP_DBMDE=\
	".\autoconf.h"\
	".\extern.h"\
	".\gdbmconst.h"\
	".\gdbmdefs.h"\
	".\proto.h"\
	".\systems.h"\
	

!IF  "$(CFG)" == "gdbm - Win32 Release"


"$(INTDIR)\dbmdelete.obj" : $(SOURCE) $(DEP_CPP_DBMDE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "gdbm - Win32 Debug"


"$(INTDIR)\dbmdelete.obj"	"$(INTDIR)\dbmdelete.sbr" : $(SOURCE)\
 $(DEP_CPP_DBMDE) "$(INTDIR)"


!ENDIF 

SOURCE=.\dbmdirfno.c
DEP_CPP_DBMDI=\
	".\autoconf.h"\
	".\gdbmconst.h"\
	".\gdbmdefs.h"\
	".\proto.h"\
	".\systems.h"\
	

!IF  "$(CFG)" == "gdbm - Win32 Release"


"$(INTDIR)\dbmdirfno.obj" : $(SOURCE) $(DEP_CPP_DBMDI) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "gdbm - Win32 Debug"


"$(INTDIR)\dbmdirfno.obj"	"$(INTDIR)\dbmdirfno.sbr" : $(SOURCE)\
 $(DEP_CPP_DBMDI) "$(INTDIR)"


!ENDIF 

SOURCE=.\dbmfetch.c
DEP_CPP_DBMFE=\
	".\autoconf.h"\
	".\extern.h"\
	".\gdbmconst.h"\
	".\gdbmdefs.h"\
	".\proto.h"\
	".\systems.h"\
	

!IF  "$(CFG)" == "gdbm - Win32 Release"


"$(INTDIR)\dbmfetch.obj" : $(SOURCE) $(DEP_CPP_DBMFE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "gdbm - Win32 Debug"


"$(INTDIR)\dbmfetch.obj"	"$(INTDIR)\dbmfetch.sbr" : $(SOURCE) $(DEP_CPP_DBMFE)\
 "$(INTDIR)"


!ENDIF 

SOURCE=.\dbminit.c

!IF  "$(CFG)" == "gdbm - Win32 Release"

DEP_CPP_DBMIN=\
	".\autoconf.h"\
	".\extern.h"\
	".\gdbmconst.h"\
	".\gdbmdefs.h"\
	".\gdbmerrno.h"\
	".\proto.h"\
	".\systems.h"\
	

"$(INTDIR)\dbminit.obj" : $(SOURCE) $(DEP_CPP_DBMIN) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "gdbm - Win32 Debug"

DEP_CPP_DBMIN=\
	".\autoconf.h"\
	".\extern.h"\
	".\gdbmconst.h"\
	".\gdbmdefs.h"\
	".\gdbmerrno.h"\
	".\proto.h"\
	".\systems.h"\
	

"$(INTDIR)\dbminit.obj"	"$(INTDIR)\dbminit.sbr" : $(SOURCE) $(DEP_CPP_DBMIN)\
 "$(INTDIR)"


!ENDIF 

SOURCE=.\dbmopen.c

!IF  "$(CFG)" == "gdbm - Win32 Release"

DEP_CPP_DBMOP=\
	".\autoconf.h"\
	".\extern.h"\
	".\gdbmconst.h"\
	".\gdbmdefs.h"\
	".\gdbmerrno.h"\
	".\proto.h"\
	".\systems.h"\
	

"$(INTDIR)\dbmopen.obj" : $(SOURCE) $(DEP_CPP_DBMOP) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "gdbm - Win32 Debug"

DEP_CPP_DBMOP=\
	".\autoconf.h"\
	".\extern.h"\
	".\gdbmconst.h"\
	".\gdbmdefs.h"\
	".\gdbmerrno.h"\
	".\proto.h"\
	".\systems.h"\
	

"$(INTDIR)\dbmopen.obj"	"$(INTDIR)\dbmopen.sbr" : $(SOURCE) $(DEP_CPP_DBMOP)\
 "$(INTDIR)"


!ENDIF 

SOURCE=.\dbmpagfno.c
DEP_CPP_DBMPA=\
	".\autoconf.h"\
	".\gdbmconst.h"\
	".\gdbmdefs.h"\
	".\proto.h"\
	".\systems.h"\
	

!IF  "$(CFG)" == "gdbm - Win32 Release"


"$(INTDIR)\dbmpagfno.obj" : $(SOURCE) $(DEP_CPP_DBMPA) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "gdbm - Win32 Debug"


"$(INTDIR)\dbmpagfno.obj"	"$(INTDIR)\dbmpagfno.sbr" : $(SOURCE)\
 $(DEP_CPP_DBMPA) "$(INTDIR)"


!ENDIF 

SOURCE=.\dbmrdonly.c
DEP_CPP_DBMRD=\
	".\autoconf.h"\
	".\gdbmconst.h"\
	".\gdbmdefs.h"\
	".\proto.h"\
	".\systems.h"\
	

!IF  "$(CFG)" == "gdbm - Win32 Release"


"$(INTDIR)\dbmrdonly.obj" : $(SOURCE) $(DEP_CPP_DBMRD) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "gdbm - Win32 Debug"


"$(INTDIR)\dbmrdonly.obj"	"$(INTDIR)\dbmrdonly.sbr" : $(SOURCE)\
 $(DEP_CPP_DBMRD) "$(INTDIR)"


!ENDIF 

SOURCE=.\dbmseq.c
DEP_CPP_DBMSE=\
	".\autoconf.h"\
	".\extern.h"\
	".\gdbmconst.h"\
	".\gdbmdefs.h"\
	".\proto.h"\
	".\systems.h"\
	

!IF  "$(CFG)" == "gdbm - Win32 Release"


"$(INTDIR)\dbmseq.obj" : $(SOURCE) $(DEP_CPP_DBMSE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "gdbm - Win32 Debug"


"$(INTDIR)\dbmseq.obj"	"$(INTDIR)\dbmseq.sbr" : $(SOURCE) $(DEP_CPP_DBMSE)\
 "$(INTDIR)"


!ENDIF 

SOURCE=.\dbmstore.c
DEP_CPP_DBMST=\
	".\autoconf.h"\
	".\extern.h"\
	".\gdbmconst.h"\
	".\gdbmdefs.h"\
	".\proto.h"\
	".\systems.h"\
	

!IF  "$(CFG)" == "gdbm - Win32 Release"


"$(INTDIR)\dbmstore.obj" : $(SOURCE) $(DEP_CPP_DBMST) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "gdbm - Win32 Debug"


"$(INTDIR)\dbmstore.obj"	"$(INTDIR)\dbmstore.sbr" : $(SOURCE) $(DEP_CPP_DBMST)\
 "$(INTDIR)"


!ENDIF 

SOURCE=.\delete.c
DEP_CPP_DELET=\
	".\autoconf.h"\
	".\extern.h"\
	".\gdbmconst.h"\
	".\gdbmdefs.h"\
	".\proto.h"\
	".\systems.h"\
	

!IF  "$(CFG)" == "gdbm - Win32 Release"


"$(INTDIR)\delete.obj" : $(SOURCE) $(DEP_CPP_DELET) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "gdbm - Win32 Debug"


"$(INTDIR)\delete.obj"	"$(INTDIR)\delete.sbr" : $(SOURCE) $(DEP_CPP_DELET)\
 "$(INTDIR)"


!ENDIF 

SOURCE=.\falloc.c
DEP_CPP_FALLO=\
	".\autoconf.h"\
	".\gdbmconst.h"\
	".\gdbmdefs.h"\
	".\proto.h"\
	".\systems.h"\
	

!IF  "$(CFG)" == "gdbm - Win32 Release"


"$(INTDIR)\falloc.obj" : $(SOURCE) $(DEP_CPP_FALLO) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "gdbm - Win32 Debug"


"$(INTDIR)\falloc.obj"	"$(INTDIR)\falloc.sbr" : $(SOURCE) $(DEP_CPP_FALLO)\
 "$(INTDIR)"


!ENDIF 

SOURCE=.\fetch.c
DEP_CPP_FETCH=\
	".\autoconf.h"\
	".\extern.h"\
	".\gdbmconst.h"\
	".\gdbmdefs.h"\
	".\proto.h"\
	".\systems.h"\
	

!IF  "$(CFG)" == "gdbm - Win32 Release"


"$(INTDIR)\fetch.obj" : $(SOURCE) $(DEP_CPP_FETCH) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "gdbm - Win32 Debug"


"$(INTDIR)\fetch.obj"	"$(INTDIR)\fetch.sbr" : $(SOURCE) $(DEP_CPP_FETCH)\
 "$(INTDIR)"


!ENDIF 

SOURCE=.\findkey.c
DEP_CPP_FINDK=\
	".\autoconf.h"\
	".\gdbmconst.h"\
	".\gdbmdefs.h"\
	".\proto.h"\
	".\systems.h"\
	

!IF  "$(CFG)" == "gdbm - Win32 Release"


"$(INTDIR)\findkey.obj" : $(SOURCE) $(DEP_CPP_FINDK) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "gdbm - Win32 Debug"


"$(INTDIR)\findkey.obj"	"$(INTDIR)\findkey.sbr" : $(SOURCE) $(DEP_CPP_FINDK)\
 "$(INTDIR)"


!ENDIF 

SOURCE=.\gdbmclose.c
DEP_CPP_GDBMC=\
	".\autoconf.h"\
	".\gdbmconst.h"\
	".\gdbmdefs.h"\
	".\proto.h"\
	".\systems.h"\
	

!IF  "$(CFG)" == "gdbm - Win32 Release"


"$(INTDIR)\gdbmclose.obj" : $(SOURCE) $(DEP_CPP_GDBMC) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "gdbm - Win32 Debug"


"$(INTDIR)\gdbmclose.obj"	"$(INTDIR)\gdbmclose.sbr" : $(SOURCE)\
 $(DEP_CPP_GDBMC) "$(INTDIR)"


!ENDIF 

SOURCE=.\gdbmdelete.c
DEP_CPP_GDBMD=\
	".\autoconf.h"\
	".\gdbmconst.h"\
	".\gdbmdefs.h"\
	".\gdbmerrno.h"\
	".\proto.h"\
	".\systems.h"\
	

!IF  "$(CFG)" == "gdbm - Win32 Release"


"$(INTDIR)\gdbmdelete.obj" : $(SOURCE) $(DEP_CPP_GDBMD) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "gdbm - Win32 Debug"


"$(INTDIR)\gdbmdelete.obj"	"$(INTDIR)\gdbmdelete.sbr" : $(SOURCE)\
 $(DEP_CPP_GDBMD) "$(INTDIR)"


!ENDIF 

SOURCE=.\gdbmerrno.c
DEP_CPP_GDBME=\
	".\autoconf.h"\
	".\gdbmerrno.h"\
	

!IF  "$(CFG)" == "gdbm - Win32 Release"


"$(INTDIR)\gdbmerrno.obj" : $(SOURCE) $(DEP_CPP_GDBME) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "gdbm - Win32 Debug"


"$(INTDIR)\gdbmerrno.obj"	"$(INTDIR)\gdbmerrno.sbr" : $(SOURCE)\
 $(DEP_CPP_GDBME) "$(INTDIR)"


!ENDIF 

SOURCE=.\gdbmexists.c
DEP_CPP_GDBMEX=\
	".\autoconf.h"\
	".\gdbmconst.h"\
	".\gdbmdefs.h"\
	".\gdbmerrno.h"\
	".\proto.h"\
	".\systems.h"\
	

!IF  "$(CFG)" == "gdbm - Win32 Release"


"$(INTDIR)\gdbmexists.obj" : $(SOURCE) $(DEP_CPP_GDBMEX) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "gdbm - Win32 Debug"


"$(INTDIR)\gdbmexists.obj"	"$(INTDIR)\gdbmexists.sbr" : $(SOURCE)\
 $(DEP_CPP_GDBMEX) "$(INTDIR)"


!ENDIF 

SOURCE=.\gdbmfetch.c
DEP_CPP_GDBMF=\
	".\autoconf.h"\
	".\gdbmconst.h"\
	".\gdbmdefs.h"\
	".\gdbmerrno.h"\
	".\proto.h"\
	".\systems.h"\
	

!IF  "$(CFG)" == "gdbm - Win32 Release"


"$(INTDIR)\gdbmfetch.obj" : $(SOURCE) $(DEP_CPP_GDBMF) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "gdbm - Win32 Debug"


"$(INTDIR)\gdbmfetch.obj"	"$(INTDIR)\gdbmfetch.sbr" : $(SOURCE)\
 $(DEP_CPP_GDBMF) "$(INTDIR)"


!ENDIF 

SOURCE=.\gdbmopen.c
DEP_CPP_GDBMO=\
	".\autoconf.h"\
	".\gdbmconst.h"\
	".\gdbmdefs.h"\
	".\gdbmerrno.h"\
	".\proto.h"\
	".\systems.h"\
	

!IF  "$(CFG)" == "gdbm - Win32 Release"


"$(INTDIR)\gdbmopen.obj" : $(SOURCE) $(DEP_CPP_GDBMO) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "gdbm - Win32 Debug"


"$(INTDIR)\gdbmopen.obj"	"$(INTDIR)\gdbmopen.sbr" : $(SOURCE) $(DEP_CPP_GDBMO)\
 "$(INTDIR)"


!ENDIF 

SOURCE=.\gdbmreorg.c

!IF  "$(CFG)" == "gdbm - Win32 Release"

DEP_CPP_GDBMR=\
	".\autoconf.h"\
	".\extern.h"\
	".\gdbmconst.h"\
	".\gdbmdefs.h"\
	".\gdbmerrno.h"\
	".\proto.h"\
	".\systems.h"\
	

"$(INTDIR)\gdbmreorg.obj" : $(SOURCE) $(DEP_CPP_GDBMR) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "gdbm - Win32 Debug"

DEP_CPP_GDBMR=\
	".\autoconf.h"\
	".\extern.h"\
	".\gdbmconst.h"\
	".\gdbmdefs.h"\
	".\gdbmerrno.h"\
	".\proto.h"\
	".\systems.h"\
	

"$(INTDIR)\gdbmreorg.obj"	"$(INTDIR)\gdbmreorg.sbr" : $(SOURCE)\
 $(DEP_CPP_GDBMR) "$(INTDIR)"


!ENDIF 

SOURCE=.\gdbmseq.c
DEP_CPP_GDBMS=\
	".\autoconf.h"\
	".\gdbmconst.h"\
	".\gdbmdefs.h"\
	".\gdbmerrno.h"\
	".\proto.h"\
	".\systems.h"\
	

!IF  "$(CFG)" == "gdbm - Win32 Release"


"$(INTDIR)\gdbmseq.obj" : $(SOURCE) $(DEP_CPP_GDBMS) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "gdbm - Win32 Debug"


"$(INTDIR)\gdbmseq.obj"	"$(INTDIR)\gdbmseq.sbr" : $(SOURCE) $(DEP_CPP_GDBMS)\
 "$(INTDIR)"


!ENDIF 

SOURCE=.\gdbmsetopt.c
DEP_CPP_GDBMSE=\
	".\autoconf.h"\
	".\gdbmconst.h"\
	".\gdbmdefs.h"\
	".\gdbmerrno.h"\
	".\proto.h"\
	".\systems.h"\
	

!IF  "$(CFG)" == "gdbm - Win32 Release"


"$(INTDIR)\gdbmsetopt.obj" : $(SOURCE) $(DEP_CPP_GDBMSE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "gdbm - Win32 Debug"


"$(INTDIR)\gdbmsetopt.obj"	"$(INTDIR)\gdbmsetopt.sbr" : $(SOURCE)\
 $(DEP_CPP_GDBMSE) "$(INTDIR)"


!ENDIF 

SOURCE=.\gdbmstore.c
DEP_CPP_GDBMST=\
	".\autoconf.h"\
	".\gdbmconst.h"\
	".\gdbmdefs.h"\
	".\gdbmerrno.h"\
	".\proto.h"\
	".\systems.h"\
	

!IF  "$(CFG)" == "gdbm - Win32 Release"


"$(INTDIR)\gdbmstore.obj" : $(SOURCE) $(DEP_CPP_GDBMST) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "gdbm - Win32 Debug"


"$(INTDIR)\gdbmstore.obj"	"$(INTDIR)\gdbmstore.sbr" : $(SOURCE)\
 $(DEP_CPP_GDBMST) "$(INTDIR)"


!ENDIF 

SOURCE=.\gdbmsync.c
DEP_CPP_GDBMSY=\
	".\autoconf.h"\
	".\gdbmconst.h"\
	".\gdbmdefs.h"\
	".\gdbmerrno.h"\
	".\proto.h"\
	".\systems.h"\
	

!IF  "$(CFG)" == "gdbm - Win32 Release"


"$(INTDIR)\gdbmsync.obj" : $(SOURCE) $(DEP_CPP_GDBMSY) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "gdbm - Win32 Debug"


"$(INTDIR)\gdbmsync.obj"	"$(INTDIR)\gdbmsync.sbr" : $(SOURCE) $(DEP_CPP_GDBMSY)\
 "$(INTDIR)"


!ENDIF 

SOURCE=.\getopt.c

!IF  "$(CFG)" == "gdbm - Win32 Release"

DEP_CPP_GETOP=\
	".\autoconf.h"\
	".\getopt.h"\
	

"$(INTDIR)\getopt.obj" : $(SOURCE) $(DEP_CPP_GETOP) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "gdbm - Win32 Debug"

DEP_CPP_GETOP=\
	".\autoconf.h"\
	".\getopt.h"\
	

"$(INTDIR)\getopt.obj"	"$(INTDIR)\getopt.sbr" : $(SOURCE) $(DEP_CPP_GETOP)\
 "$(INTDIR)"


!ENDIF 

SOURCE=.\global.c
DEP_CPP_GLOBA=\
	".\autoconf.h"\
	".\gdbmconst.h"\
	".\gdbmdefs.h"\
	".\gdbmerrno.h"\
	".\proto.h"\
	".\systems.h"\
	

!IF  "$(CFG)" == "gdbm - Win32 Release"


"$(INTDIR)\global.obj" : $(SOURCE) $(DEP_CPP_GLOBA) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "gdbm - Win32 Debug"


"$(INTDIR)\global.obj"	"$(INTDIR)\global.sbr" : $(SOURCE) $(DEP_CPP_GLOBA)\
 "$(INTDIR)"


!ENDIF 

SOURCE=.\hash.c
DEP_CPP_HASH_=\
	".\autoconf.h"\
	".\gdbmconst.h"\
	".\gdbmdefs.h"\
	".\proto.h"\
	".\systems.h"\
	

!IF  "$(CFG)" == "gdbm - Win32 Release"


"$(INTDIR)\hash.obj" : $(SOURCE) $(DEP_CPP_HASH_) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "gdbm - Win32 Debug"


"$(INTDIR)\hash.obj"	"$(INTDIR)\hash.sbr" : $(SOURCE) $(DEP_CPP_HASH_)\
 "$(INTDIR)"


!ENDIF 

SOURCE=.\seq.c
DEP_CPP_SEQ_C=\
	".\autoconf.h"\
	".\extern.h"\
	".\gdbmconst.h"\
	".\gdbmdefs.h"\
	".\proto.h"\
	".\systems.h"\
	

!IF  "$(CFG)" == "gdbm - Win32 Release"


"$(INTDIR)\seq.obj" : $(SOURCE) $(DEP_CPP_SEQ_C) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "gdbm - Win32 Debug"


"$(INTDIR)\seq.obj"	"$(INTDIR)\seq.sbr" : $(SOURCE) $(DEP_CPP_SEQ_C)\
 "$(INTDIR)"


!ENDIF 

SOURCE=.\store.c
DEP_CPP_STORE=\
	".\autoconf.h"\
	".\extern.h"\
	".\gdbmconst.h"\
	".\gdbmdefs.h"\
	".\proto.h"\
	".\systems.h"\
	

!IF  "$(CFG)" == "gdbm - Win32 Release"


"$(INTDIR)\store.obj" : $(SOURCE) $(DEP_CPP_STORE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "gdbm - Win32 Debug"


"$(INTDIR)\store.obj"	"$(INTDIR)\store.sbr" : $(SOURCE) $(DEP_CPP_STORE)\
 "$(INTDIR)"


!ENDIF 

SOURCE=.\update.c
DEP_CPP_UPDAT=\
	".\autoconf.h"\
	".\gdbmconst.h"\
	".\gdbmdefs.h"\
	".\proto.h"\
	".\systems.h"\
	

!IF  "$(CFG)" == "gdbm - Win32 Release"


"$(INTDIR)\update.obj" : $(SOURCE) $(DEP_CPP_UPDAT) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "gdbm - Win32 Debug"


"$(INTDIR)\update.obj"	"$(INTDIR)\update.sbr" : $(SOURCE) $(DEP_CPP_UPDAT)\
 "$(INTDIR)"


!ENDIF 

SOURCE=.\version.c
DEP_CPP_VERSI=\
	".\autoconf.h"\
	

!IF  "$(CFG)" == "gdbm - Win32 Release"


"$(INTDIR)\version.obj" : $(SOURCE) $(DEP_CPP_VERSI) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "gdbm - Win32 Debug"


"$(INTDIR)\version.obj"	"$(INTDIR)\version.sbr" : $(SOURCE) $(DEP_CPP_VERSI)\
 "$(INTDIR)"


!ENDIF 


!ENDIF 

