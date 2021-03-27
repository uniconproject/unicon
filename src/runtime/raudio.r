/*
 * raudio.r - runtime support for audio facilities
 *
 * This file contains Audio API functions on top of OpenAL to play MP3,
 * Ogg Vorbis, and WAV. StartAudioThread(filename) is the main function,
 * where filename is any of the three formats.
 *
 * TODO: eliminate absurd hodgepodge of pthreads vs. Windows threads,
 * for example use of pthread_mutexes when Windows threads are in use.
 *
 * TODO: contemplate whether alcOpenDevice() and alcCreateContext() are needed.
 */
#ifdef Audio
 
struct sSources
{
   ALuint source;
   int inUse;
   int numBuffers;
   char filename[255];
   ALuint buffer[4];
   ALuint wBuffer;
   ALuint mBuffer;
   ALenum format;
   pthread_t thread;
#ifdef WIN32
   HANDLE hThread;
#endif

#if (defined(HAVE_LIBVORBIS) && defined(HAVE_LIBOGG))
   struct OggVorbis_File oggStream;
   struct vorbis_info *vorbisInfo;
#endif
};

struct sSources arraySource[16];
int isPlaying = -1;
int isSet = 0;
int gIndex;
pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;


void audio_exit()
{
   int i;
   ALCcontext *Context;
   ALCdevice *Device;

   if (isPlaying == -1) return;

   if (pthread_mutex_lock(&mutex) != 0) return;

   for (i=0; i<16; i++) {
      alDeleteBuffers(4, arraySource[i].buffer);
      alDeleteBuffers(1, &(arraySource[i].mBuffer));
      alDeleteBuffers(1, &(arraySource[i].wBuffer));
      alDeleteSources(1, &(arraySource[i].source));
      }

   Context = alcGetCurrentContext();
   Device = alcGetContextsDevice(Context);
   alcMakeContextCurrent(NULL);
   alcDestroyContext(Context);
   alcCloseDevice(Device);

/* we are dieing. The audio threads can just hang. we certainly don't want
   them trying to use our freed-up buffers and sources and stuff.
  if (pthread_mutex_unlock(&mutex) != 0) return; */

}

/*
 * Get a valid audio Source struct to work with. Return -1 on error.
 */
int GetIndex()
{
   int i;
   if (pthread_mutex_lock(&mutex) != 0) return -1;
   for(i = 0; i < 16; ++i) {
      if (arraySource[i].inUse == 0)
	 break;
      }
   if (i < 16)
      arraySource[i].inUse += 1;
   if (pthread_mutex_unlock(&mutex) != 0) return -1;
   return (i<16 ? i : -1);
}

void MixUnInitialize();
int MixInitialize();
int LinuxMixer(char * cmd);

#if defined(WIN32) && defined(HAVE_LIBOGG)
WAVEFORMATEX waveformater;
HWAVEOUT hwave;
struct BufferInfo {
   int nused;
   CRITICAL_SECTION criticalsection;
   HANDLE huponfree;
};

struct BufferInfo *newBufferInfo()
{
   struct BufferInfo *bi = malloc(sizeof(struct BufferInfo));
   if (bi == NULL) return NULL;
   bi->nused = 0;
   InitializeCriticalSection(&(bi->criticalsection));
   bi->huponfree = CreateEvent(NULL,FALSE,FALSE,NULL);
   return bi;
}

void deleteBufferInfo(struct BufferInfo *bi)
{
   DeleteCriticalSection(&(bi->criticalsection));
   CloseHandle(bi->huponfree);
   free(bi);
}

void CALLBACK PlayCallback(HWAVEOUT, UINT msg, DWORD param, DWORD, DWORD)
{
   if (msg != WOM_DONE)
      return;

   /* invariant: if a buffer is being freed, then nused>0. */
   struct BufferInfo *bufferinfo = (struct BufferInfo*)(DWORD_PTR)param;
   EnterCriticalSection(&(bufferinfo->criticalsection));
   bufferinfo->nused--;
   LeaveCriticalSection(&(bufferinfo->criticalsection));
   SetEvent(bufferinfo->huponfree);
}

struct BufferInfo bufferinfo;

int audioDevice(int channels, int rate)
{
   waveformater.wFormatTag =  WAVE_FORMAT_PCM;
   waveformater.nChannels  =  (WORD)channels;
   waveformater.wBitsPerSample  = 16;
   waveformater.nBlockAlign     = (WORD)((waveformater.wBitsPerSample>>3) *
					 waveformater.nChannels);
   waveformater.nSamplesPerSec  = rate;
   waveformater.nAvgBytesPerSec = waveformater.nSamplesPerSec *
                                     waveformater.nBlockAlign;
   if (waveOutOpen(&hwave,WAVE_MAPPER,&waveformater,(DWORD_PTR)PlayCallback,
		   (DWORD_PTR)&bufferinfo,CALLBACK_FUNCTION) ==
      MMSYSERR_NOERROR ){
      /* should report the error more specifically somehow. &errno? */
      return 0;
      }
   return 0;
}

DWORD WINAPI PlayOggVorbisWIN32(void * params)
{
   FILE *fd;
   const int nbuffers = 5, buffersize = (8 * 4096);
   unsigned int numsamples, numbytes, currentbuffer = 0, totprogress=0;
   int i, current_section = 0;
   WAVEHDR headers[nbuffers], *header;
   bool okay;
   int index = gIndex;
   isSet = 0;
   if (pthread_mutex_lock(&mutex) != 0) return NULL;
   isPlaying += 1;
   if (pthread_mutex_unlock(&mutex) != 0) return NULL;

   if ((fd = fopen(arraySource[index].filename, "rb")) == NULL) {
      /*
       * can't open file, fail
       */
      goto cleanup;
      }

   /*
    * A note from https://xiph.org/vorbis/doc/vorbisfile/ov_open.html says
    * Do not use ov_open() in Windows applications.
    */
   if (ov_open(fd, &(arraySource[index].oggStream), NULL, 0) < 0) {
      /*
       * ogg open failed for some reason; fail
       */
   closefail:
      fclose(fd);
      goto cleanup;
      }

   if (!ov_seekable(&arraySource[index].oggStream)) {
      ov_clear(&arraySource[index].oggStream);
      /*
       * ogg seekable failed for some reason; fail
       */
      goto closefail;
      }

   arraySource[index].vorbinfo = ov_info(&arraySource[index].oggStream,-1);

   numsamples = (unsigned int)ov_pcm_total(&arraySource[index].oggStream,0);
   numbytes = numsamples * arraySource[index].vorbinfo->channels *
      waveformater.wBitsPerSample > 1;

   if (audioDevice(arraySource[index]vorbinfo->channels,
		   arraySource[index].vorbinfo->rate)){
      /*
       * Error setting up audio device; fail.
       */
      goto closefail;
      }
   for (i=0; i < nbuffers; i++) {
      ZeroMemory(&headers[i],sizeof(WAVEHDR));
      headers[i].lpData = (LPSTR)LocalAlloc(LMEM_FIXED, buffersize);
      headers[i].dwBufferLength=buffersize;
      waveOutPrepareHeader(hwave, &headers[i], sizeof(WAVEHDR));
      }
   while (1) {
      for (okay=false; !okay; ) {
	 EnterCriticalSection(&bufferinfo.criticalsection);
	 if (bufferinfo.nused<nbuffers) {
	    bufferinfo.nused++;
	    okay=true;
	    }
	 LeaveCriticalSection(&bufferinfo.criticalsection);
	 if (!okay)
	    WaitForSingleObject(bufferinfo.huponfree,INFINITE);
	}

      header = &(headers[currentbuffer]);

      for (header->dwBufferLength=0; header->dwBufferLength<buffersize; ) {
	 long ret = 0;
	 if ((ret = ov_read( &arraySource[index].vorbinfo,
			     header->lpData+header->dwBufferLength,
			     buffersize - header->dwBufferLength, 0, 2, 1,
			     &current_section ) ) <= 0 ) {
	    break;
	    }
	 header->dwBufferLength += ret;
	 totprogress+=header->dwBufferLength;
	 }

      currentbuffer = (currentbuffer + 1)% nbuffers;
      waveOutWrite(hwave, header, sizeof(WAVEHDR));

      if (header->dwBufferLength==0) {
	 break;
	 }
      }

   for (okay=false; !okay; ) {
      EnterCriticalSection(&bufferinfo.criticalsection);
      okay = (bufferinfo.nused==0);
      LeaveCriticalSection(&bufferinfo.criticalsection);
      if (!okay)
	 WaitForSingleObject( bufferinfo.huponfree, INFINITE );
      }
   waveOutReset(hwave);

   for (i=0; i<nbuffers; i++) {
      waveOutUnprepareHeader( hwave, &headers[i], sizeof(WAVEHDR) );
      LocalFree( headers[i].lpData );
      }

   waveOutClose(hwave);
   ov_clear(&arraySource[index].oggStream);
   alSourcei(arraySource[index], AL_BUFFER, 0);
   /* fclose(fd); // Casing Error */

 cleanup:
   if (pthread_mutex_lock(&mutex) == 0) {
      isPlaying -= 1;
      arraySource[index].inUse -= 1;
      pthread_mutex_unlock(&mutex);
      }
   return 0;
}

