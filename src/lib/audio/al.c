#include "../../h/auto.h"

#if defined(HAVE_LIBOPENAL) && defined(HAVE_LIBSDL) && defined(HAVE_LIBSMPEG)

#include <AL/base.h>
#include <AL/al.h>
#include "common.h"

#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>
#include <sys/types.h>
#include <unistd.h>

#define GP(x)          alGetProcAddress((const ALubyte *) x)

#ifdef _WIN32
	#include <windows.h>

	void micro_sleep(unsigned int n) {
		Sleep(n / 1000);
		return;
	}

#elif defined(__MORPHOS__)

	#include <clib/amiga_protos.h>

	unsigned sleep(unsigned n) {
		TimeDelay(UNIT_MICROHZ, 0, n*1000);
		return 0;
	}

	void micro_sleep(unsigned int n) {
		TimeDelay(UNIT_MICROHZ, n / 1000000, n % 1000000);
		return;
	}

#elif defined(__APPLE__)
	void micro_sleep(unsigned int n) { usleep(n); }
#else

	void micro_sleep(unsigned int n) {
		struct timeval tv = { 0, 0 };
		tv.tv_usec = n;
		select(0, NULL, NULL, NULL, &tv);
		return;
	}

#endif /* _WIN32 */

	ALfloat	(*talcGetAudioChannel)(ALuint channel);
	void	(*talcSetAudioChannel)(ALuint channel, ALfloat volume);
	void	(*talMute)(void);
	void	(*talUnMute)(void);
	void	(*talReverbScale)(ALuint sid, ALfloat param);
	void	(*talReverbDelay)(ALuint sid, ALfloat param);
	void	(*talBombOnError)(void);
	void	(*talBufferi)(ALuint bid, ALenum param, ALint value);
	void	(*talBufferWriteData)(ALuint bid, ALenum format, ALvoid *data, ALint size, ALint freq, ALenum iFormat);
	ALuint  (*talBufferAppendData)(ALuint bid, ALenum format, ALvoid *data, ALint freq, ALint samples);
	ALuint  (*talBufferAppendWriteData)(ALuint bid, ALenum format, ALvoid *data, ALint freq, ALint samples, ALenum internalFormat);
	ALboolean (*alCaptureInit) ( ALenum format, ALuint rate, ALsizei bufferSize );
	ALboolean (*alCaptureDestroy) ( void );
	ALboolean (*alCaptureStart) ( void );
	ALboolean (*alCaptureStop) ( void );
	ALsizei (*alCaptureGetData) ( ALvoid* data, ALsizei n, ALenum format, ALuint rate );
	void (*talGenStreamingBuffers)(ALsizei n, ALuint *bids );
	ALboolean (*talutLoadRAW_ADPCMData)(ALuint bid,ALvoid *data, ALuint size, ALuint freq,ALenum format);
	ALboolean (*talutLoadIMA_ADPCMData)(ALuint bid,ALvoid *data, ALuint size, ALuint freq,ALenum format);
	ALboolean (*talutLoadMS_ADPCMData)(ALuint bid,ALvoid *data, ALuint size, ALuint freq,ALenum format);

	void fixup_function_pointers(void) {
		talcGetAudioChannel = (ALfloat (*)(ALuint channel))	GP("alcGetAudioChannel_LOKI");
		talcSetAudioChannel = (void (*)(ALuint channel, ALfloat volume)) GP("alcSetAudioChannel_LOKI");

		talMute   = (void (*)(void)) GP("alMute_LOKI");
		talUnMute = (void (*)(void)) GP("alUnMute_LOKI");

		talReverbScale = (void (*)(ALuint sid, ALfloat param))GP("alReverbScale_LOKI");
		talReverbDelay = (void (*)(ALuint sid, ALfloat param))GP("alReverbDelay_LOKI");

		talBombOnError = (void (*)(void))GP("alBombOnError_LOKI");

		if(talBombOnError == NULL) {
			fprintf(stderr,	"Could not GetProcAddress alBombOnError_LOKI\n");
			exit(1);
		}

		talBufferi = (void (*)(ALuint, ALenum, ALint ))	GP("alBufferi_LOKI");

		if(talBufferi == NULL) {
			fprintf(stderr,	"Could not GetProcAddress alBufferi_LOKI\n");
			exit(1);
		}

		alCaptureInit    = (ALboolean (*)( ALenum, ALuint, ALsizei )) GP("alCaptureInit_EXT");
		alCaptureDestroy = (ALboolean (*)( void )) GP("alCaptureDestroy_EXT");
		alCaptureStart   = (ALboolean (*)( void )) GP("alCaptureStart_EXT");
		alCaptureStop    = (ALboolean (*)( void )) GP("alCaptureStop_EXT");
		alCaptureGetData = (ALsizei (*)( ALvoid*, ALsizei, ALenum, ALuint )) GP("alCaptureGetData_EXT");


		talBufferWriteData = (PFNALBUFFERWRITEDATAPROC) GP("alBufferWriteData_LOKI");
		if(talBufferWriteData == NULL)
		{
			fprintf( stderr, "Could not GP alBufferWriteData_LOKI\n" );
			exit(1);
		}

		talBufferAppendData = (ALuint (*)(ALuint, ALenum, ALvoid *, ALint, ALint)) GP("alBufferAppendData_LOKI");
		talBufferAppendWriteData = (ALuint (*)(ALuint, ALenum, ALvoid *, ALint, ALint, ALenum)) GP("alBufferAppendWriteData_LOKI");

		talGenStreamingBuffers = (void (*)(ALsizei n, ALuint *bids )) GP("alGenStreamingBuffers_LOKI");
		if( talGenStreamingBuffers == NULL ) {
			fprintf( stderr, "Could not GP alGenStreamingBuffers_LOKI\n");
			exit(1);
		}

		talutLoadRAW_ADPCMData = (ALboolean (*)(ALuint bid,ALvoid *data, ALuint size, ALuint freq,ALenum format)) GP("alutLoadRAW_ADPCMData_LOKI");
		if( talutLoadRAW_ADPCMData == NULL ) {
			fprintf( stderr, "Could not GP alutLoadRAW_ADPCMData_LOKI\n");
			exit(1);
		}

		talutLoadIMA_ADPCMData = (ALboolean (*)(ALuint bid,ALvoid *data, ALuint size, ALuint freq,ALenum format)) GP("alutLoadIMA_ADPCMData_LOKI");
		if( talutLoadIMA_ADPCMData == NULL ) {
			fprintf( stderr, "Could not GP alutLoadIMA_ADPCMData_LOKI\n");
			exit(1);
		}

		talutLoadMS_ADPCMData = (ALboolean (*)(ALuint bid,ALvoid *data, ALuint size, ALuint freq,ALenum format)) GP("alutLoadMS_ADPCMData_LOKI");
		if( talutLoadMS_ADPCMData == NULL ) {
			fprintf( stderr, "Could not GP alutLoadMS_ADPCMData_LOKI\n");
			exit(1);
		}


		return;
	}

	ALboolean SourceIsPlaying(ALuint sid) {
		ALint state;

		if(alIsSource(sid) == AL_FALSE) {
			return AL_FALSE;
		}

		state = AL_INITIAL;
		alGetSourceiv(sid, AL_SOURCE_STATE, &state);
		switch(state) {
			case AL_PLAYING:
			case AL_PAUSED:	  return AL_TRUE;
		default:
		  	break;
		}

		return AL_FALSE;
	}


	#define DATABUFSIZE_MP3 	4098
	#define MP3_FUNC    		"alutLoadMP3_LOKI"
	#define NUMSOURCES  		1

	static ALuint mp3buf; /* our buffer */
	static ALuint mp3source = (ALuint ) -1;
	/* our mp3 extension */
	typedef ALboolean (mp3Loader)(ALuint, ALvoid *, ALint);
	mp3Loader *alutLoadMP3p = NULL;

	static void initMP3( void )
	{
		start = time(NULL);
		alGenBuffers( 1, &mp3buf);
		alGenSources( 1, &mp3source);
		alSourcei(  mp3source, AL_BUFFER, mp3buf );
		alSourcei(  mp3source, AL_LOOPING, AL_FALSE );
		return;
	}

	static void cleanupMP3(void)
	{
		alcDestroyContext(context_id);
	#ifdef JLIB
		jv_check_mem();
	#endif
	}

	void * OpenAL_PlayMP3( void * args )
	{
		ALCdevice *dev;
		FILE *fh;
		struct stat sbuf;
		void *data;
		int i = 0;
		int size;

		dev = alcOpenDevice( NULL );
		if( dev == NULL ) {
			return NULL;}

		/* Initialize ALUT. */
		context_id = alcCreateContext( dev, NULL );
		if(context_id == NULL) {
			alcCloseDevice( dev );
			return NULL;}

		alcMakeContextCurrent( context_id );
		fixup_function_pointers();
		initMP3();

		/* the global fname */
		if(stat(FilePtr->fname, &sbuf) == -1) {
			perror(FilePtr->fname);
			return NULL;/*errno;*/}
		size = sbuf.st_size;
		data = malloc(size);
		if(data == NULL) {
			exit(1);}
		fh = fopen(FilePtr->fname, "rb");

		if(fh == NULL) {
			fprintf(stderr, "Could not open %s\n", FilePtr->fname);
			free(data);
			exit(1);}

		fread(data, 1, size, fh);
		alutLoadMP3p = (mp3Loader *) alGetProcAddress((ALubyte *) MP3_FUNC);

		if(alutLoadMP3p == NULL) {
			free(data);
			fprintf(stderr, "Could not GetProc %s\n",(ALubyte *) MP3_FUNC);
			exit(-4);}

		if(alutLoadMP3p(mp3buf, data, size) != AL_TRUE) {
			fprintf(stderr, "alutLoadMP3p failed\n");
			exit(-2);}

		free(data);
		alSourcePlay( mp3source );
		while(SourceIsPlaying(mp3source) == AL_TRUE) {
			sleep(1);
			if(FilePtr->doneflag)	break; /* stop playing */
		}
		cleanupMP3();
		alcCloseDevice( dev );
		return NULL;
	}/* End OpenAL_PlayMP3 */
