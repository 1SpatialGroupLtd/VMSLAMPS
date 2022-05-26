Fortran
=======

VMS LAMPS2 is written in a number of languages, Most of it is in 
.SRC files which (usually) should be translated by the ADCC
command to produce the DEC Fortran source code. It is in a style
that is probably more Fortran 66 than Fortran 77 (and definitely
not later). It also uses a number of the DEC Fortran extensions.

The researcher aware of modern Fortran should read up on the 
differences - https://fortranwiki.org/fortran/show/Modernizing+Old+Fortran
appears to cover most of it.

* PARAMETER statement without parenthesis (DEC Fortran extension)
* %VAL - to pass an argument by value rather than reference.
 (Not understood by f2c).
* %LOC - to get the address of the storage item. (Not understood by f2c).
* %REF - to force pass by reference. (Not understood by f2c).
* Use of $ in identifiers. (Hack f2c in initkey() to add the character to
string of alpha-characters (called s) )
* STRUCTURE, MAP, UNION, RECORD - VMS Fortran extension.
* tab characters taken to be 8 spaces. (Expect most system to accept
this).
* Hollerith data. (f2c OK with this)
* ENTRY statements. (f2c OK with this)
* Logical operations .AND. and .OR. on integers (bitwise); F77 supplies functions instead.
* .NOT. on an integer - presume this is a check for not equal to zero. (LITESS2/SRC/INIT.SRC suggests .NOT.<integer> indicates the integer is even!)
* TYPE (similar to print)
* ACCEPT 
* ENCODE/DECODE
* IMPLICIT (A-O),(T-Z) - rather than (A-O,T-Z)

Optional arguments
------------------
Parameters may be omitted. This is detected by some machine code in
LSLMAINT/LSLLIB/SRC/HAVE_I_AN_ARG.MAR which is exposed to Fortran as
a logical function which takes the index of the argument to check.

Literals
--------
* Numbers following a double quote (") are Octal
* Radix 50 encodings. 3RXXX encodes the XXX into a 16bit number (this is
probably from the PDP-11 era when saving bytes was important).
* Hex encoding as ZFF rather than Z'FF'

Indentation
-----------
* <Tab><Digit> at the start of a line is a continuation line. 
* <Tab> at the start of a line is probably interpreted as step to column 7

Alignment
---------
The earliest code will have been on 16bit PDP-11 machines. Correctly
aligned data was fastest, but misaligned data did not have a huge 
performance cost. See http://odl.sysworks.biz/disk$axpdocsep001/opsys/vmsos721/5841/5841pro_063.html#data_alignment. 
Alphas and more modern machines are more seneitive to unaligned access
(relative to their higher speeds), this varies between platforms. 

This may show up in EQUIVALENCE and COMMON statements where a variable
is being aliased to something with the wrong alignmnent.

Includes
--------

There are several format of file specification:
* ($NAME) - A compiler supplied file ?
* SYS:NAME - An operating system supplied file ?
* HERE:NAME - in the same directory as the file. (The file being compiled
or read?)
* CMN:NAME - in an adjacent CMN directory or the current directory or an
adjacent COMMON directory or one of a number of other directories.
* LSL$<PLACE>:NAME - in another directory,
* <PLACE>:NAME - in another directory
* [DIR.DIR]NAME - in another directory
* LSL$SOURCE_ROOT:[DIR.DIR]NAME - in another directory
* LSL$DISK:[DIR.DIR]NAME - in another directory

Not sure why LaserScan used so many ways to reference the files.