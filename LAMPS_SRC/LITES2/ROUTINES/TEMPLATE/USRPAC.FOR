	SUBROUTINE USRPAC(ACTYPE,ACIVAL,ACTXTL,ACTXT,RETCOD)
C
C       Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C       Author Ron Russell			RWR	13-Jan-1989
C
C Description
C
C	LITES2 cartographic editor user command routines.
C	Dummy routine
C
        IMPLICIT NONE
C
C Arguments
C
	INTEGER*4	ACTYPE		! type of AC
	INTEGER*4	ACIVAL		! AC value
					! note: to read a real AC value,
					! a copy of this will have to
					! be equivalenced to a real
	INTEGER*4	ACTXTL		! number of characters in ACTXT
	CHARACTER*(*)	ACTXT		! text (maximum of 255 chars)
	INTEGER*4	RETCOD		! return code
					! = 0 abort, no call completion
					!     routine
					! = 1 for write another AC if
					!     there are any, or else
					!     start writing coords
					! = 2 for start writing coords
					! = 4 for abort, call completion
					!     routine
C
C	All these arguments are writable
C
C in this version, don't do anything
C
	RETCOD=0
C
	RETURN
	END
