/*
 * The ncurses-based build
 * This program is written to run from the top level directory for Unicon
 * i.e. ./build x86_32_linux | ./build x86_64_linux | ./build x86_64_macos
 *
 * Author: Ziad Al-Sharif
 *         zsharif@gmail.com
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <curses.h>

#define _ODBC_        0
#define _2D_X11_      1
#define _3D_OpenGL_   2
#define _3D_Fonts_    3
#define _AUDIO_       4
#define _VoIP_        5

#define WIDTH         60
#define HEIGHT        11

#define MARKED    " [ X ] " /* selected[i] >  0 */
#define UNMARKED  " [   ] " /* selected[i] == 0 */
#define DISABLED  " [ - ] " /* selected[i] <  0 */

void analyze_Selections(int current);
void check_Selections(int current);
void print_menu(WINDOW *menu_win, int highlight);

void printConfig(char List[100][40], int max);
void InitInfo(void);
void checkEnabledFeatures(void);
void rewrite_Auto_h(void);
void read_Makedefs(void);
void rewrite_Makedefs(void);

WINDOW *main_win, *title_win, *sub_win, *ans_win;

char msg4[]  = {"<Q>  : Quit     "};
char msg1[]  = {"<UP> : Move up  "};
char msg2[]  = {"<SPACE>: Select   "};
char msg0[]  = {"<DOWN> : Move down"};
char msg3[]  = {"<ENTER>: Build    "};

char title[] = {"*** Unicon Configuration Options *** "};

int n_choices=6;
int selected[6];

int startx = 0;
int starty = 0;

char *choices[] = {
     /*-0-*/  "    --Database (ODBC) Support         ! ",
     /*-1-*/  "    --2D Graphics (X11) Support       ! ",
     /*-2-*/  "      --3D Graphics (OpenGL) Support  ! ",
     /*-3-*/  "      --3D Fonts    (OpenGL) Support  ! ",
     /*-4-*/  "    --Audio Support                   ! ",
     /*-5-*/  "      --VoIP Support                  ! "
};

char *items[] = {
    "ODBC",
    "X11",
    "3D-Graphics",
    "3D-Fonts",
    "Audio",
    "VoIP"
};


WINDOW *create_newwin(int height, int width, int starty, int startx)
{
   WINDOW *local_win;

   if (((startx + width) > COLS) || ((starty + height) > LINES)) {
      endwin();
      printf("There is not enough screen space on the current terminal!\n");
      printf("Please increase the size of the terminal to 80x24 or larger.\n");
      exit(-1);
      }
   local_win = newwin(height, width, starty, startx);
   box(local_win, 0 , 0);
   wrefresh(local_win);
   keypad(local_win, TRUE);
   return local_win;
}

void InitSelections()
{
   n_choices = sizeof(choices) / sizeof(char *);

   selected[_ODBC_]      = -1;
   selected[_2D_X11_]    = -1;
   selected[_3D_OpenGL_] = -1;
   selected[_3D_Fonts_]  = -1;
   selected[_AUDIO_]     = -1;
   selected[_VoIP_]      = -1;
}

void InitMenu()
{
   initscr();
   clear();
   noecho();
   cbreak();    /* Line buffering disabled. pass on everything */
   startx = (COLS - WIDTH)  / 2;
   starty = (LINES - HEIGHT) / 2;

   /* Create three Windows */
   main_win  = create_newwin(HEIGHT+5, WIDTH+10, starty-3, startx-5);
   title_win = create_newwin(3, WIDTH+10, starty-6, startx-5);
   sub_win   = create_newwin(HEIGHT, WIDTH, starty, startx);
   ans_win   = create_newwin(4, WIDTH+10, starty+HEIGHT+2, startx-5);
   refresh();
}

