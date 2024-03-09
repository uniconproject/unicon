
#include "common.h"

#ifdef HAVE_LIBOGG

#ifdef WIN32  /* for MS Windows */

        WAVEFORMATEX waveformater;
        HWAVEOUT hwave;
        class BufferInfo
        {
        public:
                int nused;
                CRITICAL_SECTION criticalsection;
                HANDLE huponfree;
                BufferInfo()
                {
                        nused=0;
                        InitializeCriticalSection(&criticalsection);
                        huponfree=CreateEvent(NULL,FALSE,FALSE,NULL);
                }
                ~BufferInfo()
                {
                        DeleteCriticalSection(&criticalsection);
                        CloseHandle(huponfree);
                }
        };

        void CALLBACK PlayCallback(HWAVEOUT, UINT msg, DWORD param, DWORD, DWORD)
        {
                if (msg!=WOM_DONE)
                        return;
                // invariant: if a buffer is being freed, then nused>0.
                BufferInfo *bufferinfo = (BufferInfo*)(DWORD_PTR)param;
                EnterCriticalSection(&bufferinfo->criticalsection);
                bufferinfo->nused--;
                LeaveCriticalSection(&bufferinfo->criticalsection);
                SetEvent(bufferinfo->huponfree);
        }

        BufferInfo bufferinfo;

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

        extern "C" DWORD WINAPI PlayOggVorbisWIN32( void * params )
        {
                FILE *fd;
                OggVorbis_File oggplayfile;
                const int nbuffers = 5, buffersize = 4096;
                unsigned int numsamples, numbytes, currentbuffer = 0, totprogress=0;
                int current_section = 0;
                WAVEHDR headers[nbuffers];

                if( ( fd = fopen( FilePtr->fname , "rb" ) ) == NULL ){
                        perror("");
                        ExitProcess(1);}

                if( ov_open(fd,&oggplayfile,NULL,0) < 0 ){
                        perror("");
                        fprintf(stderr,"\nFor Some Reason ogg file is not opening\n");
                        fclose(fd);
                        ExitProcess(1);}

                if (!ov_seekable(&oggplayfile)){
                        ov_clear(&oggplayfile);
                        perror("");
                        ExitProcess(1);}

                vorbis_info *oggfileinfo=ov_info(&oggplayfile,-1);
                /* Ogg File Properties.
                char **ptr = ov_comment (&oggplayfile, -1)->user_comments;
                while (*ptr){
                        fprintf (stderr, "%s\n", *ptr);
                        ++ptr;}
                fprintf (stderr, "\nBitstream is %d channel, %ldHz\n", oggfileinfo->channels, oggfileinfo->rate);
                fprintf (stderr, "\nDecoded length: %ld samples\n",(long) ov_pcm_total (&oggplayfile, -1));
                fprintf (stderr, "Encoded by: %s\n\n", ov_comment(&oggplayfile, -1)->vendor);*/

                numsamples = (unsigned int)ov_pcm_total(&oggplayfile,0);
                numbytes = numsamples * oggfileinfo->channels * waveformater.wBitsPerSample > 1;

                if(audioDevice(oggfileinfo->channels, oggfileinfo->rate)){
                        fprintf(stderr,"\nError Setting up Audio Device\n");
                        ExitProcess(1);}
                for (int i=0; i < nbuffers; i++){
                        ZeroMemory(&headers[i],sizeof(WAVEHDR));
                        headers[i].lpData = (LPSTR)LocalAlloc(LMEM_FIXED, buffersize);
                        headers[i].dwBufferLength=buffersize;
                        waveOutPrepareHeader(hwave, &headers[i], sizeof(WAVEHDR));}
        while(1){
                for (bool okay=false; !okay; ){
                        EnterCriticalSection(&bufferinfo.criticalsection);
                        if (bufferinfo.nused<nbuffers){
                                bufferinfo.nused++;
                                okay=true;}
                        LeaveCriticalSection(&bufferinfo.criticalsection);
                        if (!okay)
                                WaitForSingleObject(bufferinfo.huponfree,INFINITE);
                }// end for

                WAVEHDR &header = headers[currentbuffer];

                for (header.dwBufferLength=0; header.dwBufferLength<buffersize; ){
                        long ret = 0;
                        if( ( ret = ov_read( &oggplayfile, header.lpData+header.dwBufferLength, buffersize - header.dwBufferLength, 0, 2, 1, &current_section ) ) <= 0 ){
                                break;
                        }
                        header.dwBufferLength += ret;
                        totprogress+=header.dwBufferLength;
                }// end for

                currentbuffer = (currentbuffer + 1)% nbuffers;
                waveOutWrite(hwave, &header, sizeof(WAVEHDR));

                if ( header.dwBufferLength==0 ){
                        break;
                }

                if(FilePtr->doneflag)
                        break;
        }// end while(1)

    for (bool okay=false; !okay; ){
                EnterCriticalSection(&bufferinfo.criticalsection);
                okay = (bufferinfo.nused==0);
                LeaveCriticalSection(&bufferinfo.criticalsection);
                if (!okay)
                        WaitForSingleObject( bufferinfo.huponfree, INFINITE );
        }
        waveOutReset(hwave);

        for (int i=0; i<nbuffers; i++){
                waveOutUnprepareHeader( hwave, &headers[i], sizeof(WAVEHDR) );
                LocalFree( headers[i].lpData );}

        waveOutClose(hwave);
        ov_clear(&oggplayfile);
        //fclose(fd); // Casing Error
        return 0;
        }
#endif /* HAVE_LIBOGG */
#endif /*  WIN32  */

