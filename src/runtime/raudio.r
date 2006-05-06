/*
 * raudio.r - runtime support for audio facilities
 */

/* May 3, 2005
 * this file contains Audio API functions on top of
 * OpenAL to play MP3, Ogg Vorbis, and WAV.
 * StartAudioThread(filename) is the main function where
 * filename is any of the three formats.
 */

#if (defined(HAVE_LIBOPENAL) && defined(HAVE_LIBOGG)) || (defined(HAVE_LIBOPENAL) && defined(HAVE_LIBSDL) && defined(HAVE_LIBSMPEG) ) || (defined(HAVE_LIBOGG) && defined(WIN32))

#ifndef WIN32

	/* OpenAL */

#if 0
#ifndef TESTLIB_H_
#define TESTLIB_H_

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

#ifndef AL_SITECONFIG_H_
#define AL_SITECONFIG_H_

/*
 * Wrap site specific config stuff
 */

#ifdef DARWIN_PBBUILDER
#include "config-osx.h"
#else
#include "config.h"
#endif /* DARWIN_PBBUILDER */


#define USE_LRINT 0 /* icculus look here JIV FIXME */

#if USE_LRINT

#define __USE_ISOC99 1
#define _ISOC99_SOURCE 1
#define __USE_EXTERN_INLINES 1
#define __FAST_MATH__ 1
#include <math.h>

#endif

#ifdef DMALLOC
/* do nothing */
#undef malloc
#undef calloc
#undef realloc
#undef new
#undef free
#undef strspn
#include <stdlib.h>
#include <string.h>
#undef malloc
#undef calloc
#undef realloc
#undef new
#undef free
#undef strspn
#elif defined(JLIB) && !defined(NOJLIB)
#include <stdlib.h>
#endif

#ifdef DMALLOC
#include "/usr/local/include/dmalloc.h"
#endif

#if defined(JLIB) && !defined(NOJLIB)
#include "../include/jlib.h"
#endif


#ifdef BROKEN_LIBIO
#include <libio.h>
#define __underflow __broken_underflow
#define __overflow __broken_overflow
#include <stdio.h>

#define __ASSEMBLER__
#include <errnos.h>

#define __USE_POSIX
#include <signal.h>

#endif /* BROKEN_LIBIO */

#endif /* AL_SITE_CONFIG_H_ */

#include <AL/altypes.h>
#include <AL/alexttypes.h>
#include "config.h"

/*
 * function pointer for LOKI extensions
 */
extern ALfloat	(*talcGetAudioChannel)(ALuint channel);
extern void	(*talcSetAudioChannel)(ALuint channel, ALfloat volume);

extern void	(*talMute)(void);
extern void	(*talUnMute)(void);

extern void	(*talReverbScale)(ALuint sid, ALfloat param);
extern void	(*talReverbDelay)(ALuint sid, ALfloat param);
extern void	(*talBombOnError)(void);

extern void	(*talBufferi)(ALuint bid, ALenum param, ALint value);


extern void	(*talBufferWriteData)(ALuint bid, ALenum format, ALvoid *data, ALint size, ALint freq, ALenum iFormat);

extern ALuint  (*talBufferAppendData)(ALuint bid, ALenum format, ALvoid *data, ALint freq, ALint samples);
extern ALuint  (*talBufferAppendWriteData)(ALuint bid, ALenum format, ALvoid *data, ALint freq, ALint samples, ALenum internalFormat);

extern ALboolean (*alCaptureInit) ( ALenum format, ALuint rate, ALsizei bufferSize );
extern ALboolean (*alCaptureDestroy) ( void );
extern ALboolean (*alCaptureStart) ( void );
extern ALboolean (*alCaptureStop) ( void );
extern ALsizei (*alCaptureGetData) ( ALvoid* data, ALsizei n, ALenum format, ALuint rate );

/* new ones */
extern void (*talGenStreamingBuffers)(ALsizei n, ALuint *bids );
extern ALboolean (*talutLoadRAW_ADPCMData)(ALuint bid,
				ALvoid *data, ALuint size, ALuint freq,
				ALenum format);
extern ALboolean (*talutLoadIMA_ADPCMData)(ALuint bid,
				ALvoid *data, ALuint size, ALuint freq,
				ALenum format);
