/*
 * Wincap.c
 *
 * Windows Screen Capture Utility
 * Version 3.00
 *
 * Description:
 * ------------
 *
 * Captures portions of the screen, specific windows, or the entire screen
 * and saves it to a file or prints it.  Uses DIBAPI functions to do most
 * of the capture/printing/saving work.  See the file DIBAPI.TXT for a
 * description of the DIB api functions.
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
#include "wincap.h"
#include "dialogs.h"
#include "dibapi.h"
#include "errors.h"

char szAppName[20];     // Name of application - used in dialog boxes

/* Global variables */
HWND ghInst;            /* Handle to instance */
HWND ghWndMain;         /* Handle to main window */
FARPROC lpfnKeyHook;    // Used in keyboard hook
FARPROC lpfnOldHook;    // Used for keyboard hook
HWND hModelessDlg;      // Handle to modeless dialog box

/* Macro to swap two values */
#define SWAP(x,y)   ((x)^=(y)^=(x)^=(y))


/**************************************************************************
 *
 * WinMain()
 *
 * Entry point of our Application.
 *
 *************************************************************************/


int PASCAL WinMain(HANDLE hInstance, HANDLE hPrevInstance, LPSTR lpszCmdLine,
                   int nCmdShow)
{
   MSG msg;
   WNDCLASS wndclass;
   HWND hWnd;

   strcpy(szAppName, "WinCap");     // Name of our App
   hModelessDlg = NULL;             // Set handle to modeless dialog to NULL because
                                    // we haven't created it yet
   if (!hPrevInstance)
   {
      wndclass.style = 0;
      wndclass.lpfnWndProc = WndProc;
      wndclass.cbClsExtra = 0;
      wndclass.cbWndExtra = 0;
      wndclass.hInstance = hInstance;
      wndclass.hIcon = LoadIcon(hInstance, "WINCAP");
      wndclass.hCursor = LoadCursor(NULL, IDC_ARROW);
      wndclass.hbrBackground = COLOR_WINDOW + 1;
      wndclass.lpszMenuName = (LPSTR)NULL;
      wndclass.lpszClassName = (LPSTR)szAppName;
      if (!RegisterClass(&wndclass))
         return FALSE;
      ghInst = hInstance;  // Set Global variable

      /*
       * Create a main window for this application instance - but don't
       * display it.
       */
      hWnd = CreateWindow(szAppName,            // Name of the window's class
                          "Screen Capture",     // Text for window caption
                          WS_OVERLAPPEDWINDOW,  // Window Style
                          CW_USEDEFAULT,        // Default horizontal position
                          CW_USEDEFAULT,        // Default vertical position
                          CW_USEDEFAULT,        // Default width
                          CW_USEDEFAULT,        // Default height
                          NULL,                 // Overlapped windows have no parent
                          NULL,                 // Use the window class menu
                          hInstance,            // This instance owns this window
                          NULL);                // Pointer (not used)
      ghWndMain = hWnd;      // Set global variable

      /*
       * We want to keep the window iconic, so let's make sure that it
       * starts out iconic (by using SW_SHOWMINNOACTIVE), and we also
       * trap the WM_QUERYOPEN message in our main message loop.  These
       * two things together will keep our window iconic.
       */
      ShowWindow(hWnd, SW_SHOWMINNOACTIVE);
      UpdateWindow(hWnd);

      /*
       * Set up the Keyboard hook for our hotkey
       */
      lpfnKeyHook = MakeProcInstance((FARPROC)KeyboardHook, hInstance);
      lpfnOldHook = SetWindowsHook(WH_KEYBOARD, lpfnKeyHook);
   }

   /*
    * If another instance of our program is already running, let the
    * user know about it then exit.
    */
   if (hPrevInstance)
   {
      MessageBox(NULL, "WinCap is already running.  "
                       "There is no need to invoke it twice.", szAppName,
                 MB_OK | MB_ICONHAND);
      return FALSE;
   }

   /* Polling messages from event queue  */
   while (GetMessage(&msg, NULL, 0, 0))
   {
      if (hModelessDlg == NULL || !IsDialogMessage(hModelessDlg, &msg))
      {
         TranslateMessage(&msg);
         DispatchMessage(&msg);
      }
   }
   return msg.wParam;
}


