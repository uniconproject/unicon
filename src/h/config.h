/*
 * Icon configuration.
 */

/*
 * System-specific definitions are in define.h
 * update June 2017:: 
 *    System-specific definitions are being handleded 
 *    by the confure script. Some remaining definitions are
 *    moved here so they are all in one place for all systems.
 *    Many of these options will be automated as well. 
 */

/*
 *  A number of symbols are defined here.  Some are specific to individual
 *  to operating systems.  Examples are:
 *
 *	MSDOS		MS-DOS for PCs
 *	UNIX		any UNIX system; also set for BeOS
 *	VMS		VMS for the VAX
 *
 *  These are defined to be 1 or 0 depending on which operating system
 *  the installation is being done under.  They are all defined and only
 *  one is defined to be 1.  (They are used in the form #if VAX || MSDOS.)
 *
 *  There also are definitions of symbols for specific computers and
 *  versions of operating systems.  These include:
 *
 *	SUN		code specific to the Sun Workstation
 *	MICROSOFT	code specific to the Microsoft C compiler for MS-DOS
 *
 *  Other definitions may occur for different configurations. These include:
 *
 *	DeBug		debugging code
 *	MultiProgram	support for multiple programs under the interpreter
 *
 *  Other definitions perform configurations that are common to several
 *  systems. An example is:
 *
 *	Double		align reals at double-word boundaries
 *
 */

#ifndef UNICON_CONFIG_H
#define UNICON_CONFIG_H

/*
 * If define.h does not specify NoAuto, supplement config info with
 * autoconf-generated symbols.
 */
#ifndef NoAuto
#include "../h/auto.h"
#endif					/* NoAuto */

#define UNICONX "uniconx"
#define UNICONWX "wuniconx"
#define UNICONT "unicont"
#define UNICONWT "wunicont"
#define UNICONC "uniconc"

#if NT
#define UNICONX_EXE UNICONX".exe"
#define UNICONWX_EXE UNICONWX".exe"
#define UNICONT_EXE UNICONT".exe"
#define UNICONWT_EXE UNICONWT".exe"
#define UNICONC_EXE UNICONC".exe"
#else					/* NT */
#define UNICONX_EXE UNICONX
#define UNICONWX_EXE UNICONWX
#define UNICONT_EXE UNICONT
#define UNICONWT_EXE UNICONWT
#define UNICONC_EXE UNICONC


#endif					/* NT */



/* make SQL_LENORIND definition global for now*/
#define SQL_LENORIND SQLLEN

#if MacOS
//#define COpts "-I/usr/X11R6/include"

#define NamedSemaphores
#define INTMAIN
#define PROFIL_CHAR_P
#endif					/* MacOS */

#if SUN
#define INTMAIN

#define SysOpt   1
#define NoRanlib
//#define COpts " -m64 -I/usr/X11R6/include -L/usr/X11R6/lib/64 "

#define Messaging  1
#define PosixFns   1
#define NoVFork
#endif 					/* SUN */


#if FreeBSD
#define GenericBSD
#define BSD_4_4_LITE    1	/* This is new, for 4.4Lite specific stuff */

#define NEED_UTIME
#define Messaging 1

#define SysOpt
#define ExecImages

#define MaxStatSize 40960

#define LinkLibs " -lm"

#define HAVE_GETHOSTNAME 1
#define HAVE_GETPWUID 1
#define HAVE_GETUID 1
#endif					/* FreeBSD */


#if Windows

/*
 * 0x501 => WindowsXP or later
 * 0x601 => Win7 or later
 */

#if !defined(WINVER) || (WINVER < 0x0601)
#undef WINVER
#define WINVER 0x0601
#endif

#if !defined(_WIN32_WINNT) || (_WIN32_WINNT < 0x0601)
#undef _WIN32_WINNT
#define _WIN32_WINNT 0x0601
#endif

#define HostStr "Win32 Intel GCC"
#define IconAlloc
#define Precision 16
#define IcodeSuffix ".exe"
#define IcodeASuffix ".EXE"
#define SystemFnc
#define SysTime <sys/time.h>
#define Standard
/*
 * Header is used in winnt.h; careful how we define it here
 */
#define Header header
#define NT 1
#define NTGCC 1
#define CComp "gcc"
#define ShellHeader

#define index strchr
#define rindex strrchr
#define strdup _strdup
#define unlink _unlink
#define MSDOS 1
#define StandardC
#define ZERODIVIDE
#define QSortFncCast int (*)(const void *,const void *)