extern ALboolean (*talutLoadMS_ADPCMData)(ALuint bid,
				ALvoid *data, ALuint size, ALuint freq,
				ALenum format);

void micro_sleep(unsigned int n);
void fixup_function_pointers(void);
ALboolean SourceIsPlaying(ALuint sid);

#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif /* TESTLIB_H_ */

#endif

static time_t start;
static ALCcontext *context_id;
static ALuint stereo;

pthread_t AudioThread;

#else  /* WIN32 Audio */

/* WIN32 Threads */
DWORD dwThreadId;
HANDLE hThread;
#endif /* WIN32 */

struct AudioFile *FilePtr;

/* Internal Thread Functions Prototypes */
#ifndef WIN32
	void * OpenAL_PlayMP3( void * args );
	void * OpenAL_PlayWAV( void * args );
	void * OpenAL_PlayOgg( void * args );
	void * PlayOggVorbis(void * args);
#endif


#ifdef WIN32
DWORD WINAPI PlayOggVorbisWIN32( void * params );
#endif

struct AudioFile * audioInit(char filename[])
{
   if (FilePtr == NULL)
      FilePtr = (struct AudioFile *) malloc(sizeof(struct AudioFile));

   if (FilePtr != NULL) {
      FilePtr->doneflag = 0;
      FilePtr->fname = strdup(filename);
      if (FilePtr->fname == NULL) {
	 fprintf(stderr, "audio init: malloc failed\n");
	 return NULL;
	 }
      return FilePtr;
      }
   else
      fprintf(stderr, "\n Memory is not enough : malloc failed\n");
   return NULL;
}


#if defined(HAVE_LIBOPENAL) && defined(HAVE_LIBSDL) && defined(HAVE_LIBSMPEG)
struct AudioFile * StartMP3Thread(char filename[])
{
   struct AudioFile *Ptr;
   Ptr = audioInit(filename);
   if (Ptr != NULL) {
#ifndef WIN32
      if (pthread_create( &AudioThread, NULL, OpenAL_PlayMP3 , NULL)) {
	 fprintf(stderr, "error creating thread.\n");
	 abort();
	 }
      return Ptr;
#else
      /* WIN32 : MP3 is not implemented yet */
      return NULL;
#endif
      }
   return Ptr;
}
#endif

#ifdef HAVE_LIBOPENAL
struct AudioFile * StartWAVThread(char filename[])
{
   struct AudioFile *Ptr;
   Ptr = audioInit(filename);
   if (Ptr != NULL) {
#ifndef WIN32
      if ( pthread_create( &AudioThread, NULL, OpenAL_PlayMP3 , NULL) ) {
	 fprintf(stderr, "error creating thread.\n");
	 abort();
	 }
      return Ptr;
#else
      /* WIN32 : WAV is not implemented yet, you can use WinPlayMedia() */
      return NULL;
#endif /* WIN32 */
      }
   return Ptr;
}
#endif

#if defined(HAVE_LIBOGG)
struct AudioFile * StartOggVorbisThread(char filename[])
{
   struct AudioFile *Ptr;
   Ptr = audioInit(filename);
   if (Ptr != NULL) {
#ifndef WIN32
      if ( pthread_create( &AudioThread, NULL, OpenAL_PlayOgg, NULL) ) {
	 fprintf(stderr, "error creating thread.\n");
	 abort();
	 }
      return Ptr;
#else    /*  Create a  Windows Thread  */
      hThread = CreateThread(NULL,0,PlayOggVorbisWIN32,NULL,0,&dwThreadId);
      if (hThread == NULL)
	 ExitProcess(1);
      return Ptr;
#endif   /* WIN32 */
      }
   return Ptr;
}
#endif /* defined(HAVE_LIBOGG) */

/* This is a general Audio API Function    */
struct AudioFile * StartAudioThread(char filename[])
{
   char *sp;
   static struct AudioFile *Ptr;

