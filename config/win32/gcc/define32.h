/*
 * This header lists optional symbols for 32-bit builds.
 *
 * The rule of thumb we aim for is: it includes everything that comes with
 * mingw out of the box. This includes pthreads, apparently, and 2D and 3D
 * (OpenGL) headers, but not png, libz, or jpeg.
 *
 * In order to obtain png, libz, or jpeg libraries and headers for Mingw:
 *
 * ... fill in missing information here ...
 */


/*define for png image support, libz is required by PNG */
/* #define HAVE_LIBPNG 1 */
/* #define HAVE_LIBZ 1   */ /* DO NOT define if you are using zlib1.dll */

/*define for jpeg image support */
/* #define HAVE_LIBJPEG 1 */

/*define if you have pthreads and want concurrency*/
#define HAVE_LIBPTHREAD 1
#define Concurrent 1
#define NoKeyword__Thread 1

/*#define HAVE_STRUCT_TIMESPEC 1*/
