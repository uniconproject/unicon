/*
 *  file.c
 *
 *  Source file for Device-Independent Bitmap (DIB) API.  Provides
 *  the following functions:
 *
 *  SaveDIB()           - Saves the specified dib in a file
 *  LoadDIB()           - Loads a DIB from a file
 *  DestroyDIB()        - Deletes DIB when finished using it
 *
 * Development Team: Mark Bader
 *                   Patrick Schreiber
 *                   Garrett McAuliffe
 *                   Eric Flo
 *                   Tony Claflin
 *
 * Written by Microsoft Product Support Services, Developer Support.
 * Copyright (c) 1991 Microsoft Corporation. All rights reserved.
 */
#include <windows.h>
#include <string.h>
#include <stdio.h>
#include <math.h>
#include <io.h>
#include <direct.h>
#include <stdlib.h>
#include <fcntl.h>
#include "errors.h"
#include "dibutil.h"
#include "dibapi.h"

/*
 * Dib Header Marker - used in writing DIBs to files
 */
#define DIB_HEADER_MARKER   ((WORD) ('M' << 8) | 'B')


/*********************************************************************
 *
 * Local Function Prototypes
 *
 *********************************************************************/


HANDLE ReadDIBFile(int);
BOOL MyRead(int, LPSTR, DWORD);
BOOL SaveDIBFile(void);
BOOL WriteDIB(LPSTR, HANDLE);
DWORD PASCAL MyWrite(int, VOID FAR *, DWORD);

/*************************************************************************
 *
 * LoadDIB()
 *
 * Loads the specified DIB from a file, allocates memory for it,
 * and reads the disk file into the memory.
 *
 * Parameters:
 *
 * LPSTR lpFileName - specifies the file to load a DIB from
 *
 * Returns: A handle to a DIB, or NULL if unsuccessful.
 *
 *************************************************************************/
int theBits;


HDIB LoadDIB(LPSTR lpFileName)
{
   HDIB hDIB;
   int hFile;
   OFSTRUCT ofs;

   /*
    * Set the cursor to a hourglass, in case the loading operation
    * takes more than a sec, the user will know what's going on.
    */

   SetCursor(LoadCursor(NULL, IDC_WAIT));
#if MSNT
   if ((hFile = open(lpFileName, _O_RDONLY)) != -1) {
     theBits = filelength(hFile);
     close(hFile);
   }
#endif

   if ((hFile = OpenFile(lpFileName, &ofs, OF_READ)) != -1)
   {
      hDIB = ReadDIBFile(hFile);
      _lclose(hFile);
      SetCursor(LoadCursor(NULL, IDC_ARROW));
      return hDIB;
   }
   else
   {
      DIBError(ERR_FILENOTFOUND);
      SetCursor(LoadCursor(NULL, IDC_ARROW));
      return NULL;
   }
}


/*************************************************************************
 *
 * SaveDIB()
 *
 * Saves the specified DIB into the specified file name on disk.  No
 * error checking is done, so if the file already exists, it will be
 * written over.
 *
 * Parameters:
 *
 * HDIB hDib - Handle to the dib to save
 *
 * LPSTR lpFileName - pointer to full pathname to save DIB under
 *
 * Return value: 0 if successful, or one of:
 *        ERR_INVALIDHANDLE
 *        ERR_OPEN
 *        ERR_LOCK
 *
 *************************************************************************/


WORD SaveDIB(HDIB hDib, LPSTR lpFileName)
{
   BITMAPFILEHEADER bmfHdr; // Header for Bitmap file
   LPBITMAPINFOHEADER lpBI;   // Pointer to DIB info structure
   int fh;     // file handle for opened file
   OFSTRUCT of;     // OpenFile structure

   if (!hDib)
      return ERR_INVALIDHANDLE;
   fh = OpenFile(lpFileName, &of, OF_CREATE | OF_READWRITE);
   if (fh == -1)
      return ERR_OPEN;

   /*
    * Get a pointer to the DIB memory, the first of which contains
    * a BITMAPINFO structure
    */
   lpBI = (LPBITMAPINFOHEADER)GlobalLock(hDib);
   if (!lpBI)
      return ERR_LOCK;

   /*
    * Fill in the fields of the file header
    */

   /* Fill in file type (first 2 bytes must be "BM" for a bitmap) */
   bmfHdr.bfType = DIB_HEADER_MARKER;  // "BM"

   /* Size is size of packed dib in memory plus size of file header */
   bmfHdr.bfSize = GlobalSize(hDib) + sizeof(BITMAPFILEHEADER);
   bmfHdr.bfReserved1 = 0;
   bmfHdr.bfReserved2 = 0;

   /*
    * Now, calculate the offset the actual bitmap bits will be in
    * the file -- It's the Bitmap file header plus the DIB header,
    * plus the size of the color table.
    */
   bmfHdr.bfOffBits = (DWORD)sizeof(BITMAPFILEHEADER) + lpBI->biSize +
                      PaletteSize((LPSTR)lpBI);

   /* Write the file header */
   _lwrite(fh, (LPSTR)&bmfHdr, sizeof(BITMAPFILEHEADER));

   /*
    * Write the DIB header and the bits -- use local version of
    * MyWrite, so we can write more than 32767 bytes of data
    */
   MyWrite(fh, (LPSTR)lpBI, GlobalSize(hDib));
   GlobalUnlock(hDib);
   _lclose(fh);
   return 0; // Success code
}


