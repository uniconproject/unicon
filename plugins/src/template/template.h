/***
    xunt*       Subject    : Unicon Plugin Template
 *      Author     : Jafar Al-Gharaibeh
 *      Date       : Feb 3, 2017
 ***
 *
 *      Description: This is a template a Unicon plugin.
 *
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
 *  @function{1} foo(value@i)
 *  @return : i
 *
 *  One line describtion: does this and that
 *
 *  elaborate describon does this and that
 *  and even more
 *  but can't do these
 *
 */
int foo(UARGS);
