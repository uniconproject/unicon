/*
 * dialogs.c
 *
 * Contains all the dialog procedures for WinCap Windows Screen Capture
 * Program, as well as a few useful miscellaneous functions.
 *
 * Dialog Functions:
 *
 * AboutDlgProc()         // About Box
 * OptionsDlgProc()       // Options Dialog
 * InfoBoxDlgProc()       // InfoBox, which displays as the program first
 *                        // starts up
 * SavingDlgProc()        // Dialog which displays "Saving to file..."
 * HelpDlgProc()          // Help Dialog
 *
 * Other Functions:
 *
 * StretchIconToWindow()  // Stretches Specified icon to fill up entire window.
 *                        // This function is used in the "About" Box
 * cwCenter()             // Centers a window on the display
 * DrawIndent()           // Draws 3-D shadows for controls in dialog boxes
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
#include <stdlib.h>
#include "WINCAP.h"
#include "DIALOGS.h"
#include "dibapi.h"

// VERSION is used in About dialog box
#define VERSION "Version 3.00"

/* Global variables which are set in main program */
extern char szAppName[20];  /* Name of app */
extern HWND ghInst;         /* Handle to instance */
extern HWND ghWndMain;      /* Handle to main window */

/***********************************************************************
 *
 *"About" Dialog Box Window Procedure
 *
 * Notable features:  This dialog box draws the application's icon
 * in the dialog box itself. The icon is actually stretched larger to
 * fit in the specified area, which must be done manually.
 * See WM_PAINT case.
 *
 ************************************************************************/


BOOL FAR PASCAL AboutDlgProc(HWND hWndDlg, WORD Message, WORD wParam, LONG
                             lParam)
{
   switch (Message)
      {
   case WM_INITDIALOG:
      cwCenter(hWndDlg, 0);       // Center the dialog on the screen

      // Set the version number (makes it easy to change)
      SendDlgItemMessage(hWndDlg, IDC_VERSION, WM_SETTEXT, 0, (LONG)(LPSTR)
                         VERSION);

      // Set focus on the OK button.  Since we set focus, return FALSE
      SetFocus(GetDlgItem(hWndDlg, IDOK));
      return FALSE;

   case WM_CLOSE:
      /* Closing the Dialog behaves the same as Cancel               */
      PostMessage(hWndDlg, WM_COMMAND, IDCANCEL, 0L);
      break;

   case WM_COMMAND:
      switch (wParam)
         {
      case IDC_HELP:
      {
         FARPROC lpfnDIALOGSMsgProc;

         lpfnDIALOGSMsgProc = MakeProcInstance((FARPROC)HelpDlgProc, ghInst);
         DialogBox(ghInst, (LPSTR)"Help", hWndDlg, lpfnDIALOGSMsgProc);
         FreeProcInstance(lpfnDIALOGSMsgProc);
      }
         break;

      case IDOK:
      case IDCANCEL:
         EndDialog(hWndDlg, FALSE);
         break;
         }
      break;    /* End of WM_COMMAND                                 */

   case WM_PAINT:
   // This procedure must process paint messages. However, Windows
   // must do standard painting *first*. Otherwise, it would be
   // necessary to do standard painting manually or the application's
   // painting would be overwritten. To implement this, post an
   // application defined message and return FALSE to allow Windows
   // to paint the dialog.
      PostMessage(hWndDlg, WM_REPAINT, 0, 0L);
      return FALSE;

   case WM_REPAINT:
   // This is the message posted in the WM_PAINT case above. At this
   // point, standard dialog box painting is complete and the
   // application can perform its custom painting.
   // Call function which stretches icon to fit in window.  The window
   // we want to use is the control specified by IDC_ICONAREA.  The icon
   // to use is "WINCAP", which is one of the app's resources.  Also,
   // draw the cool 3-D effects around the IDC_ICONAREA control.
      StretchIconToWindow(GetDlgItem(hWndDlg, IDC_ICONAREA), "WINCAP");
      DrawIndent(hWndDlg, IDC_ICONAREA, 2); // 2 -- special flag
      break;

   default:
      return FALSE;
      }
   return TRUE;
} /* End of DIALOGSMsgProc                                      */