   Ptr = audioInit(filename);
   if (Ptr != NULL) {
      if((sp = strstr(Ptr->fname,".mp3")  ) != NULL ||
	 (sp = strstr(Ptr->fname,".MP3")  ) != NULL){
#if defined(HAVE_LIBOPENAL) && defined(HAVE_LIBSDL) && defined(HAVE_LIBSMPEG)
#ifndef WIN32
	 if ( pthread_create( &AudioThread, NULL, OpenAL_PlayMP3 , NULL) ) {
	    fprintf(stderr, "error creating thread.\n");
	    abort();
	    }
	 return Ptr;
#else
	 /* WIN32 : MP3 is not implemented yet */
	 return NULL;
#endif /* WIN32 */
#else
	 fprintf(stderr, "\nstartaudiothread: sound not supported in VM\n");
	 return NULL;
#endif
	 }

      if((sp = strstr(Ptr->fname,".ogg")  ) != NULL ||
	 (sp = strstr(Ptr->fname,".Ogg")  ) != NULL){
#if defined(HAVE_LIBOGG) 
#ifndef WIN32
	 if ( pthread_create( &AudioThread, NULL, OpenAL_PlayOgg , NULL) ) {
	    fprintf(stderr, "error creating thread.\n");
	    abort();
	    }
	 return Ptr;
#else
	 hThread = CreateThread(NULL,0,PlayOggVorbisWIN32,NULL,0,&dwThreadId);
	 if (hThread == NULL)
	    ExitProcess(1);
	 return Ptr;
#endif /* WIN32 */
#else
	 fprintf(stderr, "\n HAVE_LIBOGG: is not defined\n");
	 return NULL;
#endif /* defined(HAVE_LIBOGG)  */
	 }

      if((sp = strstr(Ptr->fname,".wav")  ) != NULL ||
	 (sp = strstr(Ptr->fname,".WAV")  ) != NULL){
#ifdef HAVE_LIBOPENAL
#ifndef WIN32
	 if ( pthread_create( &AudioThread, NULL, OpenAL_PlayWAV , NULL) ) {
	    fprintf(stderr, "error creating thread.");
	    abort();
	    }
	 return Ptr;
#else
	 /* WIN32 : WAV is not implemented yet, you can use WinPlayMedia() */
	 return NULL;
#endif /* WIN32 */
#else
	 fprintf(stderr, "\n HAVE_LIBOPENAL: is not defined\n");
	 return NULL;
#endif
	 }/* End WAV Thread */
      }
   else {
      fprintf(stderr, "\n No enough memory : malloc failed \n");
      return NULL;
      }
   return NULL;
}


void StopAudioThread(struct AudioFile * Ptr)
{
   if( Ptr != NULL){
      Ptr->doneflag=1;
      Ptr->doneflag=1;
      free(Ptr);
#ifdef WIN32
      CloseHandle(hThread);
#endif
      }
}

/*
 *  audio mixer
 *	Windows 32 : Based on Windows Multimedia -lwinmm
 *	Linux      : Based on the OSS APIs
 *  Auther         : Ziad Al-Sharif, zsharif@cs.nmsu.edu
 *  Date           : April 1, 2006
 */

int MixInitialize();
int MixUnInitialize();
int AudioMixer(char * cmd);

/* Linux mixer based on the OSS system  */
#ifndef WIN32
/* #include <unistd.h>
   #include <stdlib.h>
   #include <stdio.h>
   #include <sys/ioctl.h>
   #include <fcntl.h>
   #include <linux/soundcard.h>
   #include <stdlib.h>
   #include <string.h> 
*/

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
int LinuxMixer(char * cmd);

int OpenMixer()
{
   int status;

   /* open mixer, read only */
   mixer_fd = open("/dev/mixer", O_RDONLY);
   if (mixer_fd == -1) {
      fprintf(stderr,"unable to open /dev/mixer");
      return mixer_fd;
      }

   /* get needed information about the mixer */
   status = ioctl(mixer_fd, SOUND_MIXER_READ_DEVMASK, &devmask);
   if (status == -1)
      fprintf(stderr,"SOUND_MIXER_READ_DEVMASK ioctl failed");
   status = ioctl(mixer_fd, SOUND_MIXER_READ_STEREODEVS, &stereodevs);
   if (status == -1)
      fprintf(stderr,"SOUND_MIXER_READ_STEREODEVS ioctl failed");

   /* get all of the information about the mixer */
   status = ioctl(mixer_fd, SOUND_MIXER_READ_RECSRC, &recsrc);
   if (status == -1)
      fprintf(stderr,"SOUND_MIXER_READ_RECSRC ioctl failed");

   status = ioctl(mixer_fd, SOUND_MIXER_READ_RECMASK, &recmask);
   if (status == -1)
      fprintf(stderr,"SOUND_MIXER_READ_RECMASK ioctl failed");

   status = ioctl(mixer_fd, SOUND_MIXER_READ_CAPS, &caps);
   if (status == -1)
      fprintf(stderr,"SOUND_MIXER_READ_CAPS ioctl failed");

   return mixer_fd;
}