int menu()
{
   int highlight = 1;
   int choice = 0;
   int i, ch, current;

   InitMenu();

   print_menu(sub_win, highlight);
   analyze_Selections(highlight-1);

   while(1) {
      ch = wgetch(sub_win);
      switch(ch){
      case KEY_UP:{
         if (highlight == 1)
            highlight = n_choices;
         else
            --highlight;
         break;
         }
      case KEY_DOWN:{
         if (highlight == n_choices)
            highlight = 1;
         else
            ++highlight;
         break;
         }
      case ' ':{
         current = highlight - 1;
         if (selected[current] > 0){
            selected[current] = 0;
            check_Selections(current);
            }
         else if (selected[current] == 0){
            selected[current] = 1;
            check_Selections(current);
            }
         break;
         }
      case 'q':
      case 'Q':
      case 27:{ /* the Esc key   */
         /* quit the build process */
         ch = getAnswer(1);
         if ((ch == 'Y') || (ch=='y'))
            choice = highlight;
         break;
         }
      case 10:{ /* the Enter key */
         ch = getAnswer(2);
         if ((ch == 'Y') || (ch=='y')){
            choice = highlight;

            rewrite_Auto_h();
            rewrite_Makedefs();

            endwin();
            printf("\n\nmake Unicon \n");
            system("make Unicon");
            }
         break;
         }
         }
      print_menu(sub_win, highlight);
      analyze_Selections(highlight-1);

      if(choice != 0)
         break;
      }
   delwin(main_win);
   delwin(title_win);
   delwin(sub_win);
   endwin();
   return 0;
}

void check_Selections(int current)
{
   int i;

   if (current == _2D_X11_){ /* Check for the Graphics Configurations */
      if (!selected[_2D_X11_])
         if (selected[_3D_OpenGL_] > 0) selected[_3D_OpenGL_] = 0;
         if (selected[_3D_Fonts_] > 0)  selected[_3D_Fonts_]  = 0;
      }
   else if (current == _3D_OpenGL_){
      /* Check for the 3D Graphics Configurations */
      if ((!selected[_3D_OpenGL_]) && (selected[_3D_Fonts_] > 0))
         selected[_3D_Fonts_] = 0;
      else if(selected[_3D_OpenGL_])
         selected[_2D_X11_] = 1;
      }
   else if (current == _3D_Fonts_){
      /* Check for the 3D Graphics Configurations */
      if (selected[_3D_Fonts_]) {
         selected[_3D_OpenGL_] = 1;
         selected[_2D_X11_] = 1;
         }
      }
   else if (current == _AUDIO_){ /* Check for Audio and VoIP Configurations */
      if ((!selected[_AUDIO_]) && (selected[_VoIP_] > 0))
         selected[_VoIP_] = 0;
      }
   else if (current == _VoIP_){ /* Check for Audio and VoIP Configurations */
      if (selected[_VoIP_])
         selected[_AUDIO_] = 1;
      }
}

void analyze_Selections(int current)
{
   char temp[200]={"Selections: "};
   int  i, j=0, y, x, l;

   if (selected[current] >=0) {
      for(i = 0; i < n_choices; ++i)
         if(selected[i] > 0) {
            strcat(temp, items[i]);
            strcat(temp, ", ");
            ++j;
            }
      if (j > 0){
         l = strlen(temp)-2;
         temp[l]='.';
         temp[l+1]='\0';
         }
      else
         strcat(temp, " NONE = Basic.");
      }
   else if (selected[current] == -1){
      strcpy(temp, "The ");
      strcat(temp,items[current]);
      strcat(temp," feature was not found on this platform.");
      }
   x = (WIDTH/2) - (strlen(temp)/2)+4;
   wmove(ans_win,1, 1);
   mvwprintw(ans_win,1,1,"                                                                   ");
   mvwprintw(ans_win,1, x, temp);
   wrefresh(ans_win);
}

