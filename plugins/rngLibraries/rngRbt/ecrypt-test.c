/* ecrypt-test.c */
/*--------------------------------------------------------------------------------
 *
 * This file is released under the terms of the GNU LIBRARY GENERAL PUBLIC LICENSE
 * (LGPL) version 2. The licence may be found in the root directory of the Unicon
 * source directory in the file COPYING.
 *
 *--------------------------------------------------------------------------------
 */
/* 
 * API conformance test and test vector generation (DRAFT)
 *
 * Based on the NESSIE test suite (http://www.cryptonessie.org/)
 */

/* ------------------------------------------------------------------------- */

#define ECRYPT_API ecrypt-sync.h

#define QUOTE(str) QUOTE_HELPER(str)
#define QUOTE_HELPER(str) # str

#include "ecrypt-portable.h"
//#include "ecrypt-config.h" 
#include QUOTE(ECRYPT_API)

#if defined(ECRYPT_SSYN) || defined(ECRYPT_SSYN_AE)
#error self-synchronising stream ciphers are not supported yet
#endif

#if defined(ECRYPT_SYNC_AE) || defined(ECRYPT_SSYN_AE)
#define ECRYPT_AE
#endif

#include <stdio.h>
#include <string.h>

#define MAXKEYSIZEB ((ECRYPT_KEYSIZE(ECRYPT_MAXKEYSIZE) + 7) / 8)
#define MAXIVSIZEB ((ECRYPT_IVSIZE(ECRYPT_MAXIVSIZE) + 7) / 8)
#define MAXMACSIZEB ((ECRYPT_MACSIZE(ECRYPT_MAXMACSIZE) + 7) / 8)

/* ------------------------------------------------------------------------- */

int compare_blocks(const u8 *m1, const u8 *m2, int len_bits)
{
  int i;
  const int lenb = (len_bits + 7) >> 3;
  const int mask0 = (1 << (((len_bits - 1) & 7) + 1)) - 1;

  if ((m1[0] & mask0) != (m2[0] & mask0))
    return 1;

  for (i = 1; i < lenb; i++)
    if (m1[i] != m2[i])
      return 1;
  
  return 0;
}

void print_data(FILE *fd, const char *str, const u8 *val, int len)
{
  int i;

  static const char hex[] = "0123456789ABCDEF";

  fprintf(fd, "%28s = ", str);

  for (i = 0; i < len; i++)
    {
      if (i > 0 && (i & 0xF) == 0 && (len > 24))
        fprintf(fd, "\n%28s   ", "");

      putc(hex[(val[i] >> 4) & 0xF], fd);
      putc(hex[(val[i]     ) & 0xF], fd);
    }

  fprintf(fd, "\n");
}

void print_chunk(FILE *fd, const char *str, const u8 *val, int start, int len)
{
  char indexed[80];

  sprintf(indexed, "%s[%d..%d]", str, start, start + len - 1);
  print_data(fd, indexed, val + start, len);
}

void xor_digest(const u8 *stream, int size, u8 *out, int outsize)
{
  int i;
  memset(out, 0, outsize);
  for (i = 0; i < size; i++)
    out[i % outsize] ^= stream[i];
}

/* ------------------------------------------------------------------------- */

#define TEST_STREAM_SIZEB 0x200
#define TEST_STREAM_SIZEB_SET4 0x20000
#define TEST_CHUNK 64

#ifdef ECRYPT_AE

#define CTX ECRYPT_AE_ctx
#define IVSETUP ECRYPT_AE_ivsetup
#define ENCRYPT_BYTES ECRYPT_AE_encrypt_bytes
#define DECRYPT_BYTES ECRYPT_AE_decrypt_bytes
#define AUTHENTICATE_BYTES ECRYPT_AE_authenticate_bytes
#define ENCRYPT_BLOCKS ECRYPT_AE_encrypt_blocks
#define DECRYPT_BLOCKS ECRYPT_AE_decrypt_blocks
#define KEYSETUP ECRYPT_AE_keysetup
#define ENCRYPT_PACKET ECRYPT_AE_encrypt_packet
#define DECRYPT_PACKET ECRYPT_AE_decrypt_packet
#define FINALIZE ECRYPT_AE_finalize

#else

#define CTX ECRYPT_ctx
#define IVSETUP ECRYPT_ivsetup
#define ENCRYPT_BYTES ECRYPT_encrypt_bytes
#define DECRYPT_BYTES ECRYPT_decrypt_bytes
#define ENCRYPT_BLOCKS ECRYPT_encrypt_blocks
#define DECRYPT_BLOCKS ECRYPT_decrypt_blocks

