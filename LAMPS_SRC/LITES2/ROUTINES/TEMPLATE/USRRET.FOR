	SUBROUTINE USRRET(CNDFLG,RTSTRL,RTSTR,RETCOD)
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
	LOGICAL		CNDFLG		! LITES2 conditional flag
	INTEGER*4	RTSTRL		!  input: maximum size of RTSTR
					! output: size of RTSTR
	CHARACTER*(*)	RTSTR		! LITES2 command line, to be 
					! executed before any other
					! command
	INTEGER*4	RETCOD		! return code
					! = 0 for abort
					! = 1 for CNDFLG to be set
					!     and command to be executed
					! = 2 for call processing routine
					!     again
					! = 3 for call USRDEF, then call
					!     USRRET again
					! = 4 for call USRANO, then call
					!     USRRET again
					! = 5 for call USRDRW, then call
					!     USRRET again
C
C in this version, don't do anything
C
	RETCOD=0
C
	RETURN
	END
