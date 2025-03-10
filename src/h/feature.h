/*
 * feature.h -- predefined symbols and &features
 *
 * This file consists entirely of a sequence of conditionalized calls
 *  to the Feature() macro.  The macro is not defined here, but is
 *  defined to different things by the the code that includes it.
 *
 * For the macro call  Feature(guard,symname,kwval)
 * the parameters are:
 *    guard for the compiler's runtime system, an expression that must
 *    evaluate as true for the feature to be included in &features
 *    symname   predefined name in the preprocessor; "" if none
 *    kwval value produced by the &features keyword; 0 if none
 *
 * The translator and compiler modify this list of predefined symbols
 * through calls to ppdef().
 */

   Feature(1, "_V9", 0)         /* Version 9 (unconditional) */

#if VM
   Feature(1, "_CMS", "CMS")
#endif                  /* VM */

#ifdef MacOS
   Feature(1, "_MACOS", "MacOS")
#endif                  /* MacOS */

#if MSDOS
#if NT
   Feature(1, "_MS_WINDOWS_NT", "MS Windows NT")
#else                   /* NT */
   Feature(1, "_MSDOS", "MS-DOS")
#endif                  /* NT */
#endif                  /* MSDOS */

#if MVS
   Feature(1, "_MVS", "MVS")
#endif                  /* MVS */

#if PORT
   Feature(1, "_PORT", "PORT")
#endif                  /* PORT */

#if UNIX
   Feature(1, "_UNIX", "UNIX")
#endif                  /* VM */

#ifdef SUN
   Feature(1, "_SOLARIS", "Solaris")
#endif                  /* SUN */

#ifdef PosixFns
   Feature(1, "_POSIX", "POSIX")
#endif                  /* PosixFns */

#ifdef Dbm
   Feature(1, "_DBM", "DBM")
#endif                  /* DBM */

#if VMS
   Feature(1, "_VMS", "VMS")
#endif                  /* VMS */

#if EBCDIC != 1
   Feature(1, "_ASCII", "ASCII")
#else                   /* EBCDIC != 1 */
   Feature(1, "_EBCDIC", "EBCDIC")
#endif                  /* EBCDIC */

#ifdef CoExpr
   Feature(1, "_CO_EXPRESSIONS", "co-expressions")
#endif                  /* CoExpr */

#ifdef NativeCoswitch
   Feature(1, "_NATIVECOSWITCH", "native coswitch")
#endif                  /* NativeCoswitch */

#ifdef Concurrent
#if ConcurrentCOMPILER
   Feature(1, "_CONCURRENT", "concurrent threads, compiler subset")
#else                   /* ConcurrentCOMPILER */
   Feature(1, "_CONCURRENT", "concurrent threads")
#endif                  /* ConcurrentCOMPILER */
#endif                  /* CoExpr */

#ifdef ConsoleWindow
   Feature(1, "_CONSOLE_WINDOW", "console window")
#endif                  /* ConsoleWindow */

#ifdef LoadFunc
   Feature(1, "_DYNAMIC_LOADING", "dynamic loading")
#endif                  /* LoadFunc */

   Feature(1, "", "environment variables")

#ifdef EventMon
   Feature(1, "_EVENT_MONITOR", "event monitoring")
#endif                  /* EventMon */

#ifdef ExternalFunctions
   Feature(1, "_EXTERNAL_FUNCTIONS", "external functions")
#endif                  /* ExternalFunctions */

#ifdef KeyboardFncs
   Feature(1, "_KEYBOARD_FUNCTIONS", "keyboard functions")
#endif                  /* KeyboardFncs */

#ifdef LargeInts
   Feature(largeints, "_LARGE_INTEGERS", "large integers")
#endif                  /* LargeInts */

#ifdef MultiProgram
   Feature(1, "_MULTITASKING", "multiple programs")
#endif                  /* MultiProgram */

#ifdef PatternType
   Feature(1, "_PATTERNS", "pattern type")
#endif                  /* PatternType */

#ifdef Pipes
   Feature(1, "_PIPES", "pipes")
#endif                  /* Pipes */

#ifdef PseudoPty
   Feature(1, "_PTY", "pseudo terminals")
#endif                  /* PseudoPty */

   Feature(1, "_SYSTEM_FUNCTION", "system function")

#ifdef Messaging
   Feature(1, "_MESSAGING", "messaging")
#endif                                  /* Messaging */

#ifdef Graphics
   Feature(1, "_GRAPHICS", "graphics")
#endif                  /* Graphics */

#ifdef Graphics3D
   Feature(1, "_3D_GRAPHICS", "3D graphics")
#endif                  /* Graphics */

#ifdef GraphicsGL
   Feature(1, "_GL_GRAPHICS", "OpenGL graphics")
#endif                  /* GraphicsGL */

#ifdef XWindows
   Feature(1, "_X_WINDOW_SYSTEM", "X Windows")
#endif                  /* XWindows */

#ifdef MSWindows
   Feature(1, "_MS_WINDOWS", "MS Windows")
#ifdef NT
   Feature(1, "_WIN32", "Win32")
#endif                  /* NT */
#endif                  /* MSWindows */

#ifdef DosFncs
   Feature(1, "_DOS_FUNCTIONS", "MS-DOS extensions")
#endif                  /* DosFncs */

#if HAVE_LIBZ
   Feature(1, "_LIBZ_COMPRESSION", "libz file compression")
#endif                  /* HAVE_LIBZ */

#if HAVE_LIBJPEG
   Feature(1, "_JPEG", "JPEG images")
#endif                  /* HAVE_LIBJPEG */

#if HAVE_LIBPNG
   Feature(1, "_PNG", "PNG images")
#endif                  /* HAVE_LIBPNG */

#ifdef ISQL
   Feature(1, "_SQL", "SQL via ODBC")
#endif                  /* ISQL */

#ifdef Audio
   Feature(1, "_AUDIO", "Audio")
#endif                  /* Audio */

#ifdef HAVE_LIBSSL
   Feature(1, "_SSL", "secure sockets layer encryption")
#endif                  /* HAVE_LIBSSL */

#ifdef HAVE_VOICE
   Feature(1, "_VOIP", "Voice Over IP")
#endif                  /* HAVE_VOICE */

#ifdef OVLD
   Feature(1, "_OVLD", "operator overloading")
#endif                  /* OVLD */

#ifdef DEVELOPMODE
   /*
    * DEVELOPMODE used to be called DEVMODE and caused (amongst other things)
    * the preprocessor to define _DEVMODE as a predefined symbol.
    * Unfortunately, DEVMODE is used by the Windows UCRT run time and the clash of
    * symbols causes a build failure when Unicon is configured with --enable-devmode
    * So, in the Unicon run time system, DEVMODE has been renamed to DEVELOPMODE.
    * The name of the preprocessor defined symbol and the configure option
    * are unchanged to avoid breaking existing usage.
    */
   Feature(1, "_DEVMODE", "developer mode")
#endif                  /* DEVELOPMODE */