/* #define Eve */
#define PosixFns
#define KeyboardFncs
#define NoCrypt
#define Dbm
#define Messaging 1

#if defined(Messaging) && defined(OLD_NTGCC)
#define ssize_t signed
#endif					/* Messaging && OLD_NTGCC */

#define LoadFunc
#define FieldTableCompression 1

/* StackCheck seems to cause a crash when exiting through 
 * pressing the [x] close window button, turn it off for now 
 */
#define NoStackCheck

#endif					/* Windows */


/*
 * If COMPILER is not defined, code for the interpreter is compiled.
 */

#ifndef COMPILER
   #define COMPILER 0
#endif

/*
 * The following definitions insure that all the symbols for operating
 * systems that are not relevant are defined to be 0 -- so that they
 * can be used in logical expressions in #if directives.
 */

#ifndef PORT
   #define PORT 0
#endif					/* PORT */

#ifndef MACINTOSH
   #define MACINTOSH 0
#endif					/* MACINTOSH */

#ifndef MSDOS
   #define MSDOS 0
#endif					/* MSDOS */

#ifndef MVS
   #define MVS 0
#endif					/* MVS */

#ifndef UNIX
   #define UNIX 0
#endif					/* UNIX */

#ifndef VM
   #define VM 0
#endif					/* VM */

#ifndef VMS
   #define VMS 0
#endif					/* VMS */

/*
 * The following definitions serve to cast common conditionals is
 *  a positive way, while allowing defaults for the cases that
 *  occur most frequently.  That is, if co-expressions are not supported,
 *  NoCoExpr is defined in define.h, but if they are supported, no
 *  definition is needed in define.h; nonetheless subsequent conditionals
 *  can be cast as #ifdef CoExpr.
 */

#ifndef NoPosixFns
   #undef PosixFns
   #define PosixFns
#endif					/* NoPosixFns */

#ifdef PosixFns
#define ReadDirectory
#endif					/* PosixFns */

/*
 *  Execution monitoring is not supported under the compiler,
 *  nor if co-expressions are not available.
 */

#undef NativeCoswitch
#ifdef NoCoExpr
   #undef NoNativeCoswitch
   #define NoNativeCoswitch
   #undef MultiProgram
   #undef NoMultiProgram
   #define NoMultiProgram
#else					/* NoCoExpr */
   #undef CoExpr
   #define CoExpr
   #ifndef NoNativeCoswitch
      #define NativeCoswitch
   #endif				/* NoNativeCoswitch */
#endif					/* NoCoExpr */

#if COMPILER
   #undef MultiProgram
   #undef NoMultiProgram
   #define NoMultiProgram
#endif					/* COMPILER */

#ifdef NoMultiProgram
   #undef MultiProgram
   #undef EventMon
   #undef Eve
   #undef NoEventMon
   #define NoEventMon
#else
   #undef MultiProgram
   #define MultiProgram
#endif					/* NoMultiProgram */

#ifndef NoEventMon
  #undef  EventMon
  #define EventMon
#endif

//#ifdef MultiProgram
   #if defined(HAVE_LIBPTHREAD) && !defined(NoConcurrent)
      #undef Concurrent
      #define Concurrent 1
   #endif			/* HAVE_LIBPTHREAD && !NoConcurrent */
//#endif					/* MultiProgram */

#if defined(Concurrent) && COMPILER
   #ifdef NoConcurrentCOMPILER
   #define ConcurrentCOMPILER 0
   #undef Concurrent
   #else
   #define ConcurrentCOMPILER 1
   #endif
#else
   #define ConcurrentCOMPILER 0
#endif

#ifdef Concurrent
   #define PthreadCoswitch 1
   #define TSLIST 
   /*
    * The default at present does not use __thread.
    * To use __thread, uncomment the following line 
    * "#define HAVE_KEYWORD__THREAD"
    */
#endif				/* Concurrent */

#ifndef NoINTMAIN
   #undef INTMAIN
   #define INTMAIN
#endif					/* NoINTMAIN */

#ifndef NoMessaging
   #undef Messaging
   #define Messaging
#endif					/* Messaging */

#ifndef NoStrInvoke
   #undef StrInvoke
   #define StrInvoke
#endif					/* NoStrInvoke */

#ifndef NoLargeInts
   #undef LargeInts
   #define LargeInts