/************************************************************************
 *
 * "Options" Dialog Box Window Procedure
 *
 * This procedure takes care of the processing for the "Options" dialog
 * box, where the user selects which portion of the screen to capture.
 *
 * Notable features: This dialog box is "expanding" -- meaning that
 * the user sees it as a certain size, and can press the "Options>>" key
 * which causes the dialog box to get larger.
 *
 * Also, this Dialog Box Procedure is called using DialogBoxParam.  This
 * allows us to pass a parameter into the dialog box procedure -- the
 * parameter that gets passed in here is a handle to a structure holding
 * all the options that the user specified in this dialog box.  This
 * allows passing the options back to the main program WITHOUT using
 * global variables.
 *
 ************************************************************************/


BOOL FAR PASCAL OptionsDlgProc(HWND hWndDlg, WORD Message, WORD wParam, LONG
                               lParam)
{
   static int iWidth, iHeight;     // Original Height & Width of Dialog -- used
   // when growing dialog back to original size
   static BOOL bIsLarge = TRUE;    // True if Dialog is full-size
   static WORD wChecked;           // Button checked under "Single Window"
   static HANDLE hOptionStruct;    // Handle to OPTIONSTRUCT, used to return data

   switch (Message)
      {
   case WM_INITDIALOG:
   {
      RECT rDialog;                   // Used to calculate dialog box shrinking
      int iShrinkAmount;              // amount to shrink dialog box by
      LPOPTIONSTRUCT lpOptionStruct;  // Pointer to options
      char buffer[30];                // used in itoa conversion
      RECT rDividingLine;             // Location of Dividing Line, which is
                                      // used to shrink dialog box

      // Because DialogBoxParam() was used to invoke this dialog box,
      // lParam contains a handle to the OPTIONSTRUCT, which contains the
      // defualt values. Place user input in this structure before returning.

      hOptionStruct = (HANDLE)LOWORD(lParam);
      cwCenter(hWndDlg, 0);                   // Center dialog on screen

      /*
       * Shrink the window so the options do not appear - to do this,
       * just call MoveWindow() with a smaller height.
       */
      GetWindowRect(hWndDlg, &rDialog);        // Get window rect in screen coords
      iWidth = rDialog.right - rDialog.left;  // Calculate original Width & Height
      iHeight = rDialog.bottom - rDialog.top;

      // Find position of IDC_DIVIDINGLINE in dialog, and shrink up to
      // this control.  The reason we do this instead of making the iShrinkAmount
      // a hard-coded value is that the dialog box may be different sizes
      // depending on the display driver.
      GetWindowRect(GetDlgItem(hWndDlg, IDC_DIVIDINGLINE), &rDividingLine);
      iShrinkAmount = rDialog.bottom - rDividingLine.bottom;

      // Shrink dialog box - last parameter is TRUE so dialog is redrawn
      MoveWindow(hWndDlg, rDialog.left, rDialog.top, iWidth, iHeight -
                 iShrinkAmount, TRUE);
      bIsLarge = FALSE;                       // We aren't large any more

      /****************************************************************
       * Use the default options contained in the OPTIONSTRUCT to check
       * and enable the corresponding windows, check boxes and buttons
       ****************************************************************/
      lpOptionStruct = (LPOPTIONSTRUCT)GlobalLock(hOptionStruct);
      if (lpOptionStruct)
      {
      // Send messages which set the correct options from
      // the default options listed in the lpOptionStruct.
         SendMessage(hWndDlg, WM_COMMAND, lpOptionStruct->iOptionWindow, 0L);
         SendMessage(hWndDlg, WM_COMMAND, lpOptionStruct->iOptionArea, 0L);
         wChecked = lpOptionStruct->iOptionWindow;
         SendMessage(hWndDlg, WM_COMMAND, lpOptionStruct->iOptionPrint, 0L);
         if (IsDlgButtonChecked(hWndDlg, IDC_SCALE))
         {
            SetDlgItemText(hWndDlg, IDC_XAXIS, (LPSTR)itoa(lpOptionStruct->
                           iXScale, buffer, 10));
            SetDlgItemText(hWndDlg, IDC_YAXIS, (LPSTR)itoa(lpOptionStruct->
                           iYScale, buffer, 10));
         }

         // Set the text into the filename edit control
         SetDlgItemText(hWndDlg, IDC_FILETEXT, (LPSTR)lpOptionStruct->
                        szFileName);

         // Check/Uncheck and disable/enable the File and Printer
         // check boxes
         CheckDlgButton(hWndDlg, IDC_FILE, (lpOptionStruct->iOptionDest) &
                        OPTION_FILE);
         EnableWindow(GetDlgItem(hWndDlg, IDC_FILETEXT), (lpOptionStruct->
                      iOptionDest) & OPTION_FILE);
         CheckDlgButton(hWndDlg, IDC_PRINTER, (lpOptionStruct->iOptionDest) &
                        OPTION_PRINTER);
         EnableWindow(GetDlgItem(hWndDlg, IDC_OPTIONSBUTTON), (lpOptionStruct
                      ->iOptionDest) & OPTION_PRINTER);
         GlobalUnlock(hOptionStruct);
      }
   }
      break; /* End of WM_INITDIALOG                                 */

   case WM_CLOSE:
      /* Closing the Dialog should behave the same as Cancel          */
      PostMessage(hWndDlg, WM_COMMAND, IDCANCEL, 0L);
      break;

   case WM_COMMAND:
      switch (wParam)
         {
      // If user checks any of the buttons in a group, make sure
      // that the other buttons in the group get unchecked
      case IDC_SINGLEWINDOW: /* Radiobutton text: "Single Window"    */
         CheckRadioButton(hWndDlg, IDC_SINGLEWINDOW, IDC_PARTIALSCREEN,
                          IDC_SINGLEWINDOW);

      // Enable the options which are applicable to this case --
      // the IDC_ENTIRESCREEN and the IDC_PARTIALSCREEN options
      // might have these disabled...
         EnableWindow(GetDlgItem(hWndDlg, IDC_ENTIREWINDOW), TRUE);
         EnableWindow(GetDlgItem(hWndDlg, IDC_CLIENTAREAONLY), TRUE);
         CheckRadioButton(hWndDlg, IDC_ENTIREWINDOW, IDC_CLIENTAREAONLY,
                          wChecked);
         break;

      case IDC_ENTIRESCREEN: /* Radiobutton text: "Entire Screen"    */
      case IDC_PARTIALSCREEN: /* Radiobutton text: "Rubber Band Portion"*/
         CheckRadioButton(hWndDlg, IDC_SINGLEWINDOW, IDC_PARTIALSCREEN, wParam
                          );

      // Now, disable the options that are only applicable to
      // the IDC_SINGLEWINDOW case
         EnableWindow(GetDlgItem(hWndDlg, IDC_ENTIREWINDOW), FALSE);
         EnableWindow(GetDlgItem(hWndDlg, IDC_CLIENTAREAONLY), FALSE);
         CheckDlgButton(hWndDlg, IDC_ENTIREWINDOW, FALSE);
         CheckDlgButton(hWndDlg, IDC_CLIENTAREAONLY, FALSE);
         break;

      case IDC_ENTIREWINDOW: /* Radiobutton text: "Entire Window"    */
      case IDC_CLIENTAREAONLY: /* Radiobutton text: "Client Area Only"*/
         CheckRadioButton(hWndDlg, IDC_ENTIREWINDOW, IDC_CLIENTAREAONLY,
                          wParam);
         wChecked = wParam;
         break;

      case IDC_BESTFIT:
      case IDC_STRETCHTOPAGE:
      case IDC_SCALE:
         // Check the correct button
         CheckRadioButton(hWndDlg, IDC_BESTFIT, IDC_SCALE, wParam);

         // And enable or disable the options under "Scale",
         // depending on whether or not the IDC_SCALE button is checked
         EnableWindow(GetDlgItem(hWndDlg, IDC_XAXIS), (BOOL)(wParam ==
                      IDC_SCALE));
         EnableWindow(GetDlgItem(hWndDlg, IDC_YAXIS), (BOOL)(wParam ==
                      IDC_SCALE));
         EnableWindow(GetDlgItem(hWndDlg, IDC_XTEXT), (BOOL)(wParam ==
                      IDC_SCALE));
         EnableWindow(GetDlgItem(hWndDlg, IDC_YTEXT), (BOOL)(wParam ==
                      IDC_SCALE));
         break;

      case IDC_FILE:      /* Check box "Save To File" */
         // Determine if the File Text edit control should be enabled or not
         EnableWindow(GetDlgItem(hWndDlg, IDC_FILETEXT), IsDlgButtonChecked(
                      hWndDlg, IDC_FILE));
         break;

      case IDC_PRINTER:   /* Check box "Send to Printer" */
      // Determine if the 'Options>>' button should be enabled --
      // enable it if the "Printer" checkbox is checked AND
      // dialog box has not been grown
         EnableWindow(GetDlgItem(hWndDlg, IDC_OPTIONSBUTTON), (
                      IsDlgButtonChecked(hWndDlg, IDC_PRINTER) && !bIsLarge));
         break;

      case IDOK:  /* button "OK" */
      {
         LPOPTIONSTRUCT lpOptionStruct;
         int iDest;
         char szTmp[100];

         // Save the user's selection into the OPTIONSTRUCT

         if (!hOptionStruct)
         {
            EndDialog(hWndDlg, FALSE);
            break;
         }
         lpOptionStruct = (LPOPTIONSTRUCT)GlobalLock(hOptionStruct);
         if (!lpOptionStruct)
         {
            EndDialog(hWndDlg, FALSE);
            break;
         }
         if (IsDlgButtonChecked(hWndDlg, IDC_SINGLEWINDOW))
            lpOptionStruct->iOptionArea = IDC_SINGLEWINDOW;
         if (IsDlgButtonChecked(hWndDlg, IDC_ENTIRESCREEN))
            lpOptionStruct->iOptionArea = IDC_ENTIRESCREEN;
         if (IsDlgButtonChecked(hWndDlg, IDC_PARTIALSCREEN))
            lpOptionStruct->iOptionArea = IDC_PARTIALSCREEN;
         if (IsDlgButtonChecked(hWndDlg, IDC_ENTIREWINDOW))
            lpOptionStruct->iOptionWindow = IDC_ENTIREWINDOW;
         if (IsDlgButtonChecked(hWndDlg, IDC_CLIENTAREAONLY))
            lpOptionStruct->iOptionWindow = IDC_CLIENTAREAONLY;
         if (IsDlgButtonChecked(hWndDlg, IDC_BESTFIT))
            lpOptionStruct->iOptionPrint = IDC_BESTFIT;
         if (IsDlgButtonChecked(hWndDlg, IDC_STRETCHTOPAGE))
            lpOptionStruct->iOptionPrint = IDC_STRETCHTOPAGE;
         if (IsDlgButtonChecked(hWndDlg, IDC_SCALE))
            lpOptionStruct->iOptionPrint = IDC_SCALE;
         GetDlgItemText(hWndDlg, IDC_FILETEXT, (LPSTR)lpOptionStruct->
                        szFileName, 100);
         iDest = 0;
         if (IsDlgButtonChecked(hWndDlg, IDC_FILE))
            iDest |= OPTION_FILE;
         if (IsDlgButtonChecked(hWndDlg, IDC_PRINTER))
            iDest |= OPTION_PRINTER;
         lpOptionStruct->iOptionDest = iDest;
         if (GetDlgItemText(hWndDlg, IDC_XAXIS, (LPSTR)szTmp, 100))
            lpOptionStruct->iXScale = atoi(szTmp);
         if (GetDlgItemText(hWndDlg, IDC_YAXIS, (LPSTR)szTmp, 100))
            lpOptionStruct->iYScale = atoi(szTmp);
         GlobalUnlock(hOptionStruct);
         EndDialog(hWndDlg, TRUE);
      }
         break;

      case IDCANCEL:
      /* Ignore data values entered into the controls        */
      /* and dismiss the dialog window returning FALSE       */
         EndDialog(hWndDlg, FALSE);
         break;

      case IDC_HELP: /* Button text: "Help"                       */
      {
         FARPROC lpfnDIALOGSMsgProc;

         lpfnDIALOGSMsgProc = MakeProcInstance((FARPROC)HelpDlgProc, ghInst);
         DialogBox(ghInst, (LPSTR)"Help", hWndDlg, lpfnDIALOGSMsgProc);
         FreeProcInstance(lpfnDIALOGSMsgProc);
      }
         break;

      case IDC_OPTIONSBUTTON: /* Button text: "Options >>"        */
      // Make the window bigger to expose the hidden portion
      // of the dialog.
         if (!bIsLarge)  // Only do it if we aren't already large
         {
            RECT rDialog;

            GetWindowRect(hWndDlg, &rDialog);    // Get window rect in screen coords

            // Grow the dialog box - iWidth & iHeight are the original
            // height & width of the dialog.
            MoveWindow(hWndDlg, rDialog.left, rDialog.top, iWidth, iHeight,
                       TRUE);
            bIsLarge = TRUE;
         }

         // Disable button
         EnableWindow(GetDlgItem(hWndDlg, IDC_OPTIONSBUTTON), FALSE);
         break;

      case IDC_FOLD: /* Button Text: "<< Fold" */
         // Fold the dialog box into a smaller version
         if (bIsLarge)
         {
            RECT rDialog;
            RECT rDividingLine;
            int iShrinkAmount;

            GetWindowRect(hWndDlg, &rDialog);        // Get window rect in screen coords

            // Find position of IDC_DIVIDINGLINE in dialog, and shrink up to
            // this control.  The reason we do this instead of making the iShrinkAmount
            // a hard-coded value is that our dialog box may be different sizes
            // depending on the display driver.
            GetWindowRect(GetDlgItem(hWndDlg, IDC_DIVIDINGLINE), &
                          rDividingLine);
            iShrinkAmount = rDialog.bottom - rDividingLine.bottom;

            // Shrink dialog box - last parameter is TRUE so dialog is redrawn
            MoveWindow(hWndDlg, rDialog.left, rDialog.top, iWidth, iHeight -
                       iShrinkAmount, TRUE);
            bIsLarge = FALSE;                       // We aren't large any more
         }

         // Enable "Options" button
         EnableWindow(GetDlgItem(hWndDlg, IDC_OPTIONSBUTTON), TRUE);
         break;
         }
      break;    /* End of WM_COMMAND                                 */

   case WM_PAINT:
      PostMessage(hWndDlg, WM_REPAINT, 0, 0L);
      return FALSE;

   case WM_REPAINT:
      DrawIndent(hWndDlg, IDC_BOX1, 1);   // 1 is for groupbox control
      DrawIndent(hWndDlg, IDC_BOX2, 1);
      DrawIndent(hWndDlg, IDC_BOX3, 1);
      DrawIndent(hWndDlg, IDC_BOX4, 1);
      break;

   default:
      return FALSE;
      }
   return TRUE;
} /* End of DIALOGSMsgProc                                      */