int getAnswer(int which)
{
   int x;
   char ch, temp[100]={'\0'};

   if (which == 1)
      strcat(temp,"Do you really want to quit the build process (Y|N)?:");
   else if (which == 2)
      strcat(temp,"Do you really want to start the build process (Y|N)?:");

   x = (WIDTH/2) - (strlen(temp)/2)+3;
   wmove(ans_win,2, 1);
   mvwprintw(ans_win,2,1,"                                                                   ");
   mvwprintw(ans_win,2, x, temp);
   ch = wgetch(ans_win);
   mvwprintw(ans_win,2,1,"                                                                   ");
   wrefresh(ans_win);
   return ch;
}

void print_menu(WINDOW *win, int highlight)
{
   int x, y, i;

   /* print the title menu */
   box(title_win, 0, 0);
   mvwprintw(title_win, 1, 17, title);
   wrefresh(title_win);

   /* print the main menu (outermost) */
   box(main_win, 0, 0);
   mvwprintw(main_win, 1 , 5 , msg2);
   mvwprintw(main_win, 1 , 30, msg3);
   mvwprintw(main_win, 1 , 50, msg4);
   mvwprintw(main_win, 2 , 5 , msg0);
   mvwprintw(main_win, 2 , 50, msg1);

   mvwprintw(main_win, 14, 5 , "[   ]: Not Selected");
   mvwprintw(main_win, 14, 28, "[ X ]: Selected");
   mvwprintw(main_win, 14, 49, "[ - ]: Disabled");
   wrefresh(main_win);

   /* print the sub menu (innermost) */
   x = (WIDTH - strlen(choices[0]) - strlen(MARKED) -3) / 2;
   y = 2;
   box(win, 0, 0);
   for(i = 0; i < n_choices; ++i){
      if(highlight == i + 1){ /* High light the present choice */
         wattron(win, A_REVERSE);
         if (selected[i] > 0)
            mvwprintw(win, y, x, "%s : %s", MARKED, choices[i]);
         else if (selected[i] < 0)
            mvwprintw(win, y, x, "%s : %s", DISABLED, choices[i]);
         else
            mvwprintw(win, y, x, "%s : %s", UNMARKED, choices[i]);
         wattroff(win, A_REVERSE);
         }
      else{
         if (selected[i] > 0)
            mvwprintw(win, y, x, "%s : %s", MARKED , choices[i]);
         else if (selected[i] < 0)
            mvwprintw(win, y, x, "%s : %s", DISABLED, choices[i]);
         else
            mvwprintw(win, y, x, "%s : %s", UNMARKED, choices[i]);
         }
      ++y;
    }
    wrefresh(win);

    /* print the answer window at the bottom */
    box(ans_win, 0, 0);
    wrefresh(ans_win);
}

/*-----------------------------------------------------------------*/

char MAKEDEFS[]={"Makedefs"};       /* The name of the Makedefs file Unicon  */
char AUTO_H[]  ={"src/h/auto.h"};   /* The name of the auto.h file in Unicon */

char _All_Defined_Macros[100][40];   /* initialized from auto.h        */
int _All_Defined_Macros_MAX;         /* number of #defined macros      */

struct Info {
   int  enabled;
   char tag[20];
   char defined[40];
   char undefined[40];
   char lib1[20];
   char lib2[20];
   char lib3[20];
};

int _AC_LIBS_MAX=0;
char _AC_LIBS[30][40]={'\0'};

int _DataBase_Score = 2;
struct Info _DataBase[2];

int _X11_2DGraphics_Score = 1;
struct Info _X11_2DGraphics[1];

int _3DGraphics_Score = 1;
struct Info _3DGraphics[1];

int _3DFonts_Score = 3;
struct Info _3DFonts[3];

int _Audio_Score = 4;
struct Info _Audio[4];

int _VoIP_Score = 5;
struct Info _VoIP[5];