#endif  /*#if WIN32 && HAVE_LIBOGG */

#if !defined(WIN32) && defined(HAVE_LIBOPENAL)
	
        #passthru #include <AL/alut.h>

#else
	DWORD dwThreadId;
	HANDLE hThread;
#endif

/*function pointer for LOKI extensions */
ALfloat	(*talcGetAudioChannel)(ALuint channel);
void	(*talcSetAudioChannel)(ALuint channel, ALfloat volume);

void	(*talMute)(void);
void	(*talUnMute)(void);

void	(*talReverbScale)(ALuint sid, ALfloat param);
void	(*talReverbDelay)(ALuint sid, ALfloat param);
void	(*talBombOnError)(void);

void	(*talBufferi)(ALuint bid, ALenum param, ALint value);

typedef void	(*tbwd)(ALuint bid, ALenum format, ALvoid *data,
			      ALint size, ALint freq, ALenum iFormat);
void	(*talBufferWriteData)(ALuint bid, ALenum format, ALvoid *data,
			      ALint size, ALint freq, ALenum iFormat);

ALuint  (*talBufferAppendData)(ALuint bid, ALenum format, ALvoid *data,
			       ALint freq, ALint samples);
ALuint  (*talBufferAppendWriteData)(ALuint bid, ALenum format, ALvoid *data,
				    ALint freq, ALint samples,
				    ALenum internalFormat);

ALboolean (*alCaptureInit) ( ALenum format, ALuint rate, ALsizei bufferSize );
ALboolean (*alCaptureDestroy) ( void );
ALboolean (*alCaptureStart) ( void );
ALboolean (*alCaptureStop) ( void );
ALsizei (*alCaptureGetData) ( ALvoid* data, ALsizei n, ALenum format,
			     ALuint rate );

/* new ones */
void (*talGenStreamingBuffers)(ALsizei n, ALuint *bids );
ALboolean (*talutLoadRAW_ADPCMData)(ALuint bid,
				ALvoid *data, ALuint size, ALuint freq,
				ALenum format);
ALboolean (*talutLoadIMA_ADPCMData)(ALuint bid,
				ALvoid *data, ALuint size, ALuint freq,
				ALenum format);
ALboolean (*talutLoadMS_ADPCMData)(ALuint bid,
				ALvoid *data, ALuint size, ALuint freq,
				ALenum format);

#define GP(x)  alGetProcAddress((const ALchar *) x)


void micro_sleep(unsigned int n)
{
   struct timeval tv = { 0, 0 };
   tv.tv_usec = n;
   select(0, NULL, NULL, NULL, &tv);
   return;
}

#if defined(HAVE_LIBOPENAL)
/*
 * Assign dynamic OpenAL extension function pointers. There are numerous
 * failure points possible. Return 1 for success, 0 for failure.
 */
int fixup_function_pointers(void)
{
   talcGetAudioChannel = (ALfloat (*)(ALuint channel))
			    GP("alcGetAudioChannel_LOKI");
   if (talcGetAudioChannel == NULL)
      return 0;

   Protect(talcSetAudioChannel = (void (*)(ALuint channel, ALfloat volume))
      GP("alcSetAudioChannel_LOKI"), return 0);
/*   Protect(talMute   = (void (*)(void)) GP("alMute_LOKI"), return 0);*/
/*   Protect(talUnMute = (void (*)(void)) GP("alUnMute_LOKI"), return 0); */
   Protect(talReverbScale = (void (*)(ALuint sid, ALfloat param))
      GP("alReverbScale_LOKI"), return 0);
   Protect(talReverbDelay = (void (*)(ALuint sid, ALfloat param))
      GP("alReverbDelay_LOKI"), return 0);
   talBombOnError = (void (*)(void))GP("alBombOnError_LOKI");

   if (talBombOnError == NULL) {
      /*
       * Could not GetProcAddress alBombOnError_LOKI; fail.
       */
      return 0;
      }
   talBufferi = (void (*)(ALuint, ALenum, ALint ))	GP("alBufferi_LOKI");
   if (talBufferi == NULL) {
      /*
       * Could not GetProcAddress alBufferi_LOKI; fail.
       */
      return 0;
      }
   alCaptureInit    = (ALboolean (*)( ALenum, ALuint, ALsizei ))
      GP("alCaptureInit_EXT");
   alCaptureDestroy = (ALboolean (*)( void )) GP("alCaptureDestroy_EXT");
   alCaptureStart   = (ALboolean (*)( void )) GP("alCaptureStart_EXT");
   alCaptureStop    = (ALboolean (*)( void )) GP("alCaptureStop_EXT");
   alCaptureGetData = (ALsizei (*)( ALvoid*, ALsizei, ALenum, ALuint ))
      GP("alCaptureGetData_EXT");
   talBufferWriteData = (tbwd)GP("alBufferWriteData_LOKI");
   if(talBufferWriteData == NULL) {
      /*
       * Could not GP alBufferWriteData_LOKI; fail.
       */
      return 0;
      }
   talBufferAppendData = (ALuint (*)(ALuint, ALenum, ALvoid *, ALint, ALint))
      GP("alBufferAppendData_LOKI");
   talBufferAppendWriteData = (ALuint (*)(ALuint, ALenum, ALvoid *, ALint,
					  ALint, ALenum))
      GP("alBufferAppendWriteData_LOKI");

   talGenStreamingBuffers = (void (*)(ALsizei n, ALuint *bids ))
      GP("alGenStreamingBuffers_LOKI");
   if( talGenStreamingBuffers == NULL ) {
      /*
       * Could not GP alGenStreamingBuffers_LOKI; fail.
       */
      return 0;
      }
/*   talutLoadRAW_ADPCMData = (ALboolean (*)(ALuint bid,ALvoid *data,
					   ALuint size, ALuint freq,
					   ALenum format))
      GP("alutLoadRAW_ADPCMData_LOKI");
   if (talutLoadRAW_ADPCMData == NULL) {
       * 
       * Could not GP alutLoadRAW_ADPCMData_LOKI; fail.
       *
      return 0; 
      }
   talutLoadIMA_ADPCMData = (ALboolean (*)(ALuint bid,ALvoid *data,
					   ALuint size, ALuint freq,
					   ALenum format))
      GP("alutLoadIMA_ADPCMData_LOKI");
   if (talutLoadIMA_ADPCMData == NULL) {
       * 
       * Could not GP alutLoadIMA_ADPCMData_LOKI; fail.
       *
      return 0; 
      }

   talutLoadMS_ADPCMData = (ALboolean (*)(ALuint bid,ALvoid *data, ALuint size,
			        	  ALuint freq,ALenum format))
                           GP("alutLoadMS_ADPCMData_LOKI");
   if( talutLoadMS_ADPCMData == NULL ) {
       * 
       * Could not GP alutLoadMS_ADPCMData_LOKI; fail.
       *
      return 0; 
      }
*/
   return 1;
}