/***********************************************************************
 *
 * KeyboardHook()
 *
 * This is the Keyboard Hook function which windows will call every
 * time it gets a keyboard message.  In this function, we check to
 * see if the key pressed was Ctrl+Alt+F9, and if it is, we post
 * the proper message to our main window which will call up the
 * printscreen dialog box.
 *
 **********************************************************************/


DWORD FAR PASCAL KeyboardHook(int iCode, WORD wParam, LONG lParam)
{
   if (iCode == HC_ACTION && wParam == VK_F9 && GetKeyState(VK_SHIFT) < 0 &&
       GetKeyState(VK_CONTROL) < 0)
   {
      if (HIWORD (lParam) & 0x8000)
         PostMessage(ghWndMain, WM_PRTSC, 0, 0L);
      return TRUE;
   }
   else
      return DefHookProc(iCode, wParam, lParam, &lpfnOldHook);
}


/***********************************************************************
 *
 * WndProc()
 *
 * This is our main window procedure.  It receives all the messages destined
 * for our application's main window.
 *
 **********************************************************************/


long FAR PASCAL WndProc(HWND hWnd, WORD wMessage, WORD wParam, LONG lParam)
{
   /*
    * The bNowPrinting variable is set to TRUE if we are in the middle of
    * printing.  This takes care of the case when the user presses the hotkey
    * during capturing
    */
   static BOOL bNowPrinting = FALSE;
   static HANDLE hOptionStruct;         // handle to pass OPTIONSTRUCT to dialog box

   switch (wMessage)
      {
   case WM_CREATE:
   {
      HANDLE hSysMenu;
      FARPROC lpfnDIALOGSMsgProc;
      LPOPTIONSTRUCT lpOptionStruct;

      /*
       * Since we want our main window to stay iconized, the user will never
       * see any menus we add to our main window, so instead let's add the
       * menu items to the system menu, which can be called up by clicking
       * once on the icon.
       */

      hSysMenu = GetSystemMenu(hWnd, FALSE);
      AppendMenu(hSysMenu, MF_SEPARATOR, 0, NULL);
      AppendMenu(hSysMenu, MF_STRING, IDM_ABOUT, "&About WinCap...");
      AppendMenu(hSysMenu, MF_STRING, IDM_CAPTURE, "Ca&pture Screen...");

      /*
       * Put up InfoBox to let user know that we loaded.
       */
      lpfnDIALOGSMsgProc = MakeProcInstance((FARPROC)InfoBoxDlgProc, ghInst);
      DialogBox(ghInst, (LPSTR)"InfoBox", hWnd, lpfnDIALOGSMsgProc);
      FreeProcInstance(lpfnDIALOGSMsgProc);

      /*
       * Allocate memory for an OPTIONSTRUCT.  This structure will be used to
       * pass data to and receive data from the Options dialog box.
       */
      hOptionStruct = GlobalAlloc(GMEM_MOVEABLE, sizeof(OPTIONSTRUCT) + 5);

      /*
       * Now set up default options
       */
      lpOptionStruct = (LPOPTIONSTRUCT)GlobalLock(hOptionStruct);
      if (hOptionStruct)
      {
         lpOptionStruct->iOptionArea = IDC_SINGLEWINDOW;
         lpOptionStruct->iOptionWindow = IDC_ENTIREWINDOW;
         lpOptionStruct->iOptionDest = OPTION_PRINTER;
         lstrcpy(lpOptionStruct->szFileName, (LPSTR)"c:\\capture.bmp");
         lpOptionStruct->iOptionPrint = IDC_BESTFIT;
         lpOptionStruct->iXScale = 1;
         lpOptionStruct->iYScale = 2;
         GlobalUnlock(hOptionStruct);
      }
   }
      break;

   case WM_PRTSC:
   {

   /*
    * The WM_PRTSC message is one that we defined in our header file.  This
    * message is sent to us when the user wants to capture the screen, either
    * by hitting the hotkey (see the KeyboardHook procedure above), by
    * double-clicking on the icon caption (see WM_QUERYOPEN message case
    * below), or by selecting the menu item "Capture Screen..." (see
    * WM_SYSCOMMAND message case below).
    */

   /* Check to see that we aren't already in the middle of printing.
    * This could happen if the user presses our hotkey in the middle of
    * one of our dialog boxes.
    */
      if (bNowPrinting)
      {
         MessageBox(NULL, "Already capturing screen.", szAppName, MB_OK |
                    MB_ICONEXCLAMATION);
      }
      else
      {

         // Commence screen capture!
         bNowPrinting = TRUE;
         DoCapture(hOptionStruct);
         bNowPrinting = FALSE;
      }
   } /* End WM_PRTSC case */
      break;

   case WM_QUERYOPEN:

      /*
       * This code makes the window stay iconic.  The PostMessage() is here
       * so that when user double-clicks on icon, we do the printscreen.
       */
      PostMessage(hWnd, WM_PRTSC, 0, 0L);
      return FALSE;

   case WM_SYSCOMMAND:
      switch (wParam)
         {
      case IDM_ABOUT:

      /*
       * Display "About" Box
       */
      {
         FARPROC lpfnDIALOGSMsgProc;

         lpfnDIALOGSMsgProc = MakeProcInstance((FARPROC)AboutDlgProc, ghInst);
         DialogBox(ghInst, (LPSTR)"About", hWnd, lpfnDIALOGSMsgProc);
         FreeProcInstance(lpfnDIALOGSMsgProc);
      }
         return 0;

      case IDM_CAPTURE:

         /*
          * User selected "Capture Screen..." From the menu
          */
         PostMessage(hWnd, WM_PRTSC, 0, 0L);
         return 0;
         }
      return DefWindowProc(hWnd, wMessage, wParam, lParam);
      break;

   case WM_DESTROY:

      /*
       * Clean up
       */
      UnhookWindowsHook(WH_KEYBOARD, lpfnKeyHook);

      /*
       * Free memory used for OPTIONSTRUCT
       */
      GlobalFree(hOptionStruct);
      PostQuitMessage(0);
      break;

   default:
      return DefWindowProc(hWnd, wMessage, wParam, lParam);
      }
   return 0L;
}


