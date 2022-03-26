	SUBROUTINE USRGZS(SIZE,USERXYZ,USRFLG,RETCOD)
C
CDEC$	IDENT	'17MY91'
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
	INTEGER*4	SIZE		! number of coords passed
					! with this call
	REAL*4		USERXYZ(3,SIZE)	! coords
	LOGICAL*1	USRFLG(SIZE)	! flags (visibility only)
	INTEGER*4	RETCOD		! return code
					! = 0 abort, don't call processing
					!     routine
					! = 1 for get more coords
					!     or call processing routine,
					!     if no more
					! = 4 for abort, but call
					!     processing routine
C
C	All these arguments, apart from RETCOD, should be considered
C	as read only
C
C	the following parameter is for testing if a Z coordinate value
C	is present for a particular point
C
C	NOTE: this must be tested against an integer, which has
C	been equivalenced onto the real value to be tested
C
	INCLUDE 'USRFEAT.CMN/LIST'		! common blocks
	INCLUDE 'USRKEEP.CMN/LIST'
C
	INTEGER*4	IABSENT
	PARAMETER	(IABSENT = '80000000'X)
C
C functions
	INTEGER		LIB$EXTV
C
C workspace
	INTEGER		I
C
	DO 100 I=1,SIZE
	   NPTS = NPTS+1
	   IF (LIB$EXTV(0,32,USERXYZ(3,NPTS)).EQ.IABSENT) GOTO 999
	   COORD(1,NPTS) = USERXYZ(1,I)
	   COORD(2,NPTS) = USERXYZ(2,I)
	   COORD(3,NPTS) = USERXYZ(3,I)
100	CONTINUE
C
	RETCOD = 1		! get more points (if there are any)
	GOTO 1000
C
999	CALL TTWSTR('Feature contains one or more unheighted points')
	ERROR = .TRUE.
	RETCOD = 4		! go to USRDO
C
1000	RETURN
	END