#endif					/* HAVE_LIBOPENAL */

#if defined(HAVE_LIBOPENAL) && defined(HAVE_LIBSDL) && defined(HAVE_LIBSMPEG)
/* The following is for MP3 Support on top of OpenAL */
#define DATABUFSIZE_MP3 	(8 * 4098)
#define MP3_FUNC    		"alutLoadMP3_LOKI"

/* our mp3 extension */
typedef ALboolean (mp3Loader)(ALuint, ALvoid *, ALint);
mp3Loader *alutLoadMP3p = NULL;

static void initMP3( int index )
{
   alSourceQueueBuffers(arraySource[index].source, 1,
			&(arraySource[index].mBuffer ));
   alSourcei(  arraySource[index].source, AL_LOOPING, AL_FALSE );
   return;
}


void * OpenAL_PlayMP3( void * args )
{
   int index;
   FILE *fh;
   struct stat sbuf;
   void *data;
   int i = 0;
   int size;
   ALint tState;
   index = gIndex;
   isSet = 0;
   pthread_mutex_lock(&mutex);
   isPlaying += 1;
   pthread_mutex_unlock(&mutex);
   if (stat(arraySource[index].filename, &sbuf) == -1) {
      pthread_mutex_lock(&mutex);
      isPlaying -= 1;
      arraySource[index].inUse -= 1;
      pthread_mutex_unlock(&mutex);
      pthread_exit(NULL);
      }
   size = sbuf.st_size;
   data = malloc(size);
   if (data == NULL) {
      pthread_mutex_lock(&mutex);
      isPlaying -= 1;
      arraySource[index].inUse -= 1;
      pthread_mutex_unlock(&mutex);
      pthread_exit(NULL);
      }
   fh = fopen(arraySource[index].filename, "rb");
   if (fh == NULL) {
      free(data);
      pthread_mutex_lock(&mutex);
      isPlaying -= 1;
      arraySource[index].inUse -= 1;
      pthread_mutex_unlock(&mutex);
      pthread_exit(NULL);
      }
   if (fread(data, 1, size, fh) <= 0) {
      fclose(fh);
      free(data);
      pthread_mutex_lock(&mutex);
      isPlaying -= 1;
      arraySource[index].inUse -= 1;
      pthread_mutex_unlock(&mutex);
      pthread_exit(NULL);
      }

   fclose(fh);
   alutLoadMP3p = (mp3Loader *) alGetProcAddress((ALubyte *) MP3_FUNC);
   if (alutLoadMP3p == NULL) {
      /*
       * Can't get the ProcAddress; fail.
       */
      free(data);
      pthread_mutex_lock(&mutex);
      isPlaying -= 1;
      arraySource[index].inUse -= 1;
      pthread_mutex_unlock(&mutex);
      pthread_exit(NULL);
      }
   if(alutLoadMP3p(arraySource[index].mBuffer, data, size) != AL_TRUE) {
      /*
       * Can't LoadMP3, fail;
       */
      free(data);
      pthread_mutex_lock(&mutex);
      isPlaying -= 1;
      arraySource[index].inUse -= 1;
      pthread_mutex_unlock(&mutex);
      pthread_exit(NULL);
      }
   free(data);
   initMP3(index);
   alSourcePlay( arraySource[index].source );
   alGetSourcei(arraySource[index].source, AL_SOURCE_STATE, &tState);
   while(tState == AL_PLAYING) {
      sleep(1);
      alGetSourcei(arraySource[index].source, AL_SOURCE_STATE, &tState);
      }
   alSourceStop(arraySource[index].source);
   alSourcei(arraySource[index].source, AL_BUFFER, 0);
   pthread_mutex_lock(&mutex);
   isPlaying -= 1;
   arraySource[index].inUse -= 1;
   pthread_mutex_unlock(&mutex);
   pthread_exit(NULL);
}
#endif /* if(HAVE_OPENAL && HAVE_LIBSDL && HAVE_LIBSMPEG) */

#if defined(HAVE_LIBOPENAL) && defined(HAVE_LIBOGG)
/* The following is for Ogg-Vorbis Support on top of OpenAL*/
#define DATABUFSIZE 		(4096 * 16)

/*
 * OggStreamBuf - read a buffer's worth of data from our Ogg stream.
 *   returns 1 if ov_read() has returned negative number.
 *   returns 1 if size is 0
 *   returns 0 if size is nonzero, i.e. all is well
 */
int OggStreamBuf(ALuint buffer, int index)
{
   char pcm[DATABUFSIZE];
   long size;
   int section;
   long result;
   int active;
   size = 0;
   while (size < DATABUFSIZE) {
      result = ov_read(&arraySource[index].oggStream, pcm + size,
		       DATABUFSIZE - size, 0, 2, 1, &section);
      if (result > 0) {
         size += result;
	 }
      else
         if (result < 0) {
            return 1;
	    }
         else
            break;
      }
   if (size == 0) {
      active = 1;
      }
   else {
      active = 0;
      }
   alBufferData(buffer, arraySource[index].format, pcm, size,
		arraySource[index].vorbisInfo->rate);
   return active;
}

/*
 * OggPlayback() - play an ogg audio buffer
 */
int OggPlayback(int index)
{
   ALenum state;

   alGetSourcei(arraySource[index].source, AL_SOURCE_STATE, &state);
   if(state == AL_PLAYING)
      return 0;

   arraySource[index].numBuffers = 0;

   if(OggStreamBuf(arraySource[index].buffer[0], index) == 1) { /* no data */
      return 1;
      }
   else { /* some data, support up to 4 buffers */
      arraySource[index].numBuffers++;
      if(OggStreamBuf(arraySource[index].buffer[1], index) != 1) {
	 arraySource[index].numBuffers++;
	 if(OggStreamBuf(arraySource[index].buffer[2], index) != 1) {
	    arraySource[index].numBuffers++;
	    if(OggStreamBuf(arraySource[index].buffer[3], index) != 1) {
	       arraySource[index].numBuffers++;
	       }
	    }
	 }
      }

   alSourceQueueBuffers(arraySource[index].source, arraySource[index].numBuffers,
			arraySource[index].buffer);
   alSourcePlay(arraySource[index].source);
   return 0;
}

int OggUpdate(int index)
{
   int processed;
   int active = 0;
   alGetSourcei(arraySource[index].source, AL_BUFFERS_PROCESSED, &processed);
   while (processed--) {
      ALuint buffer;
      alSourceUnqueueBuffers(arraySource[index].source, 1, &buffer);
      active = OggStreamBuf(buffer, index);
      alSourceQueueBuffers(arraySource[index].source, 1, &buffer);
   }
   return active;
}