#define KEYSETUP(ctx, key, keysize, ivsize, macsize)    \
  ECRYPT_keysetup(ctx, key, keysize, ivsize)

#define ENCRYPT_PACKET(                                                 \
                       ctx, iv, aad, aadlen, plaintext, ciphertext, msglen, mac) \
  ECRYPT_encrypt_packet(ctx, iv, plaintext, ciphertext, msglen)

#define DECRYPT_PACKET(                                                 \
                       ctx, iv, aad, aadlen, ciphertext, plaintext, msglen, mac) \
  ECRYPT_decrypt_packet(ctx, iv, ciphertext, plaintext, msglen)

#define FINALIZE(ctx, checkmac)

#endif

typedef struct
{
  int keysize;
  int ivsize;
  int msglen;

  CTX ctx;

  u8 key[MAXKEYSIZEB];
  u8 iv[MAXIVSIZEB];

  u8 plaintext[TEST_STREAM_SIZEB_SET4];
  u8 ciphertext[TEST_STREAM_SIZEB_SET4];
  u8 checktext[TEST_STREAM_SIZEB_SET4];

#ifdef ECRYPT_AE
  int macsize;
  int aadlen;

  u8 aad[TEST_CHUNK];
  u8 mac[MAXMACSIZEB];
  u8 checkmac[MAXMACSIZEB];
#endif

  u8 xored[TEST_CHUNK];

  FILE *fd;

} test_struct;

int errors = 0;

