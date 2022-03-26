	SUBROUTINE USRGAC(ACTYPE,ACIVAL,ACTXTL,ACTXT,RETCOD)
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
					! = 0 abort, don't call processing
					!     routine
					! = 1 for get more ACs if there
					!     are any, or start getting
					!     coords if reqd, or call
					!     USRDO if coords not reqd
					! = 2 stop getting ACs, start
					!     getting cooordinates
					! = 4 for call processing routine
					!     right away
C
C	All these arguments, apart from RETCOD, should be considered
C	as read only
C
C in this version, don't do anything
C
	RETCOD=0
C
	RETURN
	END