void OggExit(int index)
{
   pthread_mutex_lock(&mutex);
   isPlaying -= 1;
   alSourceStop(arraySource[index].source);
   ov_clear(&arraySource[index].oggStream);
   alSourcei(arraySource[index].source, AL_BUFFER, 0);
   arraySource[index].inUse -= 1;
   /* deletion of buffers and sources is handled in audio_exit() */
   pthread_mutex_unlock(&mutex);
}

/*
 * OpenAL_PlayOgg - play an Ogg file.  A pthreads start routine, the
 * parameter and return type are dictated, but since we do not join
 * to it, we do not use the return value.
 */
void * OpenAL_PlayOgg(void * args)
{
   int rv, i = gIndex;
   isSet = 0;

   if (pthread_mutex_lock(&mutex) != 0) return NULL;
   isPlaying += 1;
   if (pthread_mutex_unlock(&mutex) != 0) return NULL;
   if((rv=ov_fopen(arraySource[i].filename, &(arraySource[i].oggStream))) < 0) {

      switch(rv) { /* TODO: handle or indicate these errors */
      case OV_EREAD:      /* media read error */
      case OV_ENOTVORBIS: /* bitstream has no vorbis data */
      case OV_EVERSION:   /* vorbis version mismatch */
      case OV_EBADHEADER: /* bad vorbis bitstream header */
      case OV_EFAULT:     /* internal logic fault */
	 ;
	 }

      if (pthread_mutex_lock(&mutex) == 0) {
	 ov_clear(&arraySource[i].oggStream);
	 isPlaying -= 1;
	 arraySource[i].inUse -= 1;
	 pthread_mutex_unlock(&mutex);
	 }
      pthread_exit(NULL);
   }
   arraySource[i].vorbisInfo = ov_info(&(arraySource[i].oggStream), -1);
   if (arraySource[i].vorbisInfo == NULL) {
      goto errfail;
      }
   if(arraySource[i].vorbisInfo->channels == 1) {
      arraySource[i].format = AL_FORMAT_MONO16;
      }
   else {
      arraySource[i].format = AL_FORMAT_STEREO16;
      }
   if (OggPlayback(i) == 1) {
      goto errfail;
      }
   while(OggUpdate(i) == 0) {
      if(OggPlayback(i) == 1) {
	 goto errfail;
	 }
      sleep(2);
      }
 errfail:
   OggExit(i);
   pthread_exit(NULL);
}

#endif 	/* #if(HAVE_LIBOPENAL && HAVE_LIBOGG)*/

#ifdef HAVE_LIBOPENAL

/*
 * Thread function to play WAV file under OpenAL.
 */
void * OpenAL_PlayWAV(void * args)
{
   int indexSource;
   ALint tState;
   indexSource = gIndex;
   isSet = 0;
   pthread_mutex_lock(&mutex);
   isPlaying += 1;
   pthread_mutex_unlock(&mutex);

   /* startaudiothread ran before we did, and initialized wbuffer, but we
    * want to use an alut function that creates a buffer, so free whatever
    * is in there already.
    */
   alDeleteBuffers(1, &(arraySource[indexSource].wBuffer));
   arraySource[indexSource].wBuffer =
      alutCreateBufferFromFile(arraySource[indexSource].filename);
   alSourceQueueBuffers(arraySource[indexSource].source, 1,
			&arraySource[indexSource].wBuffer);
   alSourcePlay(arraySource[indexSource].source);
   alGetSourcei(arraySource[indexSource].source, AL_SOURCE_STATE, &tState);
   while(tState == AL_PLAYING) {
      sleep(1);
      alGetSourcei(arraySource[indexSource].source, AL_SOURCE_STATE, &tState);
      }
   alSourceStop(arraySource[indexSource].source);
   alSourcei(arraySource[indexSource].source, AL_BUFFER, 0);
   pthread_mutex_lock(&mutex);
   isPlaying -= 1;
   arraySource[indexSource].inUse -= 1;
   pthread_mutex_unlock(&mutex);
   pthread_exit(NULL);
}
#endif /* HAVE_LIBOPENAL */


/*
 * This is a general Audio API Function.  Returns 0 for success, -1 for failure.
 */
int StartAudioThread(char filename[])
{
   int i;
   pthread_attr_t attrib;
   char *strptr;
   if (pthread_mutex_lock(&mutex) != 0) return -1;
   if (isPlaying == -1) {
      if (alutInit(NULL, NULL) != AL_TRUE) return -1;
      for(i = 0; i < 16 ; ++i) {
         alGenSources(1, &arraySource[i].source);
         alGenBuffers(4, arraySource[i].buffer);
         alGenBuffers(1, &arraySource[i].mBuffer);
         alGenBuffers(1, &arraySource[i].wBuffer);
         arraySource[i].inUse = 0;
	 }
      isPlaying = 0;
      }
   if (pthread_mutex_unlock(&mutex) != 0) return -1;

   while (isSet != 0)
      sleep(1);
   if ((i = GetIndex()) < 0) return -1;
   
   isSet = 1;
   gIndex = i;
   strcpy(arraySource[i].filename, filename);
   pthread_attr_init(&attrib);
   pthread_attr_setdetachstate(&attrib, PTHREAD_CREATE_DETACHED);

   if((strptr = strstr(filename,".mp3")) != NULL) {
#if defined(HAVE_LIBOPENAL) && defined(HAVE_LIBSDL) && defined(HAVE_LIBSMPEG)
#ifndef WIN32
      if (pthread_create(&arraySource[i].thread, &attrib, OpenAL_PlayMP3,NULL)){
	 goto errfail;
	 }
      return i;
#else					/* !WIN32 */
      /* WIN32 : MP3 is not implemented yet */
      goto errfail;
#endif					/* !WIN32 */
#else					/* HAVE_LIBOPENAL && ... */
      goto errfail;
#endif					/* HAVE_LIBOPENAL && ... */
	 }

      else if ((strptr = strstr(filename,".ogg")) != NULL) {
#if defined(HAVE_LIBOGG) 
#ifndef WIN32
	 if (pthread_create(&arraySource[i].thread, &attrib,
			    OpenAL_PlayOgg, NULL)) {
	    goto errfail;
	    }
#else					/* !WIN32 */
	 arraySource[i].hThread =
	    CreateThread(NULL, 0, PlayOggVorbisWIN32, NULL, 0, &dwThreadId);
	 if (arraySouce[i].hThread == NULL) {
	    goto errfail;
	    }
#endif					/* !WIN32 */
	 return i;
#else					/* HAVE_LIBOGG */
	 goto errfail;
#endif					/* HAVE_LIBOGG */
	 }

      if((strptr = strstr(filename,".wav")) != NULL){
#ifdef HAVE_LIBOPENAL
#ifndef WIN32
	 if (pthread_create(&arraySource[i].thread, &attrib,
			    OpenAL_PlayWAV, NULL)) {
	    goto errfail;
	    }
	 return i;
#else					/* !WIN32 */
	 /* WIN32 : WAV is not implemented yet, you can use WinPlayMedia() */
	 return -1;
#endif					/* !WIN32 */
#else
	 goto errfail;
#endif
	 }
 errfail:
   if (pthread_mutex_lock(&mutex) == 0) {
      arraySource[i].inUse -= 1;
      pthread_mutex_unlock(&mutex); 
      }
   isSet = 0;
   return -1;
}