#endif /* if(HAVE_OPENAL && HAVE_LIBSDL && HAVE_LIBSMPEG) */


#ifdef HAVE_LIBOPENAL
	#define DATABUFSIZE 		4096
	#define VORBIS_FUNC		"alutLoadVorbis_LOKI"
	static ALuint vorbbuf; /* our buffer */
	static ALuint vorbsource = (ALuint ) -1;

	/* our vorbis extension */
	typedef ALboolean (vorbisLoader)(ALuint, ALvoid *, ALint);
	vorbisLoader *alutLoadVorbisp = NULL;

	static void initOggVorbis( void )
	{
		start = time(NULL);
		alGenBuffers( 1, &vorbbuf);
		alGenSources( 1, &vorbsource);
		alSourcei(  vorbsource, AL_BUFFER, vorbbuf );
		alSourcei(  vorbsource, AL_LOOPING, AL_TRUE );
		return;
	}

	static void cleanupOggVorbis(void)
	{
		alcDestroyContext(context_id);
	#ifdef JLIB
		jv_check_mem();
	#endif
	}

	void * OpenAL_PlayOgg( void * args ) /* the OggVorbis Thread function */
	{
		ALCdevice *dev;
		FILE *fh;
		struct stat sbuf;
		void *data;
		int size;
		int i = 0;

		dev = alcOpenDevice( NULL );
		if( dev == NULL ) {
			return NULL;}

		/* Initialize ALUT. */
		context_id = alcCreateContext( dev, NULL );
		if(context_id == NULL) {
			alcCloseDevice( dev );
			return NULL;}

		alcMakeContextCurrent( context_id );
		fixup_function_pointers();
		initOggVorbis();

		/* the global fname */
		if(stat(FilePtr->fname, &sbuf) == -1) {
			perror(FilePtr->fname);
			return NULL;/*errno;*/}

		size = sbuf.st_size;
		data = malloc(size);
		if(data == NULL) {
			exit(1);}

		fh = fopen(FilePtr->fname, "rb");
		if(fh == NULL) {
			fprintf(stderr, "Could not open %s\n", FilePtr->fname);
			free(data);
			exit(1);}

		fread(data, size, 1, fh);

		alutLoadVorbisp = (vorbisLoader *) alGetProcAddress((ALubyte *) VORBIS_FUNC);
		if(alutLoadVorbisp == NULL) {
			free(data);

			fprintf(stderr, "Could not GetProc %s\n",
				(ALubyte *) VORBIS_FUNC);
			exit(-4);}

		if(alutLoadVorbisp(vorbbuf, data, size) != AL_TRUE) {
			fprintf(stderr, "alutLoadVorbis failed\n");
			exit(-2);}

		free(data);

		alSourcePlay( vorbsource );

		while(SourceIsPlaying(vorbsource) == AL_TRUE) {
			sleep(1);
			if(FilePtr->doneflag)	break;/* break the thread and stop playing */
		}
		cleanupOggVorbis();
		alcCloseDevice( dev );
		return NULL;
	} /* End OpenAL_PlayOgg  */
