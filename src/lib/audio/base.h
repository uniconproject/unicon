#ifndef BASE_H
#define BASE_H

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

#if HAVE_ALTYPES
#include <AL/altypes.h>
#include <AL/alexttypes.h>
#endif                                  /* HAVE_ALTYPES */
#include "config.h"

/*
 * function pointer for LOKI extensions
 */
extern ALfloat  (*talcGetAudioChannel)(ALuint channel);
extern void     (*talcSetAudioChannel)(ALuint channel, ALfloat volume);

extern void     (*talMute)(void);
extern void     (*talUnMute)(void);

extern void     (*talReverbScale)(ALuint sid, ALfloat param);
extern void     (*talReverbDelay)(ALuint sid, ALfloat param);
extern void     (*talBombOnError)(void);

extern void     (*talBufferi)(ALuint bid, ALenum param, ALint value);


extern void     (*talBufferWriteData)(ALuint bid, ALenum format, ALvoid *data, ALint size, ALint freq, ALenum iFormat);

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

#endif /* BASE_H */