void encrypt_and_check(test_struct* t, void (*print)(test_struct*, int))
{
  const int blocks = t->msglen / ECRYPT_BLOCKLENGTH;
  const int tail = blocks * ECRYPT_BLOCKLENGTH;
  const int bytes = t->msglen % ECRYPT_BLOCKLENGTH;

  memset(t->ciphertext, 0, sizeof(t->ciphertext));
#ifdef ECRYPT_AE
  memset(t->mac, 0, sizeof(t->mac));
#endif

  KEYSETUP(&t->ctx, t->key, t->keysize, t->ivsize, t->macsize);
  ENCRYPT_PACKET(&t->ctx, t->iv, 
                 t->aad, t->aadlen, t->plaintext, t->ciphertext, t->msglen, t->mac);

  print(t, 0);

#ifdef ECRYPT_AE
  memset(t->checkmac, 0, sizeof(t->checkmac));
#endif
  memset(t->checktext, 0, sizeof(t->checktext));

  KEYSETUP(&t->ctx, t->key, t->keysize, t->ivsize, t->macsize);
  DECRYPT_PACKET(&t->ctx, t->iv, 
                 t->aad, t->aadlen, t->ciphertext, t->checktext, t->msglen, t->checkmac);

  if (compare_blocks(t->plaintext, t->checktext, t->msglen * 8) != 0)
    {
      ++errors;
      fprintf(t->fd, 
              "*** ERROR: encrypt_packet <-> decrypt_packet:\n"
              "*** decrypted text differs from plaintext:\n");
      print(t, 1);
    }
#ifdef ECRYPT_AE
  else if (compare_blocks(t->mac, t->checkmac, t->macsize) != 0)
    {
      ++errors;
      fprintf(t->fd, 
              "*** ERROR: encrypt_packet <-> decrypt_packet:\n"
              "*** decryption MAC differs from encryption MAC:\n");
      print_data(t->fd, "MAC", t->checkmac, (t->macsize + 7) / 8);
    }

  memset(t->checkmac, 0, sizeof(t->checkmac));
#endif
  memset(t->checktext, 0, sizeof(t->checktext));

  IVSETUP(&t->ctx, t->iv);

#ifdef ECRYPT_SUPPORTS_AAD
  AUTHENTICATE_BYTES(&t->ctx, t->aad, t->aadlen);
#endif

  ENCRYPT_BYTES(&t->ctx, t->plaintext, t->checktext, t->msglen);
  FINALIZE(&t->ctx, t->checkmac);

  if (compare_blocks(t->ciphertext, t->checktext, t->msglen * 8) != 0)
    {
      ++errors;
      fprintf(t->fd, 
              "*** ERROR: encrypt_packet <-> encrypt_bytes:\n"
              "*** encrypt_bytes generates different ciphertext:\n");
      print(t, 2);
    }
#ifdef ECRYPT_AE
  else if (compare_blocks(t->mac, t->checkmac, t->macsize) != 0)
    {
      ++errors;
      fprintf(t->fd, 
              "*** ERROR: encrypt_packet <-> encrypt_bytes:\n"
              "*** encrypt_bytes generates different MAC:\n");
      print_data(t->fd, "MAC", t->checkmac, (t->macsize + 7) / 8);
    }

  memset(t->checkmac, 0, sizeof(t->checkmac));
#endif
  memset(t->checktext, 0, sizeof(t->checktext));

  IVSETUP(&t->ctx, t->iv);

#ifdef ECRYPT_SUPPORTS_AAD
  AUTHENTICATE_BYTES(&t->ctx, t->aad, t->aadlen);
#endif

  DECRYPT_BYTES(&t->ctx, t->ciphertext, t->checktext, t->msglen);
  FINALIZE(&t->ctx, t->checkmac);

  if (compare_blocks(t->plaintext, t->checktext, t->msglen * 8) != 0)
    {
      ++errors;
      fprintf(t->fd, 
              "*** ERROR: encrypt_packet <-> decrypt_bytes:\n"
              "*** decrypt_bytes generates different plaintext:\n");
      print(t, 2);
    }
#ifdef ECRYPT_AE
  else if (compare_blocks(t->mac, t->checkmac, t->macsize) != 0)
    {
      ++errors;
      fprintf(t->fd, 
              "*** ERROR: encrypt_packet <-> decrypt_bytes:\n"
              "*** decrypt_bytes generates different MAC:\n");
      print_data(t->fd, "MAC", t->checkmac, (t->macsize + 7) / 8);
    }

  memset(t->checkmac, 0, sizeof(t->checkmac));
#endif
  memset(t->checktext, 0, sizeof(t->checktext));

  IVSETUP(&t->ctx, t->iv);

#ifdef ECRYPT_SUPPORTS_AAD
  AUTHENTICATE_BYTES(&t->ctx, t->aad, t->aadlen);
#endif

  ENCRYPT_BLOCKS(&t->ctx, t->plaintext, t->checktext, blocks);
  ENCRYPT_BYTES(&t->ctx, t->plaintext + tail, t->checktext + tail, bytes);
  FINALIZE(&t->ctx, t->checkmac);

  if (compare_blocks(t->ciphertext, t->checktext, t->msglen * 8) != 0)
    {
      ++errors;
      fprintf(t->fd, 
              "*** ERROR: encrypt_packet <-> encrypt_blocks/bytes:\n"
              "*** encrypt_blocks/bytes generates different ciphertext:\n");
      print(t, 2);
    }
#ifdef ECRYPT_AE
  else if (compare_blocks(t->mac, t->checkmac, t->macsize) != 0)
    {
      ++errors;
      fprintf(t->fd, 
              "*** ERROR: encrypt_packet <-> encrypt_blocks/bytes:\n"
              "*** encrypt_blocks/bytes generates different MAC:\n");
      print_data(t->fd, "MAC", t->checkmac, (t->macsize + 7) / 8);
    }

  memset(t->checkmac, 0, sizeof(t->checkmac));
#endif
  memset(t->checktext, 0, sizeof(t->checktext));

  IVSETUP(&t->ctx, t->iv);

#ifdef ECRYPT_SUPPORTS_AAD
  AUTHENTICATE_BYTES(&t->ctx, t->aad, t->aadlen);
#endif

  DECRYPT_BLOCKS(&t->ctx, t->ciphertext, t->checktext, blocks);
  DECRYPT_BYTES(&t->ctx, t->ciphertext + tail, t->checktext + tail, bytes);
  FINALIZE(&t->ctx, t->checkmac);

  if (compare_blocks(t->plaintext, t->checktext, t->msglen * 8) != 0)
    {
      ++errors;
      fprintf(t->fd, 
              "*** ERROR: encrypt_packet <-> decrypt_blocks/bytes:\n"
              "*** decrypt_blocks/bytes generates different plaintext:\n");
      print(t, 2);
    }
#ifdef ECRYPT_AE
  else if (compare_blocks(t->mac, t->checkmac, t->macsize) != 0)
    {
      ++errors;
      fprintf(t->fd, 
              "*** ERROR: encrypt_packet <-> decrypt_blocks/bytes:\n"
              "*** decrypt_blocks/bytes generates different MAC:\n");
      print_data(t->fd, "MAC", t->checkmac, (t->macsize + 7) / 8);
    }
#endif

  fprintf(t->fd, "\n");
}