#endif					/* NoLargeInts */

#ifdef EventMon
   #undef MultiProgram
   #define MultiProgram
#ifndef NoMonitoredTrappedVar
   #undef MonitoredTrappedVar
   #define MonitoredTrappedVar
#endif					/* MonitoredTrappedVar */
#endif					/* EventMon */


/*
 * Names for standard environment variables.
 * The standard names are used unless they are overridden.
 */

#ifndef NOERRBUF
   #define NOERRBUF "NOERRBUF"
#endif

#ifndef TRACE
   #define TRACE "TRACE"
#endif

#ifndef COEXPSIZE
   #define COEXPSIZE "COEXPSIZE"
#endif

#ifndef STRSIZE
   #define STRSIZE "STRSIZE"
#endif

#ifndef HEAPSIZE
   #define HEAPSIZE "HEAPSIZE"
#endif

#ifndef BLOCKSIZE
   #define BLOCKSIZE "BLOCKSIZE"
#endif

#ifndef BLKSIZE
   #define BLKSIZE "BLKSIZE"
#endif

#ifndef MSTKSIZE
   #define MSTKSIZE "MSTKSIZE"
#endif

#ifndef QLSIZE
   #define QLSIZE "QLSIZE"
#endif

#ifndef ICONCORE
   #define ICONCORE "ICONCORE"
#endif

#ifndef IPATH
   #define IPATH "IPATH"
#endif

#if defined(HAVE_LIBJVOIP) && defined(HAVE_LIBJRTP) && defined(HAVE_LIBJTHREAD) && defined(HAVE_LIBVOIP)
#define HAVE_VOICE
#endif

#if (defined(HAVE_LIBOPENAL) && defined(HAVE_LIBALUT))
   #if (defined(HAVE_LIBVORBIS) && defined(HAVE_LIBOGG))
   #define Audio
   #endif
   #if defined(HAVE_LIBSDL) && defined(HAVE_LIBSMPEG)
   #define Audio
   #endif
#endif

#if  (defined(HAVE_LIBOGG) && defined(WIN32))
/* defined audio because have ogg and win32 */
#define Audio
#endif

#if !defined(NoGraphics)
   #if HAVE_LIBX11
   #define Graphics 1
   #endif

#if defined(MSWindows) || defined(WICONT)
   #undef Graphics
   #define Graphics 1
   #define FAttrib 1
   #ifndef NTConsole
      #define ConsoleWindow 1
   #endif				/* NTConsole */
   #endif					/* MSWindows */

   #ifdef MacGraph
   #undef Graphics
   #define Graphics 1
   #endif					/* MacGraph */
#endif



#ifdef Graphics
   #ifndef NoXpmFormat
      #if UNIX
         #undef HAVE_LIBXPM
         #define HAVE_LIBXPM
      #endif				/* UNIX */
   #endif				/* NoXpmFormat */

   #ifndef MSWindows
         #ifndef MacGraph
            #undef XWindows
            #define XWindows 1
         #endif				/* MacGraph */
   #endif				/* MSWindows */

   #undef LineCodes
   #define LineCodes

   #undef Polling
   #define Polling

   #ifndef NoIconify
      #define Iconify
   #endif				/* NoIconify */

   #ifndef ICONC_XLIB
      #define ICONC_XLIB "-L/usr/X11R6/lib -lX11"
   #endif				/* ICONC_XLIB */

   #if defined(ConsoleWindow) || (NT && !defined(Rttx) && !defined(NTConsole))
      /*
       * Knock out fprintf and putc; these are here so that consoles
       * may be used in icont and rtt, not just iconx.
       */
      #undef fprintf
      #define fprintf Consolefprintf
      #undef putc
      #define putc Consoleputc
      #undef fflush
      #define fflush Consolefflush
      #undef printf
      #define printf Consoleprintf
   #endif


#endif					/* Graphics */

#ifndef NoExternalFunctions
   #undef ExternalFunctions
   #define ExternalFunctions
#endif					/* NoExternalFunctions */

/*
 * EBCDIC == 0 corresponds to ASCII.
 * EBCDIC == 1 corresponds to EBCDIC collating sequence.
 * EBCDIC == 2 provides the ASCII collating sequence for EBCDIC systems.
 */
#ifndef EBCDIC
   #define EBCDIC 0
#endif					/* EBCDIC */

/*
 * Other defaults.
 */

