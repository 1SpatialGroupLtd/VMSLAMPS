	SUBROUTINE USRGST(SIZE,USERXY,USRFLG,RETCOD)
C
C       Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C       Author Ron Russell			RWR	30-Nov-1988
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
					! with this call
	REAL		USERXY(2,SIZE)	! coords
	LOGICAL*1	USRFLG(SIZE)	! flags (visibility only)
	INTEGER*4	RETCOD		! return code
					! = 0 abort, don't call
					!     processing routine
					! = 1 for get more coords
					!     or call processing routine,
					!     if no more
					! = 4 for abort, but call
					!     processing routine
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