#endif 	/* HAVE_LIBOPENAL */



#ifdef HAVE_LIBOPENAL
	#define WAV_DATABUFFERSIZE (10 * (512 * 3) * 1024)
	static ALuint moving_source = 0;

	static void iterateWAV( void )
	{
		static ALfloat position[] = { 10.0, 0.0, 4.0 };
		static ALfloat movefactor = 4.5;
		static time_t then = 0;
		time_t now;
		ALint byteloki;
		ALint size;

		now = time( NULL );

		/* Switch between left and right stereo sample every two seconds. */
		if( now - then > 2 ) {
			then = now;
			movefactor *= -1.0;}

		position[0] += movefactor;
		alSourcefv( moving_source, AL_POSITION, position );
		micro_sleep(500000);
		return;
	}

	static void initWAV(void)
	{
		FILE *fh;
		ALfloat zeroes[] = { 0.0f, 0.0f,  0.0f };
		ALfloat back[]   = { 0.0f, 0.0f, -1.0f, 0.0f, 1.0f, 0.0f };
		ALfloat front[]  = { 0.0f, 0.0f,  1.0f, 0.0f, 1.0f, 0.0f };
		ALsizei size;
		ALsizei bits;
		ALsizei freq;
		ALsizei format;
		int filelen;
		ALint err;
		static void *data = (void *) 0xDEADBEEF;

		data = malloc(WAV_DATABUFFERSIZE);
		start = time(NULL);
		alListenerfv(AL_POSITION, zeroes );
		/* alListenerfv(AL_VELOCITY, zeroes ); */
		alListenerfv(AL_ORIENTATION, front );
		alGenBuffers( 1, &stereo);
		fh = fopen(FilePtr->fname, "rb");
		printf("\n FilePtr->fname = [%s]\n",FilePtr->fname);
		if(fh == NULL) {
			fprintf(stderr, "Couldn't open fname\n");
			exit(1);}

		filelen = fread(data, 1, WAV_DATABUFFERSIZE, fh);
		fclose(fh);
		alGetError();

		/* sure hope it's a wave file */
		alBufferData( stereo, AL_FORMAT_WAVE_EXT, data, filelen, 0 );
		if( alGetError() != AL_NO_ERROR ) {
			fprintf(stderr, "Could not BufferData\n");
			exit(1);}

		free(data);
		alGenSources( 1, &moving_source);
		alSourcei(  moving_source, AL_BUFFER, stereo );
		alSourcei(  moving_source, AL_LOOPING, AL_TRUE);
		return;
	}

	static void cleanupWAV(void)
	{
	#ifdef JLIB
		jv_check_mem();
	#endif
	}

	void * OpenAL_PlayWAV( void * args ) /* the WAV thread function */
	{
		ALCdevice *dev;
		int attrlist[] = { ALC_FREQUENCY, 22050,ALC_INVALID };
		time_t shouldend;

		dev = alcOpenDevice( NULL );
		if( dev == NULL ) {
			fprintf(stderr, "Could not open device\n");
			return NULL;}

		/* Initialize ALUT. */
		context_id = alcCreateContext( dev, attrlist );
		if(context_id == NULL) {
			fprintf(stderr, "Could not open context: %s\n",
				alGetString( alcGetError(dev) ));
			return NULL;}

		alcMakeContextCurrent( context_id );
		fixup_function_pointers();
		talBombOnError();
		initWAV();
		alSourcePlay( moving_source );

		while(SourceIsPlaying( moving_source ) == AL_TRUE) {
			iterateWAV();
			shouldend = time(NULL);
			if((shouldend - start) > 30) {
				alSourceStop(moving_source);}
			if(FilePtr->doneflag == 1)
				break; /* break the thread and stop playing */
		}
		cleanupWAV();
		alcDestroyContext( context_id );
		alcCloseDevice(  dev  );
		return NULL;
	}
#else
static char c;
#endif /* HAVE_LIBOPENAL */
