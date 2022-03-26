	SUBROUTINE USRDO(RETCOD)
C
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
	INTEGER*4	RETCOD		! return code
					! = 0 abort, dont call completion
					!     routine
					! = 4 for abort, call completion
					!     routine
					! = 5 to create a new feature
					!     (and keep old one if there
					!      was one)
					! = 6 to create a new feature
					!     and delete old one
C
C in this version, don't do anything
C
	RETCOD=0
C
	RETURN
	END