/*************************************************************************
 *
 * DestroyDIB ()
 *
 * Purpose:  Frees memory associated with a DIB
 *
 * Returns:  Nothing
 *
 *************************************************************************/


WORD DestroyDIB(HDIB hDib)
{
   GlobalFree(hDib);
   return 0;
}


//************************************************************************
//
// Auxiliary Functions which the above procedures use
//
//************************************************************************


/*************************************************************************

  Function:  ReadDIBFile (int)

   Purpose:  Reads in the specified DIB file into a global chunk of
             memory.

   Returns:  A handle to a dib (hDIB) if successful.
             NULL if an error occurs.

  Comments:  BITMAPFILEHEADER is stripped off of the DIB.  Everything
             from the end of the BITMAPFILEHEADER structure on is
             returned in the global memory handle.

*************************************************************************/


HANDLE ReadDIBFile(int hFile)
{
   BITMAPFILEHEADER bmfHeader;
   DWORD dwBitsSize;
   HANDLE hDIB;
   LPSTR pDIB;

   /*
    * get length of DIB in bytes for use when reading
    */

#ifdef MSNT
   dwBitsSize = theBits;
#else
   dwBitsSize = filelength(hFile);
#endif

   /*
    * Go read the DIB file header and check if it's valid.
    */
   if ((_lread(hFile, (LPSTR)&bmfHeader, sizeof(bmfHeader)) != sizeof(
       bmfHeader))) {
       return NULL;
      }
   if (bmfHeader.bfType != DIB_HEADER_MARKER)
   {
      return NULL;
   }
   /*
    * Allocate memory for DIB
    */
   hDIB = GlobalAlloc(GMEM_MOVEABLE | GMEM_ZEROINIT, dwBitsSize);
   if (hDIB == 0)
   {
      return NULL;
   }
   pDIB = GlobalLock(hDIB);

   /*
    * Go read the bits.
    */
   if (!MyRead(hFile, pDIB, dwBitsSize - sizeof(BITMAPFILEHEADER)))
   {
      GlobalUnlock(hDIB);
      GlobalFree(hDIB);
      return NULL;
   }
   GlobalUnlock(hDIB);
   return hDIB;
}

/*************************************************************************

  Function:  MyRead (int, LPSTR, DWORD)

   Purpose:  Routine to read files greater than 64K in size.

   Returns:  TRUE if successful.
             FALSE if an error occurs.

  Comments:

*************************************************************************/


BOOL MyRead(int hFile, LPSTR lpBuffer, DWORD dwSize)
{
#ifdef MSNT
   char *lpInBuf = (char *)lpBuffer;
#else
   char huge *lpInBuf = (char huge *)lpBuffer;
#endif
   int nBytes;

   /*
    * Read in the data in 32767 byte chunks (or a smaller amount if it's
    * the last chunk of data read)
    */

   while (dwSize)
   {
      nBytes = (int)(dwSize > (DWORD)32767 ? 32767 : LOWORD (dwSize));
      if (_lread(hFile, (LPSTR)lpInBuf, nBytes) != (WORD)nBytes)
         return FALSE;
      dwSize -= nBytes;
      lpInBuf += nBytes;
   }
   return TRUE;
}


/****************************************************************************

 FUNCTION   : MyWrite(int fh, VOID FAR *pv, DWORD ul)

 PURPOSE    : Writes data in steps of 32k till all the data is written.
              Normal _lwrite uses a WORD as 3rd parameter, so it is
              limited to 32767 bytes, but this procedure is not.

 RETURNS    : 0 - If write did not proceed correctly.
              number of bytes written otherwise.

 ****************************************************************************/


DWORD PASCAL MyWrite(int iFileHandle, VOID FAR *lpBuffer, DWORD dwBytes)
{
   DWORD dwBytesTmp = dwBytes;       // Save # of bytes for return value
#ifdef MSNT
   BYTE *hpBuffer = lpBuffer;   // make a huge pointer to the data
#else
   BYTE huge *hpBuffer = lpBuffer;   // make a huge pointer to the data
#endif

   /*
    * Write out the data in 32767 byte chunks.
    */

   while (dwBytes > 32767)
   {
      if (_lwrite(iFileHandle, (LPSTR)hpBuffer, (WORD)32767) != 32767)
         return 0;
      dwBytes -= 32767;
      hpBuffer += 32767;
   }

   /* Write out the last chunk (which is < 32767 bytes) */
   if (_lwrite(iFileHandle, (LPSTR)hpBuffer, (WORD)dwBytes) != (WORD)dwBytes)
      return 0;
   return dwBytesTmp;
}
