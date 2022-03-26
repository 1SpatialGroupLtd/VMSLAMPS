	SUBROUTINE USRPZS(SIZE,USERXYZ,USRFLG,RETCOD)
C
CDEC$	IDENT	'16MY91'
C
C       Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C       Author Clarke Brunt			CCB	15-May-1991
C
C Description
C
C	LITES2 cartographic editor user command routines
C	Volume calculation routine
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
	REAL		USERXYZ(3,SIZE)	! coords
	LOGICAL*1	USRFLG(SIZE)	! flags (visibility only)
	INTEGER*4	RETCOD		! return code
					! = 0 abort, dont call 
					!     completion routine
					! = 1 for write more coords, if
					!     there are any, or else
					!     call USRRET
					! = 4 for abort, call completion
					!     routine
C
C	All these arguments are writable.
C
	INCLUDE 'USRFEAT.CMN/LIST'		! common blocks
	INCLUDE 'USRKEEP.CMN/LIST'
C
C workspace
	INTEGER		I
C
	SIZE = MIN(SIZE,NPTS-OPTS)
	DO 10 I=1,SIZE
	   USERXYZ(1,I) = COORD(1,OPTS+I)
	   USERXYZ(2,I) = COORD(2,OPTS+I)
	   USERXYZ(3,I) = COORD(3,OPTS+I)
	   USRFLG(I)    = FLG(OPTS+I)
10	CONTINUE
	OPTS = OPTS+SIZE
C
	RETCOD = 1	! output more coords, or goto USRRET
C
	RETURN
	END
