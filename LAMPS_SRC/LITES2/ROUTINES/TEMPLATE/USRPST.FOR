	SUBROUTINE USRPST(SIZE,USERXY,USRFLG,RETCOD)
C
C       Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C       Author Ron Russell			RWR	25-Nov-1988
C
C Description
C
C	LITES2 cartographic editor user command routines .
C	Dummy user routine
C
        IMPLICIT NONE
C
C Arguments
C
	INTEGER*4	SIZE		! input:  maximum number of
					!         coords to pass back
					! output: actual number of
					!         coords passed back
					! with this call
	REAL		USERXY(2,SIZE)	! coords
	LOGICAL*1	USRFLG(SIZE)	! flags (visibility only)
	INTEGER*4	RETCOD		! return code
					! = 0 abort, dont call completion
					!     routine
					! = 1 for write more coords, if
					!     there are any, or else
					!     call USRRET
					! = 4 for abort, call completion
					!     routine
C
C	All these arguments are writable.
C
C	This is a dummy routine that does nothing
C
	RETCOD=0
C
	RETURN
	END
