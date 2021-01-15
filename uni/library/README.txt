This directory holds the base superclass files required for the UniconProjects
repositiory.

At present there are four required files:

errorsystem.icn     -   this is the topmost class file. The class defined in this
                        file provides basic error handling, debugging and class
                        information.

classobject.icn     -   there are two classes defined in this file. One is the
                        supserclass of the other and is the superclass of all
                        objects within the UniconProjects system. The other is
                        the superclass of all class objects. These class objects
                        are the creators of any objects of that class. These
                        class objetcs can be considered the Type definition and
                        the class objects themselves are the values of that Type.

runtimeerrors.icn   -   this contains the procedure that controls all available
                        runtimeerrors, including all Unicon system runtime errors
                        that the programmer may wich to create for a specific
                        library or application.

utilities.icn       -   this file will contain any utility procedures that are
                        needed by the various classes. It has one procedure
                        definition at this time that can be used by any method
                        or procedure in the UniconProjects system.

The standard classes and utilities within the uni directory of the Unicon system
are referenced as needed.

This specific hierarchy has been designed to enable the translation of a number of
javascript applications that I am interested in translating to Unicon.