#ifdef DeBug
   #undef DeBugTrans
   #undef DeBugLinker
   #undef DeBugIconx
   #define DeBugTrans
   #define DeBugLinker
   #define DeBugIconx
#endif					/* DeBug */

#ifndef AllocType
   #define AllocType uword
#endif					/* AllocType */

#ifndef MaxHdr
   #define MaxHdr 4096
#endif					/* MaxHdr */

#ifndef MaxPath
   #ifdef PATH_MAX
      #define MaxPath PATH_MAX
   #else
      #define MaxPath 1024
   #endif
#endif					/* MaxPath */

#ifndef StackAlign
   #define StackAlign (SIZEOF_INT_P * 2)
#endif					/* StackAlign */

#ifndef WordBits
   #if Windows
      #define WordBits (SIZEOF_INT_P * 8)
   #else
      #define WordBits (SIZEOF_LONG_INT * 8)
   #endif				/* Windows */
#endif					/* WordBits */

#ifndef IntBits
   #define IntBits (SIZEOF_INT * 8)
#endif					/* IntBits */

#if (WordBits == 64)
   #if Windows
      #define MSWIN64
      #define LongLongWord
   #endif				/* Windows */
   #ifndef OLD_NTGCC
      #define Double
   #endif				/* OLD_NTGCC */
#else
    #ifdef ARM
      #define Double
   #endif				/* ARM */  
#endif

#ifndef SourceSuffix
   #define SourceSuffix ".icn"
#endif					/* SourceSuffix */

/*
 * Representations of directories. LocalDir is the "current working directory".
 *  SourceDir is where the source file is.
 */

#define LocalDir ""
#define SourceDir (char *)NULL

#ifndef TargetDir
   #define TargetDir LocalDir
#endif					/* TargetDir */

/*
 * Features enabled by default under certain systems
 */

#ifndef Pipes
   #if UNIX || VMS
      #define Pipes
   #endif				/* UNIX || VMS */
#endif					/* Pipes */

#ifndef KeyboardFncs
   #if UNIX
      #ifndef NoKeyboardFncs
	 #define KeyboardFncs
      #endif				/* NoKeyboardFncs */
   #endif				/* UNIX */
#endif					/* KeyboardFncs */

#ifndef ReadDirectory
   #if UNIX
      #define ReadDirectory
   #endif				/* UNIX*/
#endif					/* ReadDirectory */

#ifndef Dbm
   #if UNIX
   #ifndef NoDbm
      #define Dbm 1
   #endif				/* NoDbm */
   #endif				/* UNIX */
#endif					/* Dbm */

/*
 * Default sizing and such.
 */

#define WordSize sizeof(word)

#ifndef ByteBits
   #define ByteBits 8
#endif					/* ByteBits */

/*
 *  The following definitions assume ANSI C.
 */
#define Cat(x,y) x##y
#define Lit(x) #x
#define Bell '\a'

/*
 *  something to handle a cast problem for signal().
 */
#ifndef SigFncCast
   #define SigFncCast (void (*)(int))
#endif					/* SigFncCast */

#ifndef QSortFncCast
   #define QSortFncCast int (*)(const void *,const void *)
#endif					/* QSortFncCast */

/*
 * Customize output if not pre-defined.
 */

#if EBCDIC
   #define BackSlash "\xe0"
#else					/* EBCDIC */
   #define BackSlash "\\"
#endif					/* EBCDIC */

#ifndef WriteBinary
   #define WriteBinary "wb"
#endif					/* WriteBinary */

#ifndef ReadBinary
   #define ReadBinary "rb"
#endif					/* ReadBinary */

#ifndef ReadWriteBinary
   #define ReadWriteBinary "wb+"
#endif					/* ReadWriteBinary */

#ifndef ReadEndBinary
   #define ReadEndBinary "r+b"
#endif					/* ReadEndBinary */

#ifndef WriteText
   #define WriteText "w"
#endif					/* WriteText */

#ifndef ReadText
   #define ReadText "r"
#endif					/* ReadText */

/*
 * The following code is operating-system dependent [@config.01].
 *  Any configuration stuff that has to be done at this point.
 */

#if PORT
   /* Probably nothing is needed. */
Deliberate Syntax Error
#endif					/* PORT */

#if VMS
   #define ExecSuffix ".exe"
   #define ObjSuffix ".obj"
   #define LibSuffix ".olb"
#endif					/* VMS */