void print_stream(test_struct* t, int type)
{
  const int chunk = TEST_CHUNK;

  switch (type)
    {
    case 0:
      print_data(t->fd, "key", t->key, (t->keysize + 7) / 8); 
      print_data(t->fd, "IV", t->iv, (t->ivsize + 7) / 8);    
      
      print_chunk(t->fd, "stream", t->ciphertext, 0, chunk);
      print_chunk(t->fd, "stream", t->ciphertext, t->msglen/2-chunk, chunk);
      print_chunk(t->fd, "stream", t->ciphertext, t->msglen/2, chunk);         
      print_chunk(t->fd, "stream", t->ciphertext, t->msglen-chunk, chunk);
      
      xor_digest(t->ciphertext, t->msglen, t->xored, chunk);
      print_data(t->fd, "xor-digest", t->xored, chunk);  
      
#ifdef ECRYPT_AE
      print_data(t->fd, "MAC", t->mac, (t->macsize + 7) / 8); 
#endif
      break;
    case 1:
      print_chunk(t->fd, "decryption", t->checktext, 0, chunk);
      print_chunk(t->fd, "decryption", t->checktext, t->msglen/2-chunk, chunk);
      print_chunk(t->fd, "decryption", t->checktext, t->msglen/2, chunk);
      print_chunk(t->fd, "decryption", t->checktext, t->msglen-chunk, chunk);
      
      xor_digest(t->checktext, t->msglen, t->xored, chunk);                    
      print_data(t->fd, "xor-digest", t->xored, chunk);  

#ifdef ECRYPT_AE
      print_data(t->fd, "MAC", t->checkmac, (t->macsize + 7) / 8); 
#endif
      break;
    case 2:
      print_chunk(t->fd, "stream", t->checktext, 0, chunk);
      print_chunk(t->fd, "stream", t->checktext, t->msglen/2-chunk, chunk);
      print_chunk(t->fd, "stream", t->checktext, t->msglen/2, chunk);         
      print_chunk(t->fd, "stream", t->checktext, t->msglen-chunk, chunk);
      
      xor_digest(t->checktext, t->msglen, t->xored, chunk);                    
      print_data(t->fd, "xor-digest", t->xored, chunk); 
 
#ifdef ECRYPT_AE   
      print_data(t->fd, "MAC", t->checkmac, (t->macsize + 7) / 8); 
#endif
      break;
    }
}

void print_pair(test_struct* t, int type)
{
  switch (type)
    {
    case 0:
      print_data(t->fd, "key", t->key, (t->keysize + 7) / 8); 
      print_data(t->fd, "IV", t->iv, (t->ivsize + 7) / 8);

#ifdef ECRYPT_SUPPORTS_AAD
      if (t->aadlen)
        print_data(t->fd, "AAD", t->aad, t->aadlen);
#endif
      print_data(t->fd, "plaintext", t->plaintext, t->msglen);
      print_data(t->fd, "ciphertext", t->ciphertext, t->msglen); 
#ifdef ECRYPT_AE
      print_data(t->fd, "MAC", t->mac, (t->macsize + 7) / 8);      
#endif
      break;
    case 1:
      print_data(t->fd, "decryption", t->checktext, t->msglen); 
#ifdef ECRYPT_AE
      print_data(t->fd, "MAC", t->checkmac, (t->macsize + 7) / 8); 
#endif
      break;
    case 2:
      print_data(t->fd, "ciphertext", t->checktext, t->msglen);
#ifdef ECRYPT_AE 
      print_data(t->fd, "MAC", t->checkmac, (t->macsize + 7) / 8); 
#endif
      break;
    }
}

