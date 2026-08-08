:title: unicon — interpret or compile Unicon programs
:author: Unicon Project
:trnumber: 11
:date: 2014-07-28
:abstract: Manual page for unicon, icont, and iconc — tools that convert
   Unicon and Icon source programs into executable form.
:docclass: report

NAME
====

unicon - interpret or compile Unicon programs

SYNOPSIS
========

| unicon [ option ... ] file ... [ -x arg ... ]
| icont [ option ... ] file ... [ -x arg ... ]
| iconc [ option ... ] file ... [ -x arg ... ]

DESCRIPTION
===========

The programs unicon, icont and iconc convert Unicon and Icon source
programs into executable form. By default unicon, like icont, translates
quickly and provides interpretive (virtual machine) execution. Unicon
with the -C option uses iconc, which takes longer to compile but
produces programs that execute faster. icont and iconc for the most part
can be used interchangeably. Unicon is a superset that supports Icon
programs, while adding classes, packages, and various other features.

This manual page describes unicon, and the versions of icont and iconc
that come with unicon. This page is gratefully based on the Icon Project
manual page for icon. Where there there are differences in usage between
unicon, icont and iconc, these are noted.

**File Names:** Files whose names end in .icn are assumed to be Unicon
source files. The .icn suffix may be omitted; if it is not present, it
is supplied. The character - can be used to indicate an Unicon source
file given in standard input. Several source files can be given on the
same command line; if so, they are combined to produce a single program.

The name of the executable file is the base name of the first input
file, formed by deleting the suffix, if present. stdin is used for
source programs given in standard input.

**Processing:** As noted in the synopsis above, unicon, icont and iconc
accept options followed by file names, optionally followed by -x and
arguments. If -x is given, the program is executed automatically and any
following arguments are passed to it.

unicon: The processing performed by unicon consists of *class and
package preprocessing* followed by invocation of icont (or iconc, if -C
is given) to produce code and/or executable output.

icont: The processing performed by icont consists of two phases:
*translation* and *linking*. During translation, each Icon source file
is translated into an intermediate language called *ucode*. A ucode file
is produced for each source file, with a base name taken from the source
file and the suffix .u. During linking, one or more ucode files are
combined to produce a single *icode* file. The ucode files are deleted
after the icode file is created.

Processing by unicon or icont can be terminated after translation by the
-c option. In this case, the ucode files are not deleted. The names of
.u files from previous translations can be given on the unicon or icont
command line. These files files are included in the linking phase after
the translation of any source files. Ucode files that are explicitly
named are not deleted.

iconc: The processing performed by iconc consists of two phases: *code
generation* and *compilation and linking*. The code generation phase
produces C code, consisting of a .c and a .h file, with the base name of
the first source file. These files are then compiled and linked to
produce an executable binary file. The C files normally are deleted
after compilation and linking.

Processing by iconc can be terminated after code generation by the -c
option. In this case, the C files are not deleted.

OPTIONS
=======

The following options are recognized by unicon, icont, and iconc:

+---+----+---+------------------------------------------------------+
|   | -c |   | Stop after producing intermediate files and do not   |
|   |    |   | delete them (unicon and icont only).                 |
+---+----+---+------------------------------------------------------+

-e *file*

Redirect standard error output to *file*.

-f s

Enable full string invocation.

-o *name*

Name the output file *name*.

+---+----+---+------------------------------------------------------+
|   | -s |   | Suppress informative messages. Normally, both        |
|   |    |   | informative messages and error messages are sent to  |
|   |    |   | standard error output.                               |
+---+----+---+------------------------------------------------------+
|   | -t |   | Arrange for &trace to have an initial value of -1    |
|   |    |   | when the program is executed and for iconc enable    |
|   |    |   | debugging features.                                  |
+---+----+---+------------------------------------------------------+
|   | -u |   | Issue warning messages for undeclared identifiers in |
|   |    |   | the program.                                         |
+---+----+---+------------------------------------------------------+

-v *i*

Set verbosity level of informative messages to *i*

+---+------+---+----------------------------------------------------+
|   | *-E* |   | Direct the results of preprocessing to standard    |
|   |      |   | output and inhibit further processing.             |
+---+------+---+----------------------------------------------------+

The following options are recognized only by unicon:

== == =======================================================
\  -C  Have unicon generate code using iconc instead of icont.
== == =======================================================

-version

Print the version of Unicon and exit.

-features

Print the features compiled into this implementation Unicon and exit.

The following additional options are recognized only by unicon and
icont:

== == ==================================================
\  -B  Bundle a copy of the iconx VM into the executable. 
\  -G  Bundle a graphics-enabled VM (MS Windows)          
== == ==================================================