/***********************************************************************
 *
 * "Info Box" Dialog Window Procedure
 *
 * This procedure displays the dialog box which appears when the program
 * is first loaded.  It will go away after a few seconds if the user does
 * not hit escape or enter or click on the OK box first.
 *
 * Notable features: our application icon is stretched to fill up one of
 * the controls in this dialog box.
 *
 ************************************************************************/


BOOL FAR PASCAL InfoBoxDlgProc(HWND hWndDlg, WORD Message, WORD wParam, LONG
                               lParam)
{
   static int nTimerID = 22;       // ID for our timer - any number will do
   static int nTimerLength = 5000; // Length of timer in milliseconds

   switch (Message)
      {
   case WM_INITDIALOG:
   {
      cwCenter(hWndDlg, 0);   // Center dialog on screen

      // Set timer.  This will cause a WM_TIMER message to be sent to this
      // dialog procedure in nTimerLength milliseconds.
      SetTimer(hWndDlg, nTimerID, nTimerLength, NULL);
   }
      break; /* End of WM_INITDIALOG                                 */

   case WM_TIMER:
   // We got the timer message, so the time must have expired.  Make the
   // dialog go away by simulating the user pressing the OK button.
      PostMessage(hWndDlg, WM_COMMAND, IDOK, 0L);
      break;

   case WM_CLOSE:
      /* Closing the Dialog behaves the same as Cancel               */
      PostMessage(hWndDlg, WM_COMMAND, IDCANCEL, 0L);
      break; /* End of WM_CLOSE                                      */

   case WM_PAINT:
      // See comments in AboutBoxProc() code above
      PostMessage(hWndDlg, WM_REPAINT, 0, 0L);
      return FALSE;

   case WM_REPAINT:
      // See comments in AboutBoxProc() code above
      StretchIconToWindow(GetDlgItem(hWndDlg, IDC_ICONAREA), "WINCAP");
      DrawIndent(hWndDlg, IDC_ICONAREA, 2); // 2 -- special flag
      break;

   case WM_COMMAND:
      switch (wParam)
         {
      case IDOK:
      case IDCANCEL:
         KillTimer(hWndDlg, nTimerID);    // Stop timer
         EndDialog(hWndDlg, TRUE);
         break;
         }
      break;    /* End of WM_COMMAND                                 */

   default:
      return FALSE;
      }
   return TRUE;
} /* End of DIALOGSMsgProc                                      */