void test_vectors(FILE *fd, int keysize, int ivsize, int macsize)
{

#define STREAM_VECTOR(set, vector)                      \
  do {                                                  \
    fprintf(fd, "Set %d, vector#%3d:\n", set, vector);  \
    encrypt_and_check(&t, print_stream);                \
  } while (0)

#define MAC_VECTOR(set, vector)                         \
  do {                                                  \
    fprintf(fd, "Set %d, vector#%3d:\n", set, vector);  \
    encrypt_and_check(&t, print_pair);                  \
  } while (0)

#define AAD_VECTOR(set, vector)                         \
  do {                                                  \
    fprintf(fd, "Set %d, vector#%3d:\n", set, vector);  \
    encrypt_and_check(&t, print_pair);                  \
  } while (0)

  test_struct t;
  int i, v;

  fprintf(fd, 
          "****************************************"
          "****************************************\n");
  fprintf(fd, 
          "*                          ECRYPT Stream"
          " Cipher Project                        *\n");
  fprintf(fd, 
          "****************************************"
          "****************************************\n");
  fprintf(fd, "\n");
  fprintf(fd, "Primitive Name: %s\n", ECRYPT_NAME);
  fprintf(fd, "================%.*s\n", (int)strlen(ECRYPT_NAME),
          "==========================================");
  fprintf(fd, "Key size: %d bits\n", keysize);
  fprintf(fd, "IV size: %d bits\n", ivsize);
#ifdef ECRYPT_AE
  fprintf(fd, "MAC size: %d bits\n", macsize);
#endif
  fprintf(fd, "\n");
  fprintf(fd, "Preferred block length: %d bytes\n", ECRYPT_BLOCKLENGTH);
  fprintf(fd, "\n");

  memset(t.plaintext, 0, sizeof(t.plaintext));
  memset(t.ciphertext, 0, sizeof(t.ciphertext));

  /* check key stream */

  t.fd = fd;

  t.keysize = keysize;
  t.ivsize = ivsize;
#ifdef ECRYPT_AE
  t.macsize = macsize;
  t.aadlen = 0;
#endif
  t.msglen = TEST_STREAM_SIZEB;

  fprintf(t.fd, "Test vectors -- set 1\n");
  fprintf(t.fd, "=====================\n\n");
  fprintf(t.fd, "(stream is generated by encrypting %d zero bytes)\n\n", 
          t.msglen);

  memset(t.iv, 0, sizeof(t.iv));

  for (v = 0; v < t.keysize; v++)
    {
      memset(t.key, 0, sizeof(t.key));
      t.key[v >> 3] = 1 << (7 - (v & 7));
      
      STREAM_VECTOR(1, v);
    }

  fprintf(t.fd, "Test vectors -- set 2\n");
  fprintf(t.fd, "=====================\n\n");

  memset(t.iv, 0, sizeof(t.iv));

  for (v = 0; v < 256; v++)
    {
      memset(t.key, v, sizeof(t.key));

      STREAM_VECTOR(2, v);
    }

  fprintf(fd, "Test vectors -- set 3\n");
  fprintf(fd, "=====================\n\n");

  memset(t.iv, 0, sizeof(t.iv));

  for (v = 0; v < 256; v++)
    {
      for (i = 0; i < sizeof(t.key); i++)
        t.key[i] = (i + v) & 0xFF;

      STREAM_VECTOR(3, v);
    }

  t.msglen = TEST_STREAM_SIZEB_SET4;

  fprintf(t.fd, "Test vectors -- set 4\n");
  fprintf(t.fd, "=====================\n\n");

  for (v = 0; v < 4; v++)
    {
      for (i = 0; i< sizeof(t.key); i++)
        t.key[i] = (i * 0x53 + v * 5) & 0xFF;

      STREAM_VECTOR(4, v);
    }

  t.msglen = TEST_STREAM_SIZEB;

  fprintf(t.fd, "Test vectors -- set 5\n");
  fprintf(t.fd, "=====================\n\n");

  memset(t.key, 0, sizeof(t.key));

  for (v = 0; v < t.ivsize; v++)
    {
      memset(t.iv, 0, sizeof(t.iv));
      t.iv[v >> 3] = 1 << (7 - (v & 7));

      STREAM_VECTOR(5, v);
    }

  t.msglen = TEST_STREAM_SIZEB_SET4;

  fprintf(t.fd, "Test vectors -- set 6\n");
  fprintf(t.fd, "=====================\n\n");

  for (v = 0; v < 4; v++)
    {
      for (i = 0; i < sizeof(t.key); i++)
        t.key[i] = (i * 0x53 + v * 5) & 0xFF;

      for (i = 0; i < sizeof(t.iv); i++)
        t.iv[i] = (i * 0x67 + v * 9 + 13) & 0xFF;

      STREAM_VECTOR(6, v);
    }

  t.msglen = TEST_STREAM_SIZEB;

#if defined(ECRYPT_AE) || !defined(ECRYPT_GENERATES_KEYSTREAM)
  /* check MAC */

  fprintf(t.fd, "Test vectors -- set 7\n");
  fprintf(t.fd, "=====================\n\n");

  memset(t.key, 0, sizeof(t.key));
  memset(t.iv, 0, sizeof(t.iv));
  memset(t.plaintext, 0, sizeof(t.plaintext));

  for (i = 0; i < sizeof(t.key); i++)
    t.key[i] = (i * 0x11) & 0xFF;

  for (v = 0; v <= TEST_CHUNK; v++)
    {
      t.msglen = v;

      MAC_VECTOR(7, v);
    }

  t.msglen = TEST_CHUNK / 2;

  fprintf(t.fd, "Test vectors -- set 8\n");
  fprintf(t.fd, "=====================\n\n");

  memset(t.key, 0, sizeof(t.key));
  memset(t.iv, 0, sizeof(t.iv));

  for (v = 0; v < t.msglen * 8; v++)
    {
      memset(t.plaintext, 0, sizeof(t.plaintext));
      t.plaintext[v >> 3] = 1 << (7 - (v & 7));

      MAC_VECTOR(8, v);
    }

  fprintf(t.fd, "Test vectors -- set 9\n");
  fprintf(t.fd, "=====================\n\n");

  for (v = 0; v < 4; v++)
    {
      for (i = 0; i < sizeof(t.key); i++)
        t.key[i] = (i * 0x53 + v * 5) & 0xFF;

      for (i = 0; i < sizeof(t.iv); i++)
        t.iv[i] = (i * 0x67 + v * 9 + 13) & 0xFF;

      for (i = 0; i < t.msglen; i++)
        t.plaintext[i] = (i * 0x61 + v * 7 + 109) & 0xFF;

      MAC_VECTOR(9, v);
    }

#ifdef ECRYPT_SUPPORTS_AAD
  /* check AAD */

  t.msglen = TEST_CHUNK / 2;

  fprintf(t.fd, "Test vectors -- set 10\n");
  fprintf(t.fd, "======================\n\n");

  memset(t.key, 0, sizeof(t.key));
  memset(t.iv, 0, sizeof(t.iv));
  memset(t.plaintext, 0, sizeof(t.plaintext));
  memset(t.aad, 0, sizeof(t.aad));

  for (i = 0; i < sizeof(t.key); i++)
    t.key[i] = (i * 0x11) & 0xFF;

  for (v = 0; v <= TEST_CHUNK; v++)
    {
      t.aadlen = v;

      AAD_VECTOR(10, v);
    }

  t.aadlen = TEST_CHUNK / 2;

  fprintf(t.fd, "Test vectors -- set 11\n");
  fprintf(t.fd, "======================\n\n");

  memset(t.key, 0, sizeof(t.key));
  memset(t.iv, 0, sizeof(t.iv));
  memset(t.plaintext, 0, sizeof(t.plaintext));

  for (v = 0; v < t.aadlen * 8; v++)
    {
      memset(t.aad, 0, sizeof(t.aad));
      t.aad[v >> 3] = 1 << (7 - (v & 7));

      AAD_VECTOR(11, v);
    }

  fprintf(t.fd, "Test vectors -- set 12\n");
  fprintf(t.fd, "======================\n\n");

  for (v = 0; v < 4; v++)
    {
      for (i = 0; i < sizeof(t.key); i++)
        t.key[i] = (i * 0x53 + v * 5) & 0xFF;

      for (i = 0; i < sizeof(t.iv); i++)
        t.iv[i] = (i * 0x67 + v * 9 + 13) & 0xFF;

      for (i = 0; i < t.msglen; i++)
        t.plaintext[i] = (i * 0x61 + v * 7 + 109) & 0xFF;

      for (i = 0; i < t.aadlen; i++)
        t.aad[i] = (i * 0x25 + v * 13 + 11) & 0xFF;

      AAD_VECTOR(12, v);
    }
#endif
#endif

  fprintf(t.fd, "\n\nEnd of test vectors\n");
}

