:title: Unicon: A Posix Interface for the Icon Programming Language
:author: Shamim Mohamed
:date: 1997-04-25
:abstract: This document describes a set of functions that implement access to
   low-level POSIX/Unix system facilities from Icon/Unicon.
:docclass: report

.. note::
   ©1997 Shamim Mohamed. This document may be reproduced and
   redistributed freely provided it is reproduced in its entirety.

Introduction
============

The Icon Programming Language[1] provides a
large set of platform-independent facilities for non-numerical
processing, graphics etc. Icon runs on everything from Unix machines to
Amigas and Macs. This strong point, its platform independence, is also a
weak point: it could not offer access to the underlying system and so
could not be used as a system administration and scripting language like
Perl[2]. This was a great disappointment to
the author, who has had to write many Perl scripts over the years. While
it is true that Perl substitutes for a congolmeration of ``sed``,
``awk`` and shell scripts, it does so with some of the worst language
features from them.

Icon, on the other hand, has always been a good clean language with lots
of support for high-level control and data structures. If we could add
the Unix system calls to the language, we would have the best of both
worlds: a sensible and powerful VHLL as a Unix scripting language. Icon
even has integrated support for X11 graphics!

This document describes a set of functions that implement access to the
low-level system facilities. It is based on Unix systems, and as such
cannot be expected to be fully portable. However it is expected that
these functions can be ported to any system that conforms more or less
to the POSIX standard (Unix systems, Windows-NT etc.)

The Unicon package comprises additional functions defined in *icont* and
*iconx*, and an include file *posix.icn* is provided that defines the
constants and the record types that are required. This file should be
included by programs desirous of using the Posix interface. It links in
the icode library *posix*.

All the common system calls (Section 2 of the Unix manuals) are
available under the same names. Some of these are already implemented in
standard Icon (*chdir*, *rename*). For system calls that return
``struct`` types, a record is created and returned; the components of
the record have names that are similar to the elements of the
``struct``.

Whenever possible, the type system of Icon is used to advantage. For
example instead of having separate functions ``stat`` and ``fstat``, the
function *stat* calls the appropriate system procedure based on the type
of the argument.

A new keyword *&errno* has been added to the language. If an error
occurs during the execution of any of these system functions, the
function will fail and *&errno* will be set. The string corresponding to
an error ID is returned by the function *sys_errstr*. The first few
errors (``EPERM`` to ``EPIPE``) seem to be common between systems, and
these are defined in the header file; *&errno* can be directly compared
against constants like *ENOENT* etc. In general, however, it is safer to
format the error with the *sys_errstr* function.

Document Conventions
--------------------

In this document, Unix system calls and commands are represented with
the manpage section number and set in a typewriter font, thus:
``select(2)``; whereas Icon names and functions are set in a sans serif
font: *select()*.

Signals
=======

Signals may be trapped or ignored with the *trap* function. The signal
argument is passed by name, and may be system dependent, e.g. Linux
systems don't have a *SIGLOST*. The signal handler defaults to the
default provided by the system -- for instance, *SIGHUP* is ignored by
default but *SIGFPE* will cause a core dump. See Fig. 1
for an example.

::

   global oldhandler
        ...             
        trap("SIGFPE", sig_ignore)
        oldhandler := signal("SIGSEGV", handler)
        ...
        trap("SIGSEGV", oldhandler)
   end

   procedure sig_ignore(s); end
   procedure handler(s)
        write("Got signal ", s)
        oldhandler(s)                  # propagate the signal
   end

Figure 1: Signal handling

Forking programs
================

Programs may be forked in the usual Unix manner of calling ``fork(2)``
and then ``exec*(2)``. The function *fork* behaves exactly as the Unix
version; *exec* subsumes all of the Unix ``exec*`` system calls. The
first argument is the filename of the program to execute, and the
remaining arguments are the values of ``argv`` that the program will
get, starting with ``argv[0]``.

