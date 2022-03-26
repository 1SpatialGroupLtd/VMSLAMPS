	SUBROUTINE USRERR(FATAL,ERRCOD)
C
C       Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C       Author Ron Russell			RWR	13-Jan-1989
C
C Description
C
C	LITES2 cartographic editor user command routines .
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
C Error numbers
C
	INCLUDE		'USRERR.PAR'
C
C in this version, write a message
C
	PRINT *,' '
	IF (FATAL) THEN
   10	   FORMAT(' Fatal error ',I3,' has occurred')
	   PRINT 10,ERRCOD
	ELSE
   20	   FORMAT(' Non-fatal error ',I3,' has occurred')
	   PRINT 20,ERRCOD
	ENDIF
	PRINT *,' '
C
C
	RETURN
	END
