History

2007.10.15 Art Eschenlauer

The Generator, Vol. 2 No. 2 pp. 2-32 
  http://www.unicon.org/generator/v2n2.pdf
described a proof-of-concept "shell" for Unicon.  This shell facilitates composition of new solutions by loading and executing multiple tasks (pre-translated Unicon programs) within a single virtual machine.  The user supplies scripts that define the relationship among the programs, their input parameters, and initial task activations.

I recently added updated versions of the programs to the Sourceforge repository under unicon/uni/shell:
  Version 0.9 of shell.icn  (man page at http://tinyurl.com/yr4764)
  Version 0.9 of Stream.icn (man page at http://tinyurl.com/2fzkce)
  Version 0.2 of ush.icn    (man page at http://tinyurl.com/ys7mpu)
The makefiles assume this location and assume that unicon/bin is in the execution path.
The principal enhancement is that they support an environment variable, USHPATH, that the shell searches for tasks and scripts.