void StopAudioThread(int index)
{
   if (index < 0 || index > 15)
      return;
   pthread_mutex_lock(&mutex);
   if (arraySource[index].inUse > 0) 
   {
      isPlaying -= 1;;
      arraySource[index].inUse -= 1;
      alSourceStop(arraySource[index].source);
      alSourcei(arraySource[index].source, AL_BUFFER, 0);
#ifdef WIN32
      CloseHandle(arraySource[index].hThread);
#else
      pthread_cancel(arraySource[index].thread);
#endif
   }
   pthread_mutex_unlock(&mutex);
}

/*
 *  audio mixer
 *	Windows 32: Based on Windows Multimedia -lwinmm
 *	Linux     : Based on the OSS APIs
 *  Author      : Ziad Al-Sharif, zsharif@cs.uidaho.edu
 *  Date        : April 1, 2006
 */

int AudioMixer(char * cmd)
{
   int res;
#if NT
   res = WinMixer(cmd);
#else
   res = LinuxMixer(cmd);
#endif
   MixUnInitialize();
   return res;
}

/* Linux mixer based on the OSS system  */
#if !NT

/* names of available mixer devices */
const char *sound_device_names[] = SOUND_DEVICE_NAMES;

/* file descriptor for mixer device */
int mixer_fd;

/* bit masks of mixer information */
int recsrc, devmask, recmask,stereodevs, caps;

int OpenMixer();
int CloseMixer();
int SetMixerAttribute(char * dev, int value);
int GetMixerAttribute(char * dev);
int PrintAllMixerAttribute(char *device);


int OpenMixer()
{

   /* open mixer, read only */
   mixer_fd = open("/dev/mixer", O_RDONLY);
   if (mixer_fd == -1) { 
      /* unable to open /dev/mixer */
      return mixer_fd;
      }

   /* get needed information about the mixer */
   if ( ioctl(mixer_fd, SOUND_MIXER_READ_DEVMASK, &devmask) == -1 ) 
      return -1; /* ioctl failed */

   if ( ioctl(mixer_fd, SOUND_MIXER_READ_STEREODEVS, &stereodevs) == -1)
      return -1; /* ioctl failed */

   /* get all of the information about the mixer */
   if ( ioctl(mixer_fd, SOUND_MIXER_READ_RECSRC, &recsrc) == -1)
      return -1; /* ioctl failed */

   if ( ioctl(mixer_fd, SOUND_MIXER_READ_RECMASK, &recmask) == -1)
      return -1; /* ioctl failed */

   if ( ioctl(mixer_fd, SOUND_MIXER_READ_CAPS, &caps) == -1)
      return -1; /* ioctl failed */

   return mixer_fd;
}

int CloseMixer()
{
   close(mixer_fd);
   return 0;
}

int SetMixerAttribute(char *dev, int value)
{
   int left, right, level;	/* gain settings */
   int device;		/* which mixer device to set */
   int i;			/* general purpose loop counter */

   /* figure out which device to use */
   for (i = 0 ; i < SOUND_MIXER_NRDEVICES ; i++)
      if (((1 << i) & devmask) && !strcmp(dev, sound_device_names[i]))
	 break;
   if (i == SOUND_MIXER_NRDEVICES) { 	/* didn't find a match */
      /* "dev" is not a valid mixer device */
      return -1;
      }

   /* we have a valid mixer device */
   device = i;

   left = right = value;

   /* issue warning if left and right gains given for non-stereo device */
   if ((left != right) && !((1 << i) & stereodevs)) {
      /* Warning: "dev" is not a stereo device  */
      }

   /* encode both channels into one value */
   level = (right << 8) + left;

   /* set gain */
   if (ioctl(mixer_fd, MIXER_WRITE(device), &level) == -1) {
      return -1; /* MIXER_WRITE ioctl failed */
      }

   /* unpack left and right levels returned by sound driver */
   left  = level & 0xff;
   right = (level & 0xff00) >> 8;

   level = (left + right) / 2;
   return level;
}

int GetMixerAttribute(char * dev)
{
   int left, right, level;   /* gain settings */
   int device;		     /* which mixer device to set */
   int i;		     /* general purpose loop counter */

   /* figure out which device to use */
   for (i = 0 ; i < SOUND_MIXER_NRDEVICES ; i++)
      if (((1 << i) & devmask) && !strcmp(dev, sound_device_names[i]))
	 break;
   if (i == SOUND_MIXER_NRDEVICES) { 	
      /* didn't find a match             */
      /* dev is not a valid mixer device */
      return -1;
      }

   device = i;

   if ((1 << i) & stereodevs) {
      if (ioctl(mixer_fd, MIXER_READ(device), &level) == -1)
	 return -1; /* ioctl failed */
      left  = level & 0xff;
      right = (level & 0xff00) >> 8;
      level = (left + right) / 2;
      }
   else { /* only one channel */
      if (ioctl(mixer_fd, MIXER_READ(device), &level) == -1)
	 return -1; /* ioctl failed */
      level = level & 0xff;
      }
   return level;
}

int LinuxMixer(char * cmd) /* cmd: eg. "vol=50" */
{
   int i = 0;
   char val[5] = {'\0'};
   int  cmdiVal = -1;
   char cmdsVal[10] = {'\0'};
   char *strptr = NULL, *p = NULL;

   if (MixInitialize() >= 0) {
      /*----------------parse cmd; */
      p = strchr(cmd,'=');
      if (p != NULL) { /* cmd: "cmd=ival" */
	 strptr = cmd;
	 while (strptr != p) cmdsVal[i++] = *strptr++;
	 cmdsVal[i] = '\0';
	 i=0;
	 while(*++p != '\0') val[i++] = *p;
	 val[i] = '\0';
	 cmdiVal = atoi(val);
	 }
      else  /* cmd: "cmd" */
	 strcat(cmdsVal,cmd);

      /*----------------*/
      if ( !strcmp(cmdsVal,"wave"))
	 strcpy(cmdsVal,"pcm");

      /*----------------*/
      if (cmdiVal > -1){
	 if ( !strcmp(cmdsVal,"mic")){
	    SetMixerAttribute(cmdsVal, cmdiVal);
	    return SetMixerAttribute("igain", cmdiVal);
	    }
	 else
	    if ( !strcmp(cmdsVal,"phone")){
	       SetMixerAttribute("phin", cmdiVal);  /* phin:  is phone  */
	       /* phout: is Master Mono */
	       return SetMixerAttribute("phout", cmdiVal);
	       }
	    else
	       return SetMixerAttribute(cmdsVal, cmdiVal);
	 }
      else {
	 if (!strcmp(cmdsVal,"mic")){
	    GetMixerAttribute(cmdsVal);
	    return GetMixerAttribute("igain");
	    }
	 if (!strcmp(cmdsVal,"phone")){
	    GetMixerAttribute("phin");   /* phin:  is phone  */
	    return GetMixerAttribute("phout");  /* phout: is Master Mono */
	    }
	 else
	    return GetMixerAttribute(cmdsVal);
	 }
      }
   return -1;
}
#endif /* if !NT  */

/*    Win 32 Mixer: based on the Windows Multimedia and -lwinmm library    */
#if NT

unsigned int mixid;
HMIXER       hmix;
int  opened=0;
int  loaded=0;
int  numlines=0;
MIXERLINE * mxl_List[256]={NULL};
int VolumeDevmask[256];
int MuteDevmask[256];
#define mxfactr	655.35