/************************************************************************
 *
 * "Saving file to..." Dialog Box Window Procedure
 *
 * This is a modeless dialog box which is called when we save the bitmap
 * to a file (so the user dosen't think his machine has hung).
 *
 ************************************************************************/


BOOL FAR PASCAL SavingDlgProc(HWND hDlg, WORD message, WORD wParam, LONG
                              lParam)
{
   switch (message)
      {
   case WM_SETFOCUS:
      MessageBeep(0);
      break;

   case WM_INITDIALOG:
      cwCenter(hDlg, 0);  // Center dialog on screen
      SetDlgItemText(hDlg, IDC_FILETEXT, (LPSTR)lParam);
      return TRUE;
      break;

   case WM_DESTROY:
      return TRUE;
      break;

   default:
      return FALSE;
      }
}



/***********************************************************************
 *
 * "Help" Button Dialog Window Procedure
 *
 * This procedure displays the dialog box which appears when the user
 * presses the "Help" button in either the About box, or the Options box.
 *
 ************************************************************************/


BOOL FAR PASCAL HelpDlgProc(HWND hWndDlg, WORD Message, WORD wParam, LONG
                            lParam)
{
   static HFONT hDlgFont1, hDlgFont2;
   static LOGFONT lFont;

   switch (Message)
      {
   case WM_INITDIALOG:
      cwCenter(hWndDlg, 0);   // Center dialog on screen

   // Set font of IDC_TITLE1 to a big Helv.  This procedure is explained
   // in Microsoft KnowledgeBase article "Changing the Font Used by
   // Dialog Controls in Windows"
      lFont.lfHeight = 30;
      lFont.lfWidth = 0;
      lFont.lfEscapement = 0;
      lFont.lfOrientation = 0;
      lFont.lfWeight = 700; // bold font weight
      lFont.lfItalic = 0;
      lFont.lfUnderline = 0;
      lFont.lfStrikeOut = 0;
      lFont.lfCharSet = ANSI_CHARSET;
      lFont.lfOutPrecision = OUT_DEFAULT_PRECIS;
      lFont.lfClipPrecision = CLIP_DEFAULT_PRECIS;
      lFont.lfQuality = PROOF_QUALITY;
      lstrcpy((LPSTR)lFont.lfFaceName, (LPSTR)"");
      lFont.lfPitchAndFamily = VARIABLE_PITCH | FF_SWISS;
      hDlgFont1 = CreateFontIndirect(&lFont);

      // Send WM_SETFONT message to desired control
      SendDlgItemMessage(hWndDlg, IDC_TITLE1, WM_SETFONT, hDlgFont1, (DWORD)
                         TRUE);
      lFont.lfItalic = TRUE;  // Make font italic
      lFont.lfHeight = 20;    // 20 pixels high
      lFont.lfWeight = 400;   // Non-bold
      hDlgFont2 = CreateFontIndirect(&lFont);

      // Send WM_SETFONT message to desired control
      SendDlgItemMessage(hWndDlg, IDC_TITLE2, WM_SETFONT, hDlgFont2, (DWORD)
                         TRUE);
      SetFocus(GetDlgItem(hWndDlg, IDOK));
      return TRUE;
      break;

   case WM_CLOSE:
      /* Closing the Dialog behaves the same as Cancel               */
      PostMessage(hWndDlg, WM_COMMAND, IDCANCEL, 0L);
      break; /* End of WM_CLOSE                                      */

   case WM_PAINT:
      PostMessage(hWndDlg, WM_REPAINT, 0, 0L);
      return FALSE;

   case WM_REPAINT:
      DrawIndent(hWndDlg, IDC_BOX1, 1);
      break;

   case WM_COMMAND:
      switch (wParam)
         {
      case IDOK:

      case IDCANCEL:
         DeleteObject(hDlgFont1);
         DeleteObject(hDlgFont2);
         EndDialog(hWndDlg, TRUE);
         break;
         }
      break;    /* End of WM_COMMAND                                 */

   default:
      return FALSE;
      }
   return TRUE;
} /* End of DIALOGSMsgProc                                      */