/***********************************************************************
 *
 * DoCapture()
 *
 * This procedure gets called when the user wants to capture the
 * screen.  This is where we actually bring up the proper dialog
 * boxes and call the proper screen capture functions.
 *
 **********************************************************************/


void DoCapture(HANDLE hOptionStruct)
{
   FARPROC lpfnDIALOGSMsgProc;     // Pointer for dialog boxes
   int nResult;                    // return codes from the dialog boxes
   LPOPTIONSTRUCT lpOptionStruct;  // Pointer to OPTIONSTRUCT
   static HDIB hDib;               // Handle to our captured screen DIB
   char szWindowText[100];         // Text which tells what we captured
   static HWND hWndCurrent;


   /*
    * Keep track of the active window so we can bring it to top
    * later.
    */

   hWndCurrent = GetActiveWindow();

   /*
    * Call up Options dialog box
    */
   lpfnDIALOGSMsgProc = MakeProcInstance((FARPROC)OptionsDlgProc, ghInst);

   /*
    * Pass the handle to our OPTIONSTRUCT to the dialog box in the 5th parameter
    * to DialogBoxParam.  This will be passed to our dialog box in the lParam
    * WM_INITDIALOG message.  Since the 5th parameter to DialogBoxParam()
    * is 32 bits, and our handle is only 16 bits, let's put it in the
    * LOWORD() of the parameter.
    */
   nResult = DialogBoxParam(ghInst, (LPSTR)"Options", ghWndMain,
                            lpfnDIALOGSMsgProc, (DWORD)MAKELONG(hOptionStruct,
                            0));
   FreeProcInstance(lpfnDIALOGSMsgProc);

   /*
    * If user presses OK (nResult == TRUE), then go on, otherwise don't go on
    */
   if (nResult)
   {
      lpOptionStruct = (LPOPTIONSTRUCT)GlobalLock(hOptionStruct);
      if (!lpOptionStruct)
         return;

      /*
       * The structure should now contain:
       * 1. iOptionArea - Specifies which area user wants to capture
       *    One of: IDC_SINGLEWINDOW
       *            IDC_ENTIRESCREEN
       *            IDC_PARTIALSCREEN
       * 2. iOptionWindow - Specifies which portion of the window to capture -
       *    this will only contain valid data if the iOptionArea is set to
       *    IDC_SINGLEWINDOW.  Will be one of:
       *            IDC_ENTIREWINDOW
       *            IDC_CLIENTAREAONLY
       *            IDC_CAPTIONBARONLY
       *            IDC_MENUBARONLY
       * 3. iOptionDest - Bitfield which specifies the destination of the
       *    bitmap.  Can be a logical combination of: OPTION_FILE and
       *    OPTION_PRINTER.
       * 4. szFileName - string which contains the filename the user
       *    typed into as the name to save the bitmap to.  This is only
       *    valid if the iOptionDest has the OPTION_FILE bit set.
       * 5. iOptionPrint - Print Options.  Will be one of:
       *            IDC_BESTFIT
       *            IDC_STRETCHTOPAGE
       *            IDC_SCALE
       * 6. iXScale, iYScale - X and Y scaling factors for printing bitmap.
       *    These values are only valid if iOptionPrint is set to IDC_SCALE.
       */
      switch (lpOptionStruct->iOptionArea)
         {
      case IDC_ENTIRESCREEN:

      /*
       * Copy Entire screen to DIB
       */
      {
         RECT rScreen;       // Rect containing entire screen
         HDC hDC;            // DC to screen
         MSG msg;            // Message for the PeekMessage()

         hDC = CreateDC("DISPLAY", NULL, NULL, NULL);
         rScreen.left = rScreen.top = 0;
         rScreen.right = GetDeviceCaps(hDC, HORZRES);
         rScreen.bottom = GetDeviceCaps(hDC, VERTRES);
         strcpy(szWindowText, "Entire screen");

         /* Bring the previous current window to the top of the Z-order.
          * Wait until this application gets another message -- this allows
          * the other windows (which were obscured before by the dialog
          * box) to repaint themselves.
          */
         BringWindowToTop(hWndCurrent);
         while (PeekMessage(&msg, NULL, 0, 0, PM_REMOVE) != 0)
         {
            TranslateMessage(&msg);
            DispatchMessage(&msg);
         }

         /*
          * Call the DIB API function which captures the screen.  This
          * will automatically allocate enough space for the DIB, fill
          * in the proper fields in the DIB header, and return us a
          * pointer to the memory containing the header, colortable,
          * and bits of the DIB.
          */
         hDib = CopyScreenToDIB(&rScreen);
      }
         break;

      case IDC_PARTIALSCREEN:
      /*
       * Copy user-selected portion of screen to DIB
       */
      {
         RECT rRubberBand;       // Region to capture (screen coordinates)

         /*
          * Allow user to "rubberband" a section of the screen for
          * us to capture
          */

         RubberBandScreen(&rRubberBand);
         strcpy(szWindowText, "User selected portion");

         /*
          * Call the DIB API function which captures the screen.  This
          * will automatically allocate enough space for the DIB, fill
          * in the proper fields in the DIB header, and return us a
          * pointer to the memory containing the header, colortable,
          * and bits of the DIB.
          */
         hDib = CopyScreenToDIB(&rRubberBand);
      }
         break;

      case IDC_SINGLEWINDOW:
      /*
       * Allow the user to click on a single window to capture
       */
      {
         HWND hWndSelect;
         HWND hWndDesktop;
         WORD wOption;

         /*
          * Call function which lets user select a window
          */

         hWndSelect = SelectWindow();

         /*
          * Check to see that they didn't try to capture desktop window
          */
         hWndDesktop = GetDesktopWindow();
         if (hWndSelect == hWndDesktop)
         {
            MessageBox(NULL, "Cannot capture Desktop window."
                             "  Use 'Entire Screen' option to capture"
                             " the entire screen.", szAppName,
                       MB_ICONEXCLAMATION | MB_OK);
            hDib = NULL;
            break;
         }

         /*
          * Check to see that the hWnd is not NULL
          */
         if (!hWndSelect)
         {
            MessageBox(NULL, "Cannot capture that window!", szAppName,
                       MB_ICONEXCLAMATION | MB_OK);
            hDib = NULL;
            break;
         }

         /*
          * Make sure it's not a hidden window.  Hmm, capturing a hidden
          * window would certainly be a cool trick, wouldn't it?
          */
         if (!IsWindowVisible(hWndSelect))
         {
            MessageBox(NULL, "Window is not visible.  Can't capture",
                       szAppName, MB_ICONEXCLAMATION | MB_OK);
            hDib = NULL;
            break;
         }

         // Move window which was selected to top of Z-order for
         // the capture, and make it redraw itself
         SetWindowPos(hWndSelect, NULL, 0, 0, 0, 0, SWP_DRAWFRAME | SWP_NOSIZE
                      | SWP_NOMOVE);
         UpdateWindow(hWndSelect);

         /*
          * Get the caption
          */
         GetWindowText(hWndSelect, szWindowText, 100);

         /*
          * Convert our OPTIONSTRUCT options to DIB API options
          */
         switch (lpOptionStruct->iOptionWindow)
            {
         case IDC_CLIENTAREAONLY:
            wOption = PW_CLIENT;
            break;

         case IDC_ENTIREWINDOW:
         default:
            wOption = PW_WINDOW;
            break;
            }
         /*
          * Call the DIB API function which captures the screen.  This
          * will automatically allocate enough space for the DIB, fill
          * in the proper fields in the DIB header, and return us a
          * pointer to the memory containing the header, colortable,
          * and bits of the DIB.
          */
         hDib = CopyWindowToDIB(hWndSelect, wOption);
      }
         break;

      default:
         /*
          * Oops, something went wrong
          */
         MessageBox(NULL, "Invalid Return value from Options DialogBox",
                    szAppName, MB_ICONHAND | MB_OK);
         break;
         }
      /*
       * At this point, if hDib is NULL, then there was an error.  We should
       * have already taken care of informing the user of the error.
       */
      if (!hDib)
      {
         GlobalUnlock(hOptionStruct);
         DestroyDIB(hDib);
         return;
      }

      /*
       * Now, process the destination information (e.g. to printer or file)
       */

      /*
       * See if the user checked the checkbox "Send to File"
       */
      if (lpOptionStruct->iOptionDest & OPTION_FILE)
      {
         WORD wReturn;
         FARPROC lpfnDIALOGSMsgProc;

         // First, call up a modeless dialog box which tells that we are saving
         // this to a file...

         if (!hModelessDlg)
         {
            lpfnDIALOGSMsgProc = MakeProcInstance((FARPROC)SavingDlgProc,
                                                  ghInst);
            hModelessDlg = CreateDialogParam(ghInst, (LPSTR)"Saving",
                                             ghWndMain, lpfnDIALOGSMsgProc, (
                                             DWORD)(LPSTR)lpOptionStruct->
                                             szFileName);
         }

         /*
          * Call DIB API function which saves dib to file
          */
         wReturn = SaveDIB(hDib, (LPSTR)lpOptionStruct->szFileName);
         DestroyWindow(hModelessDlg);
         hModelessDlg = NULL;
         if (wReturn)
            MessageBox(NULL, "Error saving file", szAppName,
                       MB_ICONEXCLAMATION | MB_OK);
         FreeProcInstance(lpfnDIALOGSMsgProc);
      }

      /*
       * See if the user checked the box "Print to printer"
       */
      if (lpOptionStruct->iOptionDest & OPTION_PRINTER)
      {
         WORD wReturn;
         WORD wOption;
         WORD wX = 0, wY = 0;

         switch (lpOptionStruct->iOptionPrint)
            {
         case IDC_STRETCHTOPAGE:
            wOption = PW_STRETCHTOPAGE;
            break;

         case IDC_SCALE:
            wOption = PW_SCALE;
            wX = lpOptionStruct->iXScale;
            wY = lpOptionStruct->iYScale;
            break;

         default:
         case IDC_BESTFIT:
            wOption = PW_BESTFIT;
            break;
            }

         /*
          * Send the bitmap to the printer, using the specified options
          */
         wReturn = PrintDIB(hDib, wOption, wX, wY, (LPSTR)szWindowText);
         if (wReturn)
         {
            DIBError(wReturn);
         }
      }

      /*
       * Clean up -- deallocate memory used for DIB
       */
      GlobalUnlock(hOptionStruct);
      DestroyDIB(hDib);
   }
}