void InitInfo(void)
{
   /*
    * Initialize the database configurations
    */
   _DataBase[0].enabled = 0;
   strcpy(_DataBase[0].tag,       "Zlib/libz");
   strcpy(_DataBase[0].defined,   "#define HAVE_LIBZ 1");
   strcpy(_DataBase[0].undefined, "#undef HAVE_LIBZ");
   strcpy(_DataBase[0].lib1,      "-lz");
   _DataBase[0].lib2[0] = '\0';
   _DataBase[0].lib3[0] = '\0';

   _DataBase[1].enabled = 0;
   strcpy(_DataBase[1].tag,       "odbc");
   strcpy(_DataBase[1].defined,   "#define HAVE_LIBODBC 1");
   strcpy(_DataBase[1].undefined, "#undef HAVE_LIBODBC");
   strcpy(_DataBase[1].lib1,      "-lodbc"); /* this one or the other */
   strcpy(_DataBase[1].lib2,      "-liodbc");/* this one or the other */
   _DataBase[1].lib3[0] = '\0';

   /*
    * Initialize the X11 2D Graphis configurations
    */
   _X11_2DGraphics[0].enabled = 0;
   strcpy(_X11_2DGraphics[0].tag,       "X11 2D Graphics");
   strcpy(_X11_2DGraphics[0].defined,   "#define HAVE_LIBX11 1");
   strcpy(_X11_2DGraphics[0].undefined, "#undef  HAVE_LIBX11");
   strcpy(_X11_2DGraphics[0].lib1,      "-lX11"); /* this one and the other */
   _X11_2DGraphics[0].lib2[0]= '\0';
   _X11_2DGraphics[0].lib3[0]= '\0';


   /*
    * Initialize the 3D Graphis configurations
    */
   _3DGraphics[0].enabled = 0;
   strcpy(_3DGraphics[0].tag,       "opengl");
   strcpy(_3DGraphics[0].defined,   "#define HAVE_LIBGL 1");
   strcpy(_3DGraphics[0].undefined, "#undef HAVE_LIBGL");
   strcpy(_3DGraphics[0].lib1,      "-lGL"); /* this one and the other */
   strcpy(_3DGraphics[0].lib2,      "-lGLU");/* this one and the other */
   _3DGraphics[0].lib3[0]= '\0';

   /*
    * Initialize the 3D Fonts configurations
    */
   _3DFonts[0].enabled = 0;
   strcpy(_3DFonts[0].tag,       "FTGL");
   strcpy(_3DFonts[0].defined,   "#define HAVE_LIBFTGL 1");
   strcpy(_3DFonts[0].undefined, "#undef HAVE_LIBFTGL");
   strcpy(_3DFonts[0].lib1,      "-lftgl"); /* this one and no other */
   _3DFonts[0].lib2[0] = '\0';
   _3DFonts[0].lib3[0] = '\0';

   _3DFonts[1].enabled = 0;
   strcpy(_3DFonts[1].tag,       "Freetype");
   strcpy(_3DFonts[1].defined,   "#define HAVE_LIBFREETYPE 1");
   strcpy(_3DFonts[1].undefined, "#undef HAVE_LIBFREETYPE");
   strcpy(_3DFonts[1].lib1,      "-lfreetype"); /* this one and no other */
   _3DFonts[1].lib2[0] = '\0';
   _3DFonts[1].lib3[0] = '\0';

   _3DFonts[2].enabled = 0;
   strcpy(_3DFonts[2].tag,       "Xft");
   strcpy(_3DFonts[2].defined,   "#define HAVE_LIBXFT 1");
   strcpy(_3DFonts[2].undefined, "#undef HAVE_LIBXFT");
   strcpy(_3DFonts[2].lib1,      "-lxft"); /* this one and no other */
   _3DFonts[2].lib2[0] = '\0';
   _3DFonts[2].lib3[0] = '\0';

   /*
    * Initialize the Audio configurations
    */
   _Audio[0].enabled = 0;
   strcpy(_Audio[0].tag,       "ogg vorbis");
   strcpy(_Audio[0].defined,   "#define HAVE_LIBOGG 1");
   strcpy(_Audio[0].undefined, "#undef HAVE_LIBOGG");
   strcpy(_Audio[0].lib1,      "-logg");       /* this one and the other */
   strcpy(_Audio[0].lib2,      "-lvorbis");    /* this one and the other */
   strcpy(_Audio[0].lib3,      "-lvorbisfile");/* this one and the other */

   _Audio[1].enabled = 0;
   strcpy(_Audio[1].tag,       "libsmpeg");
   strcpy(_Audio[1].defined,   "#define HAVE_LIBSMPEG 1");
   strcpy(_Audio[1].undefined, "#undef HAVE_LIBSMPEG");
   strcpy(_Audio[1].lib1,      "-lsmpeg"); /* this one and no other */
   _Audio[1].lib2[0] = '\0';
   _Audio[1].lib3[0] = '\0';

   _Audio[2].enabled = 0;
   strcpy(_Audio[2].tag,       "libSDL");
   strcpy(_Audio[2].defined,   "#define HAVE_LIBSDL 1");
   strcpy(_Audio[2].undefined, "#undef HAVE_LIBSDL");
   strcpy(_Audio[2].lib1,      "-lSDL"); /* this one and no other */
   _Audio[2].lib2[0] = '\0';
   _Audio[2].lib3[0] = '\0';

   _Audio[3].enabled = 0;
   strcpy(_Audio[3].tag,       "libopenal");
   strcpy(_Audio[3].defined,   "#define HAVE_LIBOPENAL 1");
   strcpy(_Audio[3].undefined, "#undef HAVE_LIBOPENAL");
   strcpy(_Audio[3].lib1,      "-lopenal"); /* this one and no other */
   _Audio[3].lib2[0] = '\0';
   _Audio[3].lib3[0] = '\0';

   /*
    * Initialize the VoIP configurations
    */
   _VoIP[0].enabled = 0;
   strcpy(_VoIP[0].tag,       "jvoiplib");
   strcpy(_VoIP[0].defined,   "#define HAVE_LIBJVOIP 1");
   strcpy(_VoIP[0].undefined, "#undef HAVE_LIBJVOIP");
   strcpy(_VoIP[0].lib1,      "-ljvoiplib"); /* this one and no other */
   _VoIP[0].lib2[0] = '\0';
   _VoIP[0].lib3[0] = '\0';

   _VoIP[1].enabled = 0;
   strcpy(_VoIP[1].tag,       "jrtplib");
   strcpy(_VoIP[1].defined,   "#define HAVE_LIBJRTP 1");
   strcpy(_VoIP[1].undefined, "#undef HAVE_LIBJRTP");
   strcpy(_VoIP[1].lib1,      "-ljrtplib"); /* this one and no other */
   _VoIP[1].lib2[0] = '\0';
   _VoIP[1].lib3[0] = '\0';

   _VoIP[2].enabled = 0;
   strcpy(_VoIP[2].tag,       "jthreadlib");
   strcpy(_VoIP[2].defined,   "#define HAVE_LIBJTHREAD 1");
   strcpy(_VoIP[2].undefined, "#undef HAVE_LIBJTHREAD");
   strcpy(_VoIP[2].lib1,      "-ljthreadlib"); /* this one and no other */
   _VoIP[2].lib2[0] = '\0';
   _VoIP[2].lib3[0] = '\0';

   _VoIP[3].enabled = 0;
   strcpy(_VoIP[3].tag,       "voiplib");
   strcpy(_VoIP[3].defined,   "#define HAVE_LIBVOIP 1");
   strcpy(_VoIP[3].undefined, "#undef HAVE_LIBVOIP");
   strcpy(_VoIP[3].lib1,      "-lvoiplib"); /* this one and no other */
   _VoIP[3].lib2[0] = '\0';
   _VoIP[3].lib3[0] = '\0';

   _VoIP[4].enabled = 0;
   strcpy(_VoIP[4].tag,       "libsndfile");
   strcpy(_VoIP[4].defined,   "#define HAVE_LIBSNDFILE 1");
   strcpy(_VoIP[4].undefined, "#undef HAVE_LIBSNDFILE");
   strcpy(_VoIP[4].lib1,      "-lsndfile"); /* this one and no other */
   _VoIP[4].lib2[0] = '\0';
   _VoIP[4].lib3[0] = '\0';
};