#if MSDOS

   /*
    *  Define compiler-specific symbols to be zero if not already
    *  defined.
    */

   #ifndef MICROSOFT
      #define MICROSOFT 0
   #endif				/* MICROSOFT */

   #ifndef CSET2
      #define CSET2 0
   #endif				/* CSet/2 */

   #ifndef CSET2V2
      #define CSET2V2 0
   #endif				/* CSet/2 version 2 */

   #ifndef TURBO
      #define TURBO 0
   #endif				/* TURBO */

   #ifndef NT
      #define NT 0
   #endif				/* NT */

#endif					/* MSDOS */

#ifndef NoWildCards
   #if NT || MICROSOFT
      #define WildCards 1
   #else				/* NT || ... */
      #define WildCards 0
   #endif				/* NT || ... */
#else					/* NoWildCards */
   #define WildCards 0
#endif					/* NoWildCards */

/*
 * End of operating-system specific code.
 */

#ifndef DiffPtrs
   #define DiffPtrs(p1,p2) (word)((p1)-(p2))
#endif					/* DiffPtrs */

#ifndef AllocReg
   #define AllocReg(n) malloc((msize)n)
#endif					/* AllocReg */

#define MaxFileName MaxPath

#ifndef RttSuffix
   #define RttSuffix ".r"
#endif					/* RttSuffix */

#ifndef DBSuffix
   #define DBSuffix ".db"
#endif					/* DBSuffix */

#ifndef PPInit
   #define PPInit ""
#endif					/* PPInit */

#ifndef PPDirectives
   #define PPDirectives {"passthru", PpKeep},
#endif					/* PPDirectives */

#ifndef NoPseudoPty
   #define PseudoPty
#endif					/* PseudoPty */

#ifndef NoArrays
   #ifdef Arrays
   #undef Arrays
   #endif
   #define Arrays 1
#endif					/* Arrays */

#if !defined(NoDescriptorDouble) && (WordBits==64)
   #define DescriptorDouble 1
#endif					/* DescriptorDouble */


#ifndef NoPattern
   #define PatternType 1
#endif					/* PatternType */		      

#ifndef ExecSuffix
   #define ExecSuffix ""
#endif					/* ExecSuffix */

#ifndef CSuffix
   #define CSuffix ".c"
#endif					/* CSuffix */

#ifndef HSuffix
   #define HSuffix ".h"
#endif					/* HSuffix */

#ifndef ObjSuffix
   #define ObjSuffix ".o"
#endif					/* ObjSuffix */

#ifndef LibSuffix
   #define LibSuffix ".a"
#endif					/* LibSuffix */

#ifndef CComp
   #define CComp "cc"
#endif					/* CComp */

#ifndef COpts
   #define COpts ""
#endif					/* COpts */

/*
 * Note, size of the hash table is a power of 2:
 */
#define IHSize 128
#define IHasher(x)	(((unsigned int)(uword)(x))&(IHSize-1))

#if COMPILER

   /*
    * Code for the compiler.
    */
   #undef MultiProgram		/* no way -- interpreter only */
   #undef EventMon		/* presently not supported in the compiler */
   #undef MonitoredTrappedVar	/* no way */
   #undef ExecImages		/* interpreter only */
   #undef HAVE_IODBC		/* ODBC interpreter only until dynamic */
   #undef ISQL			/* records get added to the compiler */
   #undef OVLD			/* operator overloading -- not supported */

#else					/* COMPILER */

   /*
    * Code for the interpreter.
    */
   #ifndef IcodeSuffix
      #define IcodeSuffix ""
   #endif				/* IcodeSuffix */

   #ifndef IcodeASuffix
      #define IcodeASuffix ""
   #endif				/* IcodeASuffix */

   #ifndef U1Suffix
      #define U1Suffix ".u1"
   #endif				/* U1Suffix */

   #ifndef U2Suffix
      #define U2Suffix ".u2"
   #endif				/* U2Suffix */

   #ifndef USuffix
      #define USuffix ".u"
   #endif				/* USuffix */

#endif					/* COMPILER */

#if UNIX
   #undef Header
   #define Header
   #undef ShellHeader
   #define ShellHeader
#endif					/* UNIX */

/*
 * I don't care what autoconf says, some platforms (Solaris) have trouble
 * with vfork.
 */
#ifdef NoVFork
#undef HAVE_WORKING_VFORK
#endif

#if MSDOS && !NT
   #undef DirectExecution
   #define DirectExecution