/*void print_NameValue(int device);*/
void Clear();
int OpenMixer();
int CloseMixer();
void print_AllMixerLinesInfo();
int GetAllMixerLinesInfo();
int GetAllMixerLinesVolume();
int GetMixerLineVolume(unsigned int i);
int SetAllMixerLinesVolume(DWORD Volume);
int SetMixerLineVolume(unsigned int i, DWORD Volume);
int GetAllMixerLinesMuteState();
int GetMixerLineMuteState(unsigned int i);
int SetMixerLineMuteState(unsigned int i, LONG Val);

void Clear()
{
   int i;
   for (i=0; i< numlines; ++i) {
      if(mxl_List[i] != NULL)
	 free(mxl_List[i]);
      VolumeDevmask[numlines] = -1;
      MuteDevmask[numlines]   = -1;
      }
   numlines=0;
}

int OpenMixer()
{
   int i;
   MMRESULT res;
   if (opened)
      return -1;
   res = mixerOpen(&hmix,0,0,0,MIXER_OBJECTF_MIXER | CALLBACK_WINDOW);
   if( res != MMSYSERR_NOERROR)
      return -1;
   res = mixerGetID((HMIXEROBJ)hmix,&mixid,MIXER_OBJECTF_HMIXER);
   if(res != MMSYSERR_NOERROR)
      return -1;
   opened = 1;
   loaded = 0;
   return 1;
}

int CloseMixer()
{
   if (hmix != NULL)
      if(mixerClose(hmix) == MMSYSERR_NOERROR){
	 hmix = NULL;
	 Clear();
	 return 1;
	 }
   return -1;
}

/*
 * gets all the mxl info and store them in mxl_List[],
 * numlines: is the number of the available mixer lines
 */
int GetAllMixerLinesInfo()
{
   unsigned int i,k,num;
   MIXERLINE  	*pmxl;
   MMRESULT 	res;
   MIXERCAPS   mxcaps;
   numlines=0;
   if (!opened)
      return -1;
   res = mixerGetDevCaps(mixid, &mxcaps, sizeof(MIXERCAPS));
   if(res != MMSYSERR_NOERROR)
      return -1;
   for (i = 0 ; i < mxcaps.cDestinations ; i++){
      pmxl= (MIXERLINE*)malloc(sizeof(MIXERLINE));
      if (pmxl == NULL)  return -1;
      pmxl->cbStruct = sizeof(MIXERLINE);
      pmxl->dwDestination = i;
      res = mixerGetLineInfo((HMIXEROBJ)hmix, pmxl,
			     MIXER_GETLINEINFOF_DESTINATION);
      if (res == MMSYSERR_NOERROR){
	 num = pmxl->cConnections;
	 /*---*/
	 mxl_List[numlines]=pmxl;
	 VolumeDevmask[numlines]= -1;
	 MuteDevmask[numlines]  = -1;
	 numlines++;
	 /*---*/
	 for (k = 0 ; k < num ; k++){
	    pmxl= (MIXERLINE*)malloc(sizeof(MIXERLINE));
            if (pmxl == NULL)  return -1;
	    pmxl->cbStruct = sizeof(MIXERLINE);
	    pmxl->dwDestination = i;
	    pmxl->dwSource = k;
	    res = mixerGetLineInfo((HMIXEROBJ)hmix, pmxl,
				   MIXER_GETLINEINFOF_SOURCE);
	    if (res == MMSYSERR_NOERROR){
	       /*---*/
	       mxl_List[numlines]=pmxl;
	       VolumeDevmask[numlines]= -1;
	       MuteDevmask[numlines]  = -1;
	       numlines++;
	       /*---*/
	       }
	    else free(pmxl);
	    }
	 } else free(pmxl);
      }
   loaded = 1;
   return 1;
}

int GetAllMixerLinesVolume()
{
   unsigned int i;
   MMRESULT 	res;
   MIXERCAPS   mxcaps;
   MIXERCONTROL        mxc;
   MIXERLINECONTROLS   mxlc;
   MIXERCONTROLDETAILS mxcd;
   MIXERCONTROLDETAILS_UNSIGNED mxcdVolume;
   DWORD dwVal=0;

   if (!opened)
      return -1;
   res = mixerGetDevCaps(mixid,&mxcaps,sizeof(MIXERCAPS));
   if(res != MMSYSERR_NOERROR)
      return -1;

   for (i = 0 ; i < numlines ; i++){
      /* get dwControlID */
      mxlc.cbStruct = sizeof(MIXERLINECONTROLS);
      mxlc.dwLineID = mxl_List[i]->dwLineID;/*mxl.dwLineID;*/
      mxlc.dwControlType = MIXERCONTROL_CONTROLTYPE_VOLUME;
      mxlc.cControls = 1;
      mxlc.cbmxctrl = sizeof(MIXERCONTROL);
      mxlc.pamxctrl = &mxc;
      res = mixerGetLineControls((HMIXEROBJ)hmix, &mxlc,
		     MIXER_OBJECTF_HMIXER | MIXER_GETLINECONTROLSF_ONEBYTYPE);
      if ( res != MMSYSERR_NOERROR){
	 VolumeDevmask[i] = -1;
	 }
      else {
	 mxcd.cbStruct = sizeof(MIXERCONTROLDETAILS);
	 mxcd.dwControlID = mxc.dwControlID;
	 mxcd.cChannels = 1;
	 mxcd.cMultipleItems = 0;
	 mxcd.cbDetails = sizeof(MIXERCONTROLDETAILS_UNSIGNED);
	 mxcd.paDetails = &mxcdVolume;
	 res = mixerGetControlDetails((HMIXEROBJ)hmix,&mxcd,
		       MIXER_OBJECTF_HMIXER | MIXER_GETCONTROLDETAILSF_VALUE);
	 if( res != MMSYSERR_NOERROR){
	    VolumeDevmask[i] = -1;
	    }
	 else {
	    dwVal = mxcdVolume.dwValue;
	    VolumeDevmask[i] = dwVal;
	    }
	 }
      }
   loaded = 1;
   return dwVal;
}

int GetMixerLineVolume(unsigned int i)
{
   MMRESULT 	res;
   MIXERCAPS   mxcaps;
   MIXERCONTROL        mxc;
   MIXERLINECONTROLS   mxlc;
   MIXERCONTROLDETAILS mxcd;
   MIXERCONTROLDETAILS_UNSIGNED mxcdVolume;
   DWORD dwVal=0;

   if (!opened)
      return -1;
   /*	res = mixerGetDevCaps(mixid,&mxcaps,sizeof(MIXERCAPS)); */
   /*	if(res != MMSYSERR_NOERROR) */
   /*		return -1; */

   /* get dwControlID */
   mxlc.cbStruct = sizeof(MIXERLINECONTROLS);
   mxlc.dwLineID = mxl_List[i]->dwLineID;/*mxl.dwLineID; */
   mxlc.dwControlType = MIXERCONTROL_CONTROLTYPE_VOLUME;
   mxlc.cControls = 1;
   mxlc.cbmxctrl = sizeof(MIXERCONTROL);
   mxlc.pamxctrl = &mxc;
   res = mixerGetLineControls((HMIXEROBJ)hmix,&mxlc,
		    MIXER_OBJECTF_HMIXER | MIXER_GETLINECONTROLSF_ONEBYTYPE);
   if ( res != MMSYSERR_NOERROR){
      VolumeDevmask[i] = -1;
      }
   else {
      mxcd.cbStruct = sizeof(MIXERCONTROLDETAILS);
      mxcd.dwControlID = mxc.dwControlID;
      mxcd.cChannels = 1;
      mxcd.cMultipleItems = 0;
      mxcd.cbDetails = sizeof(MIXERCONTROLDETAILS_UNSIGNED);
      mxcd.paDetails = &mxcdVolume;
      res = mixerGetControlDetails((HMIXEROBJ)hmix,&mxcd,MIXER_OBJECTF_HMIXER |
				   MIXER_GETCONTROLDETAILSF_VALUE);
      if (res != MMSYSERR_NOERROR){
	 VolumeDevmask[i] = -1;
	 }
      else {
	 dwVal = mxcdVolume.dwValue;
	 VolumeDevmask[i] = dwVal;
	 }
      }
   loaded = 1;
   return dwVal;
}

