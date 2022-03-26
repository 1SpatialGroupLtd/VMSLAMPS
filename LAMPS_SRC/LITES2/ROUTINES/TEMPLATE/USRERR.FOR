	SUBROUTINE USRERR(FATAL,ERRCOD)
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
	LOGICAL		FATAL		! .TRUE. if user routine is
					!        about to be aborted
					! .FALSE. if only a warning
	INTEGER*4	ERRCOD		! error code
C
C in this version, don't do anything
C
C
	RETURN
	END
