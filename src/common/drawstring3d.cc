#include "../h/define.h"
#ifndef NoAuto
#include "../h/auto.h"
#endif

#include <stdio.h>
#include <stdlib.h>

#if HAVE_LIBGL && HAVE_LIBFTGL
#include <GL/gl.h>
#include <FTGL/ftgl.h>

static FTFont *fonts;
// static int width;
// static int height;

extern "C" int cpp_drawstring3d(double x, double y, double z, char *s,
                                char *f, int t, int size, void **tfont)
{
   FTFont **fp;
   int point_size=size;

   fp = (FTFont **) tfont;
   if (*tfont) {
      fonts = *fp;
      }
   else {
      switch (t) {
      case 0: fonts = new FTGLOutlineFont(f); break;
      case 1: fonts = new FTGLPolygonFont(f); break;
      case 2: fonts = new FTGLTextureFont(f); break;
      case 3: fonts = new FTGLBitmapFont(f); break;
      case 4: fonts = new FTGLPixmapFont(f); break;
      case 5: fonts = new FTGLExtrdFont(f); break;
      }
      }

   if (!fonts->FaceSize(point_size)) {
      /* Unable to support point_size */
      printf("ERROR: Unable to set font face size %d\n", point_size);
      return 1;
      }

   if (t == 2) {
      glEnable(GL_TEXTURE_2D);
      glEnable(GL_BLEND);
      glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
      }
   glPushMatrix();
      glTranslatef(x, y, z);
      fonts->Render(s);
   glPopMatrix();
   if (t == 2) {
      glDisable(GL_TEXTURE_2D);
      glDisable(GL_BLEND);
      }
   if (!*tfont) *fp = fonts;
   return 0;
}

#else                                   /* HAVE_LIBGL && HAVE_FTGL */

extern "C" int cpp_drawstring3d(double x, double y, double z, char *s,
                                char *f, int t, int size, void **tfont)
{
        fprintf(stderr,"no OpenGL/FTGL, cannot drawstring3d\n");
        fflush(stderr);
        exit(-1);
}

#endif                                  /* HAVE_LIBGL && HAVE_FTGL */