int CloseMixer()
{
   close(mixer_fd);
   return 0;
}

int SetMixerAttribute(char * dev, int value)
{
   int left, right, level;	/* gain settings */
   int status;		/* return value from system calls */
   int device;		/* which mixer device to set */
   int i;			/* general purpose loop counter */

   /* figure out which device to use */
   for (i = 0 ; i < SOUND_MIXER_NRDEVICES ; i++)
      if (((1 << i) & devmask) && !strcmp(dev, sound_device_names[i]))
	 break;
   if (i == SOUND_MIXER_NRDEVICES) { 	/* didn't find a match */
      fprintf(stderr, "%s is not a valid mixer device\n", dev);
      return -1;
      }

   /* we have a valid mixer device */
   device = i;

   left = right = value;

   /*display warning if left and right gains given for non-stereo device */
   if ((left != right) && !((1 << i) & stereodevs)) {
      fprintf(stderr, "warning: %s is not a stereo device\n", dev);
      }

   /* encode both channels into one value */
   level = (right << 8) + left;

   /* set gain */
   status = ioctl(mixer_fd, MIXER_WRITE(device), &level);
   if (status == -1) {
      fprintf(stderr,"MIXER_WRITE ioctl failed");
      return -1;
      }

   /* unpack left and right levels returned by sound driver */
   left  = level & 0xff;
   right = (level & 0xff00) >> 8;

   level = (left + right) / 2;
   return level;
}