int SetAllMixerLinesVolume(DWORD Volume)
{
   unsigned int i;
   MMRESULT 	res;
   MIXERCAPS   mxcaps;
   MIXERCONTROL        mxc;
   MIXERLINECONTROLS   mxlc;
   MIXERCONTROLDETAILS mxcd;
   MIXERCONTROLDETAILS_UNSIGNED mxcdVolume = {(DWORD)(Volume * mxfactr)};
   DWORD dwVal=0;

   if (!opened)
      return -1;
   res = mixerGetDevCaps(mixid,&mxcaps,sizeof(MIXERCAPS));
   if(res != MMSYSERR_NOERROR)
      return -1;

   for (i = 0 ; i < numlines ; i++){
      /* get dwControlID */
      mxlc.cbStruct = sizeof(MIXERLINECONTROLS);
      mxlc.dwLineID = mxl_List[i]->dwLineID;/*mxl.dwLineID;*/
      mxlc.dwControlType = MIXERCONTROL_CONTROLTYPE_VOLUME;
      mxlc.cControls = 1;
      mxlc.cbmxctrl = sizeof(MIXERCONTROL);
      mxlc.pamxctrl = &mxc;
      res = mixerGetLineControls((HMIXEROBJ)hmix,&mxlc,MIXER_OBJECTF_HMIXER |
				 MIXER_GETLINECONTROLSF_ONEBYTYPE);
      if ( res != MMSYSERR_NOERROR){
	 VolumeDevmask[i] = -1;
	 }
      else {
	 mxcd.cbStruct = sizeof(MIXERCONTROLDETAILS);
	 mxcd.dwControlID = mxc.dwControlID;
	 mxcd.cChannels = 1;
	 mxcd.cMultipleItems = 0;
	 mxcd.cbDetails = sizeof(MIXERCONTROLDETAILS_UNSIGNED);
	 mxcd.paDetails = &mxcdVolume;
	 res = mixerSetControlDetails((HMIXEROBJ)hmix,&mxcd,
		      MIXER_OBJECTF_HMIXER | MIXER_GETCONTROLDETAILSF_VALUE);
	 if (res != MMSYSERR_NOERROR) {
	    VolumeDevmask[i] = -1;
	    }
	 else {
	    dwVal = mxcdVolume.dwValue;
	    VolumeDevmask[i] = dwVal;
	    }
	 }
      }
   loaded = 1;
   return dwVal;
}

int SetMixerLineVolume(unsigned int i, DWORD Volume)
{
   MMRESULT res;
   MIXERCAPS   mxcaps;
   MIXERCONTROL        mxc;
   MIXERLINECONTROLS   mxlc;
   MIXERCONTROLDETAILS mxcd;
   MIXERCONTROLDETAILS_UNSIGNED mxcdVolume = { (DWORD)(Volume * mxfactr) };
   DWORD dwVal=0;

   if (!opened)
      return -1;
   res = mixerGetDevCaps(mixid,&mxcaps,sizeof(MIXERCAPS));
   if(res != MMSYSERR_NOERROR)
      return -1;

   /* get dwControlID */
   mxlc.cbStruct = sizeof(MIXERLINECONTROLS);
   mxlc.dwLineID = mxl_List[i]->dwLineID;/*mxl.dwLineID;*/

   mxlc.dwControlType = MIXERCONTROL_CONTROLTYPE_VOLUME;
   mxlc.cControls = 1;
   mxlc.cbmxctrl = sizeof(MIXERCONTROL);
   mxlc.pamxctrl = &mxc;
   res = mixerGetLineControls((HMIXEROBJ)hmix,&mxlc,
		    MIXER_OBJECTF_HMIXER | MIXER_GETLINECONTROLSF_ONEBYTYPE);
   if (res != MMSYSERR_NOERROR) {
      VolumeDevmask[i] = -1;
      }
   else {
      mxcd.cbStruct = sizeof(MIXERCONTROLDETAILS);
      mxcd.dwControlID = mxc.dwControlID;
      mxcd.cChannels = 1;
      mxcd.cMultipleItems = 0;
      mxcd.cbDetails = sizeof(MIXERCONTROLDETAILS_UNSIGNED);
      mxcd.paDetails = &mxcdVolume;
      res = mixerSetControlDetails((HMIXEROBJ)hmix,&mxcd,MIXER_OBJECTF_HMIXER |
				   MIXER_GETCONTROLDETAILSF_VALUE);
      if (res != MMSYSERR_NOERROR) {
	 VolumeDevmask[i] = -1;
	 }
      else {
	 dwVal = mxcdVolume.dwValue;
	 VolumeDevmask[i] = dwVal;
	 }
      }
   loaded = 1;
   return dwVal;
}

int GetAllMixerLinesMuteState()
{
   unsigned int i;
   MMRESULT 	res;
   MIXERCAPS   mxcaps;
   MIXERCONTROL        mxc;
   MIXERLINECONTROLS   mxlc;
   MIXERCONTROLDETAILS mxcd;
   MIXERCONTROLDETAILS_BOOLEAN mxcdMute;    /*new*/
   DWORD dwVal=0;

   if (!opened)
      return -1;
   res = mixerGetDevCaps(mixid,&mxcaps,sizeof(MIXERCAPS));
   if (res != MMSYSERR_NOERROR)
      return -1;

   for (i = 0 ; i < numlines ; i++){
      /* get dwControlID */
      mxlc.cbStruct = sizeof(MIXERLINECONTROLS);
      mxlc.dwLineID = mxl_List[i]->dwLineID;/*mxl.dwLineID;*/
      mxlc.dwControlType = MIXERCONTROL_CONTROLTYPE_MUTE;  /*new*/
      mxlc.cControls = 1;
      mxlc.cbmxctrl = sizeof(MIXERCONTROL);
      mxlc.pamxctrl = &mxc;
      res = mixerGetLineControls((HMIXEROBJ)hmix,&mxlc,
		     MIXER_OBJECTF_HMIXER | MIXER_GETLINECONTROLSF_ONEBYTYPE);
      if (res != MMSYSERR_NOERROR) {
	 MuteDevmask[i] = -1;
	 }
      else {
	 mxcd.cbStruct = sizeof(MIXERCONTROLDETAILS);
	 mxcd.dwControlID = mxc.dwControlID;
	 mxcd.cChannels = 1;
	 mxcd.cMultipleItems = 0;
	 mxcd.cbDetails = sizeof(MIXERCONTROLDETAILS_BOOLEAN); /* new */
	 mxcd.paDetails = &mxcdMute;
	 res = mixerGetControlDetails((HMIXEROBJ)hmix,&mxcd,
		       MIXER_OBJECTF_HMIXER | MIXER_GETCONTROLDETAILSF_VALUE);
	 if (res != MMSYSERR_NOERROR) {
	    MuteDevmask[i] = -1;
	    }
	 else {
	    dwVal = mxcdMute.fValue;
	    MuteDevmask[i] = dwVal;
	    }
	 }
      }
   loaded = 1;
   return dwVal;
}

