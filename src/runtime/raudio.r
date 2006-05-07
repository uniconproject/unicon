/*
 * raudio.r - runtime support for audio facilities
 */

/* May 3, 2005
 * this file contains Audio API functions on top of
 * OpenAL to play MP3, Ogg Vorbis, and WAV.
 * StartAudioThread(filename) is the main function where
 * filename is any of the three formats.
 */

#ifdef Audio

int MixInitialize();
int MixUnInitialize();
int AudioMixer(char * cmd);
struct AudioFile * audioInit(char filename[]);

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
   if (Ptr != NULL) {
      Ptr->doneflag=1;
      free(Ptr);
#ifdef WIN32
      CloseHandle(hThread);
#endif
      }
}

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




#ifdef HAVE_OPENAL

	/* OpenAL */

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


/*
 *  audio mixer
 *	Windows 32 : Based on Windows Multimedia -lwinmm
 *	Linux      : Based on the OSS APIs
 *  Auther         : Ziad Al-Sharif, zsharif@cs.nmsu.edu
 *  Date           : April 1, 2006
 */


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

/*
 * following code formerly lib/audio/woggvorb.cpp
 */

#ifdef HAVE_LIBOGG
	
#ifdef WIN32  /* for MS Windows */
	
WAVEFORMATEX waveformater;
HWAVEOUT hwave;
struct BufferInfo {
  /*	public: */
   int nused;
   CRITICAL_SECTION criticalsection;
   HANDLE huponfree;
};

struct BufferInfo *newBufferInfo()
{
   struct BufferInfo *bi = malloc(sizeof(struct BufferInfo));
   if (bi == NULL) return NULL;
   bi->nused=0;
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
   waveformater.nBlockAlign     = (WORD)((waveformater.wBitsPerSample>>3)*waveformater.nChannels);
   waveformater.nSamplesPerSec  = rate;
   waveformater.nAvgBytesPerSec = waveformater.nSamplesPerSec * waveformater.nBlockAlign;
   if( waveOutOpen(&hwave,WAVE_MAPPER,&waveformater,(DWORD_PTR)PlayCallback,(DWORD_PTR)&bufferinfo,CALLBACK_FUNCTION) == MMSYSERR_NOERROR ){
      perror("");
      return 0;
      }
   return 0;
}

/*extern "C"*/