int isMatchedConfig(char *str, struct Info List[], int max)
{
   int matched=0, i;
   for(i=0; i < max ; i++){
      if (!strcmp(List[i].defined, str)){
         List[i].enabled = 1;
         return 1;
         }
      }
   return 0;
}

int isEnabled(struct Info List[], int max)
{
   int enabled=0, i;
   for(i=0; i < max ; i++)
      enabled += List[i].enabled;

   if (enabled == max)
      return 1;
   return 0;
}

/*
 * Manually question the user for Yes or No of different features.
 * checks for features found by configure script and written to auto.h
 */
void checkEnabledFeatures(void)
{
   /*
    * Check for Database support
    */
   if (isEnabled(_DataBase, _DataBase_Score))
      selected[_ODBC_]= 1;

   /*
    * Check for "X11 2D Graphics" + "3D Graphics" + "3D Fonts" support
    */
   if (isEnabled(_X11_2DGraphics, _X11_2DGraphics_Score)){
      selected[_2D_X11_] = 1;
      if (isEnabled(_3DGraphics, _3DGraphics_Score)){
         selected[_3D_OpenGL_] = 1;
         if (isEnabled(_3DFonts, _3DFonts_Score))
            selected[_3D_Fonts_] = 1;
         }
      }

   /*
    * Check for "Audio" and "VoIP" support
    */
   if (isEnabled(_Audio, _Audio_Score)){
      selected[_AUDIO_] = 1;
      if (isEnabled(_VoIP, _VoIP_Score))
         selected[_VoIP_] = 1;
      }
}

