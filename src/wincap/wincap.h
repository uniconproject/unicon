/* Header file for wincap.c */
/* Copyright (c) 1991 Microsoft Corporation. All rights reserved. */

/*
 * constants for menu items 
 */

#define IDM_ABOUT 101
#define IDM_CAPTURE 102

/*
 * constants for OPTIONSTRUCT list of
 * options 
 */

#define OPTION_FILE 0x01
#define OPTION_PRINTER 0x02

/*
 * User-defined messages
 */

#define WM_PRTSC  (WM_USER + 10)
#define WM_REPAINT (WM_USER + 11)

typedef struct tagOPTIONS {
    int iOptionArea;        // Area to capture Option selected
    int iOptionWindow;      // Window to capture option selected
    int iOptionDest;        // Option for destination of bitmap
    char szFileName[100];       // Name of file to save to
    int iOptionPrint;       // Print Options
    int iXScale;
    int iYScale;
    } OPTIONSTRUCT;

typedef OPTIONSTRUCT FAR *LPOPTIONSTRUCT;

/*
 * function prototypes
 */

void cwCenter(HWND, int);

LONG FAR PASCAL WndProc(HWND, WORD, WORD, LONG);
BOOL FAR PASCAL OptionsDlgProc(HWND, WORD, WORD, LONG);
BOOL FAR PASCAL AboutDlgProc(HWND, WORD, WORD, LONG);
BOOL FAR PASCAL HelpDlgProc(HWND, WORD, WORD, LONG);
BOOL FAR PASCAL SavePrintDlgProc(HWND, WORD, WORD, LONG);
BOOL FAR PASCAL InfoBoxDlgProc(HWND, WORD, WORD, LONG);
BOOL FAR PASCAL SavingDlgProc(HWND, WORD, WORD, LONG);
DWORD FAR PASCAL KeyboardHook (int iCode, WORD wParam, LONG lParam);
void DrawIndent(HWND hDlg, int ID, int iType);
void StretchIconToWindow(HWND hWndDlg, LPSTR szIconName);
void DoCapture(HANDLE);
void RubberBandScreen(LPRECT lpRect);
void DrawSelect( HDC hdc, BOOL fDraw, LPRECT lprClip);
void PASCAL NormalizeRect (LPRECT prc);
HWND SelectWindow(void);
