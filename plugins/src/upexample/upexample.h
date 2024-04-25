/***
 *      Subject    : Unicon Plugin Example
 *      Author     : Jafar Al-Gharaibeh
 *      Date       : Feb 3, 2017
 ***
 *
 *      Description: This is an example demonstrating the format of
 *                   a Unicon plugin.
 *                   Example functions borrowed from IPL
 ***
 *
 *      This file is in the public domain.
 *
 ***
 */

#include "../icall.h"

/*
 * data types reference:
 *   i : integer
 *   r : real
 *   n : number
 *   s : string
 *   l : list
 *   t : table
 *   x : any
 * ...

 * return signatures
 *   function{0} return 0 result, i.e fail
 *   function{1} return 1 result
 *   function{0, 1} return 1 result or fail

 *   param signature
 *   name@type              => param name and type, and it is required
 *   name@type:default      => param name and type with a default value
 *                             presence of default means the param is optional
 */

/**********************************************************/
/*                      Plugin API                        */
/**********************************************************/

/*
 *  @function{1} bitcount(value@i)
 *  @return : i
 *
 *  count bits in an integer
 *
 *  returns the number of bits that are set in the integer i.
 *  It works only for "normal" integers, not large integers.
 *
 */
int bitcount(UARGS);


/*
 *  s := pack(value, flags, width)
 *  x := unpack(string, flags)
 *
 *  Flag characters are as follows:
 *
 *    l -- little-endian [default]
 *    b -- big-endian
 *    n -- host platform's native packing order
 *
 *    i -- integer [default]
 *    u -- unsigned integer
 *    r -- real (host platform's native float or double format)
 *
 * The default width is 4.
 *
 * Integer values must fit in a standard Icon integer (not large integer).
 * Consequently, a word-sized value cannot have the high bit set if unsigned.
 * Floating values can only be converted to/from a string width matching
 * sizeof(float) or sizeof(double).
 *
 * Size/type combinations that can't be handled produce errors.
 * Valid combinations produce failure if the value overflows.
 *
 * Some of this code assumes a twos-complement architecture with 8-bit bytes.
 *
 *
 *  @function{0, 1} pack(value@n, flags@s:null, width@i:4)
 *  @return : n
 *
 *  pack integer into bytes
 */
 int pack(UARGS);

/*
 *  function{0, 1} unpack(value@n, flags@s:null)
 *  @return : n
 *
 *  unpack integer from bytes
 */
int unpack(UARGS);