/*
 * disables features in the auto.h and Makedefs files based
 * on the categorization in InitInfo()
 * and based on the user selection
 */
void disableFeatures(FILE *fout, struct Info List[], int max, int type)
{
   int i;
   fprintf(fout,"\n"
                "/*\n"
                " * The following is disabled by the USER \n"
                " */\n");
   for(i=0; i < max; ++i)
      fprintf(fout,"%s\n",List[i].undefined);
   fprintf(fout,"\n");

   if (type == _ODBC_) {
      for(i=0; i < _AC_LIBS_MAX; ++i)
         if ((!strcmp(List[0].lib1,_AC_LIBS[i])) ||
             ((!strcmp(List[1].lib1,_AC_LIBS[i]) ||
               (!strcmp(List[1].lib2,_AC_LIBS[i])))))
            _AC_LIBS[i][0] = '\0';
      }
   else if ( type == _2D_X11_ ){
      for(i=0; i < _AC_LIBS_MAX; ++i)
         if ((!strcmp(List[0].lib1,_AC_LIBS[i])) ||
             (!strcmp(List[0].lib2,_AC_LIBS[i])))
            _AC_LIBS[i][0] = '\0';
      }
   else if ( type == _3D_OpenGL_ ){
      for(i=0; i < _AC_LIBS_MAX; ++i)
         if ((!strcmp(List[0].lib1,_AC_LIBS[i])) ||
             (!strcmp(List[0].lib2,_AC_LIBS[i])))
            _AC_LIBS[i][0] = '\0';
      }
   else if ( type == _3D_Fonts_ ){
      for(i=0; i < _AC_LIBS_MAX; ++i)
         if (!strcmp(List[0].lib1,_AC_LIBS[i]))
            _AC_LIBS[i][0] = '\0';
         else
            if (!strcmp(List[1].lib1,_AC_LIBS[i]))
               _AC_LIBS[i][0] = '\0';
            else
               if (!strcmp(List[2].lib1,_AC_LIBS[i]))
                  _AC_LIBS[i][0] = '\0';
      }
   else if ( type == _AUDIO_ ){
      for(i=0; i < _AC_LIBS_MAX; ++i)
         if ((!strcmp(List[0].lib1,_AC_LIBS[i])) ||
             (!strcmp(List[0].lib2,_AC_LIBS[i])) ||
             (!strcmp(List[0].lib3,_AC_LIBS[i]))   )
            _AC_LIBS[i][0] = '\0';
         else if(!strcmp(List[1].lib1,_AC_LIBS[i]))
            _AC_LIBS[i][0] = '\0';
         else if(!strcmp(List[2].lib1,_AC_LIBS[i]))
            _AC_LIBS[i][0] = '\0';
         else if(!strcmp(List[3].lib1,_AC_LIBS[i]))
            _AC_LIBS[i][0] = '\0';
      }
   else if ( type == _VoIP_ ){
      for(i=0; i < _AC_LIBS_MAX; ++i)
         if (!strcmp(List[0].lib1,_AC_LIBS[i]))
            _AC_LIBS[i][0] = '\0';
         else if(!strcmp(List[1].lib1,_AC_LIBS[i]))
            _AC_LIBS[i][0] = '\0';
         else if(!strcmp(List[2].lib1,_AC_LIBS[i]))
            _AC_LIBS[i][0] = '\0';
         else if(!strcmp(List[3].lib1,_AC_LIBS[i]))
            _AC_LIBS[i][0] = '\0';
         else if(!strcmp(List[4].lib1,_AC_LIBS[i]))
            _AC_LIBS[i][0] = '\0';
      }
}

