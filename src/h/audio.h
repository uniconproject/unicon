/*
 * audio.h - audio structure used in Unicon's audio interface
 */

 struct AudioFile{
        int doneflag;
        char* fname;
        };

typedef struct AudioFile AudioStruct;
typedef struct AudioFile * AudioPtr;