/***********************************************************************
 *
 * SelectWindow()
 *
 * This function allows the user to select a window on the screen.  The
 * cursor is changed to a custom cursor, then the user clicks on the title
 * bar of a window to capture, and the handle to this window is returned.
 *
 **********************************************************************/


HWND SelectWindow()
{
   HCURSOR hOldCursor;     // Handle to old cursor
   POINT pt;               // Stores mouse position on a mouse click
   HWND hWndClicked;       // Window we clicked on
   MSG msg;

   /*
    * Capture all mouse messages
    */
   SetCapture(ghWndMain);

   /*
    * Load custom Cursor
    */
   hOldCursor = SetCursor(LoadCursor(ghInst, "SELECT"));

   /*
    * Eat mouse messages until a WM_LBUTTONUP is encountered.
    */
   for (;;)
   {
      WaitMessage();
      if (PeekMessage(&msg, NULL, WM_MOUSEFIRST, WM_MOUSELAST, PM_REMOVE))
      {
         if (msg.message == WM_LBUTTONUP)
         {
            /*
             * Get mouse position
             */
            pt.x = LOWORD(msg.lParam);
            pt.y = HIWORD(msg.lParam);

            /*
             * Convert to screen coordinates
             */
            ClientToScreen(ghWndMain, &pt);

            /*
             * Get Window that we clicked on
             */
            hWndClicked = WindowFromPoint(pt);

            /*
             * If it's not a valid window, just return NULL
             */
            if (!hWndClicked)
            {
               ReleaseCapture();
               SetCursor(hOldCursor);
               return NULL;
            }
            break;
         }
      }
      else
         continue;
   }
   ReleaseCapture();
   SetCursor(hOldCursor);
   return (hWndClicked);
}