void checkSelectedFeatures(FILE *fout)
{
   if (selected[_ODBC_] < 1)
      disableFeatures(fout,_DataBase,_DataBase_Score, _ODBC_);

   if (selected[_2D_X11_] < 1)
      disableFeatures(fout,_X11_2DGraphics,_X11_2DGraphics_Score, _2D_X11_);

   if (selected[_3D_OpenGL_] < 1)
      disableFeatures(fout,_3DGraphics,_3DGraphics_Score, _3D_OpenGL_ );

   if (selected[_3D_Fonts_] < 1)
      disableFeatures(fout,_3DFonts,_3DFonts_Score, _3D_Fonts_);

   if (selected[_AUDIO_] < 1)
      disableFeatures(fout,_Audio,_Audio_Score, _AUDIO_);

   if (selected[_VoIP_] < 1)
      disableFeatures(fout,_VoIP,_VoIP_Score, _VoIP_);

   /*printConfig(_AC_LIBS, _AC_LIBS_MAX);*/
}

/*
 * Traditional checked file opener
 */
FILE *ckopen(char *name, char *mode, char *diagnostic)
{
   FILE *f = fopen (name, mode);
   if (f == NULL){
      printf("\nCannot open %s file %s in mode %s\n", diagnostic, name, mode);
      exit(-1);
      }
   return f;
}

/*
 *  re-writes the h/auto.h header file based on the user selections
 *  Before any call to this function, Makedefs should be read and its
 *  libraries are tokenized
 */
void rewrite_Auto_h(void)
{
   FILE *fin, *fout;
   char line[100];
   char *source = AUTO_H;
   char dest[]  ={"temp.h"};

   fin = ckopen (source, "r", "configuration");
   fout = ckopen (dest, "w", "temporary");

   while(fgets(line, 80, fin) != NULL)
      fprintf(fout,line);

   checkSelectedFeatures(fout);

   fclose(fin);
   fclose(fout);
   system("mv temp.h ./src/h/auto.h");
}

/*
 * reads the auto.h header file
 */
void read_Auto_h()
{
   int i;
   char line [150], prev;
   FILE *fin = ckopen (AUTO_H, "r", "configuration");

   printf("\n%s\n", AUTO_H);
   while(fgets(line, 100, fin) != NULL) {
      if (line[0] == '#') {
         /* remove the \n from the end of the defined macro */
         for(i=1; i< strlen(line); i++){
            prev = line[i-1];
            if ((line[i]=='1') && (prev == ' ')){
               line[i+1]='\0';
               break;
               }
            }
         strcpy(_All_Defined_Macros[_All_Defined_Macros_MAX],line);
         ++_All_Defined_Macros_MAX;
         }
      }
   fclose(fin);
}