#endif					/* MSDOS && !NT */

#ifdef Header
   #undef DirectExecution
   #define DirectExecution
#endif					/* Header */

#ifdef PthreadCoswitch
#define CoClean 1
#endif					/* PthreadCoswitch */

#if COMPILER
#undef StackCheck
#define NoStackCheck
#endif					/* COMPILER */

#ifndef Concurrent
#ifndef NoStackCheck
#define StackCheck 1
#endif					/* NoStackCheck */
#endif					/* Concurrent */

#ifdef NoLIBZ
#undef HAVE_LIBZ
#define HAVE_LIBZ 0
#endif					/* NoLIBZ */

#ifdef NoJPEG
#undef HAVE_LIBJPEG
#define HAVE_LIBJPEG 0
#endif					/* NoJPEG */

#ifdef NoPNG
#undef HAVE_LIBPNG
#define HAVE_LIBPNG 0
#endif					/* NoPNG */

#ifdef NoGL
#undef HAVE_LIBGL
#define HAVE_LIBGL 0
#endif					/* NoGL */

#ifdef NoODBC
#undef HAVE_LIBIODBC
#define HAVE_LIBIODBC 0
#define HAVE_LIBODBC 0
#endif					/* NoODBC */

#ifdef NoProfil
#undef HAVE_PROFIL
#define HAVE_PROFIL 0
#endif					/* NoProfil */

#ifndef HAVE_LIBZ
#define HAVE_LIBZ 0
#endif					/* HAVE_LIBZ */

#if !HAVE_LIBZ && !defined(NTGCC)
#ifdef HAVE_LIBPNG
#undef HAVE_LIBPNG
#endif					/* HAVE_LIBPNG */
#define HAVE_LIBPNG 0
#endif					/* !HAVE_LIBZ */

#ifndef HAVE_LIBJPEG
#define HAVE_LIBJPEG 0
#endif					/* HAVE_LIBJPEG */

#ifndef HAVE_LIBGL
#define HAVE_LIBGL 0
#endif					/* HAVE_LIBGL */

#ifndef HAVE_LIBIODBC
#define HAVE_LIBIODBC 0
#endif					/* HAVE_LIBIODBC */
#ifndef HAVE_LIBODBC
#define HAVE_LIBODBC 0
#endif					/* HAVE_LIBODBC */

#ifndef HAVE_FTGL
#define HAVE_FTGL 0
#endif					/* HAVE_FTGL */

#if HAVE_LIBGL
#define Graphics3D 1
#define GraphicsGL 1
#else					/* HAVE_LIBGL */
#if HAVE_FTGL
#undef HAVE_FTGL
#define HAVE_FTGL 0
#endif					/* HAVE_FTGL */
#endif					/* HAVE_LIBGL */

#ifndef Arrays
  #undef Graphics3D
  #undef PatternType
#endif

#ifndef Graphics
#undef Graphics3D
#endif					/* Graphics */

#if HAVE_LIBIODBC || HAVE_LIBODBC
#define ISQL 1
#endif					/* HAVE_LIBIODBC */
#ifdef ISQL
#ifndef SQL_LENORIND

#ifdef MSWIN64
    #define SQL_LENORIND SQLLEN
#else					/* MSWIN64 */
    #define SQL_LENORIND SQLINTEGER
#endif					/* MSWIN64 */

#endif					/* SQL_LENORIND */
#endif					/* ISQL */

#ifndef NoLoadFunc
#if HAVE_LIBDL
#define LoadFunc
#endif					/* HAVE_LIBDL */
#endif


/*
 *  Vsizeof is for use with variable-sized (i.e., indefinite)
 *   structures containing an array of descriptors declared of size 1
 *   to avoid compiler warnings associated with 0-sized arrays.
 */

#define Vsizeof(s)	(sizeof(s) - sizeof(struct descrip))

/*
 * Other sizeof macros:
 *
 *  Wsizeof(x)	-- Size of x in words.
 *  Vwsizeof(x) -- Size of x in words, minus the size of a descriptor.	Used
 *   when structures have a potentially null list of descriptors
 *   at their end.
 */

#define Wsizeof(x)	((sizeof(x) + sizeof(word) - 1) / sizeof(word))
#define Vwsizeof(x)	((sizeof(x) - sizeof(struct descrip) +\
			   sizeof(word) - 1) / sizeof(word))

#endif					/* UNICON_CONFIG_H */
