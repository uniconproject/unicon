#include "../h/define.h"
#ifndef NoAuto
#include "../h/auto.h"
#endif

#include <stdio.h>
#include <stdlib.h>

#if HAVE_LIBGL && HAVE_FTGL
#include <GL/gl.h>
// #include <GL/glut.h>


#include "FTGLOutlineFont.h"
#include "FTGLPolygonFont.h"
#include "FTGLBitmapFont.h"
#include "FTGLTextureFont.h"
#include "FTGLPixmapFont.h"
#include "FTGLExtrdFont.h"


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
#if 0
   glColor3f(1.0, 1.0, 1.0);
#endif

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

#else					/* HAVE_LIBGL && HAVE_FTGL */

extern "C" int cpp_drawstring3d(double x, double y, double z, char *s,
				char *f, int t, int size, void **tfont)
{
	fprintf(stderr,"no OpenGL/FTGL, cannot drawstring3d\n");
	fflush(stderr);
	exit(-1);
}

#endif					/* HAVE_LIBGL && HAVE_FTGL */

/*
static void
do_ortho()
{
  int w;
  int h;
  GLdouble size;
  GLdouble aspect;

  w = width;
  h = height;
  aspect = (GLdouble)w / (GLdouble)h;

  // Use the whole window.
  glViewport(0, 0, w, h);

  // We are going to do some 2-D orthographic drawing.
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  size = (GLdouble)((w >= h) ? w : h) / 2.0;
  if (w <= h) {
    aspect = (GLdouble)h/(GLdouble)w;
    glOrtho(-size, size, -size*aspect, size*aspect,
            -100000.0, 100000.0);
  }
  else {
    aspect = (GLdouble)w/(GLdouble)h;
    glOrtho(-size*aspect, size*aspect, -size, size,
            -100000.0, 100000.0);
  }

  // Make the world and window coordinates coincide so that 1.0 in
  // model space equals one pixel in window space.
  glScaled(aspect, aspect, 1.0);

   // Now determine where to draw things.
  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity();
}
*/

/*
void
draw_scene()
{
   glColor3f(1.0, 1.0, 1.0);

   GLfloat x = -250.0;
   GLfloat y;
   GLfloat yild = 20.0;
   y = 275.0-font*120.0-j*yild;
   if (t == 2) {
     glEnable(GL_TEXTURE_2D);
     glEnable(GL_BLEND);
     glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
   }
   glPushMatrix(); {
     glTranslatef(x, y, z);
     fonts->Render(s);
   } glPopMatrix();
   if (font == 2) {
     glDisable(GL_TEXTURE_2D);
     glDisable(GL_BLEND);
   }
}

*/