/***********************************************************************
 *
 * RubberBandScreen()
 *
 * This function allows the user to rubber-band a portion of the screen.
 * When the left button is released, the rect that the user selected
 * (in screen coordinates) is returned in lpRect.
 *
 **********************************************************************/


void RubberBandScreen(LPRECT lpRect)
{
   POINT pt;           // Temporary POINT
   MSG msg;            // Used in our PeekMessage() loop
   POINT ptOrigin;     // Point where the user pressed left mouse button down
   RECT rcClip;        // Current selection
   HDC hScreenDC;      // DC to the screen (so we can draw on it)
   HCURSOR hOldCursor; // Saves old cursor
   BOOL bCapturing = FALSE;    // TRUE if we are rubber-banding

   hScreenDC = CreateDC("DISPLAY", NULL, NULL, NULL);

   /*
    * Make cursor our custom cursor
    */
   hOldCursor = SetCursor(LoadCursor(NULL, IDC_CROSS));

   /*
    * Capture all mouse messages
    */
   SetCapture(ghWndMain);

   /* Eat mouse messages until a WM_LBUTTONUP is encountered. Meanwhile
    * continue to draw a rubberbanding rectangle and display it's dimensions
    */
   for (;;)
   {
      WaitMessage();
      if (PeekMessage(&msg, NULL, WM_MOUSEFIRST, WM_MOUSELAST, PM_REMOVE))
      {
         /*
          * If the message is a WM_LBUTTONDOWN, begin drawing the
          * rubber-band box.
          */
         if (msg.message == WM_LBUTTONDOWN)
         {
            /*
             * User pressed left button, initialize selection
             * Set origin to current mouse position (in window coords)
             */
            ptOrigin.x = LOWORD(msg.lParam);
            ptOrigin.y = HIWORD(msg.lParam);

            /*
             * Convert to screen coordinates
             */
            ClientToScreen(ghWndMain, &ptOrigin);

            /*
             * rcClip is the current rectangle that the user
             * has selected.  Since user just pressed left button down,
             * initialize this rect very small
             */
            rcClip.left = rcClip.right = ptOrigin.x;
            rcClip.top = rcClip.bottom = ptOrigin.y;
            NormalizeRect(&rcClip);     // Make sure it is a normal rect
            DrawSelect(hScreenDC, TRUE, &rcClip); // Draw the rubber-band box
            bCapturing = TRUE;
         }
         /*
          * Any messages that make it into the next statement are mouse
          * messages, and we are capturing, so let's update the rubber-band
          * box
          */
         if (bCapturing)
         {
            DrawSelect(hScreenDC, FALSE, &rcClip);    // erase old rubber-band
            rcClip.left = ptOrigin.x;     // Update rect with new mouse info
            rcClip.top = ptOrigin.y;
            pt.x = LOWORD(msg.lParam);
            pt.y = HIWORD(msg.lParam);

            /*
             * Convert to screen coordinates
             */
            ClientToScreen(ghWndMain, &pt);
            rcClip.right = pt.x;
            rcClip.bottom = pt.y;
            NormalizeRect(&rcClip);
            DrawSelect(hScreenDC, TRUE, &rcClip); // And draw the new rubber-band
         }

         // If the message is WM_LBUTTONUP, then we stop the selection
         // process.
         if (msg.message == WM_LBUTTONUP)
         {
            DrawSelect(hScreenDC, FALSE, &rcClip);    // erase rubber-band
            SetCursor(hOldCursor);
            break;
         }
      }
      else
         continue;
   }
   ReleaseCapture();
   DeleteDC(hScreenDC);

   /*
    * Assign rect user selected to lpRect parameter
    */
   CopyRect(lpRect, &rcClip);
}