/* ------------------------------------------------------------------------- */

void test_if_conform_to_api(FILE *fd, int keysize, int ivsize, int macsize)
{
  CTX ctx[2];
  
  u8 key[2][MAXKEYSIZEB];
  u8 iv[2][MAXIVSIZEB];
  
  u8 plaintext[TEST_CHUNK + ECRYPT_BLOCKLENGTH];
  u8 ciphertext[3][TEST_CHUNK + ECRYPT_BLOCKLENGTH];
#ifdef ECRYPT_AE
  u8 mac[3][MAXMACSIZEB];
#endif
  
  int msglen = TEST_CHUNK;

  int i;

  for(i = 0; i < MAXKEYSIZEB; i++)
    {
      key[0][i] = 3 * i + 5;
      key[1][i] = 240 - 5 * i;
    }

  for(i = 0; i < MAXIVSIZEB; i++)
    {
      iv[0][i] = 9 * i + 25;
      iv[1][i] = 11 * i + 17;
    }

  memset(plaintext, 0, sizeof(plaintext));
  memset(ciphertext, 0, sizeof(ciphertext));

  KEYSETUP(&ctx[0], key[0], keysize, ivsize, macsize);

  IVSETUP(&ctx[0], iv[0]);
  ENCRYPT_BYTES(&ctx[0], plaintext, ciphertext[0], msglen);
  FINALIZE(&ctx[0], mac[0]);

  IVSETUP(&ctx[0], iv[0]);
  ENCRYPT_BYTES(&ctx[0], plaintext, ciphertext[1], msglen);
  FINALIZE(&ctx[0], mac[1]);

  if (compare_blocks(ciphertext[0], ciphertext[1], msglen * 8) != 0)
    {
      ++errors;
      fprintf(fd, 
              "*** ERROR: Code does not conform to ECRYPT API:\n"
              "*** Two calls to ivsetup produced different results:\n");

      print_data(fd, "K", key[0], (keysize + 7) / 8);
      print_data(fd, "IV", iv[0], (ivsize + 7) / 8);

      print_data(fd, "P", plaintext, msglen);
      print_data(fd, "C after 1st IV setup", ciphertext[0], msglen);
      print_data(fd, "C after 2nd IV setup", ciphertext[1], msglen);
      fprintf(fd, "\n");
      fflush(fd);
    }
#ifdef ECRYPT_AE
  else if (compare_blocks(mac[0], mac[1], macsize) != 0)
    {
      ++errors;
      fprintf(fd, 
              "*** ERROR: Code does not conform to ECRYPT API:\n"
              "*** Two calls to ivsetup produced different results:\n");

      print_data(fd, "K", key[0], (keysize + 7) / 8);
      print_data(fd, "IV", iv[0], (ivsize + 7) / 8);

      print_data(fd, "P", plaintext, msglen);
      print_data(fd, "MAC after 1st IV setup", mac[0], (macsize + 7) / 8);
      print_data(fd, "MAC after 2nd IV setup", mac[1], (macsize + 7) / 8);
      fprintf(fd, "\n");
      fflush(fd);
    }
#endif

  memset(ciphertext, 0, sizeof(ciphertext));

  KEYSETUP(&ctx[0], key[0], keysize, ivsize, macsize);
  IVSETUP(&ctx[0], iv[0]);
  ENCRYPT_BYTES(&ctx[0], plaintext, ciphertext[0], msglen);
  FINALIZE(&ctx[0], mac[0]);

  KEYSETUP(&ctx[1], key[1], keysize, ivsize, macsize);
  IVSETUP(&ctx[1], iv[1]);
  ENCRYPT_BYTES(&ctx[1], plaintext, ciphertext[1], msglen);
  FINALIZE(&ctx[1], mac[1]);

  IVSETUP(&ctx[0], iv[0]);

  IVSETUP(&ctx[1], iv[1]);

  ENCRYPT_BYTES(&ctx[0], plaintext, ciphertext[2], msglen);
  FINALIZE(&ctx[0], mac[2]);

  if (compare_blocks(ciphertext[0], ciphertext[2], msglen * 8) != 0)
    {
      ++errors;
      fprintf(fd, 
              "*** ERROR: Code does not conform to ECRYPT API:\n"
              "*** code produces inconsistent results when calls with different\n" 
              "*** contexts are interleaved:\n");

      if (compare_blocks(ciphertext[1], ciphertext[2], msglen * 8) == 0)
        fprintf(fd, 
                "*** (this is probably due to the use of static state variables)\n");

      print_data(fd, "K1", key[0], (keysize + 7) / 8);
      print_data(fd, "K2", key[1], (keysize + 7) / 8);
      print_data(fd, "IV1", iv[0], (ivsize + 7) / 8);
      print_data(fd, "IV2", iv[0], (ivsize + 7) / 8);

      print_data(fd, "P", plaintext, msglen);
      print_data(fd, "C by K1", ciphertext[0], msglen);
      print_data(fd, "C by K2", ciphertext[1], msglen);
      print_data(fd, "C by K1 after IV2 setup", ciphertext[2], msglen);
      fprintf(fd, "\n");
      fflush(fd);
    }
#ifdef ECRYPT_AE
  else if (compare_blocks(mac[0], mac[2], macsize) != 0)
    {
      ++errors;
      fprintf(fd, 
              "*** ERROR: Code does not conform to ECRYPT API:\n"
              "*** code produces inconsistent results when calls with different\n" 
              "*** contexts are interleaved:\n");

      if (compare_blocks(mac[1], mac[2], macsize) == 0)
        fprintf(fd, 
                "*** (this is probably due to the use of static state variables)\n");

      print_data(fd, "K1", key[0], (keysize + 7) / 8);
      print_data(fd, "K2", key[1], (keysize + 7) / 8);
      print_data(fd, "IV1", iv[0], (ivsize + 7) / 8);
      print_data(fd, "IV2", iv[0], (ivsize + 7) / 8);

      print_data(fd, "P", plaintext, msglen);
      print_data(fd, "MAC by K1", mac[0], (macsize + 7) / 8);
      print_data(fd, "MAC by K2", mac[1], (macsize + 7) / 8);
      print_data(fd, "MAC by K1 after IV2 setup", mac[2], (macsize + 7) / 8);
      fprintf(fd, "\n");
      fflush(fd);
    }
#endif

#define B ECRYPT_BLOCKLENGTH

  memset(ciphertext, 0, sizeof(ciphertext));

  KEYSETUP(&ctx[0], key[0], keysize, ivsize, macsize);
  IVSETUP(&ctx[0], iv[0]);
  ENCRYPT_BYTES(&ctx[0], plaintext + B, ciphertext[0] + B, msglen);
  FINALIZE(&ctx[0], mac[0]);

  KEYSETUP(&ctx[1], key[1], keysize, ivsize, macsize);
  IVSETUP(&ctx[1], iv[1]);
  ENCRYPT_BLOCKS(&ctx[1], plaintext, ciphertext[1], 1);
  ENCRYPT_BYTES(&ctx[1], plaintext + B, ciphertext[1] + B, msglen);
  FINALIZE(&ctx[1], mac[1]);

  IVSETUP(&ctx[0], iv[0]);

  IVSETUP(&ctx[1], iv[1]);
  ENCRYPT_BLOCKS(&ctx[1], plaintext, ciphertext[2], 1);

  ENCRYPT_BYTES(&ctx[0], plaintext + B, ciphertext[2] + B, msglen);
  FINALIZE(&ctx[0], mac[2]);

  if (compare_blocks(ciphertext[0] + B, ciphertext[2] + B, msglen * 8) != 0)
    {
      ++errors;
      fprintf(fd, 
              "*** ERROR: Code does not conform to ECRYPT API:\n"
              "*** code produces inconsistent results when calls with different\n" 
              "*** contexts are interleaved:\n");

      if (compare_blocks(ciphertext[1], ciphertext[2], (msglen + B) * 8) == 0)
        fprintf(fd, 
                "*** (this is probably due to the use of static state variables)\n");

      print_data(fd, "K1", key[0], (keysize + 7) / 8);
      print_data(fd, "K2", key[1], (keysize + 7) / 8);
      print_data(fd, "IV1", iv[0], (ivsize + 7) / 8);
      print_data(fd, "IV2", iv[1], (ivsize + 7) / 8);

      print_data(fd, "(last part of) P", plaintext + B, msglen);
      print_data(fd, "C by K1", ciphertext[0] + B, msglen);
      print_data(fd, "last part of C by K2", ciphertext[1] + B, msglen);
      print_data(fd, "C by K1 after calls K2", ciphertext[2] + B, msglen);
      fprintf(fd, "\n");
      fflush(fd);
    }
#ifdef ECRYPT_AE
  else if (compare_blocks(mac[0], mac[2], macsize) != 0)
    {
      ++errors;
      fprintf(fd, 
              "*** ERROR: Code does not conform to ECRYPT API:\n"
              "*** code produces inconsistent results when calls with different\n" 
              "*** contexts are interleaved:\n");

      if (compare_blocks(mac[1], mac[2], macsize) == 0)
        fprintf(fd, 
                "*** (this is probably due to the use of static state variables)\n");

      print_data(fd, "K1", key[0], (keysize + 7) / 8);
      print_data(fd, "K2", key[1], (keysize + 7) / 8);
      print_data(fd, "IV1", iv[0], (ivsize + 7) / 8);
      print_data(fd, "IV2", iv[1], (ivsize + 7) / 8);

      print_data(fd, "(last part of) P", plaintext, msglen);
      print_data(fd, "MAC by K1", mac[0], (macsize + 7) / 8);
      print_data(fd, "MAC by K2", mac[1], (macsize + 7) / 8);
      print_data(fd, "MAC by K1 after K2 calls", mac[2], (macsize + 7) / 8);
      fprintf(fd, "\n");
      fflush(fd);
    }
#endif
}

/* ------------------------------------------------------------------------- */

int main()
{
  int ikey;
  int iiv;

  ECRYPT_init();

  for(ikey=0; ikey<=ECRYPT_MAXKEYSIZE; ikey++)
    for(iiv=0; iiv<=ECRYPT_MAXIVSIZE; iiv++)
      {
        const int keysize = ECRYPT_KEYSIZE(ikey);
        const int ivsize = ECRYPT_IVSIZE(iiv);
#ifdef ECRYPT_AE
        const int macsize = ECRYPT_MACSIZE(0);
#else
        const int macsize = 0;
#endif
        if(keysize&(keysize-1)) continue; /* Only powers of 2 */
        if(ivsize&(ivsize-1)) continue; /* Only powers of 2 */

        test_if_conform_to_api(stderr, keysize, ivsize, macsize);
        test_vectors(stdout, keysize, ivsize, macsize);
      }

  fprintf(stderr, "There where %d errors.\n", errors);

  return 0;
}
