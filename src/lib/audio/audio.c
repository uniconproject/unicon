/* May 3, 2005
 * this file contains Audio API functions on top of
 * OpenAL to play MP3, Ogg Vorbis, and WAV.
 * StartAudioThread(filename) is the main function where
 * filename is any of the three formats.
 */
#include "../../h/auto.h"

#if (defined(HAVE_LIBOPENAL) && defined(HAVE_LIBOGG)) || (defined(HAVE_LIBOPENAL) && defined(HAVE_LIBSDL) && defined(HAVE_LIBSMPEG) ) || (defined(HAVE_LIBOGG) && defined(WIN32))

#include "common.h"

#ifdef WIN32
        DWORD WINAPI PlayOggVorbisWIN32( void * params );
#endif

struct AudioFile * init(char filename[])
{
        FilePtr = (struct AudioFile *) malloc(sizeof(struct AudioFile));

        if(FilePtr != NULL){
                FilePtr->doneflag=0;
                FilePtr->fname=(char *)malloc(sizeof(filename));
                /*strcpy(FilePtr->fname,filename);*/
                FilePtr->fname=strdup(filename);
                /*printf("\n FilePtr->fname = %s\n",FilePtr->fname);*/
                return FilePtr;
        }
        else
                printf("\n Memory is not enough : malloc failed\n");
        return NULL;
}


#if defined(HAVE_LIBOPENAL) && defined(HAVE_LIBSDL) && defined(HAVE_LIBSMPEG)
struct AudioFile * StartMP3Thread(char filename[])
{
        //pthread_t AudioThread;
        char *sp;
        struct AudioFile *Ptr;
        Ptr = init(filename);
        if(Ptr != NULL){
        #ifndef WIN32
                if ( pthread_create( &AudioThread, NULL, OpenAL_PlayMP3 , NULL) ) {
                        printf("error creating thread.");
                        abort();
                }/* End Creation Thread*/
                return Ptr;
        #else
                /* WIN32 : MP3 is not implemented yet */
                return NULL;
        #endif
        }/* End MP3 Thread*/
        return Ptr;
}
#endif

#ifdef HAVE_LIBOPENAL
struct AudioFile * StartWAVThread(char filename[])
{
        //pthread_t AudioThread;
        char *sp;
        struct AudioFile *Ptr;
        Ptr = init(filename);
        if(Ptr != NULL){
        #ifndef WIN32
                if ( pthread_create( &AudioThread, NULL, OpenAL_PlayMP3 , NULL) ) {
                        printf("error creating thread.");
                        abort();
                }/* End Creation Thread*/
                return Ptr;
        #else
                /* WIN32 : WAV is not implemented yet, you can use WinPlayMedia() */
                return NULL;
        #endif /* WIN32 */
        }/* End MP3 Thread*/
        return Ptr;
}
#endif

#if defined(HAVE_LIBOGG)
struct AudioFile * StartOggVorbisThread(char filename[])
{
        //pthread_t AudioThread;
        char *sp;
        struct AudioFile *Ptr;
        Ptr = init(filename);
        if(Ptr != NULL){
        #ifndef WIN32
                if ( pthread_create( &AudioThread, NULL, /*PlayOggVorbis*/ OpenAL_PlayOgg, NULL) ) {
                        printf("error creating thread.");
                        abort();
                }/* End Creation Thread*/
                return Ptr;
        #else    /*  Create a  Windows Thread  */
                hThread = CreateThread(NULL,0,PlayOggVorbisWIN32,NULL,0,&dwThreadId);
                if (hThread == NULL)
                        ExitProcess(1);
                return Ptr;
        #endif   /* WIN32 */
        } /* End If */
        return Ptr;
}
#endif /* defined(HAVE_LIBOGG) */

/* This is A general Audio API Function    */
struct AudioFile * StartAudioThread(char filename[])
{
        //pthread_t AudioThread;
        char *sp;
        static struct AudioFile *Ptr=NULL;

        Ptr = init(filename);

        if(Ptr != NULL){
                if( (sp = strstr(Ptr->fname,".mp3")  ) != NULL || (sp = strstr(Ptr->fname,".MP3")  ) != NULL){
                #if defined(HAVE_LIBOPENAL) && defined(HAVE_LIBSDL) && defined(HAVE_LIBSMPEG)
                        #ifndef WIN32
                                if ( pthread_create( &AudioThread, NULL, OpenAL_PlayMP3 , NULL) ) {
                                        printf("error creating thread.");
                                        abort();
                                }/* End Creation Thread*/
                                return Ptr;
                        #else
                                /* WIN32 : MP3 is not implemented yet */
                                return NULL;
                        #endif /* WIN32 */
                #else
                        printf("\n HAVE_LIBOPENAL, HAVE_LIBSDL, and HAVE_LIBSMPEG:  are not defined");
                        return NULL;
                #endif
                }/* End MP3 Thread*/

                if( (sp = strstr(Ptr->fname,".ogg")  ) != NULL || (sp = strstr(Ptr->fname,".Ogg")  ) != NULL){
                #if defined(HAVE_LIBOGG)
                        #ifndef WIN32
                                if ( pthread_create( &AudioThread, NULL, /*PlayOggVorbis*/ OpenAL_PlayOgg , NULL) ) {
                                        printf("error creating thread.");
                                        abort();
                                }/* End Creation Thread*/
                                return Ptr;
                        #else
                                hThread = CreateThread(NULL,0,PlayOggVorbisWIN32,NULL,0,&dwThreadId);
                                if (hThread == NULL)
                                        ExitProcess(1);
                                return Ptr;
                        #endif /* WIN32 */
                #else
                        printf("\n HAVE_LIBOGG: is not defined");
                        return NULL;
                #endif /* defined(HAVE_LIBOGG)  */
                }/* End Ogg Vorbis Thread */

                if( (sp = strstr(Ptr->fname,".wav")  ) != NULL || (sp = strstr(Ptr->fname,".WAV")  ) != NULL){
                #ifdef HAVE_LIBOPENAL
                        #ifndef WIN32
                                if ( pthread_create( &AudioThread, NULL, OpenAL_PlayWAV , NULL) ) {
                                        printf("error creating thread.");
                                        abort();
                                }/* End Creation Thread*/
                                return Ptr;
                        #else
                                /* WIN32 : WAV is not implemented yet, you can use WinPlayMedia() */
                                return NULL;
                        #endif /* WIN32 */
                #else
                        printf("\n HAVE_LIBOPENAL: is not defined");
                        return NULL;
                #endif
                }/* End WAV Thread */
        }
        else
        {
                printf("\n No enough memory : mallaoc is failed \n ");
                return NULL;
        }
        return NULL;
}
/*===========================================================*/
 void StopAudioThread(struct AudioFile * Ptr)
{
        if( Ptr != NULL){
                Ptr->doneflag=1;
                Ptr->doneflag=1;
                free(Ptr);
                #ifdef WIN32
                        CloseHandle(hThread);
                #endif
                        /*FilePtr=NULL;*/
        }
        /*exit(0);*/
}

#else
static char c;
#endif                  /* HAVE_LIBOPENAL && HAVE_LIBSDL && HAVE_LIBSMPEG */
