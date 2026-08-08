Unicon: Frequently Asked Questions
==================================

This FAQ has been prepared by Clint Jeffery with input from Brian Rogoff
and Chris Harris. Last updated September 11, 2012. Thanks to
Jovana Milutinovich the `FAQ is available in Serbian
<http://science.webhostinggeeks.com/unicon-cesto-postavljana-pitanja>`__.


1. What is Unicon?
------------------

Unicon is a "modern dialect" descending     from the Icon programming
language.  Unicon incorporates numerous new     features and extensions
to make the Icon language more suitable for a     broad range of real-
world applications.

2. What does the name "Unicon" mean?
------------------------------------

Version 1 of Unicon referred to a set of UNIX extensions for Icon
written     by Shamim Mohamed.  More recently the name has been
broadened to refer to     a unified extended dialect of Icon.  The POSIX
system interface     has been ported to Windows, and the language also
bundles OOP,     ODBC database support, and other extensions.     It
also means: the *un*Icon.

3. Why aren't you calling it Icon Version 10?
---------------------------------------------

The University of Arizona distributes Icon, and they are neither
responsible for, nor endorse Unicon.  Do not ask them questions
about it.  The current version of Icon is 9.5.  The Icon Project     is
welcome to incorporate features from Unicon if they wish.

4. Is this a hostile takeover attempt?
--------------------------------------

No.  Icon Project at University of Arizona is unaffected by Unicon.  We
will cooperate with them on Icon-related matters. We did not want to
invent a new language at all, but are marketing Unicon as a new language
at the insistence of the Icon Project.

5.  What is Unicon, *really*?
-----------------------------

Unicon is a superset of Icon with "looser slots and a higher payback",
to use Las Vegas terminology.  It adds objects, networking and file
systems access, concurrency, execution monitoring and visualization, and
an ODBC database interface that operates on local files or across a
network with SQL database servers.  It is portable to (minimally) Linux,
MS Windows, Mac OS X, IRIX and Solaris environments.

6. What is the motivation for Unicon?
-------------------------------------

We wish to develop, improve, and promote Icon-style goal-directed very
high level languages.  One way to do this is to do a new implementation
of an existing language; Icon translators into C code and Java code are
examples of this approach.  Another way to do this is to design a new
language that is not constrained by the syntax or semantics of an
existing language; the `Godiva programming language `__ is (to some
extent) an example this approach. Unicon pursues a third path: that of
evolving an existing language to support new capabilities in a manner
that is as compatible and consistent with the original design philosophy
as possible.

7. What's with the ludicrous slogan "more Icon than Icon"?
----------------------------------------------------------

It is a parody of the Tyrell Corporation's slogan from the movie *Blade
Runner*.  As one example, Icon provides support in its run-time system
for type conversions and defaulting of parameters that comprises some of
the basic character of the language.  Yet at the source-level, writing
procedures that coerce their parameters is clumsy.  We have extended to
the source language some constructs discovered in the implementation;
this is (part of) how Icon was carved out of Snobol4's legacy.  Beyond
this minor detail, you can view the slogan as a homage to "feature
bloat", or conclude that the slogan fits the added high level
capabilities provided by Unicon.

8. Who is responsible for Unicon?
---------------------------------

Unicon was originally the creation of Clinton Jeffery and Shamim
Mohamed. Federico Balbi has contributed an ODBC interface. Robert
Parlett contributed the implementation of packages, along with
substantive programming tools and class libraries that are distributed
as part of Unicon. Other contributors are welcome.  Jafar Al Gharaibeh
has contributed concurrency and extensive improvements to the 3D
graphics facilities. Unicon has a `Citizens page `__ that shows many
other contributions.

9. Where is the Unicon language definition?
-------------------------------------------