::

   exec("/bin/echo", "echo", "Hello,", "world!")

Currently there is no way of passing the environment (``execve`` style).

Redirecting I/O Streams
-----------------------

Often, the child process's standard input and output need to switched to
different files. Icon provides an interface equivalent to ``dup2(2)``
called *fdup*. Fig. 2 shows pipes and *fdup* being used to
redirect a child process' input.

::

   L := pipe() | stop("Couldn't get pipe: ", sys_errstr(&errno))
   if fork() = 0 then {
        close(L[2])
        fdup(L[1], &input)
        exec(...)
   }
   close(L[1])
   write(L[2], ...)                     # write to child's stdin

Figure 2: A pipe from parent to child

The function *filepair* is similar to *pipe* except that the connection
is bidirectional.

Networking
==========

TCP
---

Icon provides a much simpler interface to BSD-style sockets. Instead of
the four different system calls that are required to start a TCP/IP
server on Unix systems, Icon provides only one--the *"na"* (network
accept) flags to *open*. The first argument to *open* is the network
address to connect to -- *host:port* for Internet domain connections,
and a filename for Unix domain sockets. If the address starts with *":"*
i.e. no host name, the socket is opened on the same machine. The
returned value from *open* is a file that can be used in *select* etc.
as well as normal reading and writing.

::

   procedure main()
        while f := open(":1888", "na") do
             if fork() = 0 then {
                  servicerequest(f)
                  exit()
             } else
                  close(f)
        (&errno = 0) | stop("Open failed: ", sys_errstr(&errno))
   end

Figure 3: An Internet TCP server

::

   procedure finger(n)
        static fserv
        initial fserv := getserv("finger") |
             stop("Couldn't get service: ", sys_errstr(&errno))

        n ? {
             name := n; host := ""
             name := tab(upto('@')) & ="@" & host := tab(0)
        }
        if *host > 0 then write("[", host, "]")
        
        f := open(host || ":" || fserv.port, "n") |
             stop("Couldn't open connection: ", sys_errstr(&errno))

        write(f, name) | stop("Couldn't write: ", sys_errstr(&errno))
        while line := read(f) do
             write(line)
   end

Figure 4: A procedure that implements ``finger(1)``

Fig. 3 shows Icon code that implements a simple Internet
domain TCP server that listens on port 1888. To connect to this server,
the *"n"* (network connect) flag is used. Fig. 4 shows a
function that connects to a \`finger' server.

UDP
---

UDP networking is similar to the TCP examples above, except that the
additional character *"u"* is passed to *open*. When a call to *writes*
is made, a message is sent to the address that was specified when the
socket was created. The *send* function can also be used to send a UDP
datagram; the difference between using *send* and *writes* is that the
latter keeps the socket open between calls, whereas the former doesn't.
Typically a server might use *send* because during its life it will be
sending many datagrams to different addresses, and it might reach the
system open file limit by using *open*.

To receive a UDP datagram, the *receive* function is used, which returns
a record with two fields: the *addr* field contains the address of the
sender in *"host:port"* form, and the *msg* field contains the message.
See Fig. 5 for an example of a UDP server program, and
Fig. 6 for a UDP client. (Note: since UDP is not
reliable, the *receive* in Fig. 6 is guarded with a
*select*, or it might hang forever if the reply is lost.)

::

        f := open(":1025", "nua")
        while r := receive(f) do {
             # Process the request in r.msg
             ...
             send(r.addr, reply)
        }

Figure 5: A UDP server

::

   procedure main(args)
      (*args = 1) | stop("Usage: rdate host")
      host := args[1]
      
      s := getserv("daytime", "udp")
      
      f := open(host||":"||s.port, "nu") |
         stop("Open failed: ", sys_errstr(&errno))

      writes(f, " ")

      if *select([f], 5000) = 0 then
         stop("Connection timed out.")

      r := receive(f)
      write("Time on ", host, " is ", r.msg)
   end

Figure 6: A UDP client using \`daytime'

The *select()* system call
==========================

The function *select()* implemented in Icon performs a subset of the
``select(2)`` system call. Only the \`read' ``fd_set`` is passed in; no
provision is made to wait for exceptions on files or to ensure that
writes don't block. (For non-blocking writes, use *fcntl*.) It is hoped
that this somewhat weaker version of ``select`` will still be usable in
the majority of the cases. (Appendix B shows an implementation of the
``script(1)`` command.)

Instead of modifying the sets of file descriptors in place, *select()*
returns a list of *file*\ s that have data to be read. If the timeout
expires instead, an empty list is returned. Fig. 7 shows
an example of the usage.

::

        while *(L := select([f1, f2, f3], timeout)) = 0 do handle_timeout()
        (&errno = 0) | stop("Select failed: ", sys_errstr(&errno))

        every f := !L do {
             # Dispatch reads pending on f
             ...
        }

Figure 7: Waiting for input on multiple files

Buffering: A Caveat
-------------------

Care must be taken that the buffering used by ``stdio`` does not
interfere with the files being used with *select*. Consider this code:

::

        while L := select([f, &window]) do
             if L[1] === f then
                  c := reads(f, 3)

If the string *"hello\ ``\``\ n"* is ready on f and only three
characters are read from it, ``stdio`` will read the whole line; on the
next call to *select* there is no more data available on the Unix file
descriptor so select will not return--even though the file *f* still has
input *"lo\ ``\``\ n"* ready to be read.

