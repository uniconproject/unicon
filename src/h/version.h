/*
 * version.h -- version identification
 */

#undef DVersion
#undef Version
#undef UVersion
#undef IVersion

/* Include build information for files that need version details */
#include "../h/build.h"

/*
 *  Icon version number and date.
 *  These are the only two entries that change any more.
 */
#define VersionNumber "13.2"

#define VersionDate "October 15, 2020"

/*
 * Version number to insure format of data base matches version of iconc
 *  and rtt.
 */

#define DVersion "12.1.00"

#if COMPILER

   /*
    * &version
    */
   #define Version  "Unicon Version " VersionNumber " (iconc).  " VersionDate

#else					/* COMPILER */

   /*
    *  &version
    */
   #define Version  "Unicon Version " VersionNumber ".  " VersionDate
   
   /*
    * Version numbers to be sure ucode is compatible with the linker
    * and icode is compatible with the run-time system.
    */
   
   #define UVersion "U12.1.00"
   
       #ifdef FieldTableCompression

	  #if IntBits == 16
	     #define IVersion "I12.U.30FT/16/16"
	  #endif				/* IntBits == 16 */

	  #if IntBits == 32
#if WordBits==64
	     #define IVersion "I12.U.30FT/32/64"
#else
	     #define IVersion "I12.U.30FT/32/32"
#endif
	  #endif				/* IntBits == 32 */

	  #if IntBits == 64
	     #define IVersion "I12.U.30FT/64/64"
	  #endif				/* IntBits == 64 */

       #else				/* FieldTableCompression */

	  #if IntBits == 16
	     #define IVersion "I12.U.30/16/32"
	  #endif				/* IntBits == 16 */

	  #if IntBits == 32
#if WordBits==64
	     #define IVersion "I12.U.30/32/64"
#else
	     #define IVersion "I12.U.30/32/32"
#endif
	  #endif				/* IntBits == 32 */

	  #if IntBits == 64
	     #define IVersion "I12.U.30/64/64"
	  #endif				/* IntBits == 64 */

       #endif				/* FieldTableCompression */
   
#endif					/* COMPILER */

/*
 * Version number for event monitoring.
 */
#define Eversion "12.0.00"