/************************************************************************
 *
 * StretchIconToWindow()
 *
 * Draws the specified icon on the specified window, filling up the entire
 * window's client area.  The icon must be one of the application's
 * resources.
 *
 ************************************************************************/


void StretchIconToWindow(HWND hWndDlg,      // window to paint to 
                         LPSTR szIconName)  // name of ICON RESOURCE (not icon file!)
{
   HDC hDC, hMemDC;        // hDC is DC to window, hMemDC is DC to draw icon on
   HICON hIcon;            // Handle to the loaded icon
   RECT rRect;             // RECT of the window's client area coordinates
   HBITMAP hBitmap,        // Handle to bitmap for hMemDC
           hOldBitmap;     // Old Bitmap in hMemDC
   BOOL bReturn;           // To Check return value from StretchBlt
   HBRUSH hOldBrush;       // Handle to old brush in hMemDC
   HBRUSH hBkgdBrush;      // Brush to paint background

   hDC = GetDC(hWndDlg);     // Get DC to window
   GetClientRect(hWndDlg, (LPRECT)&rRect); // Get size

   // Load the icon
   hIcon = LoadIcon(ghInst, szIconName);
   if (!hIcon)
      return;

   // To stretch the icon to the size of the Window specified, we do this:
   // 1. Create a Memory DC (compatible with the window we are drawing to)
   // 2. Create a compatible bitmap and select it into the Memory DC
   // 3. Draw our icon on the Memory DC
   // 4. StretchBlt it into our destination window
   hMemDC = CreateCompatibleDC(hDC);
   hBitmap = CreateCompatibleBitmap(hDC, 64, 64);  // make it big enough to hold icon

   // Select the new bitmap into the DC, then paint the background gray.  This
   // is done so that any transparent part of the icon will show through as
   // gray.
   hOldBitmap = SelectObject(hMemDC, hBitmap);
   hBkgdBrush = CreateSolidBrush(RGB(255,255,255));
   hOldBrush = SelectObject(hMemDC, hBkgdBrush);

   // Draw rectangle with offset of (-1,-1) for upper left corner - this is
   // to make sure we cover the entire client area of the window
   Rectangle(hMemDC, rRect.left - 1, rRect.top - 1, rRect.right, rRect.bottom)
   ;

   //Draw the icon on the memory DC
   DrawIcon(hMemDC, 0, 0, hIcon);

   // StretchBlt the icon to fill up the complete destination window.  Note
   // that this is hard-coded for 32x32 icons, which is valid for EGA,VGA and
   // 8514 resolutions for Windows 3.0.
   bReturn = StretchBlt(hDC, rRect.left, rRect.top, rRect.right, rRect.bottom,
                        hMemDC, 0, 0, 32, 32, SRCCOPY);

   // Clean up
   SelectObject(hMemDC, hOldBitmap);
   SelectObject(hMemDC, hOldBrush);
   DeleteObject(hBitmap);
   DeleteObject(hBkgdBrush);
   DeleteDC(hMemDC);

   // Validate rect of the client our WM_PAINT case dosen't try to paint over it
   ValidateRect(hWndDlg, &rRect);
   ReleaseDC(hWndDlg, hDC);
}


