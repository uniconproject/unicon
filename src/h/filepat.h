#ifndef FILEPAT_H
#define FILEPAT_H
/*
 * Typedefs and macros for filename wildcard expansion on some systems.
 *  The definitions provided here are:
 *
 *    typedef ... FINDFILE_T;
 *    // Current state of the filename wildcard expansion
 *
 *    int FINDFIRST ( char *pattern, FINDFILE_T *pfd );
 *    // Initializes *pfd and returns 1 if a file is found that matches the
 *    // pattern, 0 otherwise
 *
 *    int FINDNEXT ( FINDFILE_T *pfd );
 *    // Assuming that the last FINDFIRST/FINDNEXT call was successful,
 *    // updates *pfd and returns whether another match can be made.
 *
 *    char *FILENAME ( FINDFILE_T *pfd );
 *    // Assuming that the last FINDFIRST/FINDNEXT call was successful,
 *    // returns pointer to last found file name.
 *
 *    void FINDCLOSE ( FINDFILE_T *pfd );
 *    // Does any cleanup required after doing filenaame wildcard expansion.
 *
 * Also, the macro WildCards will be defined to be 1 if there is file
 * pattern matching is supported, 0 otherwise.  If !WildCards, then a
 * default set of typedef/macros will be provided that will return only one
 * match, the original pattern.
 */


#if WildCards

#if NT

#include <io.h>

typedef struct _FINDFILE_TAG {
   intptr_t             handle;
   struct _finddata_t   fileinfo;
   } FINDDATA_T;

#define FINDFIRST(pattern, pfd) \
   ( ( (pfd)->handle = _findfirst ( (pattern), &(pfd)->fileinfo ) ) != -1L )
#define FINDNEXT(pfd) ( _findnext ( (pfd)->handle, &(pfd)->fileinfo ) != -1 )
#define FILENAME(pfd)   ( (pfd)->fileinfo.name )
#define FINDCLOSE(pfd)  _findclose( (pfd)->handle )

#endif                                  /* NT */

#if MICROSOFT

#include <dos.h>

typedef struct _find_t FINDDATA_T;

#define FINDFIRST(pattern, pfd) (!_dos_findfirst ((pattern), _A_NORMAL, (pfd)))
#define FINDNEXT(pfd)   ( !_dos_findnext ( (pfd) ) )
#define FILENAME(pfd)   ( (pfd)->name )
#define FINDCLOSE(pfd)  ( (void) 0 )

#endif                                  /* MICROSOFT */

#if PORT
Deliberate Syntax Error                 /* Give it some thought */
#endif                                  /* PORT */
#else                                   /* WildCards */
typedef struct _NotWild { char *name; } FINDDATA_T;
#define FINDFIRST(pattern, pfd) ((pfd)->name = (pattern))
#define FINDNEXT(pfd)   ( 0 )
#define FILENAME(pfd)   ( (pfd)->name )
#define FINDCLOSE(pfd)  ( (void) 0 )

#endif                                  /* WildCards */
#endif
