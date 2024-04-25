/*
 * Icon configuration file for Silicon Graphics Irix
 */
 
#define UNIX 1
#define LoadFunc
#define SysOpt

#define IRIS4D
#define CStateSize 32		/* anything >= 26 should actually do */
#define Double

#define NoRanlib
#ifdef NoCoExpr
   #define MaxStatSize 9000
#endif				/* NoCoExpr */

#define COpts "-Wf,-XNd10000"

#define GammaCorrection 1.0	/* for old X11R5 systems */
#define STKSIZE 50000
#define MStackSize 50000

#define Messaging
