/*********************** stdint-example.h **********************/
/**** Use this file if your system does not have a stdint.h. ***/
/***************** See RFC 6234 for details. *******************/
#ifndef STDINT_H
#define STDINT_H

typedef unsigned long long uint64_t;    /* unsigned 64-bit integer */
typedef unsigned int       uint32_t;    /* unsigned 32-bit integer */
typedef unsigned char      uint8_t;     /* unsigned 8-bit integer */
                                        /* (i.e., unsigned char) */
typedef int int_least32_t;              /* integer of >= 32 bits */
typedef short int_least16_t;            /* integer of >= 16 bits */

#endif /* STDINT_H */
