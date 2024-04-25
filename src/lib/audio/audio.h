/* Tha Audio data Structure and Functions needed
 * by the Unicon VM
 * May 24, 2005
 * zsharif@cs.nmsu.edu
 */

 struct AudioFile{
        int doneflag;
        char* fname;
        };

typedef struct AudioFile AudioStruct;
typedef struct AudioFile * AudioPtr;

struct AudioFile * StartAudioTread(char filename[]);
void StopAudioThread(struct AudioFile * Ptr);

struct AudioFile * StartMP3Thread(char filename[]);
struct AudioFile * StartWAVThread(char filename[]);
struct AudioFile * StartOggVorbisThread(char filename[]);