The function *sysread(f, i)* performs one ``read(2)`` call and returns
the string, bypassing any buffering that ``stdio`` may be doing. Since
the unprocessed input is still in the low-level buffers, *select* will
work correctly.

::

        while L := select([f, &window]) do
             if L[1] === f then
                  c := sysread(f, 3)

The first time *sysread* is called, it will return the string *"hel"*;
the subsequent call to *select* finds input still waiting on *f* so it
will return, resulting in a value of *"lo\ ``\``\ n"* being read. If the
size argument is omitted, *sysread* will read as muchas it can without
blocking. *Important:* Do not mix *sysread* with the usual
*read*/*reads*!

The ``script(1)`` example (Appendix B) shows the usage of *select* and
*sysread*.

Reading directories
===================

The *open* function can open directories in the manner of
``readdir(2)``. They can only be opened for reading, and every *read*
returns the name of one entry. Entries are not guaranteed to be in any
specific order. Fig. 8 shows an implementation of a simple for
of ``ls(1)``.

::

   procedure main(args)
        every name := !args do {
             f := open(name) | stop(sys_errstr(&errno), name)
             L := list()
             while line := read(f) do
                  push(L, line)
             every write(format(lstat(n := !sort(L)), n, name))
            }
   end
        
   procedure format(p, name, dir)
        s := sprintf("%7s %4s %s %3s %8s %8s %8s %s %s",
              p.ino, p.blocks, p.mode, p.nlink,
              p.uid, p.gid, p.size, p.mtime, name)
      
        if p.mode[1] == "l" then
             s ||:= " -> " || readlink(dir||"/"||name)

        return s
   end

Figure 8: A program that lists all the files in a directory

Regular Expressions
===================

The *regexp* library in the Icon Program Library may be used for regular
expression searching and search-and-replace operations.

::

   link regexp
        ...
        result := ""
        s ? {
             while j := ReFind(re) do {
                  result ||:= tab(j) || replacement
                  tab(ReMatch(re))
             }
             result ||:= tab(0)
        }

Figure 9: Regular expression search-and-replace

Since the Icon program has access to the operation at a finer grain,
more complex operations (rather than only search-and-replace) are
possible.

Information from System Files
=============================

There are four functions that read information from system files:
*getpw* to read the password file, *getgr* for the group file, *gethost*
for hostnames and *getserv* for network services. Called with an
argument (usually a string) they perform a lookup in the system file.
When called with no arguments, these functions step through the files
one entry at a time.

The functions *setpwent*, *setgrent*, *sethostent*, *setservent* do the
same things as their Unix counterparts, i.e. they reset the file
position used by the *get\** routines to the beginning of the file.

They return records whose members are similar to the ``struct``\ s
returned by the system functions like ``getpwuid(2)``,
``gethostbyname(2)`` etc.

DBM databases
=============

DBM databases may be opened by the *open* function. The only permissible
values for the second argument are *"d"* and *"dr"*, for opening the
database read/write and read-only respectively.

Values are inserted into the database with *insert(d, k, v)* and are
read from it with *fetch(d, k)*.

Status
======

Unicon is now in alpha release. Patches to apply to the Icon 9.3 Unix
distribution are available at:

ftp://ftp.crl.com/users/sp/spm/unicon-patches.tar.gz

The Icon source distribution is at:

ftp://ftp.cs.arizona.edu/icon/packages/unix/unix.tar.gz

Linux (kernel 2.0 ELF, libgdbm 2.0.0, libX11 6.0, libdl 1.7.14, libm
5.0.0 and libc 5.2.18) binaries are also available at

| ftp://ftp.crl.com/users/sp/spm/unicon-linux.tar.gz
| ftp://ftp.crl.com/users/sp/spm/icon-9.3-2.i386.rpm
| ftp://ftp.crl.com/users/sp/spm/icon-ipl-9.3-2.i386.rpm

Unicon has been ported to these platforms:

================ ===============
Linux 2.0        gcc 2.7.2, ELF
Solaris 2.4      SunPro cc \*
Solaris 2.5      SunPro cc
SunOS 4.1.3      bundled cc \*\*
HPUX 9.03        bundled cc \*\*
HPUX 10.20 (PA2) ANSI cc \*\*
================ ===============

(\*) On Solaris 2.4, after a network server [a program that has
performed an \`open(..., "na")'] has exited, the OS won't allow another
server to listen on the same port until after a timeout of several
minutes.

(\*\*) On SunOS4 and HPUX, bind() always returns EADDRNOTAVAIL - and I
don't know why. If anyone can help with this, I'd appreciate it!

Acknowledgements
================

My thanks to Clint Jeffery for the long discussions on the right Unix
interface, and for inciting me to do commit this act of implementation.
Thanks also to Ralph Griswold and the Icon Project for creating and
maintaining a fine language.

And of course thanks to Richard Stallman, Linus Torvalds and a cast of
millions!

References
----------

**1**
   Ralph Griswold and Madge Griswold. *The Icon Programming Language*.
   Peer-To-Peer Communications, San Jose, California, 3d edition, 1997.
**2**
   Larry Wall and Randall Schwartz. *Programming Perl*. O'Reilly and
   Associates, Sebastopol, California, 1991.

Appendix A: Reference Manual
============================

Additions to pre-existing functions
-----------------------------------

Some additions have been made to the arguments and functionality of
these Icon functions:

**open(s1, s2) : f -- Open a file**
   | 
   | The additional options to *open* are:

   ======= ===============================
   *"na"*  listen on a TCP network socket
   *"n"*   connect to a TCP network socket
   *"nau"* listen on a UDP network socket
   *"nu"*  connect to a UDP network socket
   *"d"*   open a DBM database
   ======= ===============================

   When opening a network socket: the first argument *s1* is the name of
   the socket to connect to: if of the form *"s:i"*, it is an Internet
   domain socket on host *s* and port *i*; otherwise, it's the name of a
   Unix domain socket. If the host name is null, it represents the
   current host.

   For a UDP socket, \`connect' means that any writes to that file will
   send a datagram to that address, so that the address doesn't have to
   specified each time. Also, *read* or *reads* cannot be performed on a
   UDP socket; use *receive*. UDP sockets must be in the INET domain,
   i.e. the address must have a colon.

   For a DBM database, only one modifier character may be used: if *s1*
   is *"dr"* it indicates that the database should be opened in
   read-only mode.

**Event(W, i) : a -- return next window event**
   The second argument *i* is a timeout value in milliseconds. If the
   timeout expires before an event is available, then *Event()* fails.
   The default for *i* signifies that *Event()* should wait for the next
   window event.

New functions
-------------

If an error occurs during the execution of these functions, the function
will fail and *&errno* will be set. The string corresponding to an error
ID is returned by the function *sys_errstr*.

**chmod(f, mode) -- Change file mode**
   | 
   | Sets the mode of a file *f* to *mode*. The *mode* can be an integer
     mode or a string representing the change to be performed. The
     string is of the form

   *[ugoa]*[+-=][rwxRWXstugo]\**

   The first group describes the set of mode bits to be changed: *u* is
   the owner set, *g* is the group and *o* is the group \`other.' The
   character *a* represents all the fields. The operator (*+-=*)
   describes the operation to be performed: *+* adds a permission, *-*
   removes a permission, and *=* sets a permission. The permissions
   themselves are:

   === ============================================
   *r* read
   *w* write
   *x* execute
   *R* read if any other set already has *r*
   *W* write if any other set already has *w*
   *X* execute if any other set already has *x*
   *s* setuid (if the first part contains *u*
   \   and/or setgid if the first part contains *g*
   *t* sticky if the first part has *o*
   *u* the *u* bits on the same file
   *g* the *g* bits on the same file
   *o* the *o* bits on the same file
   === ============================================

   If the first group is missing, then it is treated as *a* *except*
   that any bits in the user's ``umask`` will not be modified in the
   mode.

**chown(f, u, g) -- Change file owner**
   Set the owner of a file *f* to owner *u* and group *g*. The user and
   group arguments can be numeric ID's or names.

**chroot(f) -- Change root**
   Change the root of the filesystem to *f*.

**ctime(t) : s -- Format a time value into local time**
   Converts an integer time - seconds since the epoch, Jan 1, 1970
   00:00:00 - into a string in the local timezone.

**crypt(s1, s2) : s -- Encrypt a password**
   Encrypt the password *s1* with the salt s2. (The first two characters
   of the returned string will be the salt.)

**exec(f, arg0, arg1, arg2, ...) -- Replace the executing Icon program with another.**
   The current program is replaced by another program *f*. The remaining
   arguments are passed to the program. Consult the ``exec(2)`` manpages
   for more details. *Warning:* *f* must point to an executable program,
   not to a shell script or Icon program. If you want to run those, the
   first argument to *exec* should be ``/bin/sh``, or ``iconx``, etc.

**fetch(d, k) : s -- Fetch a value from a dbm database**
   Fetch the value corresponding to key *k* from the dbm database *d*.

**fcntl(file, cmd, arg) -- Miscellaneous operations on opened files**
   | 
   | Perform a number of miscellaneous operations on the open file. See
     the ``fcntl(2)`` manpage for more details. Directories and dbm
     files cannot be arguments to *fcntl*.

   The following characters are the possible values for *cmd*:

   === ==========================================
   *f* Get flags (F_SETFL)
   *F* Set flags (F_GETFL)
   *x* Get close-on-exec flags (F_GETFD)
   *X* Set close-on-exec flag (F_SETFD)
   *l* Get file lock (F_GETLK)
   *L* Set file lock (F_SETLK)
   *W* Set file lock and wait (F_SETLKW)
   *o* Get file owner or process group (F_GETOWN)
   *O* Set file owner or process group (F_SETOWN)
   === ==========================================

   In the case of *L*, the *arg* value should be a string that describes
   the lock. A record will be returned by F_GETLK:

   *record posix_lock(value, pid)*

   The lock string consists of three parts separated by commas: the type
   of lock (*r*, *w* or *u*), the starting position and the length. The
   starting position can be an offset from the beginning of the file
   (e.g. *23*), end of the file (e.g. *-50*) or from the current
   position in the file (e.g. *+200*). A *length* of 0 means lock till
   EOF.

   The file flags set by F_SETFL and accessed by F_GETFL are represented
   by these characters:

   === =======
   *d* FNDELAY
   *s* FASYNC
   *a* FAPPEND
   === =======

**fdup(src, dest) -- Copy a file descriptor**
   This function provides a functionality similar to the ``dup2(2)``
   system call. It only needs to be used when you are concerned about
   the actual Unix file descriptor used, such as just before calling
   *exec*. The *dest* file is closed; *src* is made to have its Unix
   file descriptor; and the second file is replaced by the first.

**filepair() : L -- Create a pair of connected files**
   This is analogous to ``socketpair(2)`` - it returns a list of two
   files, such that writes on one will be available on the other. The
   connection is bi-directional, unlike *pipe*. The two files are
   indistinguishable. *Caution:* Typically, the pair is created just
   before a *fork*; after it, one process should close *L[1]* and the
   other should close *L[2]* or you will not get proper end-of-file
   notification.

**flock(file, op) -- Apply or remove a lock on a file**
   | 
   | An advisory lock is applied to the file. Consult the ``flock(2)``
     manpage for more details.

   The following characters can be used to make up the operation string:

   === ========================
   *s* shared lock
   *x* exclusive lock
   *b* don't block when locking
   *u* unlock
   === ========================

   Locks cannot be applied to directories or dbm files.

**fork() : pid -- Create a copy of the process.**
   This function creates a new process that is identical to the current
   process in all respects except in the return value. The parent gets a
   return value that is the PID of the child, and the child gets 0.

**getegid() : gid -- get group identity**
   Get the effective gid of the current process.

**geteuid() : uid -- get user identity**
   Get the effective uid of the current process.

**getgid() : gid -- get group identity**
   Get the real gid of the current process.

**getgr(g) : r -- Get a group file entry**
   | 
   | Returns a record that contains group file information. If *g* is
     null, each successive call to *getgr* returns the next entry.
     *setgrent* resets the sequence to the beginning. *g* can be a
     numeric gid or a group name.

   Return type: *record posix_group(name, passwd, gid, members)*

**gethost(h) : r -- Get a host entry**
   | 
   | Returns a record that contains host information. If *h* is null,
     each successive call to *gethost* returns the next entry.
     *sethostent* resets the sequence to the beginning. The aliases and
     addresses are comma separated lists of aliases and addresses (in
     a.b.c.d format) respectively.

   Return type: *record posix_hostent(name, aliases, addresses)*

**getpgrp() -- Get the process group**
   Returns the process group of the current process.

**getpid() : pid -- get process identity**
   Get the pid of the current process.

**getppid() : pid -- get parent's identity**
   Get the pid of the parent process.

**getpw(u) : r -- Get a password file entry**
   | 
   | Returns a record that contains password file information. If *u* is
     null, each successive call to *getpw* returns the next entry and
     *setpwent* resets the sequence to the beginning. *u* can be a
     numeric uid or a user name.

   Return type: *record posix_password(name, passwd, uid, gid, age,
   comment, gecos, dir, shell)*

**getserv(s1, s2) : r -- Get a serv entry**
   | 
   | Returns a record that contains serv information for the service
     *s1* using protocol *s2*. If *s1* is null, each successive call to
     getservent returns the next entry. *setservent* resets the sequence
     to the beginning.

   Return type: *record posix_servent(name, aliases, port, proto)*

   If *s2* is defaulted, it will return the first matching entry.

**gettimeofday() : r -- Return the time of day.**
   | 
   | Returns the current time in seconds and microseconds since the
     epoch, Jan 1, 1970 00:00:00. The *sec* value may be converted to a
     date string with *ctime* or *gtime*.

   Return value: *record posix_timeval(sec, usec)*

**getuid() : uid -- get user identity**
   Get the real uid of the current process.

**gtime(t) : s -- Format a time value into UTC**
   Converts an integer time - seconds since the epoch, Jan 1, 1970
   00:00:00 - into a string in UTC.

**ioctl() -- Unimplemented**
   | 
   | Since ``ioctl(2)`` relies so heavily on opaque pointers to structs,
     it is hard to implement in Icon; accordingly its implementation has
     been deferred till we can figure out what the right use model
     should be.

   Calls to *ioctl* are inherently not portable. Most ioctl functions
   can be done with *system*, running programs like ``stty(1)`` or
   ``mt(1)``.

**lstat(f) : r -- Get information about a symlink**
   Returns a *record* with information about the link *f*. (See the
   entry for *stat* for more details.) Return value: *record
   posix_stat(dev, ino, mode, nlink, uid, gid, rdev, size, atime, mtime,
   ctime, blksize, blocks)*

**link(src, dest) -- Make a link**
   Make a (hard) link *dest* that points to *src*.

**mkdir(path, mode) -- Create a new directory**
   Create a new directory named *path* with a mode of *mode*. The mode
   can be numeric or a string of the form accepted by *chmod()*.

**pipe() : L -- Create a pipe.**
   Create a pipe and return a list of two *file* objects. The first is
   for reading, the second is for writing.

**readlink(l) : s -- Read a link**
   Returns the value of a symbolic link.

**receive(f) : r -- Receive a UDP datagram.**
   This function reads a datagram addressed to the port associated with
   *f*, waiting if necessary. The returned value is a record of type
   *posix_message(addr, msg)*, containing the address of the sender and
   the contents of the message respectively.

**rmdir(d) -- Remove a directory**
   Removes an empty directory.

**select(files, timeout) : L -- Select among files**
   | 
   | Wait for a input to become available on a number of files. If
     *timeout* is specified, it is an upper bound on the time elapsed
     before *select* returns. A timeout of 0 may be specified in which
     case select will return immediately with a list of files on which
     input is currently pending.

   ========= ========= ======================================
   Defaults: *files*   Wait for timeout to expire and return.
   \         *timeout* Wait forever.
   ========= ========= ======================================

   Directories and dbm files cannot be arguments to *select*.

**send(s1, s2) -- Send a UDP datagram.**
   This function sends a datagram to the address *s1* with the contents
   *s2*.

**setgrent() -- Resets the group file**
   This function resets and rewinds the pointer to the group file used
   by *getgr* when called with no arguments.

**sethostent(stayopen) -- Resets the host file**
   This function resets and rewinds the pointer to the host file used by
   *gethost*. The argument defines whether the file should be kept open
   between calls to *gethost*; the default is to keep it open.

**setpgrp() -- Set the process group**
   Sets the process group. This is the equivalent of ``setpgrp(0, 0)``
   on BSD systems.

**setpwent() -- Resets the password file**
   This function resets and rewinds the pointer to the password file
   used by *getpw* when called with no arguments.

**setgid(g) -- Set the gid**
   Set the gid of the current process to *g*. Consult the SysV
   ``setgid(2)`` manpage.

**setuid(u) -- Set the uid**
   Set the uid of the current process to *u*.Consult the SysV
   ``setuid(2)`` manpage.

**setservent(stayopen) -- Resets the network services file**
   This function resets and rewinds the pointer to the srvices file used
   by *getserv*. The argument defines whether the file should be kept
   open between calls to *getserv*; the default is to keep it open.

**stat(f) : r -- Get information about a file**
   | 
   | Returns a *record* with information about the file *f* which may be
     a path or a *file* object. The times are integers that may be
     formatted with the *ctime* and *mtime* functions.

   Return value: *record posix_stat(dev, ino, mode, nlink, uid, gid,
   rdev, size, atime, mtime, ctime, blksize, blocks)*

   The *mode* is a string similar to the output of ``ls(1)``. For
   example, *"-rwxrwsr-x"* represents a plain file with a mode of 2775
   (octal).

**symlink(src, dest) -- Make a symbolic link**
   Make a symbolic link *dest* that points to *src*.

**sys_errstr(&errno) : s -- Format an error id**
   This function returns the string corresponding to the error code. If
   called with an invalid code (negative, or greater than the number of
   error messages) this function fails.

**trap(s, proc) : proc -- Trap or ignore a signal**
   | 
   | Set up a signal handler for the signal *s* (the name of the
     signal). The old handler (if any) is returned. If *proc* is
     *&null*, the signal is reset to its default value.

   **Caveat:** This is not supported with the compiler!

**truncate(f, len) -- Truncate a file**
   Truncate the file *f* (which may be a path to the file, or a *file*
   object that points to the file) to be of length *len*.

**umask(u) : u -- Set the file creation mask**
   Set the umask of the process to *u*. The old value of the umask is
   returned.

**sysread(f, i) : s -- Low-level read function**
   | 
   | This function performs a low-level unbuffered read operation of up
     to i characters. If i is omitted, *sysread* will read all the data
     that it can without blocking.

   Warning: sysread cannot be mixed with read/reads.

**utime(f, atime, mtime) -- Set file modification/access times.**
   Set the access time for file *f* to *atime* and the modification time
   to *mtime*. The *ctime* is set to the current time.

**wait(pid, options) : status -- Wait for process to terminate or stop**
   | 
   | The return value is a string that represents the pid and the exit
     status as defined in this table:

   ======================== ================================
   Unix equivalent          example of returned string
   ``WIFSTOPPED(status)``   *"1234 stopped:SIGTSTP"*
   ``WIFSIGNALLED(status)`` *"1234 terminated:SIGHUP"*
   ``WIFEXITED(status)``    *"1234 exit:1"*
   ``WIFCORE(status)``      *"1234 terminated:SIGSEGV:core"*
   ======================== ================================

   Currently the ``rusage`` facility is unimplemented.

   ========= ===== =====================
   Defaults: *pid* Wait for all children
   ========= ===== =====================

Appendix B: An example
======================

Here is an example implementation of the BSD ``script(1)`` command:

::

   # script: capture a script of a shell session (as in BSD)
   # Usage: script [-a] [filename}
   # filename defaults to "typescript"

   $include "posix.icn"

   procedure main(L)

      if L[1] == "-a" then {
         flags := "a"; pop(L)
      } else
         flags := "w"

      # Find a pty to use
      every c1 := !"pqrs" do
         every c2 := !(&digits || "abcdef") do
            if pty := open("/dev/pty" || c1 || c2, "rw") then {
               # Aha!
               capture(fname := L[1] | "typescript", pty, c1 || c2, flags)
               stop("Script is done, file ", image(fname))
            }
      
      stop("Couldn't find a pty!")
   end

   procedure capture(scriptfile, pty, name, flags)

      f := open(scriptfile, flags) | stop("Couldn't open ", image(scriptfile))
      tty := open("/dev/tty" || name, "rw") | stop("Couldn't open tty!")
    
      if (child := fork()) = 0 then {
         # Child: redirect i/o to the pty
         fdup(tty, &input)
         fdup(tty, &output)
         fdup(tty, &errout)
         shell := getenv("SHELL") | "/bin/sh"
         # Beautify shell's name
         shell ? {
            while tab(upto('/')) do move(1)
            sh := tab(0)
         }
         exec(shell, sh, "-i")
         stop("exec error: ", sys_errstr(&errno))
      }

      # Parent
      close(tty)
      system("stty raw -echo")

      # Handle input
      while L := select([pty, &input]) do
         if L[1] === &input then
            writes(pty, sysread()) | break
         else if L[1] === pty then {
            writes(f, inp := sysread(pty)) | break
            writes(inp)
         }

      (&errno = 0) | write(&errout, "Unexpected error: ", sys_errstr(&errno))
      system("stty cooked echo")
      close(f)
   end

About this document ...
=======================

| © 1997 Shamim Mohamed

Shamim Mohamed