void analyze_Auto_h()
{
   int i;

   for(i=0; i < _All_Defined_Macros_MAX; ++i){
      if (isMatchedConfig(_All_Defined_Macros[i], _DataBase, _DataBase_Score))
         continue;
      else if (isMatchedConfig(_All_Defined_Macros[i], _X11_2DGraphics, _X11_2DGraphics_Score))
         continue;
      else if (isMatchedConfig(_All_Defined_Macros[i], _3DGraphics, _3DGraphics_Score))
         continue;
      else if (isMatchedConfig(_All_Defined_Macros[i], _3DFonts, _3DFonts_Score))
         continue;
      else if (isMatchedConfig(_All_Defined_Macros[i], _Audio, _Audio_Score))
         continue;
      else if (isMatchedConfig(_All_Defined_Macros[i], _VoIP, _VoIP_Score))
         continue;
      };
   checkEnabledFeatures();
}

void printConfig(char List[30][40], int max)
{
   int i;

   printf("\n ------- Enabled Features -------\n");
   for(i = 0; i < max;  ++i )
      printf("\n[%-2d] -- [%s]", i, List[i]);
   printf("\n");
}

/*
 * Reads Makedefs and strips out the unwanted libraries
 * It will be handled from the menu() and based on the user selctions.
 */

void tokenize_AC_LIBS(char *line)
{
   char token[20];
   int i = 0, j;

   while(i < strlen(line)) {
      while((line[i] == ' ') || (line[i] == '\t') || (line[i] == '=')) ++i;
      j = 0;
      while((isalpha(line[i])) || (isdigit(line[i])) || (line[i] == '-') || (line[i] == '_'))
         token[j++] = line[i++];
      token[j] ='\0';
      strcpy(_AC_LIBS[_AC_LIBS_MAX], token);
      ++_AC_LIBS_MAX;
      if ((line[i] == '\n') || (line[i] == '\0'))  break;
      }
   /*printConfig(_AC_LIBS, _AC_LIBS_MAX);*/
}

void read_Makedefs()
{
   char line [200];
   FILE *fin = ckopen (MAKEDEFS, "r", "configuration");
   while(fgets(line, 200, fin) != NULL) {
      if ((line[0] == 'A')  && (!strncmp(line,"AC_LIBS",7))){
         tokenize_AC_LIBS(line);
         break;
         }
      }
   fclose(fin);
}

void rewrite_Makedefs(void)
{
   FILE *fin, *fout;
   char line [200];
   char *source = MAKEDEFS;
   char dest[]  = {"Makedefs.tmp"};
   int i;

   fin = ckopen(source, "r", "configuration");
   fout = ckopen (dest, "w", "temporary");

   while(fgets(line, 200, fin) != NULL) {
      if ((line[0] == 'A')  && (!strncmp(line,"AC_LIBS",7))){
         fprintf(fout, "#%s", line);
         fprintf(fout, "%s= ", _AC_LIBS[0]);
         for(i=1; i < _AC_LIBS_MAX; ++i)
            if (_AC_LIBS[i][0] != '\0')
               fprintf(fout, " %s ",_AC_LIBS[i]);
         fprintf(fout,"\n");
         }
      else
         fprintf(fout,"%s", line);
      }

   fclose(fout);
   fclose(fin);

   system("mv Makedefs Makedefs.old");
   system("mv Makedefs.tmp Makedefs");
}

/*
 * The main procedure
 */
int main(int argc, char* argv[])
{
   char options[100]={"make X-Configure name="};

   if (argc < 2) {
      printf("\nUsage: ./build [x86_32_linux | x86_64_linux | x86_32_macos |"
             " ...]\n\n\n");
      exit(-1);
      }

   strcat(options, argv[1]);
   printf("\n\n%s\n", options);

   system(options);

   InitInfo();
   InitSelections();

   read_Auto_h();
   read_Makedefs();
   analyze_Auto_h();
   menu();
   return 0;
}