/************************************************************************
 * cwCenter()
 *
 * Centers a window in the center of the screen.  To do this, we find the
 * dimensions of the screen, the dimensions of the window, and do some
 * calculations to center it on the screen, then call MoveWindow() on the
 * window.
 *
 *
 ************************************************************************/


void cwCenter(HWND hWnd,        // Handle to the window to be centered
              int top)          // adjust vertical position either up (positive
                                // values) or down (negative values)
{
   POINT pt;
   RECT rDialog;      // Rect of dialog
   int iDlgWidth;     // width of dialog box
   int iDlgHeight;    // height of dialog box
   HDC hDC;           // hDC to entire screen

   /* Figure out how big screen is, then calculate center point of screen */

   hDC = CreateDC("DISPLAY", NULL, NULL, NULL);
   pt.x = (GetDeviceCaps(hDC, HORZRES) / 2);
   pt.y = (GetDeviceCaps(hDC, VERTRES) / 2);
   DeleteDC(hDC);

   /* Get rect of the dialog box, and calculate the height and width  */
   GetWindowRect(hWnd, &rDialog);
   iDlgHeight = rDialog.bottom - rDialog.top;
   iDlgWidth = rDialog.right - rDialog.left;

   /* calculate the new x, y starting point                               */
   pt.x = pt.x - iDlgWidth / 2;
   pt.y = pt.y - iDlgHeight / 2;

   /* top will adjust the window position, up or down                     */
   if (top)
      pt.y = pt.y + top;

   /* move the window                                                     */
   MoveWindow(hWnd, pt.x, pt.y, iDlgWidth, iDlgHeight, FALSE);
}

