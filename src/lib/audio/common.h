#ifndef WIN32
	#include "../../h/auto.h"

	/* OpenAL */
	#include <AL/al.h>
	#include <AL/alc.h>
	#include <AL/alext.h>
#ifdef HAVE_ALUT_H
	#include <AL/alut.h>
#endif					/* HAVE_ALUT_H */
	#include <errno.h>
	#include <time.h>
	#include <sys/stat.h>
	#include <sys/time.h>
	#include <sys/types.h>
	#include <unistd.h>
	#include "base.h"

	static time_t start;
	static ALCcontext *context_id;
	static ALuint stereo;

	/* Ogg Vorbis */
	#include <math.h>
	#include <vorbis/codec.h>
	#include <vorbis/vorbisfile.h>
	//#include <errno.h>
	//#include <unistd.h>
	#include <fcntl.h>
	//#include <sys/types.h>
	#include <sys/ioctl.h>
	#include <linux/soundcard.h>

	/* pthread */
	#include <pthread.h>
	pthread_t AudioThread;

#else  /* WIN32 Audio */
	//#include "../../h/define.h"
	#define HAVE_LIBOGG 1

	#include <windows.h>
	#include <mmsystem.h>
	#include <vorbis/codec.h>
	#include <vorbis/vorbisfile.h>

	/* WIN32 Threads */
	DWORD dwThreadId;
	HANDLE hThread;
#endif /* WIN32 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct AudioFile{
	int doneflag;
	char *fname;
	};

struct AudioFile *FilePtr;

/* Internal Thread Functions Prototypes */
#ifndef WIN32
	void * OpenAL_PlayMP3( void * args );
	void * OpenAL_PlayWAV( void * args );
	void * OpenAL_PlayOgg( void * args );
	void * PlayOggVorbis(void * args);
#endif


/* General Audio Functions */
struct AudioFile * StartMP3Thread(char filename[]);
struct AudioFile * StartWAVThread(char filename[]);
struct AudioFile * StartOggVorbisThread(char filename[]);
struct AudioFile * StartAudioThread(char filename[]);
void StopAudioThread(struct AudioFile * Ptr);