| The following additional options are recognized only by by unicon -C
  and iconc:
| -f *string*

Enable features as indicated by the letters in *string*:

+---+---+---+-------------------------------------------------------+
|   | a |   | all, equivalent to delns                              |
+---+---+---+-------------------------------------------------------+
|   | d |   | enable debugging features: display(), name(),         |
|   |   |   | variable(), error trace back, and the effect of -f n  |
|   |   |   | (see below)                                           |
+---+---+---+-------------------------------------------------------+
|   | e |   | enable error conversion                               |
+---+---+---+-------------------------------------------------------+
|   | l |   | enable large-integer arithmetic                       |
+---+---+---+-------------------------------------------------------+
|   | n |   | produce code that keeps track of line numbers and     |
|   |   |   | file names in the source code                         |
+---+---+---+-------------------------------------------------------+
|   | s |   | enable full string invocation                         |
+---+---+---+-------------------------------------------------------+

-n *string*

Disable specific optimizations. These are indicated by the letters in
*string*:

+---+---+---+-------------------------------------------------------+
|   | a |   | all, equivalent to cest                               |
+---+---+---+-------------------------------------------------------+
|   | c |   | control flow optimizations other than switch          |
|   |   |   | statement optimizations                               |
+---+---+---+-------------------------------------------------------+
|   | e |   | expand operations in-line when reasonable (keywords   |
|   |   |   | are always put in-line)                               |
+---+---+---+-------------------------------------------------------+
|   | s |   | optimize switch statements associated with operation  |
|   |   |   | invocations                                           |
+---+---+---+-------------------------------------------------------+
|   | t |   | type inference                                        |
+---+---+---+-------------------------------------------------------+

-p *arg*

Pass *arg* on to the C compiler used by iconc

-r *path*

Use the run-time system at *path*, which must end with a slash.

-CC *prg*

Have iconc use the C compiler given by *prg*

ENVIRONMENT VARIABLES
=====================

| When an Unicon program is executed, several environment variables are
  examined to determine certain execution parameters. Values in
  parentheses are the default values.
| BLKSIZE (1% of physical memory)

The initial size of the allocated block region, in bytes.

COEXPSIZE (2000)

The size, in words, of each co-expression block.

DBLIST

The location of data bases for iconc to search before the standard one.
The value of DBLIST should be a semicolon-separated string of the form
*p1;p2;... pn* where the *pi* name directories.

ICONCORE

If set, a core dump is produced for error termination.

ICONX

The location of iconx, the executor for icode files, is built into an
icode file when it is produced. This location can be overridden by
setting the environment variable ICONX. If ICONX is set, its value is
used in place of the location built into the icode file.

IPATH

The location of ucode files specified in link declarations for icont.
IPATH is a semicolon-separated list of directories. The current
directory is always searched first, regardless of the value of IPATH.

LPATH

The location of source files specified in preprocessor $include
directives and in link declarations for iconc. LPATH is otherwise
similar to IPATH.

MSTKSIZE (50000)

The size, in words, of the main interpreter stack for icont.

NOERRBUF

By default, &errout is buffered. If this variable is set, &errout is not
buffered.

QLSIZE (5000)

The size, in bytes, of the region used for pointers to strings during
garbage collection.

STRSIZE (1% of physical memory)

The initial size of the string space, in bytes.

TRACE

The initial value of &trace. If this variable has a value, it overrides
the translation-time -t option.

FILES
=====

| unicon Unicon translator
| icont Icon translator
| iconc Icon compiler
| iconx Icon executor

SEE ALSO
========

*Programming with Unicon*, Clinton Jeffery, Shamim Mohamed, Ray Pereda
and Robert Parlett, http://unicon.org, 2008.

*The Icon Programming Language*, Ralph E. Griswold and Madge T.
Griswold, Peer-to-Peer Communications, Inc., Third Edition, 1996.

*Version 9.3 of Icon*, Ralph E. Griswold, Clinton L. Jeffery, and Gregg
M. Townsend, IPD278, Department of Computer Science, The University of
Arizona, 1996.

*Version 9 of the Icon Compiler*, Ralph E. Griswold, IPD237, Department
of Computer Science, The University of Arizona, 1995.

LIMITATIONS AND BUGS
====================

The icode files for the interpreter do not stand alone; the Icon
run-time system (iconx) must be present.

Stack overflow is checked using a heuristic that is not always
effective.

| "unicon -C" and iconc are not yet ported to MS Windows. They run out
  of
| memory on large programs if limited swap or virtual memory address
  space is available, such as 32-bit platforms. A few features of
  Unicon, such as ODBC database access, are not yet supported under
  "unicon -C" and iconc.