int GetMixerLineMuteState(unsigned int i)
{
   MMRESULT 	res;
   MIXERCAPS   mxcaps;
   MIXERCONTROL        mxc;
   MIXERLINECONTROLS   mxlc;
   MIXERCONTROLDETAILS mxcd;
   MIXERCONTROLDETAILS_BOOLEAN mxcdMute;    /*new*/
   DWORD dwVal=0;

   if (!opened)
      return -1;
   res = mixerGetDevCaps(mixid,&mxcaps,sizeof(MIXERCAPS));
   if(res != MMSYSERR_NOERROR)
      return -1;

   /* get dwControlID */
   mxlc.cbStruct = sizeof(MIXERLINECONTROLS);
   mxlc.dwLineID = mxl_List[i]->dwLineID;/*mxl.dwLineID;*/
   mxlc.dwControlType = MIXERCONTROL_CONTROLTYPE_MUTE;  /*new */
   mxlc.cControls = 1;
   mxlc.cbmxctrl = sizeof(MIXERCONTROL);
   mxlc.pamxctrl = &mxc;
   res = mixerGetLineControls((HMIXEROBJ)hmix,&mxlc,
		     MIXER_OBJECTF_HMIXER | MIXER_GETLINECONTROLSF_ONEBYTYPE);
   if ( res != MMSYSERR_NOERROR){
      MuteDevmask[i] = -1;
      }
   else {
      mxcd.cbStruct = sizeof(MIXERCONTROLDETAILS);
      mxcd.dwControlID = mxc.dwControlID;
      mxcd.cChannels = 1;
      mxcd.cMultipleItems = 0;
      mxcd.cbDetails = sizeof(MIXERCONTROLDETAILS_BOOLEAN); /*new */
      mxcd.paDetails = &mxcdMute;
      res = mixerGetControlDetails((HMIXEROBJ)hmix, &mxcd,
		       MIXER_OBJECTF_HMIXER | MIXER_GETCONTROLDETAILSF_VALUE);
      if (res != MMSYSERR_NOERROR) {
	 MuteDevmask[i] = -1;
	 }
      else {
	 dwVal = mxcdMute.fValue;
	 MuteDevmask[i] = dwVal;
	 }
      }
   loaded = 1;
   return dwVal;
}

/* Val=[0|1], 1 means MUTE=ON, 0 means Mute=OFF  */
int SetMixerLineMuteState(unsigned int i, LONG Val)
{
   MMRESULT 	res;
   MIXERCAPS   mxcaps;
   MIXERCONTROL        mxc;
   MIXERLINECONTROLS   mxlc;
   MIXERCONTROLDETAILS mxcd;
   MIXERCONTROLDETAILS_BOOLEAN mxcdMute = { Val };
   DWORD dwVal=0;

   if (!opened)
      return -1;
   res = mixerGetDevCaps(mixid,&mxcaps,sizeof(MIXERCAPS));
   if (res != MMSYSERR_NOERROR)
      return -1;

   /* get dwControlID */
   mxlc.cbStruct = sizeof(MIXERLINECONTROLS);
   mxlc.dwLineID = mxl_List[i]->dwLineID;/*mxl.dwLineID;*/
   mxlc.dwControlType = MIXERCONTROL_CONTROLTYPE_MUTE;  /*new*/
   mxlc.cControls = 1;
   mxlc.cbmxctrl = sizeof(MIXERCONTROL);
   mxlc.pamxctrl = &mxc;
   res = mixerGetLineControls((HMIXEROBJ)hmix,&mxlc,
		   MIXER_OBJECTF_HMIXER | MIXER_GETLINECONTROLSF_ONEBYTYPE);
   if (res != MMSYSERR_NOERROR) {
      MuteDevmask[i] = -1;
      }
   else {
      mxcd.cbStruct = sizeof(MIXERCONTROLDETAILS);
      mxcd.dwControlID = mxc.dwControlID;
      mxcd.cChannels = 1;
      mxcd.cMultipleItems = 0;
      mxcd.cbDetails = sizeof(MIXERCONTROLDETAILS_BOOLEAN); /* new */
      mxcd.paDetails = &mxcdMute;
      res = mixerSetControlDetails((HMIXEROBJ)hmix, &mxcd,
		       MIXER_OBJECTF_HMIXER | MIXER_GETCONTROLDETAILSF_VALUE);
      if (res != MMSYSERR_NOERROR) {
	 MuteDevmask[i] = -1;
	 }
      else {
	 dwVal = mxcdMute.fValue;
	 MuteDevmask[i] = dwVal;
	 }
      }
   loaded = 1;
   return dwVal;
}

int WinMixer(char * cmd) /* cmd: eg. "vol=50" */
{
   int i = 0, k;
   char val[5] = {'\0'};
   int  cmdiVal = -1;
   char cmdsVal[10] = {'\0'};
   char *strptr= NULL, *p = NULL;
   char * DevNames[10] = {
      "Volume Contro","Wave","SW Synth","Telephone","PC Speaker",
      "CD Audio","Line In","Microphone","IIS","Phone Line"};
   char * attribs[10] = {"vol","wave","synth","telephone","speaker",
			    "cd","line","mic","iis","phoneline"};
   if (MixInitialize()) {
      /*----------------parse cmd */
      p = strchr(cmd,'=');
      if (p != NULL){ /* cmd: "cmd=ival" */
	 strptr=cmd;
	 while(strptr != p)	cmdsVal[i++]=*strptr++;
	 cmdsVal[i]='\0';
	 i=0;
	 while(*++p != '\0')	val[i++]=*p;
	 val[i]='\0';
	 cmdiVal = atoi(val);
	 }
      else  /* cmd: "cmd" */
	 strcat(cmdsVal,cmd);

      /*----------------*/
      if( !strcmp(cmdsVal,"pcm"))
	 strcpy(cmdsVal,"wave");
      if( !strcmp(cmdsVal,"phone")){
	 strcpy(cmdsVal,"phoneline");
	 i=9;
	 }
      else
	 for(i=0; i < 10; ++i)
	    if(strstr(cmdsVal,attribs[i])){
	       break;
	       }
      if(i != 10){
	 for(k=0; k < numlines; ++k){
	    if (strstr(mxl_List[k]->szName,DevNames[i])) {
	       if(VolumeDevmask[k] != -1)
		  if(cmdiVal > -1){
		     if(cmdiVal == 0){ /* do mute */
			SetMixerLineMuteState((unsigned int) k,
					      1 /*(DWORD) cmdiVal*/);
			return (int)(SetMixerLineVolume((unsigned int) k,
						      (DWORD)cmdiVal)/mxfactr);
			}
		     else { /* do unmute */
			SetMixerLineMuteState((unsigned int) k,
					      0 /*(DWORD) cmdiVal*/);
			return (int)(SetMixerLineVolume((unsigned int) k,
						    (DWORD)cmdiVal) / mxfactr);
			}
		     }
		  else {
		     return (int)(GetMixerLineVolume((unsigned int)k)/mxfactr);
		     }
	       }
	    }
	 }
      }
   return -1;
}
#endif /* if NT */

int MixInitialize()
{
   if (OpenMixer() >= 0) {
#ifdef WIN32
      if (GetAllMixerLinesInfo() >= 0)
	 if (GetAllMixerLinesVolume() >= 0)
	    if (GetAllMixerLinesMuteState() >= 0){
	       return 1;
	       }
#else
      return 1;
#endif
      }
   return -1;
}

void MixUnInitialize()
{
   CloseMixer();
}
#else
/**/
#endif					/* Audio */