DWORD WINAPI PlayOggVorbisWIN32( void * params )
{
   FILE *fd;
   OggVorbis_File oggplayfile;
   const int nbuffers = 5, buffersize = 4096;
   unsigned int numsamples, numbytes, currentbuffer = 0, totprogress=0;
   int i, current_section = 0;
   WAVEHDR headers[nbuffers], *header;
   vorbis_info *oggfileinfo;
   bool okay;

   if ( ( fd = fopen( FilePtr->fname , "rb" ) ) == NULL ){
      perror("");
      ExitProcess(1);
      }

   if ( ov_open(fd,&oggplayfile,NULL,0) < 0 ){
      perror("");
      fprintf(stderr,"\nFor Some Reason ogg file is not opening\n");
      fclose(fd);
      ExitProcess(1);
      }

   if (!ov_seekable(&oggplayfile)){
      ov_clear(&oggplayfile);
      perror("");
      ExitProcess(1);
      }

   oggfileinfo=ov_info(&oggplayfile,-1);

   numsamples = (unsigned int)ov_pcm_total(&oggplayfile,0);
   numbytes = numsamples * oggfileinfo->channels * waveformater.wBitsPerSample > 1;

   if(audioDevice(oggfileinfo->channels, oggfileinfo->rate)){
      fprintf(stderr,"\nError Setting up Audio Device\n");
      ExitProcess(1);
      }
   for (i=0; i < nbuffers; i++){
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

      for (header->dwBufferLength=0; header->dwBufferLength<buffersize; ){
	 long ret = 0;
	 if( ( ret = ov_read( &oggplayfile, header->lpData+header->dwBufferLength, buffersize - header->dwBufferLength, 0, 2, 1, &current_section ) ) <= 0 ){
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

      if(FilePtr->doneflag)
	 break;
      }

   for (okay=false; !okay; ){
      EnterCriticalSection(&bufferinfo.criticalsection);
      okay = (bufferinfo.nused==0);
      LeaveCriticalSection(&bufferinfo.criticalsection);
      if (!okay)
	 WaitForSingleObject( bufferinfo.huponfree, INFINITE );
      }
   waveOutReset(hwave);

   for (i=0; i<nbuffers; i++){
      waveOutUnprepareHeader( hwave, &headers[i], sizeof(WAVEHDR) );
      LocalFree( headers[i].lpData );
      }

   waveOutClose(hwave);
   ov_clear(&oggplayfile);
   /* fclose(fd); // Casing Error */
   return 0;
}

#else /* WIN32 */


/*
 * Following code formerly lib/audio/al.c, openal/linux audio playback code
 */

#define GP(x)          alGetProcAddress((const ALubyte *) x)

#ifdef _WIN32

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

   if (talBufferi == NULL) {
      fprintf(stderr,	"Could not GetProcAddress alBufferi_LOKI\n");
      exit(1);
      }

   alCaptureInit    = (ALboolean (*)( ALenum, ALuint, ALsizei )) GP("alCaptureInit_EXT");
   alCaptureDestroy = (ALboolean (*)( void )) GP("alCaptureDestroy_EXT");
   alCaptureStart   = (ALboolean (*)( void )) GP("alCaptureStart_EXT");
   alCaptureStop    = (ALboolean (*)( void )) GP("alCaptureStop_EXT");
   alCaptureGetData = (ALsizei (*)( ALvoid*, ALsizei, ALenum, ALuint )) GP("alCaptureGetData_EXT");


   talBufferWriteData = (PFNALBUFFERWRITEDATAPROC) GP("alBufferWriteData_LOKI");
   if (talBufferWriteData == NULL) {
      fprintf( stderr, "Could not GP alBufferWriteData_LOKI\n" );
      exit(1);
      }

   talBufferAppendData = (ALuint (*)(ALuint, ALenum, ALvoid *, ALint, ALint)) GP("alBufferAppendData_LOKI");
   talBufferAppendWriteData = (ALuint (*)(ALuint, ALenum, ALvoid *, ALint, ALint, ALenum)) GP("alBufferAppendWriteData_LOKI");

   talGenStreamingBuffers = (void (*)(ALsizei n, ALuint *bids )) GP("alGenStreamingBuffers_LOKI");
   if (talGenStreamingBuffers == NULL) {
      fprintf( stderr, "Could not GP alGenStreamingBuffers_LOKI\n");
      exit(1);
      }

   talutLoadRAW_ADPCMData = (ALboolean (*)(ALuint bid,ALvoid *data, ALuint size, ALuint freq,ALenum format)) GP("alutLoadRAW_ADPCMData_LOKI");
   if (talutLoadRAW_ADPCMData == NULL) {
      fprintf( stderr, "Could not GP alutLoadRAW_ADPCMData_LOKI\n");
      exit(1);
      }

   talutLoadIMA_ADPCMData = (ALboolean (*)(ALuint bid,ALvoid *data, ALuint size, ALuint freq,ALenum format)) GP("alutLoadIMA_ADPCMData_LOKI");
   if (talutLoadIMA_ADPCMData == NULL) {
      fprintf( stderr, "Could not GP alutLoadIMA_ADPCMData_LOKI\n");
      exit(1);
      }

   talutLoadMS_ADPCMData = (ALboolean (*)(ALuint bid,ALvoid *data, ALuint size, ALuint freq,ALenum format)) GP("alutLoadMS_ADPCMData_LOKI");
   if (talutLoadMS_ADPCMData == NULL) {
      fprintf( stderr, "Could not GP alutLoadMS_ADPCMData_LOKI\n");
      exit(1);
      }

   return;
}

ALboolean SourceIsPlaying(ALuint sid) {
   ALint state;

   if (alIsSource(sid) == AL_FALSE) {
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
   if (dev == NULL) {
      return NULL;
      }

   /* Initialize ALUT. */
   context_id = alcCreateContext( dev, NULL );
   if (context_id == NULL) {
      alcCloseDevice( dev );
      return NULL;
      }

   alcMakeContextCurrent( context_id );
   fixup_function_pointers();
   initMP3();

   /* the global fname */
   if(stat(FilePtr->fname, &sbuf) == -1) {
      perror(FilePtr->fname);
      return NULL;/*errno;*/
      }
   size = sbuf.st_size;
   data = malloc(size);
   if(data == NULL) {
      exit(1);
      }
   fh = fopen(FilePtr->fname, "rb");

   if (fh == NULL) {
      fprintf(stderr, "Could not open %s\n", FilePtr->fname);
      free(data);
      exit(1);
      }

   fread(data, 1, size, fh);
   alutLoadMP3p = (mp3Loader *) alGetProcAddress((ALubyte *) MP3_FUNC);

   if (alutLoadMP3p == NULL) {
      free(data);
      fprintf(stderr, "Could not GetProc %s\n",(ALubyte *) MP3_FUNC);
      exit(-4);
      }

   if (alutLoadMP3p(mp3buf, data, size) != AL_TRUE) {
      fprintf(stderr, "alutLoadMP3p failed\n");
      exit(-2);
      }

   free(data);
   alSourcePlay( mp3source );
   while (SourceIsPlaying(mp3source) == AL_TRUE) {
      sleep(1);
      if(FilePtr->doneflag)	break; /* stop playing */
      }
   cleanupMP3();
   alcCloseDevice( dev );
   return NULL;
}
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
   if ( dev == NULL ) {
      return NULL;
      }

   /* Initialize ALUT. */
   context_id = alcCreateContext( dev, NULL );
   if (context_id == NULL) {
      alcCloseDevice( dev );
      return NULL;
      }

   alcMakeContextCurrent( context_id );
   fixup_function_pointers();
   initOggVorbis();

   /* the global fname */
   if (stat(FilePtr->fname, &sbuf) == -1) {
      perror(FilePtr->fname);
      return NULL;/*errno;*/
      }

   size = sbuf.st_size;
   data = malloc(size);
   if (data == NULL) {
      exit(1);
      }

   fh = fopen(FilePtr->fname, "rb");
   if(fh == NULL) {
      fprintf(stderr, "Could not open %s\n", FilePtr->fname);
      free(data);
      exit(1);
      }

   fread(data, size, 1, fh);

   alutLoadVorbisp = (vorbisLoader *) alGetProcAddress((ALubyte *)VORBIS_FUNC);
   if (alutLoadVorbisp == NULL) {
      free(data);
      fprintf(stderr, "Could not GetProc %s\n",	(ALubyte *) VORBIS_FUNC);
      exit(-4);
      }

   if (alutLoadVorbisp(vorbbuf, data, size) != AL_TRUE) {
      fprintf(stderr, "alutLoadVorbis failed\n");
      exit(-2);
      }

   free(data);
   alSourcePlay( vorbsource );

   while(SourceIsPlaying(vorbsource) == AL_TRUE) {
      sleep(1);
      if(FilePtr->doneflag)	break;/* break the thread and stop playing */
      }
   cleanupOggVorbis();
   alcCloseDevice( dev );
   return NULL;
}
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
   if (now - then > 2) {
      then = now;
      movefactor *= -1.0;
      }

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
   if (fh == NULL) {
      fprintf(stderr, "Couldn't open fname\n");
      exit(1);
      }

   filelen = fread(data, 1, WAV_DATABUFFERSIZE, fh);
   fclose(fh);
   alGetError();

   /* sure hope it's a wave file */
   alBufferData( stereo, AL_FORMAT_WAVE_EXT, data, filelen, 0 );
   if (alGetError() != AL_NO_ERROR) {
      fprintf(stderr, "Could not BufferData\n");
      exit(1);
      }

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
   if ( dev == NULL ) {
      fprintf(stderr, "Could not open device\n");
      return NULL;
      }

   /* Initialize ALUT. */
   context_id = alcCreateContext( dev, attrlist );
   if (context_id == NULL) {
      fprintf(stderr, "Could not open context: %s\n",
	      alGetString( alcGetError(dev) ));
      return NULL;
      }

   alcMakeContextCurrent( context_id );
   fixup_function_pointers();
   talBombOnError();
   initWAV();
   alSourcePlay( moving_source );

   while (SourceIsPlaying( moving_source ) == AL_TRUE) {
      iterateWAV();
      shouldend = time(NULL);
      if ((shouldend - start) > 30) {
	 alSourceStop(moving_source);
         }
      if (FilePtr->doneflag == 1)
	 break; /* break the thread and stop playing */
      }
   cleanupWAV();
   alcDestroyContext( context_id );
   alcCloseDevice(  dev  );
   return NULL;
}
#endif /* HAVE_LIBOPENAL */

#endif /* HAVE_LIBOGG */

#else
static char c;
#endif			/* HAVE_LIBOPENAL && HAVE_LIBSDL && HAVE_LIBSMPEG */