Unicon is described in an open document book by Clinton Jeffery, Shamim
Mohamed, Jafar Al Gharaibeh, Robert Parlett, and Ray Pereda, titled
"Programming with Unicon". A PDF format draft copy of this book is
available on the unicon.org web site.  Hard copies are available. A
technical report (UTR #8) summarizes the language.

10. Why aren't Unicon's basic types classes?
--------------------------------------------

Types that Unicon inherits from Icon will retain compatibility with
Icon. They may eventually gain class status, meaning they'll have
attributes and operations, and can be subclassed.

11. Why isn't data structure X a built-in?
------------------------------------------

The built-in types are widely-used, general-purpose information elements
and structures.  Every program pays for their presence in the runtime
system whether they are used or not.  New built-in types may
occasionally appear, but most data structures will be added as classes.

12. Why aren't there abstract classes in Unicon?
------------------------------------------------

There isn't a strong need for these in a dynamically typed language.
Robert Parlett has added syntax to support abstract methods; we may
at some point add syntax for declaring an abstract class.

13. Is there a convention for naming classes and methods?
---------------------------------------------------------

The Java/Smalltalk style of capitalizing the first letter of a class
name and using lower case for method names is endorsed, but not yet
mandated or universally adhered to in class libraries.

14. How compatible is Unicon with Icon?
---------------------------------------

Well, it is a superset in principle, but if you get technical you will
find incompatibilities.  The reserved words added in Unicon are no
longer legal variable names: words like "class" and "method".  This
breaks for example, a grand total of 1 of the 223 files in the Icon
Program Library procs/ directory, requiring its variable named "method"
to be changed to "Method" (or whatever). The Unicon translator generates
out Icon as an intermediate step; for regular Icon source the resulting
virtual machine code is very similar.

15. How compatible is Unicon with Idol?
---------------------------------------

Pretty compatible, and vastly simpler. The $ syntax is available but not
required in ordinary invocation.  The full yacc-based parser is more
correct than the Idol parser.  The file extension changed from .iol to
.icn.  No ugly idolcode.env/ subdirectory is created. Code from a .icn
file is stored in a single corresponding .u file.  An accompanying DBM
database stores class information on a per-directory bases for use in
inheritance resolution.  DBM databases along the IPATH are searched for
superclass information.

16. What do I have to do to build Windows Unicon?
-------------------------------------------------

At present the recommended compiler is MinGW32 version of the GNU C
compiler. A 64-bit Windows configuration has been produced but is not
very mature yet. MS Visual C++ has been used for production releases in
the past and the sources might be updated to work with that compiler,
with modest effort. Other C compilers will require nontrivial effort to
develop new configuration files under the config/win32 directory,
comparable to (and possibly starting from) config/win32/gcc or
config/win32/msvc.

After you unpack the source files, you have to add the Unicon bin
directory to your path, or the ``make`` or ``nmake`` command will not
build all the way successfully. This author's experience is that the
Windows build process is at present unfortunately not for the faint of
heart.

17. How do I build noweb with Windows (Un)Icon?
-----------------------------------------------

(provided by Chris Harris)

-  Get the noweb distribution and extract all of the Icon files in the
	icon/ directory.

-  Build each one using "nticont "

-  Copy all of the .exe files built in step #2 into your noweb/bin/
directory.

-  Delete old DOS Icon noweb .exe's if you are putting in new Windows .exe's

18. How can I use an assert() expression in my programs?
--------------------------------------------------------

assert(expr) is normally written as expr | stop("expr failed...").
Unicon does not provide a built-in macro or control structure for
assert.     If your system supports m4 you can use it to provide an
assert() macro,     as in the following example provided by Kostas
Oikonomou:

.. code-block:: text

m4 -D assert='($$1) | stop("Assertion failure on line ", &line, "!")'

This filter might work on .m4 files to produce .icn files, or might be
used in conjunction with noweb, as in Kostas' example makefile rule
below.     Note that this example assumes GNU m4, which can process your
code     without accidentally firing off built-in m4 macros if you
supply the     --prefix-builtins flag:

.. code-block:: text

%.icn : %.nw            notangle $ $@

19. My SQL/ODBC open() mode "q" is failing.  Why?
-------------------------------------------------

Well, first, it should be mode "o", not mode "q"; this is a change not
yet reflected in the Unicon book public PDF file. Next, ODBC open() will
fail if Unicon binaries are built without ODBC facilities.  Third, the
ODBC Data Source Name and related configuration must be correct on your
platform (e.g. in the Control Panel for ODBC), lastly you must have
setup a valid username and password.

20. Why haven't Icon and Unicon become more popular?
----------------------------------------------------

Boy, what a piece of flame-bait!  It is simply speculation or sour
grapes, but some people might reasonably speculate that Icon and Unicon
would be a lot more popular if they were invented at AT&T, Microsoft, or
IBM.  Icon and Unicon might be a lot more popular if they did something
other languages really can't easily do (niche) rather than simply doing
things more elegantly.  Icon and Unicon's inventors have never invested
heavily in marketing their wares, viewing them as a by-product of
research rather than a product to be pushed. Similarly, Icon's inventor
could easily claim victory by noting the success of languages influenced
by Icon (e.g. generators or Icon-style strings present in other
languages like Python), rather than claiming defeat by deploring the
failure of the mainstream to take advantage of goal-directed evaluation
or the best collection of data types found in any language.  Clearly,
adopters of this language family love these features with sometimes
extreme levels of passion, but they are apparently often missed by the
casual observer.