/****************************************************************************
 *
 * DrawSelect
 *
 * Draws the selected clip rectangle with its dimensions on the DC
 * This code is taken from DIBVIEW.
 *
 ****************************************************************************/


void DrawSelect(HDC hdc,           // DC to draw on
                BOOL fDraw,        // TRUE to draw, FALSE to erase
                LPRECT lprClip)    // rect to draw
{
   char sz[80];
   DWORD dw;
   int x, y, len, dx, dy;
   HDC hdcBits;
   HBITMAP hbm;
   RECT rcClip;

   rcClip = *lprClip;
   if (!IsRectEmpty(&rcClip))
   {

      /* If a rectangular clip region has been selected, draw it */
      PatBlt(hdc, rcClip.left, rcClip.top, rcClip.right - rcClip.left, 1,
             DSTINVERT);
      PatBlt(hdc, rcClip.left, rcClip.bottom, 1, -(rcClip.bottom - rcClip.top)
             , DSTINVERT);
      PatBlt(hdc, rcClip.right - 1, rcClip.top, 1, rcClip.bottom - rcClip.top,
             DSTINVERT);
      PatBlt(hdc, rcClip.right, rcClip.bottom - 1, -(rcClip.right -
             rcClip.left), 1, DSTINVERT);

      /* Format the dimensions string ...*/
      wsprintf(sz, "%dx%d", rcClip.right - rcClip.left, rcClip.bottom -
               rcClip.top);
      len = lstrlen(sz);

      /* ... and center it in the rectangle */
      dw = GetTextExtent(hdc, sz, len);
      dx = LOWORD (dw);
      dy = HIWORD (dw);
      x = (rcClip.right + rcClip.left - dx) / 2;
      y = (rcClip.bottom + rcClip.top - dy) / 2;
      hdcBits = CreateCompatibleDC(hdc);
      SetTextColor(hdcBits, 0xFFFFFFL);
      SetBkColor(hdcBits, 0x000000L);

      /* Output the text to the DC */
      if (hbm = CreateBitmap(dx, dy, 1, 1, NULL))
      {
         hbm = SelectObject(hdcBits, hbm);
         ExtTextOut(hdcBits, 0, 0, 0, NULL, sz, len, NULL);
         BitBlt(hdc, x, y, dx, dy, hdcBits, 0, 0, SRCINVERT);
         hbm = SelectObject(hdcBits, hbm);
         DeleteObject(hbm);
      }
      DeleteDC(hdcBits);
   }
}


/****************************************************************************
 *                                                                          *
 *  FUNCTION   : NormalizeRect(RECT *prc)                                   *
 *                                                                          *
 *  PURPOSE    : If the rectangle coordinates are reversed, swaps them      *
 *                                                                          *
 ****************************************************************************/


void PASCAL NormalizeRect(LPRECT prc)
{
   if (prc->right < prc->left)
      SWAP(prc->right,prc->left);
   if (prc->bottom < prc->top)
      SWAP(prc->bottom,prc->top);
}