int GetMixerAttribute(char * dev)
{
   int left, right, level;	/* gain settings */
   int status;		/* return value from system calls */
   int device;		/* which mixer device to set */
   int i;			/* general purpose loop counter */

   /* figure out which device to use */
   for (i = 0 ; i < SOUND_MIXER_NRDEVICES ; i++)
      if (((1 << i) & devmask) && !strcmp(dev, sound_device_names[i]))
	 break;
   if (i == SOUND_MIXER_NRDEVICES) { 	/* didn't find a match */
      fprintf(stderr, "%s is not a valid mixer device\n", dev);
      return -1;
      }

   device = i;

   if ((1 << i) & stereodevs) {
      status = ioctl(mixer_fd, MIXER_READ(device), &level);
      if (status == -1)
	 fprintf(stderr,"SOUND_MIXER_READ ioctl failed");
      left  = level & 0xff;
      right = (level & 0xff00) >> 8;
      level = (left + right) / 2;
      }
   else { /* only one channel */
      status = ioctl(mixer_fd, MIXER_READ(device), &level);
      if (status == -1)
	 fprintf(stderr,"SOUND_MIXER_READ ioctl failed");
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
   char *sp = NULL, *p = NULL;

   if( MixInitialize() >= 0){
      /*----------------parse cmd; */
      p = strchr(cmd,'=');
      if(p != NULL){ /* cmd: "cmd=ival" */
	 sp=cmd;
	 while(sp != p)	cmdsVal[i++]=*sp++;
	 cmdsVal[i]='\0';
	 i=0;
	 while(*++p != '\0')	val[i++]=*p;
	 val[i]='\0';
	 cmdiVal = atoi(val);
	 }else  /* cmd: "cmd" */
	    strcat(cmdsVal,cmd);

      /*----------------*/
      if( !strcmp(cmdsVal,"wave"))
	 strcpy(cmdsVal,"pcm");

      /*----------------*/
      if(cmdiVal > -1){
	 if( !strcmp(cmdsVal,"mic")){
	    SetMixerAttribute(cmdsVal, cmdiVal);
	    return	SetMixerAttribute("igain", cmdiVal);
	    }
	 else
	    if( !strcmp(cmdsVal,"phone")){
	       SetMixerAttribute("phin", cmdiVal);  /* phin:  is phone  */
	       return	SetMixerAttribute("phout", cmdiVal); /* phout: is Master Mono */
	       }
	    else
	       return SetMixerAttribute(cmdsVal, cmdiVal);
	 }
      else {
	 if( !strcmp(cmdsVal,"mic")){
	    GetMixerAttribute(cmdsVal);
	    return	GetMixerAttribute("igain");
	    }
	 if( !strcmp(cmdsVal,"phone")){
	    GetMixerAttribute("phin");   /* phin:  is phone  */
	    return	GetMixerAttribute("phout");  /* phout: is Master Mono */
	    }
	 else
	    return GetMixerAttribute(cmdsVal);
	 }
      }
   return -1;
}
#endif

/*    Win 32 Mixer: based on the Windows Multimedia and -lwinmm library    */
#ifdef WIN32
/*
  #include <windows.h>
  #include <mmsystem.h>
  #include <stdio.h>
*/
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
   res = mixerGetDevCaps(mixid,&mxcaps,sizeof(MIXERCAPS));
   if(res != MMSYSERR_NOERROR)
      return -1;
   for (i = 0 ; i < mxcaps.cDestinations ; i++){
      pmxl= (MIXERLINE*)malloc(sizeof(MIXERLINE));
      pmxl->cbStruct = sizeof(MIXERLINE);
      pmxl->dwDestination = i;
      res = mixerGetLineInfo((HMIXEROBJ)hmix,pmxl,MIXER_GETLINEINFOF_DESTINATION);
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
	    pmxl->cbStruct = sizeof(MIXERLINE);
	    pmxl->dwDestination = i;
	    pmxl->dwSource = k;
	    res = mixerGetLineInfo((HMIXEROBJ)hmix,pmxl,MIXER_GETLINEINFOF_SOURCE);
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
   else
      {
	 mxcd.cbStruct = sizeof(MIXERCONTROLDETAILS);
	 mxcd.dwControlID = mxc.dwControlID;
	 mxcd.cChannels = 1;
	 mxcd.cMultipleItems = 0;
	 mxcd.cbDetails = sizeof(MIXERCONTROLDETAILS_UNSIGNED);
	 mxcd.paDetails = &mxcdVolume;
	 res = mixerGetControlDetails((HMIXEROBJ)hmix,&mxcd,MIXER_OBJECTF_HMIXER | MIXER_GETCONTROLDETAILSF_VALUE);
	 if( res != MMSYSERR_NOERROR){
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
      res = mixerGetLineControls((HMIXEROBJ)hmix,&mxlc,MIXER_OBJECTF_HMIXER | MIXER_GETLINECONTROLSF_ONEBYTYPE);
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
      res = mixerSetControlDetails((HMIXEROBJ)hmix,&mxcd,MIXER_OBJECTF_HMIXER | MIXER_GETCONTROLDETAILSF_VALUE);
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
   char *sp = NULL, *p = NULL;
   char * DevNames[10] = {
      "Volume Contro","Wave","SW Synth","Telephone","PC Speaker",
      "CD Audio","Line In","Microphone","IIS","Phone Line"};
   char * attribs[10] = {"vol","wave","synth","telephone","speaker",
			    "cd","line","mic","iis","phoneline"};
   if (MixInitialize()) {
      /*----------------parse cmd */
      p = strchr(cmd,'=');
      if(p != NULL){ /* cmd: "cmd=ival" */
	 sp=cmd;
	 while(sp != p)	cmdsVal[i++]=*sp++;
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
#endif

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

int MixUnInitialize()
{
   CloseMixer();
}

int AudioMixer(char * cmd)
{
   int res;
#ifndef WIN32
   res = LinuxMixer(cmd);
#else
   res = WinMixer(cmd);
#endif
   MixUnInitialize();
   return res;
}

#else
static char c;
#endif			/* HAVE_LIBOPENAL && HAVE_LIBSDL && HAVE_LIBSMPEG */
