/*
 * Direct 3D port of the 3D facilities. Not implemented yet.
 */

/*
 * Redefinitions of various OpenGL integer scalar values.
 * Using these names, portable code can function without OpenGL.
 * If OpenGL is present, they are defined as OpenGL-native, see opengl.h
 * On other platforms, they may be a simple integer enumeration or may be
 * redefined to values native to that platform.
 */

#define U3D_POINTS         1
#define U3D_LINES          2
#define U3D_LINE_STRIP     3
#define U3D_LINE_LOOP      4
#define U3D_TRIANGLES      5
#define U3D_TRIANGLE_FAN   6
#define U3D_TRIANGLE_STRIP 7
#define U3D_QUADS          8
#define U3D_QUAD_STRIP     9
#define U3D_POLYGON       10

#define U3D_REPLACE      100
#define U3D_BLEND        101
#define U3D_MODULATE     102

#define GLfloat float
#define GLubyte unsigned char
#define GLuint unsigned int