/************************************************************************
 * DrawIndent()
 *
 * Draws a 3-D "Indent", or shadow for the specified control within
 * a dialog box.  This routine also takes a third parameter, which can be set
 * to 1 for a groupbox control, and 2 for a frame control.  Specifying a 2
 * causes this procedure to draw a rectangle around the window also.
 *
 * This code is based on the Microsoft KnowledgeBase article
 * "How to Give a 3_d Effect to Windows Controls"
 *
 ************************************************************************/


void DrawIndent(HWND hDlg, int ID, int iType)

// Assumptions:
//
// hDlg        is a valid window handle.
// ID          is a valid control ID.
// iType       is 1 or 2.  2 will draw a rectangle around the control
{
   RECT rRect;   // RECT which contains control window's coordinates (in client coords)
   HDC hDC;     // HDC to control's window
   HPEN hOldPen; // save old pen so we can select it back in
   HPEN hPenSmall;   // Pen for outlining
   HPEN hPenShadow;  // Pen for shadowing
   HBRUSH hBrushOld; // Save it so we can restore it

   // Find out how big the control's window is

   GetClientRect(GetDlgItem(hDlg, ID), (LPRECT)&rRect);
   hDC = GetDC(GetDlgItem(hDlg, ID));

   // Create the pens which will draw the shadows (and borders)
   hPenSmall = CreatePen(PS_SOLID, 1, RGB(0,0,0));         // Black, 1 pixel wide
   hPenShadow = CreatePen(PS_SOLID, 4, RGB(160,160,160));  // Grayish, 4 pixels wide
   hOldPen = SelectObject(hDC, hPenShadow);

   // Draw the Shadow
   MoveTo(hDC, rRect.right + 2, rRect.top + 13);
   LineTo(hDC, rRect.right + 2, rRect.bottom + 2);
   LineTo(hDC, rRect.left + 6, rRect.bottom + 2);

   // If iType is 2, draw the border around the window (with small pen) also
   if (iType == 2)
   {
      SelectObject(hDC, hPenSmall);
      hBrushOld = SelectObject(hDC, GetStockObject(NULL_BRUSH));
      Rectangle(hDC, rRect.left, rRect.top, rRect.right, rRect.bottom);
      SelectObject(hDC, hBrushOld);
   }

   // Housekeep
   SelectObject(hDC, hOldPen);
   DeleteObject(hPenShadow);
   DeleteObject(hPenSmall);
   ReleaseDC(GetDlgItem(hDlg, ID), hDC);
}
