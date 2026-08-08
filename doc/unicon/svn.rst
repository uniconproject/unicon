Unicon Source Code SVN Repository
=================================

.. note::
   This page is **legacy**. Unicon development uses Git today. The SVN
   instructions below are retained for historical reference.

Public SVN gave everyone ongoing access to the latest (or near-latest)
files. If you plan to contribute any changes, or want to obtain others'
changes to the source code, SVN made that much easier than just sending
code via e-mail. No system is perfect, not even SourceForge. They have
changed their configuration several times, and the instructions on this
page may need updating.

Anonymous checkout
------------------

To grab an anonymous copy of Unicon sources from SVN, see the site docs
at www.sourceforge.net or try::

   svn checkout http://svn.code.sf.net/p/unicon/code/trunk/unicon

Authenticated checkout
----------------------

To grab a (non-anonymous) copy of Unicon sources from SVN, try the
following with your SourceForge ID::

   svn checkout svn+ssh://userid@svn.code.sf.net/p/unicon/code/trunk/unicon

Developer write access
----------------------

Unicon developers: code contributions are always welcome by e-mail, and
should be based on current sources. If you've got a track record with us
and want write access, register with SourceForge, then e-mail Jeffery
with your SourceForge user name and request to be a Unicon developer.
After you are added, ssh once into ``unicon.cvs.sourceforge.net`` (it
sets things up and exits). Then::

   svn add -m "comment" --username=sourceforgeuserid file(s)
   svn commit -m "comment" --username=sourceforgeuserid file(s)

Windows clients
---------------

On Windows, get an SVN client from https://subversion.apache.org/ (command
line, instructions as above) or TortoiseSVN.
