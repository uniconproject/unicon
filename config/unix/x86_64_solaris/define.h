/*  
 * Icon configuration file for an AMD64 system running Solaris 10,
   Sun Studio 12 compilers.
*/

#define UNIX 1
#define SUN 1
#define INTMAIN /* int main() */

#define LoadFunc 1
#define SysOpt   1
#define NoRanlib
#define COpts " -m64 -I/usr/X11R6/include -L/usr/X11R6/lib/64 "

/* CPU architecture */
#define IntBits 32
#define WordBits 64
#define Double
#define StackAlign 16

#define NEED_UTIME
#define Messaging  1
#define PosixFns   1
#define NoVFork
